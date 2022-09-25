--[[
	Statify is a function that converts the given value into a State, if it wasn't one already. This can be useful for when you need
	to assign values to the State without having to worry about the value maybe or may not be a state.
	
	If the provided value is a State, but cannot be set, it will instead convert it into a copied value
	
	NOTE: 
		It should be noted that it's recommended to use unwrap over Statify if you only need to get the state, as Use doesn't create a
		new state object if the provided value is not a state.
	
]]

local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local cachedComputeds = setmetatable({}, {__mode = "kvs"})
local Computed = Fusion.Computed
local Value = Fusion.Value

local function Statify<T>(value: T): Fusion.Value<T>
	
	if type(value) == "table" and value.type == "State" then
		
		if value.kind == "Value" then
			return value
		else
			local redirect = Value(value:get())
			cachedComputeds[redirect] = Computed(function()
				redirect:set(value:get())
			end)
			
			return redirect
		end
		
	else
		return Value(value)
		
	end
	
end

return Statify