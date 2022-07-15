local class = require "external.middleclass"

local ScreenManager = class("ScreenManager")

function ScreenManager:initialize()
    self._screens = {}
end

function ScreenManager:pushScreen(screen)
    table.insert(self._screens, screen)
    screen:onPush()
end

function ScreenManager:popScreen()
end

function ScreenManager:onEnter()
end

function ScreenManager:update(dt)
    for i, v in pairs(self._screens) do
        v:update(dt)
    end
end

function ScreenManager:draw(camera)
    for i, v in pairs(self._screens) do
        v:draw(camera)
    end
end

function ScreenManager:touchBegin(touch)
    for i = #self._screens, 1, -1 do
        local screen = self._screens[i]
        if touch:isPropagationStopped() then
            break
        end
        screen:touchBegin(touch)
    end
end

function ScreenManager:touchMoved(touch)
    for i = #self._screens, 1, -1 do
        local screen = self._screens[i]
        if touch:isPropagationStopped() then
            break
        end
        screen:touchMoved(touch)
    end
end

function ScreenManager:touchEnded(touch)
    for i = #self._screens, 1, -1 do
        local screen = self._screens[i]
        if touch:isPropagationStopped() then
            break
        end
        screen:touchEnded(touch)
    end
end

function ScreenManager:onExit()
end

return ScreenManager