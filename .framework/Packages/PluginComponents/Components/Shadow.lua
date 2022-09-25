--[[
	Shadow;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Image = require(Components.Image)
local UIPadding = require(Components.UIPadding)

local Theme = Util.Theme
local stripProps = Util.stripProps

local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"ShadowTransparency"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
export type Shadow = {
	ShadowTransparency: CanBeState<number?>,

	[any]: any
}

local function Shadow(props: Shadow)
	
	local ShadowTransparency = props.ShadowTransparency

	local Shadow = Image {
		
		Name = "Shadow",
		
		Size = UDim2.new(), -- Set size to 0,0 so that AutomaticSize works properly
		AutomaticSize = Enum.AutomaticSize.XY,
		
		Image = "rbxasset://textures/StudioSharedUI/dropShadow.png",
		ImageColor3 = Theme(Enum.StudioStyleGuideColor.Midlight),
		ImageTransparency = ShadowTransparency,
		
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 8, 8),
		SliceScale = 0.5,
		
		[Children] = {
			
			UIPadding {
				XPadding = UDim2.fromOffset(3, 3),
				YPadding = UDim2.fromOffset(3, 3)
			} 
			
		}
		
	}
	
	return Hydrate(Shadow)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Shadow