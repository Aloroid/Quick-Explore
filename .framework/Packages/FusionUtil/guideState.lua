--[[
	Creates a GuideModifier state which can be used to track if a component is being hovered/pressed.
	
]]

local Packages = script.Parent.Parent
local Util = script.Parent

local Fusion = require(Packages.Fusion)
local unwrap = require(Util.unwrap)

type StateObject = Fusion.CanBeState<boolean>?
type Computed<T> = Fusion.Computed<T>

local Computed = Fusion.Computed

local function guideState(selected: StateObject, disabled: StateObject, pressed: StateObject, hovering: StateObject): Computed<Enum.StudioStyleGuideModifier>
	
	return Computed(function()
		
		local value =
			if unwrap(disabled) then
				Enum.StudioStyleGuideModifier.Disabled
			elseif unwrap(selected) then
				Enum.StudioStyleGuideModifier.Selected
			elseif unwrap(pressed) then
				Enum.StudioStyleGuideModifier.Pressed
			elseif unwrap(hovering) then
				Enum.StudioStyleGuideModifier.Hover
			else
				Enum.StudioStyleGuideModifier.Default
		
		return value
		
	end)
	
end

return guideState
