-- https://phanx.net/addons/tutorials/localize
local _, namespace = ...

local L = setmetatable({}, {
    __index = function(t, k)
        local v = tostring(k)
        rawset(t, k, v)
        return v
    end
})

namespace.L = L

local LOCALE = GetLocale()

if LOCALE == "enUS" then
    -- The EU English game client also
    -- uses the US English locale code.
    return
end

---- To add translations, use this block as a starting point

-- if LOCALE == "deDE" then
--     -- German translations go here
--     L["I need to open my cache!"] = "German for 'I need to open my weekly cache still!'"
--     L["I have no key."] = "German for 'I have no key, I have been slacking.'"
--     return
-- end
