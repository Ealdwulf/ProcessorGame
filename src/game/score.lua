--[[
score.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = require 'system.layout'
local g = love.graphics

local Score ={}
Score.__index = Score


function Score.create(max_stalls_level)
    local self = setmetatable({}, Score)
    self.level = 0
    self.points = 0
    self.stallsLevel = 0
    self.maxStalls = max_stalls_level
    self.text = love.graphics.newText(Layout.font, '')

    return self
end

function Score:update(stall)
    print(stall)
    if stall then
        self.stallsLevel = self.stallsLevel + 1
    end
    self.text:set("Level "..self.level.." Points: "..self.points.. "Stalls: "..self.stallsLevel)
end

function Score:draw()
    local ly = Layout.score
    g.setColor(ly.colour)
    g.draw(self.text, ly.text.x, ly.text.y)
    g.setColor(ly.stall.colour)
    g.rectangle("fill", ly.stall.x, ly.stall.y, ly.stall.width, ly.stall.height * (self.maxStalls-self.stallsLevel)/self.maxStalls)
end
return Score
