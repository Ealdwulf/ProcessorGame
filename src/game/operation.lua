--[[
operation.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Layout = require "system.layout"

local Operation ={}
Operation.__index = Operation
local love = love

function Operation.create(data)
    local self = setmetatable(data, Operation) -- PLS VIOLATION - turning raw data into a class
    
    self.text = love.graphics.newText(Layout.font, self.op .. ' ' .. self.txt)
    return self
end

function Operation:draw(x, y )
    love.graphics.setColor(Layout.textColour)
    love.graphics.draw(self.text, x, y)
end

function Operation:scoreboard(sc)
    for i = 1, #self.r, 2 do
        sc:alloc(self.w[i], self.w[i+1])
    end
end
function Operation:un_scoreboard(sc)
    for i = 1, #self.r, 2 do
        sc:clear(self.w[i])
    end
end
function Operation:mustWait(sc)
    local wait = false
    for i = 1, #self.r, 2 do
        -- for now ignore writes
        if sc:lookup(self.r[i], self.r[i+1]) then
            wait = true
        end
    end
    return wait
end
function Operation:getPipe()
    
    if     self.op == 'LDL' then return 'ldst'
    elseif self.op == 'STL' then return 'ldst'
    elseif self.op == 'ADD' then return 'arith'
    elseif self.op == 'MUL' then return 'mac'
    end
end
return Operation
