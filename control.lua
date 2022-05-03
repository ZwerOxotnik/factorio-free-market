if script.level.campaign_name then return end -- Don't init if it's a campaign

local event_handler = require("__zk-lib__/static-libs/lualibs/event_handler_vZO.lua")


---@type table<string, module>
local modules = {}
modules.better_commands = require("models/BetterCommands/control")

local version = settings.startup["free_market-version"].value
if version == "stable" then
	modules.free_market = require("models/free-market")
elseif version == "debug" then
	modules.free_market = require("models/free-market-debug")
end


modules.better_commands:handle_custom_commands(modules.free_market) -- adds commands

event_handler.add_libraries(modules)

if script.active_mods["gvv"] then require("__gvv__.gvv")() end
