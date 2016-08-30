_addon.name = 'S-Mart'
_addon.name = 'Talym'
_addon.version = '1.00'
_addon.commands = {'sm'}

require 'pack'
require 'lists'

config = require('config')

local default_settings = {}
default_settings.displacers = false
default_settings.acheron = false
default_settings.darksteel = false

settings = config.load(default_settings)

windower.register_event('addon command', function(command, ...)

    command = command and command:lower() or 'help'
    local params = {...}

    if command == 'help' then
        windower.add_to_chat(204, _addon.name .. ' v' .. _addon.version .. '. Author: ' .. _addon.author)
        windower.add_to_chat(006, 'sm displacer on/off : Manage voidwatch displacer purchasing (gil)')
        windower.add_to_chat(006, 'sm acheron on/off : Manage acheron shield purchasing (sparks)')
        windower.add_to_chat(006, 'sm darksteel on/off : Manage darksteel buckler purchasing (sparks)')
        windower.add_to_chat(006, 'sm help : Shows help message')
    end
end)

windower.register_event('outgoing chunk',function(id,org)
    if id == 0x5B then
        local data = org:unpack('I')
        local name = (windower.ffxi.get_mob_by_id(org:unpack('I',5)) or {}).name
        if settings.displacers == true and L{'Ardrick'}:contains(name) then
            local outstr = org:sub(1,8)
            local choice = org:unpack('I',9)
            if choice == 0 or choice == 0x40000000 then
                return outstr..string.char(1,0,0x05,0)..org:sub(13)
            end
        end
    end
end
)
