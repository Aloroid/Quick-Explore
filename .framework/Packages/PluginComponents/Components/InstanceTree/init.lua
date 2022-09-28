--[[
	InstanceTree;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local List = require(Components.List)
local InstanceButton = require(script.InstanceButton)

local Statify = Util.Statify
local Theme = Util.Theme
local quickInsert = Util.quickInsert
local quickRemove = Util.quickRemove
local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"Instances",
	"MultipleSelections",
	"Selected",
	
	"OnRightClick"
	
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type InstanceTree = {
	
	Instances: {Instance},
	MultipleSelections: Fusion.CanBeState<boolean>?,
	Selected: Fusion.Value<{Instance?}>?,
	
	OnRightClick: ( () -> nil )?,
	
	[any]: any
	
}

local function InstanceTree(props: InstanceTree)
	
	local selectedTree = Statify(props.Selected or {})
	local instances = props.Instances
	local newInstanceTable = table.create(1000000) -- Pre-allocate 1 million for incredibly fast expansion and such
	
	local renderTree = Value(newInstanceTable)
	local paddingTree = Value({})
	local expandedTree = Value({})
	
	local isShiftDown = false
	local isControlDown = false
	
	-- Expands the Instance Tree for the index
	local function expand(index: number)
		
		local render = unwrap(renderTree)
		local padding = unwrap(paddingTree)
		local expanded = unwrap(expandedTree)
		
		local instance = render[index]
		
		-- Make sure that the instance is in the render-tree. If we can't
		-- find the Instance then we can't do anything.
		if instance == nil then return end
		
		local instancePadding = padding[instance] or 0
		local children = instance:GetChildren()
		
		if #children == 0 then return end
		expanded[instance] = true
		
		quickInsert(render, children, index + 1)
		
		-- Go through all new instances and check if they need to be expanded and set their padding.
		-- If yes, then expand the Instance.
		for childIndex, child in children do
			padding[child] = instancePadding + 1
			
			if not expanded[child] then continue end
			expand(index + childIndex)
			
		end
		
		-- Set the (now updated) trees so that everything updates.
		renderTree:set(render, true)
		paddingTree:set(padding, true)
		expandedTree:set(expanded, true)
		
	end
	
	-- Collapses the Instance Tree for the index
	local function collapse(index: number)
		
		local render = unwrap(renderTree)
		local padding = unwrap(paddingTree)
		local expanded = unwrap(expandedTree)
		
		local instance = render[index]
		local instancePadding = padding[instance] or 0
		
		-- Make sure that the instance is in the render-tree. If we can't
		-- find the Instance then we can't do anything.
		if instance == nil then return end
		if expanded[instance] == nil then return end
		
		expanded[instance] = nil
		
		local lastIndex = #render
		
		-- Find the next instance with the same (or less) padding
		for otherIndex = index + 1, #render do
			local element = render[otherIndex]
			local otherInstancePadding = padding[element] or 0
			
			if instancePadding >= otherInstancePadding then
				lastIndex = otherIndex
				break
			end
			
		end
		
		quickRemove(render, index + 1, lastIndex - index - 1)
		
		-- Set the (now updated) trees so that everything updates.
		renderTree:set(render, true)
		paddingTree:set(padding, true)
		expandedTree:set(expanded, true)
		
	end
	
	-- We've swapped the system for Select to be O(1) read rather than O(1) selection.
	-- This is done because we are reading a lot more data when scrolling, and while
	-- table.find is alright it's O(n) which won't do when dealing with extremely
	-- large selections especially the farther down you go.
	-- We could technically optimize this to be O(log n) by having the Array be sorted BUT
	-- after checking with some very basic benchmarks
	local firstIndexInstance = nil
	local selectedWithShift = nil
	
	local function select(index: number)
		
		local render = unwrap(renderTree)
		local selected = unwrap(selectedTree)
		
		local instance = render[index]
		local firstIndex = table.find(render, firstIndexInstance)
		
		if isShiftDown and firstIndex then
			
			-- Unselects any other element that has been selected through the shift function
			if selectedWithShift then
				for _, element in selectedWithShift do
					selected[element] = nil
					
				end
				
			end
			
			local toIterateWith = if firstIndex < index then 1 else -1
			
			selectedWithShift = table.create(math.abs(firstIndex - index))
			
			for i = firstIndex, index, toIterateWith do
				local element = render[i]
				
				if selected[element] == nil then
					table.insert(selectedWithShift, element)
					
				end
				
				selected[element] = true
				
			end
			
		elseif isControlDown then
			firstIndexInstance = instance
			selectedWithShift = nil
			
			selected[instance] = not selected[instance] or nil
			
		else
			firstIndexInstance = instance
			selectedWithShift = nil
			
			selected = {[instance] = true}
			
		end
		
		selectedTree:set(selected, true)
		
	end
	
	local function inputBegan(input: InputObject)
		
		if input.KeyCode == Enum.KeyCode.Escape then
			selectedTree:set({})
			
		elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			isShiftDown = true
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			isControlDown = true
			
		end
		
	end
	
	local function inputEnded(input: InputObject)
		
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			isShiftDown = false
			
		elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			isControlDown = false
			
		end
		
	end
	
	for _, instance in instances do
		
		-- DescendantAdded will add the instance to the render tree.
		instance.DescendantAdded:Connect(function(child: Instance)
			local parentChild = child.Parent
			local expanded = unwrap(expandedTree)
			local index = table.find(unwrap(renderTree), parentChild)
			
			if expanded[parentChild] == true then
				collapse(index)
				expand(index)
			end
			
			renderTree:set(unwrap(renderTree), true) -- trigger a update on everything.
			
		end)
		
		-- DescendantRemoving will remove the instance from the render tree
		instance.DescendantRemoving:Connect(function(child: Instance)
			local parentChild = child.Parent
			local expanded = unwrap(expandedTree)
			local index = table.find(unwrap(renderTree), parentChild)
			
			if expanded[parentChild] == true then
				collapse(index)
				task.defer(expand, index)
			end
			
			renderTree:set(unwrap(renderTree), true) -- trigger a update on everything.
		end)
		
		table.insert(newInstanceTable, instance)
	end
	
	local InstanceTree = List {
		
		MinItems = 1,
		MaxItems = Computed(function() return #unwrap(renderTree) end),
		ItemSize = 18,
		
		StreamIn = function(index: Value<number>)
			
			return InstanceButton {
				
				Tree = renderTree,
				Padding = paddingTree,
				Expanded = expandedTree,
				Selected = selectedTree,
				
				Index = index,
				
				OnExpand = function()
					local expanded = unwrap(expandedTree)
					local render = unwrap(renderTree)
					local currentIndex = unwrap(index)
					
					if expanded[render[currentIndex] or 1] then
						collapse(currentIndex)
					else
						expand(currentIndex)
					end
				end,
				OnSelect = select,
				
				[OnEvent "InputBegan"] = inputBegan,
				[OnEvent "InputEnded"] = inputEnded,
				
				[OnEvent "MouseButton2Down"] = props.OnRightClick
				
			}
			
		end,
		
		[OnEvent "InputBegan"] = inputBegan,
		[OnEvent "InputEnded"] = inputEnded
		
	}
	
	return Hydrate(InstanceTree)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return InstanceTree