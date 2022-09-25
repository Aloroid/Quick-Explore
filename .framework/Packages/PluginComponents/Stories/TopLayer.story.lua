
local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local TopLayer = require(Components.TopLayer)
local ExpandablePane = require(Components.ExpandablePane)
local TextLabel = require(Components.TextLabel)
local Button = require(Components.Button)

local New = Fusion.New
local Children = Fusion.Children

return function(target)
	
	local object = New "Frame" {
		Parent = target,
		
		Size = UDim2.new(1, -16, 1, -16),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		
		BackgroundTransparency = 1,
		
		[Children] = {
			
			New "UIListLayout" {
				Padding = UDim.new(0, 8)
			},
			
			ExpandablePane {
				Parent = target,
				
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				
				CategoryText = "This is a message!",
				[Children] = {
					
					TextLabel {
						Text = "This comes with text!"
						
					},
					
					Button {
						Text = "B"
					},
					
					New "UIListLayout" {
						Padding = UDim.new(0, 8)
						
					}
					
				}
				
			},
			
			ExpandablePane {
				Parent = target,
				
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				
				[Children] = {
					
					TextLabel {
						Text = "This one is without Text"
						
					},
					
					TopLayer {
						[Children] = Button {
							Position = UDim2.fromOffset(0, 64),
							Text = "Button"
						}
					},
					
					New "UIListLayout" {
						Padding = UDim.new(0, 8)
						
					}
					
				}
				
			}
			
		}
		
	}
	
	return function()
		object:Destroy()
		
	end
end