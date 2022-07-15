local class = require "external.middleclass"
local ScreenElement = require "lib.screen.elements.screen_element"

local ScreenTileMap = class("ScreenTileMap", ScreenElement)

function ScreenTileMap:initialize(texture)
    ScreenElement.initialize(self)

    self._batch = love.graphics.newSpriteBatch(texture)
end

function ScreenTileMap:addTile(quad, pos_x, pos_y)
    return self._objects_sprite_batch:add(quad, pos_x, pos_y)
end

-- function ScreenTileMap:updateTile(quad, pos_x, pos_y)
--     return self._objects_sprite_batch:add(quad, pos_x, pos_y)
-- end

function ScreenTileMap:render(renderer, parent_transform)
    love.graphics.draw(self._batch, parent_transform * self._local_transform)
end

return ScreenTileMap