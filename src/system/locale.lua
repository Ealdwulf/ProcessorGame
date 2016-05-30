--[[
locale.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Locale = {}

function Locale.gettext(text, ...)  -- not actually implemented yet
    for i, v in ipairs(arg) do
        text = text:gsub("%$"..i, v)
    end
    return text
end

return Locale
