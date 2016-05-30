--[[
gameManager.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Sounds = require "system.sounds"
local Locale = require "system.locale"
local DisassemblyView = require "game.disassemblyView"
local BlockManager = require "game.blockManager"
local Levels = require "game.levels"
local Issue = require "game.issue"
local Stage = require "game.stage"
local Completer = require "game.completer"
local Scoreboard = require "game.scoreboard"
ticks = 0  -- global for debug purposes
local love = love
local GameManager ={}
GameManager.__index = GameManager

-- local variables

function GameManager.create(gameStates, score)
    local self = setmetatable({}, GameManager)
    local blocks = {}
    self.blockManager = BlockManager.create(blocks)
    self.gameStates = gameStates

    self.score = score
    self.scoreboard = Scoreboard.create()
    self.disassemblyView = DisassemblyView.create(gameStates)

    blocks.completer_a = Completer.create("arith1",self.scoreboard)
    blocks.completer_m = Completer.create("mac8",self.scoreboard)
    blocks.completer_l = Completer.create("ldst5",self.scoreboard)
    blocks.ldst4 = Stage.create('ldst4',blocks.completer_l)
    blocks.ldst3 = Stage.create('ldst3',blocks.ldst4)
    blocks.ldst2 = Stage.create('ldst2',blocks.ldst3)
    blocks.ldst1 = Stage.create('ldst1',blocks.ldst2)
    blocks.mac7 = Stage.create('mac7',blocks.completer_m)
    blocks.mac6 = Stage.create('mac6',blocks.mac7)
    blocks.mac5 = Stage.create('mac5',blocks.mac6)
    blocks.mac4 = Stage.create('mac4',blocks.mac5)
    blocks.mac3 = Stage.create('mac3',blocks.mac4)
    blocks.mac2 = Stage.create('mac2',blocks.mac3)
    blocks.mac1 = Stage.create('mac1',blocks.mac2)

    blocks.issue = Issue.create(self.disassemblyView, self.scoreboard, blocks.completer_a, blocks.ldst1, blocks.mac1)
    self.blocks = blocks
    
    return self
end

function GameManager:load(_)
    self.code = Levels.getInstructions(self.score.level)
    self.tickTime = 1.0
    self.accumTime = 0
    self.tickNext = true
    self.disassemblyView:load(self.code)
    self.blockManager:load()
    self.scoreboard:load()
end

function GameManager:update(dt)
    self.disassemblyView:update(dt)
    self.accumTime = self.accumTime + dt
    if self.accumTime > self.tickTime*0.5 then
        if self.tickNext then
            Sounds.play("tick")
            self:tick()
            local stall = self.blocks.issue:update(dt)
            local pc = self.disassemblyView:getPC()
            local finished, okayStalls = self.score:update(stall, pc)
            if finished then
                self.gameStates:endLevel(true)
                return
            end
            if not okayStalls then
                -- lose  due to running out of stall points
                
                self.gameStates:endLevel(false, Locale.gettext("The machine stalled too many times! Press enter to try again or ESC to quit"))
            end
            
        else
            Sounds.play("tock")
            self:tock()
        end
        self.tickNext = not self.tickNext
        self.accumTime = 0
        
    end
    
end
function GameManager:tick()
    ticks = ticks + 1
    self.blockManager:tick()

end
function GameManager:tock()
    self.blockManager:tock()
    self.scoreboard:tock()
end

function GameManager:draw()
    self.disassemblyView:draw()
    self.blockManager:draw()
    self.scoreboard:draw()
    self.score:draw()
end


function GameManager:quit()
    love.event.quit()
end

-- Input --------------------------------------------------------------------------------

function GameManager:controls(key, what)
    self.disassemblyView:controls(key, what)
end



return GameManager
