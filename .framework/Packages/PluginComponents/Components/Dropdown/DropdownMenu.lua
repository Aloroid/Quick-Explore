--[[
	DropdownMenu;
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Button = require(Components.Button)
local Border = require(Components.Border)
local Expandable = require(Components.Expandable)
local UIPadding = require(Components.UIPadding)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local ForPairs = Fusion.ForPairs
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local CORNER_RADIUS = UDim.new(0, 4)

local COMPONENT_ONLY_PROPERTIES = {
	"MaxItems",
	"ItemSize",
	
	"Options",
	"Selected",
	
	"Expanded"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type DropdownMenu = {
	
	MaxItems: CanBeState<number>?,
	ItemSize: CanBeState<number>?,
	
	Options: CanBeState<{string}>,
	Selected: Value<number>,
	
	Expanded: Value<boolean>,
	OnSelect: ( (n: number) -> nil )?,
	
	[any]: any
}

local function DropdownMenu(props: DropdownMenu)
	
	local maxItems = props.MaxItems or 5
	local itemSize = props.ItemSize or 18
	
	local options = props.Options
	local selected = props.Selected
	local expanded = props.Expanded
	local OnSelect = props.OnSelect
	
	local realItemSize = Computed(function()
		return UDim2.new(1, 0, 0, unwrap(itemSize))
	end)
	local realExpandableSize = Value(Vector2.zero)
	
	local DropdownMenu = Expandable {
		
		Name = "DropdownList",
		
		BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.Dropdown),
		BackgroundTransparency = 0,
		
		Expanded = expanded,
		ExpandedSize = Computed(function()
			return UDim2.new(1, 0, 0, unwrap(itemSize) * math.min(#unwrap(options), unwrap(maxItems)) + 10)
			
		end),
		
		RealChildren = {
			
			New "UICorner" {
				CornerRadius = CORNER_RADIUS
			},
			
			Border {
				Thickness = Computed(function()
					local currentSize = unwrap(realExpandableSize) or Vector2.new()
					return if currentSize.Y <= 1 then 0 else 1
				end)
			}
			
		},
		
		[Out "AbsoluteSize"] = realExpandableSize,
		[Children] = {
			
			UIPadding {
				XPadding = UDim2.fromOffset(2, 2),
				YPadding = UDim2.fromOffset(2, 2)
			},
			
			New "ScrollingFrame" {
			
				Name = "Scrolling",
				
				Size = UDim2.fromScale(1, 1),
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 4,
				
				BackgroundTransparency = 1,
				BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.EmulatorDropDown),
				ScrollBarImageColor3 = Theme(Enum.StudioStyleGuideColor.SubText),
				
				[Children] = {
					
					UIPadding {
						XPadding = UDim2.fromOffset(2, 8),
						YPadding = UDim2.fromOffset(2, 2)
					},
					
					New "UIListLayout" {
						Padding = UDim.new(0, 2)
					},
					
					ForPairs(options, function(key, text)
						
						return key, Button {
							
							Name = "Dropdown:"..text,
							
							Size = realItemSize,
							
							BackgroundColor = Enum.StudioStyleGuideColor.EmulatorDropDown,
							BorderColor = Enum.StudioStyleGuideColor.EmulatorDropDown,
							
							Text = text,
							TextSize = 14,
							
							YPadding = UDim2.fromOffset(2, 2),
							
							[OnEvent "Activated"] = function()
								expanded:set(false)
								selected:set(key)
								
								if OnSelect then
									OnSelect(key)
								end
							end
							
						}
						
					end)
				}
				
			}
			
		}
		
	}
	
	return Hydrate(DropdownMenu)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return DropdownMenu