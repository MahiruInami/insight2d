local class = require "external.middleclass"

local Touch = class("Touch")

Touch.static.MOUSE_BASE_ID = 100
Touch.static.CLICK_TIME_DIFF = 0.12

function Touch:initialize(id, x, y)
    self._id = id
    self._pos_x = x
    self._pos_y = y
    self._pos_x_diff = 0
    self._pos_y_diff = 0
    self._position_diff = 0
    self._touch_start_time = love.timer.getTime()
    self._capture_target = nil
    self._is_propagation_stopped = false

    self._is_moved = false
end

function Touch:getId()
    return self._id
end

function Touch:getPositionX()
    return self._pos_x
end

function Touch:getPositionY()
    return self._pos_y
end

function Touch:updatePosition(x, y)
    if not self._is_moved then
        self._position_diff = math.abs(x - self._pos_x) + math.abs(y - self._pos_y)
    end

    self._pos_x_diff = x - self._pos_x
    self._pos_y_diff = y - self._pos_y
    self._pos_x = x
    self._pos_y = y

    self._is_moved = self._position_diff > 4
end

function Touch:isMoved()
    return self._is_moved
end

function Touch:getPositionXDelta()
    return self._pos_x_diff
end

function Touch:getPositionYDelta()
    return self._pos_y_diff
end

function Touch:isClick()
    return love.timer.getTime() - self._touch_start_time <= Touch.static.CLICK_TIME_DIFF
end

function Touch:isMouse()
    return self._id >= Touch.static.MOUSE_BASE_ID
end

function Touch:isMouseButton(button)
    return self:isMouse() and (self._id - Touch.static.MOUSE_BASE_ID) == button
end

function Touch:stopPropagation()
    self._is_propagation_stopped = true
end

function Touch:isPropagationStopped()
    return self._is_propagation_stopped
end

function Touch:isCaptured()
    return self._capture_target ~= nil
end

function Touch:captureTarget(target)
    self._capture_target = target
end

function Touch:getTarget()
    return self._capture_target
end

return Touch