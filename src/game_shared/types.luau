local module = {}

export type module = {
    init : () -> (),
    start : () -> (),
    stop : () -> (),
    enable : () -> (),
    disable : () -> ()
}

export type state_model = {
    lock : () -> (),
    state  : () -> (),
    model : Model
}

return module