local module = {}

local state = false
local connection = nil

local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local camera = workspace.CurrentCamera

module._turn = 0
module.sway_strength = 100
module.delta_boost = 4

function lerp(a, b, t)
	return a + (b - a) * t
end

module.toggle_state = function(override)
	state = override or not state
	
	if state then
		connection = rs:BindToRenderStep("camera_sway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)

			local delta = uis:GetMouseDelta()

			module._turn = lerp(module._turn, math.clamp(delta.X, - module.sway_strength, module.sway_strength), (module.delta_boost * deltaTime))
			camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.rad(module._turn))
		end)
	else
		if connection then
			connection:Disconnect()
		end
	end
end

module.toggle_state()

return module
