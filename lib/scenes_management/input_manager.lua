local class = require "external.middleclass"

local Touch = require "lib.scenes_management.input.touch"
local InputManager = class("InputManager")

function InputManager:initialize()
    self._is_update = false

    self._touches = {}
end

function InputManager:beforeUpdate(dt)
    self._is_update = true
end

function InputManager:update(dt)
end

function InputManager:afterUpdate(dt)
    self._is_update = false
end

function InputManager:keyPressed(key, scancode, isrepeat)

end

function InputManager:keyReleased(key, scancode)
end

function InputManager:mousePressed(mx, my, button, isTouch, presses, scene)
    local touch = Touch:new(Touch.static.MOUSE_BASE_ID + button, mx, my)
    table.insert(self._touches, touch)

    scene:touchBegin(touch)
end

function InputManager:mouseMoved(x, y, dx, dy, isTouch, scene)
    if self._touches ~= nil then
        for i, v in pairs(self._touches) do
            if v:isMouse() then
                v:updatePosition(x, y)

                v._is_propagation_stopped = false
                if v:isCaptured() then
                    local target = v:getTarget()
                    local transform = target:getWorldTransform()
                    target:touchMoved(v, transform)
                else
                    scene:touchMoved(v)
                end
            end
        end
    end
end

function InputManager:mouseReleased(mx, my, button, isTouch, presses, scene)
    if self._touches ~= nil then
        local touch_index = -1
        for i, v in pairs(self._touches) do
            if v:getId() == (Touch.static.MOUSE_BASE_ID + button) then
                touch_index = i
                break
            end
        end

        if touch_index > 0 then
            self._touches[touch_index]._is_propagation_stopped = false
            if self._touches[touch_index]:isCaptured() then
                local target = self._touches[touch_index]:getTarget()
                local transform = target:getWorldTransform()
                target:touchEnded(self._touches[touch_index], transform)
            else
                scene:touchEnded(self._touches[touch_index])
            end
            table.remove(self._touches, touch_index)
        end
    end
end

function InputManager:isMouseButtonPressed(button)
    if self._touches ~= nil then
        for i, v in pairs(self._touches) do
            if v:isMouse() and v:getId() == (Touch.static.MOUSE_BASE_ID + button) then
                return true
            end
        end
    end

    return false
end

function InputManager:mouseFocus(f)
end

function InputManager:wheelMoved(dx, dy)

end

return InputManager