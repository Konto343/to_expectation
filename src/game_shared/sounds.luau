local module = {}

local debris = game:GetService('Debris')

function module:play_sound(sound : Sound, parent : Instance, random_volume : boolean|nil)
    local clone = sound:Clone()
    clone.Parent = parent or workspace
    
    if random_volume then
        clone.Volume = math.random(1,10) / 10
    end
    
    clone:Play()
    clone.Ended:Once(function()
        clone:Destroy()
    end)
    debris:AddItem(clone, 60)
end

return module