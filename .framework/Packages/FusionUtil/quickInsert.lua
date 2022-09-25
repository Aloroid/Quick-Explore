--[[
	quickInsert
	quickInsert is a function that can quickly remove tons of elements from a table while preserving the order.
		
]]

local function quickInsert(src: {[any]: any}, items: {[any]: any}, index: number)

	table.move(src, index, #src, index + #items)
	table.move(items, 1, #items, index, src)

end

return quickInsert
