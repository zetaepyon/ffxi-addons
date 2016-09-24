----------------------------------------------------------------------------------------------------
-- Enhanced Keybind, Includes formatted chatlog output
----------------------------------------------------------------------------------------------------
-- required     key     Key to bind, following standard Windower notation
-- required     cmd     Command to bind
-- required     name    Name to use in chatlog display
----------------------------------------------------------------------------------------------------
function bind(key, cmd, name)

    -- Perform actual keybind
    send_command('bind '..key..' '..cmd)

    -- Format keybind and add to chatlog
    key = key:upper():gsub('%^','Ctrl-'):gsub('%!','Alt-'):gsub('%@','Win-')
    add_to_chat(210,name..': '..string.color(key,001))

end

----------------------------------------------------------------------------------------------------
-- Select a random lockstyle set
----------------------------------------------------------------------------------------------------
-- optional     ...     Arbitrary-length list of numerical parameters
--
-- 0 params:  Selects a set between 1 and 20 (first page of lockstyle sets)
-- 1 param:   Selects a set between 1 and the number specified
-- 2+ params: Selects a set from the parameters specified
----------------------------------------------------------------------------------------------------
function random_lockstyle(...)

    local args = {...}
    local default_max = 20
    local wait_time = 10
    local choice

    -- Initialize randomizer
    local seed = math.modf(os.time()/(math.random(10,50)*10000))
    math.randomseed(seed)

    if not args[1] then
        choice = math.random(1,default_max)
    elseif #args == 1 then
        choice = math.random(1,args[1])
    else
        choice = args[math.random(1,#args)]
    end

    send_command('wait '..wait_time..'; input /lockstyleset '..choice)

end
