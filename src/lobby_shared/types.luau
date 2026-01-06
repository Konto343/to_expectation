local module = {}

export type server_response = {
    status : boolean,
    message : string
}

export type server_command = {
    action : string
}

export type client_message = {
    action : string
}

export type party = {
    is_friends_only : boolean,
    password : nil | string,
    owner_userid: number,
    members: {number},
}

return module