--[[
	Heavytest is a testing module created to test the code of plugins. It also doubles as a
	benchmarker for benchmarking how performant code is running.
	While Heavytest is used internally, it can be used to test services similarly to TestEZ
	
	Heavytest does NOT use dependency-injection in order to avoid potential errors/warnings
	of non-existent globals (that get injected at run-time) unlike TestEZ.
	
	Heavytest in Interconnect will usually run on the Tests folder.
	
	To create a Test file with tests, make a .spec file (not needed if placed inside a Tests folder)
	and have it return a dictionary. It must be formatted in the following way:
	{
		
		["Describes Tests"] = {
			["checks if 1 + 1 equals 2"] = function(check, skip)
				check(1 + 1 == 2)
				
			end,
			
			["this test will skip"] = function(check, skip)
				skip("to demonstrate skips")
				
				check(1 * 2 == 2)
				
			end,
			
			["Dividing 2 by 2 should result in 1"] = function(check, skip)
				check(2 / 2 == 1)
				
			end)
		},
		
		
	}
	
	----
	
	
	
	API:
	
	type Test = {
		name: string,
		source: ModuleScript
		
		callback: (check, skip) -> nil,
		
	}
	
	type Benchmark = {
		results: {number},
		totalElapsedTime: number
		
	}
	
	type Result = {
		success: boolean,
		didError: boolean,
		didSkip: boolean,
		
		errorMessage: string?,
		skipMessage: string?,
		
		benchmark: Benchmark,
		test: Test
	}
	
	type Results = {
		[string]: Results | Result
	}
	
	type Configuration = {
		searchDescendants: boolean?,
		prefix: string? (searches for .spec files when unspecified)
		
	}
	
	HeavyTest.run(test: ModuleScript): Results
		Runs the provided tests and returns a table containing the information
		containing the results of that test
	
	HeavyTest.findAndRun(directories: {Instance}, config: Configuration?): Results
		Finds all the directories provided and runs all the test files inside
		those directories
	
	
	
	HeavyTest
	
]]

local HeavyTest = {
	run = require(script.Run),
	findAndRun = require(script.FindAndRun),
	fancyPrint = require(script.FancyPrint)
}


return HeavyTest