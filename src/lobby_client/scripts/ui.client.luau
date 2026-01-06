--!strict

local players = game:GetService('Players')
local ts = game:GetService('TweenService')
local remotes = require(game.ReplicatedStorage.shared.remotes)
local types = require(game.ReplicatedStorage.shared.types)

local party_remote = remotes:get('parties', true)

local player = game.Players.LocalPlayer
local ui = player.PlayerGui

local lobby_ui = ui:WaitForChild('lobby', 10) :: ScreenGui
local lobby_screen = lobby_ui.lobby_screen :: CanvasGroup

local loading = lobby_ui.loading :: CanvasGroup
local destroy = lobby_ui.secret :: TextButton

local party_listing = lobby_screen.party_listing.container
local party = lobby_screen.party.container

local make_party = party_listing.party_creation.make_party :: TextButton
local make_party_password = party_listing.party_creation.password_box :: TextBox 

local leave_party = party.listing.leave_party :: TextButton 
local party_options = party.listing.party_owner_controls.options

local sfx = game.ReplicatedStorage.sfx

function loading_screen()
    task.wait(1)
    
    destroy.MouseButton1Down:Once(function()
        lobby_ui:Destroy()
        sfx.general.secret:Play()
        sfx.general.secret_ambience:Play()
    end)
    
    local fade_in_out = TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
    local fade_in = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    sfx.general.string:Play()
    local credit_fade = ts:Create(loading.credit, fade_in_out, {GroupTransparency = 0})
    credit_fade:Play()
    credit_fade.Completed:Wait()
    
    task.wait(1)
    
    sfx.general.riser:Play()
    
    task.wait(1)
    
    sfx.general.pass:Play()
    local headphones_fade = ts:Create(loading.headphones, fade_in_out, {GroupTransparency = 0})
    headphones_fade:Play()
    headphones_fade.Completed:Wait()
    
    task.wait(1)
    
    ts:Create(sfx.music.lobby, fade_in, {PlaybackSpeed = 1}):Play()
    ts:Create(lobby_screen, fade_in, {GroupTransparency = 0}):Play()
end

function ui_sounds()
    local hover = sfx.ui.hover
    local click = sfx.ui.click

    for _, obj in lobby_ui:GetDescendants() do
        if obj:IsA('TextButton') then
            obj.MouseButton1Down:Connect(function()
                click:Play()
            end)

            obj.MouseEnter:Connect(function()
                hover:Play()
            end)
        end
    end
end

function update_listing(data : types.party|nil)
    for _, obj in party_listing.listing:GetChildren() do
        if obj:IsA('UIListLayout') then
            continue
        end

        if obj.Name ~= 'template' then
            obj:Destroy()
        end
    end

    local server_listing = data or party_remote:InvokeServer({action = 'get_listing'})
    local template = party_listing.listing.template :: Frame

    for owner_userid, party_data in server_listing do
        local party_owner = players:GetPlayerByUserId(owner_userid)
        local clone = template:Clone()
        local join_button = clone.join_button :: TextButton

        clone.Name = owner_userid
        clone.Visible = true
        clone.label.Text = `{party_owner.DisplayName}'s Party ({party_data['player_count']} Player(s))` .. (party_data['is_friends_only'] and '[Friends Only]' or '')
        clone.Parent = party_listing.listing

        join_button.MouseButton1Down:Connect(function()
            local response = party_remote:InvokeServer({
                action = 'join',
                owner_userid = owner_userid,
                password = make_party_password.Text
            }) :: types.server_response

            handle_response(response)

            if response.status then
                update_party(response.message)
            end
        end)
    end
end

function update_party(data : types.party|nil)
    local party_header = party.listing.header :: TextLabel
    local party_controls = party.listing.party_owner_controls :: Frame
    local player_listing = party.listing.player_listing :: ScrollingFrame
    
    if not data then
        party_header.Text = '...'
        party_controls.Visible = false
        leave_party.Visible = false
    else
        local party_owner = players:GetPlayerByUserId(data.owner_userid)
        party_header.Text = `{party_owner.DisplayName}'s Party` or '...'
        party_controls.Visible = players.LocalPlayer.UserId == data.owner_userid
        leave_party.Visible = true
    end

    for _, obj in player_listing:GetChildren() do
        if obj:IsA('UIListLayout') then
            continue
        end

        if obj.Name ~= 'template' then
            obj:Destroy()
        end
    end

    if not data then
        return
    end

    for _, player_userid in data.members do
        local plr = players:GetPlayerByUserId(player_userid)
        local template = player_listing.template:Clone() :: TextLabel
        template.Name = plr.DisplayName
        template.Text = plr.DisplayName
        template.Visible = true
        template.Parent = player_listing
    end
end

function handle_response(response : types.server_response)
    local status = response.status
    local data = response.message
    local output_function = status and print or warn

    output_function(`Status: {status and 'Successful' or 'Error'} | Server result: {data}`)
end

make_party.MouseButton1Down:Connect(function()
    local response = party_remote:InvokeServer({
        action = 'create',
        password = make_party_password.Text
    }) :: types.server_response

    handle_response(response)
    update_party(response.message)
    update_listing()
end)

leave_party.MouseButton1Down:Connect(function()
    local response = party_remote:InvokeServer({
        action = 'leave'
    }) :: types.server_response

    handle_response(response)
    update_party(nil)
    update_listing()
end)

party_options.delete.MouseButton1Down:Connect(function()
    local response = party_remote:InvokeServer({
        action = 'delete'
    }) :: types.server_response

    handle_response(response)
    update_party(nil)
    update_listing()
end)

party_options.launch.MouseButton1Down:Connect(function()
    local response = party_remote:InvokeServer({
        action = 'launch'
    }) :: types.server_response

    handle_response(response)
    update_party(nil)
    update_listing()
end)

party_remote.OnClientInvoke = function(data : types.server_command)
    local action = data.action
    assert(action, 'Server sent bad action!')
    
    if action == 'force_party' then
        update_party(data.party)
    end

    if action == 'force_listing' then
        update_listing(data.listing)
    end
end

lobby_screen.GroupTransparency = 1
lobby_ui.Enabled = true

loading_screen()
ui_sounds()