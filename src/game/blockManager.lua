--[[
blockManager.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local BlockManager ={}
BlockManager.__index = BlockManager

function BlockManager.create(blocks)
    local self = setmetatable({}, BlockManager)
    self.blocks = blocks

    return self
end

function BlockManager:getPath(path)
    local t = self.blocks
    for x in path:gmatch("[^.]+") do
        t = t[x]
    end
    return t
end

function BlockManager:tick()
    for _, p in pairs(self.blocks) do
        p:tick()
    end
end

function BlockManager:tock()
    for _, p in pairs(self.blocks) do
        p:tock()
    end
end

function BlockManager:draw()
    for _, p in pairs(self.blocks) do
        p:draw()
    end
end

return BlockManager
