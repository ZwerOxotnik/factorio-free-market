local M = {} -- models/free-market.can:2
local __mod_data -- models/free-market.can:8
local __embargoes -- models/free-market.can:13
local __sell_prices -- models/free-market.can:18
local __inactive_sell_prices -- models/free-market.can:23
local __buy_prices -- models/free-market.can:28
local __inactive_buy_prices -- models/free-market.can:33
local __transfer_boxes -- models/free-market.can:38
local __inactive_transfer_boxes -- models/free-market.can:43
local __bin_boxes -- models/free-market.can:48
local __inactive_bin_boxes -- models/free-market.can:53
local __universal_transfer_boxes -- models/free-market.can:58
local __inactive_universal_transfer_boxes -- models/free-market.can:63
local __universal_bin_boxes -- models/free-market.can:68
local __inactive_universal_bin_boxes -- models/free-market.can:73
local __buy_boxes -- models/free-market.can:78
local __inactive_buy_boxes -- models/free-market.can:83
local __pull_boxes -- models/free-market.can:88
local __open_box -- models/free-market.can:92
local __all_boxes -- models/free-market.can:100
local __active_forces -- models/free-market.can:106
local __storages -- models/free-market.can:111
local __storages_limit -- models/free-market.can:116
local __default_storage_limit -- models/free-market.can:121
local __item_HUD -- models/free-market.can:131
local tremove = table["remove"] -- models/free-market.can:137
local find = string["find"] -- models/free-market.can:138
local sub = string["sub"] -- models/free-market.can:139
local call = remote["call"] -- models/free-market.can:140
local floor = math["floor"] -- models/free-market.can:141
local ceil = math["ceil"] -- models/free-market.can:142
local draw_sprite = rendering["draw_sprite"] -- models/free-market.can:143
local get_rendered_by_id = rendering["get_object_by_id"] -- models/free-market.can:144
local print_to_rcon = rcon["print"] -- models/free-market.can:145
local CHECK_FORCES_TICK = 60 * 60 * 1.5 -- models/free-market.can:165
local CHECK_TEAMS_DATA_TICK = 60 * 60 * 25 -- models/free-market.can:166
local EMPTY_TABLE = {} -- models/free-market.can:167
local WHITE_COLOR = { -- models/free-market.can:168
	1, -- models/free-market.can:168
	1, -- models/free-market.can:168
	1 -- models/free-market.can:168
} -- models/free-market.can:168
local BOX_TYPE_SPRITE_OFFSET = { -- models/free-market.can:169
	0, -- models/free-market.can:169
	0.2 -- models/free-market.can:169
} -- models/free-market.can:169
local HINT_SPRITE_OFFSET = { -- models/free-market.can:170
	0, -- models/free-market.can:170
	- 0.25 -- models/free-market.can:170
} -- models/free-market.can:170
local COLON = { "colon" } -- models/free-market.can:171
local LABEL = { ["type"] = "label" } -- models/free-market.can:172
local FLOW = { ["type"] = "flow" } -- models/free-market.can:173
local VERTICAL_FLOW = { -- models/free-market.can:174
	["type"] = "flow", -- models/free-market.can:174
	["direction"] = "vertical" -- models/free-market.can:174
} -- models/free-market.can:174
local SPRITE_BUTTON = { ["type"] = "sprite-button" } -- models/free-market.can:175
local SLOT_BUTTON = { -- models/free-market.can:176
	["type"] = "sprite-button", -- models/free-market.can:176
	["style"] = "slot_button" -- models/free-market.can:176
} -- models/free-market.can:176
local EMPTY_WIDGET = { ["type"] = "empty-widget" } -- models/free-market.can:177
local PRICE_LABEL = { -- models/free-market.can:178
	["type"] = "label", -- models/free-market.can:178
	["style"] = "FM_price_label" -- models/free-market.can:178
} -- models/free-market.can:178
local POST_PRICE_LABEL = { -- models/free-market.can:179
	["type"] = "label", -- models/free-market.can:179
	["style"] = "FM_price_label", -- models/free-market.can:179
	["caption"] = "$" -- models/free-market.can:179
} -- models/free-market.can:179
local PRICE_FRAME = { -- models/free-market.can:180
	["type"] = "frame", -- models/free-market.can:180
	["style"] = "FM_price_frame" -- models/free-market.can:180
} -- models/free-market.can:180
local SELL_PRICE_BUTTON = { -- models/free-market.can:181
	["type"] = "sprite-button", -- models/free-market.can:181
	["style"] = "slot_button", -- models/free-market.can:181
	["name"] = "FM_open_sell_price" -- models/free-market.can:181
} -- models/free-market.can:181
local BUY_PRICE_BUTTON = { -- models/free-market.can:182
	["type"] = "sprite-button", -- models/free-market.can:182
	["style"] = "slot_button", -- models/free-market.can:182
	["name"] = "FM_open_buy_price" -- models/free-market.can:182
} -- models/free-market.can:182
local ALLOWED_CHEST_TYPES = { -- models/free-market.can:183
	["container"] = true, -- models/free-market.can:183
	["logistic-container"] = true -- models/free-market.can:183
} -- models/free-market.can:183
local TITLEBAR_FLOW = { -- models/free-market.can:184
	["type"] = "flow", -- models/free-market.can:184
	["style"] = "flib_titlebar_flow", -- models/free-market.can:184
	["name"] = "titlebar" -- models/free-market.can:184
} -- models/free-market.can:184
local DRAG_HANDLER = { -- models/free-market.can:185
	["type"] = "empty-widget", -- models/free-market.can:185
	["style"] = "flib_dialog_footer_drag_handle", -- models/free-market.can:185
	["name"] = "drag_handler" -- models/free-market.can:185
} -- models/free-market.can:185
local STORAGE_LIMIT_TEXTFIELD = { -- models/free-market.can:186
	["type"] = "textfield", -- models/free-market.can:186
	["name"] = "storage_limit", -- models/free-market.can:186
	["style"] = "FM_price_textfield", -- models/free-market.can:186
	["numeric"] = true, -- models/free-market.can:186
	["allow_decimal"] = false, -- models/free-market.can:186
	["allow_negative"] = false -- models/free-market.can:186
} -- models/free-market.can:186
local DEFAULT_LIMIT_TEXTFIELD = { -- models/free-market.can:187
	["type"] = "textfield", -- models/free-market.can:187
	["name"] = "FM_default_limit", -- models/free-market.can:187
	["style"] = "FM_price_textfield", -- models/free-market.can:187
	["numeric"] = true, -- models/free-market.can:187
	["allow_decimal"] = false, -- models/free-market.can:187
	["allow_negative"] = false -- models/free-market.can:187
} -- models/free-market.can:187
local SELL_PRICE_TEXTFIELD = { -- models/free-market.can:188
	["type"] = "textfield", -- models/free-market.can:188
	["name"] = "sell_price", -- models/free-market.can:188
	["style"] = "FM_price_textfield", -- models/free-market.can:188
	["numeric"] = true, -- models/free-market.can:188
	["allow_decimal"] = false, -- models/free-market.can:188
	["allow_negative"] = false -- models/free-market.can:188
} -- models/free-market.can:188
local BUY_PRICE_TEXTFIELD = { -- models/free-market.can:189
	["type"] = "textfield", -- models/free-market.can:189
	["name"] = "buy_price", -- models/free-market.can:189
	["style"] = "FM_price_textfield", -- models/free-market.can:189
	["numeric"] = true, -- models/free-market.can:189
	["allow_decimal"] = false, -- models/free-market.can:189
	["allow_negative"] = false -- models/free-market.can:189
} -- models/free-market.can:189
local SCROLL_PANE = { -- models/free-market.can:190
	["type"] = "scroll-pane", -- models/free-market.can:191
	["name"] = "scroll-pane", -- models/free-market.can:192
	["horizontal_scroll_policy"] = "never" -- models/free-market.can:193
} -- models/free-market.can:193
local CLOSE_BUTTON = { -- models/free-market.can:195
	["hovered_sprite"] = "utility/close_black", -- models/free-market.can:196
	["clicked_sprite"] = "utility/close_black", -- models/free-market.can:197
	["sprite"] = "utility/close_white", -- models/free-market.can:198
	["style"] = "frame_action_button", -- models/free-market.can:199
	["type"] = "sprite-button", -- models/free-market.can:200
	["name"] = "FM_close" -- models/free-market.can:201
} -- models/free-market.can:201
local ITEM_FILTERS = { -- models/free-market.can:203
	{ -- models/free-market.can:204
		["filter"] = "type", -- models/free-market.can:204
		["type"] = "blueprint-book", -- models/free-market.can:204
		["invert"] = true, -- models/free-market.can:204
		["mode"] = "and" -- models/free-market.can:204
	}, -- models/free-market.can:204
	{ -- models/free-market.can:205
		["filter"] = "selection-tool", -- models/free-market.can:205
		["invert"] = true, -- models/free-market.can:205
		["mode"] = "and" -- models/free-market.can:205
	} -- models/free-market.can:205
} -- models/free-market.can:205
local FM_ITEM_ELEMENT = { -- models/free-market.can:207
	["type"] = "choose-elem-button", -- models/free-market.can:207
	["name"] = "FM_item", -- models/free-market.can:207
	["elem_type"] = "item", -- models/free-market.can:207
	["elem_filters"] = ITEM_FILTERS -- models/free-market.can:207
} -- models/free-market.can:207
local CHECK_BUTTON = { -- models/free-market.can:208
	["type"] = "sprite-button", -- models/free-market.can:209
	["style"] = "item_and_count_select_confirm", -- models/free-market.can:210
	["sprite"] = "utility/check_mark" -- models/free-market.can:211
} -- models/free-market.can:211
local update_buy_tick = settings["global"]["FM_update-tick"]["value"] -- models/free-market.can:218
local update_transfer_tick = settings["global"]["FM_update-transfer-tick"]["value"] -- models/free-market.can:221
local update_pull_tick = settings["global"]["FM_update-pull-tick"]["value"] -- models/free-market.can:224
local is_auto_embargo = settings["global"]["FM_enable-auto-embargo"]["value"] -- models/free-market.can:227
local money_treshold = settings["global"]["FM_money-treshold"]["value"] -- models/free-market.can:230
local minimal_price = settings["global"]["FM_minimal-price"]["value"] -- models/free-market.can:233
local maximal_price = settings["global"]["FM_maximal-price"]["value"] -- models/free-market.can:236
local skip_offline_team_chance = settings["global"]["FM_skip_offline_team_chance"]["value"] -- models/free-market.can:239
local max_storage_threshold = settings["global"]["FM_max_storage_threshold"]["value"] -- models/free-market.can:242
local pull_cost_per_item = settings["global"]["FM_pull_cost_per_item"]["value"] -- models/free-market.can:245
local is_public_titles = settings["global"]["FM_is-public-titles"]["value"] -- models/free-market.can:248
local is_reset_public = settings["global"]["FM_is_reset_public"]["value"] -- models/free-market.can:251
local stack = { -- models/free-market.can:256
	["name"] = "", -- models/free-market.can:256
	["count"] = 0 -- models/free-market.can:256
} -- models/free-market.can:256
clear_invalid_data = nil -- models/free-market.can:261
print_force_data = function(target, getter) -- models/free-market.can:265
	if getter then -- models/free-market.can:266
		if not getter["valid"] then -- models/free-market.can:267
			log("Invalid object") -- models/free-market.can:268
			return  -- models/free-market.can:269
		end -- models/free-market.can:269
	else -- models/free-market.can:269
		getter = game -- models/free-market.can:272
	end -- models/free-market.can:272
	local index -- models/free-market.can:275
	local object_name = target["object_name"] -- models/free-market.can:276
	if object_name == "LuaPlayer" then -- models/free-market.can:277
		index = target["force_index"] -- models/free-market.can:278
	elseif object_name == "LuaForce" then -- models/free-market.can:279
		index = target["index"] -- models/free-market.can:280
	else -- models/free-market.can:280
		log("Invalid type") -- models/free-market.can:282
		return  -- models/free-market.can:283
	end -- models/free-market.can:283
	local print_to_target = getter["print"] -- models/free-market.can:286
	print_to_target("") -- models/free-market.can:287
	print_to_target("Inactive sell prices:" .. serpent["line"](__inactive_sell_prices[index])) -- models/free-market.can:288
	print_to_target("Inactive buy prices:" .. serpent["line"](__inactive_buy_prices[index])) -- models/free-market.can:289
	print_to_target("Sell prices:" .. serpent["line"](__sell_prices[index])) -- models/free-market.can:290
	print_to_target("Buy prices:" .. serpent["line"](__buy_prices[index])) -- models/free-market.can:291
	print_to_target("Universal transferers:" .. serpent["line"](__universal_transfer_boxes[index])) -- models/free-market.can:292
	print_to_target("Transferers:" .. serpent["line"](__transfer_boxes[index])) -- models/free-market.can:293
	print_to_target("Bin boxes:" .. serpent["line"](__bin_boxes[index])) -- models/free-market.can:294
	print_to_target("Universal bin boxes:" .. serpent["line"](__universal_bin_boxes[index])) -- models/free-market.can:295
	print_to_target("Pull boxes:" .. serpent["line"](__pull_boxes[index])) -- models/free-market.can:296
	print_to_target("Buy boxes:" .. serpent["line"](__buy_boxes[index])) -- models/free-market.can:297
	print_to_target("Embargoes:" .. serpent["line"](__embargoes[index])) -- models/free-market.can:298
	print_to_target("Storage:" .. serpent["line"](__storages[index])) -- models/free-market.can:299
end -- models/free-market.can:299
resetBuyBoxes = function(force_index) -- models/free-market.can:304
	local f_buy_boxes = __buy_boxes[force_index] -- models/free-market.can:305
	if f_buy_boxes == nil then -- models/free-market.can:306
		return  -- models/free-market.can:306
	end -- models/free-market.can:306
	for _, forces_data in pairs(f_buy_boxes) do -- models/free-market.can:308
		for _, entities_data in pairs(forces_data) do -- models/free-market.can:309
			local unit_number = entities_data[1]["unit_number"] -- models/free-market.can:310
			local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:311
			rendered["destroy"]() -- models/free-market.can:312
			__all_boxes[unit_number] = nil -- models/free-market.can:313
		end -- models/free-market.can:313
	end -- models/free-market.can:313
	__buy_boxes[force_index] = {} -- models/free-market.can:316
	local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:318
	if f_buy_prices == nil then -- models/free-market.can:319
		return  -- models/free-market.can:319
	end -- models/free-market.can:319
	local f_inactive_buy_prices = __inactive_buy_prices[force_index] -- models/free-market.can:320
	if f_inactive_buy_prices == nil then -- models/free-market.can:321
		return  -- models/free-market.can:321
	end -- models/free-market.can:321
	for item_name, price in pairs(f_buy_prices) do -- models/free-market.can:322
		f_inactive_buy_prices[item_name] = price -- models/free-market.can:323
	end -- models/free-market.can:323
	__buy_prices[force_index] = {} -- models/free-market.can:325
end -- models/free-market.can:325
resetTransferBoxes = function(force_index) -- models/free-market.can:330
	local f_transfer_boxes = __transfer_boxes[force_index] -- models/free-market.can:331
	if f_transfer_boxes == nil then -- models/free-market.can:332
		return  -- models/free-market.can:332
	end -- models/free-market.can:332
	for _, entities_data in pairs(f_transfer_boxes) do -- models/free-market.can:334
		for i = 1, # entities_data do -- models/free-market.can:335
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:336
			local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:337
			rendered["destroy"]() -- models/free-market.can:338
			__all_boxes[unit_number] = nil -- models/free-market.can:339
		end -- models/free-market.can:339
	end -- models/free-market.can:339
	__transfer_boxes[force_index] = {} -- models/free-market.can:342
	local f_inactive_sell_prices = __inactive_sell_prices[force_index] -- models/free-market.can:344
	if f_inactive_sell_prices == nil then -- models/free-market.can:345
		return  -- models/free-market.can:345
	end -- models/free-market.can:345
	local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:346
	if f_sell_prices == nil then -- models/free-market.can:347
		return  -- models/free-market.can:347
	end -- models/free-market.can:347
	local storage = __storages[force_index] -- models/free-market.can:348
	if storage == nil then -- models/free-market.can:349
		return  -- models/free-market.can:349
	end -- models/free-market.can:349
	for item_name, price in pairs(f_sell_prices) do -- models/free-market.can:351
		local count = storage[item_name] -- models/free-market.can:352
		if count == nil or count <= 0 then -- models/free-market.can:353
			f_inactive_sell_prices[item_name] = price -- models/free-market.can:354
			f_sell_prices[item_name] = nil -- models/free-market.can:355
		end -- models/free-market.can:355
	end -- models/free-market.can:355
end -- models/free-market.can:355
resetUniversalTransferBoxes = function(force_index) -- models/free-market.can:362
	local entities = __universal_transfer_boxes[force_index] -- models/free-market.can:363
	if entities == nil then -- models/free-market.can:364
		return  -- models/free-market.can:364
	end -- models/free-market.can:364
	for i = 1, # entities do -- models/free-market.can:366
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:367
		local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:368
		rendered["destroy"]() -- models/free-market.can:369
		__all_boxes[unit_number] = nil -- models/free-market.can:370
	end -- models/free-market.can:370
	__universal_transfer_boxes[force_index] = {} -- models/free-market.can:372
end -- models/free-market.can:372
resetBinBoxes = function(force_index) -- models/free-market.can:377
	local f_bin_boxes = __bin_boxes[force_index] -- models/free-market.can:378
	if f_bin_boxes == nil then -- models/free-market.can:379
		return  -- models/free-market.can:379
	end -- models/free-market.can:379
	for _, entities_data in pairs(f_bin_boxes) do -- models/free-market.can:381
		for i = 1, # entities_data do -- models/free-market.can:382
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:383
			local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:384
			rendered["destroy"]() -- models/free-market.can:385
			__all_boxes[unit_number] = nil -- models/free-market.can:386
		end -- models/free-market.can:386
	end -- models/free-market.can:386
	__bin_boxes[force_index] = {} -- models/free-market.can:389
end -- models/free-market.can:389
resetUniversalBinBoxes = function(force_index) -- models/free-market.can:394
	local entities = __universal_bin_boxes[force_index] -- models/free-market.can:395
	if entities == nil then -- models/free-market.can:396
		return  -- models/free-market.can:396
	end -- models/free-market.can:396
	for i = 1, # entities do -- models/free-market.can:398
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:399
		local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:400
		rendered["destroy"]() -- models/free-market.can:401
		__all_boxes[unit_number] = nil -- models/free-market.can:402
	end -- models/free-market.can:402
	__universal_bin_boxes[force_index] = {} -- models/free-market.can:404
end -- models/free-market.can:404
resetPullBoxes = function(force_index) -- models/free-market.can:409
	local f_pull_boxes = __pull_boxes[force_index] -- models/free-market.can:410
	if f_pull_boxes == nil then -- models/free-market.can:411
		return  -- models/free-market.can:411
	end -- models/free-market.can:411
	for _, entities_data in pairs(f_pull_boxes) do -- models/free-market.can:413
		for i = 1, # entities_data do -- models/free-market.can:414
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:415
			local rendered = get_rendered_by_id(__all_boxes[unit_number][2]) -- models/free-market.can:416
			rendered["destroy"]() -- models/free-market.can:417
			__all_boxes[unit_number] = nil -- models/free-market.can:418
		end -- models/free-market.can:418
	end -- models/free-market.can:418
	__pull_boxes[force_index] = {} -- models/free-market.can:421
end -- models/free-market.can:421
resetAllBoxes = function(force_index) -- models/free-market.can:426
	resetTransferBoxes(force_index) -- models/free-market.can:427
	resetUniversalTransferBoxes(force_index) -- models/free-market.can:428
	resetBinBoxes(force_index) -- models/free-market.can:429
	resetUniversalBinBoxes(force_index) -- models/free-market.can:430
	resetPullBoxes(force_index) -- models/free-market.can:431
	resetBuyBoxes(force_index) -- models/free-market.can:432
end -- models/free-market.can:432
check_local_and_global_data = function(local_data, global_data_name, receiver) -- models/free-market.can:440
	if (type(global_data_name) == "string" and local_data ~= storage["free_market"][global_data_name]) then -- models/free-market.can:441
		local message = string["format"]("!WARNING! Desync has been detected in __%s__ %s. Please report and send log files to %s and try to load your game again or use /sync", script["mod_name"], "mod_data[\"" .. global_data_name .. "\"]", "ZwerOxotnik") -- models/free-market.can:442
		log(message) -- models/free-market.can:443
		if game and (game["is_multiplayer"]() == false or receiver) then -- models/free-market.can:444
			message = { -- models/free-market.can:445
				"EasyAPI.report-desync", -- models/free-market.can:445
				script["mod_name"], -- models/free-market.can:446
				"mod_data[\"" .. global_data_name .. "\"]", -- models/free-market.can:446
				"ZwerOxotnik" -- models/free-market.can:446
			} -- models/free-market.can:446
			receiver = receiver or game -- models/free-market.can:448
			receiver["print"](message) -- models/free-market.can:449
		end -- models/free-market.can:449
		return true -- models/free-market.can:451
	end -- models/free-market.can:451
	return false -- models/free-market.can:453
end -- models/free-market.can:453
detect_desync = function(receiver) -- models/free-market.can:457
	check_local_and_global_data(__embargoes, "embargoes", receiver) -- models/free-market.can:458
	check_local_and_global_data(__sell_prices, "sell_prices", receiver) -- models/free-market.can:459
	check_local_and_global_data(__inactive_sell_prices, "inactive_sell_prices", receiver) -- models/free-market.can:460
	check_local_and_global_data(__buy_prices, "buy_prices", receiver) -- models/free-market.can:461
	check_local_and_global_data(__inactive_buy_prices, "inactive_buy_prices", receiver) -- models/free-market.can:462
	check_local_and_global_data(__transfer_boxes, "transfer_boxes", receiver) -- models/free-market.can:463
	check_local_and_global_data(__inactive_transfer_boxes, "inactive_transfer_boxes", receiver) -- models/free-market.can:464
	check_local_and_global_data(__bin_boxes, "bin_boxes", receiver) -- models/free-market.can:465
	check_local_and_global_data(__inactive_bin_boxes, "inactive_bin_boxes", receiver) -- models/free-market.can:466
	check_local_and_global_data(__universal_transfer_boxes, "universal_transfer_boxes", receiver) -- models/free-market.can:467
	check_local_and_global_data(__inactive_universal_transfer_boxes, "inactive_universal_transfer_boxes", receiver) -- models/free-market.can:468
	check_local_and_global_data(__universal_bin_boxes, "universal_bin_boxes", receiver) -- models/free-market.can:469
	check_local_and_global_data(__inactive_universal_bin_boxes, "universal_inactive_bin_boxes", receiver) -- models/free-market.can:470
	check_local_and_global_data(__buy_boxes, "buy_boxes", receiver) -- models/free-market.can:471
	check_local_and_global_data(__inactive_buy_boxes, "inactive_buy_boxes", receiver) -- models/free-market.can:472
	check_local_and_global_data(__pull_boxes, "pull_boxes", receiver) -- models/free-market.can:473
	check_local_and_global_data(__open_box, "open_box", receiver) -- models/free-market.can:474
	check_local_and_global_data(__all_boxes, "all_boxes", receiver) -- models/free-market.can:475
	check_local_and_global_data(__active_forces, "active_forces", receiver) -- models/free-market.can:476
	check_local_and_global_data(__storages, "storages", receiver) -- models/free-market.can:477
	check_local_and_global_data(__storages_limit, "storages_limit", receiver) -- models/free-market.can:478
	check_local_and_global_data(__default_storage_limit, "default_storage_limit", receiver) -- models/free-market.can:479
	check_local_and_global_data(__item_HUD, "item_hinter", receiver) -- models/free-market.can:480
end -- models/free-market.can:480
getRconData = function(name) -- models/free-market.can:489
	print_to_rcon(helpers["table_to_json"](__mod_data[name])) -- models/free-market.can:490
end -- models/free-market.can:490
getRconForceData = function(name, force) -- models/free-market.can:495
	if not force["valid"] then -- models/free-market.can:496
		return  -- models/free-market.can:496
	end -- models/free-market.can:496
	print_to_rcon(helpers["table_to_json"](__mod_data[name][force["index"]])) -- models/free-market.can:497
end -- models/free-market.can:497
getRconForceDataByIndex = function(name, force_index) -- models/free-market.can:502
	print_to_rcon(helpers["table_to_json"](__mod_data[name][force_index])) -- models/free-market.can:503
end -- models/free-market.can:503
local function clear_force_data(index) -- models/free-market.can:512
	__default_storage_limit[index] = nil -- models/free-market.can:513
	__inactive_sell_prices[index] = nil -- models/free-market.can:514
	__inactive_buy_prices[index] = nil -- models/free-market.can:515
	__bin_boxes[index] = nil -- models/free-market.can:516
	__inactive_bin_boxes[index] = nil -- models/free-market.can:517
	__universal_bin_boxes[index] = nil -- models/free-market.can:518
	__inactive_universal_bin_boxes[index] = nil -- models/free-market.can:519
	__inactive_universal_transfer_boxes[index] = nil -- models/free-market.can:520
	__inactive_transfer_boxes[index] = nil -- models/free-market.can:521
	__inactive_buy_boxes[index] = nil -- models/free-market.can:522
	__storages_limit[index] = nil -- models/free-market.can:523
	__sell_prices[index] = nil -- models/free-market.can:524
	__buy_prices[index] = nil -- models/free-market.can:525
	__pull_boxes[index] = nil -- models/free-market.can:526
	__universal_transfer_boxes[index] = nil -- models/free-market.can:527
	__transfer_boxes[index] = nil -- models/free-market.can:528
	__buy_boxes[index] = nil -- models/free-market.can:529
	__embargoes[index] = nil -- models/free-market.can:530
	__storages[index] = nil -- models/free-market.can:531
	for _, force_data in pairs(__embargoes) do -- models/free-market.can:533
		force_data[index] = nil -- models/free-market.can:534
	end -- models/free-market.can:534
	for i, force_index in pairs(__active_forces) do -- models/free-market.can:537
		if force_index == index then -- models/free-market.can:538
			tremove(__active_forces, i) -- models/free-market.can:539
			break -- models/free-market.can:540
		end -- models/free-market.can:540
	end -- models/free-market.can:540
end -- models/free-market.can:540
init_force_data = function(index) -- models/free-market.can:546
	__inactive_sell_prices[index] = __inactive_sell_prices[index] or {} -- models/free-market.can:547
	__inactive_buy_prices[index] = __inactive_buy_prices[index] or {} -- models/free-market.can:548
	__bin_boxes[index] = __bin_boxes[index] or {} -- models/free-market.can:549
	__inactive_bin_boxes[index] = __inactive_bin_boxes[index] or {} -- models/free-market.can:550
	__universal_bin_boxes[index] = __universal_bin_boxes[index] or {} -- models/free-market.can:551
	__inactive_universal_bin_boxes[index] = __inactive_universal_bin_boxes[index] or {} -- models/free-market.can:552
	__inactive_universal_transfer_boxes[index] = __inactive_universal_transfer_boxes[index] or {} -- models/free-market.can:553
	__inactive_transfer_boxes[index] = __inactive_transfer_boxes[index] or {} -- models/free-market.can:554
	__inactive_buy_boxes[index] = __inactive_buy_boxes[index] or {} -- models/free-market.can:555
	__sell_prices[index] = __sell_prices[index] or {} -- models/free-market.can:556
	__buy_prices[index] = __buy_prices[index] or {} -- models/free-market.can:557
	__pull_boxes[index] = __pull_boxes[index] or {} -- models/free-market.can:558
	__universal_transfer_boxes[index] = __universal_transfer_boxes[index] or {} -- models/free-market.can:559
	__transfer_boxes[index] = __transfer_boxes[index] or {} -- models/free-market.can:560
	__buy_boxes[index] = __buy_boxes[index] or {} -- models/free-market.can:561
	__embargoes[index] = __embargoes[index] or {} -- models/free-market.can:562
	__storages[index] = __storages[index] or {} -- models/free-market.can:563
	if __storages_limit[index] == nil then -- models/free-market.can:565
		__storages_limit[index] = {} -- models/free-market.can:566
		local f_storages_limit = __storages_limit[index] -- models/free-market.can:567
		for item_name, item in pairs(prototypes["item"]) do -- models/free-market.can:568
			if item["stack_size"] <= 5 then -- models/free-market.can:569
				f_storages_limit[item_name] = 1 -- models/free-market.can:570
			end -- models/free-market.can:570
		end -- models/free-market.can:570
	end -- models/free-market.can:570
end -- models/free-market.can:570
local function remove_certain_transfer_box(entity, box_data) -- models/free-market.can:578
	local force_index = entity["force_index"] -- models/free-market.can:579
	local f_transfer_boxes = __transfer_boxes[force_index] -- models/free-market.can:580
	local item_name = box_data[5] -- models/free-market.can:581
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:582
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:583
	if entities == nil then -- models/free-market.can:584
		return  -- models/free-market.can:584
	end -- models/free-market.can:584
	for i = # entities, 1, - 1 do -- models/free-market.can:585
		if entities[i] == entity then -- models/free-market.can:586
			tremove(entities, i) -- models/free-market.can:587
			if # entities == 0 then -- models/free-market.can:588
				f_transfer_boxes[item_name] = nil -- models/free-market.can:589
				local quantity_stored = __storages[force_index][item_name] -- models/free-market.can:590
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:591
					local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:592
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:593
					if sell_price then -- models/free-market.can:594
						local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:595
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:596
							__inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:597
							f_sell_prices[item_name] = nil -- models/free-market.can:598
						end -- models/free-market.can:598
					end -- models/free-market.can:598
				end -- models/free-market.can:598
			end -- models/free-market.can:598
			return  -- models/free-market.can:603
		end -- models/free-market.can:603
	end -- models/free-market.can:603
end -- models/free-market.can:603
local function remove_certain_bin_box(entity, box_data) -- models/free-market.can:610
	local force_index = entity["force_index"] -- models/free-market.can:611
	local f_bin_boxes = __bin_boxes[force_index] -- models/free-market.can:612
	local item_name = box_data[5] -- models/free-market.can:613
	local entities = f_bin_boxes[item_name] -- models/free-market.can:614
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:615
	if entities == nil then -- models/free-market.can:616
		return  -- models/free-market.can:616
	end -- models/free-market.can:616
	for i = # entities, 1, - 1 do -- models/free-market.can:617
		if entities[i] == entity then -- models/free-market.can:618
			tremove(entities, i) -- models/free-market.can:619
			if # entities == 0 then -- models/free-market.can:620
				f_bin_boxes[item_name] = nil -- models/free-market.can:621
				local quantity_stored = __storages[force_index][item_name] -- models/free-market.can:622
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:623
					local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:624
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:625
					if sell_price and __transfer_boxes[force_index][item_name] == nil then -- models/free-market.can:626
						local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:627
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:628
							__inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:629
							f_sell_prices[item_name] = nil -- models/free-market.can:630
						end -- models/free-market.can:630
					end -- models/free-market.can:630
				end -- models/free-market.can:630
			end -- models/free-market.can:630
			return  -- models/free-market.can:635
		end -- models/free-market.can:635
	end -- models/free-market.can:635
end -- models/free-market.can:635
local function remove_certain_universal_transfer_box(entity) -- models/free-market.can:641
	local force_index = entity["force_index"] -- models/free-market.can:642
	local entities = __universal_transfer_boxes[force_index] -- models/free-market.can:643
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:644
	if entities == nil then -- models/free-market.can:645
		return  -- models/free-market.can:645
	end -- models/free-market.can:645
	for i = # entities, 1, - 1 do -- models/free-market.can:646
		if entities[i] == entity then -- models/free-market.can:647
			tremove(entities, i) -- models/free-market.can:648
			return  -- models/free-market.can:649
		end -- models/free-market.can:649
	end -- models/free-market.can:649
end -- models/free-market.can:649
local function remove_certain_universal_bin_box(entity) -- models/free-market.can:655
	local force_index = entity["force_index"] -- models/free-market.can:656
	local entities = __universal_bin_boxes[force_index] -- models/free-market.can:657
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:658
	if entities == nil then -- models/free-market.can:659
		return  -- models/free-market.can:659
	end -- models/free-market.can:659
	for i = # entities, 1, - 1 do -- models/free-market.can:660
		if entities[i] == entity then -- models/free-market.can:661
			tremove(entities, i) -- models/free-market.can:662
			return  -- models/free-market.can:663
		end -- models/free-market.can:663
	end -- models/free-market.can:663
end -- models/free-market.can:663
local function remove_certain_buy_box(entity, box_data) -- models/free-market.can:670
	local force_index = entity["force_index"] -- models/free-market.can:671
	local f_buy_boxes = __buy_boxes[force_index] -- models/free-market.can:672
	local item_name = box_data[5] -- models/free-market.can:673
	local items_data = f_buy_boxes[item_name] -- models/free-market.can:674
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:675
	if items_data == nil then -- models/free-market.can:676
		return  -- models/free-market.can:676
	end -- models/free-market.can:676
	for i = # items_data, 1, - 1 do -- models/free-market.can:677
		local buy_box = items_data[i] -- models/free-market.can:678
		if buy_box[1] == entity then -- models/free-market.can:679
			tremove(items_data, i) -- models/free-market.can:680
			if # items_data == 0 then -- models/free-market.can:681
				f_buy_boxes[item_name] = nil -- models/free-market.can:682
				local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:683
				local buy_price = f_buy_prices[item_name] -- models/free-market.can:684
				if buy_price then -- models/free-market.can:685
					__inactive_buy_prices[force_index][item_name] = buy_price -- models/free-market.can:686
					f_buy_prices[item_name] = nil -- models/free-market.can:687
				end -- models/free-market.can:687
			end -- models/free-market.can:687
			return  -- models/free-market.can:690
		end -- models/free-market.can:690
	end -- models/free-market.can:690
