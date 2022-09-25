--[[
	Border;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Theme = Util.Theme
local stripProps = Util.stripProps

local New = Fusion.New
local Spring = Fusion.Spring
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"BorderStyle",
	"BorderModifier"
	
}

export type Border = {
	BorderStyle: Fusion.CanBeState<Enum.StudioStyleGuideColor>?,
	BorderModifier: Fusion.CanBeState<Enum.StudioStyleGuideModifier>?,
	
	[any]: any
}

local function Border(props: Border)
	
	local BorderStyle = props.BorderStyle or Enum.StudioStyleGuideColor.Border
	local BorderModifier = props.BorderModifier or Enum.StudioStyleGuideModifier.Default
	
	local Border = New "UIStroke" {
		
		Name = "Border",
		
		ApplyStrokeMode=  Enum.ApplyStrokeMode.Border,
		
		Color = Spring(Theme(BorderStyle, BorderModifier), 60, 1),
		Thickness = 1
		
	}
	
	return Hydrate(Border)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Border