local path = (...):gsub("screen_layer", "")
local lib_directory = path:gsub("screen.", "")

local Renderer = insight2d.require("renderer.renderer")

local ScreenLayer = insight2d.class("ScreenLayer")

function ScreenLayer:initialize()
    self._elements = {}
    self._renderer = Renderer:new()

    self._transform = love.math.newTransform()
    self._drawInWorldView = false
end

function ScreenLayer:onPush()
end

function ScreenLayer:addElement(element)
    table.insert(self._elements, element)
end

function ScreenLayer:update(dt)
    for i, v in pairs(self._elements) do
        v:update(dt)
    end
end

function ScreenLayer:draw(camera)
    if self:drawInWorldView() then
        camera:push()
    end
    self._renderer:startFrame()

    for i, v in pairs(self._elements) do
        v:visit(self._renderer, self._transform)
    end

    self:innerDraw()
    
    self._renderer:finishFrame()
    if self:drawInWorldView() then
        camera:pop()
    end
end

function ScreenLayer:innerDraw()
end

function ScreenLayer:touchBegin(touch)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchBegin(touch, self._transform)
    end
end

function ScreenLayer:touchMoved(touch)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchMoved(touch, self._transform)
    end
end

function ScreenLayer:touchEnded(touch)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchEnded(touch, self._transform)
    end
end

function ScreenLayer:drawInWorldView()
    return self._drawInWorldView
end

function ScreenLayer:onScreenRemoved()
end

return ScreenLayer