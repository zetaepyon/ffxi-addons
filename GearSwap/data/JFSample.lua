----------------------------------------------------------------------------------------------------
-- Sample Job Script
-- For use with JobFramework (JF-Include)
----------------------------------------------------------------------------------------------------

-- Base initialization function
function get_sets()
    jf_include_version = 1

    -- Load and initialize include file
    include('JF-Include')

end

-- Set up user-independent variables
function job_setup()
end

-- Set up user-dependent variables
function user_setup()

    state.OffenseMode:options('Normal','MidAcc','HighAcc')
    state.DefenseMode:options('Normal','DT')
    state.WeaponskillMode:options('Normal','Acc')

end

-- Define sets and variables used by this job file
function init_gear_sets()

    -------------------------
    -- Precast Sets
    -------------------------
    -- Fast cast for spells
    sets.precast.FC = {}

    -- Weaponskill sets
    sets.precast.WS = {}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -------------------------
    -- Midcast Sets
    -------------------------

    -------------------------
    -- Idle Sets
    -------------------------
    sets.idle = {}
    sets.idle.Weak = {}

    -------------------------
    -- Engaged Sets
    -------------------------
    sets.engaged = {
        --main   = "",
        --sub    = "",
        --ranged = "",
        ammo   = "",
        head   = "",
        neck   = "",
        lear   = "",
        rear   = "",
        body   = "",
        hands  = "",
        lring  = "",
        rring  = "",
        back   = "",
        waist  = "",
        legs   = "",
        feet   = ""
        }

    sets.engaged.MidAcc = {}
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, {})

    sets.engaged.HighAcc = {}
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, {})

end

function job_precast(spell, action, spellMap, eventArgs)
end

function job_post_midcast(spell, action, spellmap, eventArgs)
end

function job_state_change(stateField, newValue, oldValue)
end

function job_get_spell_map(spell, default_spell_map)
end
