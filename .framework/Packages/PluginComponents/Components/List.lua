--[[
	List;
	
]]

local Packages = script.Parent.Parent.Parent
local Components = script.Parent

local Fusion = require(Packages.Fusion)
local Util = require(Packages.FusionUtil)

local ScrollingFrame = require(Components.ScrollingFrame)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local Out = Fusion.Out
local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate

local COMPONENT_ONLY_PROPERTIES = {
	"ItemSize",
	"StreamIn",
	"MaxItems",
	"MinItems"
	
}

export type List = {
	ItemSize: Fusion.CanBeState<number>,
	
	StreamIn: (index: number) -> Instance,
	MaxItems: Fusion.CanBeState<number>?,
	MinItems: Fusion.CanBeState<number>?,
	--StreamOut: (object: Instance, index: number) -> nil,
	
	[any]: any
}

local function List(props: List)
	
	local itemSize = props.ItemSize
	local streamIn = props.StreamIn
	local maxItems = props.MaxItems or math.huge
	local minItems = props.MinItems or 0
	
	local streamed = setmetatable({}, {__mode = "vs"})
	
	local absoluteSize = Value(Vector2.new())
	local absoluteCanvasSize = Value(Vector2.new())
	local canvasPosition = Value(Vector2.new())
	
	local itemsIndexes = Computed(function()
		
		local currentAbsoluteSize = unwrap(absoluteSize)
		local currentAbsoluteCanvasSize = unwrap(absoluteCanvasSize)
		local currentCanvasPosition = unwrap(canvasPosition)
		local currentItemSize = unwrap(itemSize)
		local minItems = unwrap(minItems)
		local maxItems = unwrap(maxItems)
		
		if not (currentAbsoluteSize and currentAbsoluteCanvasSize and currentCanvasPosition) then
			return {1, 2}
		end
		
		--local totalItemsToRender = math.ceil(currentAbsoluteSize.Y / currentItemSize + 2)
		
		-- Determines the indexes to render it for.
		local areaMin, areaMax = currentCanvasPosition, currentCanvasPosition + currentAbsoluteSize
		
		local minIndex = math.clamp(math.floor(areaMin.Y / currentItemSize) - 4, minItems, maxItems)
		local maxIndex = math.clamp(math.ceil(areaMax.Y / currentItemSize) + 4, minItems, maxItems)
		
		--print(minIndex, maxIndex)
		
		return {minIndex, maxIndex}
		
	end)
	
	local items = Computed(function()
		
		local indexes = unwrap(itemsIndexes)
		local min, max = indexes[1], indexes[2]
		
		local newStreamed = {}
		
		for index = min, max do
			local streamedObject = streamed[index]
			
			if streamedObject == nil then
				streamedObject = unwrap(streamIn)(index)
				--print("created", index)
				streamed[index] = streamedObject
				
			end
			
			newStreamed[index] = streamedObject
			
		end
		
		for index, item in streamed do
			
			if newStreamed[index] == nil then
				item:Destroy()
				streamed[index] = nil
			end
			
		end
		
		return newStreamed
		
	end)
	
	local List = ScrollingFrame {
		
		ScrollingFrame = {
			CanvasSize = props.CanvasSize or Computed(function()
				
				if unwrap(maxItems) == math.huge then
					local itemIndexes = unwrap(itemsIndexes)
					local canvasSize = unwrap(absoluteCanvasSize) or Vector2.new()
					
					return UDim2.fromOffset(0, math.max((itemIndexes[2] + 2) * unwrap(itemSize), canvasSize.Y))
				else
					return UDim2.fromOffset(0, unwrap(maxItems) * unwrap(itemSize))
					
				end
				
				
			end),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			
			[Out "AbsoluteSize"] = absoluteSize,
			[Out "AbsoluteCanvasSize"] = absoluteCanvasSize,
			[Out "CanvasPosition"] = canvasPosition,
		},
		
		[Children] = items
		
	}
	
	return Hydrate(List)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return List