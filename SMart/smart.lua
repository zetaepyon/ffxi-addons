require 'pack'
require 'lists'

windower.register_event('outgoing chunk',function(id,org)
    if id == 0x5B then
        local data = org:unpack('I')
        local name = (windower.ffxi.get_mob_by_id(org:unpack('I',5)) or {}).name
        if L{'Ardrick'}:contains(name) then
            local outstr = org:sub(1,8)
            local choice = org:unpack('I',9)
            if choice == 0 or choice == 0x40000000 then
                return outstr..string.char(1,0,0x05,0)..org:sub(13)
            end
        end
    end
end
)
