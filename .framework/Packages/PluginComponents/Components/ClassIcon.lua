--[[
	ClassIcon;
	
]]

local StudioService = game:GetService("StudioService")

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Image = require(Components.Image)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Computed = Fusion.Computed
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"ClassName"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
export type ClassIcon = {
	ClassName: CanBeState<string>,
	
	[any]: any
}

local function ClassIcon(props: ClassIcon)
	
	local className = props.ClassName
	local imageData = Computed(function()
		return StudioService:GetClassIcon(unwrap(className))
		
	end)
	
	local ClassIcon = Image {
		
		Name = "Image",
		
		Size = UDim2.fromOffset(16, 16),
		Image = Computed(function()
			return unwrap(imageData).Image
		end),
		ImageRectOffset = Computed(function()
			return unwrap(imageData).ImageRectOffset
		end),
		ImageRectSize = Computed(function()
			return unwrap(imageData).ImageRectSize
		end)
		
	}
	
	return Hydrate(ClassIcon)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return ClassIcon