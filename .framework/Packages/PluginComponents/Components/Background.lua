--[[
	Background;
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Theme = Util.Theme

local New = Fusion.New
local Hydrate = Fusion.Hydrate

export type Background = {
	[any]: any
}

local function Background(props: Background)
	local Background = New "Frame" {
		
		Name = "Background",
		
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = if props.Size then Enum.AutomaticSize.XY else Enum.AutomaticSize.None,
		
		BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.MainBackground)
	}
	
	return Hydrate(Background)(props)
end

return Background