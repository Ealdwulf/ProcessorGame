--[[
gameStates.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local GameManager = require "game.gameManager"
local Sounds = require "system.sounds"
local Message = require "game.ui.message"
local Score = require "game.score"
local Levels = require "game.levels"
local love = love
local GameStates ={}
GameStates.__index = GameStates


-- local variables

function GameStates.create()
    local self = setmetatable({}, GameStates)
    self.message = Message.create(self)
    self.message:set("Press ENTER to start game, ESCAPE to quit", "continue")
    self.score = Score.create(self.message)
    self.gameManager = GameManager.create(self, self.score)
    self.STATE_START = 1
    self.STATE_INGAME = 2
    self.STATE_WIN_LOSE = 3
    self.state = self.STATE_START

    return self    
end

function GameStates:load(_)
    self.score:load()
    self.gameManager:load()
    Sounds.load()
end

function GameStates:update(dt)
    if self.state == self.STATE_INGAME then
        self.gameManager:update(dt)
    end
end

function GameStates:draw()
    self.gameManager:draw()
    if self.state == self.STATE_START or self.state == self.STATE_WINLOSE then
        self.message:draw()
    end
end

function GameStates:doNothing()
    print("Error: message called before callback set")
end

function GameStates:continue()
    self.state = self.STATE_INGAME
    print("reload")
    self.gameManager:load()
    self.score:load()
end

function GameStates:endLevel(won, loseText)
    self.state = self.STATE_WINLOSE
    if not won then
        Sounds.play("bad")
    end
    self.score:endLevel(won, loseText)
end
            

function GameStates:quit()
    self.gameManager:quit()
end

-- Input --------------------------------------------------------------------------------

function GameStates:controls(key, what)
    if key == 'escape' and what == 'keyReleased' then
        self:quit()
    end
    if self.state == self.STATE_INGAME then
        self.gameManager:controls(key, what)        
    elseif self.state == self.STATE_START or self.state == self.STATE_WINLOSE then
        self.message:controls(key, what)
    end    
end

return GameStates
