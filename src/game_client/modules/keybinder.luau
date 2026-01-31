--!strict

local keybinder = {}
keybinder.__index = keybinder

local uis = game:GetService('UserInputService')

function keybinder:disconnect()
	self._conn:Disconnect()
end

function keybinder.register(keybinds: {Enum.KeyCode}, func: () -> ())
	local self = setmetatable({}, keybinder)

	self.keys = keybinds
	self._conn = uis.InputBegan:Connect(function()
		for _, key in keybinds do
			if not uis:IsKeyDown(key) then
				return
			end
		end
		
		func()
	end)

	return self	
end

return keybinder