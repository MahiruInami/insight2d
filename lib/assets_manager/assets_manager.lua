local AssetsManager = insight2d.class("AssetsManager")

function AssetsManager:initialize()
    self._textures = {}
    self._fonts = {}
    self._quads = {}
end

function AssetsManager:loadFont(font_name, path, size)
    local font = love.graphics.newFont(path, size)
    self._fonts[font_name] = font
    return font
end

function AssetsManager:loadTexture(texture_name, path)
    self._textures[texture_name] = love.graphics.newImage(path)
end

function AssetsManager:loadQuads(texture_name, path)
    local tileset_data = love.filesystem.load(path)
    local tileset = tileset_data()
    for i, v in pairs(tileset.tileset) do
        self:addQuadForTexture(texture_name, v.name, {v.x, v.y, v.width, v.height})
    end
end

function AssetsManager:addQuadForTexture(texture_name, key, rect)
    if self._quads[texture_name] == nil then
        self._quads[texture_name] = {}
    end
    self._quads[texture_name][key] = love.graphics.newQuad(rect[1], rect[2], rect[3], rect[4], self._textures[texture_name]:getDimensions())
end

function AssetsManager:get9patchQuadsForTexture(texture_name, base_key)
    local quads = {}
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_1"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_2"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_3"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_4"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_5"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_6"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_7"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_8"))
    table.insert(quads, self:getQuadForTexture(texture_name, base_key .. "_9"))

    return quads
end

function AssetsManager:getQuadForTexture(texture_name, key)
    return self._quads[texture_name][key]
end

function AssetsManager:textures()
    return self._textures
end

function AssetsManager:fonts()
    return self._fonts
end

return AssetsManager