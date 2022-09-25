--[[
	ScrollingFrame;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local Background = require(Components.Background)

local Theme = Util.Theme
local stripProps = Util.stripProps

local New = Fusion.New
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"ScrollingFrame",
	
	Children
}

export type ScrollingFrame = {
	ScrollingFrame: {
		[any]: any
	},
	
	[any]: any
}

local function ScrollingFrame(props: ScrollingFrame)
	
	local ScrollingFrame = Background {
		
		Name = "Scroll",
		
		[Children] = {
			
			Hydrate(New "ScrollingFrame" {
		
				Name = "ScrollerContainer",
				
				Size = UDim2.fromScale(1, 1),
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				
				HorizontalScrollBarInset = Enum.ScrollBarInset.Always,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				
				BackgroundTransparency = 1,
				
				ScrollBarImageColor3 = Theme(Enum.StudioStyleGuideColor.ScrollBar),
				
				TopImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
				MidImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
				BottomImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
				
				ScrollBarThickness = 12,
				ZIndex = 10,
				
				[Children] = props[Children]
				
			})(props.ScrollingFrame or {}),
			
			New "Frame" {
				
				Name = "ScrollingBackground",
				
				Size = UDim2.new(0, 12, 1, 0),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),
				
				BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.ScrollBarBackground),
				BorderColor3 = Theme(Enum.StudioStyleGuideColor.Border),
				BorderSizePixel = 1
				
			}
			
		}
		
	}
	
	return Hydrate(ScrollingFrame)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return ScrollingFrame