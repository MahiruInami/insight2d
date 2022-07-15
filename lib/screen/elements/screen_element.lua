local ScreenElement = insight2d.class("ScreenElement")

function ScreenElement:initialize()
    self._pos_x = 0
    self._pos_y = 0
    self._anchor_x = 0
    self._anchor_y = 0
    self._scale_x = 1.0
    self._scale_y = 1.0
    self._rotation = 0
    self._width = 1
    self._height = 1

    self._is_visible = true

    self._is_dirty = false
    self._local_transform = love.math.newTransform(0, 0, 0, 1.0, 1.0)

    self._elements = {}
    self._parent = nil
end

function ScreenElement:getWidth()
    return self._width
end

function ScreenElement:getHeight()
    return self._height
end

function ScreenElement:getParent()
    return self._parent
end

function ScreenElement:getTransform()
    return self._local_transform
end

function ScreenElement:getWorldTransform()
    local parent = self:getParent()
    local transforms = {}
    while parent ~= nil do
        table.insert(transforms, 1, parent:getTransform())
        parent = parent:getParent()
    end
    local worldTransform = love.math.newTransform(0, 0, 0, 1.0, 1.0)
    for i, v in pairs(transforms) do
        worldTransform = worldTransform * v
    end
    return worldTransform
end

function ScreenElement:addElement(element)
    element._parent = self
    table.insert(self._elements, element)
end

function ScreenElement:removeElement(element)
    local index = -1
    if element ~= nil then
        element._parent = nil
    end
    for i, v in pairs(self._elements) do
        if v == element then
            index = i
            break
        end
    end

    if index > 0 then
        table.remove(self._elements, index)
    end

    self:invalidate()
end

function ScreenElement:setVisible(value)
    self._is_visible = value
end

function ScreenElement:isVisible()
    return self._is_visible
end

function ScreenElement:setPosition(x, y)
    self._pos_x = x
    self._pos_y = y

    self:invalidate()
end

function ScreenElement:setAnchor(x, y)
    self._anchor_x = x
    self._anchor_y = y

    self:invalidate()
end

function ScreenElement:setRotation(value)
    self._rotation = value

    self:invalidate()
end

function ScreenElement:setScale(value_x, value_y)
    self._scale_x = value_x
    self._scale_y = value_y

    self:invalidate()
end

function ScreenElement:invalidate()
    self._is_dirty = true
end

function ScreenElement:validate()
    self._is_dirty = false
end

function ScreenElement:isDirty()
    return self._is_dirty
end

function ScreenElement:updateTransform()
    if not self:isDirty() then
        return
    end

    local offset_x = self._width * self._anchor_x
    local offset_y = self._height * self._anchor_y
    self._local_transform = love.math.newTransform(self._pos_x, self._pos_y, self._rotation, self._scale_x, self._scale_y)
    self._local_transform:translate(-offset_x, -offset_y)

    self:validate()
end

function ScreenElement:visit(renderer, parent_transform)
    if not self:isVisible() then
        return
    end

    if self:isDirty() then
        self:updateTransform()
    end

    self:render(renderer, parent_transform)

    if self._elements ~= nil then
        for i, v in pairs(self._elements) do
            v:visit(renderer, parent_transform * self._local_transform)
        end
    end
end

function ScreenElement:render(renderer, parent_transform)
end

function ScreenElement:update(dt)
    for i, v in pairs(self._elements) do
        v:update(dt)
    end
end

function ScreenElement:touchBegin(touch, parent_transform)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchBegin(touch, parent_transform * self._local_transform)
    end
end

function ScreenElement:touchMoved(touch, parent_transform)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchMoved(touch, parent_transform * self._local_transform)
    end
end

function ScreenElement:touchEnded(touch, parent_transform)
    for i, v in pairs(self._elements) do
        if touch:isPropagationStopped() then
            break
        end
        v:touchEnded(touch, parent_transform * self._local_transform)
    end
end

return ScreenElement