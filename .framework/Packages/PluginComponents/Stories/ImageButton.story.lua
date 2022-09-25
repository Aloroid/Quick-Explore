
local Components = script.Parent.Parent.Components

local ImageButton = require(Components.ImageButton)

return function(target)
	
	local object = ImageButton {
		Parent = target,
		
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(128, 128),
		
		Image = "rbxasset://textures/explosion.png"
	}
	
	return function()
		object:Destroy()
		
	end
end