local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local ScrollingFrame = require(Components.ScrollingFrame)
local Button = require(Components.Button)

local New = Fusion.New
local Children = Fusion.Children

return function(target)
	
	local t = {}
	for i = 1, 100 do
		table.insert(t, Button {Text = 'Hii!'})
	end
	
	local object = ScrollingFrame {
		Parent = target,
		
		[Children] = {
			
			New "UIListLayout" {
				Padding = UDim.new(0, 6)
			},
			t
			
		}
	}
	
	return function()
		object:Destroy()
		
	end
end