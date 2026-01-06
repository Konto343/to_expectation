local grid = require(game.ServerScriptService.server.modules.grid)
local sounds = require(game.ReplicatedStorage.shared.sounds)
local sfx = game.ReplicatedStorage:WaitForChild('sfx', 10)

local test_range = {-12, 12}

for x=test_range[1],test_range[2] do
  for z=test_range[1],test_range[2] do
     grid.make_grid(x,z)
     task.wait()
  end
end

