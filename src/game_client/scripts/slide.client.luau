local run = game:GetService('RunService')
local uis = game:GetService('UserInputService')
local players = game:GetService('Players')
local player = players.LocalPlayer

local target_key = Enum.KeyCode.LeftControl
local state = false
local db = false
local connection : RBXScriptConnection

local physics = Instance.new('BodyVelocity')
physics.MaxForce = Vector3.new(40000, 0, 40000)

function start_loop()
    local char = player.Character or player.CharacterAdded:Wait()

    if not char or not state or db then
        return
    end

    local humanoid = char:FindFirstChildWhichIsA('Humanoid')
    local hrp = char:FindFirstChild("HumanoidRootPart", true)
    physics.Parent = hrp

    local target_speed = humanoid.WalkSpeed * 5 --normal = 60
    local speed_mult = 1
    local speed_mult_step = 1/100
    local last_y = 0

    connection = run.RenderStepped:Connect(function()
        if not state then
            return
        end

        local ray = workspace:Raycast(hrp.CFrame.Position, Vector3.new(0, -1, 0)) --ADD PARAMS TO EXCLUDE CHARACTER MODEL
        local y_difference

        if ray then
            y_difference = last_y - ray.Distance
            last_y = ray.Distance
        end

        if y_difference <= .5 then
            speed_mult -= speed_mult_step
        elseif y_difference >= .5 then
            speed_mult += speed_mult_step
        else
            speed_mult -= (speed_mult_step / 2)
        end

        physics.Velocity = (hrp.CFrame.LookVector * target_speed) * speed_mult
    end)
end

uis.InputBegan:Connect(function(input)
    if input.KeyCode == target_key then
        state = true
        start_loop()
    end
end)

uis.InputEnded:Connect(function(input)
    if input.KeyCode == target_key then
        state = false

        if connection then
            connection:Disconnect()
        end
        
        physics.Parent = nil
        physics.Velocity = Vector3.new()
    end
end)