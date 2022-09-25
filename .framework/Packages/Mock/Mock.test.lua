local Mock = require(script.Parent)

local Source = script.Parent.TestUsage

return {
	
	["Constructor"] = {
		
		["should create a new Mock Object"] = function(check)
			local mockObject = Mock.new(Source.NoDependency)
			
			check(mockObject, "MockObject not returned")
			
		end
		
	},
	
	["Run"] = {
		
		["should run succesfully"] = function(check)
			local mockObject = Mock.new(Source.NoDependency)
			local success, result = mockObject:run()
			
			check(success, result)
			
		end
		
	},
	
	["Dependencies"] = {
		
		["should capture dependency"] = function(check)
			
			local mockObject = Mock.new(Source.MultipleDependencies)
			local success, result = mockObject:run()
			
			check(success, result)
			check(#mockObject.dependencies == 2, "MockObject did not capture all dependencies, only "..#mockObject.dependencies.." captured")
			
		end,
		
		["should detect dependency change"] = function(check)
			
			local mockObject = Mock.new(Source.MultipleDependencies)
			local success, result = mockObject:run()
			
			check(success, result)
			check(#mockObject.dependencies == 2, "MockObject did not capture all dependencies, only "..#mockObject.dependencies.." captured")
			
			Source.MultipleDependencies.Another.Source = "return "..math.random(1, 100000)
			task.wait()
			check(mockObject.didDependencyChange == true, "dependency change not detected")
			
		end
		
	},
	
	["Change"] = {
		
		["should detect change in source"] = function(check)
			
			local mockObject = Mock.new(Source.NoDependency)
			local success, result = mockObject:run()
			
			check(success, result)
			check(mockObject.didSourceChange == false, "source has been marked changed before being changed")
			
			Source.NoDependency.Source = "return "..math.random(1, 100000)
			task.wait()
			check(mockObject.didSourceChange == true, "source has not been marked as changed when changed")
			
		end,
		
		["should fire codeChanged when source changes"] = function(check)
			
			local mockObject = Mock.new(Source.NoDependency)
			local success, result = mockObject:run()
			
			check(success, result)
			
			task.defer(function()
				Source.NoDependency.Source = "return "..math.random(1, 100000)
			end)
			mockObject.codeChanged:Wait()
			
			
			
		end
		
	}
	
}