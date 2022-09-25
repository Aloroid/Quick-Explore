local Benchmark = {}
Benchmark.__index = Benchmark

export type Benchmark = {
	results: {number},
	totalElapsedTime: number
	
}

local function NewBenchmark(): Benchmark
	
	local self = setmetatable({
		className = "Benchmark",
		
		results = {},
		totalElapsedTime = 0
		
	}, Benchmark)
	
	return self
	
end

--[[
	Records a result and adds it to the list
	
]]
function Benchmark:_record(result: number)
	self.totalElapsedTime += result
	table.insert(self.results, result)
	
end

return NewBenchmark

