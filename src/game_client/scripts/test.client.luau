local player = game.Players.LocalPlayer
local player_gui = player.PlayerGui

local main = player_gui:FindFirstChild('main')
local round_timer = main.round_timer

local timers = require(game.ReplicatedStorage.shared.timers)
local timer = timers:new()

timer.connection = function(elapsed)
    local formatted = timer:get_formatted()
    round_timer.Text = formatted

    if elapsed >= (60) then
        for _=1,10 do
            round_timer.TextColor3 = Color3.fromRGB(255,0,0)
            task.wait(1)
            round_timer.TextColor3 = Color3.fromRGB(0, 0, 0)
            task.wait(1)
        end
    end
end
