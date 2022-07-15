local class = require "external.middleclass"

local ScenesManager = class("ScenesManager")

function ScenesManager:initialize()
    self._currentScene = nil
end

function ScenesManager:switchScene(newScene, nums)
    if self._currentScene ~= nil then
        self._currentScene:onExit()
    end

    self._currentScene = newScene
    if self._currentScene ~= nil then
        self._currentScene:onEnter()
    end
end

function ScenesManager:update(dt)
    if self._currentScene ~= nil then
        self._currentScene:beforeUpdate(dt)
        self._currentScene:update(dt)
        self._currentScene:afterUpdate(dt)
    end
end

function ScenesManager:render()
    if self._currentScene ~= nil then
        self._currentScene:render()
    end
end

function ScenesManager:keyPressed(key, scancode, isrepeat)
    if self._currentScene ~= nil then
        self._currentScene:keyPressed(key, scancode, isrepeat)
    end
end

function ScenesManager:keyReleased(key, scancode)
    if self._currentScene ~= nil then
        self._currentScene:keyReleased(key, scancode)
    end
end

function ScenesManager:mousePressed(mx, my, button, isTouch, presses)
    if self._currentScene ~= nil then
        self._currentScene:mousePressed(mx, my, button, isTouch, presses)
    end
end

function ScenesManager:mouseReleased(mx, my, button, isTouch, presses)
    if self._currentScene ~= nil then
        self._currentScene:mouseReleased(mx, my, button, isTouch, presses)
    end
end

function ScenesManager:mouseFocus(f)
    if self._currentScene ~= nil then
        self._currentScene:mouseFocus(f)
    end
end

function ScenesManager:mouseMoved(x, y, dx, dy, isTouch)
    if self._currentScene ~= nil then
        self._currentScene:mouseMoved(x, y, dx, dy, isTouch)
    end
end

function ScenesManager:wheelMoved(dx, dy)
    if self._currentScene ~= nil then
        self._currentScene:wheelMoved(dx, dy)
    end
end

return ScenesManager