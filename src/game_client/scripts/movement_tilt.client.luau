local tilt_speed = 0.05 --lower number is faster tiliting
local tilt_boost = .2 --around .1 is normal

local tracking = {}

function setup(plr)
	tracking[#tracking+1] = plr

	local char = plr.Character or plr.CharacterAdded:Wait()
	local hrp : BasePart = char:WaitForChild('HumanoidRootPart', 10)

	local rootjoint : JointInstance = hrp.RootJoint
	local og_c0 = rootjoint.C0
	
	game:GetService('RunService').Stepped:Connect(function()
		if not char then 
			char = plr.Character or plr.CharacterAdded:Wait()
		end
	
		local x_angle = hrp.CFrame.RightVector:Dot(char.Humanoid.MoveDirection)
		local y_angle = hrp.CFrame.LookVector:Dot(char.Humanoid.MoveDirection)
		local cur_c0 = rootjoint.C0
	
		local goal = og_c0 * CFrame.Angles(y_angle * tilt_boost, -x_angle * tilt_boost, 0)
	
		rootjoint.C0 = cur_c0:Lerp(goal, tilt_speed)
	end)
end

for _, player in game.Players:GetPlayers() do
	if not table.find(tracking, player) then
		setup(player)
	end
end
