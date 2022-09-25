--[[
	Image;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)

local New = Fusion.New
local Hydrate = Fusion.Hydrate

export type Image = {
	Image: string,
	
	[any]: any
}

local function Image(props: Image)
	
	local Image = New "ImageButton" {
		
		Name = "ImageButton",
		
		Size = UDim2.fromOffset(32, 32),
		
		BackgroundTransparency = 1
		
	}
	
	return Hydrate(Image)(props)
end

return Image