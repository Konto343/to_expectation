--!strict

local module = {}

local players = game:GetService('Players')
local teleport = game:GetService('TeleportService')

local remotes = require(game.ReplicatedStorage.shared.remotes)
local types = require(game.ReplicatedStorage.shared.types)

local remote = remotes:get('parties', true)
local parties = {} :: {types.party}

local game_placeid = 91868870983711

function module:new(is_friends_only : boolean, password : string, owner_userid : number) : types.party|types.server_response
    if not password then
        return {
            status = false, 
            message = 'Password not provided for party.'
        }
    end

    if module:find_by_owner(owner_userid) then
        return {
            status = false, 
            message = 'User already has a party made.'
        }
    end
    
    local party = {
        is_friends_only = is_friends_only,
        password = password,
        owner_userid = owner_userid,
        members = {}
    } :: types.party

    party.members[#party.members+1] = owner_userid
    parties[#parties+1] = party

    return {
        status = true, 
        message = party
    }
end

function module:find_by_owner(owner_userid : number) : types.party|nil
    for _, party in parties do
        if tonumber(party.owner_userid) == tonumber(owner_userid) then
            return party
        end
    end
    return nil
end

function module:is_player_partied(player : Player)
    for _, party in parties do
        if table.find(party.members, tonumber(player.UserId)) then
            return true
        end
    end
    return false
end

function module:join_party(player : Player, owner_userid : number, password : string) : types.server_response
    if module:is_player_partied(player) then
        return {
            status = false, 
            message = 'Player is already in a party!'}
    end

    local party = module:find_by_owner(owner_userid)
    if not party then
        return {
            status = false, 
            message = `Party not found under the owner of: {owner_userid}`
        }
    end

    if party.is_friends_only then
        local is_friends = player:IsFriendsWithAsync(party.owner_userid)
        if not is_friends then
            return {
                status = false, 
                message = 'User is not friends with the party owner.'
            }
        end
    end

    if password ~= party.password then
        return {
            status = false, 
            message = 'Password is incorrect.'
        }
    end

    party.members[#party.members+1] = player.UserId

    return {
        status = true, 
        message = party
    }
end

function module:leave_party(player : Player)
    for _, party in parties do
        local existing = table.find(party.members, player.UserId)
        if not existing then
            continue
        end

        party.members[existing] = nil
        return {
            status = true, 
            message = 'Left party.'
        }
    end

    return {
        status = false, 
        message = 'Attempted to leave a non-existence party.'
    }
end

function module:delete(player : Player)
    for index, party in parties do
        if party.owner_userid ~= player.UserId then
            continue
        end

        parties[index] = nil
        return {
            status = true,
            message = 'Party deleted successfully.'
        }
    end

    return {
        status = false, 
        message = 'Party was not deleted, no parties are tied to the user.'
    }
end

function module:launch(player : Player)
    local party = module:find_by_owner(player.UserId)

    if not party then
        return {
            status = false,
            message = 'Player has no party tied to them to launch.'
        }
    end

    local party_players = {} :: {Player}

    for _, player_userid in party.members do
        party_players[#party_players+1] = players:GetPlayerByUserId(player_userid)
    end

    local private_server = teleport:ReserveServerAsync(game_placeid)

    teleport:TeleportToPrivateServer(
        game_placeid,
        private_server,
        party_players
    )

    return {
        status = true,
        message = 'You are about to be teleported... Wait on moment. (If you still see this after NOT being teleported, look for errors/warnings and report them to the developer.'
    }
end

function module:get_listing()
    local listing = {}
    for _, party in parties do
        listing[party.owner_userid] = {
            player_count = #party.members,
            is_friends_only = party.is_friends_only
        }
    end
    return listing
end

function module:get_party(player : Player)
    for _, party in parties do
        if table.find(party.members, player.UserId) then
            return {
                status = true, 
                message = party
            }
        end
    end
    
    return {
        status = false, 
        message = 'Player is not in any parties.'
    }
end

function module:force_listing_all()
    for _, plr in players:GetPlayers() do
        remote:InvokeClient(plr, {
            action = 'force_listing',
        })
    end
end

function module:force_party_all()
    for _, party in parties do
        for _, player_userid in party.members do
            local plr = players:GetPlayerByUserId(player_userid)
            remote:InvokeClient(plr, 'force_party')
        end
    end
end

remote.OnServerInvoke = function(player, data : types.client_message)
    local action = data.action
    assert(action, `{player.UserId} sent bad/nil action.`)

    if action == 'create' then
        local result = module:new(
            data.is_friends_only,
            data.password,
            player.UserId
        )
        module:force_listing_all()
        return result
    elseif action == 'join' then
        local result = module:join_party(
            player,
            data.owner_userid,
            data.password
        )
        module:force_listing_all()
        return result
    elseif action == 'delete' then
        local result =  module:delete(player)
        module:force_listing_all()
        return result

    elseif action == 'leave' then
        local result = module:leave_party(player)
        module:force_listing_all()
        return result

    elseif action == 'launch' then
        local result = module:launch(player)
        module:launch(player)
        module:delete(player)
        return result

    elseif action == 'get_listing' then
        return module:get_listing()

    elseif action == 'get_party' then
        return module:get_party(player)
    end
end

return module