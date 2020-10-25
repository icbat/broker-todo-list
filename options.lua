local ADDON, namespace = ...

local function buildTaskOptions(listName, task, i)
    print(task["display"], task["goal"])
    return {
        name = task["display"],
        order = i,
        type = "group",
        args = {
            name = {
                order = 1,
                name = "Task Name",
                type = "input",
                get = function()
                    return task["display"]
                end,
                set = function(info, value)
                    task["display"] = value
                end
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
                get = function()
                    return task["goal"]
                end,
                set = function(info, value)
                    task["goal"] = value
                end
            },
            delete = {
                order = 3,
                name = "Remove this task",
                type = "execute",
                func = function()
                    table.remove(icbat_btdl_data[listName], i)
                end
            }
        }
    }
end

local function asdfasdfasdf(listName)
    local optionsList = {}

    for i, task in pairs(icbat_btdl_data[listName]) do
        optionsList[task["display"]] = buildTaskOptions(listName, task, i)
    end

    return optionsList
end


local function build_options()
    return {
        type = "group",
        args = {
            daily = {
                name = "Daily Goals",
                type = "group",
                args = asdfasdfasdf("daily")
            },

            weekly = {
                name = "Weekly Goals",
                type = "group",
                args = asdfasdfasdf("weekly")
            }
        }
    }
end

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable("Broker: ToDo", build_options)
namespace.options_panel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker: ToDo", "Broker: ToDo")
