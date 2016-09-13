function get_sets()

    user_setup()

    sets.precast = {}
    sets.midcast = {}

end

function user_setup()

    include('Modes.lua')
    include('haste-tracker.lua')

    classes = classes or {}
    classes.Hastes = S{'Haste','March','Embrava','Haste Samba','Mighty Guard'}

    -- State variables for haste & delay reduction calculation and display
    state = state or {}
    --state.March1 = 'Victory March'
    --state.March2 = 'Advancing March'
    state.VictoryMarch = 17
    state.AdvancingMarch = 14
    --state.HonorMarch = 15
    --state.IndiHaste = 40
    --state.GeoHaste = 40
    state.EquipmentHaste = 25  -- Assumed value of equipment haste
    state.DelayReduction = 0
    state.TotalHaste = 0
    --state.DualWield = 5

end

function buff_change(buff, gain, buff_details)

    if classes.Hastes:contains(buff) then

        if buff == 'Haste' and not gain then haste_type = 0 end

        local haste = {calc_haste()}
        local delay = calc_delay_reduction(haste[1])

        windower.add_to_chat(006, string.format("Total Haste: %2d%% (M:%2d J:%2d E:%2d)", haste[1], haste[2], haste[3], haste[4]))
        windower.add_to_chat(006, string.format("Delay Reduction: %2.2f%%", delay))

    end

end

function buff_refresh(buff, buff_details)

    if classes.Hastes:contains(buff) then

        local haste = {calc_haste()}
        local delay = calc_delay_reduction(haste[1])

        windower.add_to_chat(006, string.format("Total Haste: %2d%% (M:%2d J:%2d E:%2d)", haste[1], haste[2], haste[3], haste[4]))
        windower.add_to_chat(006, string.format("Delay Reduction: %2.2f%%", delay))

    end

end
