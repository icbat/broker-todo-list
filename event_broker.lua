local ADDON, namespace = ...
local L = namespace.L

-- invisible frame for updating/hooking events
local event_frame = CreateFrame("frame")

local onUpdate = {}

namespace.registerOnUpdate = function(event)
    namespace.log("registering event", event.name)
    table.insert(onUpdate, event)
    
    -- register with 0 so there's no dead period w/ an empty tooltip
    namespace.updateStat(event.name, 0)
end

local updateAllStats = function()
    for _, event in pairs(onUpdate) do
        namespace.updateStat(event.name, event.percentCompleted())
    end
end


local UPDATEPERIOD = 10
local elapsed = 0
event_frame:SetScript("OnUpdate", function(self, elap)
    elapsed = elapsed + elap
    if elapsed < UPDATEPERIOD then
        return
    end
    elapsed = 0

    updateAllStats()
end)

event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:SetScript("OnEvent", updateAllStats)