end -- models/free-market.can:690
local function remove_certain_pull_box(entity, box_data) -- models/free-market.can:697
	local force_index = entity["force_index"] -- models/free-market.can:698
	local f_pull_boxes = __pull_boxes[force_index] -- models/free-market.can:699
	local item_name = box_data[5] -- models/free-market.can:700
	local entities = f_pull_boxes[item_name] -- models/free-market.can:701
	__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:702
	if entities == nil then -- models/free-market.can:703
		return  -- models/free-market.can:703
	end -- models/free-market.can:703
	for i = # entities, 1, - 1 do -- models/free-market.can:704
		if entities[i] == entity then -- models/free-market.can:705
			tremove(entities, i) -- models/free-market.can:706
			if # entities == 0 then -- models/free-market.can:707
				f_pull_boxes[item_name] = nil -- models/free-market.can:708
			end -- models/free-market.can:708
			return  -- models/free-market.can:710
		end -- models/free-market.can:710
	end -- models/free-market.can:710
end -- models/free-market.can:710
local function change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:719
	local data = __buy_boxes[entity["force_index"]][item_name] -- models/free-market.can:720
	for i = 1, # data do -- models/free-market.can:721
		local buy_box = data[i] -- models/free-market.can:722
		if buy_box[1] == entity then -- models/free-market.can:723
			buy_box[2] = count -- models/free-market.can:724
			return  -- models/free-market.can:725
		end -- models/free-market.can:725
	end -- models/free-market.can:725
end -- models/free-market.can:725
local function clear_invalid_embargoes() -- models/free-market.can:730
	local forces = game["forces"] -- models/free-market.can:731
	for index in pairs(__embargoes) do -- models/free-market.can:732
		if forces[index] == nil then -- models/free-market.can:733
			__embargoes[index] = nil -- models/free-market.can:734
		end -- models/free-market.can:734
	end -- models/free-market.can:734
	for _, forces_data in pairs(__embargoes) do -- models/free-market.can:737
		for index in pairs(forces_data) do -- models/free-market.can:738
			if forces[index] == nil then -- models/free-market.can:739
				forces_data[index] = nil -- models/free-market.can:740
			end -- models/free-market.can:740
		end -- models/free-market.can:740
	end -- models/free-market.can:740
end -- models/free-market.can:740
local function show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:749
	if # force["connected_players"] > 1 then -- models/free-market.can:750
		draw_sprite({ -- models/free-market.can:751
			["sprite"] = "item." .. item_name, -- models/free-market.can:752
			["target"] = entity, -- models/free-market.can:753
			["surface"] = entity["surface"], -- models/free-market.can:754
			["forces"] = { force }, -- models/free-market.can:755
			["time_to_live"] = 200, -- models/free-market.can:756
			["x_scale"] = 0.9, -- models/free-market.can:757
			["target_offset"] = HINT_SPRITE_OFFSET -- models/free-market.can:758
		}) -- models/free-market.can:758
	end -- models/free-market.can:758
end -- models/free-market.can:758
local function clear_invalid_prices(prices) -- models/free-market.can:763
	local item_prototypes = prototypes["item"] -- models/free-market.can:764
	local forces = game["forces"] -- models/free-market.can:765
	for index, forces_data in pairs(prices) do -- models/free-market.can:766
		if forces[index] == nil then -- models/free-market.can:767
			__sell_prices[index] = nil -- models/free-market.can:768
			__buy_prices[index] = nil -- models/free-market.can:769
			__inactive_sell_prices[index] = nil -- models/free-market.can:770
			__inactive_buy_prices[index] = nil -- models/free-market.can:771
		else -- models/free-market.can:771
			for item_name in pairs(forces_data) do -- models/free-market.can:773
				if item_prototypes[item_name] == nil then -- models/free-market.can:774
					forces_data[item_name] = nil -- models/free-market.can:775
				end -- models/free-market.can:775
			end -- models/free-market.can:775
		end -- models/free-market.can:775
	end -- models/free-market.can:775
end -- models/free-market.can:775
local function clear_invalid_storage_data() -- models/free-market.can:782
	local item_prototypes = prototypes["item"] -- models/free-market.can:783
	local forces = game["forces"] -- models/free-market.can:784
	for index, data in pairs(__pull_boxes) do -- models/free-market.can:785
		if forces[index] == nil then -- models/free-market.can:786
			clear_force_data(index) -- models/free-market.can:787
		else -- models/free-market.can:787
			for item_name, count in pairs(data) do -- models/free-market.can:789
				if item_prototypes[item_name] == nil or count == 0 then -- models/free-market.can:790
					data[item_name] = nil -- models/free-market.can:791
				end -- models/free-market.can:791
			end -- models/free-market.can:791
		end -- models/free-market.can:791
	end -- models/free-market.can:791
end -- models/free-market.can:791
local function clear_invalid_pull_boxes_data() -- models/free-market.can:798
	local item_prototypes = prototypes["item"] -- models/free-market.can:799
	local forces = game["forces"] -- models/free-market.can:800
	for index, data in pairs(__pull_boxes) do -- models/free-market.can:801
		if forces[index] == nil then -- models/free-market.can:802
			clear_force_data(index) -- models/free-market.can:803
		else -- models/free-market.can:803
			for item_name, entities in pairs(data) do -- models/free-market.can:805
				if item_prototypes[item_name] == nil then -- models/free-market.can:806
					data[item_name] = nil -- models/free-market.can:807
				else -- models/free-market.can:807
					for i = # entities, 1, - 1 do -- models/free-market.can:809
						local entity = entities[i] -- models/free-market.can:810
						if entity["valid"] == false then -- models/free-market.can:811
							tremove(entities, i) -- models/free-market.can:812
						else -- models/free-market.can:812
							local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:814
							if box_data == nil then -- models/free-market.can:815
								tremove(entities, i) -- models/free-market.can:816
							elseif entity ~= box_data[1] then -- models/free-market.can:817
								local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:818
								rendered["destroy"]() -- models/free-market.can:819
								__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:820
								tremove(entities, i) -- models/free-market.can:821
							end -- models/free-market.can:821
						end -- models/free-market.can:821
					end -- models/free-market.can:821
					if # entities == 0 then -- models/free-market.can:825
						data[item_name] = nil -- models/free-market.can:826
					end -- models/free-market.can:826
				end -- models/free-market.can:826
			end -- models/free-market.can:826
		end -- models/free-market.can:826
	end -- models/free-market.can:826
end -- models/free-market.can:826
local function clear_invalid_transfer_boxes_data(_data) -- models/free-market.can:835
	local item_prototypes = prototypes["item"] -- models/free-market.can:836
	local forces = game["forces"] -- models/free-market.can:837
	for index, data in pairs(_data) do -- models/free-market.can:838
		if forces[index] == nil then -- models/free-market.can:839
			clear_force_data(index) -- models/free-market.can:840
		else -- models/free-market.can:840
			for item_name, entities in pairs(data) do -- models/free-market.can:842
				if item_prototypes[item_name] == nil then -- models/free-market.can:843
					data[item_name] = nil -- models/free-market.can:844
				else -- models/free-market.can:844
					for i = # entities, 1, - 1 do -- models/free-market.can:846
						local entity = entities[i] -- models/free-market.can:847
						if entity["valid"] == false then -- models/free-market.can:848
							tremove(entities, i) -- models/free-market.can:849
						else -- models/free-market.can:849
							local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:851
							if box_data == nil then -- models/free-market.can:852
								tremove(entities, i) -- models/free-market.can:853
							elseif entity ~= box_data[1] then -- models/free-market.can:854
								local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:855
								rendered["destroy"]() -- models/free-market.can:856
								__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:857
								tremove(entities, i) -- models/free-market.can:858
							end -- models/free-market.can:858
						end -- models/free-market.can:858
					end -- models/free-market.can:858
					if # entities == 0 then -- models/free-market.can:862
						data[item_name] = nil -- models/free-market.can:863
					end -- models/free-market.can:863
				end -- models/free-market.can:863
			end -- models/free-market.can:863
		end -- models/free-market.can:863
	end -- models/free-market.can:863
end -- models/free-market.can:863
local function clear_invalid_buy_boxes_data(_data) -- models/free-market.can:872
	local item_prototypes = prototypes["item"] -- models/free-market.can:873
	local forces = game["forces"] -- models/free-market.can:874
	for index, data in pairs(_data) do -- models/free-market.can:875
		if forces[index] == nil then -- models/free-market.can:876
			clear_force_data(index) -- models/free-market.can:877
		else -- models/free-market.can:877
			for item_name, entities in pairs(data) do -- models/free-market.can:879
				if item_prototypes[item_name] == nil then -- models/free-market.can:880
					data[item_name] = nil -- models/free-market.can:881
				else -- models/free-market.can:881
					for i = # entities, 1, - 1 do -- models/free-market.can:883
						local box_data = entities[i] -- models/free-market.can:884
						local entity = box_data[1] -- models/free-market.can:885
						if entity["valid"] == false then -- models/free-market.can:886
							tremove(entities, i) -- models/free-market.can:887
						elseif not box_data[2] then -- models/free-market.can:888
							tremove(entities, i) -- models/free-market.can:889
							__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:890
						else -- models/free-market.can:890
							local _box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:892
							if _box_data == nil then -- models/free-market.can:893
								tremove(entities, i) -- models/free-market.can:894
							elseif entity ~= _box_data[1] then -- models/free-market.can:895
								local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:896
								rendered["destroy"]() -- models/free-market.can:897
								__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:898
								tremove(entities, i) -- models/free-market.can:899
							end -- models/free-market.can:899
						end -- models/free-market.can:899
					end -- models/free-market.can:899
					if # entities == 0 then -- models/free-market.can:903
						data[item_name] = nil -- models/free-market.can:904
					end -- models/free-market.can:904
				end -- models/free-market.can:904
			end -- models/free-market.can:904
		end -- models/free-market.can:904
	end -- models/free-market.can:904
end -- models/free-market.can:904
local function clear_invalid_simple_boxes(data) -- models/free-market.can:913
	for _, entities in pairs(data) do -- models/free-market.can:914
		for i = # entities, 1, - 1 do -- models/free-market.can:915
			local entity = entities[i] -- models/free-market.can:916
			if entity["valid"] == false then -- models/free-market.can:917
				tremove(entities, i) -- models/free-market.can:918
			else -- models/free-market.can:918
				local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:920
				if box_data == nil then -- models/free-market.can:921
					tremove(entities, i) -- models/free-market.can:922
				elseif entity ~= box_data[1] then -- models/free-market.can:923
					local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:924
					rendered["destroy"]() -- models/free-market.can:925
					__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:926
					tremove(entities, i) -- models/free-market.can:927
				end -- models/free-market.can:927
			end -- models/free-market.can:927
		end -- models/free-market.can:927
	end -- models/free-market.can:927
end -- models/free-market.can:927
local function delete_item_price_HUD(player) -- models/free-market.can:935
	local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:936
	if frame then -- models/free-market.can:937
		frame["destroy"]() -- models/free-market.can:938
		__item_HUD[player["index"]] = nil -- models/free-market.can:939
	end -- models/free-market.can:939
end -- models/free-market.can:939
local function clear_invalid_player_data() -- models/free-market.can:943
	for player_index in pairs(__item_HUD) do -- models/free-market.can:944
		local player = game["get_player"](player_index) -- models/free-market.can:945
		if not (player and player["valid"]) then -- models/free-market.can:946
			__item_HUD[player_index] = nil -- models/free-market.can:947
		elseif player["connected"] then -- models/free-market.can:948
			local player_item_HUD = __item_HUD[player_index] -- models/free-market.can:949
			if player_item_HUD and player_item_HUD[1]["valid"] == false then -- models/free-market.can:950
				log(string["format"]("[BUG][%s] item_HUD for \"%s\" refers to invalid data", script["mod_name"], player["name"])) -- models/free-market.can:951
				delete_item_price_HUD(player) -- models/free-market.can:952
			end -- models/free-market.can:952
		end -- models/free-market.can:952
	end -- models/free-market.can:952
	for _, player in pairs(game["players"]) do -- models/free-market.can:957
		if (player and player["valid"]) then -- models/free-market.can:958
			local player_index = player["index"] -- models/free-market.can:959
			if not player["connected"] then -- models/free-market.can:960
				delete_item_price_HUD(player) -- models/free-market.can:961
			elseif __item_HUD[player_index] == nil then -- models/free-market.can:962
				local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:963
				if frame and frame["valid"] then -- models/free-market.can:964
					log(string["format"]("[BUG][iFreeMarket] Player \"%s\" has FM_item_price_frame and online, item_HUD[player_index] is nil", player["name"])) -- models/free-market.can:965
					delete_item_price_HUD(player) -- models/free-market.can:966
					create_item_price_HUD(player) -- models/free-market.can:967
				end -- models/free-market.can:967
			end -- models/free-market.can:967
		end -- models/free-market.can:967
	end -- models/free-market.can:967
end -- models/free-market.can:967
local function clear_invalid_entities() -- models/free-market.can:974
	local item_prototypes = prototypes["item"] -- models/free-market.can:975
	for unit_number, data in pairs(__all_boxes) do -- models/free-market.can:976
		if not data[1]["valid"] then -- models/free-market.can:977
			__all_boxes[unit_number] = nil -- models/free-market.can:978
		else -- models/free-market.can:978
			local item_name = data[5] -- models/free-market.can:980
			if item_name and item_prototypes[item_name] == nil then -- models/free-market.can:981
				local rendered = get_rendered_by_id(data[2]) -- models/free-market.can:982
				rendered["destroy"]() -- models/free-market.can:983
				__all_boxes[unit_number] = nil -- models/free-market.can:984
			end -- models/free-market.can:984
		end -- models/free-market.can:984
	end -- models/free-market.can:984
	clear_invalid_storage_data() -- models/free-market.can:989
	clear_invalid_pull_boxes_data() -- models/free-market.can:990
	clear_invalid_transfer_boxes_data(__transfer_boxes) -- models/free-market.can:991
	clear_invalid_transfer_boxes_data(__inactive_transfer_boxes) -- models/free-market.can:992
	clear_invalid_transfer_boxes_data(__bin_boxes) -- models/free-market.can:993
	clear_invalid_transfer_boxes_data(__inactive_bin_boxes) -- models/free-market.can:994
	clear_invalid_buy_boxes_data(__buy_boxes) -- models/free-market.can:995
	clear_invalid_buy_boxes_data(__inactive_buy_boxes) -- models/free-market.can:996
	clear_invalid_simple_boxes(__universal_transfer_boxes) -- models/free-market.can:997
	clear_invalid_simple_boxes(__inactive_universal_transfer_boxes) -- models/free-market.can:998
	clear_invalid_simple_boxes(__universal_bin_boxes) -- models/free-market.can:999
	clear_invalid_simple_boxes(__inactive_universal_bin_boxes) -- models/free-market.can:1000
end -- models/free-market.can:1000
clear_invalid_data = function() -- models/free-market.can:1003
	clear_invalid_entities() -- models/free-market.can:1004
	clear_invalid_prices(__storages_limit) -- models/free-market.can:1005
	clear_invalid_prices(__inactive_sell_prices) -- models/free-market.can:1006
	clear_invalid_prices(__inactive_buy_prices) -- models/free-market.can:1007
	clear_invalid_prices(__sell_prices) -- models/free-market.can:1008
	clear_invalid_prices(__buy_prices) -- models/free-market.can:1009
	clear_invalid_embargoes() -- models/free-market.can:1010
	clear_invalid_player_data() -- models/free-market.can:1011
end -- models/free-market.can:1011
local function get_distance(start, stop) -- models/free-market.can:1015
	local xdiff = start["x"] - stop["x"] -- models/free-market.can:1016
	local ydiff = start["y"] - stop["y"] -- models/free-market.can:1017
	return (xdiff * xdiff + ydiff * ydiff) ^ 0.5 -- models/free-market.can:1018
end -- models/free-market.can:1018
local function delete_player_data(event) -- models/free-market.can:1021
	local player_index = event["player_index"] -- models/free-market.can:1022
	__open_box[player_index] = nil -- models/free-market.can:1023
	__item_HUD[player_index] = nil -- models/free-market.can:1024
