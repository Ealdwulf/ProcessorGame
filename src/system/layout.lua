--[[
layout.lua

Copyright (C) 2016 Alex Burr
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = {}
local love = love
local RED_MID = {128, 0, 0}
local GREEN_MID = {0, 128, 0}
local BLUE_MID = {0, 0, 128}
local GREEN_6 = {0, 176, 0}
local GREEN = {0, 0, 256}
local BLACK = {0, 0, 0}

local RED = {256, 0, 0}

local YELLOW = {256, 256, 0}
Layout.assemblyView  = {
    colour = RED_MID,
    
    instBackgroundColour = GREEN_MID,
    PCColour = GREEN_6,
    cursorColour = BLUE_MID,
    instSelectedColour = GREEN,
    x = 0,
    y = 100,
    width = 150,
    height = 700,
    codeSep = 30,
    instHeight = 20,
    PCwidth = 3
}
Layout.issue = {
    colour = GREEN_MID,
    stalledColour = YELLOW,

    x = 400-150/2,
    y = 10,
    width = 150,
    height = 30
    
}
Layout.scoreboard = {
    outlineColour = BLACK,
    colour = GREEN_MID,
    scoreboardedColour = YELLOW,
    x = 170,
    y = 50,
    width = 20,
    height = 20
}
Layout.stage = {
    colour = GREEN_MID,
    stalledColour = YELLOW,
    width = 150,
    height = 30,

    arith1 = {x=160, y=100},

    ldst1 = {x=330, y=100},
    ldst2 = {x=330, y=140},
    ldst3 = {x=330, y=180},
    ldst4 = {x=330, y=220},
    ldst5 = {x=330, y=260},

    mac1 = {x=500, y=100},
    mac2 = {x=500, y=140},
    mac3 = {x=500, y=180},
    mac4 = {x=500, y=220},
    mac5 = {x=500, y=260},
    mac6 = {x=500, y=300},
    mac7 = {x=500, y=340},
    mac8 = {x=500, y=380},
    
}
Layout.textColour = BLACK
Layout.font = love.graphics.newFont(16)
    
return Layout
