local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local Fusion = require(Package.Fusion)
local ClassIcon = require(Components.ClassIcon)
local Background = require(Components.Background)

local New = Fusion.New
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local Icons = {
	"Players",
	"Part",
	"Workspace",
	"ReplicatedStorage",
	"Folder",
	"Configuration",
	"Player"
	
}

return function(target)
	
	local object = Background {
		Parent = target,
		
		[Children] = {
			New "UIListLayout" {
				Padding = UDim.new(0, 6)
				
			},
			
			ForValues(Icons, function(className)
				return ClassIcon {
					ClassName = className
				}
				
			end, function(inst)
				inst:Destroy()
			end)
		}
		
	}
	
	return function()
		object:Destroy()
		
	end
end