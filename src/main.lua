--[[
main.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local love = love
local GameStates = require "game.gameStates"
local gameStates = GameStates.create()
-- local variables

function love.load(_)
    -- System
    love.graphics.setBackgroundColor(0, 0, 0)
    gameStates:load()
end

function love.update(dt)

    gameStates:update(dt)
end

function love.draw()
    gameStates:draw()
end


function love.quit()
end

-- Input --------------------------------------------------------------------------------

function love.keypressed(key)
    gameStates:controls(key, 'keyPressed')
end

function love.keyreleased(key)
    gameStates:controls(key, 'keyReleased')
end
