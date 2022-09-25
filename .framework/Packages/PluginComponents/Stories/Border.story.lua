local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local Border = require(Components.Border)
local Background = require(Components.Background)

local Children = Fusion.Children

return function(target)
	
	local object = Background {
		Parent = target,
		
		Size = UDim2.fromOffset(64, 64),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		
		[Children] = Border {}
		
	}
	
	return function()
		object:Destroy()
		
	end
end