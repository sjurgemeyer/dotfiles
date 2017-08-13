-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

send_escape = false
hyper_active = false

check_for_escape = function()
	send_escape = false
end

check_escape_handler = hs.timer.delayed.new(0.15, check_for_escape)

hyper_handler = function(evt)
	local new_mods = evt:getFlags()
	if not hyper_active then
		if new_mods["ctrl"] and
			new_mods["shift"] and
			new_mods["alt"] and
			new_mods["cmd"] then

			hyper_active = true
			send_escape = true
			check_escape_handler:start()
		end
	else
		if not (new_mods["ctrl"] and
			new_mods["shift"] and
			new_mods["alt"] and
			new_mods["cmd"]) then

			hyper_active = false
			if (send_escape) then
				keyUpDown({}, 'escape')
			end
		end
	end
	return false
end

hyper_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, hyper_handler)
hyper_tap:start()
