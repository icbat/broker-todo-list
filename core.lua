-- TODO how do I know when to reset stuff/how do we know when the daily reset is?
-- TODO how do I keep track of completed?
-- TODO how do I keep track of "I completed this today, but in a different login session"

local ADDON, namespace = ...
local L = namespace.L

-----
-- Initialize Saved Variable(s)
-----

if icbat_btdl_data == nil then
    icbat_btdl_data = {
        v = 1,
        weekly = {
            {display = "Open your Great Vault", goal = 1, status = 0},
            {display = "Raid Bosses killed", goal = 10, status = 0},
            {display = "M+15 for weekly cache", goal = 10, status = 0},
            {display = "Earn Conquest 1/3", goal = 1, status = 0},
            {display = "Earn Conquest 2/3", goal = 1, status = 0},
            {display = "Earn Conquest 3/3", goal = 1, status = 0},
            {display = "Torghast", goal = 2, status = 0},
        },
        daily = {
            {display = "Dungeons Finished", goal = 2, status = 0},
            {display = "Maw Ventured Into", goal = 1, status = 0},
        },
    }
end

-----
-- Do Stuff :)
-----

local function is_completed(task)
    return task["goal"] == task["status"]
end

local function calc_percentage(task)
    return task["status"] / task["goal"]
end

local function display_list(self, list)
    for _, task in pairs(list) do
        -- print(k, v["display"], v["goal"], v["status"])
        local is_completed = is_completed(task)
        local checkmark = ""
        if is_completed then
            checkmark = "X"
        end
        self:AddLine(checkmark, task["display"], calc_percentage(task) .. "%")
    end
end

local function build_tooltip (self)
    -- col 1 is for completed yes/no
    -- col 2 is for display
    -- col 3 is for % complete display
    self:AddHeader("", "ToDo List")
    self:AddLine()

    if (#icbat_btdl_data["weekly"] > 0) then
        self:AddHeader("", "Weekly Goals")
        self:AddSeparator()
        display_list(self, icbat_btdl_data["weekly"])
        self:AddLine()
    end

    if (#icbat_btdl_data["daily"] > 0) then
        self:AddHeader("", "Daily Goals")
        self:AddSeparator()
        display_list(self, icbat_btdl_data["daily"])
        self:AddLine()

    end
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

    local tooltip = LibQTip:Acquire("FooBarTooltip", 3, "RIGHT", "LEFT", "LEFT")
    self.tooltip = tooltip
    tooltip.OnRelease = OnRelease
    tooltip.OnLeave = OnLeave -- TODO WTF is this?
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
