local Package = script.Parent

local Check = require(Package.Check)
local Skip = require(Package.Skip)

local Test = {}
Test.__index = Test

export type Test = {
	name: string,
	source: ModuleScript,
	
	callback: () -> nil,
	
}

local function NewTest(name: string, moduleScript: ModuleScript, callback: (check: () -> nil, skip: () -> nil) -> any): Test
	
	local self = setmetatable({
		className = "Test",
		
		name = name,
		source = moduleScript,
		callback = function()
			callback(Check, Skip)
			
		end
		
	}, Test)
	
	return self
	
end



return NewTest