end -- models/free-market.can:1024
local function make_prices_header(table) -- models/free-market.can:1027
	local dummy -- models/free-market.can:1028
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:1029
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1030
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1031
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:1032
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1033
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1034
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:1035
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1036
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1037
	table["add"](LABEL)["caption"] = { "team-name" } -- models/free-market.can:1039
	table["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:1040
	table["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:1041
end -- models/free-market.can:1041
local function make_storage_header(table) -- models/free-market.can:1044
	local dummy -- models/free-market.can:1045
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:1046
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1047
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1048
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:1049
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1050
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1051
	table["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:1053
	table["add"](LABEL)["caption"] = { "gui-logistic.count" } -- models/free-market.can:1054
end -- models/free-market.can:1054
local function make_price_list_header(table_element) -- models/free-market.can:1058
	local dummy -- models/free-market.can:1059
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:1060
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1061
	dummy["style"]["minimal_width"] = 30 -- models/free-market.can:1062
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:1063
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1064
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1065
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:1066
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:1067
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:1068
	table_element["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:1070
	table_element["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:1071
	table_element["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:1072
end -- models/free-market.can:1072
local function update_prices_table(player, item_name, table_element) -- models/free-market.can:1078
	table_element["clear"]() -- models/free-market.can:1079
	make_prices_header(table_element) -- models/free-market.can:1080
	local force = player["force"] -- models/free-market.can:1081
	local result = {} -- models/free-market.can:1082
	for name, _force in pairs(game["forces"]) do -- models/free-market.can:1083
		if force ~= _force then -- models/free-market.can:1084
			result[_force["index"]] = { ["name"] = name } -- models/free-market.can:1085
		end -- models/free-market.can:1085
	end -- models/free-market.can:1085
	for index, force_items in pairs(__buy_prices) do -- models/free-market.can:1088
		local data = result[index] -- models/free-market.can:1089
		if data then -- models/free-market.can:1090
			local buy_value = force_items[item_name] -- models/free-market.can:1091
			if buy_value then -- models/free-market.can:1092
				data["buy_price"] = tostring(buy_value) -- models/free-market.can:1093
			end -- models/free-market.can:1093
		end -- models/free-market.can:1093
	end -- models/free-market.can:1093
	for index, force_items in pairs(__sell_prices) do -- models/free-market.can:1097
		local data = result[index] -- models/free-market.can:1098
		if data then -- models/free-market.can:1099
			local sell_price = force_items[item_name] -- models/free-market.can:1100
			if sell_price then -- models/free-market.can:1101
				data["sell_price"] = tostring(sell_price) -- models/free-market.can:1102
			end -- models/free-market.can:1102
		end -- models/free-market.can:1102
	end -- models/free-market.can:1102
	local add = table_element["add"] -- models/free-market.can:1107
	for _, data in pairs(result) do -- models/free-market.can:1108
		if data["buy_price"] or data["sell_price"] then -- models/free-market.can:1109
			add(LABEL)["caption"] = data["name"] -- models/free-market.can:1110
			add(LABEL)["caption"] = (data["buy_price"] or "") -- models/free-market.can:1111
			add(LABEL)["caption"] = (data["sell_price"] or "") -- models/free-market.can:1112
		end -- models/free-market.can:1112
	end -- models/free-market.can:1112
end -- models/free-market.can:1112
local function update_price_list_table(force, scroll_pane) -- models/free-market.can:1119
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1120
	short_price_list_table["clear"]() -- models/free-market.can:1121
	short_price_list_table["visible"] = false -- models/free-market.can:1122
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1123
	price_list_table["clear"]() -- models/free-market.can:1124
	price_list_table["visible"] = true -- models/free-market.can:1125
	make_price_list_header(price_list_table) -- models/free-market.can:1126
	local force_index = force["index"] -- models/free-market.can:1128
	local f_buy_prices = __buy_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1129
	local f_sell_prices = __sell_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1130
	local add = price_list_table["add"] -- models/free-market.can:1132
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1133
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1134
		add(LABEL)["caption"] = buy_price -- models/free-market.can:1135
		add(LABEL)["caption"] = (f_sell_prices[item_name] or "") -- models/free-market.can:1136
	end -- models/free-market.can:1136
	for item_name, sell_price in pairs(f_sell_prices) do -- models/free-market.can:1139
		if f_buy_prices[item_name] == nil then -- models/free-market.can:1140
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1141
			add(EMPTY_WIDGET) -- models/free-market.can:1142
			add(LABEL)["caption"] = sell_price -- models/free-market.can:1143
		end -- models/free-market.can:1143
	end -- models/free-market.can:1143
end -- models/free-market.can:1143
local function update_price_list_by_sell_filter(force, scroll_pane, text_filter) -- models/free-market.can:1151
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1152
	short_price_list_table["clear"]() -- models/free-market.can:1153
	short_price_list_table["visible"] = true -- models/free-market.can:1154
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1155
	price_list_table["clear"]() -- models/free-market.can:1156
	price_list_table["visible"] = false -- models/free-market.can:1157
	make_price_list_header(short_price_list_table) -- models/free-market.can:1159
	short_price_list_table["children"][5]["destroy"]() -- models/free-market.can:1160
	short_price_list_table["children"][2]["destroy"]() -- models/free-market.can:1161
	local f_sell_prices = __sell_prices[force["index"]] -- models/free-market.can:1163
	if f_sell_prices == nil then -- models/free-market.can:1164
		return  -- models/free-market.can:1164
	end -- models/free-market.can:1164
	local add = short_price_list_table["add"] -- models/free-market.can:1166
	for item_name, buy_price in pairs(f_sell_prices) do -- models/free-market.can:1167
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1168
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1169
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1170
		end -- models/free-market.can:1170
	end -- models/free-market.can:1170
end -- models/free-market.can:1170
local function update_price_list_by_buy_filter(force, scroll_pane, text_filter) -- models/free-market.can:1178
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1179
	short_price_list_table["clear"]() -- models/free-market.can:1180
	short_price_list_table["visible"] = true -- models/free-market.can:1181
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1182
	price_list_table["clear"]() -- models/free-market.can:1183
	price_list_table["visible"] = false -- models/free-market.can:1184
	make_price_list_header(short_price_list_table) -- models/free-market.can:1186
	short_price_list_table["children"][6]["destroy"]() -- models/free-market.can:1187
	short_price_list_table["children"][3]["destroy"]() -- models/free-market.can:1188
	local f_buy_prices = __buy_prices[force["index"]] -- models/free-market.can:1190
	if f_buy_prices == nil then -- models/free-market.can:1191
		return  -- models/free-market.can:1191
	end -- models/free-market.can:1191
	local add = short_price_list_table["add"] -- models/free-market.can:1193
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1194
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1195
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1196
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1197
		end -- models/free-market.can:1197
	end -- models/free-market.can:1197
end -- models/free-market.can:1197
local function destroy_prices_gui(player) -- models/free-market.can:1203
	local screen = player["gui"]["screen"] -- models/free-market.can:1204
	if screen["FM_prices_frame"] then -- models/free-market.can:1205
		screen["FM_prices_frame"]["destroy"]() -- models/free-market.can:1206
	end -- models/free-market.can:1206
end -- models/free-market.can:1206
local function destroy_price_list_gui(player) -- models/free-market.can:1211
	local screen = player["gui"]["screen"] -- models/free-market.can:1212
	if screen["FM_price_list_frame"] then -- models/free-market.can:1213
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1214
	end -- models/free-market.can:1214
end -- models/free-market.can:1214
local function update_embargo_table(embargo_table, player) -- models/free-market.can:1220
	embargo_table["clear"]() -- models/free-market.can:1221
	embargo_table["add"](LABEL)["caption"] = { "free-market.without-embargo-title" } -- models/free-market.can:1223
	embargo_table["add"](EMPTY_WIDGET) -- models/free-market.can:1224
	embargo_table["add"](LABEL)["caption"] = { "free-market.with-embargo-title" } -- models/free-market.can:1225
	local force_index = player["force_index"] -- models/free-market.can:1227
	local in_embargo_list = {} -- models/free-market.can:1228
	local no_embargo_list = {} -- models/free-market.can:1229
	local f_embargoes = __embargoes[force_index] -- models/free-market.can:1230
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1231
		if # force["players"] > 0 and force["index"] ~= force_index then -- models/free-market.can:1232
			if f_embargoes[force["index"]] then -- models/free-market.can:1233
				in_embargo_list[# in_embargo_list + 1] = force_name -- models/free-market.can:1234
			else -- models/free-market.can:1234
				no_embargo_list[# no_embargo_list + 1] = force_name -- models/free-market.can:1236
			end -- models/free-market.can:1236
		end -- models/free-market.can:1236
	end -- models/free-market.can:1236
	local forces_list = embargo_table["add"]({ -- models/free-market.can:1241
		["type"] = "list-box", -- models/free-market.can:1241
		["name"] = "forces_list", -- models/free-market.can:1241
		["items"] = no_embargo_list -- models/free-market.can:1241
	}) -- models/free-market.can:1241
	forces_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1242
	forces_list["style"]["height"] = 200 -- models/free-market.can:1243
	local buttons_flow = embargo_table["add"](VERTICAL_FLOW) -- models/free-market.can:1244
	buttons_flow["add"]({ -- models/free-market.can:1245
		["type"] = "sprite-button", -- models/free-market.can:1245
		["name"] = "FM_cancel_embargo", -- models/free-market.can:1245
		["style"] = "tool_button", -- models/free-market.can:1245
		["sprite"] = "utility/left_arrow" -- models/free-market.can:1245
	}) -- models/free-market.can:1245
	buttons_flow["add"]({ -- models/free-market.can:1246
		["type"] = "sprite-button", -- models/free-market.can:1246
		["name"] = "FM_declare_embargo", -- models/free-market.can:1246
		["style"] = "tool_button", -- models/free-market.can:1246
		["sprite"] = "utility/right_arrow" -- models/free-market.can:1246
	}) -- models/free-market.can:1246
	local embargo_list = embargo_table["add"]({ -- models/free-market.can:1247
		["type"] = "list-box", -- models/free-market.can:1247
		["name"] = "embargo_list", -- models/free-market.can:1247
		["items"] = in_embargo_list -- models/free-market.can:1247
	}) -- models/free-market.can:1247
	embargo_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1248
	embargo_list["style"]["height"] = 200 -- models/free-market.can:1249
end -- models/free-market.can:1249
local function add_item_in_sell_prices(player, item_name, price, force_index) -- models/free-market.can:1255
	local prices_table = player["gui"]["screen"]["FM_sell_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1256
	local add = prices_table["add"] -- models/free-market.can:1257
	local button = add(FLOW)["add"](SELL_PRICE_BUTTON) -- models/free-market.can:1258
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1259
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1260
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1261
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1263
	add(POST_PRICE_LABEL) -- models/free-market.can:1264
	local children = prices_table["children"] -- models/free-market.can:1266
	if # children / 2 > player["mod_settings"]["FM_sell_notification_size"]["value"] then -- models/free-market.can:1267
		children[2]["destroy"]() -- models/free-market.can:1268
		children[1]["destroy"]() -- models/free-market.can:1269
	end -- models/free-market.can:1269
end -- models/free-market.can:1269
local function add_item_in_buy_prices(player, item_name, price, force_index) -- models/free-market.can:1276
	local prices_table = player["gui"]["screen"]["FM_buy_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1277
	local add = prices_table["add"] -- models/free-market.can:1278
	local button = add(FLOW)["add"](BUY_PRICE_BUTTON) -- models/free-market.can:1279
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1280
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1281
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1282
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1284
	add(POST_PRICE_LABEL) -- models/free-market.can:1285
	local children = prices_table["children"] -- models/free-market.can:1287
	if # children / 2 > player["mod_settings"]["FM_buy_notification_size"]["value"] then -- models/free-market.can:1288
		children[2]["destroy"]() -- models/free-market.can:1289
		children[1]["destroy"]() -- models/free-market.can:1290
	end -- models/free-market.can:1290
end -- models/free-market.can:1290
local function notify_sell_price(source_index, item_name, sell_price) -- models/free-market.can:1297
	local forces = game["forces"] -- models/free-market.can:1298
	local f_embargoes = __embargoes[source_index] -- models/free-market.can:1299
	for _, force_index in pairs(__active_forces) do -- models/free-market.can:1300
		if force_index ~= source_index and not f_embargoes[f_embargoes] then -- models/free-market.can:1301
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1302
				pcall(add_item_in_sell_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1303
			end -- models/free-market.can:1303
		end -- models/free-market.can:1303
	end -- models/free-market.can:1303
end -- models/free-market.can:1303
local function notify_buy_price(source_index, item_name, sell_price) -- models/free-market.can:1312
	local forces = game["forces"] -- models/free-market.can:1313
	for _, force_index in pairs(__active_forces) do -- models/free-market.can:1314
		if force_index ~= source_index and not __embargoes[force_index][source_index] then -- models/free-market.can:1315
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1316
				pcall(add_item_in_buy_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1317
			end -- models/free-market.can:1317
		end -- models/free-market.can:1317
	end -- models/free-market.can:1317
end -- models/free-market.can:1317
local function change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:1327
	local force_index = player["force_index"] -- models/free-market.can:1328
	local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:1329
	local f_inactive_sell_prices = __inactive_sell_prices[force_index] -- models/free-market.can:1330
	if sell_price == nil then -- models/free-market.can:1331
		f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1332
		f_sell_prices[item_name] = nil -- models/free-market.can:1333
		return  -- models/free-market.can:1334
	end -- models/free-market.can:1334
	local active_sell_price = f_sell_prices[item_name] -- models/free-market.can:1337
	local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1338
	local prev_sell_price = f_sell_prices[item_name] or inactive_sell_price -- models/free-market.can:1339
	if prev_sell_price == sell_price then -- models/free-market.can:1340
		if inactive_sell_price then -- models/free-market.can:1341
			local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:1342
			if count_in_storage and count_in_storage > 0 then -- models/free-market.can:1343
				f_sell_prices[item_name] = sell_price -- models/free-market.can:1344
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1345
				notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1346
			end -- models/free-market.can:1346
		end -- models/free-market.can:1346
		return  -- models/free-market.can:1349
	end -- models/free-market.can:1349
	local buy_price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:1352
	if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then -- models/free-market.can:1353
		player["print"]({ -- models/free-market.can:1354
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1354
			sell_price, -- models/free-market.can:1354
			buy_price or minimal_price, -- models/free-market.can:1354
			maximal_price -- models/free-market.can:1354
		}) -- models/free-market.can:1354
		return active_sell_price or inactive_sell_price or "" -- models/free-market.can:1355
	end -- models/free-market.can:1355
	if active_sell_price then -- models/free-market.can:1358
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1359
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1360
	elseif inactive_sell_price then -- models/free-market.can:1361
		local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:1362
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1363
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1364
		else -- models/free-market.can:1364
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1366
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1367
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1368
		end -- models/free-market.can:1368
	elseif __transfer_boxes[force_index][item_name] then -- models/free-market.can:1370
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1371
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1372
	else -- models/free-market.can:1372
		local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:1374
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1375
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1376
		else -- models/free-market.can:1376
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1378
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1379
		end -- models/free-market.can:1379
	end -- models/free-market.can:1379
end -- models/free-market.can:1379
local function change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:1388
	local force_index = player["force_index"] -- models/free-market.can:1389
	local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:1390
	local f_inactive_buy_prices = __inactive_buy_prices[force_index] -- models/free-market.can:1391
	if buy_price == nil then -- models/free-market.can:1392
		f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1393
		f_buy_prices[item_name] = nil -- models/free-market.can:1394
		return  -- models/free-market.can:1395
	end -- models/free-market.can:1395
	local prev_buy_price = f_buy_prices[item_name] or f_inactive_buy_prices[item_name] -- models/free-market.can:1398
	if prev_buy_price == buy_price then -- models/free-market.can:1399
		return  -- models/free-market.can:1400
	end -- models/free-market.can:1400
	local sell_price = __sell_prices[force_index][item_name] -- models/free-market.can:1403
	if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then -- models/free-market.can:1404
		player["print"]({ -- models/free-market.can:1405
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1405
			buy_price, -- models/free-market.can:1405
			minimal_price, -- models/free-market.can:1405
			sell_price or maximal_price -- models/free-market.can:1405
		}) -- models/free-market.can:1405
		return f_buy_prices[item_name] or f_inactive_buy_prices[item_name] or "" -- models/free-market.can:1406
	end -- models/free-market.can:1406
	if f_buy_prices[item_name] then -- models/free-market.can:1409
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1410
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1411
	elseif f_inactive_buy_prices[item_name] then -- models/free-market.can:1412
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1413
	elseif __buy_boxes[force_index][item_name] then -- models/free-market.can:1414
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1415
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1416
	else -- models/free-market.can:1416
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1418
	end -- models/free-market.can:1418
end -- models/free-market.can:1418
local function create_price_notification_handler(gui, button_name, is_top_handler) -- models/free-market.can:1425
	local flow = gui["add"](TITLEBAR_FLOW) -- models/free-market.can:1426
	flow["style"]["padding"] = 0 -- models/free-market.can:1427
	if is_top_handler then -- models/free-market.can:1428
		local button = flow["add"]({ -- models/free-market.can:1429
			["type"] = "sprite-button", -- models/free-market.can:1430
			["sprite"] = "FM_price", -- models/free-market.can:1431
			["style"] = "frame_action_button", -- models/free-market.can:1432
			["name"] = button_name -- models/free-market.can:1433
		}) -- models/free-market.can:1433
		button["style"]["margin"] = 0 -- models/free-market.can:1435
	end -- models/free-market.can:1435
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:1437
	drag_handler["drag_target"] = gui -- models/free-market.can:1438
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:1439
	if is_top_handler then -- models/free-market.can:1440
		flow["style"]["horizontal_spacing"] = 0 -- models/free-market.can:1441
		drag_handler["style"]["width"] = 27 -- models/free-market.can:1442
		drag_handler["style"]["height"] = 25 -- models/free-market.can:1443
		drag_handler["style"]["horizontally_stretchable"] = false -- models/free-market.can:1444
	else -- models/free-market.can:1444
		drag_handler["style"]["width"] = 24 -- models/free-market.can:1446
		drag_handler["style"]["height"] = 46 -- models/free-market.can:1447
		drag_handler["add"]({ -- models/free-market.can:1448
			["type"] = "sprite-button", -- models/free-market.can:1449
			["sprite"] = "FM_price", -- models/free-market.can:1450
			["style"] = "frame_action_button", -- models/free-market.can:1451
			["name"] = button_name -- models/free-market.can:1452
		}) -- models/free-market.can:1452
	end -- models/free-market.can:1452
end -- models/free-market.can:1452
local function switch_sell_prices_gui(player, location) -- models/free-market.can:1459
	local screen = player["gui"]["screen"] -- models/free-market.can:1460
	local main_frame = screen["FM_sell_prices_frame"] -- models/free-market.can:1461
	if main_frame then -- models/free-market.can:1462
		local children = main_frame["children"] -- models/free-market.can:1463
		if # children > 1 then -- models/free-market.can:1464
			children[2]["destroy"]() -- models/free-market.can:1465
			return  -- models/free-market.can:1466
		else -- models/free-market.can:1466
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1468
				["type"] = "frame", -- models/free-market.can:1468
				["name"] = "FM_prices_flow", -- models/free-market.can:1468
				["style"] = "FM_prices_frame", -- models/free-market.can:1468
				["direction"] = "vertical" -- models/free-market.can:1468
			}) -- models/free-market.can:1468
			local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1469
			prices_flow["add"]({ -- models/free-market.can:1470
				["type"] = "table", -- models/free-market.can:1470
				["name"] = "FM_prices_table", -- models/free-market.can:1470
				["style"] = "FM_prices_table", -- models/free-market.can:1470
				["column_count"] = column_count -- models/free-market.can:1470
			}) -- models/free-market.can:1470
		end -- models/free-market.can:1470
	else -- models/free-market.can:1470
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1480
		local is_vertical = (column_count == 2) -- models/free-market.can:1481
		if is_vertical then -- models/free-market.can:1482
			direction = "vertical" -- models/free-market.can:1483
		else -- models/free-market.can:1483
			direction = "horizontal" -- models/free-market.can:1485
		end -- models/free-market.can:1485
		main_frame = screen["add"]({ -- models/free-market.can:1487
			["type"] = "frame", -- models/free-market.can:1487
			["name"] = "FM_sell_prices_frame", -- models/free-market.can:1487
			["style"] = "tips_and_tricks_notification_frame", -- models/free-market.can:1487
			["direction"] = direction -- models/free-market.can:1487
		}) -- models/free-market.can:1487
		main_frame["location"] = location or { -- models/free-market.can:1488
			["x"] = player["display_resolution"]["width"] - 752, -- models/free-market.can:1488
			["y"] = 272 -- models/free-market.can:1488
		} -- models/free-market.can:1488
		create_price_notification_handler(main_frame, "FM_switch_sell_prices_gui", is_vertical) -- models/free-market.can:1489
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1490
			["type"] = "frame", -- models/free-market.can:1490
			["name"] = "FM_prices_flow", -- models/free-market.can:1490
			["style"] = "FM_prices_frame", -- models/free-market.can:1490
			["direction"] = "vertical" -- models/free-market.can:1490
		}) -- models/free-market.can:1490
		prices_flow["add"]({ -- models/free-market.can:1491
			["type"] = "table", -- models/free-market.can:1491
			["name"] = "FM_prices_table", -- models/free-market.can:1491
			["style"] = "FM_prices_table", -- models/free-market.can:1491
			["column_count"] = column_count -- models/free-market.can:1491
		}) -- models/free-market.can:1491
	end -- models/free-market.can:1491
end -- models/free-market.can:1491
local function switch_buy_prices_gui(player, location) -- models/free-market.can:1497
	local screen = player["gui"]["screen"] -- models/free-market.can:1498
	local main_frame = screen["FM_buy_prices_frame"] -- models/free-market.can:1499
	if main_frame then -- models/free-market.can:1500
		local children = main_frame["children"] -- models/free-market.can:1501
		if # children > 1 then -- models/free-market.can:1502
			children[2]["destroy"]() -- models/free-market.can:1503
			return  -- models/free-market.can:1504
		else -- models/free-market.can:1504
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1506
				["type"] = "frame", -- models/free-market.can:1506
				["name"] = "FM_prices_flow", -- models/free-market.can:1506
				["style"] = "FM_prices_frame", -- models/free-market.can:1506
				["direction"] = "vertical" -- models/free-market.can:1506
			}) -- models/free-market.can:1506
			local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1507
			prices_flow["add"]({ -- models/free-market.can:1508
				["type"] = "table", -- models/free-market.can:1508
				["name"] = "FM_prices_table", -- models/free-market.can:1508
				["style"] = "FM_prices_table", -- models/free-market.can:1508
				["column_count"] = column_count -- models/free-market.can:1508
			}) -- models/free-market.can:1508
		end -- models/free-market.can:1508
	else -- models/free-market.can:1508
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1518
		local is_vertical = (column_count == 2) -- models/free-market.can:1519
		if is_vertical then -- models/free-market.can:1520
			direction = "vertical" -- models/free-market.can:1521
		else -- models/free-market.can:1521
			direction = "horizontal" -- models/free-market.can:1523
		end -- models/free-market.can:1523
		main_frame = screen["add"]({ -- models/free-market.can:1525
			["type"] = "frame", -- models/free-market.can:1525
			["name"] = "FM_buy_prices_frame", -- models/free-market.can:1525
			["style"] = "tips_and_tricks_notification_frame", -- models/free-market.can:1525
			["direction"] = direction -- models/free-market.can:1525
		}) -- models/free-market.can:1525
		main_frame["location"] = location or { -- models/free-market.can:1526
			["x"] = player["display_resolution"]["width"] - 712, -- models/free-market.can:1526
			["y"] = 272 -- models/free-market.can:1526
		} -- models/free-market.can:1526
		create_price_notification_handler(main_frame, "FM_switch_buy_prices_gui", is_vertical) -- models/free-market.can:1527
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1528
			["type"] = "frame", -- models/free-market.can:1528
			["name"] = "FM_prices_flow", -- models/free-market.can:1528
			["style"] = "FM_prices_frame", -- models/free-market.can:1528
			["direction"] = "vertical" -- models/free-market.can:1528
		}) -- models/free-market.can:1528
		prices_flow["add"]({ -- models/free-market.can:1529
			["type"] = "table", -- models/free-market.can:1529
			["name"] = "FM_prices_table", -- models/free-market.can:1529
			["style"] = "FM_prices_table", -- models/free-market.can:1529
			["column_count"] = column_count -- models/free-market.can:1529
		}) -- models/free-market.can:1529
	end -- models/free-market.can:1529
end -- models/free-market.can:1529
local function open_embargo_gui(player) -- models/free-market.can:1534
	local screen = player["gui"]["screen"] -- models/free-market.can:1535
	if screen["FM_embargo_frame"] then -- models/free-market.can:1536
		screen["FM_embargo_frame"]["destroy"]() -- models/free-market.can:1537
		return  -- models/free-market.can:1538
	end -- models/free-market.can:1538
	local main_frame = screen["add"]({ -- models/free-market.can:1540
		["type"] = "frame", -- models/free-market.can:1540
		["name"] = "FM_embargo_frame", -- models/free-market.can:1540
		["direction"] = "vertical" -- models/free-market.can:1540
	}) -- models/free-market.can:1540
	main_frame["style"]["minimal_width"] = 340 -- models/free-market.can:1541
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1542
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1543
	flow["add"]({ -- models/free-market.can:1544
		["type"] = "label", -- models/free-market.can:1545
		["style"] = "frame_title", -- models/free-market.can:1546
		["caption"] = { "free-market.embargo-gui" }, -- models/free-market.can:1547
		["ignored_by_interaction"] = true -- models/free-market.can:1548
	}) -- models/free-market.can:1548
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1550
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1551
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1553
		["type"] = "frame", -- models/free-market.can:1553
		["name"] = "shallow_frame", -- models/free-market.can:1553
		["style"] = "inside_shallow_frame" -- models/free-market.can:1553
	}) -- models/free-market.can:1553
	local embargo_table = shallow_frame["add"]({ -- models/free-market.can:1554
		["type"] = "table", -- models/free-market.can:1554
		["name"] = "embargo_table", -- models/free-market.can:1554
		["column_count"] = 3 -- models/free-market.can:1554
	}) -- models/free-market.can:1554
	embargo_table["style"]["horizontally_stretchable"] = true -- models/free-market.can:1555
	embargo_table["style"]["vertically_stretchable"] = true -- models/free-market.can:1556
	embargo_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1557
	embargo_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1558
	embargo_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1559
	update_embargo_table(embargo_table, player) -- models/free-market.can:1561
	main_frame["force_auto_center"]() -- models/free-market.can:1562
end -- models/free-market.can:1562
local function set_transfer_box_data(item_name, entity) -- models/free-market.can:1567
	local force = entity["force"] -- models/free-market.can:1568
	local force_index = force["index"] -- models/free-market.can:1569
	local f_transfer_boxes = __transfer_boxes[force_index] -- models/free-market.can:1570
	if f_transfer_boxes[item_name] == nil then -- models/free-market.can:1571
		local f_inactive_sell_prices = __inactive_sell_prices[force_index] -- models/free-market.can:1572
		local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1573
		if inactive_sell_price then -- models/free-market.can:1574
			__sell_prices[force_index][item_name] = inactive_sell_price -- models/free-market.can:1575
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1576
			notify_sell_price(force_index, item_name, inactive_sell_price) -- models/free-market.can:1577
		end -- models/free-market.can:1577
		f_transfer_boxes[item_name] = {} -- models/free-market.can:1579
	end -- models/free-market.can:1579
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:1581
	entities[# entities + 1] = entity -- models/free-market.can:1582
	local sprite_data = { -- models/free-market.can:1583
		["sprite"] = "FM_transparent-transfer", -- models/free-market.can:1584
		["target"] = entity, -- models/free-market.can:1585
		["surface"] = entity["surface"], -- models/free-market.can:1586
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1587
		["only_in_alt_mode"] = true, -- models/free-market.can:1588
		["x_scale"] = 0.4, -- models/free-market.can:1589
		["y_scale"] = 0.4 -- models/free-market.can:1589
	} -- models/free-market.can:1589
	if is_public_titles == false then -- models/free-market.can:1591
		sprite_data["forces"] = { force } -- models/free-market.can:1592
	end -- models/free-market.can:1592
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1595
	show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:1596
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1598
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1601
		entity, -- models/free-market.can:1601
		id, -- models/free-market.can:1601
		4, -- models/free-market.can:1
		entities, -- models/free-market.can:1601
		item_name -- models/free-market.can:1601
	} -- models/free-market.can:1601
end -- models/free-market.can:1601
local function set_universal_transfer_box_data(entity) -- models/free-market.can:1605
	local force = entity["force"] -- models/free-market.can:1606
	local force_index = force["index"] -- models/free-market.can:1607
	local entities = __universal_transfer_boxes[force_index] -- models/free-market.can:1608
	entities[# entities + 1] = entity -- models/free-market.can:1609
	local sprite_data = { -- models/free-market.can:1610
		["sprite"] = "FM_transparent-universal-transfer", -- models/free-market.can:1611
		["target"] = entity, -- models/free-market.can:1612
		["surface"] = entity["surface"], -- models/free-market.can:1613
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1614
		["only_in_alt_mode"] = true, -- models/free-market.can:1615
		["x_scale"] = 0.4, -- models/free-market.can:1616
		["y_scale"] = 0.4 -- models/free-market.can:1616
	} -- models/free-market.can:1616
	if is_public_titles == false then -- models/free-market.can:1618
		sprite_data["forces"] = { force } -- models/free-market.can:1619
	end -- models/free-market.can:1619
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1622
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1625
		entity, -- models/free-market.can:1625
		id, -- models/free-market.can:1625
		5, -- models/free-market.can:1
		entities, -- models/free-market.can:1625
		nil -- models/free-market.can:1625
	} -- models/free-market.can:1625
end -- models/free-market.can:1625
local function set_bin_box_data(item_name, entity) -- models/free-market.can:1630
	local force = entity["force"] -- models/free-market.can:1631
	local force_index = force["index"] -- models/free-market.can:1632
	local f_bin_boxes = __bin_boxes[force_index] -- models/free-market.can:1633
	if f_bin_boxes[item_name] == nil then -- models/free-market.can:1634
		f_bin_boxes[item_name] = {} -- models/free-market.can:1635
	end -- models/free-market.can:1635
	local entities = f_bin_boxes[item_name] -- models/free-market.can:1637
	entities[# entities + 1] = entity -- models/free-market.can:1638
	local sprite_data = { -- models/free-market.can:1639
		["sprite"] = "FM_transparent-bin", -- models/free-market.can:1640
		["target"] = entity, -- models/free-market.can:1641
		["surface"] = entity["surface"], -- models/free-market.can:1642
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1643
		["only_in_alt_mode"] = true, -- models/free-market.can:1644
		["x_scale"] = 0.4, -- models/free-market.can:1645
		["y_scale"] = 0.4 -- models/free-market.can:1645
	} -- models/free-market.can:1645
	if is_public_titles == false then -- models/free-market.can:1647
		sprite_data["forces"] = { force } -- models/free-market.can:1648
	end -- models/free-market.can:1648
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1651
	show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:1652
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1655
		entity, -- models/free-market.can:1655
		id, -- models/free-market.can:1655
		6, -- models/free-market.can:1
		entities, -- models/free-market.can:1655
		item_name -- models/free-market.can:1655
	} -- models/free-market.can:1655
end -- models/free-market.can:1655
local function set_universal_bin_box_data(entity) -- models/free-market.can:1659
	local force = entity["force"] -- models/free-market.can:1660
	local force_index = force["index"] -- models/free-market.can:1661
	local entities = __universal_bin_boxes[force_index] -- models/free-market.can:1662
	entities[# entities + 1] = entity -- models/free-market.can:1663
	local sprite_data = { -- models/free-market.can:1664
		["sprite"] = "FM_transparent-universal-bin", -- models/free-market.can:1665
		["target"] = entity, -- models/free-market.can:1666
		["surface"] = entity["surface"], -- models/free-market.can:1667
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1668
		["only_in_alt_mode"] = true, -- models/free-market.can:1669
		["x_scale"] = 0.4, -- models/free-market.can:1670
		["y_scale"] = 0.4 -- models/free-market.can:1670
	} -- models/free-market.can:1670
	if is_public_titles == false then -- models/free-market.can:1672
		sprite_data["forces"] = { force } -- models/free-market.can:1673
	end -- models/free-market.can:1673
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1676
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1679
		entity, -- models/free-market.can:1679
		id, -- models/free-market.can:1679
		7, -- models/free-market.can:1
		entities, -- models/free-market.can:1679
		nil -- models/free-market.can:1679
	} -- models/free-market.can:1679
end -- models/free-market.can:1679
local function set_pull_box_data(item_name, entity) -- models/free-market.can:1684
	local force = entity["force"] -- models/free-market.can:1685
	local force_index = force["index"] -- models/free-market.can:1686
	local force_pull_boxes = __pull_boxes[force_index] -- models/free-market.can:1687
	force_pull_boxes[item_name] = force_pull_boxes[item_name] or {} -- models/free-market.can:1688
	local items = force_pull_boxes[item_name] -- models/free-market.can:1689
	items[# items + 1] = entity -- models/free-market.can:1690
	local sprite_data = { -- models/free-market.can:1691
		["sprite"] = "FM_transparent-pull-out", -- models/free-market.can:1692
		["target"] = entity, -- models/free-market.can:1693
		["surface"] = entity["surface"], -- models/free-market.can:1694
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1695
		["only_in_alt_mode"] = true, -- models/free-market.can:1696
		["x_scale"] = 0.4, -- models/free-market.can:1697
		["y_scale"] = 0.4 -- models/free-market.can:1697
	} -- models/free-market.can:1697
	if is_public_titles == false then -- models/free-market.can:1699
		sprite_data["forces"] = { force } -- models/free-market.can:1700
	end -- models/free-market.can:1700
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1703
	show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:1704
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1706
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1709
		entity, -- models/free-market.can:1709
		id, -- models/free-market.can:1709
		3, -- models/free-market.can:1
		items, -- models/free-market.can:1709
		item_name -- models/free-market.can:1709
	} -- models/free-market.can:1709
end -- models/free-market.can:1709
local function set_buy_box_data(item_name, entity, count) -- models/free-market.can:1715
	count = count or prototypes["item"][item_name]["stack_size"] -- models/free-market.can:1716
	local force = entity["force"] -- models/free-market.can:1718
	local force_index = force["index"] -- models/free-market.can:1719
	local f_buy_boxes = __buy_boxes[force_index] -- models/free-market.can:1720
	if f_buy_boxes[item_name] == nil then -- models/free-market.can:1721
		local f_inactive_buy_prices = __inactive_buy_prices[force_index] -- models/free-market.can:1722
		local inactive_buy_price = f_inactive_buy_prices[item_name] -- models/free-market.can:1723
		if inactive_buy_price then -- models/free-market.can:1724
			__buy_prices[force_index][item_name] = inactive_buy_price -- models/free-market.can:1726
			f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1727
			notify_buy_price(force_index, item_name, inactive_buy_price) -- models/free-market.can:1728
		end -- models/free-market.can:1728
		f_buy_boxes[item_name] = {} -- models/free-market.can:1730
	end -- models/free-market.can:1730
	local items = f_buy_boxes[item_name] -- models/free-market.can:1732
	items[# items + 1] = { -- models/free-market.can:1733
		entity, -- models/free-market.can:1733
		count -- models/free-market.can:1733
	} -- models/free-market.can:1733
	local sprite_data = { -- models/free-market.can:1734
		["sprite"] = "FM_transparent-buy", -- models/free-market.can:1735
		["target"] = entity, -- models/free-market.can:1736
		["surface"] = entity["surface"], -- models/free-market.can:1737
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1738
		["only_in_alt_mode"] = true, -- models/free-market.can:1739
		["x_scale"] = 0.4, -- models/free-market.can:1740
		["y_scale"] = 0.4 -- models/free-market.can:1740
	} -- models/free-market.can:1740
	if is_public_titles == false then -- models/free-market.can:1742
		sprite_data["forces"] = { force } -- models/free-market.can:1743
	end -- models/free-market.can:1743
	local id = draw_sprite(sprite_data)["id"] -- models/free-market.can:1746
	show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:1747
	__all_boxes[entity["unit_number"]] = { -- models/free-market.can:1750
		entity, -- models/free-market.can:1750
		id, -- models/free-market.can:1750
		1, -- models/free-market.can:1
		items, -- models/free-market.can:1750
		item_name -- models/free-market.can:1750
	} -- models/free-market.can:1750
end -- models/free-market.can:1750
local function destroy_force_configuration(player) -- models/free-market.can:1754
	local frame = player["gui"]["screen"]["FM_force_configuration"] -- models/free-market.can:1755
	if frame then -- models/free-market.can:1756
		frame["destroy"]() -- models/free-market.can:1757
	end -- models/free-market.can:1757
end -- models/free-market.can:1757
local function open_force_configuration(player) -- models/free-market.can:1762
	local screen = player["gui"]["screen"] -- models/free-market.can:1763
	if screen["FM_force_configuration"] then -- models/free-market.can:1764
		screen["FM_force_configuration"]["destroy"]() -- models/free-market.can:1765
		return  -- models/free-market.can:1766
	end -- models/free-market.can:1766
	local is_player_admin = player["admin"] -- models/free-market.can:1769
	local force = player["force"] -- models/free-market.can:1770
	local main_frame = screen["add"]({ -- models/free-market.can:1772
		["type"] = "frame", -- models/free-market.can:1772
		["name"] = "FM_force_configuration", -- models/free-market.can:1772
		["direction"] = "vertical" -- models/free-market.can:1772
	}) -- models/free-market.can:1772
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1773
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1774
	flow["add"]({ -- models/free-market.can:1775
		["type"] = "label", -- models/free-market.can:1776
		["style"] = "frame_title", -- models/free-market.can:1777
		["caption"] = { "free-market.team-configuration" }, -- models/free-market.can:1778
		["ignored_by_interaction"] = true -- models/free-market.can:1779
	}) -- models/free-market.can:1779
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1781
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1782
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1783
		["type"] = "frame", -- models/free-market.can:1783
		["name"] = "shallow_frame", -- models/free-market.can:1783
		["style"] = "inside_shallow_frame", -- models/free-market.can:1783
		["direction"] = "vertical" -- models/free-market.can:1783
	}) -- models/free-market.can:1783
	local content = shallow_frame["add"]({ -- models/free-market.can:1784
		["type"] = "flow", -- models/free-market.can:1784
		["name"] = "content_flow", -- models/free-market.can:1784
		["direction"] = "vertical" -- models/free-market.can:1784
	}) -- models/free-market.can:1784
	content["style"]["padding"] = 12 -- models/free-market.can:1785
	if is_player_admin then -- models/free-market.can:1787
		local admin_row = content["add"](FLOW) -- models/free-market.can:1788
		admin_row["name"] = "admin_row" -- models/free-market.can:1789
		admin_row["add"](LABEL)["caption"] = { -- models/free-market.can:1790
			"", -- models/free-market.can:1790
			{ "gui-multiplayer-lobby.allow-commands-admins-only" }, -- models/free-market.can:1790
			COLON -- models/free-market.can:1790
		} -- models/free-market.can:1790
		admin_row["add"]({ -- models/free-market.can:1791
			["type"] = "button", -- models/free-market.can:1791
			["caption"] = { "free-market.print-force-data-button" }, -- models/free-market.can:1791
			["name"] = "FM_print_force_data" -- models/free-market.can:1791
		}) -- models/free-market.can:1791
		admin_row["add"]({ -- models/free-market.can:1792
			["type"] = "button", -- models/free-market.can:1792
			["caption"] = "Clear invalid data", -- models/free-market.can:1792
			["name"] = "FM_clear_invalid_data" -- models/free-market.can:1792
		}) -- models/free-market.can:1792
	end -- models/free-market.can:1792
	if is_reset_public or is_player_admin or # force["players"] == 1 then -- models/free-market.can:1795
		if is_player_admin then -- models/free-market.can:1796
			content["add"](LABEL)["caption"] = { -- models/free-market.can:1797
				"", -- models/free-market.can:1797
				"Attention", -- models/free-market.can:1797
				COLON, -- models/free-market.can:1797
				"reset is public" -- models/free-market.can:1797
			} -- models/free-market.can:1797
		end -- models/free-market.can:1797
		local reset_caption = { -- models/free-market.can:1799
			"", -- models/free-market.can:1799
			{ "free-market.reset-gui" }, -- models/free-market.can:1799
			COLON -- models/free-market.can:1799
		} -- models/free-market.can:1799
		local reset_prices_row = content["add"](FLOW) -- models/free-market.can:1800
		reset_prices_row["name"] = "reset_prices_row" -- models/free-market.can:1801
		reset_prices_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1802
		reset_prices_row["add"]({ -- models/free-market.can:1803
			["type"] = "button", -- models/free-market.can:1803
			["caption"] = { "free-market.reset-buy-prices" }, -- models/free-market.can:1803
			["name"] = "FM_reset_buy_prices" -- models/free-market.can:1803
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1803
		reset_prices_row["add"]({ -- models/free-market.can:1804
			["type"] = "button", -- models/free-market.can:1804
			["caption"] = { "free-market.reset-sell-prices" }, -- models/free-market.can:1804
			["name"] = "FM_reset_sell_prices" -- models/free-market.can:1804
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1804
		reset_prices_row["add"]({ -- models/free-market.can:1805
			["type"] = "button", -- models/free-market.can:1805
			["caption"] = { "free-market.reset-all-prices" }, -- models/free-market.can:1805
			["name"] = "FM_reset_all_prices" -- models/free-market.can:1805
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1805
		local reset_boxes_row = content["add"](FLOW) -- models/free-market.can:1807
		reset_boxes_row["name"] = "reset_boxes_row" -- models/free-market.can:1808
		reset_boxes_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1809
		reset_boxes_row["add"]({ -- models/free-market.can:1810
			["type"] = "button", -- models/free-market.can:1810
			["style"] = "FM_transfer_button", -- models/free-market.can:1810
			["name"] = "FM_reset_transfer_boxes" -- models/free-market.can:1810
		}) -- models/free-market.can:1810
		reset_boxes_row["add"]({ -- models/free-market.can:1811
			["type"] = "button", -- models/free-market.can:1811
			["style"] = "FM_universal_transfer_button", -- models/free-market.can:1811
			["name"] = "FM_reset_universal_transfer_boxes" -- models/free-market.can:1811
		}) -- models/free-market.can:1811
		reset_boxes_row["add"]({ -- models/free-market.can:1812
			["type"] = "button", -- models/free-market.can:1812
			["style"] = "FM_bin_button", -- models/free-market.can:1812
			["name"] = "FM_reset_bin_boxes" -- models/free-market.can:1812
		}) -- models/free-market.can:1812
		reset_boxes_row["add"]({ -- models/free-market.can:1813
			["type"] = "button", -- models/free-market.can:1813
			["style"] = "FM_universal_bin_button", -- models/free-market.can:1813
			["name"] = "FM_reset_universal_bin_boxes" -- models/free-market.can:1813
		}) -- models/free-market.can:1813
		reset_boxes_row["add"]({ -- models/free-market.can:1814
			["type"] = "button", -- models/free-market.can:1814
			["style"] = "FM_pull_out_button", -- models/free-market.can:1814
			["name"] = "FM_reset_pull_boxes" -- models/free-market.can:1814
		}) -- models/free-market.can:1814
		reset_boxes_row["add"]({ -- models/free-market.can:1815
			["type"] = "button", -- models/free-market.can:1815
			["style"] = "FM_buy_button", -- models/free-market.can:1815
			["name"] = "FM_reset_buy_boxes" -- models/free-market.can:1815
		}) -- models/free-market.can:1815
		reset_boxes_row["add"]({ -- models/free-market.can:1816
			["type"] = "button", -- models/free-market.can:1816
			["caption"] = { "free-market.reset-all-types" }, -- models/free-market.can:1816
			["name"] = "FM_reset_all_boxes" -- models/free-market.can:1816
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1816
	end -- models/free-market.can:1816
	local setting_row = content["add"](FLOW) -- models/free-market.can:1819
	setting_row["style"]["vertical_align"] = "center" -- models/free-market.can:1820
	setting_row["add"](LABEL)["caption"] = { -- models/free-market.can:1821
		"", -- models/free-market.can:1821
		{ "free-market.default-storage-limit" }, -- models/free-market.can:1821
		COLON -- models/free-market.can:1821
	} -- models/free-market.can:1821
	local default_limit_textfield = setting_row["add"](DEFAULT_LIMIT_TEXTFIELD) -- models/free-market.can:1822
	local default_limit = __default_storage_limit[force["index"]] or max_storage_threshold -- models/free-market.can:1823
	default_limit_textfield["text"] = tostring(default_limit) -- models/free-market.can:1824
	setting_row["add"](CHECK_BUTTON)["name"] = "FM_confirm_default_limit" -- models/free-market.can:1825
	local label = content["add"](LABEL) -- models/free-market.can:1827
	label["caption"] = { -- models/free-market.can:1828
		"", -- models/free-market.can:1828
		{ "gui.credits" }, -- models/free-market.can:1828
		COLON -- models/free-market.can:1828
	} -- models/free-market.can:1828
	label["style"]["font"] = "heading-1" -- models/free-market.can:1829
	local translations_row = content["add"](FLOW) -- models/free-market.can:1830
	translations_row["add"](LABEL)["caption"] = { -- models/free-market.can:1831
		"", -- models/free-market.can:1831
		"Translations", -- models/free-market.can:1831
		COLON -- models/free-market.can:1831
	} -- models/free-market.can:1831
	local link = translations_row["add"]({ -- models/free-market.can:1832
		["type"] = "textfield", -- models/free-market.can:1832
		["text"] = "https://crowdin.com/project/factorio-mods-localization" -- models/free-market.can:1832
	}) -- models/free-market.can:1832
	link["style"]["horizontally_stretchable"] = true -- models/free-market.can:1833
	link["style"]["width"] = 320 -- models/free-market.can:1834
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1835
		"", -- models/free-market.can:1835
		"Translators", -- models/free-market.can:1835
		COLON, -- models/free-market.can:1835
		" ", -- models/free-market.can:1835
		"TerMineFact, Met_en_Bouldry, jorgendbj (Allodet), Xman1109, Eerrikki (Robin Braathen), eifel (Eifel87), zszzlzm (刘泽民), Spielen01231 (TheFakescribtx2), Drilzxx_ (Kévin), eifel (Eifel87), Felix_Manning (Felix Manning), ZwerOxotnik" -- models/free-market.can:1835
	} -- models/free-market.can:1835
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1836
		"", -- models/free-market.can:1836
		"Supporters", -- models/free-market.can:1836
		COLON, -- models/free-market.can:1836
		" ", -- models/free-market.can:1836
		"Eerrikki" -- models/free-market.can:1836
	} -- models/free-market.can:1836
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1837
		"", -- models/free-market.can:1837
		{ "gui-other-settings.developer" }, -- models/free-market.can:1837
		COLON, -- models/free-market.can:1837
		" ", -- models/free-market.can:1837
		"ZwerOxotnik" -- models/free-market.can:1837
	} -- models/free-market.can:1837
	local text_box = content["add"]({ ["type"] = "text-box" }) -- models/free-market.can:1838
	text_box["read_only"] = true -- models/free-market.can:1839
	text_box["text"] = "see-prices.png from https://www.svgrepo.com/svg/77065/price-tag\
" .. "change-price.png from https://www.svgrepo.com/svg/96982/price-tag\
" .. "embargo.png is modified version of https://www.svgrepo.com/svg/97012/price-tag" .. "Modified versions of https://www.svgrepo.com/svg/11042/shopping-cart-with-down-arrow-e-commerce-symbol" .. "Modified versions of https://www.svgrepo.com/svg/89258/rubbish-bin" -- models/free-market.can:1844
	text_box["style"]["maximal_width"] = 0 -- models/free-market.can:1845
	text_box["style"]["height"] = 70 -- models/free-market.can:1846
	text_box["style"]["horizontally_stretchable"] = true -- models/free-market.can:1847
	text_box["style"]["vertically_stretchable"] = true -- models/free-market.can:1848
	main_frame["force_auto_center"]() -- models/free-market.can:1850
end -- models/free-market.can:1850
local function switch_prices_gui(player, item_name) -- models/free-market.can:1855
	local screen = player["gui"]["screen"] -- models/free-market.can:1856
	local main_frame = screen["FM_prices_frame"] -- models/free-market.can:1857
	if main_frame then -- models/free-market.can:1858
		if item_name == nil then -- models/free-market.can:1859
			main_frame["destroy"]() -- models/free-market.can:1860
		else -- models/free-market.can:1860
			local content_flow = main_frame["shallow_frame"]["content_flow"] -- models/free-market.can:1862
			local item_row = main_frame["shallow_frame"]["content_flow"]["item_row"] -- models/free-market.can:1863
			item_row["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:1864
			local force_index = player["force_index"] -- models/free-market.can:1866
			local sell_price = __sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] -- models/free-market.can:1867
			if sell_price then -- models/free-market.can:1868
				item_row["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:1869
			end -- models/free-market.can:1869
			local buy_price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:1871
			if buy_price then -- models/free-market.can:1872
				item_row["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:1873
			end -- models/free-market.can:1873
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:1875
		end -- models/free-market.can:1875
		return  -- models/free-market.can:1877
	end -- models/free-market.can:1877
	local force_index = player["force_index"] -- models/free-market.can:1880
	main_frame = screen["add"]({ -- models/free-market.can:1882
		["type"] = "frame", -- models/free-market.can:1882
		["name"] = "FM_prices_frame", -- models/free-market.can:1882
		["direction"] = "vertical" -- models/free-market.can:1882
	}) -- models/free-market.can:1882
	main_frame["location"] = { -- models/free-market.can:1883
		["x"] = 100 / player["display_scale"], -- models/free-market.can:1883
		["y"] = 50 -- models/free-market.can:1883
	} -- models/free-market.can:1883
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1884
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1885
	flow["add"]({ -- models/free-market.can:1886
		["type"] = "label", -- models/free-market.can:1887
		["style"] = "frame_title", -- models/free-market.can:1888
		["caption"] = { "free-market.prices" }, -- models/free-market.can:1889
		["ignored_by_interaction"] = true -- models/free-market.can:1890
	}) -- models/free-market.can:1890
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1892
	flow["add"]({ -- models/free-market.can:1893
		["type"] = "sprite-button", -- models/free-market.can:1894
		["style"] = "frame_action_button", -- models/free-market.can:1895
		["sprite"] = "refresh_white_icon", -- models/free-market.can:1896
		["name"] = "FM_refresh_prices_table" -- models/free-market.can:1897
	}) -- models/free-market.can:1897
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1899
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1900
		["type"] = "frame", -- models/free-market.can:1900
		["name"] = "shallow_frame", -- models/free-market.can:1900
		["style"] = "inside_shallow_frame", -- models/free-market.can:1900
		["direction"] = "vertical" -- models/free-market.can:1900
	}) -- models/free-market.can:1900
	local content = shallow_frame["add"]({ -- models/free-market.can:1901
		["type"] = "flow", -- models/free-market.can:1901
		["name"] = "content_flow", -- models/free-market.can:1901
		["direction"] = "vertical" -- models/free-market.can:1901
	}) -- models/free-market.can:1901
	content["style"]["padding"] = 12 -- models/free-market.can:1902
	local item_row = content["add"](FLOW) -- models/free-market.can:1904
	local add = item_row["add"] -- models/free-market.can:1905
	item_row["name"] = "item_row" -- models/free-market.can:1906
	item_row["style"]["vertical_align"] = "center" -- models/free-market.can:1907
	local item = add({ -- models/free-market.can:1908
		["type"] = "choose-elem-button", -- models/free-market.can:1908
		["name"] = "FM_prices_item", -- models/free-market.can:1908
		["elem_type"] = "item", -- models/free-market.can:1908
		["elem_filters"] = ITEM_FILTERS -- models/free-market.can:1908
	}) -- models/free-market.can:1908
	item["elem_value"] = item_name -- models/free-market.can:1909
	add(LABEL)["caption"] = { "free-market.buy-gui" } -- models/free-market.can:1910
	local buy_textfield = add(BUY_PRICE_TEXTFIELD) -- models/free-market.can:1911
	if item_name then -- models/free-market.can:1912
		local price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:1913
		if price then -- models/free-market.can:1914
			buy_textfield["text"] = tostring(price) -- models/free-market.can:1915
		end -- models/free-market.can:1915
	end -- models/free-market.can:1915
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price" -- models/free-market.can:1918
	add(LABEL)["caption"] = { "free-market.sell-gui" } -- models/free-market.can:1919
	local sell_textfield = add(SELL_PRICE_TEXTFIELD) -- models/free-market.can:1920
	if item_name then -- models/free-market.can:1921
		local price = __sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] -- models/free-market.can:1922
		if price then -- models/free-market.can:1923
			sell_textfield["text"] = tostring(price) -- models/free-market.can:1924
		end -- models/free-market.can:1924
	end -- models/free-market.can:1924
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price" -- models/free-market.can:1927
	local storage_row = content["add"](FLOW) -- models/free-market.can:1929
	local add = storage_row["add"] -- models/free-market.can:1930
	storage_row["name"] = "storage_row" -- models/free-market.can:1931
	storage_row["style"]["vertical_align"] = "center" -- models/free-market.can:1932
	add(LABEL)["caption"] = { -- models/free-market.can:1933
		"", -- models/free-market.can:1933
		{ "description.storage" }, -- models/free-market.can:1933
		COLON -- models/free-market.can:1933
	} -- models/free-market.can:1933
	local storage_count = add(LABEL) -- models/free-market.can:1934
	storage_count["name"] = "storage_count" -- models/free-market.can:1935
	add(LABEL)["caption"] = "/" -- models/free-market.can:1936
	local storage_limit_textfield = add(STORAGE_LIMIT_TEXTFIELD) -- models/free-market.can:1937
	add(CHECK_BUTTON)["name"] = "FM_confirm_storage_limit" -- models/free-market.can:1938
	if item_name == nil then -- models/free-market.can:1939
		storage_row["visible"] = false -- models/free-market.can:1940
	else -- models/free-market.can:1940
		local count = __storages[force_index][item_name] or 0 -- models/free-market.can:1942
		storage_count["caption"] = tostring(count) -- models/free-market.can:1943
		local limit = __storages_limit[force_index][item_name] or __default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:1944
		storage_limit_textfield["text"] = tostring(limit) -- models/free-market.can:1945
	end -- models/free-market.can:1945
	local prices_frame = content["add"]({ -- models/free-market.can:1948
		["type"] = "frame", -- models/free-market.can:1948
		["name"] = "other_prices_frame", -- models/free-market.can:1948
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1948
		["direction"] = "vertical" -- models/free-market.can:1948
	}) -- models/free-market.can:1948
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1949
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1950
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1951
		["type"] = "table", -- models/free-market.can:1951
		["name"] = "prices_table", -- models/free-market.can:1951
		["column_count"] = 3 -- models/free-market.can:1951
	}) -- models/free-market.can:1951
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1952
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1953
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:1954
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1955
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1956
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1957
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:1958
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:1959
	if item_name then -- models/free-market.can:1960
		update_prices_table(player, item_name, prices_table) -- models/free-market.can:1961
	else -- models/free-market.can:1961
		make_prices_header(prices_table) -- models/free-market.can:1963
	end -- models/free-market.can:1963
	return content -- models/free-market.can:1966
end -- models/free-market.can:1966
local function open_storage_gui(player) -- models/free-market.can:1969
	local screen = player["gui"]["screen"] -- models/free-market.can:1970
	local main_frame = screen["FM_storage_frame"] -- models/free-market.can:1971
	if main_frame then -- models/free-market.can:1972
		main_frame["destroy"]() -- models/free-market.can:1973
		return  -- models/free-market.can:1974
	end -- models/free-market.can:1974
	main_frame = screen["add"]({ -- models/free-market.can:1977
		["type"] = "frame", -- models/free-market.can:1977
		["name"] = "FM_storage_frame", -- models/free-market.can:1977
		["direction"] = "vertical" -- models/free-market.can:1977
	}) -- models/free-market.can:1977
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1978
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1979
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1980
	flow["add"]({ -- models/free-market.can:1981
		["type"] = "label", -- models/free-market.can:1982
		["style"] = "frame_title", -- models/free-market.can:1983
		["caption"] = { "description.storage" }, -- models/free-market.can:1984
		["ignored_by_interaction"] = true -- models/free-market.can:1985
	}) -- models/free-market.can:1985
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1987
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1988
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1989
		["type"] = "frame", -- models/free-market.can:1989
		["name"] = "shallow_frame", -- models/free-market.can:1989
		["style"] = "inside_shallow_frame", -- models/free-market.can:1989
		["direction"] = "vertical" -- models/free-market.can:1989
	}) -- models/free-market.can:1989
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1990
		["type"] = "flow", -- models/free-market.can:1990
		["name"] = "content_flow", -- models/free-market.can:1990
		["direction"] = "vertical" -- models/free-market.can:1990
	}) -- models/free-market.can:1990
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1991
	local scroll_pane = content_flow["add"](SCROLL_PANE) -- models/free-market.can:1993
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1994
	local storage_table = scroll_pane["add"]({ -- models/free-market.can:1995
		["type"] = "table", -- models/free-market.can:1995
		["name"] = "FM_storage_table", -- models/free-market.can:1995
		["column_count"] = 2 -- models/free-market.can:1995
	}) -- models/free-market.can:1995
	storage_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1996
	storage_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1997
	storage_table["style"]["top_margin"] = - 16 -- models/free-market.can:1998
	storage_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1999
	storage_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2000
	storage_table["draw_horizontal_lines"] = true -- models/free-market.can:2001
	storage_table["draw_vertical_lines"] = true -- models/free-market.can:2002
	make_storage_header(storage_table) -- models/free-market.can:2003
	local add = storage_table["add"] -- models/free-market.can:2005
	for item_name, count in pairs(__storages[player["force_index"]]) do -- models/free-market.can:2006
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2007
		add(LABEL)["caption"] = tostring(count) -- models/free-market.can:2008
	end -- models/free-market.can:2008
	main_frame["force_auto_center"]() -- models/free-market.can:2011
