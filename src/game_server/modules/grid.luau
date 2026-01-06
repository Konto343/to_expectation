local module = {}

local ts = game:GetService('TweenService')

local sounds = require(game.ReplicatedStorage.shared.sounds)
local sfx = game.ReplicatedStorage.sfx

local storage = game.ServerStorage

local grid = {['0-0'] = true}
local grid_size = 32
local grid_folder = workspace.grid

function module.make_grid(x : number, z :number)
    local existing = grid[`{x}-{z}`]

    if existing then
        warn('Existing block found!')
        return  
    end

    grid[`{x}-{z}`] = true

    local clone = storage.assets:FindFirstChild('grid_block'):Clone() :: BasePart
    clone.Name = `{x}-{z}`
    clone.Transparency = 1
    clone.CanCollide = false
    clone.Parent = grid_folder

    local endpos = CFrame.new(Vector3.new(x*grid_size, 0, z*grid_size))
    local startpos = endpos * CFrame.new(0,-50, 0)
    local endcolor = Color3.new(math.random(), math.random(), math.random())

    clone.CFrame = startpos

    sounds:play_sound(sfx.grid.rising, clone)

    local distance = (endpos.Position - Vector3.new()).Magnitude

    endcolor = Color3.fromRGB(91, 91, 91)

    local rise = ts:Create(clone, TweenInfo.new(2, Enum.EasingStyle.Exponential), {
        CFrame = endpos,
        Transparency = 0,
        Color = endcolor
    })
    rise:Play()
    rise.Completed:Connect(function()
        clone.CanCollide = true
        sounds:play_sound(sfx.grid.boom, clone)
    end)
end

function module.change_height_grid(x : number, z : number, new_height : number)
    local existing = grid[`{x}-{z}`]

    if not existing then
        warn("Can't Move non-existent block!")
        return  
    end

    if x == 0 and z == 0 then
        warn("Cannot move protected block!")
        return
    end

    local block = grid_folder:FindFirstChild(`{x}-{z}`) :: BasePart
    local old_pos = block.CFrame
    local new_pos = CFrame.new(old_pos.X, new_height, old_pos.Z)

    sounds:play_sound(sfx.grid.shift, block)

    local rise = ts:Create(block, TweenInfo.new(1, Enum.EasingStyle.Exponential), {
        CFrame = new_pos,
    })
    rise:Play()
end

function module.delete_grid(x : number, z : number)
    local existing = grid[`{x}-{z}`]

    if not existing then
        warn("Can't Delete non-existent block!")
        return  
    end

    if x == 0 and z == 0 then
        warn("Cannot move protected block!")
        return
    end

    grid[`{x}-{z}`] = nil

    local block = grid_folder:FindFirstChild(`{x}-{z}`) :: BasePart
    local endpos = block.CFrame * CFrame.new(0, -50, 0)

    sounds:play_sound(sfx.grid.rising, block)
    block.CanCollide = false

    local rise = ts:Create(block, TweenInfo.new(2, Enum.EasingStyle.Exponential), {
        CFrame = endpos,
        Transparency = 1
    })
    rise:Play()
    rise.Completed:Connect(function()
        block:Destroy()
    end)
end


return module
