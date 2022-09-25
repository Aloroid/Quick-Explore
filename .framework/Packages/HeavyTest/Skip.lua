--[[
	Skip is used to skip a test. (no way!)
	
]]

local Package = script.Parent

local SharedState = require(Package.SharedState)

local function Skip(reasoning: string?)
	
	SharedState.result.didSkip = true
	SharedState.result.skipMessage = reasoning
	
	-- how am i supposed to tell the Tester that it skipped
	error(string.pack("s", "skipskip!!11256"), 0) -- found a way out, special key error. i hope nobody collides this
	
end

return Skip
