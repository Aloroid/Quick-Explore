--[[
	Dropdown;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Button = require(Components.Button)
local Image = require(Components.Image)
local TopLayer = require(Components.TopLayer)
local DropdownMenu = require(script.DropdownMenu)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"Options",
	"Selected",
	"OnSelect"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type Dropdown = {
	
	Options: CanBeState<{string}>,
	Selected: Value<number>?,
	
	OnSelect: ( (selected: number) -> nil )?,
	
	[any]: any
}

local function Dropdown(props: Dropdown)
	
	local options = props.Options
	local selected = props.Selected or Value(1)
	local expanded = Value(false)
	
	local Dropdown = Button {
		
		Name = "Dropdown",
		
		Size = UDim2.fromOffset(200, 30),
		
		BackgroundColor = Enum.StudioStyleGuideColor.EmulatorDropDown,
		
		Text = Computed(function()
			
			local currentOptions = unwrap(options)
			local currentSelected = unwrap(selected)
			
			return currentOptions[currentSelected]
			
		end),
		
		[OnEvent "Activated"] = function() expanded:set(not unwrap(expanded)) end,
		
		[Children] = {
			
			Image {
				Name = "Arrow",
				
				Size = UDim2.fromOffset(12, 12),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				
				Image = "rbxasset://textures/StudioSharedUI/arrowSpritesheet.png",
				ImageRectSize = Vector2.new(12, 12),
				ImageRectOffset = Computed(function()
					return if unwrap(expanded) then Vector2.new(24, 0) else Vector2.new(12, 0)
					
				end),
				ImageColor3 = Computed(function()
					return if unwrap(Theme()).Name == "Dark" then Color3.fromRGB(225, 225, 225) else Color3.fromRGB(29, 29, 29)
					
				end),
				
				
			},
			
			TopLayer {
				
				[Children] = DropdownMenu {
					
					Position = UDim2.fromOffset(1, 34),
					
					Options = options,
					Selected = selected,
					
					Expanded = expanded,
					OnSelect = props.OnSelect
					
				}
				
			}
			
		}
		
	}
	
	return Hydrate(Dropdown)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Dropdown