end -- models/free-market.can:2011
local function open_price_list_gui(player) -- models/free-market.can:2014
	local screen = player["gui"]["screen"] -- models/free-market.can:2015
	if screen["FM_price_list_frame"] then -- models/free-market.can:2016
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:2017
		return  -- models/free-market.can:2018
	end -- models/free-market.can:2018
	local main_frame = screen["add"]({ -- models/free-market.can:2020
		["type"] = "frame", -- models/free-market.can:2020
		["name"] = "FM_price_list_frame", -- models/free-market.can:2020
		["direction"] = "vertical" -- models/free-market.can:2020
	}) -- models/free-market.can:2020
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:2021
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:2022
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:2023
	flow["add"]({ -- models/free-market.can:2024
		["type"] = "label", -- models/free-market.can:2025
		["style"] = "frame_title", -- models/free-market.can:2026
		["caption"] = { "free-market.price-list" }, -- models/free-market.can:2027
		["ignored_by_interaction"] = true -- models/free-market.can:2028
	}) -- models/free-market.can:2028
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:2030
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:2031
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:2032
		["type"] = "frame", -- models/free-market.can:2032
		["name"] = "shallow_frame", -- models/free-market.can:2032
		["style"] = "inside_shallow_frame", -- models/free-market.can:2032
		["direction"] = "vertical" -- models/free-market.can:2032
	}) -- models/free-market.can:2032
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:2033
		["type"] = "flow", -- models/free-market.can:2033
		["name"] = "content_flow", -- models/free-market.can:2033
		["direction"] = "vertical" -- models/free-market.can:2033
	}) -- models/free-market.can:2033
	content_flow["style"]["padding"] = 12 -- models/free-market.can:2034
	local team_row = content_flow["add"](FLOW) -- models/free-market.can:2036
	team_row["name"] = "team_row" -- models/free-market.can:2037
	team_row["add"](LABEL)["caption"] = { -- models/free-market.can:2038
		"", -- models/free-market.can:2038
		{ "team" }, -- models/free-market.can:2038
		COLON -- models/free-market.can:2038
	} -- models/free-market.can:2038
	local items = {} -- models/free-market.can:2039
	local size = 0 -- models/free-market.can:2040
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:2041
		local force_index = force["index"] -- models/free-market.can:2042
		local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:2043
		local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:2044
		if (f_sell_prices and next(f_sell_prices)) or (f_buy_prices and next(f_buy_prices)) then -- models/free-market.can:2045
			size = size + 1 -- models/free-market.can:2046
			items[size] = force_name -- models/free-market.can:2047
		end -- models/free-market.can:2047
	end -- models/free-market.can:2047
	team_row["add"]({ -- models/free-market.can:2050
		["type"] = "drop-down", -- models/free-market.can:2050
		["name"] = "FM_force_price_list", -- models/free-market.can:2050
		["items"] = items -- models/free-market.can:2050
	}) -- models/free-market.can:2050
	local search_row = content_flow["add"]({ -- models/free-market.can:2052
		["type"] = "table", -- models/free-market.can:2052
		["name"] = "search_row", -- models/free-market.can:2052
		["column_count"] = 4 -- models/free-market.can:2052
	}) -- models/free-market.can:2052
	search_row["add"]({ -- models/free-market.can:2053
		["type"] = "textfield", -- models/free-market.can:2053
		["name"] = "FM_search_text" -- models/free-market.can:2053
	}) -- models/free-market.can:2053
	search_row["add"](LABEL)["caption"] = { -- models/free-market.can:2054
		"", -- models/free-market.can:2054
		{ "gui.search" }, -- models/free-market.can:2054
		COLON -- models/free-market.can:2054
	} -- models/free-market.can:2054
	search_row["add"]({ -- models/free-market.can:2055
		["type"] = "drop-down", -- models/free-market.can:2056
		["name"] = "FM_search_price_drop_down", -- models/free-market.can:2057
		["items"] = { -- models/free-market.can:2058
			{ "free-market.sell-offer-gui" }, -- models/free-market.can:2058
			{ "free-market.buy-request-gui" } -- models/free-market.can:2058
		} -- models/free-market.can:2058
	}) -- models/free-market.can:2058
	search_row["add"]({ -- models/free-market.can:2060
		["type"] = "sprite-button", -- models/free-market.can:2061
		["style"] = "frame_action_button", -- models/free-market.can:2062
		["name"] = "FM_search_by_price", -- models/free-market.can:2063
		["hovered_sprite"] = "utility/search_black", -- models/free-market.can:2064
		["clicked_sprite"] = "utility/search_black", -- models/free-market.can:2065
		["sprite"] = "utility/search_white" -- models/free-market.can:2066
	}) -- models/free-market.can:2066
	local prices_frame = content_flow["add"]({ -- models/free-market.can:2069
		["type"] = "frame", -- models/free-market.can:2069
		["name"] = "deep_frame", -- models/free-market.can:2069
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:2069
		["direction"] = "vertical" -- models/free-market.can:2069
	}) -- models/free-market.can:2069
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:2070
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:2071
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:2072
		["type"] = "table", -- models/free-market.can:2072
		["name"] = "price_list_table", -- models/free-market.can:2072
		["column_count"] = 3 -- models/free-market.can:2072
	}) -- models/free-market.can:2072
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2073
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2074
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2075
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2076
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2077
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2078
	prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2079
	prices_table["style"]["column_alignments"][5] = "center" -- models/free-market.can:2080
	prices_table["style"]["column_alignments"][6] = "center" -- models/free-market.can:2081
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2082
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:2083
	make_price_list_header(prices_table) -- models/free-market.can:2084
	local short_prices_table = scroll_pane["add"]({ -- models/free-market.can:2086
		["type"] = "table", -- models/free-market.can:2086
		["name"] = "short_price_list_table", -- models/free-market.can:2086
		["column_count"] = 2 -- models/free-market.can:2086
	}) -- models/free-market.can:2086
	short_prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2087
	short_prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2088
	short_prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2089
	short_prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2090
	short_prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2091
	short_prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2092
	short_prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2093
	short_prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2094
	short_prices_table["draw_vertical_lines"] = true -- models/free-market.can:2095
	short_prices_table["visible"] = false -- models/free-market.can:2096
	main_frame["force_auto_center"]() -- models/free-market.can:2098
end -- models/free-market.can:2098
local function open_buy_box_gui(player, is_new, entity) -- models/free-market.can:2104
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2105
	box_operations["clear"]() -- models/free-market.can:2106
	if box_operations["buy_content"] and not is_new then -- models/free-market.can:2107
		return  -- models/free-market.can:2108
	end -- models/free-market.can:2108
	local row = box_operations["add"]({ -- models/free-market.can:2111
		["type"] = "table", -- models/free-market.can:2111
		["name"] = "buy_content", -- models/free-market.can:2111
		["column_count"] = 4 -- models/free-market.can:2111
	}) -- models/free-market.can:2111
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2112
	row["add"]({ -- models/free-market.can:2113
		["type"] = "label", -- models/free-market.can:2113
		["caption"] = { -- models/free-market.can:2113
			"", -- models/free-market.can:2113
			{ "free-market.count-gui" }, -- models/free-market.can:2113
			COLON -- models/free-market.can:2113
		} -- models/free-market.can:2113
	}) -- models/free-market.can:2113
	local count_element = row["add"]({ -- models/free-market.can:2114
		["type"] = "textfield", -- models/free-market.can:2114
		["name"] = "count", -- models/free-market.can:2114
		["numeric"] = true, -- models/free-market.can:2114
		["allow_decimal"] = false, -- models/free-market.can:2114
		["allow_negative"] = false -- models/free-market.can:2114
	}) -- models/free-market.can:2114
	count_element["style"]["width"] = 70 -- models/free-market.can:2115
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2116
	if is_new then -- models/free-market.can:2117
		confirm_button["name"] = "FM_confirm_buy_box" -- models/free-market.can:2118
	else -- models/free-market.can:2118
		confirm_button["name"] = "FM_change_buy_box" -- models/free-market.can:2120
		local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:2121
		local entities_data = box_data[4] -- models/free-market.can:2122
		for i = 1, # entities_data do -- models/free-market.can:2123
			local buy_box = entities_data[i] -- models/free-market.can:2124
			if buy_box[1] == entity then -- models/free-market.can:2125
				count_element["text"] = tostring(buy_box[2]) -- models/free-market.can:2126
				break -- models/free-market.can:2127
			end -- models/free-market.can:2127
		end -- models/free-market.can:2127
		local item_name = box_data[5] -- models/free-market.can:2130
		FM_item["elem_value"] = item_name -- models/free-market.can:2131
	end -- models/free-market.can:2131
end -- models/free-market.can:2131
local function clear_boxes_gui(player) -- models/free-market.can:2135
	__open_box[player["index"]] = nil -- models/free-market.can:2136
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:2137
end -- models/free-market.can:2137
local function open_transfer_box_gui(player, is_new, entity) -- models/free-market.can:2143
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2144
	box_operations["clear"]() -- models/free-market.can:2145
	if box_operations["transfer_content"] and not is_new then -- models/free-market.can:2146
		return  -- models/free-market.can:2147
	end -- models/free-market.can:2147
	local row = box_operations["add"]({ -- models/free-market.can:2150
		["type"] = "table", -- models/free-market.can:2150
		["name"] = "transfer_content", -- models/free-market.can:2150
		["column_count"] = 2 -- models/free-market.can:2150
	}) -- models/free-market.can:2150
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2151
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2152
	if is_new then -- models/free-market.can:2153
		confirm_button["name"] = "FM_confirm_transfer_box" -- models/free-market.can:2154
	else -- models/free-market.can:2154
		confirm_button["name"] = "FM_change_transfer_box" -- models/free-market.can:2156
		FM_item["elem_value"] = __all_boxes[entity["unit_number"]][5] -- models/free-market.can:2157
	end -- models/free-market.can:2157
end -- models/free-market.can:2157
local function open_bin_box_gui(player, is_new, entity) -- models/free-market.can:2164
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2165
	box_operations["clear"]() -- models/free-market.can:2166
	if box_operations["bin_content"] and not is_new then -- models/free-market.can:2167
		return  -- models/free-market.can:2168
	end -- models/free-market.can:2168
	local row = box_operations["add"]({ -- models/free-market.can:2171
		["type"] = "table", -- models/free-market.can:2171
		["name"] = "bin_content", -- models/free-market.can:2171
		["column_count"] = 2 -- models/free-market.can:2171
	}) -- models/free-market.can:2171
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2172
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2173
	if is_new then -- models/free-market.can:2174
		confirm_button["name"] = "FM_confirm_bin_box" -- models/free-market.can:2175
	else -- models/free-market.can:2175
		confirm_button["name"] = "FM_change_bin_box" -- models/free-market.can:2177
		FM_item["elem_value"] = __all_boxes[entity["unit_number"]][5] -- models/free-market.can:2178
	end -- models/free-market.can:2178
