--[[
operation.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Layout = require "system.layout"
local Locale = require "system.locale"

local Operation ={}
Operation.__index = Operation
local love = love

function Operation.create(data)
    local self = setmetatable(data, Operation) -- PLS VIOLATION - turning raw data into a class

    self.loads = {LDL=1}
    self.stores = {STL=1}

    self.reads = {}
    for i = 1, #self.r, 2 do
        self.reads[self.r[i]]=true
    end
    self.writes = {}
    for i = 1, #self.w, 2 do
        self.writes[self.w[i]]=true
    end
    self.string = self.op .. ' ' .. self.txt
    
    self.text = love.graphics.newText(Layout.font, self.string)
    return self
end

function Operation:draw(x, y )
    love.graphics.setColor(Layout.textColour)
    love.graphics.draw(self.text, x, y)
end

function Operation:check(sc)

    local okay = true
    for i = 1, #self.r, 2 do
        okay = okay and sc:check(self.r[i], self.r[i+1], self.op)
    end
    return okay
end

function Operation:switchOkay(other)
    -- is it okay to swap this op with an adjacent one
    for i = 1, #self.w, 2 do

        if other.reads[self.w[i]] then
            return false, Locale.gettext("Can't move write of r$1 past read by $2",self.w[i],other.string)
        end
    end
    for i = 1, #self.r, 2 do

        if other.writes[self.r[i]] then
            return false, Locale.gettext("Can't move read of r$1 past write by $2 ",self.r[i], other.string)
        end
    end
    if (self:isLoad() and other:isStore())
    or (self:isStore() and other:isLoad()) then
        -- stg == store group (this is a hack)
        if self.stg == other.stg then
            return false, Locale.gettext("Can't tell if it's okay to move a load past a store, so I'm not going to let you!")
        end
    end
    if self:isStore() and other:isStore() then
        if self.stg == other.stg then
            return false, Locale.gettext("Can't tell if it's okay to move a store past a store, so I'm not going to let you!")
        end
    end
    return true
end

function Operation:isLoad()
    return self.loads[self.op] ~=nil
end

function Operation:isStore()
    return self.stores[self.op] ~=nil
end


function Operation:scoreboard(sc)

    for i = 1, #self.w, 2 do
        sc:alloc(self.w[i], self.w[i+1])
    end
end
function Operation:un_scoreboard(sc)
    for i = 1, #self.w, 2 do
        sc:clear(self.w[i])
    end
end
function Operation:mustWait(sc)
    local wait = false
    for i = 1, #self.r, 2 do
        -- for now ignore writes
        if sc:lookup(self.r[i], self.r[i+1]) then
            wait = true
        end
    end
    return wait
end
function Operation:getPipe()
    
    if     self.op == 'LDL' then return 'ldst'
    elseif self.op == 'STL' then return 'ldst'
    elseif self.op == 'ADD' then return 'arith'
    elseif self.op == 'MUL' then return 'mac'
    end
end
return Operation
