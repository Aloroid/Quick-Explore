--[[
	Check is used to confirm if the provided values is what it should be.
	
]]

local Package = script.Parent

local SharedState = require(Package.SharedState)

local function Check(result: any, message: string?)
	
	-- converts the result into a boolean
	result = not not result
	
	SharedState.result.success = result
	
	if result == false then
		error(message, 0)
	end
	
	return result
	
end

return Check
