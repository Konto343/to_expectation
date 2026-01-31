# Modules
# Loader for client and server
- Modules
    - *.luau
    - server/client_load.luau

Module Design:
- INIT : ()
- START : ()
- STOP : ()
- ENABLE : ()
- DISABLE : ()

State Object Design:
- attributes to any keys for object config
- LOCK (toggle) : ()
- STATE : boolean attribute
- model : model of state object (toppest level)

State objects are init with their state modules which are placed onto the top level of the model, which self init with the model from script.parent
(This takes a more instance-shifted approached to state object instead of all-memory approach)