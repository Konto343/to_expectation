local RunService = game:GetService("RunService")

local timer = {
    startTime = 0,
    elapsedTime = 0,
    isRunning = false,
    precision = 1000, -- milliseconds precision
}

function timer:Start()
    self.startTime = tick()
    self.elapsedTime = 0
    self.isRunning = true
    
    -- Heartbeat connection for accurate timing
    self.connection = RunService.Heartbeat:Connect(function(_)
        if self.isRunning then
            self.elapsedTime = tick() - self.startTime
        end
    end)
end

function timer:Stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    self.isRunning = false
end

function timer:GetTime()
    return self.elapsedTime
end

function timer:GetTimeFormatted()
    local totalSeconds = self.elapsedTime
    local minutes = math.floor(totalSeconds / 60)
    local seconds = math.floor(totalSeconds % 60)
    local milliseconds = math.floor((totalSeconds % 1) * self.precision)
    
    return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds), totalSeconds
end

return timer