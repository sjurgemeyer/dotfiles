local status, hyperModeAppMappings = pcall(require, 'keyboard.hyper-apps')

if not status then
  hyperModeAppMappings = require('hammerspoon.hyper-apps-defaults')
end

for i, mapping in ipairs(hyperModeAppMappings) do
    navigationMode:bindWithAutomaticExit({}, mapping[1], function()
        launchApp(mapping[2])
    end)
end

launchApp = function(appName)
    local app = hs.application.get(appName)
    if app then
      app:activate()
    else
      hs.application.launchOrFocus(appName)
    end
end


local hyperModeFkeyAppMappings = require('hammerspoon.hyper-apps-fkey-defaults')

for i, mapping in ipairs(hyperModeFkeyAppMappings) do
    hs.hotkey.bind({'shift', 'alt', 'cmd', 'ctrl'}, mapping[1], function()
        launchApp(mapping[2])
    end)
end
