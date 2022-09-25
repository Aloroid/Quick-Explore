--[[
	UIPadding;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Computed = Fusion.Computed
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"XPadding",
	"YPadding"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
export type UIPadding = {
	XPadding: CanBeState<UDim2?>,
	YPadding: CanBeState<UDim2?>,
	
	[any]: any
}

local function UIPadding(props: UIPadding)
	
	local xPadding = props.XPadding or UDim2.new()
	local yPadding = props.YPadding or UDim2.new()
	
	local UIPadding = New "UIPadding" {
		
		Name = "Padding",
		
		PaddingTop = Computed(function() return unwrap(yPadding).X end),
		PaddingBottom = Computed(function() return unwrap(yPadding).Y end),
		PaddingLeft = Computed(function() return unwrap(xPadding).X end),
		PaddingRight = Computed(function() return unwrap(xPadding).Y end),
		
	}
	
	return Hydrate(UIPadding)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return UIPadding