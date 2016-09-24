----------------------------------------------------------------------------------------------------
-- Job State Display
----------------------------------------------------------------------------------------------------
-- Creates a customizable visual job state display for states managed by Modes.lua
--
-- Include in get_sets(), user_setup(), etc, or custom include file
--
-- By default, supports the following modal states:
-- OffenseMode, DefenseMode, HybridMode, IdleMode, WeaponskillMode, CastingMode,
-- MainStep, AltStep, TreasureMode, TotalHaste, DelayReduction
--
-- Additional modal states can be supported by defining a label mapping in update_job_states()
-- Boolean states require no modifications
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Initialize display
-- Call after defining job states in get_sets(), user_setup(), etc.
--
-- required     job_bools   List of boolean-type states to manage
-- required     job_modes   List of modal-type states to manage
--
-- EXAMPLE
-- function user_setup()
--      state.MagicBurst = M(false, 'Magic Burst')
--      state.CastingMode:options('Normal', 'Death')
--      state.IdleMode:options('Normal', 'Death')
--      init_job_states({"MagicBurst"},{"CastingMode","IdleMode"})
-- end
----------------------------------------------------------------------------------------------------
function init_job_states(job_bools,job_modes)

    stateList = job_modes
    stateBool = job_bools

    if stateBox then stateBox:destroy() end

    local settings = windower.get_windower_settings()
    local x,y = settings["ui_x_res"]-285, settings["ui_y_res"]-18

    stateBox = texts.new()
    stateBox:pos(x,y)
    stateBox:font('Arial')
    stateBox:size(11)
    stateBox:bold(true)
    stateBox:bg_alpha(128)
    stateBox:right_justified(true)
    stateBox:stroke_width(1)

    update_job_states(stateBox)

end

----------------------------------------------------------------------------------------------------
-- Update display
-- Call from state_change(), job_state_change(), etc.
----------------------------------------------------------------------------------------------------
function update_job_states()

    -- Define colors for text in the display
    local clr = {
        h='\\cs(255,255,0)', -- Yellow for active booleans and non-default modals
        n='\\cs(192,192,192)', -- White for labels and default modals
        s='\\cs(96,96,96)' -- Gray for inactive booleans
    }

    local info = {}
    local orig = {}
    local spc = '    '

    -- Define labels for each modal state
    local labels = {
        OffenseMode = "TP",
        DefenseMode = "D",
        HybridMode = "H",
        IdleMode = "I",
        WeaponskillMode = "WS",
        CastingMode = "Cast",
        MainStep = "Main",
        AltStep = "Alt",
        TreasureMode = "TH",
        TotalHaste = "Haste",
        DelayReduction = "DR"
    }

    stateBox:clear()
    stateBox:append(spc)

    -- Construct and append info for boolean states
    for i,n in pairs(stateBool) do

        -- Define color for modal state
        if state[n].index then stateBox:append(clr.h) else stateBox:append(clr.s) end

        -- Append basic formatted boolean state
        stateBox:append(state[n].description..clr.n)

        stateBox:append(spc)
    end

    -- Construct and append info for modal states
    for i,n in ipairs(stateList) do

        -- Format total haste and delay reduction as percentages
        if n == 'TotalHaste' or n == 'DelayReduction' then
            info[n] = state[n]..'%'
            orig[n] = '0%'
        else
            info[n] = state[n].current
            orig[n] = state[n][1]
        end
        if info[n] ~= orig[n] then
            info[n] = clr.h..info[n]..clr.n
        end

        -- Append basic formatted modal state
        stateBox:append(string.format("%s: ${%s}", labels[n], n))

        -- Add additional information for active hybrid defense mode
        if n == 'OffenseMode' and state.HybridMode.current ~= state.HybridMode[1] then
            stateBox:append(string.format("%s / %s%s%s", clr.n, clr.h, state.HybridMode.current, clr.n))
        end

        stateBox:append(spc)
    end

    -- Update and display current info
    stateBox:update(info)
    stateBox:show()

end

----------------------------------------------------------------------------------------------------
-- Clean up display objects
-- Call from file_unload(), user_unload(), etc.
----------------------------------------------------------------------------------------------------
function clear_job_states()

    stateBox:destroy()

end
