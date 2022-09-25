--[[
	TextLabel;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Theme = Util.Theme
local stripProps = Util.stripProps
local unwrap = Util.unwrap

local New = Fusion.New
local Computed = Fusion.Computed
local Hydrate = Fusion.Hydrate

type CanBeState<T> = Fusion.CanBeState<T>

local COMPONENT_ONLY_PROPERTIES = {
	"FontWeight",
	"FontStyle"
	
}

export type TextLabel = {
	FontWeight: CanBeState<Enum.FontWeight>?,
	FontStyle: CanBeState<Enum.FontStyle>?,
	
	[any]: any
}

local function TextLabel(props: TextLabel)
	
	local TextLabel = New "TextLabel" {
		
		Name = "Text",
		
		AutomaticSize = Enum.AutomaticSize.XY,
		
		BackgroundTransparency = 1,
		
		TextColor3 = Theme(Enum.StudioStyleGuideColor.MainText),
		TextSize = 14,
		FontFace = Computed(function()
			return Font.new(
				"rbxasset://fonts/families/SourceSansPro.json",
				unwrap(props.FontWeight) or Enum.FontWeight.Regular,
				unwrap(props.FontStyle) or Enum.FontStyle.Normal
			)
		end)
		
	}
	
	return Hydrate(TextLabel)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return TextLabel