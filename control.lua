if script.level.campaign_name then return end -- Don't init if it's a campaign

local event_handler = require("event_handler")


---@type table<string, module>
local modules = {}
modules.better_commands = require("models/BetterCommands/control")
modules.free_market = require("models/free-market")


modules.better_commands:handle_custom_commands(modules.free_market) -- adds commands

event_handler.add_libraries(modules)
