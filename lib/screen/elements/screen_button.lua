local class = require "external.middleclass"
local batteries = require "external.batteries"
local flux = require 'external.flux.flux'
local ScreenSprite = require "lib.screen.elements.screen_sprite"

local ScreenButton = class("ScreenButton", ScreenSprite)

function ScreenButton:initialize(texture, quad)
    ScreenSprite.initialize(self, texture, quad)


    self._tween_params = {scale = 1.0}
    self._tween = nil
    self._is_touched = false
    self._on_click = function ()
    end
end

function ScreenButton:setClickAction(action)
    self._on_click = action
end

function ScreenButton:update(dt)
    ScreenSprite.update(self, dt)

    if self._tween then
        flux.update(dt)
        self:setScale(self._tween_params.scale, self._tween_params.scale)
    end
end

function ScreenButton:touchBegin(touch, parent_transform)
    if touch:isPropagationStopped() then
        return
    end

    local current_transform = parent_transform * self._local_transform
    local local_x, local_y = current_transform:inverseTransformPoint(touch:getPositionX(), touch:getPositionY())
    if local_x >= 0 and local_y >= 0 and local_x <= self._width and local_y <= self._height then
        touch:captureTarget(self)
        self._is_touched = true
        self._tween = flux.to(self._tween_params, 0.3, {scale = 0.8}):ease("backout")
    end
end

function ScreenButton:touchMoved(touch, parent_transform)
    if touch:isPropagationStopped() then
        return
    end
end

function ScreenButton:touchEnded(touch, parent_transform)
    if touch:isCaptured() then
        if touch:isClick() then
            self._on_click()
        end

        self._tween = flux.to(self._tween_params, 0.2, {scale = 1.1}):ease("backout"):after(self._tween_params, 0.1, {scale = 1.0})
    end
end

return ScreenButton