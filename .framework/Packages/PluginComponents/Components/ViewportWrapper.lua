--[[
	ViewportWrapper;
	ViewportWrapper is a special type of Component used to wrap it's given UI element inside the Viewport
	to make sure that something stays visible (like a tooltip)
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	Children
	
}

export type ViewportWrapper = {
	
	
	[any]: any
}

local function ViewportWrapper(props: ViewportWrapper)
	
	local parent = Value()
	local update = Value()
	local layerCollector = Computed(function()
		local currentParent: Instance = unwrap(parent)
		unwrap(update)
		
		if currentParent then
			local layerCollector = currentParent:FindFirstAncestorWhichIsA("LayerCollector")
			
			if layerCollector then
				return layerCollector
			end
			
		end
		
		return nil
	
	end)
	
	local absolutePosition = Value(Vector2.zero)
	local absoluteSize = Value(Vector2.zero)
	local viewportSize = Computed(function()
		
		local layer = unwrap(layerCollector)
		if layer then
			return layer.AbsoluteSize
		end
		
		return Vector2.zero
		
	end)
	
	local previous = UDim2.new()
	local adjustedPosition = Computed(function()
		
		local currentPosition = unwrap(absolutePosition)
		local currentSize = unwrap(absoluteSize)
		local currentViewportSize = unwrap(viewportSize)
		local parent = unwrap(parent)
		
		if not (currentPosition and currentSize and currentViewportSize and parent) then return previous end
		
		currentPosition = Vector2.new(
			math.clamp(currentPosition.X, 0, currentViewportSize.X),
			math.clamp(currentPosition.Y, 0, currentViewportSize.Y)
		)
		local endPosition = Vector2.new(
			math.clamp(currentPosition.X + currentSize.X, 0, currentViewportSize.X),
			math.clamp(currentPosition.Y + currentSize.Y, 0, currentViewportSize.Y)
		)
		
		local resultPosition = endPosition - currentSize - unwrap(absolutePosition, false)
		local result = UDim2.fromOffset(resultPosition.X, resultPosition.Y)
		
		previous = result
		return result
		
	end)
	
	local ViewportWrapper = New "Frame" {
		
		Name = "ViewportWrapper",
		
		BackgroundTransparency = 1,
		
		[OnEvent "AncestryChanged"] = function() update:set(os.clock()) end,
		
		[Out "Parent"] = parent,
		[Out "AbsolutePosition"] = absolutePosition,
		
		[Children] = New "Frame" {
			
			Name = "ViewportWrapperContainer",
			
			Position = adjustedPosition,
			AutomaticSize = Enum.AutomaticSize.XY,
			
			BackgroundTransparency = 1,
			
			[Out "AbsoluteSize"] = absoluteSize,
			[Children] = props[Children]
			
		}
		
	}
	
	return Hydrate(ViewportWrapper)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return ViewportWrapper