local ScreenElement = insight2d.require("screen.elements.screen_element")
local ScreenSprite = insight2d.require("screen.elements.screen_sprite")

local ScreenSprite9Patch = insight2d.class("ScreenSprite9Patch", ScreenElement)

function ScreenSprite9Patch:initialize(texture, quads, size)
    ScreenElement.initialize(self)

    self._texture = texture
    self._quads= quads

    self._size_width = size[1]
    self._size_height = size[2]

    self._width = self._size_width
    self._height = self._size_height
    
    local left_top_x, left_top_y, left_top_w, left_top_h = quads[1]:getViewport()
    local middle_top_x, middle_top_y, middle_top_w, middle_top_h = quads[2]:getViewport()
    local right_top_x, right_top_y, right_top_w, right_top_h = quads[3]:getViewport()

    local left_middle_x, left_middle_y, left_middle_w, left_middle_h = quads[4]:getViewport()
    local middle_x, middle_y, middle_w, middle_h = quads[5]:getViewport()
    local right_middle_x, right_middle_y, right_middle_w, right_middle_h = quads[6]:getViewport()

    local left_bottom_x, left_bottom_y, left_bottom_w, left_bottom_h = quads[7]:getViewport()
    local middle_bottom_x, middle_bottom_y, middle_bottom_w, middle_bottom_h = quads[8]:getViewport()
    local right_bottom_x, right_bottom_y, right_bottom_w, right_bottom_h = quads[9]:getViewport()

    local left_top = ScreenSprite:new(self._texture, quads[1])
    left_top:setPosition(0, 0)
    self:addElement(left_top)

    local middle_top = ScreenSprite:new(self._texture, quads[2])
    middle_top:setPosition(left_top_w, 0)
    middle_top:setScale((self._size_width - left_top_w - right_top_w) / middle_top_w, 1.0)
    self:addElement(middle_top)

    local right_top = ScreenSprite:new(self._texture, quads[3])
    right_top:setPosition(self._size_width - right_top_w, 0)
    self:addElement(right_top)

    local left_middle = ScreenSprite:new(self._texture, quads[4])
    left_middle:setPosition(0, left_top_h)
    left_middle:setScale(1.0, (self._size_height - left_top_h - left_bottom_h) / left_middle_h)
    self:addElement(left_middle)

    local middle = ScreenSprite:new(self._texture, quads[5])
    middle:setPosition(left_middle_w, middle_top_h)
    middle:setScale((self._size_width - left_middle_w - right_middle_w) / middle_w, (self._size_height - left_middle_h - right_middle_h) / middle_h)
    self:addElement(middle)

    local right_middle = ScreenSprite:new(self._texture, quads[6])
    right_middle:setPosition(self._size_width - right_middle_w, right_top_h)
    right_middle:setScale(1.0, (self._size_height - right_top_h - right_bottom_h) / right_middle_h)
    self:addElement(right_middle)

    local left_bottom = ScreenSprite:new(self._texture, quads[7])
    left_bottom:setPosition(0, self._size_height - left_bottom_h)
    self:addElement(left_bottom)

    local middle_bottom = ScreenSprite:new(self._texture, quads[8])
    middle_bottom:setPosition(left_bottom_w, self._size_height - middle_bottom_h)
    middle_bottom:setScale((self._size_width - left_bottom_w - right_bottom_w) / middle_top_w, 1.0)
    self:addElement(middle_bottom)

    local right_bottom = ScreenSprite:new(self._texture, quads[9])
    right_bottom:setPosition(self._size_width - right_bottom_w, self._size_height - right_bottom_h)
    self:addElement(right_bottom)
end

function ScreenSprite9Patch:touchBegin(touch, parent_transform)
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

function ScreenSprite9Patch:touchMoved(touch, parent_transform)
    ScreenElement.touchMoved(self, touch, parent_transform)
end

function ScreenSprite9Patch:touchEnded(touch, parent_transform)
    ScreenElement.touchEnded(self, touch, parent_transform)
end

return ScreenSprite9Patch