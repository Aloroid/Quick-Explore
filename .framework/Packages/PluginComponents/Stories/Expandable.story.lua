local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local Expandable = require(Components.Expandable)
local Button = require(Components.Button)
local Image = require(Components.Image)
local Padding = require(Components.UIPadding)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Children = Fusion.Children

return function(target)
	
	local expanded = Value(true)
	local isRunning = true
	
	local object = Expandable {
		Parent = target,
		
		BackgroundTransparency = 0.5,
		
		Expanded = expanded,
		[Children] = {
			
			New "UIListLayout" {
				Padding = UDim.new(0, 16)
			},
			
			Padding {
				XPadding = UDim2.fromOffset(4, 4),
				YPadding = UDim2.fromOffset(4, 4)
			},
			
			Button {
				Parent = target,
				
				Text = "Hello World!",
				
				[OnEvent "Activated"] = function()
					print("Hoihoi!")
				end
			},
			
			Button {
				Parent = target,
				
				Text = "Disabled",
				Disabled = true,
				
				[OnEvent "Activated"] = function()
					print("Hoihoi!")
				end
			},
			
			Button {
				Parent = target,
				
				Text = "Selected!",
				Selected = true,
				
				[OnEvent "Activated"] = function()
					print("Hoihoi!")
				end
			},
			
			Button {
				Parent = target,
				
				Text = "with Image",
				
				[Children] = Image {
					Image = "rbxasset://textures/StudioSharedUI/search.png",
					Size = UDim2.fromOffset(12, 12)
					
				}
				
			}
			
		}
	}
	
	task.spawn(function()
		while isRunning do
			task.wait(3)
			expanded:set(not expanded:get())
		end
		
	end)
	
	return function()
		object:Destroy()
		isRunning = false
		
	end
end