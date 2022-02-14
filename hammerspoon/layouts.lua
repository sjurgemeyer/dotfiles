local status, hyperModeLayoutMappings = pcall(require, 'keyboard.hyper-layouts')

spoon.SpoonInstall:andUse("ArrangeDesktop", { })
if not status then
  hyperModeLayoutMappings = require('hammerspoon.hyper-layout-defaults')
end

for i, mapping in ipairs(hyperModeLayoutMappings) do
    navigationMode:bindWithAutomaticExit({}, mapping[1], function()
        setLayout(mapping[2])
    end)
end

setLayout = function(layout)
    spoon.ArrangeDesktop:addMenuItems()
    spoon.ArrangeDesktop:arrange(layout)
end

hs.hotkey.bind({'shift','alt','cmd','ctrl'}, '0', function()
    spoon.ArrangeDesktop.createArrangement()
end)

