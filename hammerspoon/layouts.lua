
layoutMode = hs.hotkey.modal.new({}, 'F18')

local message = require('hammerspoon.status-message')
layoutMode.statusMessage = message.new('Layout Mode')
layoutMode.entered = function()
  layoutMode.statusMessage:show()
end
layoutMode.exited = function()
  layoutMode.statusMessage:hide()
end

-- Bind the given key to call the given function and exit WindowLayout mode
function layoutMode.bindWithAutomaticExit(mode, modifiers, key, fn)
  mode:bind(modifiers, key, function()
    mode:exit()
    fn()
  end)
end

layoutMode:bindWithAutomaticExit({}, 'return', function()
  launchApp('Slack')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():moveOneScreenWest()
  up(hs.window.focusedWindow())

  launchApp('Microsoft Outlook')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():moveOneScreenWest()
  down(hs.window.focusedWindow())

  launchApp('Google Chrome')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():moveOneScreenNorth()
  hs.window.focusedWindow():maximize()

  launchApp('Insomnia')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('zoom.us')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('iTerm')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():moveOneScreenNorth()
  hs.window.focusedWindow():maximize()


end)

layoutMode:bindWithAutomaticExit({}, 'l', function()
  launchApp('Slack')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('Microsoft Outlook')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('Google Chrome')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('Insomnia')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('zoom.us')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()

  launchApp('iTerm')
  hs.window.focusedWindow():moveToScreen(hs.screen.primaryScreen())
  hs.window.focusedWindow():maximize()


end)

-- Use Control+s to toggle WindowLayout Mode
hs.hotkey.bind({'shift','alt','cmd','ctrl'}, 'l', function()
  launchApp('Outlook')
  layoutMode:enter()
end)
layoutMode:bind({'shift','alt','cmd','ctrl'}, 'l', function()
  layoutMode:exit()
end)
