local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)

local Background = require(Components.Background)
local Tooltip = require(Components.Tooltip)
local Button = require(Components.Button)
local Image = require(Components.Image)

local Children = Fusion.Children

return function(target)
	
	local object = Background {
		
		Parent = target,
		
		[Children] = {
			
			Button {
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),
				
				Text = "Hover over me!",
				
				[Children] = Tooltip {
					Tooltip = "Hello everyone!"
					
				}
				
			},
			
			Button {
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				
				Text = "Hover over me too!",
				
				[Children] = Tooltip {
					Tooltip = "I also can do <b>rich<font color='#0098FF'>text</font></b> <font size='50'>Look how large I am!</font>",
					RichText = true
					
				}
				
			},
			
			Button {
				Position = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(1, 1),
				
				Text = "Hover over me",
				
				[Children] = Tooltip {
					Tooltip = "I even have support for images!",
					
					[Children] = Image {
						Image = "rbxasset://textures/explosion.png",
						Size = UDim2.fromOffset(64, 64)
						
					}
					
				}
			},
			
			Button {
				
				Text = "Hover over me",
				
				[Children] = Tooltip {
					Tooltip = "I even have support for images!",
					
					[Children] = Image {
						Image = "rbxasset://textures/explosion.png",
						Size = UDim2.fromOffset(64, 64)
						
					}
					
				}
			}
			
		}
		
	}
	
	return function()
		object:Destroy()
		
	end
end