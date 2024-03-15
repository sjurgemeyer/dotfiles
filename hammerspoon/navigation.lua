--------------------------------------------------------------------------------
-- Define WindowLayout Mode
--
-- WindowLayout Mode allows you to manage window layout using keyboard shortcuts
-- that are on the home row, or very close to it. Use Control+s to turn
-- on WindowLayout mode. Then, use any shortcut below to perform a window layout
-- action. For example, to send the window left, press and release
-- Control+s, and then press h.
--
--   h/j/k/l => send window to the left/bottom/top/right half of the screen
--   i => send window to the upper left quarter of the screen
--   o => send window to the upper right quarter of the screen
--   , => send window to the lower left quarter of the screen
--   . => send window to the lower right quarter of the screen
--   return => make window full screen
--   n => send window to the next monitor
--   left => send window to the monitor on the left (if there is one)
--   right => send window to the monitor on the right (if there is one)
--------------------------------------------------------------------------------

local navigationMode = hs.hotkey.modal.new({}, "F16")

navigationMode.statusMessage = require("hammerspoon.status-message").new("Navigation Mode")
navigationMode.helpMenu = require("hammerspoon.help-message").new()
navigationMode.helpData = require("hammerspoon.help-data").new()

navigationMode.entered = function()
	navigationMode.statusMessage:show()
end
navigationMode.exited = function()
	navigationMode.statusMessage:hide()
	navigationMode.helpMenu:hide()
end

-- Bind the given key to call the given function and exit WindowLayout mode
function navigationMode.bindWithAutomaticExit(mode, modifiers, key, fn)
	mode:bind(modifiers, key, function()
		mode:exit()
		fn()
	end)
end

function navigationMode.bindWithHelpText(mode, text, modifiers, key, fn)
	navigationMode.helpData.windowMenu[#navigationMode.helpData.windowMenu + 1] = { key = key, text = text }
	mode:bind(modifiers, key, function()
		fn()
	end)
end

function navigationMode.setHelpData(mode)
	--menuText = 'Apps\n'
	--for mapping, description in pairs(helpData.appMenu) do
	--menuText = menuText .. '\n' .. mapping .. ' - ' .. description
	--end
	--menuText = menuText .. '\n\nWindow Manipulation\n'
	--for mapping, description in pairs(helpData.windowMenu) do
	--menuText = menuText .. '\n' .. mapping .. ' - ' .. description
	--end

	--mode.helpMenu.message = menuText
	mode.helpMenu.helpData = navigationMode.helpData
end
-- Use hyper+q to toggle WindowLayout Mode
hs.hotkey.bind({ "shift", "alt", "cmd", "ctrl" }, "q", function()
	navigationMode:enter()
end)
navigationMode:bind({ "shift", "alt", "cmd", "ctrl" }, "q", function()
	navigationMode:exit()
end)
navigationMode:bind({}, "escape", function()
	navigationMode:exit()
end)
navigationMode:bind({ "shift" }, "/", function()
	navigationMode.helpMenu:toggle()
end)

local status, appShortcuts = pcall(require, "keyboard.hyper-apps")

if not status then
	appShortcuts = require("hammerspoon.hyper-apps-defaults")
end

for i, mapping in ipairs(appShortcuts) do
	navigationMode.helpData.appMenu[#navigationMode.helpData.appMenu + 1] = { key = mapping[1], text = mapping[2] }
	navigationMode:bindWithAutomaticExit({}, mapping[1], function()
		launchApp(mapping[2])
	end)
end

return navigationMode
