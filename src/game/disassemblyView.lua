--[[
disassembly.lua

Copyright (C) 2016 Alex Burr
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Layout = require 'system.layout'
local g = love.graphics
local DisassemblyView = {}
DisassemblyView.__index = DisassemblyView

local MAX_CODE_LINES = 15

function DisassemblyView.create()
    local self = setmetatable({}, DisassemblyView)
    self.cursor = 1
    self.selected = false
    self.PC = 1
    return self
end

function DisassemblyView:load(code)
    self.code = code
    if #code >MAX_CODE_LINES then
        error("code scrolling not yet supported")
    end
end    

function DisassemblyView:update()
end

function DisassemblyView:next()
    local ret = self.code[self.PC]
    self.PC = self.PC + 1
    if self.PC == 1+#self.code then
        self.PC =1
    end
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

function DisassemblyView:controls(key, what)

    if what == 'keyReleased' then
        if key == 'return' then
            self.selected = not self.selected
        elseif key == 'up' or key == 'down' then
            
            local next
            if key == 'up' then
                next = self.cursor - 1
                if self.cursor == 1 then
                    next = #self.code
                end
            else
                next = self.cursor + 1
                if self.cursor == #self.code then
                    next = 1
                end
            end
            if self.selected then
                local tmp = self.code[self.cursor]
                self.code[self.cursor] = self.code[next]
                self.code[next] = tmp
            end
            self.cursor = next
        end
    end
end

return DisassemblyView
