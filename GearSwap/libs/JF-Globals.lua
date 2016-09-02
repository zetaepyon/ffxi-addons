function define_global_sets()
end

function global_on_load()
    bind('f9', 'gs c cycle OffenseMode', 'Cycle Offense Mode', true)
    bind('!f9', 'gs c cycle RangedMode', 'Cycle Ranged Mode', true)
    bind('@f9', 'gs c cycle WeaponskillMode', 'Cycle Weaponskill Mode', true)
    bind('f10', 'gs c cycle DefenseMode', 'Cycle Defense Mode', true)
    bind('f11', 'gs c cycle CastingMode', 'Cycle Casting Mode', true)
    bind('f12', 'gs c cycle IdleMode', 'Cycle Idle Mode', true)
end

function global_on_unload()
    send_command('unbind f9')
    send_command('unbind !f9')
    send_command('unbind @f9')
    send_command('unbind f10')
    send_command('unbind f11')
    send_command('unbind f12')
end
