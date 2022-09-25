--[[
	InstanceTree;
	The InstanceTree is a Component unwrapd to display a list of Instances easily.
	It's speed is even faster than Roblox's built-in explorer due to using streaming technology while memory consumption is barely even touched.
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local ClassIcon = require(Components.ClassIcon)
local List = require(Components.List)
local Button = require(Components.Button)
local Image = require(Components.ImageButton)

local Theme = Util.Theme
local Statify = Util.Statify
local quickInsert = Util.quickInsert
local quickRemove = Util.quickRemove
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local ITEM_SIZE = 18
local FALLBACK = Instance.new("Folder")
FALLBACK.Name = "FALLBACK, DON'T LOOK"

local COMPONENT_ONLY_PROPERTIES = {
	"Instances",
	"MultipleSelections",
	"Selected"
	
}

export type InstanceTree = {
	
	Instances: {Instance},
	MultipleSelections: Fusion.CanBeState<boolean>?,
	Selected: Fusion.Value<{Instance?}>?,
	
	[any]: any
}

local function InstanceTree(props: InstanceTree)
	
	local selected = Statify(props.Selected or {})
	local multipleSelectable = props.MultipleSelections
	
	local renderedElements = Value(table.clone(props.Instances))
	local expandedInstanceTree = Value({})
	local paddingInstanceTree = Value({})
	local isControlDown = false
	local isShiftDown = false
	
	local firstIndex
	local selectedWithShift = {}
	
	-- TODO: Refactor Select
	local function select(currentInstance)
		
		local tree = unwrap(renderedElements)
		
		if unwrap(multipleSelectable) then
			
			if isShiftDown and firstIndex ~= nil then
				
				local currentSelected = unwrap(selected)
				
				local lastIndex = table.find(tree, currentInstance)
				local firstIndex = firstIndex
				-- Swap it if it's too high
				if firstIndex > lastIndex then
					firstIndex, lastIndex = lastIndex, firstIndex
				end
				
				for _, element in selectedWithShift do
					table.remove(currentSelected, table.find(currentSelected, element))
					
				end
				table.clear(selectedWithShift)
				
				for i = firstIndex, lastIndex do
					
					if not table.find(currentSelected, tree[i]) then
						table.insert(currentSelected, tree[i])
						table.insert(selectedWithShift, tree[i])
					end
					
				end
				
				selected:set(currentSelected, true)
				
			elseif isControlDown then
				local copy = unwrap(selected)
				selectedWithShift = {}
				
				firstIndex = table.find(tree, currentInstance)
				
				table.insert(copy, currentInstance)
				selected:set(copy, true)
				
			else
				
				selectedWithShift = {}
				firstIndex = table.find(tree, currentInstance)
				selected:set({currentInstance})
			end
			
		else
			selected:set({currentInstance})
						
		end
		
	end
	
	local function expand(index: number, willExpand: boolean?)
		
		local InstanceTree = unwrap(renderedElements)
		local expanded = unwrap(expandedInstanceTree)
		local padding = unwrap(paddingInstanceTree)
		
		local element = InstanceTree[index]
		
		local startIndex = index + 1
		local children = element:GetChildren()
		local currentPadding = padding[element] or 0
		
		if willExpand == true or expanded[element] == nil and willExpand ~= false then
			
			-- Moves all the elements in the InstanceTree up so that we have enough room to insert the elements
			-- from the children into the InstanceTree
			quickInsert(InstanceTree, children, startIndex)
			expanded[element] = true
			
			for i, child in children do
				padding[child] = currentPadding + 1
				
				if expanded[child] then
					expand(table.find(InstanceTree, child, index), true)
					
				end
			end
			
		else
			
			expanded[element] = nil
			
			-- We need to figure out the last index inside the InstanceTree.
			-- Let's first figure out the last child
			local lastChild = children[#children]
			local lastChildIndex = table.find(InstanceTree, lastChild, startIndex)
			local lastIndex = lastChildIndex
			
			if expanded[lastChildIndex] then
				
				for i = lastChildIndex, #InstanceTree do
					local otherElement = InstanceTree[i]
					
					if padding[otherElement] == padding[element] then
						padding[otherElement] = nil
						lastIndex = i
						break
					end
					padding[otherElement] = nil
					
				end
				
				if lastIndex == lastChildIndex then
					lastIndex = #InstanceTree
				end
				
			end
			
			quickRemove(InstanceTree, startIndex, lastChildIndex - startIndex + 1)
			
		end
		
		renderedElements:set(InstanceTree, true)
		expandedInstanceTree:set(expanded, true)
		paddingInstanceTree:set(padding, true)
		
	end
	
	local InstanceTree = List {
		
		MinItems = 1,
		MaxItems = Computed(function() return #unwrap(renderedElements) end),
		ItemSize = ITEM_SIZE,
		
		StreamIn = function(index)
			
			local element = Computed(function()
				return unwrap(renderedElements)[index] or FALLBACK
			end)
			local expandable = Computed(function()
				return #unwrap(element):GetChildren() > 0
			end)
			local isSelected = Computed(function()
				return table.find(unwrap(selected), unwrap(element)) ~= nil
			end)
			
			return Button {
				
				Name = Computed(function() return unwrap(element).Name end),
				
				Size = UDim2.new(1, 0, 0, ITEM_SIZE),
				Position = UDim2.fromOffset(0, (index - 1) * ITEM_SIZE),
				
				BackgroundColor = Enum.StudioStyleGuideColor.Item,
				BorderColor = Enum.StudioStyleGuideColor.Item,
				
				Selected = isSelected,
				
				TextSize = 14,
				Text = Computed(function() return unwrap(element).Name end),
				
				XPadding = Computed(function()
					return UDim2.fromOffset((unwrap(paddingInstanceTree)[unwrap(element)] or 0) * 20, 0)
				end),
				YPadding = UDim2.new(),
				
				[OnEvent "Activated"] = function() select(unwrap(element)) end,
				[OnEvent "MouseButton2Down"] = function() select(unwrap(element)) end,
				[Children] = {
					
					Image {
						
						Size = UDim2.fromOffset(16, 16),
						
						Image = Computed(function()
							local isexpanded = unwrap(expandedInstanceTree)[unwrap(element)]
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
							expand(index)
							
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
			
		end,
		
		[OnEvent "InputBegan"] = function(input: InputObject)
			
			if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
				isControlDown = true
			elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
				isShiftDown = true
			elseif input.KeyCode == Enum.KeyCode.Escape then
				selected:set({})
			end
			
		end,
		
		[OnEvent "InputEnded"] = function(input: InputObject)
			
			if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
				isControlDown = false
			elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
				isShiftDown = false
			end
			
		end
		
	}
	
	return Hydrate(InstanceTree)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return InstanceTree