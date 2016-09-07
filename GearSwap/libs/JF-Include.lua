----------------------------------------------------------------------------------------------------
-- Common vars and functions for job scripts, for general default handling
--
-- Include this file in the get_sets() function with the command:
-- include('JF-Include.lua')
--
-- IMPORTANT: This include requires supporting include files:
-- JF-Utility
-- JF-Mappings
-- JF-Globals
-- Modes
--
----------------------------------------------------------------------------------------------------

current_jf_include_version = 1

function init_include()

    -- Include data mappings
    include('JF-Mappings')

    -- Include for mode-tracking variable class, used for state variables.
    include('Modes')

    -- Base for state values
    state = {}

    state.OffenseMode     = M{['description'] = 'Offense Mode'}
    state.DefenseMode     = M{['description'] = 'Defense Mode'}
    state.WeaponskillMode = M{['description'] = 'Weaponskill Mode'}
    state.CastingMode     = M{['description'] = 'Casting Mode'}
    state.IdleMode        = M{['description'] = 'Idle Mode'}

    state.Buff = {}

    -- Define general classes
    classes = {}
    -- Basic spell mappings based on common spell series (from JF-Mappings)
    classes.SpellMaps = spell_maps

    -- Colors for use in add_to_chat messages
    color = {}
    color.error  = 167
    color.notice = 006
    color.value  = 001

    -- Sub-tables that are expected, avoid defining in each job file
    sets.precast = {}
    sets.precast.FC = {}
    sets.precast.JA = {}
    sets.precast.WS = {}
    sets.precast.RA = {}
    sets.midcast = {}
    sets.midcast.RA = {}
    sets.midcast.Pet = {}
    sets.idle = {}
    sets.resting = {}
    sets.engaged = {}
    sets.defense = {}
    sets.buff = {}

    -- Sub-tables for gear slots
    -- Useful for briefly defining heavily augmented gear in multiple sets
    gear = {}
    gear.default = {}
    gear.main = {}
    gear.sub = {}
    gear.ranged = {}
    gear.ammo = {}
    gear.head = {}
    gear.neck = {}
    gear.ear = {}
    gear.body = {}
    gear.hands = {}
    gear.ring = {}
    gear.back = {}
    gear.waist = {}
    gear.legs = {}
    gear.feet = {}

    -- Include various utility functions
    include('JF-Utility')

    -- Include general user globals
    include('JF-Globals')

    -- Define any additional sets from *-globals.lua
    if define_global_sets then
        define_global_sets()
    end

    -- Global default binds from JF-Globals or user-globals
    (binds_on_load or global_on_load)()

    -- Job-specific variable initialization and setup
    if job_setup then
        job_setup()
    end

    -- User-specific variable initialization and setup
    if user_setup then
        user_setup()
    end

    init_gear_sets()

end

if not jf_include_version or jf_include_version < current_jf_include_version then
    add_to_chat(167, 'Warning: Your job file is out of date. Update to the latest baseline.')
    return
end

-- Auto-initialize
init_include()

if not file_unload then
    file_unload = function()
        if user_unload then
            user_unload()
        elseif job_file_unload then
            job_file_unload()
        end
        _G[(binds_on_unload and 'binds_on_unload') or 'global_on_unload']()
    end
end

----------------------------------------------------------------------------------------------------
-- Action Event Handling
----------------------------------------------------------------------------------------------------

function handle_actions(spell, action, position)

    -- Initialize eventArgs to allow cancelling
    local eventArgs = {handled = false, cancel = false}

    -- Get current spell mapping
    local spellMap = get_spell_map(spell)


    -- High level filtering
    if _G['filter_'..action] then
        _G['filter_'..action](spell, spellMap, eventArgs, position)
    end

    -- Process if not filtered
    if not eventArgs.cancel then

        -- User-specific handling
        if _G['user_'..action] then
            _G['user_'..action](spell, action, spellMap, eventArgs, position)

            if eventArgs.cancel then cancel_spell() end
        end

        -- Job-specific handling
        if not eventArgs.cancel and not eventArgs.handled and _G['job_'..action] then
            _G['job_'..action](spell, action, spellMap, eventArgs, position)

            if eventArgs.cancel then cancel_spell() end
        end

        -- Default handling
        if not eventArgs.cancel and not eventArgs.handled and _G['default_'..action] then
            _G['default_'..action](spell, spellMap, position)
        end

        -- User-specific post-handling
        if not eventArgs.cancel and _G['user_post_'..action] then
            _G['user_post_'..action](spell, action, spellMap, eventArgs, position)
        end

        -- Job-specific post-handling
        if not eventArgs.cancel and _G['job_post_'..action] then
            _G['job_post_'..action](spell, action, spellMap, eventArgs, position)
        end

        -- Final cleanup
        if _G['cleanup_'..action] then
            _G['cleanup_'..action](spell, spellMap, eventArgs, position)
        end

    end

