local ScreenElement = insight2d.require("screen.elements.screen_element")

local ScreenSprite = insight2d.class("ScreenSprite", ScreenElement)

function ScreenSprite:initialize(texture, quad)
    ScreenElement.initialize(self)

    self._texture = texture
    self._quad = quad
    if self._quad == nil then
        local width, height = self._texture:getDimensions()
        self._quad = love.graphics.newQuad(0, 0, width, height, self._texture)
    end
    local x, y, w, h = self._quad:getViewport()
    self._width = w
    self._height = h
end

function ScreenSprite:render(renderer, parent_transform)
    love.graphics.draw(self._texture, self._quad, parent_transform * self._local_transform)
end

function ScreenSprite:touchBegin(touch, parent_transform)
    ScreenElement.touchBegin(self, touch, parent_transform)

    if touch:isPropagationStopped() then
        return
    end

    local current_transform = parent_transform * self._local_transform
    local local_x, local_y = current_transform:inverseTransformPoint(touch:getPositionX(), touch:getPositionY())
    if local_x >= 0 and local_y >= 0 and local_x <= self._width and local_y <= self._height then
        touch:captureTarget(self)
    end
end

function ScreenSprite:touchMoved(touch, parent_transform)
    ScreenElement.touchMoved(self, touch, parent_transform)
end

function ScreenSprite:touchEnded(touch, parent_transform)
    ScreenElement.touchEnded(self, touch, parent_transform)
end

return ScreenSprite