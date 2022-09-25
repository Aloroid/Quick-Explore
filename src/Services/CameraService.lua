--[[local PluginCode = script.Parent.Parent

local HeavyFramework = require(PluginCode.HeavyFramework)]]

local CameraService = {}

function CameraService:lookAtObject(object: BasePart | Model)
	
	local camera = workspace.CurrentCamera
	
	if object:IsA("Model") then
		camera.Focus = object:GetBoundingBox()
		camera.CFrame = camera.CFrame - camera.CFrame.Position + object:GetBoundingBox().Position - (camera.CFrame.LookVector*object:GetExtentsSize().Magnitude)
	elseif object:IsA("BasePart") then
		camera.Focus  = object.CFrame
		camera.CFrame  = camera.CFrame - camera.CFrame.Position + object.Position-(camera.CFrame.LookVector*object.Size.Magnitude)
		
	end
	
end

return CameraService