--[[
	Pane;
	Panes should be used in order to group components together for organization
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Border = require(Components.Border)
local UIPadding = require(Components.UIPadding)
local TextLabel = require(Components.TextLabel)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local CORNER_RADIUS = UDim.new(0, 4)

local COMPONENT_ONLY_PROPERTIES = {
	"BackgroundColor",
	"BorderColor",
	"TextColor",
	
	"Padding",
	"Text",
	
	Children
	
}

type CanBeState<T> = Fusion.CanBeState<T>
export type Pane = {
	BackgroundColor: CanBeState<Color3?>,
	BorderColor: CanBeState<Color3?>,
	TextColor: CanBeState<Color3?>,
	
	Padding: CanBeState<number?>,
	Text: CanBeState<string?>,
	
	[any]: any
}

local function Pane(props: Pane)
	
	local BackgroundColor = props.BackgroundColor
	local BorderColor = props.BorderColor
	local TextColor = props.TextColor
	
	local Padding = props.Padding or 8
	local Text = props.Text
	
	local Pane = New "Frame" {
		
		Name = "Pane",
		
		Size = UDim2.new(1, 0, 0, 32),
		AutomaticSize = Enum.AutomaticSize.Y,
		
		BackgroundColor3 = BackgroundColor or Theme(Enum.StudioStyleGuideColor.MainBackground),
		
		[Children] = {
			Border {
				Color = BorderColor
			},
			
			New "UICorner" {
				CornerRadius = CORNER_RADIUS
			},
			
			New "Frame" {
				Name = "Container",
				
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				
				BackgroundTransparency = 1,
				
				[Children] = {
					
					UIPadding {
						XPadding = Computed(function() return UDim2.fromOffset(unwrap(Padding), unwrap(Padding)) end),
						YPadding = Computed(function()
							return
								if unwrap(Text) then UDim2.fromOffset(12, 12)
								else UDim2.fromOffset(unwrap(Padding), unwrap(Padding))
							
						end)
						
					},
					
					props[Children]
					
				}
				
			},
			
			New "Frame" {
				Name = "PaneName",
				
				Position = UDim2.fromOffset(8, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				
				AutomaticSize = Enum.AutomaticSize.XY,
				
				BackgroundColor3 = BackgroundColor or Theme(Enum.StudioStyleGuideColor.MainBackground),
				
				Visible = Computed(function()
					return unwrap(Text) ~= nil
				end),
				
				[Children] = {
					
					UIPadding {
						XPadding = UDim2.fromOffset(4, 4)
					},
					
					TextLabel {
						Text = Text,
						TextSize = 18,
						
						TextColor3 = TextColor or Theme(Enum.StudioStyleGuideColor.DimmedText)
					}
					
				}
			}
			
		}
	}
	
	return Hydrate(Pane)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Pane