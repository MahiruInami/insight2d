local class = require "external.middleclass"
local AssetsManager = require "lib.assets_manager.assets_manager"
local Camera = require "lib.scenes_management.camera"
local InputManger = require "lib.scenes_management.input_manager"
local ScreenManager = require "lib.screen.screen_manager"

local BaseScene = class("BaseScene")

function BaseScene:initialize()
    self.assets_manager = AssetsManager:new()
    self.camera = Camera:new()
    self.input_manager = InputManger:new()
    self.screen_manager = ScreenManager:new()
end

function BaseScene:onEnter()
    self.screen_manager:onEnter()
end

function BaseScene:beforeUpdate(dt)
    self.input_manager:beforeUpdate(dt)
end

function BaseScene:update(dt)
    self.input_manager:update(dt)
    self.screen_manager:update(dt)
end

function BaseScene:afterUpdate(dt)
    self.input_manager:afterUpdate(dt)
end

function BaseScene:render()
    self:beforeDraw()
    self:draw()
    self:afterDraw()
    self:beforeDrawScreens()
    self:drawScreens()
    self:afterDrawScreens()
end

function BaseScene:beforeDraw()
    self.camera:push()
end

function BaseScene:draw()
end

function BaseScene:afterDraw()
    self.camera:pop()
end

function BaseScene:beforeDrawScreens()
end

function BaseScene:drawScreens()
    self.screen_manager:draw(self.camera)
end

function BaseScene:afterDrawScreens()
end

function BaseScene:onExit()
    self.screen_manager:onExit()
end

function BaseScene:keyPressed(key, scancode, isrepeat)
    self.input_manager:keyPressed(key, scancode, isrepeat)
end

function BaseScene:keyReleased(key, scancode)
    self.input_manager:keyReleased(key, scancode)
end

function BaseScene:mousePressed(mx, my, button, isTouch, presses)
    self.input_manager:mousePressed(mx, my, button, isTouch, presses, self)
end

function BaseScene:mouseReleased(mx, my, button, isTouch, presses)
    self.input_manager:mouseReleased(mx, my, button, isTouch, presses, self)
end

function BaseScene:mouseFocus(f)
    self.input_manager:mouseFocus(f)
end

function BaseScene:mouseMoved(x, y, dx, dy, isTouch)
    self.input_manager:mouseMoved(x, y, dx, dy, isTouch, self)
end

function BaseScene:wheelMoved(dx, dy)
    self.input_manager:wheelMoved(dx, dy)
end

function BaseScene:touchBegin(touch)
    self.screen_manager:touchBegin(touch)
end

function BaseScene:touchMoved(touch)
    self.screen_manager:touchMoved(touch)
end

function BaseScene:touchEnded(touch)
    self.screen_manager:touchEnded(touch)
end

return BaseScene