end

----------------------------------------------------------------------------------------------------
-- Standard user-initiated GearSwap action hooks
----------------------------------------------------------------------------------------------------

function pretarget(spell)
    handle_actions(spell, 'pretarget')
end

function precast(spell, position)
    -- Create buff state variable if appropriate
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    handle_actions(spell, 'precast', position)
end

function midcast(spell)
    handle_actions(spell, 'midcast')
end

function aftercast(spell)
    -- Set buff state variable as appropriate
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english] or false
    end
    handle_actions(spell, 'aftercast')
end

function pet_midcast(spell)
    handle_actions(spell, 'pet_midcast')
end

function pet_aftercast(spell)
    handle_actions(spell, 'pet_aftercast')
end


----------------------------------------------------------------------------------------------------
-- Additional GearSwap event hooks
----------------------------------------------------------------------------------------------------

-- Called when player's subjob changes
function sub_job_change(newSub, oldSub)
    if user_setup then
        user_setup()
    end

    if job_sub_job_change then
        job_sub_job_change(newSub, oldSub)
    end

    send_command('gs c update')
end

-- Called when player's status changes (engaged/idle/resting)
function status_change(newStatus, oldStatus)

    -- Initialize eventArgs
    local eventArgs = {handled = false}

    -- Allow user-specific status change function
    if user_status_change then
        user_status_change(newStatus, oldStatus, eventArgs)
    end

    -- Allow job-specific status change function
    if job_status_change and not eventArgs.handled then
        job_status_change(newStatus, oldStatus, eventArgs)
    end

    -- Equip default gear if still not handled by user or job
    if not eventArgs.handled then
        --handle_equipping_gear(newStatus)
    end

end

-- Called when player gains or loses a buff
-- buff == name of buff gained or lost
-- gain == true if buff was gained, false if lost
-- details == player.buff_details table including buff name, id, duration, etc.
function buff_change(buff, gain, details)

    -- Initialize eventArgs
    local eventArgs = {handled = false}

    -- Create or set buff state variable based on gain
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end

    -- Allow user-specific buff change function
    if user_buff_change then
        user_buff_change(buff, gain, details, eventArgs)
    end

    -- Allow job-specific buff change function
    if job_buff_change and not eventArgs.handled then
        job_buff_change(buff, gain, details, eventArgs)
    end

end

-- Called when player's buff is refreshed
-- buff == name of buff refreshed
-- details == player.buff_details table including buff name, id, duration, etc.
function buff_refresh(buff, details)

    -- Initialize eventArgs
    local eventArgs = {handled = false}

    -- Allow user-specific buff refresh function
    if user_buff_refresh then
        user_buff_refresh(buff, details, eventArgs)
    end

    -- Allow job-specific buff refresh function
    if job_buff_refresh and not eventArgs.handled then
        job_buff_refresh(buff, details, eventArgs)
    end

end

-- Called when player gains or loses a pet
-- pet == name of pet gained or lost
-- gain == true if pet was gained, false if lost
function pet_change(pet, gain)

    -- Initialize eventArgs
    local eventArgs = {handled = false}

    -- Allow user-specific pet change function
    if user_pet_change then
        user_pet_change(pet, gain, eventArgs)
    end

    -- Allow job-specific pet change function
    if job_pet_change and not eventArgs.handled then
        job_pet_change(pet, gain, eventArgs)
    end

    -- Equip default gear if still not handled by user or job
    if not eventArgs.handled then
        --handle_equipping_gear(player.status)
    end

end

-- Called when player's pet's status changes
-- Also called after pet_change when the pet is released. Avoid automatically handling gear equips.
function pet_status_change(newStatus, oldStatus)

    -- Initialize eventArgs
    local eventArgs = {handled = false}

    -- Allow user-specific pet status change function
    if user_pet_status_change then
        user_pet_status_change(newStatus, oldStatus, eventArgs)
    end

    -- Allow job-specific pet status change function
    if job_pet_status_change and not eventArgs.handled then
        job_pet_status_change(newStatus, oldStatus, eventArgs)
    end

end

----------------------------------------------------------------------------------------------------
-- Utility functions required to construct gear sets
----------------------------------------------------------------------------------------------------

-- Get the mapping for a spell
function get_spell_map(spell)

    -- Get default spell mapping from classes variable
    local defaultSpellMap = classes.SpellMaps[spell.english]
    local jobSpellMap

    -- If job-specific override exists, call that function
    if job_get_spell_map then
        jobSpellMap = job_get_spell_map(spell, defaultSpellMap)
    end

    -- Return job-specific mapping or default mapping
    return jobSpellMap or defaultSpellMap

end
