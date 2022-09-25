
local Components = script.Parent.Parent.Components

local TextLabel = require(Components.TextLabel)

return function(target)
	
	local object = TextLabel {
		Parent = target,
		
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		
		Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam non tortor quis orci vestibulum sodales. Morbi. "
	}
	
	return function()
		object:Destroy()
		
	end
end