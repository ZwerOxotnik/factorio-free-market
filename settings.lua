--- Adds settings for commands
if mods["BetterCommands"] then
	local is_ok, better_commands = pcall(require, "__BetterCommands__/BetterCommands/control")
	if is_ok then
		better_commands.COMMAND_PREFIX = "fm_"
		better_commands.create_settings("iFreeMarket", "fm_") -- Adds switchable commands
	end
end


data:extend({
	{type = "int-setting", name = "FM_money-treshold", setting_type = "runtime-global", default_value = 100, minimum_value = 1, maximum_value = 1e18},
	{type = "int-setting", name = "FM_update-tick", setting_type = "runtime-global", default_value = 60, minimum_value = 1, maximum_value = 8e4},
	{type = "int-setting", name = "FM_update-transfer-tick", setting_type = "runtime-global", default_value = 240, minimum_value = 2, maximum_value = 8e4},
	{type = "int-setting", name = "FM_update-pull-tick", setting_type = "runtime-global", default_value = 360, minimum_value = 1, maximum_value = 8e4},
	{type = "int-setting", name = "FM_minimal-price", setting_type = "runtime-global", default_value = 1, minimum_value = 1, maximum_value = 1e18},
	{type = "int-setting", name = "FM_maximal-price", setting_type = "runtime-global", default_value = 1e9, minimum_value = 1, maximum_value = 1e18},
	{type = "int-setting", name = "FM_skip_offline_team_chance", setting_type = "runtime-global", default_value = 0, minimum_value = 0, maximum_value = 100},
	{type = "int-setting", name = "FM_max_storage_threshold", setting_type = "runtime-global", default_value = 1000, minimum_value = 1, maximum_value = 4000000000},
	{type = "bool-setting", name = "FM_enable-auto-embargo", setting_type = "runtime-global", default_value = true},
	{type = "bool-setting", name = "FM_is-public-titles", setting_type = "runtime-global", default_value = true},
	{type = "bool-setting", name = "FM_is_reset_public", setting_type = "runtime-global", default_value = true},
	{type = "int-setting", name = "FM_sell_notification_column_count", setting_type = "runtime-per-user", default_value = 1, minimum_value = 1, maximum_value = 10},
	{type = "int-setting", name = "FM_buy_notification_column_count", setting_type = "runtime-per-user", default_value = 1, minimum_value = 1, maximum_value = 10},
	{type = "int-setting", name = "FM_sell_notification_size", setting_type = "runtime-per-user", default_value = 6, minimum_value = 1, maximum_value = 40},
	{type = "int-setting", name = "FM_buy_notification_size",  setting_type = "runtime-per-user", default_value = 6, minimum_value = 1, maximum_value = 40},
	{type = "bool-setting", name = "FM_show_item_price", setting_type = "runtime-per-user", default_value = true},
	{type = "double-setting", name = "FM_pull_cost_per_item", setting_type = "runtime-global", default_value = 0, minimum_value = 0, maximum_value = 4000000000},
})

--TODO: change setting_type!
data:extend({
	{
		type = "string-setting",
		name = "free_market-version",
		setting_type = "startup",
		default_value = "extra-stable",
		localised_name = {"gui-mod-info.version"},
		allowed_values = {"debug", "stable", "extra-stable"}
	}
})
