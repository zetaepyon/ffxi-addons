----------------------------------------------------------------------------------------------------
-- Monitor action packet
-- Watches action packets for spell/blood pact completion and sets haste_type variable
----------------------------------------------------------------------------------------------------
windower.raw_register_event('incoming chunk', function(id, data)

    if id == 0x028 then

        local act = windower.packets.parse_action(data)
        local action = gearswap.ActionPacket.new(act)
        local cat = action:get_category_string()
        local spell = action:get_spell()

        local actor = action:get_id()

        local allies = T{}
        for i=1,party.count do allies:append(party[i].id) end

        local hastes = T{
            [57]  = 15, -- Haste                150 / 1024
            [385] = 15, -- Hastega (Spell)      153 / 1024
            [511] = 30, -- Haste II             307 / 1024
            [530] = 10, -- Refueling            102 / 1024
            [595] = 15, -- Hastega (BP)         153 / 1024
            [602] = 30, -- Hastega II           307 / 1024
            [661] = 15, -- Animating Wail       150 / 1024
            [710] = 30  -- Erratic Flutter      307 / 1024
        }

        local haste_spell = spell and hastes:containskey(spell.id) or false

        if S{'spell_finish','avatar_tp_finish'}:contains(cat) and haste_spell then
        --if ((cat == 'spell_finish' and allies:contains(actor)) or cat == 'avatar_tp_finish') and hastes[spell.id] then


            for target in action:get_targets() do

                local target_name = target:get_name()
                if target_name == player.name then haste_type = hastes[spell.id] end

            end
        end
    end
end)

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
        ['Indi-Haste']      = state.IndiHaste or 30,     --Assume 900 skill, Idris: 40
        ['Geo-Haste']       = state.GeoHaste or 30,      --Assume 900 skill, Idris: 40
        ['Advancing March'] = state.AdvancingMarch or 6, --14
        ['Victory March']   = state.VictoryMarch or 9,   --17
        ['Honor March']     = state.HonorMarch or 10,    --15
        ['Embrava']         = 25,
    }
    local ja_values = {
        ['Haste Samba']     = 10,
        ['Hasso']           = 10,
        ['Last Resort']     = state.LastResort or 15
    }

    -- Add in optional equipment haste state up to 25%
    --haste.eq = state.EquipmentHaste or 0
    haste.eq = calc_gear_stat('haste') or 0

    if haste.eq > 25 then haste.eq = 25 end

    -- Calculate magic haste up to 43.75%
    for k,v in pairs(ma_values) do
        if buffactive[k] then haste.ma = haste.ma + v end
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

    return {haste.total, haste.ma, haste.ja, haste.eq}

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

    local percentages = {0.10, 0.15, 0.25, 0.30, 0.35, 0.37} -- Dual wield reduction tiers
    local job_dw = percentages[(state.DualWield or dualwield or 0)] or 0
    local gear_dw = (calc_gear_stat('dual_wield')/100) or 0
    local delay = (1 - job_dw - gear_dw) * (1 - haste/100)
    local reduction = (1 - delay) * 100

    if reduction > 80 then reduction = 80.0 end

    -- Update state variable, if it exists
    if state.DelayReduction then state.DelayReduction = reduction end

    return reduction

end

----------------------------------------------------------------------------------------------------
-- Calculate gear statistic
-- Calculates total amount of a stat on currently-equipped gear
----------------------------------------------------------------------------------------------------
-- optional stat        Type of statistic to calculate (e.g. haste, dual_wield)
--
-- returns  total_stat  Total statistic value from equipped gear
--
-- Gear values must be defined in data.gear_stats['Item Name'].stat to be counted.
-- Gear not found in data.gear_stats will return a value of 0 for that slot.
--
-- Example: data.gear_stats['Adhemar Jacket'].dual_wield
----------------------------------------------------------------------------------------------------
function calc_gear_stat(stat)

    local stat = stat or 'haste'
    local total_stat = 0

    for slot=0,15 do

        local eq = {}
        eq.name = player.equipment[gearswap.toslotname(slot)]
        eq.stat = 0

        if data.gear_stats[eq.name] then eq.stat = data.gear_stats[eq.name][stat] end

        total_stat = total_stat + eq.stat

    end

    return total_stat

end
