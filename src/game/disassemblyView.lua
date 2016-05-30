--[[
disassembly.lua

Copyright (C) 2016 Alex Burr
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = require 'system.layout'
local Locale = require 'system.locale'
local g = love.graphics
local DisassemblyView = {}
DisassemblyView.__index = DisassemblyView

local MAX_CODE_LINES = 15

function DisassemblyView.create(gameStates)
    local self = setmetatable({}, DisassemblyView)
    self.gameStates = gameStates
    self.loseText1 = Locale.gettext("Crashed! you tried to move an instruction past the Program Counter! Press Enter to retry this Level")
    return self
end


function DisassemblyView:nextPC(val)
    if val  == #self.code then
        return 1
    else
        return val + 1
    end
end
function DisassemblyView:prevPC(val)
    if val  == 1 then
        return #self.code
    else
        return val - 1
    end
end

function DisassemblyView:load(code)
    self.cursor = 1
    self.selected = false
    self.PC = 1
    local newcode = {}
    for _, op in ipairs(code) do
        table.insert(newcode, op)
    end
    self.code = newcode
    if #code >MAX_CODE_LINES then
        error("code scrolling not yet supported")
    end
end    

function DisassemblyView:update()
end

function DisassemblyView:next()
    local ret = self.code[self.PC]
    self.PC = self:nextPC(self.PC)
    return ret
end


function DisassemblyView:draw()
    local ly = Layout.assemblyView
    -- body
    g.setColor(Layout.assemblyView.colour)
    g.rectangle("fill", ly.x, ly.y, ly.width, ly.height)
    -- operations
    for i, op in ipairs(self.code) do
        local y = ly.codeSep * (i-1)
        g.setColor(Layout.assemblyView.instBackgroundColour)
        -- selected op
        if  i == self.PC then
            g.setColor(Layout.assemblyView.PCColour)
        end
        g.rectangle("fill",ly.x, ly.y+y, ly.width, ly.instHeight)
        op:draw(ly.x, ly.y + y)
    end
    -- PC
    local y = ly.codeSep * (self.cursor-1)
    if self.selected then
        g.setColor(Layout.assemblyView.instSelectedColour)
    else
        g.setColor(Layout.assemblyView.cursorColour)
    end
    g.setLineWidth(ly.PCwidth)
    g.rectangle("line",ly.x, ly.y+y, ly.width, ly.instHeight)
    
end



function DisassemblyView:swapInsts(next)
        -- swap instruction at cursor with instruction at next
    if self.cursor == self:nextPC(self.PC) and next == self.PC then
        self.gameStates:endLevel(false, self.loseText1)
        return
    elseif next == self:nextPC(self.PC) and self.cursor == self.PC then
        self.gameStates:endLevel(false, self.loseText1)
        return
    end

    local okay, errMsg = self.code[self.cursor]:switchOkay(self.code[next])
    if not okay then
        self.gameStates:endLevel(false, errMsg)
        return
    end
        
    local tmp = self.code[self.cursor]
    self.code[self.cursor] = self.code[next]
    self.code[next] = tmp
end
function DisassemblyView:controls(key, what)

    if what == 'keyReleased' then
        if key == 'return' then
            self.selected = not self.selected
        elseif key == 'up' or key == 'down' then
            
            local next
            if key == 'up' then
                next = self:prevPC(self.cursor)
            else
                next = self:nextPC(self.cursor)
            end
            if self.selected then
                self:swapInsts(next)
            end
            self.cursor = next
        end
    end
end

return DisassemblyView
