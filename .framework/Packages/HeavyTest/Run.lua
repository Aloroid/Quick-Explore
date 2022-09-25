--[[
	Run is used to run a ModuleScript
	
]]

local Package = script.Parent
local Test = require(Package.Test)
local Result = require(Package.Result)

type Result = Result.Result
type Results = {
	[string]: Results | Result
}

local function Run(module: ModuleScript): Results
	
	local source = require(module)
	
	-- Runs all tests inside the provided table
	local function runTests(t)
		local results = {}
		
		for testName, callbackOrMoreTests in t do
			if type(callbackOrMoreTests) == "table" then
				results[testName] = runTests(callbackOrMoreTests)
				
			else
				local test = Test(testName, module, callbackOrMoreTests)
				local result = Result(test, source)
				
				results[testName] = result
				
			end
		end
		
		return results
	end
	
	return runTests(source)
	
end

return Run
