local class = require "external.middleclass"

local Camera = class("Camera")

function Camera:initialize()
    self._x = -love.graphics.getWidth() / 2
    self._y = -love.graphics.getHeight() / 2

    self._width = love.graphics.getWidth()
    self._height = love.graphics.getHeight()

    self._scale = 1
end

function Camera:setScale(scale)
    self._scale = scale
end

function Camera:zoom(value)
    self:setScale(math.max(1, math.min(4, self._scale + value * 0.2)))
end

function Camera:getScale()
    return self._scale
end

function Camera:translate(dx, dy)
    self._x = self._x + dx
    self._y = self._y + dy
end

function Camera:push()
    love.graphics.push()

    love.graphics.scale(self._scale)
    love.graphics.translate((self._width / 2) / self._scale, (self._height / 2) / self._scale)
    love.graphics.translate(self._x, self._y)
end

function Camera:pop()
    love.graphics.pop()
end

function Camera:getPosition()
    return self._x, self._y
end

function Camera:windowToCamera(x, y)
    -- convert to center and scale
    local localX = (x - self._width / 2) / self._scale
    local localY = (y - self._height / 2) / self._scale

    -- apply position
    localX = localX - self._x
    localY = localY - self._y

    return localX, localY
end

return Camera