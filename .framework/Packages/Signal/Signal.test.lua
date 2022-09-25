--[[
	Ported from https://github.com/Sleitnick/RbxUtil/blob/main/modules/signal/init.spec.lua to HeavyTest
	
]]

local function AwaitCondition(predicate, timeout)
	local start = os.clock()
	timeout = (timeout or 10)
	while true do
		if predicate() then
			return true
		end
		if (os.clock() - start) > timeout then
			return false
		end
		task.wait()
	end
end

local Signal = require(script.Parent)

local function NumConns(sig)
	sig = sig
	return #sig:GetConnections()
end

return {
	
	["Constructor"] = {
		
		["should create a signal and fire it"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			task.defer(function()
				signal:Fire(10, 20)
			end)
			local n1, n2 = signal:Wait()
			check(n1 == 10, "n1 does not equal 10")
			check(n2 == 20, "n2 does not equal 20")
			
		end,
		
		["should create a proxy signal and connect to it"] = function(check)
			local signalWrap = Signal.Wrap(game:GetService("RunService").Heartbeat)
			
			check(Signal.Is(signalWrap) == true)
			
			local fired = false
			signalWrap:Connect(function()
				fired = true
			end)
			
			check(AwaitCondition(function()
				return fired
			end, 2) == true)
			signalWrap:Destroy()
			
		end
		
	},
	
	["FireDeferred"] = {
		
		["should be able to fire primitive argument"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local send = 10
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:FireDeferred(send)
			check(AwaitCondition(function()
				return (send == value)
			end, 1) == true, "did not receive a primitive argument")
			
		end,
		
		["should be able to fire a reference based argument"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local send = { 10, 20 }
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:FireDeferred(send)
			check(AwaitCondition(function()
				return (send == value)
			end, 1) == true, "did not receive a reference based argument")
		end
		
	},
	
	["Fire"] = {
		
		["should be able to fire primitive argument"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local send = 10
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:Fire(send)
			check(value == send, "value is not the same as what is send")
		end,

		["should be able to fire a reference based argument"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local send = { 10, 20 }
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:Fire(send)
			check(value == send, "value is not the same as what is send")
		end
		
	},
	
	["ConnectOnce"] = {
		
		["should only capture first fire"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local value
			local c = signal:ConnectOnce(function(v)
				value = v
			end)
			check(c.Connected == true, "connection is not connected")
			signal:Fire(10)
			check(c.Connected == false, "connection is not disconnected")
			signal:Fire(20)
			check(value == 10, "value is not 10")
		end
		
	},
	
	["Wait"] = {
		
		["should be able to wait for a signal to fire"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			task.defer(function()
				signal:Fire(10, 20, 30)
			end)
			local n1, n2, n3 = signal:Wait()
			check(n1 == 10, "n1 is not 10")
			check(n2 == 20, "n2 is not 20")
			check(n3 == 30, "n3 is not 30")
		end
		
	},
	
	["DisconnectAll"] = {
		
		["should disconnect all connections"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			signal:Connect(function() end)
			signal:Connect(function() end)
			check(NumConns(signal) == 2, "number of connections is not 2")
			signal:DisconnectAll()
			check(NumConns(signal) == 0, "number of connections is not 0")
		end
		
	},
	
	["Disconnect"] = {
		["should disconnect connection"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local con = signal:Connect(function() end)
			check(NumConns(signal) == 1, 'connection did not connect')
			con:Disconnect()
			check(NumConns(signal) == 0, "connection did not disconnect")
		end,

		["should still work if connections disconnected while firing"] = function(check)
			local signal = Signal.new()
			task.delay(0.1, signal.Destroy, signal)
			
			local a = 0
			local c
			signal:Connect(function()
				a += 1
			end)
			c = signal:Connect(function()
				c:Disconnect()
				a += 1
			end)
			signal:Connect(function()
				a += 1
			end)
			signal:Fire()
			check(a == 3, "amount of times fired is not 3")
		end,

		["should still work if connections disconnected while firing deferred"] = function(check)
			local signal = Signal.new()
			task.delay(1, signal.Destroy, signal)
			
			local a = 0
			local c
			signal:Connect(function()
				a += 1
			end)
			c = signal:Connect(function()
				c:Disconnect()
				a += 1
			end)
			signal:Connect(function()
				a += 1
			end)
			signal:FireDeferred()
			check(AwaitCondition(function()
				return a == 3
			end) == true, "did not find out being fired 3 times")
		end
		
	}
	
}