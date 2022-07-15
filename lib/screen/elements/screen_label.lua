local class = require "external.middleclass"
local ScreenElement = require "lib.screen.elements.screen_element"

local ScreenLabel = class("ScreenLabel", ScreenElement)

function ScreenLabel:initialize(font, text, align, limit)
    ScreenElement.initialize(self)

    self._font = font
    self._text = text
    self._align = align
    self._limit = limit
    self._render_command = nil
end

function ScreenLabel:setText(text)
    self._text = text
end

function ScreenLabel:render(renderer, parent_transform)
    if self._align == nil or self._font == nil then
        love.graphics.print(self._text, parent_transform * self._local_transform)
    else
        love.graphics.printf(self._text, self._font, parent_transform * self._local_transform, self._limit, self._align)
    end
end

return ScreenLabel