--[[
sounds.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local a = love.audio
local love = love

local SOUNDS_FOLDER = "res/sounds/"

local Sounds = {}

function Sounds.load()
    local files = love.filesystem.getDirectoryItems(SOUNDS_FOLDER)
    for _, f in ipairs(files) do
        local s = f:match("^(.*)%.[^.]*$") -- remove suffix
        Sounds[s] = a.newSource(SOUNDS_FOLDER .. f, "static")
    end
end

function Sounds.play(name)
    a.play(Sounds[name])
end


return Sounds
