local ScreenElement = insight2d.require("screen.elements.screen_element")
local ScreenLabel = insight2d.class("ScreenLabel", ScreenElement)

function ScreenLabel:initialize(font, text, align, width, height)
    ScreenElement.initialize(self)

    self._font = font
    self._text = text
    self._align = align
    self._readable_text = self:getFormatedText()
    if width == 0 or width == nil then
        self._width = math.max(self._font:getWidth(self._readable_text), 1)
        self._fixed_width = false
    else
        self._width = width
        self._fixed_width = true
    end

    self._height = height or (math.ceil(math.max(self._font:getWidth(self._readable_text), 1) / self._width) * self._font:getHeight(text))
    self._fixed_height = height ~= nil

    self._limit = self._width
    self._render_command = nil
end

function ScreenLabel:getFormatedText()
    if type(self._text) ~= "table" then
        return self._text
    end

    local result = ""
    for i, v in pairs(self._text) do
        if type(v) ~= "table" then
            result = result .. v
        end
    end

    return result
end

function ScreenLabel:setText(text)
    self._text = text
    self._readable_text = self:getFormatedText()

    if not self._fixed_width then
        self._width = math.max(self._font:getWidth(self._readable_text), 1)
        self._limit = self._width
    end

    if not self._fixed_height then
        self._height = (math.ceil(math.max(self._font:getWidth(self._readable_text), 1) / self._width) * self._font:getHeight(self._readable_text))
    end

    self:invalidate()
end

function ScreenLabel:render(renderer, parent_transform)
    if self._align == nil or self._font == nil then
        love.graphics.print(self._text, parent_transform * self._local_transform)
    else
        love.graphics.printf(self._text, self._font, parent_transform * self._local_transform, self._limit, self._align)
    end
end

return ScreenLabel