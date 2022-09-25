local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local Button = require(Components.Button)
local Image = require(Components.Image)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(target)
	
	local object = New "Folder" {
		Parent = target,
		
		[Children] = {
			
			New "UIListLayout" {
				Padding = UDim.new(0, 16)
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
	
	return function()
		object:Destroy()
		
	end
end