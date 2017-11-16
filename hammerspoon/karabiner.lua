restart_karabiner = function()
    log.i("restarting stuff")
    hs.application.launchOrFocus('Karabiner-Elements')
end

log = hs.logger.new('karabiner')
hs.application.enableSpotlightForNameSearches(true)
restart_karabiner_handler = hs.timer.delayed.new(3.0, restart_karabiner)

hs.hotkey.bind({'shift','alt','cmd','ctrl'}, 'k', function()
    log.i("restarting karabiner")
    elements = hs.application.get('Karabiner-Elements')
    log.i(elements)
    elements:kill()
    menu = hs.application.get('Karabiner-Menu')
    log.i(menu)
    menu:kill()
    log.e(menu:getMenuItems())
    hs.execute("launchctl remove org.pqrs.karabiner.karabiner_console_user_server", true)
    log.i("done doing stuff")

    restart_karabiner_handler:start()
end)
