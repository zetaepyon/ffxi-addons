--------------------------------------------------------------------------------
-- General utility functions that can be used by any job files.
--------------------------------------------------------------------------------

-- Enhanced keybind, including formatted chatlog output
function bind(key, cmd, name)
    send_command('bind' .. key .. ' input '.. cmd)
    key = key:upper():gsub('%^','Ctrl-'):gsub('%!','Alt-'):gsub('%@','Win-')
    add_to_chat(210,name..': '..string.color(key,001))
end
