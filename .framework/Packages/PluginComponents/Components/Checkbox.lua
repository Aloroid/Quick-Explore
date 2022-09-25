--[[
	Checkbox;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local ImageButton = require(Components.ImageButton)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps
local Statify = Util.Statify

local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"Value",
	"Disabled"
	
}

export type Checkbox = {
	
	Value: Fusion.Value<boolean | any>,
	Disabled: Fusion.CanBeState<boolean>?,
	
	[any]: any
}

local function Checkbox(props: Checkbox)
	
	local disabled = props.Disabled
	local checked = Statify(props.Value)
	
	local Checkbox = ImageButton {
		
		Name = "Checkbox",
		
		Size = UDim2.fromOffset(16, 16),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		
		Active = Computed(function()
			return unwrap(disabled) ~= true
		end),
		
		[OnEvent "Activated"] = function() checked:set(not unwrap(checked)) end,
		
		Image = Computed(function()
			
			local imageToGet = "rbxasset://textures/DeveloperFramework/checkbox_%s%s_%s.png"
			local checked = unwrap(checked)
			local disabled = unwrap(disabled)
			local currentTheme = unwrap(Theme())
			
			local result = string.format(
				imageToGet,
				if checked ~= false and checked ~= true and disabled == false then "indeterminate"
				elseif checked == true then "checked"
				else "unchecked",
				if disabled then "_disabled" else "",
				currentTheme.Name:lower()
			)
			
			return result
			
		end)
		
	}
	
	return Hydrate(Checkbox)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Checkbox