--[[
	TopLayer;
	A portal which will put any child to the highest layer. This can be useful for when dealing with (for example) dropdowns which
	create a new menu that should not affect anything else.
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children
local Observer = Fusion.Observer
local Cleanup = Fusion.Cleanup
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"LayerCollector"
}

type Value<T> = Fusion.Value<T>
export type TopLayer = {
	LayerCollector: Value<nil>?,
	
	[any]: any
}

local function TopLayer(props: TopLayer)
	
	local refLayerCollector = props.LayerCollector or Value()
	
	local realSize = Value()
	local realPosition = Value()
	local realRotation = Value()
	
	local parent = Value()
	local update = Value(math.random())
	local highestLayerCollector = Computed(function()
		local currentParent: Instance = unwrap(parent)
		unwrap(update)
		
		if currentParent then
			local layerCollector = currentParent:FindFirstAncestorWhichIsA("LayerCollector")
			
			if layerCollector then
				
				refLayerCollector:set(layerCollector)
				return layerCollector
			end
			
		end
		
		refLayerCollector:set(nil)
		return nil
	
	end)
	
	local observer = Observer(parent):onChange(function()
		local currentParent = unwrap(parent)
		
		if currentParent then
			
			Hydrate(currentParent) {
			
				[Cleanup] = currentParent.Changed:Connect(function(propertyName)
					if propertyName == "AbsoluteSize" then
						realSize:set(currentParent.AbsoluteSize)
					elseif propertyName == "AbsolutePosition" then
						realPosition:set(currentParent.AbsolutePosition)
					elseif propertyName == "AbsoluteRotation" then
						realRotation:set(currentParent.AbsoluteRotation)
					end
					
				end)
				
			}
			
		end
		
	end)
	
	local BaseClone = New "Folder" {
		
		Name = "TopLayerPortal",
		Parent = highestLayerCollector,
		
		[Children] = New "Frame" {
		
			Name = "Portal:TopLayer",
			
			Size = Computed(function()
				local size = unwrap(realSize)
				if size == nil then return UDim2.new() end
				return UDim2.fromOffset(size.X, size.Y)
			end),
			Position = Computed(function()
				local position = unwrap(realPosition)
				if position == nil then return UDim2.new() end
				return UDim2.fromOffset(position.X, position.Y)
			end),
			Rotation = realRotation,
			
			BackgroundTransparency = 1
			
		},
		
		[Cleanup] = observer
		
	}
	
	local TopLayer = New "Configuration" {
		
		Name = "Portal:TopLayer",
		
		[OnEvent "AncestryChanged"] = function() update:set(math.random()) end,
		[Out "Parent"] = parent,
		
		[Cleanup] = BaseClone
		
	}
	
	Hydrate(BaseClone["Portal:TopLayer"])(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	return TopLayer
end

return TopLayer