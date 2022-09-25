--[[
	A alternative to using Statify or :get() for retrieving values. It's recommended to use unwrap over converting values to a state due
	to use not requiring to constantly create a new State object beforehand. While Statify still has it's use for allowing you to assign
	values to States, it is not recommended if the only use for it is to get a Value from the State.
	
]]

local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local function unwrap<T>(value: Fusion.CanBeState<T>, captureDependencies: boolean?): T
	
	if type(value) == "table" and value.type == "State" then
		return value:get(captureDependencies)
	else
		return value :: T
	end
	
end

return unwrap
