--[[
xxx.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Xxx ={}
Xxx.__index = Xxx

function Xxx.create()
    local self = setmetatable({}, Xxx)

    return self
end

return Xxx
