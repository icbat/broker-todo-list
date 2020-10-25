-----
-- Initialize Saved Variable(s)
-----
if icbat_btdl_data == nil then
    icbat_btdl_data = {
        v = 1,
        weekly = {{
            display = "Open your Great Vault",
            goal = 1,
            status = 0
        }, {
            display = "Raid Bosses killed",
            goal = 10,
            status = 0
        }, {
            display = "M+15 for weekly cache",
            goal = 10,
            status = 0
        }, {
            display = "Earn Conquest 1/3",
            goal = 1,
            status = 0
        }, {
            display = "Earn Conquest 2/3",
            goal = 1,
            status = 0
        }, {
            display = "Earn Conquest 3/3",
            goal = 1,
            status = 0
        }, {
            display = "Torghast",
            goal = 2,
            status = 0
        }},
        daily = {{
            display = "Dungeons Finished",
            goal = 2,
            status = 0
        }, {
            display = "Maw Ventured Into",
            goal = 1,
            status = 0
        }}
    }
end
