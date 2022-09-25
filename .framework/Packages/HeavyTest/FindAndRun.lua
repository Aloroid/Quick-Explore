--[[
	Finds ModuleScripts and runs them
	
]]

local Package = script.Parent
local Run = require(Package.Run)

local DEFAULT_CONFIG = {
	searchDescendants = false,
	prefix = ".test"
}

type Configuration = {
	searchDescendants: boolean?,
	suffix: string?
	
}

local function findAndRun(directories: {Instance}, Configuration: Configuration?)
	
	local Config = if Configuration then Configuration else DEFAULT_CONFIG
	local searchDescendants = Config.searchDescendants or false
	local suffix = Config.suffix or ".test"
	
	local results = {}
	
	for _, directory in directories do
		for _, object in (if searchDescendants then directory:GetDescendants() else directory:GetChildren()) do
			
			if object:IsA("ModuleScript") and string.match(object.Name, suffix.."$") then
				
				results[directory.Name] = results[directory.Name] or {}
				
				local test = Run(object)
				results[directory.Name][object.Name] = test
				
			end
		end
	end
	
	return results
	
end


return findAndRun