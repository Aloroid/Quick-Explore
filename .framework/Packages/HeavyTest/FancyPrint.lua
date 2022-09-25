--[[
	Prints the provided results in a fancy manner :3

	
]]

local function logErrorNonFatal(message)
	task.spawn(error, message, 0)
end

local function fancyPrint(results)
	
	-- Directories
	for directoryName: string, testFiles in results do
		
		print("📁", directoryName)
		
		for testFileName, testFile in testFiles do
			print("\t📜", testFileName)
			
			local function smallerFancyPrint(t, indents: number)
				
				for testName, data in t do
					if data.className == "Result" then
						local success = data.success
						local didSkip = data.didSkip
						local didError = data.didError
						
						local icon = if didSkip then utf8.char(10144) elseif success then utf8.char(10004) else utf8.char(10006)
						local extraData = if success and not didSkip then string.format(": %0.1f μs", data.benchmark.totalElapsedTime * 1e6) else ""
						local toPrint = string.format("%s%s %s%s", string.rep("\t", indents+2), icon, testName, extraData)
						
						
						
						if didError then
							logErrorNonFatal(toPrint)
							if data.errorMessage then
								logErrorNonFatal(string.rep("\t", indents+3).." "..data.errorMessage)
							end
						elseif didSkip and data.skipMessage then
							print(toPrint)
							if data.skipMessage then
								print(string.rep("\t", indents+3),data.skipMessage)
							end
						else
							print(toPrint)
						end
						
					else
						print( string.format("%s▪  %s", string.rep("\t", indents+2), testName ))
						smallerFancyPrint(data, indents+1)
						
					end
					
				end
				
			end
			
			smallerFancyPrint(testFile, 0)
			
		end
		
	end
	
end

return fancyPrint
