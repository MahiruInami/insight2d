local BaseScene = require "lib.insight2d.lib.scenes_management.base_scene"
local AnimationHelperScene = insight2d.class("AnimationHelperScene", BaseScene)


function AnimationHelperScene:initialize(texture_path)
    BaseScene.initialize(self)

    self._texture_path = texture_path
    -- self._mode = "rects"
    self._mode = "grid"
end

function AnimationHelperScene:onEnter()
    BaseScene.onEnter(self)

    self._texture = self.assets_manager:loadTexture("animation", self._texture_path)

    self._image_data = love.image.newImageData(self._texture_path)

    self._texture_width, self._texture_height = self._texture:getDimensions()
    self._quad = love.graphics.newQuad(0, 0, self._texture_width, self._texture_height, self._texture)
    self._local_transform = love.math.newTransform(10, 10, 0, 1.0, 1.0)

    self._processing_pixels = {}
    self._frames = {}

    self._iteration_x = 1
    self._iteration_y = 1
    
    self._merge_distance = 4

    self._cell_width = 32
    self._cell_height = 32

    self._cell_offset_x = 0
    self._cell_offset_y = 0

    self._cell_margin_x = 0
    self._cell_margin_y = 0

    self._is_grid_updated = false

    self._iterations_per_update = 100
end

function AnimationHelperScene:update(dt)
    BaseScene.update(self, dt)

    if self._mode == "grid" then
        self:updateGrid()
        return
    end

    self._processing_pixels = {}
    local iterations_left = self._iterations_per_update
    while iterations_left > 0 do
        local is_coord_in_frames = insight2d.batteries.functional.any(self._frames, function (frame_data, index)
            return self._iteration_x >= frame_data[1] and self._iteration_y >= frame_data[2] and self._iteration_x <= frame_data[3] and self._iteration_y <= frame_data[4]
        end)

        table.insert(self._processing_pixels, {self._iteration_x, self._iteration_y})
        
        if not is_coord_in_frames then
            local r, g, b, a = self._image_data:getPixel(self._iteration_x, self._iteration_y)
            if a > 0.1 then
                self:parseFrame(self._iteration_x, self._iteration_y)
                iterations_left = 0
            end
        end
        self._iteration_x = self._iteration_x + 1
        if self._iteration_x >= self._texture_width then
            self._iteration_x = 1
            if self._iteration_y < self._texture_height- 1 then
                self._iteration_y = self._iteration_y + 1
            else
                self._iteration_y = 1
                self._iterations_per_update = 0
                iterations_left = 0
            end
        end
        iterations_left = iterations_left - 1
    end

    if #self._frames > 0 then
        local frames_to_merge = {}
        for i, frame_i in pairs(self._frames) do
            local merged_min_x = frame_i[1]
            local merged_max_x = frame_i[3]
            local merged_min_y = frame_i[2]
            local merged_max_y = frame_i[4]
            for j, frame_j in pairs(self._frames) do
                if i ~= j then
                    local min_x_dist = frame_i[3] - frame_j[1]
                    local max_x_dist = frame_j[3] - frame_i[1]
                    local min_y_dist = frame_i[4] - frame_j[2]
                    local max_y_dist = frame_j[4] - frame_i[2]

                    if min_x_dist >= -self._merge_distance and max_x_dist >= -self._merge_distance and min_y_dist >= -self._merge_distance and max_y_dist >= -self._merge_distance then
                        -- overlap
                        table.insert(frames_to_merge, j)

                        merged_min_x = math.min(merged_min_x, frame_j[1])
                        merged_min_y = math.min(merged_min_y, frame_j[2])
                        merged_max_x = math.max(merged_max_x, frame_j[3])
                        merged_max_y = math.max(merged_max_y, frame_j[4])
                    end
                end
            end

            if #frames_to_merge > 0 then
                table.insert(frames_to_merge, i)
                table.insert(self._frames, {merged_min_x, merged_min_y, merged_max_x, merged_max_y})
                break
            end
        end

        for i, data in pairs(frames_to_merge) do
            table.remove(self._frames, data)
        end
    end
end

