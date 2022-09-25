--[[
	quickRemove
	quickRemove is a function that can quickly remove tons of elements from a table while preserving the order.
		
]]

local function quickRemove(src: {[any]: any}, startIndex, totalItems)

	local lastIndex = startIndex + totalItems
	local totalOther = #src - lastIndex

	table.move(src, lastIndex, #src, startIndex)
	table.move({}, 1, math.max(totalOther, totalItems), startIndex + totalOther + 1, src)

end

return quickRemove
