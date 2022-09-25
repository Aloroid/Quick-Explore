local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local List = require(Components.List)

local New = Fusion.New

return function(target)
	
	local object = List {
		Parent = target,
		
		ItemSize = 32,
		StreamIn = function(index: number)
			
			return New "TextLabel" {
				Name = string.format("%4d", index),
				
				Size = UDim2.new(1, 0, 0, 32),
				Position = UDim2.fromOffset(0, 32 * (index - 1)),
				
				Text = "Index "..index,
				Font = Enum.Font.SourceSans,
				
				BackgroundTransparency = 1
				
			}
			
		end
	}
	
	return function()
		object:Destroy()
		
	end
end