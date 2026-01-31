local rep = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')

local types = require(rep.shared.types)
local client_module = players.LocalPlayer.PlayerScripts.modules

for _, mod in client_module:GetChildren() do
	if mod:IsA('ModuleScript') then
		local mod = require(mod) :: types.module
		mod:init()
		print(`Running init on: {mod:GetFullName()}`)
	end
end