end -- models/free-market.can:2178
local function create_top_relative_gui(player) -- models/free-market.can:2182
	local relative = player["gui"]["relative"] -- models/free-market.can:2183
	local main_frame = relative["FM_boxes_frame"] -- models/free-market.can:2184
	if main_frame then -- models/free-market.can:2185
		main_frame["destroy"]() -- models/free-market.can:2186
	end -- models/free-market.can:2186
	local boxes_anchor = { -- models/free-market.can:2189
		["gui"] = defines["relative_gui_type"]["container_gui"], -- models/free-market.can:2189
		["position"] = defines["relative_gui_position"]["top"] -- models/free-market.can:2189
	} -- models/free-market.can:2189
	main_frame = relative["add"]({ -- models/free-market.can:2190
		["type"] = "frame", -- models/free-market.can:2190
		["name"] = "FM_boxes_frame", -- models/free-market.can:2190
		["anchor"] = boxes_anchor -- models/free-market.can:2190
	}) -- models/free-market.can:2190
	main_frame["style"]["vertical_align"] = "center" -- models/free-market.can:2191
	main_frame["style"]["horizontally_stretchable"] = false -- models/free-market.can:2192
	main_frame["style"]["bottom_margin"] = - 14 -- models/free-market.can:2193
	local frame = main_frame["add"]({ -- models/free-market.can:2194
		["type"] = "frame", -- models/free-market.can:2194
		["name"] = "content", -- models/free-market.can:2194
		["style"] = "inside_shallow_frame" -- models/free-market.can:2194
	}) -- models/free-market.can:2194
	local main_flow = frame["add"]({ -- models/free-market.can:2195
		["type"] = "flow", -- models/free-market.can:2195
		["name"] = "main_flow", -- models/free-market.can:2195
		["direction"] = "vertical" -- models/free-market.can:2195
	}) -- models/free-market.can:2195
	main_flow["style"]["vertical_spacing"] = 0 -- models/free-market.can:2196
	main_flow["add"](FLOW)["name"] = "box_operations" -- models/free-market.can:2197
	local flow = main_flow["add"](FLOW) -- models/free-market.can:2198
	flow["add"]({ -- models/free-market.can:2199
		["type"] = "button", -- models/free-market.can:2199
		["style"] = "FM_transfer_button", -- models/free-market.can:2199
		["name"] = "FM_set_transfer_box" -- models/free-market.can:2199
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2199
	flow["add"]({ -- models/free-market.can:2200
		["type"] = "button", -- models/free-market.can:2200
		["style"] = "FM_universal_transfer_button", -- models/free-market.can:2200
		["name"] = "FM_set_universal_transfer_box" -- models/free-market.can:2200
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2200
	flow["add"]({ -- models/free-market.can:2201
		["type"] = "button", -- models/free-market.can:2201
		["style"] = "FM_bin_button", -- models/free-market.can:2201
		["name"] = "FM_set_bin_box" -- models/free-market.can:2201
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2201
	flow["add"]({ -- models/free-market.can:2202
		["type"] = "button", -- models/free-market.can:2202
		["style"] = "FM_universal_bin_button", -- models/free-market.can:2202
		["name"] = "FM_set_universal_bin_box" -- models/free-market.can:2202
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2202
	flow["add"]({ -- models/free-market.can:2203
		["type"] = "button", -- models/free-market.can:2203
		["style"] = "FM_pull_out_button", -- models/free-market.can:2203
		["name"] = "FM_set_pull_box" -- models/free-market.can:2203
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2203
	flow["add"]({ -- models/free-market.can:2204
		["type"] = "button", -- models/free-market.can:2204
		["style"] = "FM_buy_button", -- models/free-market.can:2204
		["name"] = "FM_set_buy_box" -- models/free-market.can:2204
	}) -- models/free-market.can:2204
end -- models/free-market.can:2204
local function open_pull_box_gui(player, is_new, entity) -- models/free-market.can:2210
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2211
	box_operations["clear"]() -- models/free-market.can:2212
	if box_operations["pull_content"] then -- models/free-market.can:2213
		return  -- models/free-market.can:2214
	end -- models/free-market.can:2214
	local row = box_operations["add"]({ -- models/free-market.can:2216
		["type"] = "table", -- models/free-market.can:2216
		["name"] = "pull_content", -- models/free-market.can:2216
		["column_count"] = 2 -- models/free-market.can:2216
	}) -- models/free-market.can:2216
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2217
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2218
	if is_new then -- models/free-market.can:2219
		confirm_button["name"] = "FM_confirm_pull_box" -- models/free-market.can:2220
	else -- models/free-market.can:2220
		confirm_button["name"] = "FM_change_pull_box" -- models/free-market.can:2222
		FM_item["elem_value"] = __all_boxes[entity["unit_number"]][5] -- models/free-market.can:2223
	end -- models/free-market.can:2223
end -- models/free-market.can:2223
local function create_left_relative_gui(player) -- models/free-market.can:2227
	local relative = player["gui"]["relative"] -- models/free-market.can:2228
	local main_table = relative["FM_buttons"] -- models/free-market.can:2229
	if main_table then -- models/free-market.can:2230
		main_table["destroy"]() -- models/free-market.can:2231
	end -- models/free-market.can:2231
	local left_anchor = { -- models/free-market.can:2234
		["gui"] = defines["relative_gui_type"]["controller_gui"], -- models/free-market.can:2234
		["position"] = defines["relative_gui_position"]["left"] -- models/free-market.can:2234
	} -- models/free-market.can:2234
	main_table = relative["add"]({ -- models/free-market.can:2235
		["type"] = "table", -- models/free-market.can:2235
		["name"] = "FM_buttons", -- models/free-market.can:2235
		["anchor"] = left_anchor, -- models/free-market.can:2235
		["column_count"] = 2 -- models/free-market.can:2235
	}) -- models/free-market.can:2235
	main_table["style"]["vertical_align"] = "center" -- models/free-market.can:2236
	main_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2237
	main_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2238
	local button = main_table["add"]({ -- models/free-market.can:2240
		["type"] = "button", -- models/free-market.can:2240
		["style"] = "side_menu_button", -- models/free-market.can:2240
		["caption"] = ">", -- models/free-market.can:2240
		["name"] = "FM_hide_left_buttons" -- models/free-market.can:2240
	}) -- models/free-market.can:2240
	button["style"]["font"] = "default-dialog-button" -- models/free-market.can:2241
	button["style"]["font_color"] = WHITE_COLOR -- models/free-market.can:2242
	button["style"]["top_padding"] = - 4 -- models/free-market.can:2243
	button["style"]["width"] = 18 -- models/free-market.can:2244
	button["style"]["height"] = 20 -- models/free-market.can:2245
	local frame = main_table["add"]({ -- models/free-market.can:2247
		["type"] = "frame", -- models/free-market.can:2247
		["name"] = "content" -- models/free-market.can:2247
	}) -- models/free-market.can:2247
	frame["style"]["right_margin"] = - 14 -- models/free-market.can:2248
	local shallow_frame = frame["add"]({ -- models/free-market.can:2249
		["type"] = "frame", -- models/free-market.can:2249
		["name"] = "shallow_frame", -- models/free-market.can:2249
		["style"] = "inside_shallow_frame" -- models/free-market.can:2249
	}) -- models/free-market.can:2249
	local buttons_table = shallow_frame["add"]({ -- models/free-market.can:2250
		["type"] = "table", -- models/free-market.can:2250
		["column_count"] = 3 -- models/free-market.can:2250
	}) -- models/free-market.can:2250
	buttons_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2251
	buttons_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2252
	buttons_table["add"]({ -- models/free-market.can:2253
		["type"] = "sprite-button", -- models/free-market.can:2253
		["sprite"] = "FM_change-price", -- models/free-market.can:2253
		["style"] = "slot_button", -- models/free-market.can:2253
		["name"] = "FM_open_price" -- models/free-market.can:2253
	}) -- models/free-market.can:2253
	buttons_table["add"]({ -- models/free-market.can:2254
		["type"] = "sprite-button", -- models/free-market.can:2254
		["sprite"] = "FM_see-prices", -- models/free-market.can:2254
		["style"] = "slot_button", -- models/free-market.can:2254
		["name"] = "FM_open_price_list" -- models/free-market.can:2254
	}) -- models/free-market.can:2254
	buttons_table["add"]({ -- models/free-market.can:2255
		["type"] = "sprite-button", -- models/free-market.can:2255
		["sprite"] = "FM_embargo", -- models/free-market.can:2255
		["style"] = "slot_button", -- models/free-market.can:2255
		["name"] = "FM_open_embargo" -- models/free-market.can:2255
	}) -- models/free-market.can:2255
	buttons_table["add"]({ -- models/free-market.can:2256
		["type"] = "sprite-button", -- models/free-market.can:2256
		["sprite"] = "item/wooden-chest", -- models/free-market.can:2256
		["style"] = "slot_button", -- models/free-market.can:2256
		["name"] = "FM_open_storage" -- models/free-market.can:2256
	}) -- models/free-market.can:2256
	buttons_table["add"]({ -- models/free-market.can:2257
		["type"] = "sprite-button", -- models/free-market.can:2257
		["sprite"] = "virtual-signal/signal-info", -- models/free-market.can:2257
		["style"] = "slot_button", -- models/free-market.can:2257
		["name"] = "FM_show_hint" -- models/free-market.can:2257
	}) -- models/free-market.can:2257
	buttons_table["add"]({ -- models/free-market.can:2258
		["type"] = "sprite-button", -- models/free-market.can:2259
		["sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2260
		["hovered_sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2261
		["clicked_sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2262
		["style"] = "slot_button", -- models/free-market.can:2263
		["name"] = "FM_open_force_configuration" -- models/free-market.can:2264
	}) -- models/free-market.can:2264
end -- models/free-market.can:2264
local function check_buy_price(player, item_name) -- models/free-market.can:2270
	local force_index = player["force_index"] -- models/free-market.can:2271
	if __buy_prices[force_index][item_name] == nil then -- models/free-market.can:2272
		local screen = player["gui"]["screen"] -- models/free-market.can:2273
		local prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2274
		local content_flow -- models/free-market.can:2275
		if prices_frame == nil then -- models/free-market.can:2276
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2277
			prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2278
		else -- models/free-market.can:2278
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2280
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2281
			local sell_price = __sell_prices[force_index][item_name] -- models/free-market.can:2282
			if sell_price then -- models/free-market.can:2283
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:2284
			end -- models/free-market.can:2284
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2286
		end -- models/free-market.can:2286
		content_flow["item_row"]["buy_price"]["focus"]() -- models/free-market.can:2288
	end -- models/free-market.can:2288
end -- models/free-market.can:2288
local function check_sell_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2295
	local force_index = player["force_index"] -- models/free-market.can:2296
	local sell_price = __sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] -- models/free-market.can:2297
	if sell_price then -- models/free-market.can:2298
		return  -- models/free-market.can:2298
	end -- models/free-market.can:2298
	local row = gui["add"]({ -- models/free-market.can:2300
		["type"] = "table", -- models/free-market.can:2300
		["name"] = "sell_price_table", -- models/free-market.can:2300
		["column_count"] = 4 -- models/free-market.can:2300
	}) -- models/free-market.can:2300
	local add = row["add"] -- models/free-market.can:2301
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2302
	add(LABEL)["caption"] = { -- models/free-market.can:2303
		"", -- models/free-market.can:2303
		{ "free-market.sell-price-label" }, -- models/free-market.can:2303
		COLON -- models/free-market.can:2303
	} -- models/free-market.can:2303
	add(SELL_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2304
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price_for_chest" -- models/free-market.can:2305
end -- models/free-market.can:2305
local function check_buy_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2311
	local force_index = player["force_index"] -- models/free-market.can:2312
	local buy_price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:2313
	if buy_price then -- models/free-market.can:2314
		return  -- models/free-market.can:2314
	end -- models/free-market.can:2314
	local row = gui["add"]({ -- models/free-market.can:2316
		["type"] = "table", -- models/free-market.can:2316
		["name"] = "buy_price_table", -- models/free-market.can:2316
		["column_count"] = 4 -- models/free-market.can:2316
	}) -- models/free-market.can:2316
	local add = row["add"] -- models/free-market.can:2317
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2318
	add(LABEL)["caption"] = { -- models/free-market.can:2319
		"", -- models/free-market.can:2319
		{ "free-market.buy-price-label" }, -- models/free-market.can:2319
		COLON -- models/free-market.can:2319
	} -- models/free-market.can:2319
	add(BUY_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2320
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price_for_chest" -- models/free-market.can:2321
end -- models/free-market.can:2321
local function check_sell_price(player, item_name) -- models/free-market.can:2326
	local force_index = player["force_index"] -- models/free-market.can:2327
	if __sell_prices[force_index][item_name] == nil then -- models/free-market.can:2328
		local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2329
		local content_flow -- models/free-market.can:2330
		if prices_frame == nil then -- models/free-market.can:2331
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2332
			prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2333
		else -- models/free-market.can:2333
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2335
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2336
			local buy_price = __buy_prices[force_index][item_name] -- models/free-market.can:2337
			if buy_price then -- models/free-market.can:2338
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:2339
			end -- models/free-market.can:2339
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2341
		end -- models/free-market.can:2341
		content_flow["item_row"]["sell_price"]["focus"]() -- models/free-market.can:2343
	end -- models/free-market.can:2343
end -- models/free-market.can:2343
create_item_price_HUD = function(player) -- models/free-market.can:2348
	local screen = player["gui"]["screen"] -- models/free-market.can:2349
	local main_frame = screen["FM_item_price_frame"] -- models/free-market.can:2350
	if main_frame then -- models/free-market.can:2351
		return  -- models/free-market.can:2352
	end -- models/free-market.can:2352
	main_frame = screen["add"]({ -- models/free-market.can:2355
		["type"] = "frame", -- models/free-market.can:2355
		["name"] = "FM_item_price_frame", -- models/free-market.can:2355
		["style"] = "FM_item_price_frame", -- models/free-market.can:2355
		["direction"] = "horizontal" -- models/free-market.can:2355
	}) -- models/free-market.can:2355
	main_frame["location"] = { -- models/free-market.can:2356
		["x"] = player["display_resolution"]["width"] / 2, -- models/free-market.can:2356
		["y"] = 10 -- models/free-market.can:2356
	} -- models/free-market.can:2356
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:2358
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:2359
	drag_handler["drag_target"] = main_frame -- models/free-market.can:2360
	drag_handler["style"]["vertically_stretchable"] = true -- models/free-market.can:2361
	drag_handler["style"]["minimal_height"] = 22 -- models/free-market.can:2362
	drag_handler["style"]["maximal_height"] = 0 -- models/free-market.can:2363
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:2364
	drag_handler["style"]["width"] = 10 -- models/free-market.can:2365
	local info_flow = main_frame["add"](VERTICAL_FLOW) -- models/free-market.can:2367
	info_flow["visible"] = false -- models/free-market.can:2368
	local hud_table = info_flow["add"]({ -- models/free-market.can:2369
		["type"] = "table", -- models/free-market.can:2369
		["column_count"] = 2 -- models/free-market.can:2369
	}) -- models/free-market.can:2369
	local add = hud_table["add"] -- models/free-market.can:2370
	hud_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2371
	hud_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2372
	add(LABEL)["caption"] = { -- models/free-market.can:2374
		"", -- models/free-market.can:2374
		{ "free-market.sell-price-label" }, -- models/free-market.can:2374
		COLON -- models/free-market.can:2374
	} -- models/free-market.can:2374
	local sell_price = add(LABEL) -- models/free-market.can:2375
	add(LABEL)["caption"] = { -- models/free-market.can:2377
		"", -- models/free-market.can:2377
		{ "free-market.buy-price-label" }, -- models/free-market.can:2377
		COLON -- models/free-market.can:2377
	} -- models/free-market.can:2377
	local buy_price = add(LABEL) -- models/free-market.can:2378
	local storage_flow = info_flow["add"](FLOW) -- models/free-market.can:2381
	local add = storage_flow["add"] -- models/free-market.can:2382
	local item_label = add(LABEL) -- models/free-market.can:2383
	add(LABEL)["caption"] = { -- models/free-market.can:2384
		"", -- models/free-market.can:2384
		{ "description.storage" }, -- models/free-market.can:2384
		COLON -- models/free-market.can:2384
	} -- models/free-market.can:2384
	local storage_count = add(LABEL) -- models/free-market.can:2385
	add(LABEL)["caption"] = "/" -- models/free-market.can:2387
	local storage_limit = add(LABEL) -- models/free-market.can:2388
	__item_HUD[player["index"]] = { -- models/free-market.can:2391
		info_flow, -- models/free-market.can:2392
		sell_price, -- models/free-market.can:2393
		buy_price, -- models/free-market.can:2394
		item_label, -- models/free-market.can:2395
		storage_count, -- models/free-market.can:2396
		storage_limit -- models/free-market.can:2397
	} -- models/free-market.can:2397
end -- models/free-market.can:2397
local function hide_item_price_HUD(player) -- models/free-market.can:2402
	local hinter = __item_HUD[player["index"]] -- models/free-market.can:2403
	if hinter then -- models/free-market.can:2404
		hinter[1]["visible"] = false -- models/free-market.can:2405
	end -- models/free-market.can:2405
end -- models/free-market.can:2405
local function show_item_info_HUD(player, item_name) -- models/free-market.can:2411
	local force_index = player["force_index"] -- models/free-market.can:2412
	local sell_price = __sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] -- models/free-market.can:2413
	local buy_price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:2414
	local count = __storages[force_index][item_name] -- models/free-market.can:2415
	local limit = __storages_limit[force_index][item_name] or __default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2416
	local hinter = __item_HUD[player["index"]] -- models/free-market.can:2418
	hinter[1]["visible"] = true -- models/free-market.can:2419
	if sell_price then -- models/free-market.can:2420
		hinter[2]["caption"] = tostring(sell_price) -- models/free-market.can:2421
	else -- models/free-market.can:2421
		hinter[2]["caption"] = "" -- models/free-market.can:2423
	end -- models/free-market.can:2423
	if buy_price then -- models/free-market.can:2425
		hinter[3]["caption"] = tostring(buy_price) -- models/free-market.can:2426
	else -- models/free-market.can:2426
		hinter[3]["caption"] = "" -- models/free-market.can:2428
	end -- models/free-market.can:2428
	hinter[4]["caption"] = "[item=" .. item_name .. "]" -- models/free-market.can:2430
	if count then -- models/free-market.can:2431
		hinter[5]["caption"] = tostring(count) -- models/free-market.can:2432
	else -- models/free-market.can:2432
		hinter[5]["caption"] = "0" -- models/free-market.can:2434
	end -- models/free-market.can:2434
	hinter[6]["caption"] = limit -- models/free-market.can:2436
end -- models/free-market.can:2436
local REMOVE_BOX_FUNCS = { -- models/free-market.can:2444
	[1] = remove_certain_buy_box, -- models/free-market.can:2445
	[3] = remove_certain_pull_box, -- models/free-market.can:2446
	[4] = remove_certain_transfer_box, -- models/free-market.can:2447
	[5] = remove_certain_universal_transfer_box, -- models/free-market.can:2448
	[6] = remove_certain_bin_box, -- models/free-market.can:2449
	[7] = remove_certain_universal_bin_box -- models/free-market.can:2450
} -- models/free-market.can:2450
local function clear_box_data(event) -- models/free-market.can:2452
	local entity = event["entity"] -- models/free-market.can:2453
	local unit_number = entity["unit_number"] -- models/free-market.can:2454
	local box_data = __all_boxes[unit_number] -- models/free-market.can:2455
	if box_data == nil then -- models/free-market.can:2456
		return  -- models/free-market.can:2456
	end -- models/free-market.can:2456
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2458
end -- models/free-market.can:2458
local function clear_box_data_by_entity(entity) -- models/free-market.can:2462
	local unit_number = entity["unit_number"] -- models/free-market.can:2463
	local box_data = __all_boxes[unit_number] -- models/free-market.can:2464
	if box_data == nil then -- models/free-market.can:2465
		return  -- models/free-market.can:2465
	end -- models/free-market.can:2465
	local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:2467
	rendered["destroy"]() -- models/free-market.can:2468
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2469
	return true -- models/free-market.can:2470
end -- models/free-market.can:2470
local function on_player_created(event) -- models/free-market.can:2473
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2474
	if not (player and player["valid"]) then -- models/free-market.can:2475
		return  -- models/free-market.can:2475
	end -- models/free-market.can:2475
	create_top_relative_gui(player) -- models/free-market.can:2477
	create_left_relative_gui(player) -- models/free-market.can:2478
	switch_sell_prices_gui(player) -- models/free-market.can:2479
	switch_buy_prices_gui(player) -- models/free-market.can:2480
	if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2481
		create_item_price_HUD(player) -- models/free-market.can:2482
	end -- models/free-market.can:2482
end -- models/free-market.can:2482
local function on_player_joined_game(event) -- models/free-market.can:2487
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2488
	if not (player and player["valid"]) then -- models/free-market.can:2489
		return  -- models/free-market.can:2489
	end -- models/free-market.can:2489
	if # game["connected_players"] == 1 then -- models/free-market.can:2491
		clear_invalid_player_data() -- models/free-market.can:2492
		detect_desync() -- models/free-market.can:2493
	end -- models/free-market.can:2493
	clear_boxes_gui(player) -- models/free-market.can:2496
	destroy_prices_gui(player) -- models/free-market.can:2497
	destroy_price_list_gui(player) -- models/free-market.can:2498
	create_item_price_HUD(player) -- models/free-market.can:2499
end -- models/free-market.can:2499
local function on_player_cursor_stack_changed(event) -- models/free-market.can:2521
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2522
	local cursor_stack = player["cursor_stack"] -- models/free-market.can:2523
	if cursor_stack["valid_for_read"] then -- models/free-market.can:2524
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2525
			show_item_info_HUD(player, cursor_stack["name"]) -- models/free-market.can:2526
		end -- models/free-market.can:2526
	else -- models/free-market.can:2526
		hide_item_price_HUD(player) -- models/free-market.can:2529
	end -- models/free-market.can:2529
end -- models/free-market.can:2529
local function on_force_created(event) -- models/free-market.can:2533
	local force = event["force"] -- models/free-market.can:2534
	if force["valid"] then -- models/free-market.can:2535
		init_force_data(force["index"]) -- models/free-market.can:2536
	end -- models/free-market.can:2536
end -- models/free-market.can:2536
local function check_teams_data() -- models/free-market.can:2540
	for _, storage in pairs(__storages) do -- models/free-market.can:2541
		for item_name, count in pairs(storage) do -- models/free-market.can:2542
			if count == 0 then -- models/free-market.can:2543
				storage[item_name] = nil -- models/free-market.can:2544
			end -- models/free-market.can:2544
		end -- models/free-market.can:2544
	end -- models/free-market.can:2544
end -- models/free-market.can:2544
local function check_forces() -- models/free-market.can:2550
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:2551
	local neutral_force = game["forces"]["neutral"] -- models/free-market.can:2553
	__mod_data["active_forces"] = {} -- models/free-market.can:2554
	__active_forces = __mod_data["active_forces"] -- models/free-market.can:2555
	local size = 0 -- models/free-market.can:2556
	for _, force in pairs(game["forces"]) do -- models/free-market.can:2558
		if # force["connected_players"] > 0 then -- models/free-market.can:2559
			local force_index = force["index"] -- models/free-market.can:2560
			local items_data = __buy_boxes[force_index] -- models/free-market.can:2561
			local storage_data = __storages[force_index] -- models/free-market.can:2562
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2563
				local buyer_money = forces_money[force_index] -- models/free-market.can:2564
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2565
					size = size + 1 -- models/free-market.can:2566
					__active_forces[size] = force_index -- models/free-market.can:2567
				end -- models/free-market.can:2567
			end -- models/free-market.can:2567
		elseif math["random"](99) > skip_offline_team_chance or force == neutral_force then -- models/free-market.can:2570
			local force_index = force["index"] -- models/free-market.can:2571
			local items_data = __buy_boxes[force_index] -- models/free-market.can:2572
			local storage_data = __storages[force_index] -- models/free-market.can:2573
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2574
				local buyer_money = forces_money[force_index] -- models/free-market.can:2575
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2576
					size = size + 1 -- models/free-market.can:2577
					__active_forces[size] = force_index -- models/free-market.can:2578
				end -- models/free-market.can:2578
			end -- models/free-market.can:2578
		end -- models/free-market.can:2578
	end -- models/free-market.can:2578
	if # __active_forces < 2 then -- models/free-market.can:2584
		__mod_data["active_forces"] = {} -- models/free-market.can:2585
		__active_forces = __mod_data["active_forces"] -- models/free-market.can:2586
	end -- models/free-market.can:2586
end -- models/free-market.can:2586
local function on_forces_merging(event) -- models/free-market.can:2594
	local source = event["source"] -- models/free-market.can:2595
	local source_index = source["index"] -- models/free-market.can:2596
	local source_storage = __storages[source_index] -- models/free-market.can:2598
	if source_storage then -- models/free-market.can:2599
		local destination_index = event["destination"]["index"] -- models/free-market.can:2600
		local destination_storage = __storages[destination_index] -- models/free-market.can:2601
		if destination_storage == nil then -- models/free-market.can:2602
			init_force_data(destination_index) -- models/free-market.can:2603
			destination_storage = __storages[destination_index] -- models/free-market.can:2604
		end -- models/free-market.can:2604
		for item_name, count in pairs(source_storage) do -- models/free-market.can:2606
			destination_storage[item_name] = count + (destination_storage[item_name] or 0) -- models/free-market.can:2607
		end -- models/free-market.can:2607
	end -- models/free-market.can:2607
	clear_force_data(source_index) -- models/free-market.can:2610
	local ids = rendering["get_all_objects"]() -- models/free-market.can:2612
	for i = 1, # ids do -- models/free-market.can:2613
		local rendered = get_rendered_by_id(ids[i]) -- models/free-market.can:2614
		if rendered["valid"] then -- models/free-market.can:2615
			local target = rendered["target"] -- models/free-market.can:2616
			if target then -- models/free-market.can:2617
				local entity = target["entity"] -- models/free-market.can:2618
				if (not (entity and entity["valid"]) or entity["force"] == source) and rendered["type"] == "text" then -- models/free-market.can:2619
					rendered["destroy"]() -- models/free-market.can:2620
					__all_boxes[entity["unit_number"]] = nil -- models/free-market.can:2621
				end -- models/free-market.can:2621
			end -- models/free-market.can:2621
		end -- models/free-market.can:2621
	end -- models/free-market.can:2621
	check_forces() -- models/free-market.can:2626
end -- models/free-market.can:2626
local function on_entity_cloned(event) -- models/free-market.can:2631
	local source = event["source"] -- models/free-market.can:2632
	if not (source and source["valid"]) then -- models/free-market.can:2633
		return  -- models/free-market.can:2633
	end -- models/free-market.can:2633
	local box_data = __all_boxes[source["unit_number"]] -- models/free-market.can:2634
	if box_data == nil then -- models/free-market.can:2635
		return  -- models/free-market.can:2635
	end -- models/free-market.can:2635
	local destination = event["destination"] -- models/free-market.can:2637
	if not (destination and destination["valid"]) then -- models/free-market.can:2638
		return  -- models/free-market.can:2638
	end -- models/free-market.can:2638
	local destination_box_data = __all_boxes[destination["unit_number"]] -- models/free-market.can:2640
	if destination_box_data then -- models/free-market.can:2641
		local rendered = get_rendered_by_id(destination_box_data[2]) -- models/free-market.can:2642
		rendered["destroy"]() -- models/free-market.can:2643
		REMOVE_BOX_FUNCS[destination_box_data[3]](destination, destination_box_data) -- models/free-market.can:2644
	end -- models/free-market.can:2644
	local box_type = box_data[3] -- models/free-market.can:2647
	if box_type == 3 then -- models/free-market.can:1
		set_pull_box_data(box_data[5], destination) -- models/free-market.can:2649
	elseif box_type == 1 then -- models/free-market.can:1
		local count -- models/free-market.can:2651
		local items = box_data[4] -- models/free-market.can:2652
		for i = 1, # items do -- models/free-market.can:2653
			local buy_data = items[i] -- models/free-market.can:2654
			if buy_data[1] == source then -- models/free-market.can:2655
				count = buy_data[2] -- models/free-market.can:2656
				break -- models/free-market.can:2657
			end -- models/free-market.can:2657
		end -- models/free-market.can:2657
		set_buy_box_data(box_data[5], destination, count) -- models/free-market.can:2660
	elseif box_type == 4 then -- models/free-market.can:1
		set_transfer_box_data(box_data[5], destination) -- models/free-market.can:2662
	elseif box_type == 5 then -- models/free-market.can:1
		set_universal_transfer_box_data(destination) -- models/free-market.can:2664
	elseif box_type == 6 then -- models/free-market.can:1
		set_bin_box_data(box_data[5], destination) -- models/free-market.can:2666
	elseif box_type == 7 then -- models/free-market.can:1
		set_universal_bin_box_data(destination) -- models/free-market.can:2668
	end -- models/free-market.can:2668
end -- models/free-market.can:2668
local function on_force_cease_fire_changed(event) -- models/free-market.can:2672
	local force_index = event["force"]["index"] -- models/free-market.can:2673
	local other_force_index = event["other_force"]["index"] -- models/free-market.can:2674
	if event["added"] then -- models/free-market.can:2675
		__embargoes[force_index][other_force_index] = nil -- models/free-market.can:2676
	else -- models/free-market.can:2676
		__embargoes[force_index][other_force_index] = true -- models/free-market.can:2678
	end -- models/free-market.can:2678
end -- models/free-market.can:2678
local function set_transfer_box_key_pressed(event) -- models/free-market.can:2682
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2683
	local entity = player["selected"] -- models/free-market.can:2684
	if not (entity and entity["valid"]) then -- models/free-market.can:2685
		return  -- models/free-market.can:2685
	end -- models/free-market.can:2685
	if entity["force"] ~= player["force"] then -- models/free-market.can:2686
		return  -- models/free-market.can:2686
	end -- models/free-market.can:2686
	if not entity["operable"] then -- models/free-market.can:2687
		return  -- models/free-market.can:2687
	end -- models/free-market.can:2687
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2688
		return  -- models/free-market.can:2688
	end -- models/free-market.can:2688
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2689
		return  -- models/free-market.can:2689
	end -- models/free-market.can:2689
	local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:2691
	if box_data then -- models/free-market.can:2692
		local item_name = box_data[5] -- models/free-market.can:2693
		local box_type = box_data[3] -- models/free-market.can:2694
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2696
		elseif box_type == 4 or box_type == 5 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2698
		end -- models/free-market.can:2698
		return  -- models/free-market.can:2700
	end -- models/free-market.can:2700
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2703
	if not item["valid_for_read"] then -- models/free-market.can:2704
		player["print"]({ -- models/free-market.can:2705
			"multiplayer.no-address", -- models/free-market.can:2705
			{ "item" } -- models/free-market.can:2705
		}) -- models/free-market.can:2705
		return  -- models/free-market.can:2706
	end -- models/free-market.can:2706
	set_transfer_box_data(item["name"], entity) -- models/free-market.can:2709
end -- models/free-market.can:2709
local function set_bin_box_key_pressed(event) -- models/free-market.can:2712
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2713
	local entity = player["selected"] -- models/free-market.can:2714
	if not (entity and entity["valid"]) then -- models/free-market.can:2715
		return  -- models/free-market.can:2715
	end -- models/free-market.can:2715
	if entity["force"] ~= player["force"] then -- models/free-market.can:2716
		return  -- models/free-market.can:2716
	end -- models/free-market.can:2716
	if not entity["operable"] then -- models/free-market.can:2717
		return  -- models/free-market.can:2717
	end -- models/free-market.can:2717
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2718
		return  -- models/free-market.can:2718
	end -- models/free-market.can:2718
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2719
		return  -- models/free-market.can:2719
	end -- models/free-market.can:2719
	if __all_boxes[entity["unit_number"]] then -- models/free-market.can:2721
		return  -- models/free-market.can:2722
	end -- models/free-market.can:2722
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2725
	if not item["valid_for_read"] then -- models/free-market.can:2726
		player["print"]({ -- models/free-market.can:2727
			"multiplayer.no-address", -- models/free-market.can:2727
			{ "item" } -- models/free-market.can:2727
		}) -- models/free-market.can:2727
		return  -- models/free-market.can:2728
	end -- models/free-market.can:2728
	set_bin_box_data(item["name"], entity) -- models/free-market.can:2731
end -- models/free-market.can:2731
local function set_universal_transfer_box_key_pressed(event) -- models/free-market.can:2734
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2735
	local entity = player["selected"] -- models/free-market.can:2736
	if not (entity and entity["valid"]) then -- models/free-market.can:2737
		return  -- models/free-market.can:2737
	end -- models/free-market.can:2737
	if entity["force"] ~= player["force"] then -- models/free-market.can:2738
		return  -- models/free-market.can:2738
	end -- models/free-market.can:2738
	if not entity["operable"] then -- models/free-market.can:2739
		return  -- models/free-market.can:2739
	end -- models/free-market.can:2739
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2740
		return  -- models/free-market.can:2740
	end -- models/free-market.can:2740
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2741
		return  -- models/free-market.can:2741
	end -- models/free-market.can:2741
	local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:2743
	if box_data == nil then -- models/free-market.can:2744
		set_universal_transfer_box_data(entity) -- models/free-market.can:2745
	else -- models/free-market.can:2745
		local item_name = box_data[5] -- models/free-market.can:2747
		local box_type = box_data[3] -- models/free-market.can:2748
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2750
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2752
		end -- models/free-market.can:2752
	end -- models/free-market.can:2752
end -- models/free-market.can:2752
local function set_universal_bin_box_key_pressed(event) -- models/free-market.can:2757
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2758
	local entity = player["selected"] -- models/free-market.can:2759
	if not (entity and entity["valid"]) then -- models/free-market.can:2760
		return  -- models/free-market.can:2760
	end -- models/free-market.can:2760
	if entity["force"] ~= player["force"] then -- models/free-market.can:2761
		return  -- models/free-market.can:2761
	end -- models/free-market.can:2761
	if not entity["operable"] then -- models/free-market.can:2762
		return  -- models/free-market.can:2762
	end -- models/free-market.can:2762
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2763
		return  -- models/free-market.can:2763
	end -- models/free-market.can:2763
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2764
		return  -- models/free-market.can:2764
	end -- models/free-market.can:2764
	if __all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:2766
		set_universal_bin_box_data(entity) -- models/free-market.can:2767
	end -- models/free-market.can:2767
end -- models/free-market.can:2767
local function set_pull_box_key_pressed(event) -- models/free-market.can:2771
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2772
	local entity = player["selected"] -- models/free-market.can:2773
	if not (entity and entity["valid"]) then -- models/free-market.can:2774
		return  -- models/free-market.can:2774
	end -- models/free-market.can:2774
	if entity["force"] ~= player["force"] then -- models/free-market.can:2775
		return  -- models/free-market.can:2775
	end -- models/free-market.can:2775
	if not entity["operable"] then -- models/free-market.can:2776
		return  -- models/free-market.can:2776
	end -- models/free-market.can:2776
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2777
		return  -- models/free-market.can:2777
	end -- models/free-market.can:2777
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2778
		return  -- models/free-market.can:2778
	end -- models/free-market.can:2778
	if __all_boxes[entity["unit_number"]] then -- models/free-market.can:2780
		return  -- models/free-market.can:2781
	end -- models/free-market.can:2781
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2784
	if not item["valid_for_read"] then -- models/free-market.can:2785
		player["print"]({ -- models/free-market.can:2786
			"multiplayer.no-address", -- models/free-market.can:2786
			{ "item" } -- models/free-market.can:2786
		}) -- models/free-market.can:2786
		return  -- models/free-market.can:2787
	end -- models/free-market.can:2787
	set_pull_box_data(item["name"], entity) -- models/free-market.can:2790
end -- models/free-market.can:2790
local function set_buy_box_key_pressed(event) -- models/free-market.can:2793
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2794
	local entity = player["selected"] -- models/free-market.can:2795
	if not (entity and entity["valid"]) then -- models/free-market.can:2796
		return  -- models/free-market.can:2796
	end -- models/free-market.can:2796
	if entity["force"] ~= player["force"] then -- models/free-market.can:2797
		return  -- models/free-market.can:2797
	end -- models/free-market.can:2797
	if not entity["operable"] then -- models/free-market.can:2798
		return  -- models/free-market.can:2798
	end -- models/free-market.can:2798
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:2799
		return  -- models/free-market.can:2799
	end -- models/free-market.can:2799
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2800
		return  -- models/free-market.can:2800
	end -- models/free-market.can:2800
	local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:2802
	if box_data then -- models/free-market.can:2803
		local item_name = box_data[5] -- models/free-market.can:2804
		local box_type = box_data[3] -- models/free-market.can:2805
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2807
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2809
		end -- models/free-market.can:2809
		return  -- models/free-market.can:2811
	end -- models/free-market.can:2811
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2814
	if not item["valid_for_read"] then -- models/free-market.can:2815
		player["print"]({ -- models/free-market.can:2816
			"multiplayer.no-address", -- models/free-market.can:2816
			{ "item" } -- models/free-market.can:2816
		}) -- models/free-market.can:2816
		return  -- models/free-market.can:2817
	end -- models/free-market.can:2817
	set_buy_box_data(item["name"], entity) -- models/free-market.can:2820
end -- models/free-market.can:2820
local function on_gui_elem_changed(event) -- models/free-market.can:2823
	local element = event["element"] -- models/free-market.can:2824
	if not (element and element["valid"]) then -- models/free-market.can:2825
		return  -- models/free-market.can:2825
	end -- models/free-market.can:2825
	if element["name"] ~= "FM_prices_item" then -- models/free-market.can:2826
		return  -- models/free-market.can:2826
	end -- models/free-market.can:2826
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2827
	if not (player and player["valid"]) then -- models/free-market.can:2828
		return  -- models/free-market.can:2828
	end -- models/free-market.can:2828
	local item_row = element["parent"] -- models/free-market.can:2830
	local content_flow = item_row["parent"] -- models/free-market.can:2831
	local storage_row = content_flow["storage_row"] -- models/free-market.can:2832
	local item_name = element["elem_value"] -- models/free-market.can:2833
	if item_name == nil then -- models/free-market.can:2834
		item_row["sell_price"]["text"] = "" -- models/free-market.can:2835
		item_row["buy_price"]["text"] = "" -- models/free-market.can:2836
		local prices_table = content_flow["other_prices_frame"]["scroll-pane"]["prices_table"] -- models/free-market.can:2837
		prices_table["clear"]() -- models/free-market.can:2838
		make_prices_header(prices_table) -- models/free-market.can:2839
		storage_row["visible"] = false -- models/free-market.can:2840
		return  -- models/free-market.can:2841
	end -- models/free-market.can:2841
	local force_index = player["force_index"] -- models/free-market.can:2844
	storage_row["visible"] = true -- models/free-market.can:2846
	local count = __storages[force_index][item_name] or 0 -- models/free-market.can:2847
	storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:2848
	local limit = __storages_limit[force_index][item_name] or __default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2849
	storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:2850
	item_row["sell_price"]["text"] = tostring(__sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:2852
	item_row["buy_price"]["text"] = tostring(__buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:2853
	update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2854
end -- models/free-market.can:2854
local function on_gui_selection_state_changed(event) -- models/free-market.can:2857
	local element = event["element"] -- models/free-market.can:2858
	if not (element and element["valid"]) then -- models/free-market.can:2859
		return  -- models/free-market.can:2859
	end -- models/free-market.can:2859
	if element["name"] ~= "FM_force_price_list" then -- models/free-market.can:2860
		return  -- models/free-market.can:2860
	end -- models/free-market.can:2860
	local scroll_pane = element["parent"]["parent"]["deep_frame"]["scroll-pane"] -- models/free-market.can:2862
	local force = game["forces"][element["items"][element["selected_index"]]] -- models/free-market.can:2863
	if force == nil then -- models/free-market.can:2864
		scroll_pane["clear"]() -- models/free-market.can:2865
		make_price_list_header(scroll_pane) -- models/free-market.can:2866
		return  -- models/free-market.can:2867
	end -- models/free-market.can:2867
	update_price_list_table(force, scroll_pane) -- models/free-market.can:2870
end -- models/free-market.can:2870
local GUIS = { -- models/free-market.can:2874
	[""] = function(element, player) -- models/free-market.can:2875
		if element["type"] ~= "sprite-button" then -- models/free-market.can:2876
			return  -- models/free-market.can:2876
		end -- models/free-market.can:2876
		local parent_name = element["parent"]["name"] -- models/free-market.can:2878
		if parent_name == "price_list_table" then -- models/free-market.can:2879
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2880
			local force_index = player["force_index"] -- models/free-market.can:2881
			local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2882
			if prices_frame == nil then -- models/free-market.can:2883
				switch_prices_gui(player, item_name) -- models/free-market.can:2884
			else -- models/free-market.can:2884
				local content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2886
				content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2887
				local sell_price = __sell_prices[force_index][item_name] -- models/free-market.can:2888
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price or "") -- models/free-market.can:2889
				local buy_price = __buy_prices[force_index][item_name] -- models/free-market.can:2890
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price or "") -- models/free-market.can:2891
				update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2892
			end -- models/free-market.can:2892
		elseif parent_name == "FM_storage_table" then -- models/free-market.can:2894
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2895
			switch_prices_gui(player, item_name) -- models/free-market.can:2896
		end -- models/free-market.can:2896
	end, -- models/free-market.can:2896
	["FM_close"] = function(element) -- models/free-market.can:2899
		element["parent"]["parent"]["destroy"]() -- models/free-market.can:2900
	end, -- models/free-market.can:2900
	["FM_confirm_default_limit"] = function(element, player) -- models/free-market.can:2902
		local setting_row = element["parent"] -- models/free-market.can:2903
		local default_limit = tonumber(setting_row["FM_default_limit"]["text"]) -- models/free-market.can:2904
		if default_limit == nil or default_limit < 1 or default_limit > max_storage_threshold then -- models/free-market.can:2905
			player["print"]({ -- models/free-market.can:2906
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2906
				default_limit or "", -- models/free-market.can:2906
				1, -- models/free-market.can:2906
				max_storage_threshold -- models/free-market.can:2906
			}) -- models/free-market.can:2906
			return  -- models/free-market.can:2907
		end -- models/free-market.can:2907
		local force_index = player["force_index"] -- models/free-market.can:2910
		__default_storage_limit[force_index] = default_limit -- models/free-market.can:2911
	end, -- models/free-market.can:2911
	["FM_confirm_storage_limit"] = function(element, player) -- models/free-market.can:2913
		local storage_row = element["parent"] -- models/free-market.can:2914
		local storage_limit = tonumber(storage_row["storage_limit"]["text"]) -- models/free-market.can:2915
		if storage_limit == nil or storage_limit < 1 or storage_limit > max_storage_threshold then -- models/free-market.can:2916
			player["print"]({ -- models/free-market.can:2917
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2917
				storage_limit or "", -- models/free-market.can:2917
				1, -- models/free-market.can:2917
				max_storage_threshold -- models/free-market.can:2917
			}) -- models/free-market.can:2917
			return  -- models/free-market.can:2918
		end -- models/free-market.can:2918
		local item_name = storage_row["parent"]["item_row"]["FM_prices_item"]["elem_value"] -- models/free-market.can:2921
		if item_name == nil then -- models/free-market.can:2922
			return  -- models/free-market.can:2922
		end -- models/free-market.can:2922
		local force_index = player["force_index"] -- models/free-market.can:2924
		__storages_limit[force_index][item_name] = storage_limit -- models/free-market.can:2925
	end, -- models/free-market.can:2925
	["FM_confirm_buy_box"] = function(element, player) -- models/free-market.can:2927
		local parent = element["parent"] -- models/free-market.can:2928
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:2929
		if count == nil then -- models/free-market.can:2931
			player["print"]({ -- models/free-market.can:2932
				"multiplayer.no-address", -- models/free-market.can:2932
				{ "gui-train.add-item-count-condition" } -- models/free-market.can:2932
			}) -- models/free-market.can:2932
			return  -- models/free-market.can:2933
		elseif count < 1 then -- models/free-market.can:2934
			player["print"]({ -- models/free-market.can:2935
				"count-must-be-more-n", -- models/free-market.can:2935
				0 -- models/free-market.can:2935
			}) -- models/free-market.can:2935
			return  -- models/free-market.can:2936
		end -- models/free-market.can:2936
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2939
		if not item_name then -- models/free-market.can:2940
			player["print"]({ -- models/free-market.can:2941
				"multiplayer.no-address", -- models/free-market.can:2941
				{ "item" } -- models/free-market.can:2941
			}) -- models/free-market.can:2941
			return  -- models/free-market.can:2942
		end -- models/free-market.can:2942
		local box_operations = parent["parent"] -- models/free-market.can:2945
		local player_index = player["index"] -- models/free-market.can:2946
		local entity = __open_box[player_index] -- models/free-market.can:2947
		if entity then -- models/free-market.can:2948
			local inventory_size = # entity["get_inventory"](1) -- models/free-market.can:1
			local max_count = prototypes["item"][item_name]["stack_size"] * inventory_size -- models/free-market.can:2950
			if count > max_count then -- models/free-market.can:2951
				player["print"]({ -- models/free-market.can:2952
					"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2952
					count, -- models/free-market.can:2952
					1, -- models/free-market.can:2952
					max_count -- models/free-market.can:2952
				}) -- models/free-market.can:2952
				parent["count"]["text"] = tostring(max_count) -- models/free-market.can:2953
				return  -- models/free-market.can:2954
			end -- models/free-market.can:2954
			set_buy_box_data(item_name, entity, count) -- models/free-market.can:2957
			box_operations["clear"]() -- models/free-market.can:2958
			check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2959
		else -- models/free-market.can:2959
			box_operations["clear"]() -- models/free-market.can:2961
			player["print"]({ -- models/free-market.can:2962
				"multiplayer.no-address", -- models/free-market.can:2962
				{ "item-name.linked-chest" } -- models/free-market.can:2962
			}) -- models/free-market.can:2962
		end -- models/free-market.can:2962
		if # box_operations["children"] == 0 then -- models/free-market.can:2965
			__open_box[player_index] = nil -- models/free-market.can:2966
		end -- models/free-market.can:2966
	end, -- models/free-market.can:2966
	["FM_confirm_buy_price_for_chest"] = function(element, player) -- models/free-market.can:2969
		local box_operations = element["parent"] -- models/free-market.can:2970
		local entity = __open_box[player["index"]] -- models/free-market.can:2971
		local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:2972
		if box_data == nil then -- models/free-market.can:2973
			box_operations["clear"]() -- models/free-market.can:2975
			return  -- models/free-market.can:2976
		end -- models/free-market.can:2976
		local buy_price = tonumber(box_operations["buy_price"]["text"]) -- models/free-market.can:2979
		if not buy_price then -- models/free-market.can:2980
			box_operations["clear"]() -- models/free-market.can:2981
		elseif buy_price < 1 then -- models/free-market.can:2982
			player["print"]({ -- models/free-market.can:2984
				"count-must-be-more-n", -- models/free-market.can:2984
				0 -- models/free-market.can:2984
			}) -- models/free-market.can:2984
			return  -- models/free-market.can:2985
		end -- models/free-market.can:2985
		local item_name = box_data[5] -- models/free-market.can:2988
		change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:2989
		box_operations["clear"]() -- models/free-market.can:2990
	end, -- models/free-market.can:2990
	["FM_confirm_transfer_box"] = function(element, player) -- models/free-market.can:2992
		local parent = element["parent"] -- models/free-market.can:2993
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2994
		if not item_name then -- models/free-market.can:2995
			player["print"]({ -- models/free-market.can:2996
				"multiplayer.no-address", -- models/free-market.can:2996
				{ "item" } -- models/free-market.can:2996
			}) -- models/free-market.can:2996
			return  -- models/free-market.can:2997
		end -- models/free-market.can:2997
		local box_operations = parent["parent"] -- models/free-market.can:3000
		local player_index = player["index"] -- models/free-market.can:3001
		local entity = __open_box[player_index] -- models/free-market.can:3002
		if entity then -- models/free-market.can:3003
			set_transfer_box_data(item_name, entity) -- models/free-market.can:3004
			box_operations["clear"]() -- models/free-market.can:3005
			check_sell_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:3006
		else -- models/free-market.can:3006
			box_operations["clear"]() -- models/free-market.can:3008
			player["print"]({ -- models/free-market.can:3009
				"multiplayer.no-address", -- models/free-market.can:3009
				{ "item-name.linked-chest" } -- models/free-market.can:3009
			}) -- models/free-market.can:3009
		end -- models/free-market.can:3009
		if # box_operations["children"] == 0 then -- models/free-market.can:3012
			__open_box[player_index] = nil -- models/free-market.can:3013
		end -- models/free-market.can:3013
	end, -- models/free-market.can:3013
	["FM_confirm_bin_box"] = function(element, player) -- models/free-market.can:3016
		local parent = element["parent"] -- models/free-market.can:3017
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3018
		if not item_name then -- models/free-market.can:3019
			player["print"]({ -- models/free-market.can:3020
				"multiplayer.no-address", -- models/free-market.can:3020
				{ "item" } -- models/free-market.can:3020
			}) -- models/free-market.can:3020
			return  -- models/free-market.can:3021
		end -- models/free-market.can:3021
		local box_operations = parent["parent"] -- models/free-market.can:3024
		local player_index = player["index"] -- models/free-market.can:3025
		local entity = __open_box[player_index] -- models/free-market.can:3026
		if entity then -- models/free-market.can:3027
			set_bin_box_data(item_name, entity) -- models/free-market.can:3028
		else -- models/free-market.can:3028
			player["print"]({ -- models/free-market.can:3030
				"multiplayer.no-address", -- models/free-market.can:3030
				{ "item-name.linked-chest" } -- models/free-market.can:3030
			}) -- models/free-market.can:3030
		end -- models/free-market.can:3030
		box_operations["clear"]() -- models/free-market.can:3032
		__open_box[player_index] = nil -- models/free-market.can:3033
	end, -- models/free-market.can:3033
	["FM_confirm_sell_price_for_chest"] = function(element, player) -- models/free-market.can:3035
		local box_operations = element["parent"] -- models/free-market.can:3036
		local entity = __open_box[player["index"]] -- models/free-market.can:3037
		local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3038
		if box_data == nil then -- models/free-market.can:3039
			box_operations["clear"]() -- models/free-market.can:3041
			return  -- models/free-market.can:3042
		end -- models/free-market.can:3042
		local sell_price = tonumber(box_operations["sell_price"]["text"]) -- models/free-market.can:3045
		if not sell_price then -- models/free-market.can:3046
			box_operations["clear"]() -- models/free-market.can:3047
		elseif sell_price < 1 then -- models/free-market.can:3048
			player["print"]({ -- models/free-market.can:3050
				"count-must-be-more-n", -- models/free-market.can:3050
				0 -- models/free-market.can:3050
			}) -- models/free-market.can:3050
			return  -- models/free-market.can:3051
		end -- models/free-market.can:3051
		local item_name = box_data[5] -- models/free-market.can:3054
		change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:3055
		box_operations["clear"]() -- models/free-market.can:3056
	end, -- models/free-market.can:3056
	["FM_confirm_pull_box"] = function(element, player) -- models/free-market.can:3058
		local parent = element["parent"] -- models/free-market.can:3059
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3060
		if not item_name then -- models/free-market.can:3061
			player["print"]({ -- models/free-market.can:3062
				"multiplayer.no-address", -- models/free-market.can:3062
				{ "item" } -- models/free-market.can:3062
			}) -- models/free-market.can:3062
			return  -- models/free-market.can:3063
		end -- models/free-market.can:3063
		local player_index = player["index"] -- models/free-market.can:3066
		local entity = __open_box[player_index] -- models/free-market.can:3067
		if entity then -- models/free-market.can:3068
			set_pull_box_data(item_name, entity) -- models/free-market.can:3069
		else -- models/free-market.can:3069
			player["print"]({ -- models/free-market.can:3071
				"multiplayer.no-address", -- models/free-market.can:3071
				{ "item-name.linked-chest" } -- models/free-market.can:3071
			}) -- models/free-market.can:3071
		end -- models/free-market.can:3071
		__open_box[player_index] = nil -- models/free-market.can:3073
		local box_operations = parent["parent"] -- models/free-market.can:3074
		box_operations["clear"]() -- models/free-market.can:3075
	end, -- models/free-market.can:3075
	["FM_change_transfer_box"] = function(element, player) -- models/free-market.can:3077
		local parent = element["parent"] -- models/free-market.can:3078
		local player_index = player["index"] -- models/free-market.can:3079
		local entity = __open_box[player_index] -- models/free-market.can:3080
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3081
		if entity then -- models/free-market.can:3082
			local player_force = player["force"] -- models/free-market.can:3083
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3084
			if item_name then -- models/free-market.can:3085
				if box_data and box_data[3] == 4 then -- models/free-market.can:1
					local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3087
					rendered["destroy"]() -- models/free-market.can:3088
					remove_certain_transfer_box(entity, box_data) -- models/free-market.can:3089
					set_transfer_box_data(item_name, entity) -- models/free-market.can:3090
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3091
				else -- models/free-market.can:3091
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3093
				end -- models/free-market.can:3093
			else -- models/free-market.can:3093
				local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3096
				rendered["destroy"]() -- models/free-market.can:3097
				remove_certain_transfer_box(entity, box_data) -- models/free-market.can:3098
			end -- models/free-market.can:3098
		else -- models/free-market.can:3098
			player["print"]({ -- models/free-market.can:3101
				"multiplayer.no-address", -- models/free-market.can:3101
				{ "item-name.linked-chest" } -- models/free-market.can:3101
			}) -- models/free-market.can:3101
		end -- models/free-market.can:3101
		__open_box[player_index] = nil -- models/free-market.can:3103
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3104
		box_operations["clear"]() -- models/free-market.can:3105
	end, -- models/free-market.can:3105
	["FM_change_bin_box"] = function(element, player) -- models/free-market.can:3107
		local parent = element["parent"] -- models/free-market.can:3108
		local player_index = player["index"] -- models/free-market.can:3109
		local entity = __open_box[player_index] -- models/free-market.can:3110
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3111
		if entity then -- models/free-market.can:3112
			local player_force = player["force"] -- models/free-market.can:3113
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3114
			if item_name then -- models/free-market.can:3115
				if box_data and box_data[3] == 6 then -- models/free-market.can:1
					local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3117
					rendered["destroy"]() -- models/free-market.can:3118
					remove_certain_bin_box(entity, box_data) -- models/free-market.can:3119
					set_bin_box_data(item_name, entity) -- models/free-market.can:3120
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3121
				else -- models/free-market.can:3121
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3123
				end -- models/free-market.can:3123
			else -- models/free-market.can:3123
				local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3126
				rendered["destroy"]() -- models/free-market.can:3127
				remove_certain_bin_box(entity, box_data) -- models/free-market.can:3128
			end -- models/free-market.can:3128
		else -- models/free-market.can:3128
			player["print"]({ -- models/free-market.can:3131
				"multiplayer.no-address", -- models/free-market.can:3131
				{ "item-name.linked-chest" } -- models/free-market.can:3131
			}) -- models/free-market.can:3131
		end -- models/free-market.can:3131
		__open_box[player_index] = nil -- models/free-market.can:3133
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3134
		box_operations["clear"]() -- models/free-market.can:3135
	end, -- models/free-market.can:3135
	["FM_change_pull_box"] = function(element, player) -- models/free-market.can:3137
		local parent = element["parent"] -- models/free-market.can:3138
		local player_index = player["index"] -- models/free-market.can:3139
		local entity = __open_box[player_index] -- models/free-market.can:3140
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3141
		if entity then -- models/free-market.can:3142
			local player_force = player["force"] -- models/free-market.can:3143
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3144
			if item_name then -- models/free-market.can:3145
				if box_data and box_data[3] == 3 then -- models/free-market.can:1
					local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3147
					rendered["destroy"]() -- models/free-market.can:3148
					remove_certain_pull_box(entity, box_data) -- models/free-market.can:3149
					set_pull_box_data(item_name, entity) -- models/free-market.can:3150
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3151
				else -- models/free-market.can:3151
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3153
				end -- models/free-market.can:3153
			else -- models/free-market.can:3153
				local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3156
				rendered["destroy"]() -- models/free-market.can:3157
				remove_certain_pull_box(entity, box_data) -- models/free-market.can:3158
			end -- models/free-market.can:3158
		else -- models/free-market.can:3158
			player["print"]({ -- models/free-market.can:3161
				"multiplayer.no-address", -- models/free-market.can:3161
				{ "item-name.linked-chest" } -- models/free-market.can:3161
			}) -- models/free-market.can:3161
		end -- models/free-market.can:3161
		__open_box[player_index] = nil -- models/free-market.can:3163
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3164
		box_operations["clear"]() -- models/free-market.can:3165
	end, -- models/free-market.can:3165
	["FM_change_buy_box"] = function(element, player) -- models/free-market.can:3167
		local parent = element["parent"] -- models/free-market.can:3168
		local player_index = player["index"] -- models/free-market.can:3169
		local entity = __open_box[player_index] -- models/free-market.can:3170
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:3171
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3172
		if entity then -- models/free-market.can:3173
			local player_force = player["force"] -- models/free-market.can:3174
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3175
			if item_name and count then -- models/free-market.can:3176
				local prev_item_name = box_data[5] -- models/free-market.can:3177
				if prev_item_name == item_name then -- models/free-market.can:3178
					change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:3179
				else -- models/free-market.can:3179
					if box_data and box_data[3] == 1 then -- models/free-market.can:1
						local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3182
						rendered["destroy"]() -- models/free-market.can:3183
						remove_certain_buy_box(entity, box_data) -- models/free-market.can:3184
						set_buy_box_data(item_name, entity) -- models/free-market.can:3185
						show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3186
					else -- models/free-market.can:3186
						player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3188
					end -- models/free-market.can:3188
				end -- models/free-market.can:3188
			else -- models/free-market.can:3188
				local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:3192
				rendered["destroy"]() -- models/free-market.can:3193
				remove_certain_buy_box(entity, box_data) -- models/free-market.can:3194
			end -- models/free-market.can:3194
		else -- models/free-market.can:3194
			player["print"]({ -- models/free-market.can:3197
				"multiplayer.no-address", -- models/free-market.can:3197
				{ "item-name.linked-chest" } -- models/free-market.can:3197
			}) -- models/free-market.can:3197
		end -- models/free-market.can:3197
		__open_box[player_index] = nil -- models/free-market.can:3199
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3200
		box_operations["clear"]() -- models/free-market.can:3201
	end, -- models/free-market.can:3201
	["FM_confirm_sell_price"] = function(element, player) -- models/free-market.can:3203
		local parent = element["parent"] -- models/free-market.can:3204
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3205
		if item_name == nil then -- models/free-market.can:3206
			return  -- models/free-market.can:3206
		end -- models/free-market.can:3206
		local sell_price_element = parent["sell_price"] -- models/free-market.can:3208
		local sell_price = tonumber(sell_price_element["text"]) -- models/free-market.can:3209
		local prev_sell_price = change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:3210
		if prev_sell_price then -- models/free-market.can:3211
			sell_price_element["text"] = tostring(prev_sell_price) -- models/free-market.can:3212
		end -- models/free-market.can:3212
	end, -- models/free-market.can:3212
	["FM_confirm_buy_price"] = function(element, player) -- models/free-market.can:3215
		local parent = element["parent"] -- models/free-market.can:3216
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3217
		if item_name == nil then -- models/free-market.can:3218
			return  -- models/free-market.can:3218
		end -- models/free-market.can:3218
		local buy_price_element = parent["buy_price"] -- models/free-market.can:3220
		local buy_price = tonumber(buy_price_element["text"]) -- models/free-market.can:3221
		local prev_buy_price = change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:3222
		if prev_buy_price then -- models/free-market.can:3223
			buy_price_element["text"] = tostring(prev_buy_price) -- models/free-market.can:3224
		end -- models/free-market.can:3224
	end, -- models/free-market.can:3224
	["FM_refresh_prices_table"] = function(element, player) -- models/free-market.can:3227
		local content_flow = element["parent"]["parent"]["shallow_frame"]["content_flow"] -- models/free-market.can:3228
		local item_row = content_flow["item_row"] -- models/free-market.can:3229
		local item_name = item_row["FM_prices_item"]["elem_value"] -- models/free-market.can:3230
		if item_name == nil then -- models/free-market.can:3231
			return  -- models/free-market.can:3231
		end -- models/free-market.can:3231
		local force_index = player["force_index"] -- models/free-market.can:3233
		item_row["buy_price"]["text"] = tostring(__buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:3234
		item_row["sell_price"]["text"] = tostring(__sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:3235
		local storage_row = content_flow["storage_row"] -- models/free-market.can:3237
		local count = __storages[force_index][item_name] or 0 -- models/free-market.can:3238
		storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:3239
		local limit = __storages_limit[force_index][item_name] or __default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:3240
		storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:3241
		update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:3243
	end, -- models/free-market.can:3243
	["FM_set_transfer_box"] = function(element, player) -- models/free-market.can:3245
		local entity = player["opened"] -- models/free-market.can:3246
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3248
			if player["force"] ~= entity["force"] then -- models/free-market.can:3249
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3250
				return  -- models/free-market.can:3251
			end -- models/free-market.can:3251
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3254
			if box_data then -- models/free-market.can:3255
				local box_type = box_data[3] -- models/free-market.can:3256
				if box_type == 4 then -- models/free-market.can:1
					open_transfer_box_gui(player, false, entity) -- models/free-market.can:3258
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3260
					return  -- models/free-market.can:3261
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3263
					return  -- models/free-market.can:3264
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3266
					return  -- models/free-market.can:3267
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3269
					return  -- models/free-market.can:3270
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3272
					return  -- models/free-market.can:3273
				end -- models/free-market.can:3273
			else -- models/free-market.can:3273
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3276
				if not item["valid_for_read"] then -- models/free-market.can:3277
					open_transfer_box_gui(player, true) -- models/free-market.can:3278
				else -- models/free-market.can:3278
					local item_name = item["name"] -- models/free-market.can:3280
					set_transfer_box_data(item_name, entity) -- models/free-market.can:3281
					check_sell_price(player, item_name) -- models/free-market.can:3282
				end -- models/free-market.can:3282
			end -- models/free-market.can:3282
			__open_box[player["index"]] = entity -- models/free-market.can:3285
		end -- models/free-market.can:3285
	end, -- models/free-market.can:3285
	["FM_set_universal_transfer_box"] = function(element, player) -- models/free-market.can:3288
		local entity = player["opened"] -- models/free-market.can:3289
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3291
			if player["force"] ~= entity["force"] then -- models/free-market.can:3292
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3293
				return  -- models/free-market.can:3294
			end -- models/free-market.can:3294
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3297
			if box_data then -- models/free-market.can:3298
				local box_type = box_data[3] -- models/free-market.can:3299
				if box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3301
					return  -- models/free-market.can:3302
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3304
					return  -- models/free-market.can:3305
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3307
					return  -- models/free-market.can:3308
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3310
					return  -- models/free-market.can:3311
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3313
					return  -- models/free-market.can:3314
				end -- models/free-market.can:3314
			else -- models/free-market.can:3314
				set_universal_transfer_box_data(entity) -- models/free-market.can:3317
			end -- models/free-market.can:3317
			__open_box[player["index"]] = entity -- models/free-market.can:3319
		end -- models/free-market.can:3319
	end, -- models/free-market.can:3319
	["FM_set_bin_box"] = function(element, player) -- models/free-market.can:3322
		local entity = player["opened"] -- models/free-market.can:3323
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3325
			if player["force"] ~= entity["force"] then -- models/free-market.can:3326
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3327
				return  -- models/free-market.can:3328
			end -- models/free-market.can:3328
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3331
			if box_data then -- models/free-market.can:3332
				local box_type = box_data[3] -- models/free-market.can:3333
				if box_type == 6 then -- models/free-market.can:1
					open_bin_box_gui(player, false, entity) -- models/free-market.can:3335
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3337
					return  -- models/free-market.can:3338
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3340
					return  -- models/free-market.can:3341
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3343
					return  -- models/free-market.can:3344
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3346
					return  -- models/free-market.can:3347
				end -- models/free-market.can:3347
			else -- models/free-market.can:3347
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3350
				if not item["valid_for_read"] then -- models/free-market.can:3351
					open_bin_box_gui(player, true) -- models/free-market.can:3352
				else -- models/free-market.can:3352
					set_bin_box_data(item["name"], entity) -- models/free-market.can:3354
				end -- models/free-market.can:3354
			end -- models/free-market.can:3354
			__open_box[player["index"]] = entity -- models/free-market.can:3357
		end -- models/free-market.can:3357
	end, -- models/free-market.can:3357
	["FM_set_universal_bin_box"] = function(element, player) -- models/free-market.can:3360
		local entity = player["opened"] -- models/free-market.can:3361
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3363
			if player["force"] ~= entity["force"] then -- models/free-market.can:3364
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3365
				return  -- models/free-market.can:3366
			end -- models/free-market.can:3366
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3369
			if box_data then -- models/free-market.can:3370
				local box_type = box_data[3] -- models/free-market.can:3371
				if box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3373
					return  -- models/free-market.can:3374
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3376
					return  -- models/free-market.can:3377
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3379
					return  -- models/free-market.can:3380
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3382
					return  -- models/free-market.can:3383
				end -- models/free-market.can:3383
			else -- models/free-market.can:3383
				set_universal_bin_box_data(entity) -- models/free-market.can:3386
			end -- models/free-market.can:3386
			__open_box[player["index"]] = entity -- models/free-market.can:3388
		end -- models/free-market.can:3388
	end, -- models/free-market.can:3388
	["FM_set_pull_box"] = function(element, player) -- models/free-market.can:3391
		local entity = player["opened"] -- models/free-market.can:3392
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3394
			if player["force"] ~= entity["force"] then -- models/free-market.can:3395
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3396
				return  -- models/free-market.can:3397
			end -- models/free-market.can:3397
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3400
			if box_data then -- models/free-market.can:3401
				local box_type = box_data[3] -- models/free-market.can:3402
				if box_type == 3 then -- models/free-market.can:1
					open_pull_box_gui(player, false, entity) -- models/free-market.can:3404
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3406
					return  -- models/free-market.can:3407
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3409
					return  -- models/free-market.can:3410
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3412
					return  -- models/free-market.can:3413
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3415
					return  -- models/free-market.can:3416
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3418
					return  -- models/free-market.can:3419
				end -- models/free-market.can:3419
			else -- models/free-market.can:3419
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3422
				if not item["valid_for_read"] then -- models/free-market.can:3423
					open_pull_box_gui(player, true) -- models/free-market.can:3424
				else -- models/free-market.can:3424
					set_pull_box_data(item["name"], entity) -- models/free-market.can:3426
				end -- models/free-market.can:3426
			end -- models/free-market.can:3426
			__open_box[player["index"]] = entity -- models/free-market.can:3429
		end -- models/free-market.can:3429
	end, -- models/free-market.can:3429
	["FM_set_buy_box"] = function(element, player) -- models/free-market.can:3432
		local entity = player["opened"] -- models/free-market.can:3433
		if ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3435
			if player["force"] ~= entity["force"] then -- models/free-market.can:3436
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3437
				return  -- models/free-market.can:3438
			end -- models/free-market.can:3438
			local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:3441
			if box_data then -- models/free-market.can:3442
				local box_type = box_data[3] -- models/free-market.can:3443
				if box_type == 1 then -- models/free-market.can:1
					open_buy_box_gui(player, false, entity) -- models/free-market.can:3445
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3447
					return  -- models/free-market.can:3448
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3450
					return  -- models/free-market.can:3451
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3453
					return  -- models/free-market.can:3454
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3456
					return  -- models/free-market.can:3457
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3459
					return  -- models/free-market.can:3460
				end -- models/free-market.can:3460
			else -- models/free-market.can:3460
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3463
				if not item["valid_for_read"] then -- models/free-market.can:3464
					open_buy_box_gui(player, true) -- models/free-market.can:3465
				else -- models/free-market.can:3465
					local box_operations = element["parent"]["parent"]["box_operations"] -- models/free-market.can:3467
					local item_name = item["name"] -- models/free-market.can:3468
					set_buy_box_data(item_name, entity) -- models/free-market.can:3469
					check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:3470
				end -- models/free-market.can:3470
			end -- models/free-market.can:3470
			__open_box[player["index"]] = entity -- models/free-market.can:3473
		end -- models/free-market.can:3473
	end, -- models/free-market.can:3473
	["FM_print_force_data"] = function(element, player) -- models/free-market.can:3476
		if player["admin"] then -- models/free-market.can:3477
			print_force_data(player["force"], player) -- models/free-market.can:3478
		else -- models/free-market.can:3478
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3480
		end -- models/free-market.can:3480
	end, -- models/free-market.can:3480
	["FM_clear_invalid_data"] = clear_invalid_data, -- models/free-market.can:3483
	["FM_reset_buy_prices"] = function(element, player) -- models/free-market.can:3484
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3485
			local force_index = player["force_index"] -- models/free-market.can:3486
			__buy_prices[force_index] = {} -- models/free-market.can:3487
			__inactive_buy_prices[force_index] = {} -- models/free-market.can:3488
		else -- models/free-market.can:3488
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3490
		end -- models/free-market.can:3490
	end, -- models/free-market.can:3490
	["FM_reset_sell_prices"] = function(element, player) -- models/free-market.can:3493
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3494
			local force_index = player["force_index"] -- models/free-market.can:3495
			__sell_prices[force_index] = {} -- models/free-market.can:3496
			__inactive_sell_prices[force_index] = {} -- models/free-market.can:3497
		else -- models/free-market.can:3497
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3499
		end -- models/free-market.can:3499
	end, -- models/free-market.can:3499
	["FM_reset_all_prices"] = function(element, player) -- models/free-market.can:3502
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3503
			local force_index = player["force_index"] -- models/free-market.can:3504
			__inactive_sell_prices[force_index] = {} -- models/free-market.can:3505
			__inactive_buy_prices[force_index] = {} -- models/free-market.can:3506
			__sell_prices[force_index] = {} -- models/free-market.can:3507
			__buy_prices[force_index] = {} -- models/free-market.can:3508
		else -- models/free-market.can:3508
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3510
		end -- models/free-market.can:3510
	end, -- models/free-market.can:3510
	["FM_reset_buy_boxes"] = function(element, player) -- models/free-market.can:3513
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3514
			resetBuyBoxes(player["force_index"]) -- models/free-market.can:3515
		else -- models/free-market.can:3515
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3517
		end -- models/free-market.can:3517
	end, -- models/free-market.can:3517
	["FM_reset_transfer_boxes"] = function(element, player) -- models/free-market.can:3520
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3521
			resetTransferBoxes(player["force_index"]) -- models/free-market.can:3522
		else -- models/free-market.can:3522
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3524
		end -- models/free-market.can:3524
	end, -- models/free-market.can:3524
	["FM_reset_universal_transfer_boxes"] = function(element, player) -- models/free-market.can:3527
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3528
			resetUniversalTransferBoxes(player["force_index"]) -- models/free-market.can:3529
		else -- models/free-market.can:3529
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3531
		end -- models/free-market.can:3531
	end, -- models/free-market.can:3531
	["FM_reset_bin_boxes"] = function(element, player) -- models/free-market.can:3534
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3535
			resetBinBoxes(player["force_index"]) -- models/free-market.can:3536
		else -- models/free-market.can:3536
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3538
		end -- models/free-market.can:3538
	end, -- models/free-market.can:3538
	["FM_reset_universal_bin_boxes"] = function(element, player) -- models/free-market.can:3541
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3542
			resetUniversalBinBoxes(player["force_index"]) -- models/free-market.can:3543
		else -- models/free-market.can:3543
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3545
		end -- models/free-market.can:3545
	end, -- models/free-market.can:3545
	["FM_reset_pull_boxes"] = function(element, player) -- models/free-market.can:3548
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3549
			resetPullBoxes(player["force_index"]) -- models/free-market.can:3550
		else -- models/free-market.can:3550
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3552
		end -- models/free-market.can:3552
	end, -- models/free-market.can:3552
	["FM_reset_all_boxes"] = function(element, player) -- models/free-market.can:3555
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3556
			resetAllBoxes(player["force_index"]) -- models/free-market.can:3557
		else -- models/free-market.can:3557
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3559
		end -- models/free-market.can:3559
	end, -- models/free-market.can:3559
	["FM_declare_embargo"] = function(element, player) -- models/free-market.can:3562
		local table_element = element["parent"]["parent"] -- models/free-market.can:3563
		local forces_list = table_element["forces_list"] -- models/free-market.can:3564
		if forces_list["selected_index"] == 0 then -- models/free-market.can:3565
			return  -- models/free-market.can:3565
		end -- models/free-market.can:3565
		local force_name = forces_list["items"][forces_list["selected_index"]] -- models/free-market.can:3567
		local other_force = game["forces"][force_name] -- models/free-market.can:3568
		if other_force and other_force["valid"] then -- models/free-market.can:3569
			local force = player["force"] -- models/free-market.can:3570
			__embargoes[force["index"]][other_force["index"]] = true -- models/free-market.can:3571
			local message = { -- models/free-market.can:3572
				"free-market.declared-embargo", -- models/free-market.can:3572
				force["name"], -- models/free-market.can:3572
				other_force["name"], -- models/free-market.can:3572
				player["name"] -- models/free-market.can:3572
			} -- models/free-market.can:3572
			force["print"](message) -- models/free-market.can:3573
			other_force["print"](message) -- models/free-market.can:3574
		end -- models/free-market.can:3574
		update_embargo_table(table_element, player) -- models/free-market.can:3576
	end, -- models/free-market.can:3576
	["FM_cancel_embargo"] = function(element, player) -- models/free-market.can:3578
		local table_element = element["parent"]["parent"] -- models/free-market.can:3579
		local embargo_list = table_element["embargo_list"] -- models/free-market.can:3580
		if embargo_list["selected_index"] == 0 then -- models/free-market.can:3581
			return  -- models/free-market.can:3581
		end -- models/free-market.can:3581
		local force_name = embargo_list["items"][embargo_list["selected_index"]] -- models/free-market.can:3583
		local other_force = game["forces"][force_name] -- models/free-market.can:3584
		if other_force and other_force["valid"] then -- models/free-market.can:3585
			local force = player["force"] -- models/free-market.can:3586
			__embargoes[force["index"]][other_force["index"]] = nil -- models/free-market.can:3587
			local message = { -- models/free-market.can:3588
				"free-market.canceled-embargo", -- models/free-market.can:3588
				force["name"], -- models/free-market.can:3588
				other_force["name"], -- models/free-market.can:3588
				player["name"] -- models/free-market.can:3588
			} -- models/free-market.can:3588
			force["print"](message) -- models/free-market.can:3589
			other_force["print"](message) -- models/free-market.can:3590
		end -- models/free-market.can:3590
		update_embargo_table(table_element, player) -- models/free-market.can:3592
	end, -- models/free-market.can:3592
	["FM_open_force_configuration"] = function(element, player) -- models/free-market.can:3594
		open_force_configuration(player) -- models/free-market.can:3595
	end, -- models/free-market.can:3595
	["FM_open_price"] = function(element, player) -- models/free-market.can:3597
		switch_prices_gui(player) -- models/free-market.can:3598
	end, -- models/free-market.can:3598
	["FM_switch_sell_prices_gui"] = function(element, player) -- models/free-market.can:3600
		switch_sell_prices_gui(player) -- models/free-market.can:3601
	end, -- models/free-market.can:3601
	["FM_switch_buy_prices_gui"] = function(element, player) -- models/free-market.can:3603
		switch_buy_prices_gui(player) -- models/free-market.can:3604
	end, -- models/free-market.can:3604
	["FM_open_sell_price"] = function(element, player, event) -- models/free-market.can:3606
		local force_index = tonumber(element["children"][1]["name"]) -- models/free-market.can:3607
		local force = game["forces"][force_index or 0] -- models/free-market.can:3608
		if not (force and force["valid"]) then -- models/free-market.can:3609
			game["print"]({ -- models/free-market.can:3610
				"force-doesnt-exist", -- models/free-market.can:3610
				"?" -- models/free-market.can:3610
			}) -- models/free-market.can:3610
			return  -- models/free-market.can:3611
		end -- models/free-market.can:3611
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3614
		if prototypes["item"][item_name] == nil then -- models/free-market.can:3615
			game["print"]({ -- models/free-market.can:3616
				"missing-item", -- models/free-market.can:3616
				item_name -- models/free-market.can:3616
			}) -- models/free-market.can:3616
			return  -- models/free-market.can:3617
		end -- models/free-market.can:3617
		local price = __sell_prices[force_index][item_name] or __inactive_sell_prices[force_index][item_name] -- models/free-market.can:3620
		if price then -- models/free-market.can:3621
			if event["shift"] then -- models/free-market.can:3622
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3624
			end -- models/free-market.can:3624
			if event["control"] then -- models/free-market.can:3626
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3628
			end -- models/free-market.can:3628
			if event["alt"] then -- models/free-market.can:3630
				switch_prices_gui(player, item_name) -- models/free-market.can:3631
			end -- models/free-market.can:3631
			game["print"]({ -- models/free-market.can:3633
				"free-market.team-selling-item-for", -- models/free-market.can:3633
				force["name"], -- models/free-market.can:3633
				item_name, -- models/free-market.can:3633
				price -- models/free-market.can:3633
			}) -- models/free-market.can:3633
		else -- models/free-market.can:3633
			game["print"]({ -- models/free-market.can:3636
				"free-market.team-doesnt-sell-item", -- models/free-market.can:3636
				force["name"], -- models/free-market.can:3636
				item_name -- models/free-market.can:3636
			}) -- models/free-market.can:3636
		end -- models/free-market.can:3636
	end, -- models/free-market.can:3636
	["FM_open_buy_price"] = function(element, player, event) -- models/free-market.can:3639
		local force_index = tonumber(element["children"][1]["name"]) or 0 -- models/free-market.can:3640
		local force = game["forces"][force_index] -- models/free-market.can:3641
		if not (force and force["valid"]) then -- models/free-market.can:3642
			game["print"]({ -- models/free-market.can:3643
				"force-doesnt-exist", -- models/free-market.can:3643
				"?" -- models/free-market.can:3643
			}) -- models/free-market.can:3643
			return  -- models/free-market.can:3644
		end -- models/free-market.can:3644
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3647
		if prototypes["item"][item_name] == nil then -- models/free-market.can:3648
			game["print"]({ -- models/free-market.can:3649
				"missing-item", -- models/free-market.can:3649
				item_name -- models/free-market.can:3649
			}) -- models/free-market.can:3649
			return  -- models/free-market.can:3650
		end -- models/free-market.can:3650
		local price = __buy_prices[force_index][item_name] or __inactive_buy_prices[force_index][item_name] -- models/free-market.can:3653
		if price then -- models/free-market.can:3654
			if event["shift"] then -- models/free-market.can:3655
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3657
			end -- models/free-market.can:3657
			if event["control"] then -- models/free-market.can:3659
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3661
			end -- models/free-market.can:3661
			if event["alt"] then -- models/free-market.can:3663
				switch_prices_gui(player, item_name) -- models/free-market.can:3664
			end -- models/free-market.can:3664
			game["print"]({ -- models/free-market.can:3666
				"free-market.team-buying-item-for", -- models/free-market.can:3666
				force["name"], -- models/free-market.can:3666
				item_name, -- models/free-market.can:3666
				price -- models/free-market.can:3666
			}) -- models/free-market.can:3666
		else -- models/free-market.can:3666
			game["print"]({ -- models/free-market.can:3669
				"free-market.team-doesnt-buy-item", -- models/free-market.can:3669
				force["name"], -- models/free-market.can:3669
				item_name -- models/free-market.can:3669
			}) -- models/free-market.can:3669
		end -- models/free-market.can:3669
	end, -- models/free-market.can:3669
	["FM_open_price_list"] = function(element, player) -- models/free-market.can:3672
		open_price_list_gui(player) -- models/free-market.can:3673
	end, -- models/free-market.can:3673
	["FM_open_embargo"] = function(element, player) -- models/free-market.can:3675
		open_embargo_gui(player) -- models/free-market.can:3676
	end, -- models/free-market.can:3676
	["FM_open_storage"] = function(element, player) -- models/free-market.can:3678
		open_storage_gui(player) -- models/free-market.can:3679
	end, -- models/free-market.can:3679
	["FM_show_hint"] = function(element, player) -- models/free-market.can:3681
		player["print"]({ "free-market.hint" }) -- models/free-market.can:3682
	end, -- models/free-market.can:3682
	["FM_hide_left_buttons"] = function(element, player) -- models/free-market.can:3684
		element["name"] = "FM_show_left_buttons" -- models/free-market.can:3685
		element["caption"] = "<" -- models/free-market.can:3686
		element["parent"]["children"][2]["visible"] = false -- models/free-market.can:3687
	end, -- models/free-market.can:3687
	["FM_show_left_buttons"] = function(element, player) -- models/free-market.can:3689
		element["name"] = "FM_hide_left_buttons" -- models/free-market.can:3690
		element["caption"] = ">" -- models/free-market.can:3691
		element["parent"]["children"][2]["visible"] = true -- models/free-market.can:3692
	end, -- models/free-market.can:3692
	["FM_search_by_price"] = function(element, player) -- models/free-market.can:3694
		local search_row = element["parent"] -- models/free-market.can:3695
		local selected_index = search_row["FM_search_price_drop_down"]["selected_index"] -- models/free-market.can:3696
		if selected_index == 0 then -- models/free-market.can:3697
			return  -- models/free-market.can:3698
		end -- models/free-market.can:3698
		local content_flow = search_row["parent"] -- models/free-market.can:3701
		local drop_down = content_flow["team_row"]["FM_force_price_list"] -- models/free-market.can:3702
		local dp_selected_index = drop_down["selected_index"] -- models/free-market.can:3703
		if dp_selected_index == nil or dp_selected_index == 0 then -- models/free-market.can:3704
			return  -- models/free-market.can:3704
		end -- models/free-market.can:3704
		local force = game["forces"][drop_down["items"][dp_selected_index]] -- models/free-market.can:3705
		if not (force and force["valid"]) then -- models/free-market.can:3706
			return  -- models/free-market.can:3706
		end -- models/free-market.can:3706
		local search_text = search_row["FM_search_text"]["text"] -- models/free-market.can:3708
		if # search_text > 50 then -- models/free-market.can:3709
			return  -- models/free-market.can:3710
		end -- models/free-market.can:3710
		local scroll_pane = content_flow["deep_frame"]["scroll-pane"] -- models/free-market.can:3712
		if search_text == "" then -- models/free-market.can:3713
			update_price_list_table(force, scroll_pane) -- models/free-market.can:3714
			return  -- models/free-market.can:3715
		end -- models/free-market.can:3715
		search_text = ".?" .. search_text:lower():gsub(" ", ".?") .. ".?" -- models/free-market.can:3718
		if selected_index == 1 then -- models/free-market.can:3719
			update_price_list_by_sell_filter(force, scroll_pane, search_text) -- models/free-market.can:3720
		else -- models/free-market.can:3720
			update_price_list_by_buy_filter(force, scroll_pane, search_text) -- models/free-market.can:3722
		end -- models/free-market.can:3722
	end -- models/free-market.can:3722
} -- models/free-market.can:3722
local function on_gui_click(event) -- models/free-market.can:3726
	local element = event["element"] -- models/free-market.can:3727
	if not (element and element["valid"]) then -- models/free-market.can:3728
		return  -- models/free-market.can:3728
	end -- models/free-market.can:3728
	local f = GUIS[element["name"]] -- models/free-market.can:3729
	if f then -- models/free-market.can:3730
		f(element, game["get_player"](event["player_index"]), event) -- models/free-market.can:3731
	end -- models/free-market.can:3731
end -- models/free-market.can:3731
local function on_gui_opened(event) -- models/free-market.can:3736
	local entity = event["entity"] -- models/free-market.can:3737
	if not (entity and entity["valid"]) then -- models/free-market.can:3738
		return  -- models/free-market.can:3738
	end -- models/free-market.can:3738
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3739
	if not (player and player["valid"]) then -- models/free-market.can:3740
		return  -- models/free-market.can:3740
	end -- models/free-market.can:3740
	local boxes_frame = player["gui"]["relative"]["FM_boxes_frame"] -- models/free-market.can:3742
	if player["force"] == entity["force"] then -- models/free-market.can:3743
		boxes_frame["visible"] = ALLOWED_CHEST_TYPES[entity["type"]] == true -- models/free-market.can:3744
	else -- models/free-market.can:3744
		boxes_frame["visible"] = false -- models/free-market.can:3746
	end -- models/free-market.can:3746
end -- models/free-market.can:3746
local function on_gui_closed(event) -- models/free-market.can:3750
	local entity = event["entity"] -- models/free-market.can:3751
	if not (entity and entity["valid"]) then -- models/free-market.can:3752
		return  -- models/free-market.can:3752
	end -- models/free-market.can:3752
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:3753
		return  -- models/free-market.can:3753
	end -- models/free-market.can:3753
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3754
	if not (player and player["valid"]) then -- models/free-market.can:3755
		return  -- models/free-market.can:3755
	end -- models/free-market.can:3755
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:3756
end -- models/free-market.can:3756
local function check_pull_boxes() -- models/free-market.can:3759
	local pulled_item_count = {} -- models/free-market.can:3760
	for force_index, _items_data in pairs(__pull_boxes) do -- models/free-market.can:3761
		local force_money = call("EasyAPI", "get_force_money", force_index) -- models/free-market.can:3762
		if force_money and (pull_cost_per_item == 0 or call("EasyAPI", "get_force_money", force_index) > money_treshold) then -- models/free-market.can:3763
			local inserted_count_in_total = 0 -- models/free-market.can:3764
			pulled_item_count[force_index] = 0 -- models/free-market.can:3765
			local storage = __storages[force_index] -- models/free-market.can:3766
			for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3767
				local count_in_storage = storage[item_name] -- models/free-market.can:3768
				if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3769
					stack["name"] = item_name -- models/free-market.can:3770
					for i = # force_entities, 1, - 1 do -- models/free-market.can:3771
						if count_in_storage <= 0 then -- models/free-market.can:3772
							break -- models/free-market.can:3773
						end -- models/free-market.can:3773
						local entity = force_entities[i] -- models/free-market.can:3775
						stack["count"] = count_in_storage -- models/free-market.can:3782
						local inserted_count = entity["insert"](stack) -- models/free-market.can:3783
						inserted_count_in_total = inserted_count_in_total + inserted_count -- models/free-market.can:3784
						count_in_storage = count_in_storage - inserted_count -- models/free-market.can:3785
					end -- models/free-market.can:3785
					storage[item_name] = count_in_storage -- models/free-market.can:3790
				end -- models/free-market.can:3790
			end -- models/free-market.can:3790
			pulled_item_count[force_index] = inserted_count_in_total -- models/free-market.can:3793
		end -- models/free-market.can:3793
	end -- models/free-market.can:3793
	if pull_cost_per_item == 0 then -- models/free-market.can:3797
		return  -- models/free-market.can:3797
	end -- models/free-market.can:3797
	for force_index, count in pairs(pulled_item_count) do -- models/free-market.can:3798
		if count > 0 then -- models/free-market.can:3799
			call("EasyAPI", "deposit_force_money_by_index", force_index, - ceil(count * pull_cost_per_item)) -- models/free-market.can:3802
		end -- models/free-market.can:3802
	end -- models/free-market.can:3802
end -- models/free-market.can:3802
local function check_transfer_boxes() -- models/free-market.can:3808
	stack["count"] = 4000000000 -- models/free-market.can:3809
	for force_index, force_entities in pairs(__universal_bin_boxes) do -- models/free-market.can:3810
		local storage = __storages[force_index] -- models/free-market.can:3811
		for i = # force_entities, 1, - 1 do -- models/free-market.can:3812
			local entity = force_entities[i] -- models/free-market.can:3813
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3820
			for item_name in pairs(contents) do -- models/free-market.can:3821
				local count = storage[item_name] or 0 -- models/free-market.can:3822
				stack["name"] = item_name -- models/free-market.can:3823
				local sum = entity["remove_item"](stack) -- models/free-market.can:3824
				if sum > 0 then -- models/free-market.can:3825
					storage[item_name] = count + sum -- models/free-market.can:3826
				end -- models/free-market.can:3826
			end -- models/free-market.can:3826
		end -- models/free-market.can:3826
	end -- models/free-market.can:3826
	for force_index, _items_data in pairs(__bin_boxes) do -- models/free-market.can:3835
		local storage = __storages[force_index] -- models/free-market.can:3836
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3837
			local count = storage[item_name] or 0 -- models/free-market.can:3838
			stack["name"] = item_name -- models/free-market.can:3839
			local sum = 0 -- models/free-market.can:3840
			for i = # force_entities, 1, - 1 do -- models/free-market.can:3841
				local entity = force_entities[i] -- models/free-market.can:3842
				sum = sum + entity["remove_item"](stack) -- models/free-market.can:3849
			end -- models/free-market.can:3849
			if sum > 0 then -- models/free-market.can:3854
				storage[item_name] = count + sum -- models/free-market.can:3855
			end -- models/free-market.can:3855
		end -- models/free-market.can:3855
	end -- models/free-market.can:3855
	for force_index, force_entities in pairs(__universal_transfer_boxes) do -- models/free-market.can:3861
		local default_limit = __default_storage_limit[force_index] -- models/free-market.can:3862
		local storage_limit = __storages_limit[force_index] -- models/free-market.can:3863
		local storage = __storages[force_index] -- models/free-market.can:3864
		for i = # force_entities, 1, - 1 do -- models/free-market.can:3865
			local entity = force_entities[i] -- models/free-market.can:3866
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3873
			for item_name in pairs(contents) do -- models/free-market.can:3874
				local count = storage[item_name] or 0 -- models/free-market.can:3875
				local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3876
				if max_count > 0 then -- models/free-market.can:3877
					stack["count"] = max_count -- models/free-market.can:3878
					stack["name"] = item_name -- models/free-market.can:3879
					local sum = entity["remove_item"](stack) -- models/free-market.can:3880
					if sum > 0 then -- models/free-market.can:3881
						storage[item_name] = count + sum -- models/free-market.can:3882
					end -- models/free-market.can:3882
				end -- models/free-market.can:3882
			end -- models/free-market.can:3882
		end -- models/free-market.can:3882
	end -- models/free-market.can:3882
	for force_index, _items_data in pairs(__transfer_boxes) do -- models/free-market.can:3892
		local default_limit = __default_storage_limit[force_index] -- models/free-market.can:3893
		local storage_limit = __storages_limit[force_index] -- models/free-market.can:3894
		local storage = __storages[force_index] -- models/free-market.can:3895
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3896
			local count = storage[item_name] or 0 -- models/free-market.can:3897
			local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3898
			if max_count > 0 then -- models/free-market.can:3899
				stack["count"] = max_count -- models/free-market.can:3900
				stack["name"] = item_name -- models/free-market.can:3901
				local sum = 0 -- models/free-market.can:3902
				for i = # force_entities, 1, - 1 do -- models/free-market.can:3903
					local entity = force_entities[i] -- models/free-market.can:3904
					sum = sum + entity["remove_item"](stack) -- models/free-market.can:3912
				end -- models/free-market.can:3912
				if sum > 0 then -- models/free-market.can:3917
					storage[item_name] = count + sum -- models/free-market.can:3918
				end -- models/free-market.can:3918
			end -- models/free-market.can:3918
		end -- models/free-market.can:3918
	end -- models/free-market.can:3918
end -- models/free-market.can:3918
local function check_buy_boxes() -- models/free-market.can:3925
	local last_checked_index = __mod_data["last_checked_index"] -- models/free-market.can:3926
	local buyer_index -- models/free-market.can:3927
	if last_checked_index then -- models/free-market.can:3928
		buyer_index = __active_forces[last_checked_index] -- models/free-market.can:3929
		if buyer_index then -- models/free-market.can:3930
			__mod_data["last_checked_index"] = last_checked_index + 1 -- models/free-market.can:3931
		else -- models/free-market.can:3931
			__mod_data["last_checked_index"] = nil -- models/free-market.can:3933
			return  -- models/free-market.can:3934
		end -- models/free-market.can:3934
	else -- models/free-market.can:3934
		last_checked_index, buyer_index = next(__active_forces) -- models/free-market.can:3937
		if last_checked_index then -- models/free-market.can:3938
			__mod_data["last_checked_index"] = last_checked_index -- models/free-market.can:3939
		else -- models/free-market.can:3939
			return  -- models/free-market.can:3941
		end -- models/free-market.can:3941
	end -- models/free-market.can:3941
	local items_data = __buy_boxes[buyer_index] -- models/free-market.can:3945
	if items_data == nil then -- models/free-market.can:3947
		return  -- models/free-market.can:3947
	end -- models/free-market.can:3947
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:3949
	local buyer_money = forces_money[buyer_index] -- models/free-market.can:3950
	if buyer_money == nil or buyer_money <= money_treshold then -- models/free-market.can:3951
		return  -- models/free-market.can:3952
	end -- models/free-market.can:3952
	local stack_count = 0 -- models/free-market.can:3955
	local payment = 0 -- models/free-market.can:3956
	local f_buy_prices = __buy_prices[buyer_index] -- models/free-market.can:3957
	local inserted_count_in_total = 0 -- models/free-market.can:3958
	for item_name, entities in pairs(items_data) do -- models/free-market.can:3959
		if money_treshold >= buyer_money then -- models/free-market.can:3960
			goto not_enough_money -- models/free-market.can:3962
		end -- models/free-market.can:3962
		local buy_price = f_buy_prices[item_name] -- models/free-market.can:3964
		if buy_price and buyer_money >= buy_price then -- models/free-market.can:3965
			for i = # entities, 1, - 1 do -- models/free-market.can:3966
				local buy_data = entities[i] -- models/free-market.can:3967
				local purchasable_count = buyer_money / buy_price -- models/free-market.can:3968
				if purchasable_count < 1 then -- models/free-market.can:3969
					goto skip_buy -- models/free-market.can:3970
				else -- models/free-market.can:3970
					purchasable_count = floor(purchasable_count) -- models/free-market.can:3972
				end -- models/free-market.can:3972
				local buy_box = buy_data[1] -- models/free-market.can:3974
				local need_count = buy_data[2] -- models/free-market.can:3981
				if purchasable_count < need_count then -- models/free-market.can:3982
					need_count = purchasable_count -- models/free-market.can:3983
				end -- models/free-market.can:3983
				local count = buy_box["get_item_count"](item_name) -- models/free-market.can:3985
				stack["name"] = item_name -- models/free-market.can:3986
				if need_count < count then -- models/free-market.can:3987
					stack_count = count -- models/free-market.can:3988
				else -- models/free-market.can:3988
					need_count = need_count - count -- models/free-market.can:3990
					if need_count <= 0 then -- models/free-market.can:3991
						goto skip_buy -- models/free-market.can:3992
					end -- models/free-market.can:3992
					local buyer_storage = __storages[buyer_index] -- models/free-market.can:3995
					local count_in_storage = buyer_storage[item_name] -- models/free-market.can:3996
					if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3997
						stack_count = need_count - count_in_storage -- models/free-market.can:3998
						if stack_count <= 0 then -- models/free-market.can:3999
							buyer_storage[item_name] = count_in_storage - need_count -- models/free-market.can:4000
							stack_count = 0 -- models/free-market.can:4001
							goto fulfilled_needs -- models/free-market.can:4002
						else -- models/free-market.can:4002
							buyer_storage[item_name] = count_in_storage + (stack_count - need_count) -- models/free-market.can:4004
						end -- models/free-market.can:4004
					else -- models/free-market.can:4004
						stack_count = need_count -- models/free-market.can:4007
					end -- models/free-market.can:4007
					for seller_index, seller_storage in pairs(__storages) do -- models/free-market.can:4010
						if buyer_index ~= seller_index and forces_money[seller_index] and not __embargoes[seller_index][buyer_index] then -- models/free-market.can:4011
							local sell_price = __sell_prices[seller_index][item_name] -- models/free-market.can:4012
							if sell_price and buy_price >= sell_price then -- models/free-market.can:4013
								count_in_storage = seller_storage[item_name] -- models/free-market.can:4014
								if count_in_storage then -- models/free-market.can:4015
									if count_in_storage > stack_count then -- models/free-market.can:4016
										seller_storage[item_name] = count_in_storage - stack_count -- models/free-market.can:4017
										stack_count = 0 -- models/free-market.can:4018
										payment = need_count * sell_price -- models/free-market.can:4019
										buyer_money = buyer_money - payment -- models/free-market.can:4020
										forces_money[seller_index] = forces_money[seller_index] + payment -- models/free-market.can:4021
										goto fulfilled_needs -- models/free-market.can:4022
									else -- models/free-market.can:4022
										stack_count = stack_count - count_in_storage -- models/free-market.can:4024
										seller_storage[item_name] = 0 -- models/free-market.can:4025
										payment = (need_count - stack_count) * sell_price -- models/free-market.can:4026
										buyer_money = buyer_money - payment -- models/free-market.can:4027
										forces_money[seller_index] = forces_money[seller_index] + payment -- models/free-market.can:4028
									end -- models/free-market.can:4028
								end -- models/free-market.can:4028
							end -- models/free-market.can:4028
						end -- models/free-market.can:4028
					end -- models/free-market.can:4028
				end -- models/free-market.can:4028
				::fulfilled_needs:: -- models/free-market.can:4035
				local found_items = need_count - stack_count -- models/free-market.can:4036
				if found_items > 0 then -- models/free-market.can:4037
					stack["count"] = found_items -- models/free-market.can:4038
					inserted_count_in_total = inserted_count_in_total + buy_box["insert"](stack) -- models/free-market.can:4039
				end -- models/free-market.can:4039
				::skip_buy:: -- models/free-market.can:4041
			end -- models/free-market.can:4041
		end -- models/free-market.can:4041
	end -- models/free-market.can:4041
	::not_enough_money:: -- models/free-market.can:4045
	if pull_cost_per_item == 0 then -- models/free-market.can:4046
		forces_money[buyer_index] = buyer_money -- models/free-market.can:4047
	else -- models/free-market.can:4047
		forces_money[buyer_index] = buyer_money - ceil(inserted_count_in_total * pull_cost_per_item) -- models/free-market.can:4049
	end -- models/free-market.can:4049
	local forces = game["forces"] -- models/free-market.can:4052
	call("EasyAPI", "set_forces_money", forces_money) -- models/free-market.can:4053
	for _force_index, money in pairs(forces_money) do -- models/free-market.can:4054
		local prev_money = forces_money[_force_index] -- models/free-market.can:4055
		if prev_money ~= money then -- models/free-market.can:4056
			local force = forces[_force_index] -- models/free-market.can:4057
			force["item_production_statistics"]["on_flow"]("trading", money - prev_money) -- models/free-market.can:4059
		end -- models/free-market.can:4059
	end -- models/free-market.can:4059
end -- models/free-market.can:4059
local function on_player_changed_force(event) -- models/free-market.can:4064
	local player_index = event["player_index"] -- models/free-market.can:4065
	local player = game["get_player"](player_index) -- models/free-market.can:4066
	if not (player and player["valid"]) then -- models/free-market.can:4067
		return  -- models/free-market.can:4067
	end -- models/free-market.can:4067
	if __open_box[player_index] then -- models/free-market.can:4069
		clear_boxes_gui(player) -- models/free-market.can:4070
	end -- models/free-market.can:4070
	local force_index = player["force_index"] -- models/free-market.can:4073
	if __transfer_boxes[force_index] == nil then -- models/free-market.can:4074
		init_force_data(force_index) -- models/free-market.can:4075
	end -- models/free-market.can:4075
end -- models/free-market.can:4075
local function on_player_changed_surface(event) -- models/free-market.can:4079
	local player_index = event["player_index"] -- models/free-market.can:4080
	local player = game["get_player"](player_index) -- models/free-market.can:4081
	if not (player and player["valid"]) then -- models/free-market.can:4082
		return  -- models/free-market.can:4082
	end -- models/free-market.can:4082
	if __open_box[player_index] then -- models/free-market.can:4084
		clear_boxes_gui(player) -- models/free-market.can:4085
	end -- models/free-market.can:4085
end -- models/free-market.can:4085
local function on_player_left_game(event) -- models/free-market.can:4089
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:4090
	if not (player and player["valid"]) then -- models/free-market.can:4091
		return  -- models/free-market.can:4091
	end -- models/free-market.can:4091
	clear_boxes_gui(player) -- models/free-market.can:4093
	destroy_prices_gui(player) -- models/free-market.can:4094
	delete_item_price_HUD(player) -- models/free-market.can:4095
	destroy_price_list_gui(player) -- models/free-market.can:4096
	destroy_force_configuration(player) -- models/free-market.can:4097
end -- models/free-market.can:4097
local function on_selected_entity_changed(event) -- models/free-market.can:4100
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:4101
	if not (player and player["valid"]) then -- models/free-market.can:4102
		return  -- models/free-market.can:4102
	end -- models/free-market.can:4102
	local entity = player["selected"] -- models/free-market.can:4103
	if not (entity and entity["valid"]) then -- models/free-market.can:4104
		return  -- models/free-market.can:4104
	end -- models/free-market.can:4104
	if not ALLOWED_CHEST_TYPES[entity["type"]] then -- models/free-market.can:4105
		return  -- models/free-market.can:4105
	end -- models/free-market.can:4105
	if entity["force"] ~= player["force"] then -- models/free-market.can:4106
		return  -- models/free-market.can:4106
	end -- models/free-market.can:4106
	local box_data = __all_boxes[entity["unit_number"]] -- models/free-market.can:4107
	if box_data == nil then -- models/free-market.can:4108
		return  -- models/free-market.can:4108
	end -- models/free-market.can:4108
	local item_name = box_data[5] -- models/free-market.can:4109
	if item_name == nil then -- models/free-market.can:4110
		return  -- models/free-market.can:4110
	end -- models/free-market.can:4110
	show_item_info_HUD(player, item_name) -- models/free-market.can:4112
end -- models/free-market.can:4112
local SELECT_TOOLS = { -- models/free-market.can:4116
	["FM_set_pull_boxes_tool"] = set_pull_box_data, -- models/free-market.can:4117
	["FM_set_bin_boxes_tool"] = set_bin_box_data, -- models/free-market.can:4118
	["FM_set_transfer_boxes_tool"] = set_transfer_box_data, -- models/free-market.can:4119
	["FM_set_buy_boxes_tool"] = set_buy_box_data -- models/free-market.can:4120
} -- models/free-market.can:4120
local function on_player_selected_area(event) -- models/free-market.can:4122
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:4123
	if not (player and player["valid"]) then -- models/free-market.can:4124
		return  -- models/free-market.can:4124
	end -- models/free-market.can:4124
	local tool_name = event["item"] -- models/free-market.can:4126
	local func = SELECT_TOOLS[tool_name] -- models/free-market.can:4127
	if func then -- models/free-market.can:4128
		local entities = event["entities"] -- models/free-market.can:4129
		for i = 1, # entities do -- models/free-market.can:4130
			local entity = entities[i] -- models/free-market.can:4131
			if entity["valid"] and __all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:4132
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:4133
				if item["valid_for_read"] then -- models/free-market.can:4134
					func(item["name"], entity) -- models/free-market.can:4135
				end -- models/free-market.can:4135
			end -- models/free-market.can:4135
		end -- models/free-market.can:4135
	elseif tool_name == "FM_set_universal_transfer_boxes_tool" then -- models/free-market.can:4139
		local entities = event["entities"] -- models/free-market.can:4140
		for i = 1, # entities do -- models/free-market.can:4141
			local entity = entities[i] -- models/free-market.can:4142
			if entity["valid"] and __all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:4143
				set_universal_transfer_box_data(entity) -- models/free-market.can:4144
			end -- models/free-market.can:4144
		end -- models/free-market.can:4144
	elseif tool_name == "FM_set_universal_bin_boxes_tool" then -- models/free-market.can:4147
		local entities = event["entities"] -- models/free-market.can:4148
		for i = 1, # entities do -- models/free-market.can:4149
			local entity = entities[i] -- models/free-market.can:4150
			if entity["valid"] and __all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:4151
				set_universal_bin_box_data(entity) -- models/free-market.can:4152
			end -- models/free-market.can:4152
		end -- models/free-market.can:4152
	elseif tool_name == "FM_remove_boxes_tool" then -- models/free-market.can:4155
		local entities = event["entities"] -- models/free-market.can:4156
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4157
		local count = 0 -- models/free-market.can:4158
		for i = 1, # entities do -- models/free-market.can:4159
			local entity = entities[i] -- models/free-market.can:4160
			if entity["valid"] then -- models/free-market.can:4161
				local is_deleted = clear_box_data_by_entity(entity) -- models/free-market.can:4162
				if is_deleted then -- models/free-market.can:4163
					count = count + 1 -- models/free-market.can:4164
				end -- models/free-market.can:4164
			end -- models/free-market.can:4164
		end -- models/free-market.can:4164
		if count > 0 then -- models/free-market.can:4168
			player["print"]({ -- models/free-market.can:4169
				"", -- models/free-market.can:4169
				{ "gui-migrated-content.removed-entity" }, -- models/free-market.can:4169
				COLON, -- models/free-market.can:4169
				" ", -- models/free-market.can:4169
				count -- models/free-market.can:4169
			}) -- models/free-market.can:4169
		end -- models/free-market.can:4169
	end -- models/free-market.can:4169
end -- models/free-market.can:4169
do -- models/free-market.can:4176
	local TOOL_TO_TYPE = { -- models/free-market.can:4176
		["FM_set_pull_boxes_tool"] = 3, -- models/free-market.can:1
		["FM_set_transfer_boxes_tool"] = 4, -- models/free-market.can:1
		["FM_set_universal_transfer_boxes_tool"] = 5, -- models/free-market.can:1
		["FM_set_universal_bin_boxes_tool"] = 7, -- models/free-market.can:1
		["FM_set_bin_boxes_tool"] = 6, -- models/free-market.can:1
		["FM_set_buy_boxes_tool"] = 1 -- models/free-market.can:1
	} -- models/free-market.can:1
	on_player_alt_selected_area = function(event) -- models/free-market.can:4184
		local box_type = TOOL_TO_TYPE[event["item"]] -- models/free-market.can:4185
		if box_type == nil then -- models/free-market.can:4186
			return  -- models/free-market.can:4186
		end -- models/free-market.can:4186
		local remove_box = REMOVE_BOX_FUNCS[box_type] -- models/free-market.can:4188
		local entities = event["entities"] -- models/free-market.can:4189
		for i = # entities, 1, - 1 do -- models/free-market.can:4190
			local entity = entities[i] -- models/free-market.can:4191
			if entity["valid"] then -- models/free-market.can:4192
				local unit_number = entity["unit_number"] -- models/free-market.can:4193
				local box_data = __all_boxes[unit_number] -- models/free-market.can:4194
				if box_data and box_data[3] == box_type then -- models/free-market.can:4195
					local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:4196
					rendered["destroy"]() -- models/free-market.can:4197
					remove_box(entity, box_data) -- models/free-market.can:4198
				end -- models/free-market.can:4198
			end -- models/free-market.can:4198
		end -- models/free-market.can:4198
	end -- models/free-market.can:4198
end -- models/free-market.can:4198
local mod_settings = { -- models/free-market.can:4206
	["FM_enable-auto-embargo"] = function(value) -- models/free-market.can:4207
		is_auto_embargo = value -- models/free-market.can:4207
	end, -- models/free-market.can:4207
	["FM_is-public-titles"] = function(value) -- models/free-market.can:4208
		is_public_titles = value -- models/free-market.can:4208
	end, -- models/free-market.can:4208
	["FM_is_reset_public"] = function(value) -- models/free-market.can:4209
		is_reset_public = value -- models/free-market.can:4209
	end, -- models/free-market.can:4209
	["FM_money-treshold"] = function(value) -- models/free-market.can:4210
		money_treshold = value -- models/free-market.can:4210
	end, -- models/free-market.can:4210
	["FM_minimal-price"] = function(value) -- models/free-market.can:4211
		minimal_price = value -- models/free-market.can:4211
	end, -- models/free-market.can:4211
	["FM_maximal-price"] = function(value) -- models/free-market.can:4212
		maximal_price = value -- models/free-market.can:4212
	end, -- models/free-market.can:4212
	["FM_skip_offline_team_chance"] = function(value) -- models/free-market.can:4213
		skip_offline_team_chance = value -- models/free-market.can:4213
	end, -- models/free-market.can:4213
	["FM_max_storage_threshold"] = function(value) -- models/free-market.can:4214
		max_storage_threshold = value -- models/free-market.can:4214
	end, -- models/free-market.can:4214
	["FM_pull_cost_per_item"] = function(value) -- models/free-market.can:4215
		pull_cost_per_item = value -- models/free-market.can:4215
	end, -- models/free-market.can:4215
	["FM_update-tick"] = function(value) -- models/free-market.can:4216
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4217
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4219
			return  -- models/free-market.can:4221
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4222
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4224
			return  -- models/free-market.can:4226
		elseif update_pull_tick == value then -- models/free-market.can:4227
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4229
			return  -- models/free-market.can:4231
		elseif update_transfer_tick == value then -- models/free-market.can:4232
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4234
			return  -- models/free-market.can:4236
		end -- models/free-market.can:4236
		script["on_nth_tick"](update_buy_tick, nil) -- models/free-market.can:4238
		update_buy_tick = value -- models/free-market.can:4239
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4240
	end, -- models/free-market.can:4240
	["FM_update-transfer-tick"] = function(value) -- models/free-market.can:4242
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4243
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4245
			return  -- models/free-market.can:4247
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4248
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4250
			return  -- models/free-market.can:4252
		elseif update_pull_tick == value then -- models/free-market.can:4253
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4255
			return  -- models/free-market.can:4257
		elseif update_buy_tick == value then -- models/free-market.can:4258
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4260
			return  -- models/free-market.can:4262
		end -- models/free-market.can:4262
		script["on_nth_tick"](update_transfer_tick, nil) -- models/free-market.can:4264
		update_transfer_tick = value -- models/free-market.can:4265
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4266
	end, -- models/free-market.can:4266
	["FM_update-pull-tick"] = function(value) -- models/free-market.can:4268
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4269
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4271
			return  -- models/free-market.can:4273
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4274
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4276
			return  -- models/free-market.can:4278
		elseif update_transfer_tick == value then -- models/free-market.can:4279
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4281
			return  -- models/free-market.can:4283
		elseif update_buy_tick == value then -- models/free-market.can:4284
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4286
			return  -- models/free-market.can:4288
		end -- models/free-market.can:4288
		script["on_nth_tick"](update_pull_tick, nil) -- models/free-market.can:4290
		update_pull_tick = value -- models/free-market.can:4291
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4292
	end, -- models/free-market.can:4292
	["FM_show_item_price"] = function(player) -- models/free-market.can:4294
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4295
			create_item_price_HUD(player) -- models/free-market.can:4296
		else -- models/free-market.can:4296
			delete_item_price_HUD(player) -- models/free-market.can:4298
		end -- models/free-market.can:4298
	end, -- models/free-market.can:4298
	["FM_sell_notification_column_count"] = function(player) -- models/free-market.can:4301
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:4302
		local is_vertical = (column_count == 2) -- models/free-market.can:4303
		local frame = player["gui"]["screen"]["FM_sell_prices_frame"] -- models/free-market.can:4304
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4305
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4306
			local last_location = frame["location"] -- models/free-market.can:4307
			frame["destroy"]() -- models/free-market.can:4308
			switch_sell_prices_gui(player, last_location) -- models/free-market.can:4309
		end -- models/free-market.can:4309
	end, -- models/free-market.can:4309
	["FM_buy_notification_column_count"] = function(player) -- models/free-market.can:4312
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:4313
		local is_vertical = (column_count == 2) -- models/free-market.can:4314
		local frame = player["gui"]["screen"]["FM_buy_prices_frame"] -- models/free-market.can:4315
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4316
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4317
			local last_location = frame["location"] -- models/free-market.can:4318
			frame["destroy"]() -- models/free-market.can:4319
			switch_buy_prices_gui(player, last_location) -- models/free-market.can:4320
		end -- models/free-market.can:4320
	end -- models/free-market.can:4320
} -- models/free-market.can:4320
on_runtime_mod_setting_changed = function(event) -- models/free-market.can:4324
	local setting_name = event["setting"] -- models/free-market.can:4325
	local f = mod_settings[setting_name] -- models/free-market.can:4326
	if f == nil then -- models/free-market.can:4327
		return  -- models/free-market.can:4327
	end -- models/free-market.can:4327
	if event["setting_type"] == "runtime-global" then -- models/free-market.can:4329
		f(settings["global"][setting_name]["value"]) -- models/free-market.can:4330
	else -- models/free-market.can:4330
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4332
		if player and player["valid"] then -- models/free-market.can:4333
			f(player) -- models/free-market.can:4334
		end -- models/free-market.can:4334
	end -- models/free-market.can:4334
end -- models/free-market.can:4334
local function add_remote_interface() -- models/free-market.can:4344
	remote["remove_interface"]("free-market") -- models/free-market.can:4346
	remote["add_interface"]("free-market", { -- models/free-market.can:4347
		["get_mod_data"] = function() -- models/free-market.can:4348
			return __mod_data -- models/free-market.can:4348
		end, -- models/free-market.can:4348
		["get_internal_data"] = function(name) -- models/free-market.can:4349
			return __mod_data[name] -- models/free-market.can:4349
		end, -- models/free-market.can:4349
		["change_count_in_buy_box_data"] = change_count_in_buy_box_data, -- models/free-market.can:4350
		["remove_certain_pull_box"] = remove_certain_pull_box, -- models/free-market.can:4351
		["remove_certain_transfer_box"] = remove_certain_transfer_box, -- models/free-market.can:4352
		["remove_certain_universal_transfer_box"] = remove_certain_universal_transfer_box, -- models/free-market.can:4353
		["remove_certain_bin_box"] = remove_certain_bin_box, -- models/free-market.can:4354
		["remove_certain_universal_bin_box"] = remove_certain_universal_bin_box, -- models/free-market.can:4355
		["remove_certain_buy_box"] = remove_certain_buy_box, -- models/free-market.can:4356
		["clear_box_data_by_entity"] = clear_box_data_by_entity, -- models/free-market.can:4357
		["resetTransferBoxes"] = resetTransferBoxes, -- models/free-market.can:4358
		["resetUniversalTransferBoxes"] = resetUniversalTransferBoxes, -- models/free-market.can:4359
		["resetBinBoxes"] = resetBinBoxes, -- models/free-market.can:4360
		["resetUniversalBinBoxes"] = resetUniversalBinBoxes, -- models/free-market.can:4361
		["resetPullBoxes"] = resetPullBoxes, -- models/free-market.can:4362
		["resetBuyBoxes"] = resetBuyBoxes, -- models/free-market.can:4363
		["resetAllBoxes"] = resetAllBoxes, -- models/free-market.can:4364
		["clear_force_data"] = clear_force_data, -- models/free-market.can:4365
		["init_force_data"] = init_force_data, -- models/free-market.can:4366
		["set_universal_transfer_box_data"] = set_universal_transfer_box_data, -- models/free-market.can:4367
		["set_universal_bin_box_data"] = set_universal_bin_box_data, -- models/free-market.can:4368
		["set_transfer_box_data"] = set_transfer_box_data, -- models/free-market.can:4369
		["set_bin_box_data"] = set_bin_box_data, -- models/free-market.can:4370
		["set_pull_box_data"] = set_pull_box_data, -- models/free-market.can:4371
		["set_buy_box_data"] = set_buy_box_data, -- models/free-market.can:4372
		["set_item_limit"] = function(item_name, force_index, count) -- models/free-market.can:4373
			local f_storages_limit = __storages_limit[force_index] -- models/free-market.can:4374
			if f_storages_limit == nil then -- models/free-market.can:4375
				return  -- models/free-market.can:4375
			end -- models/free-market.can:4375
			f_storages_limit[item_name] = count -- models/free-market.can:4376
		end, -- models/free-market.can:4376
		["set_default_storage_limit"] = function(force_index, count) -- models/free-market.can:4378
			local f_default_storage_limit = __default_storage_limit[force_index] -- models/free-market.can:4379
			if f_default_storage_limit == nil then -- models/free-market.can:4380
				return  -- models/free-market.can:4380
			end -- models/free-market.can:4380
			__default_storage_limit[force_index] = count -- models/free-market.can:4381
		end, -- models/free-market.can:4381
		["set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4383
			local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:4384
			if f_sell_prices == nil then -- models/free-market.can:4385
				return  -- models/free-market.can:4385
			end -- models/free-market.can:4385
			local transferers = __transfer_boxes[force_index][item_name] -- models/free-market.can:4387
			local count_in_storage = __storages[force_index][item_name] -- models/free-market.can:4388
			if f_sell_prices[item_name] or transferers ~= nil or (count_in_storage and count_in_storage > 0) then -- models/free-market.can:4389
				f_sell_prices[item_name] = price -- models/free-market.can:4390
				__inactive_sell_prices[force_index] = nil -- models/free-market.can:4391
			else -- models/free-market.can:4391
				f_sell_prices[item_name] = nil -- models/free-market.can:4393
				__inactive_sell_prices[force_index][item_name] = price -- models/free-market.can:4394
			end -- models/free-market.can:4394
		end, -- models/free-market.can:4394
		["set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4397
			local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:4398
			if f_buy_prices == nil then -- models/free-market.can:4399
				return  -- models/free-market.can:4399
			end -- models/free-market.can:4399
			local f_buy_boxes = __buy_boxes[force_index][item_name] -- models/free-market.can:4401
			if f_buy_prices[item_name] or f_buy_boxes ~= nil then -- models/free-market.can:4402
				f_buy_prices[item_name] = price -- models/free-market.can:4403
				__inactive_buy_prices[force_index] = nil -- models/free-market.can:4404
			else -- models/free-market.can:4404
				f_buy_prices[item_name] = nil -- models/free-market.can:4406
				__inactive_buy_prices[force_index][item_name] = price -- models/free-market.can:4407
			end -- models/free-market.can:4407
		end, -- models/free-market.can:4407
		["force_set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4410
			local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:4411
			if f_sell_prices == nil then -- models/free-market.can:4412
				return  -- models/free-market.can:4412
			end -- models/free-market.can:4412
			f_sell_prices[item_name] = price -- models/free-market.can:4413
			__inactive_sell_prices[force_index][item_name] = nil -- models/free-market.can:4414
		end, -- models/free-market.can:4414
		["force_set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4416
			local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:4417
			if f_buy_prices == nil then -- models/free-market.can:4418
				return  -- models/free-market.can:4418
			end -- models/free-market.can:4418
			f_buy_prices[item_name] = price -- models/free-market.can:4419
			__inactive_buy_prices[force_index][item_name] = nil -- models/free-market.can:4420
		end, -- models/free-market.can:4420
		["reset_AI_force_storage"] = function(force_index) -- models/free-market.can:4422
			local f_sell_prices = __sell_prices[force_index] -- models/free-market.can:4423
			if f_sell_prices == nil then -- models/free-market.can:4424
				return  -- models/free-market.can:4424
			end -- models/free-market.can:4424
			local f_inactive_sell_prices = __inactive_sell_prices[force_index] -- models/free-market.can:4426
			for item_name, price in pairs(f_inactive_sell_prices) do -- models/free-market.can:4427
				f_sell_prices[item_name] = price -- models/free-market.can:4428
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:4429
			end -- models/free-market.can:4429
			local f_buy_prices = __buy_prices[force_index] -- models/free-market.can:4431
			local f_inactive_buy_prices = __inactive_buy_prices[force_index] -- models/free-market.can:4432
			for item_name, price in pairs(f_inactive_buy_prices) do -- models/free-market.can:4433
				f_buy_prices[item_name] = price -- models/free-market.can:4434
				f_inactive_buy_prices[item_name] = nil -- models/free-market.can:4435
			end -- models/free-market.can:4435
			local f_storages_limit = __storages_limit[force_index] -- models/free-market.can:4439
			local f_storage = __storages[force_index] -- models/free-market.can:4440
			for item_name in pairs(f_buy_prices) do -- models/free-market.can:4441
				f_storage[item_name] = 2000000000 -- models/free-market.can:4442
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4443
			end -- models/free-market.can:4443
			for item_name in pairs(f_sell_prices) do -- models/free-market.can:4445
				f_storage[item_name] = 2000000000 -- models/free-market.can:4446
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4447
			end -- models/free-market.can:4447
		end, -- models/free-market.can:4447
		["get_item_limit"] = function(item_name, force_index) -- models/free-market.can:4450
			local f_storages_limit = __storages_limit[force_index] -- models/free-market.can:4451
			if f_storages_limit == nil then -- models/free-market.can:4452
				return  -- models/free-market.can:4452
			end -- models/free-market.can:4452
			return f_storages_limit[item_name] -- models/free-market.can:4453
		end, -- models/free-market.can:4453
		["get_default_storage_limit"] = function(force_index) -- models/free-market.can:4455
			return __default_storage_limit[force_index] -- models/free-market.can:4456
		end, -- models/free-market.can:4456
		["get_inactive_universal_transfer_boxes"] = function() -- models/free-market.can:4458
			return __inactive_universal_transfer_boxes -- models/free-market.can:4458
		end, -- models/free-market.can:4458
		["get_inactive_universal_bin_boxes"] = function() -- models/free-market.can:4459
			return __inactive_universal_bin_boxes -- models/free-market.can:4459
		end, -- models/free-market.can:4459
		["get_inactive_bin_boxes"] = function() -- models/free-market.can:4460
			return __inactive_bin_boxes -- models/free-market.can:4460
		end, -- models/free-market.can:4460
		["get_inactive_transfer_boxes"] = function() -- models/free-market.can:4461
			return __inactive_transfer_boxes -- models/free-market.can:4461
		end, -- models/free-market.can:4461
		["get_inactive_sell_prices"] = function() -- models/free-market.can:4462
			return __inactive_sell_prices -- models/free-market.can:4462
		end, -- models/free-market.can:4462
		["get_inactive_buy_prices"] = function() -- models/free-market.can:4463
			return __inactive_buy_prices -- models/free-market.can:4463
		end, -- models/free-market.can:4463
		["get_inactive_buy_boxes"] = function() -- models/free-market.can:4464
			return __inactive_buy_boxes -- models/free-market.can:4464
		end, -- models/free-market.can:4464
		["get_universal_bin_boxes"] = function() -- models/free-market.can:4465
			return __universal_bin_boxes -- models/free-market.can:4465
		end, -- models/free-market.can:4465
		["get_transfer_boxes"] = function() -- models/free-market.can:4466
			return __transfer_boxes -- models/free-market.can:4466
		end, -- models/free-market.can:4466
		["get_bin_boxes"] = function() -- models/free-market.can:4467
			return __bin_boxes -- models/free-market.can:4467
		end, -- models/free-market.can:4467
		["get_pull_boxes"] = function() -- models/free-market.can:4468
			return __pull_boxes -- models/free-market.can:4468
		end, -- models/free-market.can:4468
		["get_buy_boxes"] = function() -- models/free-market.can:4469
			return __buy_boxes -- models/free-market.can:4469
		end, -- models/free-market.can:4469
		["get_sell_prices"] = function() -- models/free-market.can:4470
			return __sell_prices -- models/free-market.can:4470
		end, -- models/free-market.can:4470
		["get_buy_prices"] = function() -- models/free-market.can:4471
			return __buy_prices -- models/free-market.can:4471
		end, -- models/free-market.can:4471
		["get_embargoes"] = function() -- models/free-market.can:4472
			return __embargoes -- models/free-market.can:4472
		end, -- models/free-market.can:4472
		["get_open_box"] = function() -- models/free-market.can:4473
			return __open_box -- models/free-market.can:4473
		end, -- models/free-market.can:4473
		["get_all_boxes"] = function() -- models/free-market.can:4474
			return __all_boxes -- models/free-market.can:4474
		end, -- models/free-market.can:4474
		["get_active_forces"] = function() -- models/free-market.can:4475
			return __active_forces -- models/free-market.can:4475
		end, -- models/free-market.can:4475
		["get_storages"] = function() -- models/free-market.can:4476
			return __storages -- models/free-market.can:4476
		end -- models/free-market.can:4476
	}) -- models/free-market.can:4476
end -- models/free-market.can:4476
local function link_data() -- models/free-market.can:4480
	__mod_data = storage["free_market"] -- models/free-market.can:4481
	__bin_boxes = __mod_data["bin_boxes"] -- models/free-market.can:4482
	__inactive_bin_boxes = __mod_data["inactive_bin_boxes"] -- models/free-market.can:4483
	__universal_bin_boxes = __mod_data["universal_bin_boxes"] -- models/free-market.can:4484
	__inactive_universal_bin_boxes = __mod_data["universal_inactive_bin_boxes"] -- models/free-market.can:4485
	__pull_boxes = __mod_data["pull_boxes"] -- models/free-market.can:4486
	__inactive_universal_transfer_boxes = __mod_data["inactive_universal_transfer_boxes"] -- models/free-market.can:4487
	__inactive_transfer_boxes = __mod_data["inactive_transfer_boxes"] -- models/free-market.can:4488
	__inactive_buy_boxes = __mod_data["inactive_buy_boxes"] -- models/free-market.can:4489
	__universal_transfer_boxes = __mod_data["universal_transfer_boxes"] -- models/free-market.can:4490
	__transfer_boxes = __mod_data["transfer_boxes"] -- models/free-market.can:4491
	__buy_boxes = __mod_data["buy_boxes"] -- models/free-market.can:4492
	__embargoes = __mod_data["embargoes"] -- models/free-market.can:4493
	__inactive_sell_prices = __mod_data["inactive_sell_prices"] -- models/free-market.can:4494
	__inactive_buy_prices = __mod_data["inactive_buy_prices"] -- models/free-market.can:4495
	__sell_prices = __mod_data["sell_prices"] -- models/free-market.can:4496
	__buy_prices = __mod_data["buy_prices"] -- models/free-market.can:4497
	__item_HUD = __mod_data["item_hinter"] -- models/free-market.can:4498
	__open_box = __mod_data["open_box"] -- models/free-market.can:4499
	__all_boxes = __mod_data["all_boxes"] -- models/free-market.can:4500
	__active_forces = __mod_data["active_forces"] -- models/free-market.can:4501
	__default_storage_limit = __mod_data["default_storage_limit"] -- models/free-market.can:4502
	__storages_limit = __mod_data["storages_limit"] -- models/free-market.can:4503
	__storages = __mod_data["storages"] -- models/free-market.can:4504
	local id = call("EasyAPI", "get_event_name", "on_entity_changed_force") -- models/free-market.can:4506
	script["on_event"](id, function(event) -- models/free-market.can:4507
		local entity = event["entity"] -- models/free-market.can:4508
		if not (entity and entity["valid"]) then -- models/free-market.can:4509
			return  -- models/free-market.can:4509
		end -- models/free-market.can:4509
		clear_box_data_by_entity(entity) -- models/free-market.can:4510
	end) -- models/free-market.can:4510
end -- models/free-market.can:4510
local function update_global_data() -- models/free-market.can:4514
	storage["free_market"] = storage["free_market"] or {} -- models/free-market.can:4515
	__mod_data = storage["free_market"] -- models/free-market.can:4516
	__mod_data["item_hinter"] = __mod_data["item_hinter"] or {} -- models/free-market.can:4517
	__mod_data["open_box"] = {} -- models/free-market.can:4518
	__mod_data["active_forces"] = __mod_data["active_forces"] or {} -- models/free-market.can:4519
	__mod_data["bin_boxes"] = __mod_data["bin_boxes"] or {} -- models/free-market.can:4520
	__mod_data["inactive_bin_boxes"] = __mod_data["inactive_bin_boxes"] or {} -- models/free-market.can:4521
	__mod_data["universal_bin_boxes"] = __mod_data["universal_bin_boxes"] or {} -- models/free-market.can:4522
	__mod_data["universal_inactive_bin_boxes"] = __mod_data["universal_inactive_bin_boxes"] or {} -- models/free-market.can:4523
	__mod_data["inactive_universal_transfer_boxes"] = __mod_data["inactive_universal_transfer_boxes"] or {} -- models/free-market.can:4524
	__mod_data["inactive_transfer_boxes"] = __mod_data["inactive_transfer_boxes"] or {} -- models/free-market.can:4525
	__mod_data["inactive_buy_boxes"] = __mod_data["inactive_buy_boxes"] or {} -- models/free-market.can:4526
	__mod_data["universal_transfer_boxes"] = __mod_data["universal_transfer_boxes"] or {} -- models/free-market.can:4527
	__mod_data["transfer_boxes"] = __mod_data["transfer_boxes"] or {} -- models/free-market.can:4528
	__mod_data["pull_boxes"] = __mod_data["pull_boxes"] or {} -- models/free-market.can:4529
	__mod_data["buy_boxes"] = __mod_data["buy_boxes"] or {} -- models/free-market.can:4530
	__mod_data["inactive_sell_prices"] = __mod_data["inactive_sell_prices"] or {} -- models/free-market.can:4531
	__mod_data["inactive_buy_prices"] = __mod_data["inactive_buy_prices"] or {} -- models/free-market.can:4532
	__mod_data["sell_prices"] = __mod_data["sell_prices"] or {} -- models/free-market.can:4533
	__mod_data["buy_prices"] = __mod_data["buy_prices"] or {} -- models/free-market.can:4534
	__mod_data["embargoes"] = __mod_data["embargoes"] or {} -- models/free-market.can:4535
	__mod_data["all_boxes"] = __mod_data["all_boxes"] or {} -- models/free-market.can:4536
	__mod_data["default_storage_limit"] = __mod_data["default_storage_limit"] or {} -- models/free-market.can:4537
	__mod_data["storages_limit"] = __mod_data["storages_limit"] or {} -- models/free-market.can:4538
	__mod_data["storages"] = __mod_data["storages"] or {} -- models/free-market.can:4539
	link_data() -- models/free-market.can:4541
	clear_invalid_data() -- models/free-market.can:4543
	for item_name, item in pairs(prototypes["item"]) do -- models/free-market.can:4545
		if item["stack_size"] <= 5 then -- models/free-market.can:4546
			for _, f_storage_limit in pairs(__storages_limit) do -- models/free-market.can:4547
				f_storage_limit[item_name] = f_storage_limit[item_name] or 1 -- models/free-market.can:4548
			end -- models/free-market.can:4548
		end -- models/free-market.can:4548
	end -- models/free-market.can:4548
	for _, force in pairs(game["forces"]) do -- models/free-market.can:4555
		if force["valid"] then -- models/free-market.can:4556
			init_force_data(force["index"]) -- models/free-market.can:4558
		end -- models/free-market.can:4558
	end -- models/free-market.can:4558
	for _, player in pairs(game["players"]) do -- models/free-market.can:4563
		if player["valid"] then -- models/free-market.can:4564
			local relative = player["gui"]["relative"] -- models/free-market.can:4565
			if relative["FM_buttons"] == nil then -- models/free-market.can:4566
				create_left_relative_gui(player) -- models/free-market.can:4567
			end -- models/free-market.can:4567
			if relative["FM_boxes_frame"] == nil then -- models/free-market.can:4569
				create_top_relative_gui(player) -- models/free-market.can:4570
			end -- models/free-market.can:4570
			local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:4572
			if frame == nil then -- models/free-market.can:4573
				create_item_price_HUD(player) -- models/free-market.can:4574
			end -- models/free-market.can:4574
		end -- models/free-market.can:4574
	end -- models/free-market.can:4574
	detect_desync(game) -- models/free-market.can:4579
end -- models/free-market.can:4579
local function on_configuration_changed(event) -- models/free-market.can:4582
	update_global_data() -- models/free-market.can:4583
	local mod_changes = event["mod_changes"]["iFreeMarket"] -- models/free-market.can:4585
	if not (mod_changes and mod_changes["old_version"]) then -- models/free-market.can:4586
		return  -- models/free-market.can:4586
	end -- models/free-market.can:4586
	local version = tonumber(string["gmatch"](mod_changes["old_version"], "%d+.%d+")()) -- models/free-market.can:4588
	if version < 0.34 then -- models/free-market.can:4590
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4591
			local index = force["index"] -- models/free-market.can:4592
			if __sell_prices[index] then -- models/free-market.can:4593
				init_force_data(index) -- models/free-market.can:4594
			end -- models/free-market.can:4594
		end -- models/free-market.can:4594
		for _, player in pairs(game["players"]) do -- models/free-market.can:4598
			if player["valid"] then -- models/free-market.can:4599
				create_top_relative_gui(player) -- models/free-market.can:4600
			end -- models/free-market.can:4600
		end -- models/free-market.can:4600
	end -- models/free-market.can:4600
	if version < 0.33 then -- models/free-market.can:4605
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4606
			local index = force["index"] -- models/free-market.can:4607
			if __sell_prices[index] and __mod_data["sell_boxes"] then -- models/free-market.can:4609
				__transfer_boxes[index] = __mod_data["sell_boxes"][index] -- models/free-market.can:4610
				__inactive_transfer_boxes[index] = __mod_data["inactive_sell_boxes"][index] -- models/free-market.can:4611
			end -- models/free-market.can:4611
			__mod_data["sell_boxes"] = nil -- models/free-market.can:4613
			__mod_data["inactive_sell_boxes"] = nil -- models/free-market.can:4614
		end -- models/free-market.can:4614
		local sprite_data = { -- models/free-market.can:4617
			["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:4618
			["only_in_alt_mode"] = true, -- models/free-market.can:4619
			["x_scale"] = 0.4, -- models/free-market.can:4620
			["y_scale"] = 0.4 -- models/free-market.can:4620
		} -- models/free-market.can:4620
		for _, box_data in pairs(__all_boxes) do -- models/free-market.can:4622
			local rendered = get_rendered_by_id(box_data[2]) -- models/free-market.can:4623
			rendered["destroy"]() -- models/free-market.can:4624
			local entity = box_data[1] -- models/free-market.can:4626
			sprite_data["target"] = entity -- models/free-market.can:4627
			sprite_data["surface"] = entity["surface"] -- models/free-market.can:4628
			if is_public_titles == false then -- models/free-market.can:4629
				sprite_data["forces"] = { entity["force"] } -- models/free-market.can:4630
			end -- models/free-market.can:4630
			local box_type = box_data[3] -- models/free-market.can:4633
			if box_type == 2 then -- models/free-market.can:1
				box_data[3] = 4 -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transparent-transfer" -- models/free-market.can:4636
			elseif box_type == 3 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transparent-pull-out" -- models/free-market.can:4638
			elseif box_type == 1 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transparent-buy" -- models/free-market.can:4640
			end -- models/free-market.can:4640
			box_data[2] = draw_sprite(sprite_data)["id"] -- models/free-market.can:4643
		end -- models/free-market.can:4643
		for _, player in pairs(game["players"]) do -- models/free-market.can:4646
			if player["valid"] then -- models/free-market.can:4647
				create_top_relative_gui(player) -- models/free-market.can:4648
			end -- models/free-market.can:4648
		end -- models/free-market.can:4648
	end -- models/free-market.can:4648
	if version < 0.32 then -- models/free-market.can:4653
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4654
			local index = force["index"] -- models/free-market.can:4655
			if __transfer_boxes[index] then -- models/free-market.can:4656
				init_force_data(index) -- models/free-market.can:4657
				__default_storage_limit[index] = max_storage_threshold -- models/free-market.can:4658
			end -- models/free-market.can:4658
		end -- models/free-market.can:4658
	end -- models/free-market.can:4658
	if version < 0.31 then -- models/free-market.can:4663
		for _, player in pairs(game["players"]) do -- models/free-market.can:4664
			if player["valid"] then -- models/free-market.can:4665
				delete_item_price_HUD(player) -- models/free-market.can:4666
				if player["connected"] then -- models/free-market.can:4667
					create_item_price_HUD(player) -- models/free-market.can:4668
				end -- models/free-market.can:4668
			end -- models/free-market.can:4668
		end -- models/free-market.can:4668
	end -- models/free-market.can:4668
	if version < 0.30 then -- models/free-market.can:4674
		for _, player in pairs(game["players"]) do -- models/free-market.can:4675
			if player["valid"] then -- models/free-market.can:4676
				local screen = player["gui"]["screen"] -- models/free-market.can:4677
				local frame = screen["FM_prices_frame"] -- models/free-market.can:4678
				if frame then -- models/free-market.can:4679
					frame["destroy"]() -- models/free-market.can:4680
				end -- models/free-market.can:4680
			end -- models/free-market.can:4680
		end -- models/free-market.can:4680
	end -- models/free-market.can:4680
	if version < 0.29 then -- models/free-market.can:4686
		for _, player in pairs(game["players"]) do -- models/free-market.can:4687
			if player["valid"] then -- models/free-market.can:4688
				local screen = player["gui"]["screen"] -- models/free-market.can:4689
				if screen["FM_sell_prices_frame"] then -- models/free-market.can:4690
					screen["FM_sell_prices_frame"]["destroy"]() -- models/free-market.can:4691
				end -- models/free-market.can:4691
				if screen["FM_buy_prices_frame"] then -- models/free-market.can:4693
					screen["FM_buy_prices_frame"]["destroy"]() -- models/free-market.can:4694
				end -- models/free-market.can:4694
				switch_buy_prices_gui(player) -- models/free-market.can:4696
				switch_sell_prices_gui(player) -- models/free-market.can:4697
			end -- models/free-market.can:4697
		end -- models/free-market.can:4697
	end -- models/free-market.can:4697
	if version < 0.28 then -- models/free-market.can:4702
		for _, player in pairs(game["players"]) do -- models/free-market.can:4703
			if player["valid"] and player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4704
				create_item_price_HUD(player) -- models/free-market.can:4705
			end -- models/free-market.can:4705
		end -- models/free-market.can:4705
	end -- models/free-market.can:4705
	if version < 0.21 then -- models/free-market.can:4710
		for _, player in pairs(game["players"]) do -- models/free-market.can:4711
			if player["valid"] then -- models/free-market.can:4712
				create_top_relative_gui(player) -- models/free-market.can:4713
			end -- models/free-market.can:4713
		end -- models/free-market.can:4713
	end -- models/free-market.can:4713
	if version < 0.22 then -- models/free-market.can:4718
		for _, player in pairs(game["players"]) do -- models/free-market.can:4719
			if player["valid"] then -- models/free-market.can:4720
				create_left_relative_gui(player) -- models/free-market.can:4721
			end -- models/free-market.can:4721
		end -- models/free-market.can:4721
	end -- models/free-market.can:4721
	if version < 0.26 then -- models/free-market.can:4726
		for _, player in pairs(game["players"]) do -- models/free-market.can:4727
			if player["valid"] then -- models/free-market.can:4728
				switch_sell_prices_gui(player) -- models/free-market.can:4729
				switch_buy_prices_gui(player) -- models/free-market.can:4730
			end -- models/free-market.can:4730
		end -- models/free-market.can:4730
		game["print"]({ -- models/free-market.can:4733
			"", -- models/free-market.can:4733
			{ "mod-name.free-market" }, -- models/free-market.can:4733
			COLON, -- models/free-market.can:4733
			" added price notification with settings" -- models/free-market.can:4733
		}) -- models/free-market.can:4733
	end -- models/free-market.can:4733
end -- models/free-market.can:4733
do -- models/free-market.can:4738
	local function set_filters() -- models/free-market.can:4738
		local filters = { -- models/free-market.can:4739
			{ -- models/free-market.can:4740
				["filter"] = "type", -- models/free-market.can:4740
				["mode"] = "or", -- models/free-market.can:4740
				["type"] = "container" -- models/free-market.can:4740
			}, -- models/free-market.can:4740
			{ -- models/free-market.can:4741
				["filter"] = "type", -- models/free-market.can:4741
				["mode"] = "or", -- models/free-market.can:4741
				["type"] = "logistic-container" -- models/free-market.can:4741
			} -- models/free-market.can:4741
		} -- models/free-market.can:4741
		script["set_event_filter"](defines["events"]["on_entity_died"], filters) -- models/free-market.can:4743
		script["set_event_filter"](defines["events"]["on_robot_mined_entity"], filters) -- models/free-market.can:4744
		script["set_event_filter"](defines["events"]["script_raised_destroy"], filters) -- models/free-market.can:4745
		script["set_event_filter"](defines["events"]["on_player_mined_entity"], filters) -- models/free-market.can:4746
		script["set_event_filter"](defines["events"]["on_entity_cloned"], filters) -- models/free-market.can:4747
		local EasyAPI_events = call("EasyAPI", "get_events") -- models/free-market.can:4749
		if EasyAPI_events["on_fix_bugs"] then -- models/free-market.can:4750
			script["on_event"](EasyAPI_events["on_fix_bugs"], function() -- models/free-market.can:4751
				clear_invalid_player_data() -- models/free-market.can:4752
				clear_invalid_entities() -- models/free-market.can:4753
				detect_desync(game) -- models/free-market.can:4755
			end) -- models/free-market.can:4755
		end -- models/free-market.can:4755
		if EasyAPI_events["on_sync"] then -- models/free-market.can:4758
			script["on_event"](EasyAPI_events["on_sync"], function() -- models/free-market.can:4759
				link_data() -- models/free-market.can:4760
			end) -- models/free-market.can:4760
		end -- models/free-market.can:4760
	end -- models/free-market.can:4760
	M["on_load"] = function() -- models/free-market.can:4765
		link_data() -- models/free-market.can:4766
		set_filters() -- models/free-market.can:4767
	end -- models/free-market.can:4767
	M["on_init"] = function() -- models/free-market.can:4769
		update_global_data() -- models/free-market.can:4770
		set_filters() -- models/free-market.can:4771
	end -- models/free-market.can:4771
end -- models/free-market.can:4771
M["on_configuration_changed"] = on_configuration_changed -- models/free-market.can:4774
M["add_remote_interface"] = add_remote_interface -- models/free-market.can:4775
M["events"] = { -- models/free-market.can:4780
	[defines["events"]["on_surface_deleted"]] = clear_invalid_entities, -- models/free-market.can:4781
	[defines["events"]["on_surface_cleared"]] = clear_invalid_entities, -- models/free-market.can:4782
	[defines["events"]["on_chunk_deleted"]] = clear_invalid_entities, -- models/free-market.can:4783
	[defines["events"]["on_player_created"]] = on_player_created, -- models/free-market.can:4784
	[defines["events"]["on_player_joined_game"]] = on_player_joined_game, -- models/free-market.can:4785
	[defines["events"]["on_player_left_game"]] = on_player_left_game, -- models/free-market.can:4786
	[defines["events"]["on_player_cursor_stack_changed"]] = function(event) -- models/free-market.can:4787
		pcall(on_player_cursor_stack_changed, event) -- models/free-market.can:4788
	end, -- models/free-market.can:4788
	[defines["events"]["on_player_removed"]] = delete_player_data, -- models/free-market.can:4790
	[defines["events"]["on_player_changed_force"]] = on_player_changed_force, -- models/free-market.can:4791
	[defines["events"]["on_player_changed_surface"]] = on_player_changed_surface, -- models/free-market.can:4792
	[defines["events"]["on_player_selected_area"]] = on_player_selected_area, -- models/free-market.can:4793
	[defines["events"]["on_player_alt_selected_area"]] = on_player_alt_selected_area, -- models/free-market.can:4794
	[defines["events"]["on_player_mined_entity"]] = clear_box_data, -- models/free-market.can:4795
	[defines["events"]["on_gui_selection_state_changed"]] = on_gui_selection_state_changed, -- models/free-market.can:4796
	[defines["events"]["on_gui_elem_changed"]] = on_gui_elem_changed, -- models/free-market.can:4797
	[defines["events"]["on_gui_click"]] = on_gui_click, -- models/free-market.can:4798
	[defines["events"]["on_gui_opened"]] = on_gui_opened, -- models/free-market.can:4799
	[defines["events"]["on_gui_closed"]] = on_gui_closed, -- models/free-market.can:4800
	[defines["events"]["on_selected_entity_changed"]] = on_selected_entity_changed, -- models/free-market.can:4801
	[defines["events"]["on_force_created"]] = on_force_created, -- models/free-market.can:4802
	[defines["events"]["on_forces_merging"]] = on_forces_merging, -- models/free-market.can:4803
	[defines["events"]["on_entity_cloned"]] = on_entity_cloned, -- models/free-market.can:4804
	[defines["events"]["on_runtime_mod_setting_changed"]] = on_runtime_mod_setting_changed, -- models/free-market.can:4805
	[defines["events"]["on_force_cease_fire_changed"]] = function(event) -- models/free-market.can:4806
		if is_auto_embargo then -- models/free-market.can:4808
			pcall(on_force_cease_fire_changed, event) -- models/free-market.can:4809
		end -- models/free-market.can:4809
	end, -- models/free-market.can:4809
	[defines["events"]["on_entity_settings_pasted"]] = function(event) -- models/free-market.can:4812
		local source = event["source"] -- models/free-market.can:4813
		if not (source and source["valid"]) then -- models/free-market.can:4814
			return  -- models/free-market.can:4814
		end -- models/free-market.can:4814
		local box_data = __all_boxes[source["unit_number"]] -- models/free-market.can:4815
		if box_data == nil then -- models/free-market.can:4816
			return  -- models/free-market.can:4816
		end -- models/free-market.can:4816
		local destination = event["destination"] -- models/free-market.can:4818
		if not (destination and destination["valid"]) then -- models/free-market.can:4819
			return  -- models/free-market.can:4819
		end -- models/free-market.can:4819
		if destination["force"] ~= source["force"] then -- models/free-market.can:4820
			return  -- models/free-market.can:4820
		end -- models/free-market.can:4820
		if not ALLOWED_CHEST_TYPES[destination["type"]] then -- models/free-market.can:4821
			return  -- models/free-market.can:4821
		end -- models/free-market.can:4821
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4823
		if not (player and player["valid"]) then -- models/free-market.can:4824
			return  -- models/free-market.can:4824
		end -- models/free-market.can:4824
		local destination_box_data = __all_boxes[destination["unit_number"]] -- models/free-market.can:4826
		if destination_box_data then -- models/free-market.can:4827
			local rendered = get_rendered_by_id(destination_box_data[2]) -- models/free-market.can:4828
			rendered["destroy"]() -- models/free-market.can:4829
			REMOVE_BOX_FUNCS[destination_box_data[3]](destination, destination_box_data) -- models/free-market.can:4830
		end -- models/free-market.can:4830
		local box_type = box_data[3] -- models/free-market.can:4833
		if box_type == 3 then -- models/free-market.can:1
			set_pull_box_data(box_data[5], destination) -- models/free-market.can:4835
		elseif box_type == 1 then -- models/free-market.can:1
			local count -- models/free-market.can:4837
			local items = box_data[4] -- models/free-market.can:4838
			for i = 1, # items do -- models/free-market.can:4839
				local buy_data = items[i] -- models/free-market.can:4840
				if buy_data[1] == source then -- models/free-market.can:4841
					count = buy_data[2] -- models/free-market.can:4842
					break -- models/free-market.can:4843
				end -- models/free-market.can:4843
			end -- models/free-market.can:4843
			set_buy_box_data(box_data[5], destination, count) -- models/free-market.can:4846
		elseif box_type == 4 then -- models/free-market.can:1
			set_transfer_box_data(box_data[5], destination) -- models/free-market.can:4848
		elseif box_type == 5 then -- models/free-market.can:1
			set_universal_transfer_box_data(destination) -- models/free-market.can:4850
		elseif box_type == 6 then -- models/free-market.can:1
			set_bin_box_data(box_data[5], destination) -- models/free-market.can:4852
		elseif box_type == 7 then -- models/free-market.can:1
			set_universal_bin_box_data(destination) -- models/free-market.can:4854
		end -- models/free-market.can:4854
	end, -- models/free-market.can:4854
	[defines["events"]["on_robot_mined_entity"]] = clear_box_data, -- models/free-market.can:4857
	[defines["events"]["script_raised_destroy"]] = clear_box_data, -- models/free-market.can:4858
	[defines["events"]["on_entity_died"]] = clear_box_data, -- models/free-market.can:4859
	["FM_set-pull-box"] = function(event) -- models/free-market.can:4860
		pcall(set_pull_box_key_pressed, event) -- models/free-market.can:4861
	end, -- models/free-market.can:4861
	["FM_set-transfer-box"] = function(event) -- models/free-market.can:4863
		pcall(set_transfer_box_key_pressed, event) -- models/free-market.can:4864
	end, -- models/free-market.can:4864
	["FM_set-universal-transfer-box"] = function(event) -- models/free-market.can:4866
		pcall(set_universal_transfer_box_key_pressed, event) -- models/free-market.can:4867
	end, -- models/free-market.can:4867
	["FM_set-bin-box"] = function(event) -- models/free-market.can:4869
		pcall(set_bin_box_key_pressed, event) -- models/free-market.can:4870
	end, -- models/free-market.can:4870
	["FM_set-universal-bin-box"] = function(event) -- models/free-market.can:4872
		pcall(set_universal_bin_box_key_pressed, event) -- models/free-market.can:4873
	end, -- models/free-market.can:4873
	["FM_set-buy-box"] = function(event) -- models/free-market.can:4875
		pcall(set_buy_box_key_pressed, event) -- models/free-market.can:4876
	end -- models/free-market.can:4876
} -- models/free-market.can:4876
M["on_nth_tick"] = { -- models/free-market.can:4880
	[update_buy_tick] = check_buy_boxes, -- models/free-market.can:4881
	[update_transfer_tick] = check_transfer_boxes, -- models/free-market.can:4882
	[update_pull_tick] = check_pull_boxes, -- models/free-market.can:4883
	[CHECK_FORCES_TICK] = check_forces, -- models/free-market.can:4884
	[CHECK_TEAMS_DATA_TICK] = check_teams_data -- models/free-market.can:4885
} -- models/free-market.can:4885
M["commands"] = { -- models/free-market.can:4888
	["embargo"] = function(cmd) -- models/free-market.can:4889
		open_embargo_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4890
	end, -- models/free-market.can:4890
	["prices"] = function(cmd) -- models/free-market.can:4892
		switch_prices_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4893
	end, -- models/free-market.can:4893
	["price_list"] = function(cmd) -- models/free-market.can:4895
		open_price_list_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4896
	end, -- models/free-market.can:4896
	["storage"] = function(cmd) -- models/free-market.can:4898
		open_storage_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4899
	end -- models/free-market.can:4899
} -- models/free-market.can:4899
return M -- models/free-market.can:4904
