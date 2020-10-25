local ADDON, namespace = ...

local function build_task_options(listName, task, i)
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
                    task["status"] = math.min(value, task["status"])
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

local function build_options_from_list(listName)
    local optionsList = {}

    for i, task in pairs(icbat_btdl_data[listName]) do
        optionsList[string.format("%s%d", task["display"], i)] = build_task_options(listName, task, i)
    end

    optionsList["Create New Task"] = {
        type = "execute",
        name = "Create New Task",
        func = function() table.insert(icbat_btdl_data[listName], namespace["template_task"]()) end,
    }

    return optionsList
end

local function build_options()
    return {
        type = "group",
        args = {
            weekly = {
                order = 1,
                name = "Weekly Goals",
                type = "group",
                args = build_options_from_list("weekly")
            },

            daily = {
                order = 2,
                name = "Daily Goals",
                type = "group",
                args = build_options_from_list("daily")
            },

            oneOff = {
                order = 3,
                name = "One-Off Goals",
                type = "group",
                args = build_options_from_list("oneOff")
            }
        }
    }
end

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable("Broker: ToDo", build_options)
namespace.options_panel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker: ToDo", "Broker: ToDo")
