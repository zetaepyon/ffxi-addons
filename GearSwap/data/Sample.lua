-- Initialization function
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

end
