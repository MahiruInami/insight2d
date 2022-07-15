local path = (...):gsub("init", "")

local class = require (path .. "external.middleclass")
local batteries = require (path .. "external.batteries")
local flux = require (path .. "external.flux.flux")

local insight2d_require = function (module_path)
    return require (path .. "lib." .. module_path)
end

insight2d = {
    ["class"] = class,
    ["batteries"] = batteries,
    ["flux"] = flux,
    ["require"] = insight2d_require
}