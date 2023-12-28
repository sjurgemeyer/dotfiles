local drawing = require 'hs.drawing'
local geometry = require 'hs.geometry'
local screen = require 'hs.screen'
local styledtext = require 'hs.styledtext'

local statusmessage = {}
statusmessage.new = function(messageText)
  local buildParts = function(messageText)
    local frame = screen.primaryScreen():frame()

    local styledTextAttributes = {
      font = { name = 'Monaco', size = 32 },
      color = { red = 0, green = 0, blue = 0, alpha=0.9}
    }

    local styledText = styledtext.new('🔨 ' .. messageText, styledTextAttributes)

    local styledTextSize = drawing.getTextDrawingSize(styledText)
    local textRect = {
      x = (frame.w - styledTextSize.w - 40) /2,
      y = (frame.h - styledTextSize.h) /2,
      w = styledTextSize.w + 40,
      h = styledTextSize.h + 40,
    }
    local text = drawing.text(textRect, styledText):setAlpha(0.9)

    local background = drawing.rectangle(
      {
        x = (frame.w - styledTextSize.w - 45) / 2,
        y = (frame.h - styledTextSize.h - 6) / 2,
        w = styledTextSize.w + 15,
        h = styledTextSize.h + 12
      }
    )
    background:setRoundedRectRadii(10, 10)
    background:setFillColor({ red = .8, green = .8, blue = .8, alpha=0.9 })

    return background, text
  end

  return {
    _buildParts = buildParts,
    show = function(self)
      self:hide()

      self.background, self.text = self._buildParts(messageText)
      self.background:show()
      self.text:show()
    end,
    hide = function(self)
      if self.background then
        self.background:delete()
        self.background = nil
      end
      if self.text then
        self.text:delete()
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

return statusmessage
