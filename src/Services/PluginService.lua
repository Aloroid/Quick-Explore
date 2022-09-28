--TODO: Refactor this code.
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local PluginCode = script.Parent.Parent
local plugin = PluginCode:FindFirstAncestorWhichIsA("Plugin")

local HeavyFramework = require(PluginCode.HeavyFramework)

local Packages = HeavyFramework.Packages

local Fusion = require(Packages.Fusion)
local PluginComponents = require(Packages.PluginComponents)
local CameraService = require(script.Parent.CameraService)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Observer = Fusion.Observer

local InstanceTree = PluginComponents.InstanceTree
local Checkbox = PluginComponents.Checkbox
local Border = PluginComponents.Border
local Background = PluginComponents.Background
local TextLabel = PluginComponents.TextLabel

local PluginService = {}
local ServicesNames = {
	"Workspace",
	"Players",
	"Lighting",
	"CoreGui",
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
local Services = {}
local Selected = Value({})

for _, service in ServicesNames do
	table.insert(Services, game:GetService(service))
	
end

function PluginService:Init()
	
	local DockWidget = plugin:CreateDockWidgetPluginGui("DockWidget", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 300, 200, 300))
	local Toolbar = plugin:CreateToolbar("QuickExplore")
	local Button = Toolbar:CreateButton("b", "Opens Quick Explorer", "", "Open Quick Explorer")
	local PluginMenu = plugin:CreatePluginMenu("Menu", "Quick Actions")
	local disableSelection = Value(false)
	
	DockWidget.Name = "QuickExplorer"
	DockWidget.Title = "Quick Explorer"
	
	PluginMenu:AddNewAction("Duplicate", "Duplicate").Triggered:Connect(function()
		ChangeHistoryService:SetWaypoint("Duplicating")
		local copies = {}
		for inst in Selected:get() do
			local copy = inst:Clone()
			copy.Parent = inst.Parent
			copies[copy] = true
		end
		Selected:set(copies)
		ChangeHistoryService:SetWaypoint("Duped")
	end)
	PluginMenu:AddNewAction("Delete", "Delete").Triggered:Connect(function()
		ChangeHistoryService:SetWaypoint("Deleting")
		for object in Selected:get() do
			object.Parent = nil
		end
		ChangeHistoryService:SetWaypoint("Deleted")
	end)
	PluginMenu:AddSeparator()
	PluginMenu:AddNewAction("ZoomTo", "Zoom To").Triggered:Connect(function()
		CameraService:lookAtObject(Selected:get()[1])
		
	end)
	PluginMenu:AddSeparator()
	PluginMenu:AddNewAction("Insert", "Insert Part").Triggered:Connect(function()
		ChangeHistoryService:SetWaypoint("Inserting Part")
		local copies = {}
		for inst in Selected:get() do
			local copy = Instance.new("Part")
			copy.Parent = inst
			
			copies[copy] = true
		end
		Selected:set(copies)
		ChangeHistoryService:SetWaypoint("Inserted")
	end)
	PluginMenu:AddSeparator()
	PluginMenu:AddNewAction("SaveToFile", "Save to File").Triggered:Connect(function()
		
		local newSelectionArray = table.create(1000)
		for inst in Selected:get() do
			table.insert(newSelectionArray, inst)
			
		end
		
		Selection:Set(newSelectionArray)
		plugin:PromptSaveSelection()
	end)
	PluginMenu:AddNewAction("SaveToRoblox", "Save to Roblox").Triggered:Connect(function()
		
		local newSelectionArray = table.create(1000)
		for inst in Selected:get() do
			table.insert(newSelectionArray, inst)
			
		end
		Selection:Set(newSelectionArray)
		
		plugin:SaveSelectedToRoblox()
	end)
	
	-- USER INTERFACE
	Background {
		
		Parent = DockWidget,
		
		[Children] = {
			
			InstanceTree {
				
				Size = UDim2.new(1, 0, 1, -24),
				
				Instances = Services,
				Selected = Selected,
				MultipleSelections = true,
				
				OnRightClick = function()
					PluginMenu:ShowAsync()
				end
			},
			
			Background {
				
				Size = UDim2.new(1, 0, 0, 24),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				
				[Children] = {
					
					Border {},
					New "UIListLayout" {
						
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						
						Padding = UDim.new(0, 6)
						
					},
										
					TextLabel {
						
						Text = "Disable Selection (better performance)"
						
					},
					
					Checkbox {
						
						Value = disableSelection
						
					}
					
				}
				
			}
			
		}
		
	}
	
	Button:SetActive(DockWidget.Enabled)
	Button.Click:Connect(function()
		DockWidget.Enabled = not DockWidget.Enabled
		Button:SetActive(DockWidget.Enabled)
	end)
	
	Observer(Selected):onChange(function()
		if #Selected:get() > 0 then
			DockWidget.Title = string.format("Quick Explorer (%i selected)", #Selected:get())
		else
			DockWidget.Title = "Quick Explorer"
		end
		
		if disableSelection:get() == false then
			Selection:set(Selected:get())
		end
	end)
	
end

return PluginService