-- TODO how do I know when to reset stuff/how do we know when the daily reset is?
-- TODO need a way to reset/decrement status manually
-- TODO fill out localization example
-- TODO label should be interesting
-- TODO should show status in the tooltip (maybe not percent at all?)

local ADDON, namespace = ...
local L = namespace.L

-----
-- Do Stuff :)
-----

local function is_completed(task)
    return task["goal"] == task["status"]
end

local function calc_percentage(task)
    return  100 * task["status"] / task["goal"]
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
    for _, task in pairs(list) do
        local is_completed = is_completed(task)
        local percentage = calc_percentage(task)

        local checkmark = ""
        if is_completed then
            checkmark = "X"
        end

        local line = self:AddLine(checkmark, task["display"], string.format("%d%%", percentage))

        if not is_completed then
            local increment_status = function()
                self:Clear()
                task["status"] = task["status"] + 1
            end
            self:SetLineScript(line, "OnMouseUp", increment_status)
        end

        self:SetCellTextColor(line, 3, percentage_color(percentage))
    end
end

local function build_tooltip (self)
    -- col 1 is for completed yes/no
    -- col 2 is for display
    -- col 3 is for % complete display
    if (#icbat_btdl_data["weekly"] == 0 and #icbat_btdl_data["daily"] == 0 and #icbat_btdl_data["oneOff"] == 0) then
        self:AddHeader("", "ToDo List")
        self:AddSeparator()
        self:AddLine("", "Setup goals in Settings -> Interface -> Addons")
        self:AddLine()
    end

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

    if (#icbat_btdl_data["oneOff"] > 0) then
        self:AddHeader("", "One-Off Goals")
        self:AddSeparator()
        display_list(self, icbat_btdl_data["oneOff"])
        self:AddLine()
    end

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
