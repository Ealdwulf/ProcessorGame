--[[
locale.lua

Copyright (C) 2016 Alex Burr.
License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2

]]--

local Locale = {}

function Locale.gettext(text, ...)  -- not actually implemented yet
    for i=1, select('#',...) do
        local argi = select(i, ...)
        text = text:gsub("%$"..i, argi)
    end
    return text
end

return Locale
