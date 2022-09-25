--[[
	Tree;
	The Tree is a Component unwrapd to display a list of Instances easily.
	It's speed is even faster than Roblox's built-in explorer due to using streaming technology while memory consumption is barely even touched.
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local List = require(Components.List)
local Button = require(Components.Button)
local Image = require(Components.Image)

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

local COMPONENT_ONLY_PROPERTIES = {
	"Elements",
	"MultipleSelections",
	"Selected"
	
}

export type Tree = {
	
	Elements: {
		{
			name: string,
			image: string,
			
			children: {}
		}
	},
	MultipleSelections: Fusion.CanBeState<boolean>?,
	Selected: Fusion.Value<{Instance?}>?,
	
	[any]: any
}

local function Tree(props: Tree)
	
	local selected = Statify(props.Selected or {})
	local multipleSelectable = props.MultipleSelections
	
	local renderedElements = Value({})
	local expandedTree = Value({})
	local paddingTree = Value({})
	
	local function expand(index: number)
		
		local tree = unwrap(renderedElements)
		local expanded = unwrap(expandedTree)
		local padding = unwrap(paddingTree)
		
		local element = tree[index]
		
		local startIndex = index + 1
		
		if expanded[element] then
			
			-- Moves all the elements in the tree up so that we have enough room to insert the elements
			-- from the children into the tree
			quickInsert(tree, element.children, startIndex)
			
		else
			
			-- We need to figure out the last index inside the tree.
			-- Let's first figure out the last child
			local lastChild = element.children[#element.children]
			local lastChildIndex = table.find(tree, startIndex, lastChild)
			local lastIndex = lastChildIndex
			
			if expanded[lastChildIndex] then
				
				for i = lastChildIndex, #tree do
					local otherElement = tree[i]
					
					if padding[otherElement] == padding[element] then
						lastIndex = i - 1
					end
					
					expanded[otherElement] = nil
					padding[otherElement] = nil
					
				end
				
				if lastIndex == lastChildIndex then
					lastIndex = #tree
				end
				
			end
			
			quickRemove(tree, startIndex, lastIndex-startIndex)
			
		end
		
		renderedElements:set(tree, true)
		expandedTree:set(expanded, true)
		paddingTree:set(padding, true)
		
	end
	
	local Tree = List {
		
		MinItems = 0,
		MaxItems = Computed(function() return #renderedElements end),
		ItemSize = 24,
		
		StreamIn = function(index)
			
			local element = Computed(function()
				return unwrap(renderedElements)[index]
			end)
			local expandable = Computed(function()
				return #unwrap(element).children > 0
			end)
			
			return Button {
				
				Name = Computed(function() return unwrap(element).name end),
				
				Size = UDim2.new(1, 0, 0, ITEM_SIZE),
				Position = UDim2.fromOffset(0, (index - 1) * ITEM_SIZE),
				
				BackgroundColor = Enum.StudioStyleGuideColor.Item,
				BorderColor = Enum.StudioStyleGuideColor.Item,
				
				TextSize = 14,
				Text = Computed(function() return unwrap(element).name end),
				
				XPadding = Computed(function()
					return UDim2.fromOffset((unwrap(paddingTree)[unwrap(element)] or 0) * 20, 0)
				end),
				YPadding = UDim2.new(),
				
				[Children] = {
					
					Image {
						
						Size = UDim2.fromOffset(16, 16),
						
						Image = Computed(function()
							local isexpanded = unwrap(expandedTree)[unwrap(element)]
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
					
					Image {
						
						Size = UDim2.fromOffset(16, 16),
						
						Image = Computed(function() return unwrap(element).image end)
					}
					
				}
			}
			
		end
		
	}
	
	return Hydrate(Tree)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Tree