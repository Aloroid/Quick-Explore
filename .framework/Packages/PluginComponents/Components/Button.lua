--[[
	Button;
	Button is a basic component used to put functionality into. It comes with basic hover, pressed, disabled and selected states.
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Background = require(Components.Background)
local TextLabel = require(Components.TextLabel)
local UIPadding = require(Components.UIPadding)
local Border = require(Components.Border)

local Theme = Util.Theme
local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps
local guideState = Util.guideState

local New = Fusion.New
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"BackgroundColor",
	"TextColor",
	"BorderColor",
	
	"Disabled",
	"Selected",
	"Pressed",
	"Hovering",
	
	"Text",
	"FontWeight",
	"FontStyle",
	"TextSize",
	
	"XPadding",
	"YPadding",
	
	Children
	
}
local CORNER_RADIUS = 3

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>

export type Button = {
	
	BackgroundColor: CanBeState<Enum.StudioStyleGuideColor?>,
	TextColor: CanBeState<Enum.StudioStyleGuideColor?>,
	BorderColor: CanBeState<Enum.StudioStyleGuideColor?>,
	
	Disabled: CanBeState<boolean?>,
	Selected: CanBeState<boolean?>,
	Pressed: Value<boolean> | boolean?,
	Hovering: Value<boolean> | boolean?,
	
	Text: CanBeState<string?>,
	TextSize: CanBeState<number?>,
	FontWeight: CanBeState<Enum.FontWeight?>,
	FontStyle: CanBeState<Enum.FontStyle?>,
	
	XPadding: CanBeState<UDim2>?,
	YPadding: CanBeState<UDim2>?,
	
	[any]: any
}

local function Button(props: Button)
	
	local textColor = props.TextColor or Enum.StudioStyleGuideColor.ButtonText
	local textSize = props.TextSize or 18
	local text = props.Text or "Button"
	local fontWeight = props.FontWeight
	local fontStyle = props.FontStyle
		
	local pressed = Statify(props.Pressed)
	local hovering = Statify(props.Hovering)
	local disabled = props.Disabled
	local selected = props.Selected
	
	local XPadding = props.XPadding
	local YPadding = props.YPadding
	
	local guideModifier = guideState(selected, disabled, pressed, hovering)
	local backgroundStyle = props.BackgroundColor or Computed(function()
		return
			if unwrap(disabled) then Enum.StudioStyleGuideColor.InputFieldBackground
			else Enum.StudioStyleGuideColor.Button
		
	end)
	local BorderStyle = props.BorderColor or Computed(function()
		return
			if unwrap(disabled) then Enum.StudioStyleGuideColor.ButtonBorder
			elseif unwrap(selected) then Enum.StudioStyleGuideColor.MainButton
			else Enum.StudioStyleGuideColor.Border
		
	end)
	
	local Button = New "TextButton" {
		
		Name = "Button",
		
		AutomaticSize = Enum.AutomaticSize.XY,
		
		BackgroundTransparency = 1,
		Active = Computed(function() return not unwrap(disabled) end),
		
		[OnEvent "MouseButton1Down"] = function() pressed:set(true) end,
		[OnEvent "MouseButton1Up"] = function() pressed:set(false) end,
		[OnEvent "MouseLeave"] = function() pressed:set(false); hovering:set(false) end,
		[OnEvent "MouseEnter"] = function() hovering:set(true) end,
		
		[Children] = {
			
			Background {
				BackgroundColor3 = Spring(Theme(backgroundStyle, guideModifier), 60, 1),
				
				[Children] = {
					UIPadding {
						XPadding = XPadding or UDim2.fromOffset(8, 8),
						YPadding = YPadding or UDim2.fromOffset(4, 4)
					},
					
					Border {
						BorderStyle = BorderStyle,
						BorderModifier = guideModifier
					},
					
					New "UICorner" {
						CornerRadius = UDim.new(0, CORNER_RADIUS)
					},
					
					New "UIListLayout" {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						
						Padding = UDim.new(0, 6)
						
					},
					
					TextLabel {
						TextColor3 = Theme(textColor, guideModifier),
						
						Text = text,
						TextSize = textSize,
						
						FontWeight = fontWeight,
						FontStyle = fontStyle,
						
						LayoutOrder = 100
						
					},
					
					props[Children]
				}
				
			}
			
		}
		
	}
	
	return Hydrate(Button)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Button