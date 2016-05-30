--[[
completer.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Layout = require 'system.layout'
local Machine = require 'game.machine'

local Completer ={}
Completer.__index = Completer
setmetatable(Completer, {__index = Machine})

local g = love.graphics

function Completer.create(id, scoreboard)
    local self = setmetatable(Machine.create(), Completer)
    self.id = id
    self.scoreboard = scoreboard
    
    return self
end

function Completer:load()
    self.next = {}
    self.input = {}
    self.next.input = {}
end

function Completer:setNextOp(op)
    self.next.input.op = op
end

function Completer:MoE()
    return true -- for now, completer is always available
end

function Completer:tick()
    if self:MoE() then
        if self.input.op and self.input.op ~= "" then

            self.input.op:un_scoreboard(self.scoreboard)
        end
    end
end

function Completer:draw()
    local ly = Layout.stage
    g.setColor(ly.colour)
    g.rectangle("fill",ly[self.id].x, ly[self.id].y, ly.width, ly.height)
    if self.input.op ~= "" and self.input.op then
        self.input.op:draw(ly[self.id].x, ly[self.id].y)
    end
    
end


return Completer
