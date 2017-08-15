
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

appSelectMode = hs.hotkey.modal.new({}, 'F17')

local message = require('hammerspoon.status-message')
appSelectMode.statusMessage = message.new('App Select Mode')
appSelectMode.entered = function()
  appSelectMode.statusMessage:show()
end
appSelectMode.exited = function()
  appSelectMode.statusMessage:hide()
end

-- Bind the given key to call the given function and exit WindowLayout mode
function appSelectMode.bindWithAutomaticExit(mode, modifiers, key, fn)
  mode:bind(modifiers, key, function()
    mode:exit()
    fn()
  end)
end

appSelectMode:bindWithAutomaticExit({}, 's', function()
    launchApp('Spotify')
end)


local status, hyperModeAppMappings = pcall(require, 'keyboard.hyper-apps')

if not status then
  hyperModeAppMappings = require('hammerspoon.hyper-apps-defaults')
end

for i, mapping in ipairs(hyperModeAppMappings) do
    appSelectMode:bindWithAutomaticExit({}, mapping[1], function()
        launchApp(mapping[2])
    end)
end

-- Use Control+s to toggle WindowLayout Mode
hs.hotkey.bind({'shift','alt','cmd','ctrl'}, 'a', function()
  appSelectMode:enter()
end)
appSelectMode:bind({'shift','alt','cmd','ctrl'}, 'a', function()
  appSelectMode:exit()
end)

launchApp = function(appName)
    local app = hs.application.get(appName)
    if app then
      app:activate()
    else
      hs.application.launchOrFocus(appName)
    end
end
