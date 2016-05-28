--[[
scoreboard.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = require 'system.layout'
local Machine = require 'game.machine'

local Scoreboard ={}
Scoreboard.__index = Scoreboard
setmetatable(Scoreboard, {__index = Machine})

local g = love.graphics

function Scoreboard.create()
    local self = setmetatable(Machine.create(), Scoreboard)

    self.board = {}
    self.next.board = {}
    self.regs = {}
    self.next.regs = {}
    self.text = {}
    for i = 0, 16 do
        self.board[i] = false
        self.next.board[i] = false
        self.regs[i] = "a"
        self.next.regs[i] = "a"
        self.text[i] = g.newText(Layout.font, "r"..i)
    end

    return self
end

function Scoreboard:load()
end

function Scoreboard:update(dt)
end

function Scoreboard:alloc(reg, value)
    print("a:",reg,value)
    if self.board[reg] then
        print("Error: already scoreboarded",reg)
    end
    self.next.board[reg] = true
    self.next.regs[reg] = value
    
end
function Scoreboard:clear(reg)
    print("c",reg)
    if not self.board[reg] then
        print("Error: not scoreboarded",reg)
    end
    self.next.board[reg] = false
end
function Scoreboard:lookup(reg)
    return self.board[reg]
end
function Scoreboard:check(reg, value, op)
    local okay =  self.regs[reg]==value
    if not okay then
        print("Op ",op," expected ", value, " got ",self.regs[value]," in reg ",reg)
    end
    return okay
end
function Scoreboard:draw()
    local ly = Layout.scoreboard
    for i = 0, 16 do
        g.setColor(ly.outlineColour)
        g.rectangle("line",ly.x+ly.width*i, ly.y, ly.width, ly.height)
        if self.board[i] then        
            g.setColor(ly.scoreboardedColour)
        else
            g.setColor(ly.colour)
        end
        g.rectangle("fill",ly.x+ly.width*i, ly.y, ly.width, ly.height)
        g.setColor(Layout.textColour)
        g.draw(self.text[i], x, y)
    end
    
end


return Scoreboard
