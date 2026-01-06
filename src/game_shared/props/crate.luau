local module = {}

local sounds = require(game.ReplicatedStorage.shared.sounds)
local sfx = game.ReplicatedStorage:WaitForChild('sfx', 10)

function module.apply(model : Model)
    local _hits = 0
    local _db = false
    
    local data_folder = sfx:FindFirstChild(model.Name)
    local connections : {RBXScriptConnection} =  {}

    for _, obj : BasePart in model:GetDescendants() do
        if not obj:IsA('BasePart') then
            continue
        end
        
        connections[#connections+1] = obj.Touched:Connect(function()
            if _db then
                return
            end

            if obj.AssemblyLinearVelocity.Magnitude >= 20 then
                _db = true
                local root : BasePart = model:FindFirstChild('root', true)
                sounds:play_sound(data_folder.breakage, root)
                root:Destroy()
                print("DEATH")
            else
                print('no lamo')
            end
        end)

        print('added TOUCHVADOW')
    end

    task.spawn(function()
        while task.wait(1) do
            if _db then
                for _, connection in connections do
                    connection:Disconnect()
                end

                for _, weld in model:GetDescendants() do
                    if weld:IsA('WeldConstraint') then
                        weld:Destroy()
                    end
                end

                print('dead')
                break
            end
        end
    end)
end

return module