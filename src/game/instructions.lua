--[[
instructions.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Operation = require "game.operation"

local Instructions ={}


-- for now, deps are explicit reather than analysed.
local testCode = {
    { op = "LDL", txt = "r0, [r9] ",      r = {9, "a"}, w = { 0, "b"},  },
    { op = "MUL", txt = "r0, r0, r8 ",    r = {0, "b", 8, "a"}, w = { 0, "c"},  },    
    { op = "LDL", txt = "r1, [r9, #8] ",  r = {9, "a"}, w = { 1, "b"},  },
    { op = "MUL", txt = "r1, r1, r8 ",    r = {1, "b", 8, "a"}, w = { 1, "c"},  },    
    { op = "ADD", txt = "r0, r0, r1 ",    r = {0, "c", 1, "c"}, w = { 0, "d"},  },    
    { op = "LDL", txt = "r2, [r9, #16] ", r = {9, "a"}, w = { 2, "b"},  },
    { op = "MUL", txt = "r2, r2, r8 ",    r = {2, "b", 8, "a"}, w = { 2, "c"},  },    
    { op = "LDL", txt = "r3, [r9, #24] ", r = {9, "a"}, w = { 3, "b"},  },
    { op = "MUL", txt = "r3, r3, r8 ",    r = {3, "b", 8, "a"}, w = { 3, "c"},  },    
    { op = "ADD", txt = "r2, r2, r3 ",    r = {2, "c", 3, "c"}, w = { 2, "d"},  },    
    { op = "ADD", txt = "r0, r0, r2 ",    r = {0, "d", 2, "d"}, w = { 0, "e"},  },    
    { op = "STL", txt = "r0, [r10],#8! ", r = {0, "e", 10, "a"}, w = { 10, "a"},  },    

}

function Instructions.getAll()
    local code = {}
    for _, data in ipairs(testCode) do
        table.insert(code, Operation.create(data))
    end

    return code
end

return Instructions
