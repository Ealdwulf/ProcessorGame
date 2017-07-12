--[[
levels.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Operation = require "game.operation"
local Levels ={}

Levels.num = 2

-- for now, deps are explicit reather than analysed.
local levelData =  {
    {
            challenge = '',
            code = {
                { op = "LDL", txt = "r0, [r9] ",      r = {9, "a"}, w = { 0, "b"},  stg=1},
                { op = "ADD", txt = "r0, r0, #1 ",    r = {0, "b"}, w = { 0, "b"},  },    
                { op = "LDL", txt = "r1, [r9, #8] ",  r = {9, "a"}, w = { 1, "b"},  stg=1},
                { op = "ADD", txt = "r1, r1, #1 ",    r = {1, "b"}, w = { 1, "b"},  },    
            },
            max_time = 60,
            min_stalls_per_loop = 4,
        },
        {
            code = {
                { op = "LDL", txt = "r0, [r9] ",      r = {9, "a"}, w = { 0, "b"},   stg=1},
                { op = "MUL", txt = "r6, r0, r8 ",    r = {0, "b", 8, "a"}, w = { 6, "c"},  },    
                { op = "LDL", txt = "r1, [r9, #8] ",  r = {9, "a"}, w = { 1, "b"},  stg=1},
                { op = "MUL", txt = "r11, r1, r8 ",    r = {1, "b", 8, "a"}, w = { 11, "c"},  },    
                { op = "ADD", txt = "r4, r6, r11 ",    r = {6, "c", 11, "c"}, w = { 4, "d"},  },    
                { op = "LDL", txt = "r2, [r9, #16] ", r = {9, "a"}, w = { 2, "b"},  stg=1},
                { op = "MUL", txt = "r12, r2, r8 ",    r = {2, "b", 8, "a"}, w = { 12, "c"},  },    
                { op = "LDL", txt = "r3, [r9, #24] ", r = {9, "a"}, w = { 3, "b"},  stg=1},
                { op = "MUL", txt = "r13, r3, r8 ",    r = {3, "b", 8, "a"}, w = { 13, "c"},  },    
                { op = "ADD", txt = "r5, r12, r13 ",    r = {12, "c", 13, "c"}, w = { 5, "d"},  },    
                { op = "ADD", txt = "r4, r4, r5 ",    r = {4, "d", 5, "d"}, w = { 4, "e"},  },    
                { op = "STL", txt = "r4, [r10],#8! ", r = {4, "e", 10, "a"}, w = { 10, "a"},  stg=2},
        },
            max_time = 350,
            min_stalls_per_loop = 0,
    }
}
function Levels.getInstructions(level)
    local code = {}
    for _, data in ipairs(levelData[level].code) do
        table.insert(code, Operation.create(data))
    end

    return code
end
function Levels.getData(level)
    return levelData[level].max_time, levelData[level].min_stalls_per_loop
end
return Levels
