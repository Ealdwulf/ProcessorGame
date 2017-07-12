--[[
score.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = require 'system.layout'
local Locale = require 'system.locale'
local Levels = require 'game.levels'
local g = love.graphics

local Score ={}
Score.__index = Score


function Score.create(message, num_levels)
    local self = setmetatable({}, Score)
    self.message = message
    self.level = 1
    self.points = 0
    self.ticksLevel = 0
    self.stallsLoop = 1000000
    self.stallsLastLoop = 1000000
    self.text = love.graphics.newText(Layout.font, '')

    return self
end

function Score:load()
    self.maxTime, self.targetStalls = Levels.getData(self.level)
end
function Score:update(stall, pc)
    self.ticksLevel = self.ticksLevel + 1
    if stall then
        self.stallsLoop = self.stallsLoop + 1
    end
    if pc == 1 and not stall then

        if self.stallsLoop <= self.targetStalls and self.stallsLastLoop <= self.targetStalls then
            return true
        end
        self.stallsLastLoop = self.stallsLoop
        self.stallsLoop = 0
    end
    self.text:set("Level "..self.level..Locale.gettext(" Points: ")..self.points.. Locale.gettext(" Time: ")..self.ticksLevel..Locale.gettext(" Target: ")..self.targetStalls)

    return false, self.ticksLevel <= self.maxTime
end
function Score:endLevel(won, loseText)
    if won then
        self.points = self.maxTime - self.ticksLevel
        if self.level >= Levels.num then            
            self.message:set(Locale.gettext("You completed all the levels! Want to play again?"),"continue")
            self.level = 1
        else
            self.message:set(Locale.gettext("You beat that level! Press Enter for the next level"),"continue")
            self.level = self.level + 1
        end
    else        
        self.message:set(loseText, "continue")        
    end
    self.ticksLevel = 0
end        
function Score:draw()
    local ly = Layout.score
    g.setColor(ly.colour)
    g.draw(self.text, ly.text.x, ly.text.y)
    g.setColor(ly.stall.colour)
    g.rectangle("fill", ly.stall.x, ly.stall.y, ly.stall.width, ly.stall.height * (self.maxTime-self.ticksLevel)/self.maxTime)
end
return Score
