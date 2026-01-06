local uis = game:GetService('UserInputService')
local target_key = Enum.KeyCode.LeftShift

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:FindFirstChild("Humanoid") 

local og_walkspeed = humanoid.WalkSpeed
local sprint_speed = 50

function changed(state)
    if state then
        humanoid.WalkSpeed = sprint_speed
    else
        humanoid = og_walkspeed
    end
end

uis.InputBegan:Connect(function(input, gpe)
    if gpe then
        return
    end

    if not input.KeyCode == target_key then
        return
    end

    changed(true)
end)

uis.InputEnded:Connect(function(input, gpe)
    if gpe then
        return
    end

    if not input.KeyCode == target_key then
        return
    end

    changed(false)
end)
