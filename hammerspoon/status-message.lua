local canvas = require 'hs.canvas'
local styledtext = require 'hs.styledtext'
local drawing = require 'hs.drawing'

local statusmessage = {}
statusmessage.new = function(messageText)
  local buildParts = function(messageText, screen)
    local frame = screen:frame()

    local styledTextAttributes = {
      font = { name = 'Monaco', size = 32 },
      color = { red = 0, green = 0, blue = 0, alpha=0.9}
    }

    local styledText = styledtext.new(messageText, styledTextAttributes)

    local canvasObj = canvas.new({x = frame.x, y = frame.y, w = frame.w, h = frame.h})
    local styledTextSize = canvasObj:minimumTextSize(styledText)
    local textRect = {
      x = frame.w - styledTextSize.w - 60,  -- Position from right with 60px padding
      y = frame.h - styledTextSize.h - 60,  -- Position from bottom with 60px padding
      w = styledTextSize.w + 40,
      h = styledTextSize.h + 40,
    }

    -- Create a canvas that covers the entire screen

    -- Add background rectangle (covers the entire screen)
    canvasObj[1] = {
      type = "rectangle",
      action = "fill",
      fillColor = { red = .8, green = .8, blue = .8, alpha=0.3 },
      roundedRectRadii = { xRadius = 10, yRadius = 10 },
      frame = { x = 0, y = 0, w = frame.w, h = frame.h }
    }

    -- Add text
    canvasObj[2] = {
      type = "text",
      text = styledText,
      textAlignment = "right",
      textLineBreak = "clip",
      frame = textRect
    }

    return canvasObj
  end

  return {
    _buildParts = buildParts,
    canvases = {},
    show = function(self)
      self:hide()

      -- Create a canvas for each screen
      local allScreens = hs.screen.allScreens()
      for _, screen in ipairs(allScreens) do
        local canvas = self._buildParts(messageText, screen)
        canvas:show()
        table.insert(self.canvases, canvas)
      end
    end,
    hide = function(self)
      -- Delete all canvases
      for _, canvas in ipairs(self.canvases) do
        canvas:delete()
      end
      self.canvases = {}
    end,
    notify = function(self, seconds)
      local seconds = seconds or 1
      self:show()
      hs.timer.delayed.new(seconds, function() self:hide() end):start()
    end,
    toggle = function(self)
        if #self.canvases > 0 then
            self:hide()
        else
            self:show()
        end
    end
  }
end

return statusmessage
