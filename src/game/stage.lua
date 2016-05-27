--[[
stage.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--
local Layout = require 'system.layout'
local Machine = require 'game.machine'

local Stage ={}
Stage.__index = Stage
setmetatable(Stage, {__index = Machine})

local g = love.graphics

local debug = false
local dprint
local function nprint()
end
if debug then
    dprint = print
else
    dprint = nprint
end

function Stage.create(id, nextStage)
    local self = setmetatable(Machine.create(), Stage)
    self.next = {}
    self.input = {}
    self.id = id
    self.nextStage = nextStage
    self.moe = nil
    return self
end

function Stage:load()
    self.op = ""
end

function Stage:setNextOp(op)
    dprint("setnext",self.id )
    self.input.nextOP = op
end

function Stage:MoE()
    if self.moe == nil then
        self.moe = self.op == "" or self.nextStage:MoE()
    end
    return self.moe
end
local function opstr(op)
    if op == "" then return ""
    elseif op == nil then return "nil"
    else return op.op.." "..op.txt
    end
end
function Stage:tick()
    dprint(self.id, self:MoE(), opstr(self.op), opstr(self.next.op), opstr(self.input.nextOP))
    if self:MoE() then
        self.next.op = self.input.nextOP
        self.nextStage:setNextOp(self.input.nextOP)
    end
end


function Stage:draw()
    local ly = Layout.stage
    if not self.moe then        
        g.setColor(ly.stalledColour)
    else
        g.setColor(ly.colour)
    end
    g.rectangle("fill",ly[self.id].x, ly[self.id].y, ly.width, ly.height)
    if self.op ~= "" and self.op then
        self.op:draw(ly[self.id].x, ly[self.id].y)
    end
    
end

return Stage
