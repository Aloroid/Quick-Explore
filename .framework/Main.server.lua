--[[
	Initiates the Framework and runs the tests
	
]]

assert(plugin, "Interconnect requires to be ran under a plugin in-order to work.")
local plugin: Plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Framework = script.Parent

local Packages = Framework:FindFirstChild("Packages")
local Tests = Framework:FindFirstChild("Tests")
local Services = plugin:FindFirstChild("Services", true)
local PluginTests = Services.Parent:FindFirstChild("Tests")

assert(Packages, "Unable to find Packages")
assert(Services, "Unable to find Services")
assert(Tests, "Unable to find tests")

local HeavyTest = require(Packages.HeavyTest)

-- Makes sure that Packages run fine
--HeavyTest.findAndRun({Packages}, {searchDescendants = true})
--HeavyTest.fancyPrint()
-- Make sure that core services is properly running and isn't broken.
local Results = HeavyTest.findAndRun({Tests, PluginTests}, {suffix = ""})


--HeavyTest.fancyPrint(Results)