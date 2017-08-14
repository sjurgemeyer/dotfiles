-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

send_left_paren = false
send_right_paren = false

left_shift_active = false
right_shift_active = false

check_for_left_paren = function()
    send_left_paren = false
end
check_for_right_paren = function()
    send_right_paren = false
end

check_left_paren_handler = hs.timer.delayed.new(0.15, check_for_left_paren)
check_right_paren_handler = hs.timer.delayed.new(0.15, check_for_right_paren)

shift_handler = function(evt)

    local key_code = evt:getKeyCode()
    local new_mods = evt:getFlags()

    if key_code == 0x38 then

        if not left_shift_active then
            if new_mods["shift"]
                and not new_mods["cmd"]
                and not new_mods["ctrl"]
                and not new_mods["alt"] then
                left_shift_active = true
                send_left_paren = true
                check_left_paren_handler:start()
            end
        else
            if not new_mods["shift"]
                and not new_mods["cmd"]
                and not new_mods["ctrl"]
                and not new_mods["alt"] then
                left_shift_active = false
                if (send_left_paren) then
                    keyUpDown({"shift"}, '9')
                        check_left_paren_handler:stop()
                        send_left_paren = false
                end
            end
        end
    end
    if key_code == 0x3c then

        if not right_shift_active then
            if new_mods["shift"]
                and not new_mods["cmd"]
                and not new_mods["ctrl"]
                and not new_mods["alt"] then
                right_shift_active = true
                    send_right_paren = true
                check_right_paren_handler:start()
            end
        else
            if not new_mods["shift"]
                and not new_mods["cmd"]
                and not new_mods["ctrl"]
                and not new_mods["alt"] then
                right_shift_active = false
                if (send_right_paren) then
                    keyUpDown({"shift"}, '0')
                        check_right_paren_handler:stop()
                        send_right_paren = false
                end
            end
        end
    end
    return false
end

--If we type at least one capital letter we don't want parens
keydown_handler = function(evt)

    local key_code = evt:getKeyCode()

    if not (key_code == 0x38) then
            check_left_paren_handler:stop()
            send_left_paren = false
        end
    if not (key_code == 0x3c) then
            check_right_paren_handler:stop()
            send_right_paren = false
        end
    return false
end

shift_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, shift_handler)
keydown_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, keydown_handler)

shift_tap:start()
keydown_tap:start()
