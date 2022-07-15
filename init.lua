local path = (...):gsub("init", "")

local class = require (path .. "external.middleclass")
local batteries = require (path .. "external.batteries")
local flux = require (path .. "external.flux.flux")

insight2d = {
    ["class"] = class,
    ["batteries"] = batteries,
    ["flux"] = flux
}