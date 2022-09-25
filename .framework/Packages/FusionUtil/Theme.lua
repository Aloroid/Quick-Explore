--[[
	This function should be used for returning the provided theme color associated with the given GuideColor and GuideModifier, this
	makes it incredibly easy for developers to retrieve a Theme that automatically updates according to theme changes.
	
]]

local Packages = script.Parent.Parent
local Util = script.Parent

local Fusion = require(Packages.Fusion)
local unwrap = require(Util.unwrap)

local Value = Fusion.Value
local Computed = Fusion.Computed

local Studio: Studio = settings():GetService("Studio")
local CurrentTheme = Value(Studio.Theme)

type CanBeState<T> = Fusion.CanBeState<T>?
type Computed<T> = Fusion.Computed<T>

local function Theme(GuideColor: CanBeState<Enum.StudioStyleGuideColor>, GuideModifier: CanBeState<Enum.StudioStyleGuideModifier>): Computed<Color3 | StudioTheme>
	
	if GuideColor == nil then
		return CurrentTheme
	end
	
	return Computed(function()
		
		local guideColor = unwrap(GuideColor)
		local guideModifier = unwrap(GuideModifier)
		
		return unwrap(CurrentTheme):GetColor(
			guideColor or Enum.StudioStyleGuideColor.MainBackground,
			guideModifier or Enum.StudioStyleGuideModifier.Default
		)
		
	end)
	
end

Studio.ThemeChanged:Connect(function(newTheme)
	CurrentTheme:set(Studio.Theme)
	
end)

return Theme