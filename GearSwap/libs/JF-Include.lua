--------------------------------------------------------------------------------
-- Common vars and functions for job scripts, for general default handling
--
-- Include this file in the get_sets() function with the command:
-- include('JF-Include.lua')
--
-- IMPORTANT: This include requires supporting include files:
-- JF-Utility
-- Modes
--
--------------------------------------------------------------------------------

current_jf_include_version = 1

function init_include()

    -- Include for mode-tracking variable class, used for state variables.
    include('Modes')

    -- Base for state values
    state = {}

    state.OffenseMode     = M{['description'] = 'OffenseMode'}
    state.WeaponskillMode = M{['description'] = 'Weaponskill Mode'}
    state.CastingMode     = M{['description'] = 'Casting Mode'}
    state.IdleMode        = M{['description'] = 'Idle Mode'}

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

    gear = {}
    gear.default = {}

    if define_global_sets then
        define_global_sets()
    end

    if job_setup then
        job_setup()
    end

    if user_setup then
        user_setup()
    end

    init_gear_sets()

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

--------------------------------------------------------------------------------
-- Standard GearSwap action hooks
--------------------------------------------------------------------------------

function pretarget(spell)
end

function precast(spell)
end

function midcast(spell)
end

function aftercast(spell)
end

function pet_midcast(spell)
end

function pet_aftercast(spell)
end
