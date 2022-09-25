local Package = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local InstanceTree = require(Components.InstanceTree)

local services = {
	"Workspace",
	"Players",
	"Lighting",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
	"Teams",
	"SoundService",
	"Chat",
	"TextChatService",
	"LocalizationService",
	"TestService"
	
}

return function(target)
	
	local servicesInstances = {}
	
	for _, service in services do
		table.insert(servicesInstances, game:GetService(service))
		
	end
	
	local object = InstanceTree {
		Parent = target,
		
		Instances = servicesInstances,
		MultipleSelections = false
	}
	
	return function()
		object:Destroy()
		
	end
end