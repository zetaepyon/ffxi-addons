<<<<<<< HEAD
----------------------------------------------------------------------------------------------------
-- Monitor action packet
-- Watches action packets for spell/blood pact completion and sets haste_type variable
----------------------------------------------------------------------------------------------------
=======
>>>>>>> 612ec69... Initial commit - raw_register_event
windower.raw_register_event('incoming chunk', function(id, data)

    if id == 0x028 then

        local act = windower.packets.parse_action(data)
        local action = gearswap.ActionPacket.new(act)
        local cat = action:get_category_string()
        local spell = action:get_spell()

<<<<<<< HEAD
        local hastes = {
            [57]  = 15, -- Haste
            [385] = 15, -- Hastega (Spell)
            [511] = 30, -- Haste II
            [530] = 10, -- Refueling
            [595] = 15, -- Hastega (BP)
            [602] = 30, -- Hastega II
            [710] = 30  -- Erratic Flutter
        }

        if S{'spell_finish','avatar_tp_finish'}:contains(cat) and hastes[spell.id] then
=======
        -- Haste, Hastega (Spell), Refueling, Hastega (BP), Haste II, Hastega II, Erratic Flutter
        local hastes = S{57,385,530,595,511,602,710}

        if S{'spell_finish','avatar_tp_finish'}:contains(cat) and hastes:contains(spell.id) then
>>>>>>> 612ec69... Initial commit - raw_register_event

            for target in action:get_targets() do

                local target_name = target:get_name()
                local act_info

                for act in target:get_actions() do act_info = act:get_basic_info() end

                if target_name == player.name and act_info.param == 33 then
<<<<<<< HEAD
                    haste_type = hastes[spell.id]
=======
                    if S{511,602,710}:contains(spell.id) then
                        haste_type = 30
                    elseif S{530}:contains(spell.id) then
                        haste_type = 10
                    else
                        haste_type = 15
                    end
>>>>>>> 612ec69... Initial commit - raw_register_event
                end
            end
        end
    end
end)
<<<<<<< HEAD

----------------------------------------------------------------------------------------------------
-- Calculate total haste
-- Calculates total amount of haste based on magic, job abilities, and equipment
----------------------------------------------------------------------------------------------------
-- returns  haste.total     Total combined haste (Cap 80%)
--          haste.ma        Magic haste (Cap 43.75%)
--          haste.ja        Job ability haste (Cap 25%)
--          haste.eq        Equipment haste (Cap 25%)
----------------------------------------------------------------------------------------------------
function calc_haste()

    -- Set up variables
    local haste = {ma = 0, ja = 0, eq = 0, total = 0}

    local march1 = state.March1 or 'Victory March'
    local march2 = state.March2 or 'Advancing March'

    local ma_values = {
        ['Mighty Guard']    = 15,
        ['Indi-Haste']      = state.IndiHaste or 2, --40
        ['Geo-Haste']       = state.GeoHaste or 2, --40
        ['Advancing March'] = state.AdvancingMarch or 6, --14
        ['Victory March']   = state.VictoryMarch or 9, --17
        ['Honor March']     = state.HonorMarch or 10, --15
        ['Embrava']         = 25,
    }
    local ja_values = {
        ['Haste Samba']     = 10,
        ['Hasso']           = 10
    }

    -- Add in optional equipment haste state up to 25%
    haste.eq = state.EquipmentHaste or 0
    if haste.eq > 25 then haste.eq = 25 end

    -- Calculate magic haste up to 43.75%
    for k,v in pairs(ma_values) do
        if buffactive[k] then
            haste.ma = haste.ma + v
        end
    end
    if buffactive['March'] then
        haste.ma = haste.ma + ma_values[march1]
        if buffactive['March'] == 2 then
            haste.ma = haste.ma + ma_values[march2]
        end
    end
    if haste_type then haste.ma = haste.ma + haste_type end
    if haste.ma > 43.75 then haste.ma = 43.75 end

    -- Calculate job ability haste up to 25%
    for k,v in pairs(ja_values) do
        if buffactive[k] then haste.ja = haste.ja + v end
    end
    if haste.ja > 25 then haste.ja = 25 end

    -- Calculate total haste up to 80%
    haste.total = haste.ma + haste.ja + haste.eq
    if haste.total > 80 then haste.total = 80 end

    -- Update state variable, if it exists
    if state.TotalHaste then state.TotalHaste = haste.total end

    return haste.total, haste.ma, haste.ja, haste.eq

end

----------------------------------------------------------------------------------------------------
-- Calculate delay reduction
-- Calculates overall delay reduction based on amount of dual wield and haste
----------------------------------------------------------------------------------------------------
-- requires haste       Total haste (e.g. from calc_haste) to use for calculation
-- optional dualwield   Amount of dual wield to use for calculation
--
-- returns  reduction   Total delay reduction, including specified haste
----------------------------------------------------------------------------------------------------
function calc_delay_reduction(haste, dualwield)

    local percentages = {0.10, 0.15, 0.25, 0.30, 0.35} -- Dual wield reduction tiers
    local dw = percentages[(state.DualWield or dualwield or 0)] or 0
    local delay = (1 - dw) * (1 - haste/100)
    local reduction = (1 - delay) * 100

    if reduction > 80 then reduction = 80.0 end
    --reduction = math.round(reduction,2)

    -- Update state variable, if it exists
    if state.DelayReduction then state.DelayReduction = reduction end

    return reduction

end
=======
>>>>>>> 612ec69... Initial commit - raw_register_event
