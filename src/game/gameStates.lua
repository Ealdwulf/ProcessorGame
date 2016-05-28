--[[
gameStates.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local GameManager = require "game.gameManager"
local Sounds = require "src.system.sounds"

local love = love
local GameStates ={}
GameStates.__index = GameStates

-- local variables

function GameStates.create()
    local self = setmetatable({}, GameStates)
    self.gameManager = GameManager.create()
    self.STATE_INGAME = 1
    self.STATE_WIN_LOSE = 2
    self.state = self.STATE_INGAME

    return self    
end

function GameStates:load(_)
    self.gameManager:load()
    Sounds.load()
end

function GameStates:update(dt)
    if self.state == self.STATE_INGAME then
        self.gameManager:update(dt)
    end
end

function GameStates:draw()
    if self.state == self.STATE_INGAME then
        self.gameManager:draw()
    end
end


function GameStates:quit()
    self.gameManager:quit()
end

-- Input --------------------------------------------------------------------------------

function GameStates:controls(key, what)
    if self.state == self.STATE_INGAME then
        if key == 'escape' and what == 'keyReleased' then
            print(key)
            love.quit() -- why isn't this working?
        end
        self.gameManager:controls(key, what)
    end    
end

return GameStates
