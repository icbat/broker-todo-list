-- TODO how do I trigger a daily thing? How do I know when the reset is?
-- TODO how do I keep track of completed?
-- TODO how do I keep track of "I completed this today, but in a different login session"

local ADDON, namespace = ...
local L = namespace.L

--- initialize saved variable if it doesn't exist
if icbat_btdl_data == nil then
    -- whether or not the label should show full names or initials
    icbat_btdl_data = {
        v = 1,
        weekly = {},
        daily = {},
    }
end


-- do stuff :)

local function build_tooltip (tooltip) 

end

-----
-- LDB setup
-----

local LibQTip = LibStub('LibQTip-1.0')

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local dataobj = ldb:NewDataObject(ADDON, {
    type = "data source",
    text = "Broker: ToDo List"
})

local function OnRelease(self)
    LibQTip:Release(self.tooltip)
    self.tooltip = nil
end

local function anchor_OnEnter(self)
    if self.tooltip then
        LibQTip:Release(self.tooltip)
        self.tooltip = nil
    end

    -- Acquire a tooltip with 3 columns, respectively aligned to left, center and right
    local tooltip = LibQTip:Acquire("FooBarTooltip", 2, "RIGHT", "LEFT")
    self.tooltip = tooltip
    tooltip.OnRelease = OnRelease
    tooltip.OnLeave = OnLeave
    tooltip:SetAutoHideDelay(.1, self)

    build_tooltip(tooltip)

    -- Use smart anchoring code to anchor the tooltip to our frame
    tooltip:SmartAnchorTo(self)

    -- Show it, et voilà !
    tooltip:Show()
end

-- tooltip/broker object settings
function dataobj:OnEnter()
    anchor_OnEnter(self)
end

function dataobj:OnLeave()
    -- Nothing to do. Needs to be defined for some display addons apparently
end

function dataobj:OnClick()
    -- what should happen on click of the broker? nothing?
end

local function set_label(self)
    dataobj.text = "yes hello I am loaded"
end

-- invisible frame for updating/hooking events
local f = CreateFrame("frame")
local UPDATEPERIOD = 5
local elapsed = 0
f:SetScript("OnUpdate", function(self, elap)
    elapsed = elapsed + elap
    if elapsed < UPDATEPERIOD then
        return
    end
    elapsed = 0
    set_label(self)
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
