--[[
message.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local g = love.graphics
local Layout = require "system.layout"

local Message ={}
Message.__index = Message

function Message.create(gameStates)
    local self = setmetatable({}, Message)
    self.gameStates = gameStates
    self.text = {}
    self.okayMethod = "doNothing"
    return self
end

local function splitWords(str, max)
    local curr = {}
    local currlen = 0
    local ret = {}
    for s in str:gmatch("[^ ]+") do
        if (currlen + #s) < max then
            table.insert(curr,s)

            currlen = currlen + #s+1
        else
            local line = table.concat(curr,' ')
            curr = {s}
            currlen = #s
            table.insert(ret, line)
        end
    end
    if #curr ~=0 then
        local line = table.concat(curr,' ')
        table.insert(ret, line)
    end
    return ret
end

function Message:set(text, okayMethod)
    self.okayMethod = okayMethod

    local strings = splitWords(text, Layout.message.text.maxchars)
    self.text = {}
    for _, s in ipairs(strings) do
        table.insert(self.text, love.graphics.newText(Layout.font, s))
    end
end

function Message:controls(key, what)
    if key == 'return' and what == 'keyReleased' then
        if self.gameStates[self.okayMethod] then
            self.gameStates[self.okayMethod](self.gameStates)
        end
    end
end

function Message:draw()
    local ly = Layout.message
    g.setColor(ly.colour)
    g.rectangle("fill", ly.x, ly.y, ly.width, ly.height)
    g.setColor(ly.text.colour)
    for i, t in ipairs(self.text) do
        g.draw(t, ly.text.x, ly.text.y+i*ly.text.ysep)
    end
end    


return Message
