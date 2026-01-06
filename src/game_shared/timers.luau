local rs = game:GetService("RunService")

local module = {}

function module:new()
    local self = {}
    self.start_time = 0 :: number
    self.elapsed_time = 0 :: number
    self.is_active = false :: boolean
    self.precision = 1000 :: number
    self.at_update = nil :: (elapsed : number) -> ()
    self._connection = nil :: RBXScriptConnection

    return self
end

function module:start()
    self.start_time = tick()
    self.elapsed_time = 0
    self.is_active = true
    
    self._connection = rs.Heartbeat:Connect(function()
        if self.is_active then
            local time_difference = tick() - self.start_time
            self.elapsed_time = time_difference
    
            if self.at_update then
                self.at_update(time_difference)
            end
        end
    end)
end

function module:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
    self.is_active = false
end

function module:get_time()
    return self.elapsed_time
end

function module:get_formatted()
    local total_seconds = self.elapsed_time
    local minutes = math.floor(total_seconds / 60)
    local seconds = math.floor(total_seconds % 60)
    local milliseconds = math.floor((total_seconds % 1) * self.precision)
    require(game.ReplicatedStorage.shared.timer)
    return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds), total_seconds
end

return module