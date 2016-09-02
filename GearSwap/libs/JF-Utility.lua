--------------------------------------------------------------------------------
-- General utility functions that can be used by any job files.
--------------------------------------------------------------------------------

-- Enhanced keybind, including formatted chatlog output
function bind(key, cmd, name, disp)
    send_command('bind ' .. key .. ' ' .. cmd)
    key = key:upper():gsub('%^','Ctrl-'):gsub('%!','Alt-'):gsub('%@','Win-')
    if not disp then
        add_to_chat(color.notice,name..': '..string.color(key,color.value))
    end
end
