local drawing = require 'hs.drawing'
local geometry = require 'hs.geometry'
local screen = require 'hs.screen'
local styledtext = require 'hs.styledtext'

local helpmessage = {}
helpmessage.new = function()
  local buildParts = function(helpData)
    local frame = screen.primaryScreen():frame()

    local titleTextAttributes = {
      font = { name = 'Monaco', size = 24 },
      color = { red = 0, green = 0, blue = 0, alpha=0.9}
    }
    local listTextAttributes = {
      font = { name = 'Monaco', size = 14 },
      color = { red = 0, green = 0, blue = 0, alpha=0.9}
    }

    local appText = ''
    for _, value in ipairs(helpData.appMenu) do
        appText = appText .. '\n' .. value.key .. ' - ' .. value.text
    end

    local windowText = ''
    for _, value in ipairs(helpData.windowMenu) do
        windowText = windowText .. '\n' .. value.key .. ' - ' .. value.text
    end

    local styledAppText = styledtext.new(appText, listTextAttributes)
    local styledWindowText = styledtext.new(windowText, listTextAttributes)

    local appTextSize = drawing.getTextDrawingSize(styledAppText)
    local windowTextSize = drawing.getTextDrawingSize(styledWindowText)

    local windowWidth = appTextSize.w + windowTextSize.w + 100
    local windowHeight = math.max(appTextSize.h, windowTextSize.h) + 100
    local windowX = (frame.w  - windowWidth) / 2
    local windowY = (frame.h - windowHeight) / 2

    local appTitle = drawing.text({
        w = appTextSize.w + 40,
        h = 40,
        x = windowX + 10,
        y = windowY + 10
    }, styledtext.new('Apps', titleTextAttributes))
    local appTextBox = drawing.text({
        w = appTextSize.w + 40,
        h = appTextSize.h + 40,
        x = windowX + 10,
        y = windowY + 40
    }, styledAppText):setAlpha(0.9)
    local windowTitle = drawing.text({
        w = windowTextSize.w + 40,
        h = 40,
        x = windowX + appTextSize.h + 10,
        y = windowY + 10
    }, styledtext.new('Window Motion', titleTextAttributes))
    local windowTextBox = drawing.text({
        w = windowTextSize.w + 40,
        h = windowTextSize.h + 40,
        x = windowX + appTextSize.w + 80,
        y = windowY + 40
    }, styledWindowText):setAlpha(0.9)

    local background = drawing.rectangle({
      w = windowWidth,
      h = windowHeight,
      x = windowX,
      y = windowY
    })
    background:setRoundedRectRadii(10, 10)
    background:setFillColor({ red = .8, green = .8, blue = .8, alpha=0.9 })

    texts = {}
    texts[1] = appTextBox
    texts[2] = windowTextBox
    texts[3] = appTitle
    texts[4] = windowTitle
    return background, texts
  end

  function getHelpText(helpData)

    menuText = 'Apps\n'
    for mapping, description in pairs(helpData.appMenu) do
        menuText = menuText .. '\n' .. mapping .. ' - ' .. description
    end
    menuText = menuText .. '\n\nWindow Manipulation\n'
    for mapping, description in pairs(helpData.windowMenu) do
        menuText = menuText .. '\n' .. mapping .. ' - ' .. description
    end

    return menuText

  end

  return {
    _buildParts = buildParts,
    helpData,
    text = nil,
    show = function(self)
      self:hide()

      local log = hs.logger.new('init.lua', 'debug')
log.d('Help data', helpData)
      self.background, self.text = self._buildParts(self.helpData)
      self.background:show()
          log.d('Is this working?', self.text)
      for x, y in ipairs(self.text) do
          log.d('Showing', x)
          y:show()
      end
    end,
    hide = function(self)
      if self.background then
        self.background:delete()
        self.background = nil
      end
      if self.text then
        for x, y in ipairs(self.text) do
            y:delete()
        end
        self.text = nil
      end
    end,
    notify = function(self, seconds)
      local seconds = seconds or 1
      self:show()
      hs.timer.delayed.new(seconds, function() self:hide() end):start()
    end,
    toggle = function(self)
        if self.text or self.background then
            self:hide()
        else
            self:show()
        end
    end
  }
end

return helpmessage
