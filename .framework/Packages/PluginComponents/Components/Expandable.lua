--[[
	A basic component that does not contain any actual visual elements.
	To be used for expandable animated user interface
	
]]

--[[
	Expandable;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local Spring = Fusion.Spring
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"Expanded",
	"ExpandedSize",
	"RealChildren",
	Children
}

type CanBeState<T> = Fusion.CanBeState<T>
export type Expandable = {
	Expanded: CanBeState<boolean>,
	ExpandedSize: CanBeState<UDim2?>,
	
	[any]: any
}

local function Expandable(props: Expandable)
	
	local expanded = props.Expanded
	local expandedSize = props.ExpandedSize
	local contentSize = Value(Vector2.new())
	local currentSize = Spring(
		Computed(function()
			local currentContentSize = unwrap(contentSize)
			local expandedSize = unwrap(expandedSize)
			
			-- fallback
			if unwrap(contentSize) == nil then return UDim2.new() end
			
			return
				if unwrap(expanded) then expandedSize or UDim2.fromOffset(currentContentSize.X, currentContentSize.Y)
				else
					if expandedSize then UDim2.new(expandedSize.X, UDim.new()) else UDim2.fromOffset(currentContentSize.X, 0)
		end)
		, 40, 1
	)
	
	local Expandable = New "Frame" {
		
		Name = "ExpandableContainer",
		
		BackgroundTransparency = 1,
		
		Size = currentSize,
		
		ClipsDescendants = true,
		
		[Children] = {
			
			New "UISizeConstraint" {
				MaxSize = Computed(function()
					return Vector2.new(math.huge, unwrap(currentSize).Y.Offset)
				end)
			},
			
			New "Frame" {
			
				Name = "Container",
				
				Size = Computed(function() return if expandedSize then UDim2.fromScale(1, 1) else UDim2.new() end),
				AutomaticSize = Enum.AutomaticSize.XY,
				
				BackgroundTransparency = 1,
				
				[Out "AbsoluteSize"] = contentSize,
				
				[Children] = props[Children]
				
			},
			
			props.RealChildren
			
		}
		
	}
	
	return Hydrate(Expandable)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Expandable