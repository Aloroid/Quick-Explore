--[[
	Mock is a module that attempts to Mock the environment of a Script.
	Whenever Mock is used it will loadstring a script and inject require code.
	
]]

local Signal = require(script.Parent.Signal)

local Mock = {}
Mock.__index = Mock
Mock.__tostring = function(self)
	return self.source.Name
	
end

local function addDependency(startingMockObject)
	
	local parent = startingMockObject.parent
	
	while parent do
		table.insert(parent.dependencies, startingMockObject)
		parent = parent.parent
	end
	
end

local function markDependency(startingMockObject)
	
	local parent = startingMockObject
	
	while parent do
		parent.didDependencyChange = true
		
		parent.codeChanged:Fire(startingMockObject)
		parent = parent.parent
	end
	
end

local function NewMock(source: LuaSourceContainer, existingCache)
	
	local cache = existingCache or {}
	local self = setmetatable({
		className = "Mock",
		dependencies = {},
		
		parent = nil,
		
		source = source,
		
		didSourceChange = false,
		didDependencyChange = false,
		
		codeChanged = Signal.new(),
		
		_value = nil
		
	}, Mock)
	
	-- If the source has been changed, set didSourceChange to true
	source.Changed:Connect(function()
		self.didSourceChange = true
		markDependency(self)
	end)
	
	local function alternateRequire(source: ModuleScript)
		assert(typeof(source) == "Instance", "Attempt to call require with invalid argument(s)")
		assert(source.ClassName == "ModuleScript", "Attempt to call require with invalid argument(s)")
		
		if cache[source] then
			return cache[source]:get()
		else
			local mock = NewMock(source, cache)
			mock.parent = self
			
			addDependency(mock)
			cache[source] = mock
			
			return cache[source]:run()
		end
	end
	
	self._alternateRequire = alternateRequire
	
	return self
	
end

function Mock:run()
	self.didSourceChange = false
	self.didDependencyChange = false
	self.dependencies = {}
	
	
	local callback = loadstring(self.source.Source)
	local envCallback = getfenv(callback)
	
	envCallback.script = self.source
	envCallback.require = self._alternateRequire
	
	local success, result = pcall(callback)
	return success, result
	
end

-- Retrieves the last results or gets new ones if outdated
function Mock:get()
	
	if self.didSourceChange or self.didDependencyChange then
		self:run()
		
	end
	
	return self._value
	
end


return {
	new = NewMock
}