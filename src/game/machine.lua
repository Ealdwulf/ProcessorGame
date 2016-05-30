--[[
machine.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Tserial = require "libs.Tserial"
local function ignore(x)
    return ""
end
local Machine ={}
Machine.__index = Machine

local debug = false
local dprint
local function nprint()
end
if debug then
    dprint = print
else
    dprint = nprint
end

function Machine.create()
    local self = setmetatable({}, Machine)
    self.next = {}
    return self
end
function Machine:tockcp(where,wherenext,k)
    dprint(k, wherenext, type(wherenext))
    if type(wherenext[k]) == 'table' and not wherenext[k].__index then
        for ik, _ in pairs(wherenext[k]) do
            dprint('ik',ik, type(wherenext[k]))
            self:tockcp(where[k],wherenext[k],ik)
        end
    else
        where[k] = wherenext[k]
        wherenext[k] = nil
    end
end
function Machine:tock()
    --dprint(Tserial.pack(self, ignore))
    for k, _ in pairs(self.next) do
        
        self:tockcp(self,self.next,k)
    end
    
end
    

return Machine