function AnimationHelperScene:parseFrame(x, y)
    local jumps = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
    local queue = {{x, y}}
    local processed = insight2d.batteries.set()
    local frame_elements = {}
    while #queue > 0 do
        local coord = insight2d.batteries.tablex.pop(queue)
        local px, py = coord[1], coord[2]
        if not processed:has((py - 1) * self._texture_width + px) then
            processed:add((py - 1) * self._texture_width + px)
            insight2d.batteries.tablex.push(frame_elements, {px, py})

            for i, jump in pairs(jumps) do
                local nx, ny = px + jump[1], py + jump[2]
                if nx <= 0 or ny <= 0 or nx > self._texture_width or ny > self._texture_height then
                    --
                else
                    local r, g, b, a = self._image_data:getPixel(nx, ny)
                    if not processed:has((ny - 1) * self._texture_width + nx) and (a > 0.1) then
                        insight2d.batteries.tablex.push(queue, {nx, ny})
                    end
                end
            end
        end
    end

    local min_x = self._texture_width + 1
    local min_y = self._texture_height + 1
    local max_x = -1
    local max_y = -1
    for i, coord in pairs(frame_elements) do
        min_x = math.min(min_x, coord[1])
        min_y = math.min(min_y, coord[2])
        max_x = math.max(max_x, coord[1])
        max_y = math.max(max_y, coord[2])
    end

    table.insert(self._frames, {min_x, min_y, max_x, max_y})
end

function AnimationHelperScene:updateGrid()
    if self._is_grid_updated then
        return
    end

    local current_frame_x = self._cell_offset_x
    local current_frame_y = self._cell_offset_y
    self._frames = {}

    while true do
        table.insert(self._frames, {current_frame_x, current_frame_y, current_frame_x + self._cell_width, current_frame_y + self._cell_height})

        current_frame_x = current_frame_x + self._cell_width + self._cell_offset_x
        if current_frame_x + self._cell_width > self._texture_width then
            current_frame_x = self._cell_offset_x
            current_frame_y = current_frame_y + self._cell_height + self._cell_offset_y
        end

        if current_frame_y + self._cell_height >= self._texture_height + 32 then
            break
        end
    end

    self._is_grid_updated = true
end

function AnimationHelperScene:keyPressed(key, scancode, isrepeat)
    BaseScene.keyPressed(self, key, scancode, isrepeat)

    if key == "left" then
        self._cell_width = math.max(1, self._cell_width - 1)
        self._is_grid_updated = false
    end

    if key == "right" then
        self._cell_width = math.min(self._texture_width, self._cell_width + 1)
        self._is_grid_updated = false
    end

    if key == "up" then
        self._cell_height = math.min(self._texture_height, self._cell_height + 1)
        self._is_grid_updated = false
    end

    if key == "down" then
        self._cell_height = math.max(1, self._cell_height - 1)
        self._is_grid_updated = false
    end

    if key == "a" then
        self._cell_offset_x = self._cell_offset_x - 1
        self._is_grid_updated = false
    end

    if key == "d" then
        self._cell_offset_x = math.min(self._texture_width, self._cell_offset_x + 1)
        self._is_grid_updated = false
    end

    if key == "w" then
        self._cell_offset_y = math.min(self._texture_height, self._cell_offset_y + 1)
        self._is_grid_updated = false
    end

    if key == "s" then
        self._cell_offset_y = self._cell_offset_y - 1
        self._is_grid_updated = false
    end
end

function AnimationHelperScene:draw()
    BaseScene.draw(self)

    -- love.graphics.setScissor(10, 10, 600, 512)
    love.graphics.draw(self._texture, self._quad, self._local_transform)
    -- love.graphics.setScissor()

    if #self._processing_pixels > 0 then
        for i, v in pairs(self._processing_pixels) do
            love.graphics.points(v[1] + 10, v[2] + 10)
        end
    end

    if #self._frames > 0 then
        for i, v in pairs(self._frames) do
            love.graphics.rectangle("line", v[1] + 10, v[2] + 10, v[3] - v[1] + 1, v[4] - v[2] + 1)
        end
    end
end

return AnimationHelperScene