--[[
	ExpandablePane;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Pane = require(Components.Pane)
local Button = require(Components.Button)
local Expandable = require(Components.Expandable)
local Image = require(Components.Image)
local UIPadding = require(Components.UIPadding)

local Theme = Util.Theme
local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"CategoryText",
	"Expanded",
	
	Children
	
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type ExpandablePane = {
	CategoryText: CanBeState<string?>,
	
	Expanded: Value<boolean>?,
	
	[any]: any
}

local function ExpandablePane(props: ExpandablePane)
	
	local CategoryText = props.CategoryText
	
	local Expanded = Statify(props.Expanded or false)
	local Hovering = Value(false)
	
	local BackgroundButtonStyle = Computed(function()
		return
			if unwrap(Hovering) == true then Enum.StudioStyleGuideColor.Button
			else Enum.StudioStyleGuideColor.MainBackground
			
	end)
	
	local ExpandablePane = Pane {
		
		--Text = CategoryText,
		Padding = 5,
		
		[Children] = {
			
			Button {
				
				Name = "Header",
				
				Size = UDim2.new(1, 0, 0, 26),
				
				BackgroundColor = BackgroundButtonStyle,
				BorderColor = BackgroundButtonStyle,
				
				Hovering = Hovering,
				
				Text = CategoryText,
				TextSize = 18,
				FontWeight = Enum.FontWeight.Bold,
				
				ZIndex = 100,
				
				[OnEvent "Activated"] = function() Expanded:set(not unwrap(Expanded)) end,
				
				-- Create a frame to hold the image to increase padding
				[Children] = New "Frame" {
					
					Name = "ImageContainer",
					
					Size = UDim2.fromOffset(16, 16),
					
					BackgroundTransparency = 1,
					
					[Children] = Image {
						Name = "Arrow",
						
						Size = UDim2.fromOffset(12, 12),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						
						Image = "rbxasset://textures/StudioSharedUI/arrowSpritesheet.png",
						ImageRectSize = Vector2.new(12, 12),
						ImageRectOffset = Computed(function()
							return if unwrap(Expanded) then Vector2.new(24, 0) else Vector2.new(12, 0)
							
						end),
						ImageColor3 = Computed(function()
							return if unwrap(Theme()).Name == "Dark" then Color3.fromRGB(225, 225, 225) else Color3.fromRGB(29, 29, 29)
							
						end),
						
						
					},
					
				}
				
			},
			
			Expandable {
				
				Position = UDim2.fromOffset(0, 26),
				
				Expanded = Expanded,
				
				[Children] = {
					
					UIPadding {
						XPadding = UDim2.fromOffset(4, 4),
						YPadding = UDim2.fromOffset(8, 4)
					},
					
					props[Children]
					
				}
				
			}
			
		}
		
	}
	
	return Hydrate(ExpandablePane)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return ExpandablePane