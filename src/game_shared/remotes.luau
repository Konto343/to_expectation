local module = {}

local rep = game.ReplicatedStorage
local remote_folder = rep:FindFirstChild('remotes')

function module:get(remote_name : string, is_remote_function : boolean) : RemoteEvent|RemoteFunction
    if not remote_folder then
        remote_folder = Instance.new('Folder')
        remote_folder.Name = 'remotes'
        remote_folder.Parent = rep
    end

    local remote = remote_folder:FindFirstChild(remote_name)
    
    if not remote then
        remote = is_remote_function and Instance.new('RemoteFunction') or Instance.new('RemoteEvent')
        remote.Name = remote_name
        remote.Parent = remote_folder
    end

    return remote
end

return module