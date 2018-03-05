karabiner_mode = 'default'
restart_karabiner = function()
    log.i("restarting stuff")
    if karabiner_mode == 'default' then
        karabiner_mode = 'external'
    else
        karabiner_mode = 'default'
    end

    hs.notify.new({title="Hammerspoon", informativeText='Setting profile to ' .. karabiner_mode}):send()
    hs.execute("rm -Rf $HOME/.config/karabiner/karabiner.json", true)
    hs.execute("ln -s $HOME/projects/dotfiles/karabiner-" .. karabiner_mode .. ".json $HOME/.config/karabiner/karabiner.json", true)
    hs.application.launchOrFocus('Karabiner-Elements')
end

log = hs.logger.new('karabiner')
hs.application.enableSpotlightForNameSearches(true)
restart_karabiner_handler = hs.timer.delayed.new(3.0, restart_karabiner)

hs.hotkey.bind({'shift','alt','cmd','ctrl'}, 'k', function()
    log.i("restarting karabiner")
    hs.notify.new({title="Hammerspoon", informativeText='Restarting Karabiner'}):send()
    elements = hs.application.get('Karabiner-Elements')
    log.i(elements)
    if (elements) then
        elements:kill()
    end
    menu = hs.application.get('Karabiner-Menu')
    log.i(menu)
    if (menu) then
        menu:kill()
    end
    hs.execute("launchctl remove org.pqrs.karabiner.karabiner_console_user_server", true)
    log.i("done doing stuff")

    restart_karabiner_handler:start()
end)
