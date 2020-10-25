local ADDON, namespace = ...

local optionsTable = {
    type = "group",
    args = {
        weekly = {
            name = "Weekly Goals",
            type = "group",
            desc = "Add any weeklyy goals here",
            args = {},
        },

        daily = {
            name = "Daily Goals",
            type = "group",
            desc = "Add any daily goals here",
            args = {},
        },
    },
}

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable("Broker: ToDo", optionsTable)
namespace.options_panel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker: ToDo", "Broker: ToDo")