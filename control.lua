if script.level.campaign_name then return end -- Don't init if it's a campaign

local event_handler = require("__zk-lib__/static-libs/lualibs/event_handler_vZO.lua")


---@type table<string, module>
local modules = {}

--- Adds https://github.com/ZwerOxotnik/factorio-BetterCommands if exists
if script.active_mods["BetterCommands"] then
	local is_ok, better_commands = pcall(require, "__BetterCommands__/BetterCommands/control")
	if is_ok then
		better_commands.COMMAND_PREFIX = "fm_"
		modules.better_commands = better_commands
	end
end

local version = settings.startup["free_market-version"].value
if version == "stable" then
	modules.free_market = require("models/free-market")
elseif version == "debug" then
	modules.free_market = require("models/free-market-debug")
elseif version == "extra-stable" then
	modules.free_market = require("models/free-market-extra-stability")
end



if modules.better_commands then
	if modules.better_commands.handle_custom_commands then
		modules.better_commands.handle_custom_commands(modules.free_market) -- adds commands
	end
	if modules.better_commands.expose_global_data then
		modules.better_commands.expose_global_data()
	end
end


event_handler.add_libraries(modules)


-- Auto adds remote access for rcon and for other mods/scenarios via zk-lib
if script.active_mods["zk-lib"] then
	local is_ok, remote_interface_util = pcall(require, "__zk-lib__/static-libs/lualibs/control_stage/remote-interface-util")
	if is_ok and remote_interface_util.expose_global_data then
		remote_interface_util.expose_global_data()
	end
	local is_ok, rcon_util = pcall(require, "__zk-lib__/static-libs/lualibs/control_stage/rcon-util")
	if is_ok and rcon_util.expose_global_data then
		rcon_util.expose_global_data()
	end
end


-- This is a part of "gvv", "Lua API global Variable Viewer" mod. https://mods.factorio.com/mod/gvv
-- It makes possible gvv mod to read sandboxed variables in the map or other mod if following code is inserted at the end of empty line of "control.lua" of each.
if script.active_mods["gvv"] then require("__gvv__.gvv")() end
