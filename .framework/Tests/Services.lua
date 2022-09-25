--[[
	This test will attempt to figure out if a Service will work. It also loads the service.
	
]]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Services = plugin:FindFirstChild("Services", true)

local tests = {}

for _index, service in Services:GetChildren() do
	
	local defaultTestsForService = {}
	local success, result = pcall(require, service)
	
	defaultTestsForService["should require succesfully"] = function(check, skip)
		
		check(success, result)
		check(type(result) == "table", "Service did not return a table")
	end
	
	defaultTestsForService["should initiate succesfully"] = function(check, skip)
		check(success)
		check(type(result) == "table")
		
		if result.Init == nil then skip("Service does not have initiate function") end
		
		result:Init()
		
	end
	
	tests[service.Name] = defaultTestsForService
	
end

return tests
