require('hammerspoon.window-functions')

navigationMode:bindWithAutomaticExit({}, 'return', function()
  hs.window.focusedWindow():maximize()
end)

navigationMode:bindWithAutomaticExit({}, 'space', function()
  centerWithFullHeight(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Left half', {}, 'h', function()
  left(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Bottom', {}, 'j', function()
  down(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Top', {}, 'k', function()
  up(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Right', {}, 'l', function()
  right(hs.window.focusedWindow())
end)

navigationMode:bind({'shift'}, 'h', function()
  left40(hs.window.focusedWindow())
end)

navigationMode:bind({'shift'}, 'l', function()
  right60(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Upper left', {}, 'q', function()
  upLeft(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Upper right', {}, 'p', function()
  upRight(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Bottom left', {}, 'a', function()
  downLeft(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Bottom right', {}, ';', function()
  downRight(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Next screen', {}, 'n', function()
  nextScreen(hs.window.focusedWindow())
end)

navigationMode:bindWithHelpText('Up screen', {}, 'up', function()
  hs.window.focusedWindow():moveOneScreenNorth()
  hs.window.focusedWindow():maximize()
end)

navigationMode:bindWithHelpText('Down screen', {}, 'down', function()
  hs.window.focusedWindow():moveOneScreenSouth()
  hs.window.focusedWindow():maximize()
end)

navigationMode:bindWithHelpText('Right screen', {}, 'right', function()
  hs.window.focusedWindow():moveOneScreenEast()
  hs.window.focusedWindow():maximize()
end)

navigationMode:bindWithHelpText('Left screen', {}, 'left', function()
  hs.window.focusedWindow():moveOneScreenWest()
  hs.window.focusedWindow():maximize()
end)

