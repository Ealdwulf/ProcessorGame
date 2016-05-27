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
    self.next = {}
    self.input = {}
    self.id = id
    self.scoreboard = scoreboard
    
    return self
end

function Completer:load()
end

function Completer:setNextOp(op)
    self.input.nextOP = op
end

function Completer:MoE()
    return true -- for now, completer is always available
end

function Completer:tick()
    if self:MoE() then
        self.next.op = self.input.nextOP
        if self.op and self.op ~= "" then
            print(self.op)
            self.op:un_scoreboard(self.scoreboard)
        end
    end
end


function Completer:draw()
    
end

return Completer
