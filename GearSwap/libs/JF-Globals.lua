function define_global_sets()
end

function global_on_load()
    bind('f9','gs c cycle OffenseMode','Cycle Offense Mode')
    bind('f10','gs c cycle DefenseMode','Cycle Defense Mode')
    bind('f11','gs c cycle CastingMode','Cycle Casting Mode')
    bind('f12','gs c cycle IdleMode','Cycle Idle Mode')

end

function global_on_unload()
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f11')
    send_command('unbind f12')
end
