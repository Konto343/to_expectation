local ts = game:GetService('TweenService')

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local hints_gui = player.PlayerGui:WaitForChild('hints', 10).canvas :: CanvasGroup
local text = hints_gui.container.text :: TextLabel

hints_gui.Visible = true

mouse.Move:Connect(function()
    if not mouse.Target then
        if hints_gui.GroupTransparency ~= 1 then
            ts:Create(hints_gui, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        end
        return
    end
    
    hints_gui.Position = UDim2.fromOffset(mouse.X, mouse.Y) --do this
    local hint = mouse.Target:GetAttribute('hint') or mouse.Target.Parent:GetAttribute('hint')

    if not hint then
        ts:Create(hints_gui, TweenInfo.new(.1), {GroupTransparency = 1}):Play() --why isn't thsi workign
        return
    else
        ts:Create(hints_gui, TweenInfo.new(.1), {GroupTransparency = 0}):Play() --why isn't thsi workign
    end

    text.Text = hint
end)