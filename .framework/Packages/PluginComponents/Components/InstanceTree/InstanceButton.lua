--[[
	InstanceButton;
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local ClassIcon = require(Components.ClassIcon)
local Button = require(Components.Button)
local Image = require(Components.ImageButton)

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local FALLBACK = Instance.new("Folder")
FALLBACK.Name = "FALLBACK, DON'T LOOK"

local COMPONENT_ONLY_PROPERTIES = {
	"Index",
	"Tree",
	"Padding",
	"Expanded",
	"Selected",
	"OnExpand",
	"OnSelect"
	
}

type Value<T> = Fusion.Value<T>
export type InstanceButton = {
	
	Index: Value<number>,
	
	Tree: Value<{Instance}>,
	Padding: Value<{[Instance]: number}>,
	Expanded: Value<{[Instance]: boolean?}>,
	Selected: Value<{Instance}>,
	
	OnSelect: (index: number) -> nil,
	OnExpand: (index: number) -> nil,
	
	[any]: any
}

local function InstanceButton(props: InstanceButton)
	
	local index = props.Index
	
	local renderTree = props.Tree
	local padding = props.Padding
	local expanded = props.Expanded
	local selected = props.Selected
	
	local expand = props.OnExpand
	local select = props.OnSelect
	
	local name = Value("")
	local expandable = Value(false)
	local temporaryConnectionName
	local temporaryConnectionChildAdded
	local temporaryConnectionChildRemoved
	
	-- This function will get the instance but also all kinds of related data to it.
	-- When the instance changes, we will get the name and expandable and then create
	-- connections which will change those.
	local element = Computed(function()
		local instance = unwrap(renderTree)[unwrap(index)] or FALLBACK
		
		name:set(instance.Name)
		expandable:set(#instance:GetChildren() > 0)
		
		if instance == FALLBACK then return instance end
		if temporaryConnectionName then temporaryConnectionName:Disconnect() end
		if temporaryConnectionChildAdded then temporaryConnectionChildAdded:Disconnect() end
		if temporaryConnectionChildRemoved then temporaryConnectionChildRemoved:Disconnect() end
		
		temporaryConnectionName = instance:GetPropertyChangedSignal("Name"):Connect(function()
			name:set(instance.Name)
		end)
		
		temporaryConnectionChildAdded = instance.ChildAdded:Connect(function()
			expandable:set(true)
		end)
		
		temporaryConnectionChildRemoved = instance.ChildRemoved:Connect(function()
			expandable:set(#instance:GetChildren() > 0)
		end)
		
		return instance
	end)
	
	local isSelected = Computed(function()
		return unwrap(selected)[unwrap(element)]
		
	end)
	
	local InstanceButton = Button {
		
		Name = index,
		
		Size = UDim2.new(1, 0, 0, 18),
		Position = Computed(function()
			return UDim2.fromOffset(0, (unwrap(index)-1) * 18)
		end),
		
		BackgroundColor = Enum.StudioStyleGuideColor.Item,
		BorderColor = Enum.StudioStyleGuideColor.Item,
		
		Selected = isSelected,
		
		TextSize = 14,
		Text = name,
		
		Visible = Computed(function() return unwrap(element) ~= FALLBACK end),
		
		XPadding = Computed(function()
			return UDim2.fromOffset((unwrap(padding)[unwrap(element)] or 0) * 20, 0)
		end),
		YPadding = UDim2.new(),
		
		[OnEvent "MouseButton1Down"] = function() select(unwrap(index)) end,
		[OnEvent "MouseButton2Down"] = function()
			if unwrap(isSelected) ~= true then select(unwrap(index)) end
		end,
		
		[Children] = {
			
			Image {
				
				Size = UDim2.fromOffset(16, 16),
				
				Image = Computed(function()
					local isexpanded = unwrap(expanded)[unwrap(element)]
					local themeName = unwrap(Theme()).Name
					
					if isexpanded then
						return "rbxasset://textures/ManageCollaborators/arrowDown_"..themeName:lower()..".png"
					else
						return "rbxasset://textures/ManageCollaborators/arrowRight_"..themeName:lower()..".png"
					end
					
				end),
				
				ImageTransparency = Computed(function()
					return if unwrap(expandable) then 0 else 1
				end),
				Active = expandable,
				
				[OnEvent "Activated"] = function()
					expand(unwrap(index))
					
				end
				
			},
			
			ClassIcon {
				
				Size = UDim2.fromOffset(16, 16),
				
				ClassName = Computed(function()
					return unwrap(element).ClassName
				end)
			}
			
		}
	}
	
	return Hydrate(InstanceButton)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return InstanceButton