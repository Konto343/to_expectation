local ts = game:GetService('TweenService')

local sounds = require(game.ReplicatedStorage.shared.sounds)
local sfx = game.ReplicatedStorage:WaitForChild('sfx', 10)

local replicated_storage = game.ReplicatedStorage
local gui = replicated_storage.gui
local speak = gui.speak :: BillboardGui

local chats = {}

function setup_chat(obj : Instance, owner : string)
    local _db = false
    local _index = 0

    local source = replicated_storage.shared.chats:FindFirstChild(owner, true)
    assert(source, 'No chat owner source found!')

    local click_obj = Instance.new('ClickDetector')
    click_obj.Parent = obj

    local data = require(source)
    local responses = data['data']

    local chat_ui = obj.Parent.Head:FindFirstChild('speak')
    if not chat_ui then
        chat_ui = speak:Clone()
        chat_ui.Parent = obj.Parent.Head
    end

    local container = chat_ui.container :: CanvasGroup

    chats[#chats+1] = click_obj.MouseClick:Connect(function(player)
        if player ~= game.Players.LocalPlayer then
            return
        end

        if _db then
            return
        end

        _db = true

        container.GroupTransparency = 0
        
        _index += 1
        
        local display_text = responses[(_index % #responses) + 1]

        for index=1,#display_text do
            container.text.Text = string.sub(display_text, 1, index)
            task.wait(1/25)
            if index % 4 then
                sounds:play_sound(sfx.speaking:FindFirstChild(owner), obj.Parent.Head, true)
            end
        end
        
        task.wait(1)
        ts:Create(container, TweenInfo.new(.1), {GroupTransparency = 1}):Play()
        task.wait(.1)

        _db = false
    end)
end

task.wait(3)

for _, obj in workspace:GetDescendants() do
    local owner = obj:GetAttribute('chat_owner')
    if owner then
        setup_chat(obj, owner)
    end
end
