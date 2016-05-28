--[[
issue.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Sounds = require "src.system.sounds"
local Layout = require 'system.layout'
local Machine = require 'game.machine'

local Issue ={}
Issue.__index = Issue
setmetatable(Issue, {__index = Machine})

local g = love.graphics

function Issue.create(disassemblyView, scb, arith, ldst, mac)
    local self = setmetatable(Machine.create(), Issue)
    self.disassemblyView = disassemblyView
    self.scb = scb
    self.pipes = {
        arith = arith,
        ldst = ldst,
        mac = mac
    }
    self.next = {}
    
    return self
end

function Issue:load()
    self.currOP = self.disassemblyView:next()
    self.stalled = false
    self.bad = false
end

function Issue:update(dt)
end

function Issue:tick()
    local waiting = self.currOP:mustWait(self.scb)
    local currPipe = self.currOP:getPipe()
    for pipeType, pipe in pairs(self.pipes) do
        --print(pipeType, currPipe)
        if pipeType == currPipe then
            --print(pipeType, pipe:MoE(), waiting)
            if pipe:MoE() and not waiting then
                pipe:setNextOp(self.currOP)
                if self.currOP then
                    self.currOP:scoreboard(self.scb)
                    if not self.currOP:check(self.scb) then
                        Sounds.play("bad")
                    end
                end
                self.stalled = false
                self.next.currOP = self.disassemblyView:next()
            else
                pipe:setNextOp("")
                self.stalled = true
            end
        else
            pipe:setNextOp("")
        end
    end
    if self.stalled then
        Sounds.play("stall")
    else
        Sounds.play("issue")
    end
end

function Issue:draw()
    local ly = Layout.issue
    if self.stalled then        
        g.setColor(ly.stalledColour)
    else
        g.setColor(ly.colour)
    end
    g.rectangle("fill",ly.x, ly.y, ly.width, ly.height)
    self.currOP:draw(ly.x, ly.y)
    
end

return Issue
