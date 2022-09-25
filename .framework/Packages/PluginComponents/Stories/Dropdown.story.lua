
local Components = script.Parent.Parent.Components

local Dropdown = require(Components.Dropdown)

return function(target)
	
	local object = Dropdown {
		Parent = target,
		
		Options = {
			"Grapes",
			"Apple",
			"Pear",
			"Banana",
			"Orange",
			"Pineapple",
			"Kiwi"
		}
	}
	
	return function()
		object:Destroy()
		
	end
end