windower.raw_register_event('incoming chunk', function(id, data)

    if id == 0x028 then

        local act = windower.packets.parse_action(data)
        local action = gearswap.ActionPacket.new(act)
        local cat = action:get_category_string()
        local spell = action:get_spell()

        -- Haste, Hastega (Spell), Refueling, Hastega (BP), Haste II, Hastega II, Erratic Flutter
        local hastes = S{57,385,530,595,511,602,710}

        if S{'spell_finish','avatar_tp_finish'}:contains(cat) and hastes:contains(spell.id) then

            for target in action:get_targets() do

                local target_name = target:get_name()
                local act_info

                for act in target:get_actions() do act_info = act:get_basic_info() end

                if target_name == player.name and act_info.param == 33 then
                    if S{511,602,710}:contains(spell.id) then
                        haste_type = 30
                    elseif S{530}:contains(spell.id) then
                        haste_type = 10
                    else
                        haste_type = 15
                    end
                end
            end
        end
    end
end)
