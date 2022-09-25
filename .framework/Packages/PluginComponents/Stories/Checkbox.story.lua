local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local Checkbox = require(Components.Checkbox)

local Value = Fusion.Value

return function(target)
	
	local object = Checkbox {
		Parent = target,
		
		Value = Value(),
		Disabled = true
	}
	
	return function()
		object:Destroy()
		
	end
end