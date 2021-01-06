-- TODO options revamped
-- TODO another task or 2 to start

-- TODO label should be interesting
-- TODO should show status in the tooltip (maybe not percent at all?)
-- TODO what's it like when there are no tasks? is that reasonable?
-- TODO extract some common vars for things like "Broker: ToDo List"
-- TODO fill out localization example

-- initial release above this line
------------


local ADDON, namespace = ...
local L = namespace.L

-----
-- Do Stuff :)
-----

--- a dictionary of name: percentage completed (float 0-1)
local internalState = {}

namespace.updateStat = function(name, percentage)
    -- namespace.log(name, "percent completed", percentage, "%")
    internalState[name] = percentage
end

local function percentage_color(percentage)
    if percentage == 0 then
        return 1, 0, 0, 1
    end

    if percentage == 100 then
        return 0, 1, 0, 1
    end

    return 1, 0.5, 0, 1
end

local function display_list(self, list)
    for name, percentage in pairs(list) do
        local is_completed = percentage >= 1
        local converted = percentage * 100

        local checkmark = ""
        if is_completed then
            checkmark = "X"
        end

        local line = self:AddLine(checkmark, name, string.format("%d%%", converted))

        self:SetCellTextColor(line, 3, percentage_color(converted))
    end
end

local function build_tooltip (self)
    -- col 1 is for completed yes/no
    -- col 2 is for display
    -- col 3 is for % complete display

    -- TODO what do we show if they don't want to see any goals?
    -- if (#icbat_btdl_data["weekly"] == 0 and #icbat_btdl_data["daily"] == 0 and #icbat_btdl_data["oneOff"] == 0) then
        -- self:AddHeader("", "ToDo List")
        -- self:AddSeparator()
        -- self:AddLine("", "Setup goals in Settings -> Interface -> Addons")
        -- self:AddLine()
    -- end

    self:AddHeader("", "Goals")
    self:AddSeparator()
    display_list(self, internalState)
    self:AddLine()

    self:SetColumnTextColor(1, 0, 1, 0, 1)
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

    local tooltip = LibQTip:Acquire("BrokerTodoTooltip", 3, "RIGHT", "LEFT", "LEFT")
    self.tooltip = tooltip
    tooltip.OnRelease = OnRelease
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
    InterfaceOptionsFrame_Show()
    if InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame_OpenToCategory(namespace.options_panel)
    end
end
