data:extend({
	{type = "int-setting", name = "FM_money-treshold", setting_type = "runtime-global", default_value = 100, minimal_value = 1, maximal_value = 1e19},
	{type = "int-setting", name = "FM_update-tick", setting_type = "runtime-global", default_value = 90, minimal_value = 1, maximal_value = 8e4},
	{type = "int-setting", name = "FM_minimal-price", setting_type = "runtime-global", default_value = 1, minimal_value = 1, maximal_value = 1e19},
	{type = "int-setting", name = "FM_maximal-price", setting_type = "runtime-global", default_value = 1e9, minimal_value = 1, maximal_value = 1e19},
	{type = "bool-setting", name = "FM_enable-auto-embargo", setting_type = "runtime-global", default_value = true},
	{type = "bool-setting", name = "FM_is-public-titles", setting_type = "runtime-global", default_value = true}
})

-- minimal price
-- FM max price
-- FM money threshold
