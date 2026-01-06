local sounds = require(game.ReplicatedStorage.shared.sounds)
local sfx = game.ReplicatedStorage:WaitForChild('sfx', 10)

game.Loaded:Wait()

function setup(model)
    local _db = false
    local sound_folder = sfx:FindFirstChild(model.Name)

    for _, part : BasePart in model:GetDescendants() do
        if not part:IsA('BasePart') then
            continue
        end

        part.Touched:Connect(function(other)
            if _db then
                return
            end

            _db = true
            if other:IsDescendantOf(model) then
                return
            end
    
            sounds:play_sound(sound_folder.hit, part)
            task.wait(.3)
            _db = false
        end)
    end
end

for _, obj in game.Workspace:GetDescendants() do
    if obj:IsA('Model') then
        local sound_folder = sfx:FindFirstChild(obj.Name)

        if not sound_folder then
            continue
        end

        setup(obj)
    end
end