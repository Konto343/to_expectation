local module = {}

local content = game:GetService('ContentProvider')
local ts = game:GetService('TweenService')
local rs = game:GetService('RunService')
local players = game:GetService('Players')
local rep = game:GetService('ReplicatedStorage')

local sounds = require(rep.shared.sounds)
local sfx = rep:WaitForChild('sfx', 10)

local gui = players.LocalPlayer.PlayerGui

local loading_ui = gui:WaitForChild('loading', 10).container :: Frame
local header = loading_ui.header :: TextLabel
local bar = loading_ui.bar :: Frame
local play_button = loading_ui.play_button :: TextButton

loading_ui.Parent.Enabled = true
sounds:play_sound(sfx.ui.appear)
ts:Create(sfx.music.loading, TweenInfo.new(10), {PlaybackSpeed = 1}):Play()

local targets = game:GetDescendants()
local total_targets = #targets
for index, obj in targets do
    pcall(function()
        content:PreloadAsync({obj})
        header.Text = `[{total_targets}/{index}] {obj:GetFullName()}`
        bar.light.Size = UDim2.fromScale(index/total_targets, 1)
        if index % 100 == 0 then
            sounds:play_sound(sfx.ui.tick)
        end
    end)
end

header.Text = 'Game loaded.'

task.wait(1)

sounds:play_sound(sfx.ui.tick)
header.Visible = false
bar.Visible = false

play_button.Visible = true
play_button.MouseButton1Down:Once(function()
    sounds:play_sound(sfx.ui.click)
    ts:Create(sfx.music.loading, TweenInfo.new(3), {PlaybackSpeed = 0}):Play()

    sounds:play_sound(sfx.general.riser1)
    play_button.Text = `...`
    
    if not rs:IsStudio() then
        task.wait(2)

        sounds:play_sound(sfx.ui.click)
        play_button.Text = `Remember {players.LocalPlayer.DisplayName}...`

        task.wait(2)

        sounds:play_sound(sfx.ui.click)
        play_button.Text = `To Perfection...`

        task.wait(2)

        sounds:play_sound(sfx.ui.click)
        play_button.Text = `To Succession...`

        task.wait(2)

        sounds:play_sound(sfx.ui.click)
        play_button.Text = `To Expectation.` --Note: im krilling myself 
        task.wait(1)
    else
        sounds:play_sound(sfx.general.squeak)
        ts:Create(play_button, TweenInfo.new(.2), {Size = UDim2.fromScale(1,1)}):Play()
        play_button.Text = `To... FIX BUGS AND ERRORS WITH ENDLESS DEBUGGING!!!!`
        sounds:play_sound(sfx.general.fah)
    end

    if not rs:IsStudio() then
        ts:Create(play_button, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1}):Play()

        task.wait(1)

    end
    
    ts:Create(sfx.music.lobby, TweenInfo.new(3), {PlaybackSpeed = 1}):Play()
    loading_ui.BackgroundColor3 = Color3.new(1,1,1)
    local fade = ts:Create(loading_ui, TweenInfo.new(1), {BackgroundTransparency = 1})
    fade:Play()
    fade.Completed:Once(function()
        loading_ui.Parent:Destroy()
    end)
end)
play_button.MouseEnter:Connect(function()
    sounds:play_sound(sfx.ui.hover)
end)

ts:Create(sfx.music.loading, TweenInfo.new(3), {PlaybackSpeed = 0.2}):Play()

return module