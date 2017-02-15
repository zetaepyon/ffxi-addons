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

----------------------------------------------------------------------------------------------------
-- Automatic spell/ability fallback
----------------------------------------------------------------------------------------------------
-- required     spell           Spell passed through from the precast function
-- optional     fallback_table  T{} table of fallback pairings. Default: classes.AutoFallback
-- optional     display         Display fallback operations in log. Default: false
--
-- EXAMPLE
-- get_sets()
--     classes.NukeFallback = T{["Fire V"]="Fire IV", ["Fire IV"]="Fire III"}
--     ...
-- end
--
-- precast()
--     if spell.skill=="Elemental Magic" then auto_fallback(spell,classes.NukeFallback) end
--     ...
-- end
----------------------------------------------------------------------------------------------------
function auto_fallback(...)

    local args = {...}
    local spell = args[1]
    local fallback_table = args[2] or classes.AutoFallback or T{}
    local display = args[3] or false

    if fallback_table:containskey(spell.english) then

        local recast_time = windower.ffxi.get_ability_recasts()[spell.recast_id] or windower.ffxi.get_spell_recasts()[spell.recast_id]
        local function change_spell(reason)
            local new_spell = fallback_table[spell.english]
            cancel_spell()
            send_command('//'..new_spell..' '..spell.target.raw)
            if display then windower.add_to_chat(001,string.format("FB :: %s > %s [%s]",string.color(spell.english,167),string.color(new_spell,204),string.color(reason,021))) end
        end

        if recast_time > 0 then
            change_spell("Recast Timer")
        elseif spell.mp_cost > player.mp then
            change_spell("Insufficient MP")
        elseif spell.type == 'JobAbility' and buffactive[spell.english] then
            change_spell("Ability Buff Active")
        end

    end
end
