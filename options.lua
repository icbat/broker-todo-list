local ADDON, namespace = ...

local optionsTable = {
    type = "group",
    args = {

        daily = {
            name = "Daily Goals",
            type = "group",
            args = {},
        },

        weekly = {
            name = "Weekly Goals",
            type = "group",
            args = {},
        },
    },
}

local function build_options(listName)
    optionsTable["args"][listName]["args"] = {}
    local optionsList = optionsTable["args"][listName]["args"]
    for i, task in pairs(icbat_btdl_data[listName]) do
        local options = {
            name = task["display"],
            order = i,
            type = "group",
            args = {
                name = {
                    order = 1,
                    name = "Task Name",
                    type = "input",
                    get = function() return icbat_btdl_data[listName][i]["display"] end,
                    set = function (info, value) icbat_btdl_data[listName][i]["display"] = value end,
                },
                goal = {
                    order = 2,
                    name = "Goal",
                    desc = "How many times do you want to complete this?",
                    confirm = true,
                    type = "range",
                    step = 1,
                    min = 1,
                    max = 100,
                    softMax = 10,
                    get = function() return icbat_btdl_data[listName][i]["goal"] end,
                    set = function (info, value) icbat_btdl_data[listName][i]["goal"] = value end,
                },
                delete = {
                    order = 3,
                    name = "Remove this task",
                    type = "execute",
                    func = function()
                        table.remove(icbat_btdl_data[listName], i)
                        build_options(listName)
                        AceConfigRegistry:NotifyChange("Broker: ToDo")
                    end
                }
            },
        }

        optionsList[task["display"]] = options
    end
end

build_options("weekly")
build_options("daily")

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable("Broker: ToDo", optionsTable)
namespace.options_panel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker: ToDo", "Broker: ToDo")
