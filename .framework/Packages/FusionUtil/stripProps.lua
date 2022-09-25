--[[
	Strips properties
	
]]

local function stripProps(props: {[string]: any}, toStrip: {string})
	local copy = table.clone(props)
	
	for _, key in toStrip do
		copy[key] = nil
		
	end
	
	return copy
	
end

return stripProps
