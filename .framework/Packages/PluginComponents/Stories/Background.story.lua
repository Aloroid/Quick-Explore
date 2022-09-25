local Components = script.Parent.Parent.Components

local Background = require(Components.Background)

return function(target)
	
	local object = Background {
		Parent = target
		
		
	}
	
	return function()
		object:Destroy()
		
	end
end