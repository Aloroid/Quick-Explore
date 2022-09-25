
local Package = script.Parent

local Test = require(Package.Test)
local Benchmark = require(Package.Benchmark)
local SharedState = require(Package.SharedState)

local SKIP = string.pack("s", "skipskip!!11256") -- special key used to identify a skip

type Test = Test.Test
type Benchmark = Benchmark.Benchmark

export type Result = {
	className: "Result",
	
	success: boolean,
	didError: boolean,
	didSkip: boolean,
	
	errorMessage: string?,
	skipMessage: string?,
	
	benchmark: Benchmark,
	test: Test
}


local Result = {}
Result.__index = Result

local function empty()
	
end

local function NewResult(test: Test, testingTable: {[string]: any}?)
	
	-- Get defining functions
	local beforeEach = empty
	local afterEach = empty
	
	if testingTable then
		beforeEach = testingTable["$beforeEach"] or empty
		afterEach = testingTable["$afterEach"] or empty
	end
	
	local isFinished = false
	local newBenchmark = Benchmark()
	local self = setmetatable({
		className = "Result",
		
		success = true,
		didSkip = false,
		didError = false,
		
		errorMessage = nil,
		skipMessage = nil,
		
		benchmark = newBenchmark,
		test = test
		
	}, Result)
	
	SharedState.result = self
	
	-- This will run over 5 seconds, check if the test has finished and if not report a error
	task.delay(5, function()
		if isFinished == false then
			warn("Are you sure that this test is gonna finish? Test Affected:", test.source.Name.."[\""..test.name.."\"]")
			
		end
		
	end)
	
	beforeEach()
	local startTime = os.clock()
	local success, result = pcall(test.callback)
	local endTime = os.clock()
	
	newBenchmark:_record(endTime - startTime)
	afterEach()
	
	if success == false and result ~= SKIP then
		self.success = false
		self.didError = true
		self.errorMessage = result
	end
	isFinished = true
	
	return self
	
end

return NewResult