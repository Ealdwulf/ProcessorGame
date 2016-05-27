--[[
gameManager.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local DisassemblyView = require "game.disassemblyView"
local Instructions = require "game.instructions"
local Issue = require "game.issue"
local Stage = require "game.stage"
local Completer = require "game.completer"
local Scoreboard = require "game.scoreboard"

local love = love
local GameManager ={}
GameManager.__index = GameManager


-- local variables

function GameManager.create()
    local self = setmetatable({}, GameManager)

    self.scoreboard = Scoreboard.create()
    self.disassemblyView = DisassemblyView.create()
    self.code = Instructions.getAll()
    self.tickTime = 1.0
    self.accumTime = 0

    self.completer_a = Completer.create("cA",self.scoreboard)
    self.completer_m = Completer.create("cM",self.scoreboard)
    self.completer_l = Completer.create("cLS",self.scoreboard)
    self.arith1 = Stage.create('arith1',self.completer_a)
    self.ldst5 = Stage.create('ldst5',self.completer_l)
    self.ldst4 = Stage.create('ldst4',self.ldst5)
    self.ldst3 = Stage.create('ldst3',self.ldst4)
    self.ldst2 = Stage.create('ldst2',self.ldst3)
    self.ldst1 = Stage.create('ldst1',self.ldst2)
    self.mac8 = Stage.create('mac8',self.completer_m)
    self.mac7 = Stage.create('mac7',self.mac8)
    self.mac6 = Stage.create('mac6',self.mac7)
    self.mac5 = Stage.create('mac5',self.mac6)
    self.mac4 = Stage.create('mac4',self.mac5)
    self.mac3 = Stage.create('mac3',self.mac4)
    self.mac2 = Stage.create('mac2',self.mac3)
    self.mac1 = Stage.create('mac1',self.mac2)
    self.pipeStages = {
        self.arith1,
        self.ldst5,
        self.ldst4,
        self.ldst3,
        self.ldst2,
        self.ldst1,
        self.mac8 ,
        self.mac7 ,
        self.mac6 ,
        self.mac5 ,
        self.mac4 ,
        self.mac3 ,
        self.mac2 ,
        self.mac1,
        self.completer_a,
        self.completer_l,
        self.completer_m,
    }

    self.issue = Issue.create(self.disassemblyView, self.scoreboard, self.arith1, self.ldst1, self.mac1)
    
    return self
end

function GameManager:load(_)
    print('gm.l',self.code)
    self.disassemblyView:load(self.code)
    self.issue:load()
end

function GameManager:update(dt)    
    self.disassemblyView:update(dt)
    self.issue:update(dt)
    self.accumTime = self.accumTime + dt
    if self.accumTime > self.tickTime then
        self:tick()
        self:tock()
        self.accumTime = 0
    end
end
function GameManager:tick()
    self.issue:tick()
    for _, p in ipairs(self.pipeStages) do
        p:tick()
    end

end
function GameManager:tock()
    self.issue:tock()
    for _, p in ipairs(self.pipeStages) do
        p:tock()
    end
    self.scoreboard:tock()
end

function GameManager:draw()
    self.disassemblyView:draw()
    self.issue:draw()
    for _, p in ipairs(self.pipeStages) do
        p:draw()
    end
    self.scoreboard:draw()
end


function GameManager:quit()
end

-- Input --------------------------------------------------------------------------------

function GameManager:controls(key, what)
    self.disassemblyView:controls(key, what)
end



return GameManager
