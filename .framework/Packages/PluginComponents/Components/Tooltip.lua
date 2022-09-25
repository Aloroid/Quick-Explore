--[[
	Tooltip;
	Tooltips display a small menu containing text (or more when specified)
	This can be used in order to explain functionality of certain UI elements inside your plugin
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local TopLayer = require(Components.TopLayer)
local Border = require(Components.Border)
local TextLabel = require(Components.TextLabel)
local UIPadding = require(Components.UIPadding)
local ViewportWrapper = require(Components.ViewportWrapper)
local Shadow = require(Components.Shadow)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local TOTAL_WAIT_TILL_DISPLAY = 0.5

local COMPONENT_ONLY_PROPERTIES = {
	"Tooltip",
	"RichText",
	
	Children
	
}

type CanBeState<T> = Fusion.CanBeState<T>
export type Tooltip = {
	Tooltip: CanBeState<string?>,
	RichText: CanBeState<boolean?>,
	
	[any]: any
}

local function Tooltip(props: Tooltip)
	
	local tooltip = props.Tooltip
	local richText = props.RichText
	
	local displayed = Value(false)
	local currentMousePosition = Value(Vector2.zero)
	local absolutePosition = Value(Vector2.zero)
	
	local lastMovement = os.clock()
	
	local springTransparency = Spring(
		Computed(function()
			return if unwrap(displayed) then 0 else 1
		end),
		60,
		1
	)
	
	local Tooltip = TopLayer {
		
		[Children] = New "Frame" {
			
			Name = "TooltipInput",
			
			Size = UDim2.fromScale(1, 1),
			
			BackgroundTransparency = 1,
			
			[OnEvent "MouseMoved"] = function(x, y)
				
				displayed:set(false)
				
				local start = os.clock()
				lastMovement = start
				
				task.delay(TOTAL_WAIT_TILL_DISPLAY, function()
					if lastMovement == start then
						displayed:set(true)
						currentMousePosition:set(Vector2.new(x, y))
					end
					
				end)
				
			end,
			[OnEvent "MouseLeave"] = function()
				displayed:set(false)
				lastMovement = os.clock()
			end,
			
			[Out "AbsolutePosition"] = absolutePosition,
			
			[Children] = ViewportWrapper {
				
				Position = Computed(function()
					local mousePosition = unwrap(currentMousePosition) - (unwrap(absolutePosition) or Vector2.zero)
					return UDim2.fromOffset(mousePosition.X + 12, mousePosition.Y + 8)
				end),
				
				[Children] = Shadow {
					
					ShadowTransparency = springTransparency,
					
					[Children] = New "CanvasGroup" {
				
						Name = "Tooltip",
						
						AutomaticSize = Enum.AutomaticSize.XY,
						
						BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.MainBackground),
						
						GroupTransparency = springTransparency,
						
						[Children] = {
							
							UIPadding {
								XPadding = UDim2.fromOffset(4, 4),
								YPadding = UDim2.fromOffset(4, 4)
							},
							
							TextLabel {
								Text = tooltip,
								RichText = richText
								
							},
							
							Border {
								Transparency = springTransparency
							},
							
							New "UIListLayout" {},
							
							props[Children]
							
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	return Hydrate(Tooltip)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Tooltip