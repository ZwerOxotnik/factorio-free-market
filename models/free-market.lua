local M = {} -- models/free-market.can:2
local mod_data -- models/free-market.can:8
local embargoes -- models/free-market.can:13
local sell_prices -- models/free-market.can:18
local inactive_sell_prices -- models/free-market.can:23
local buy_prices -- models/free-market.can:28
local inactive_buy_prices -- models/free-market.can:33
local transfer_boxes -- models/free-market.can:38
local inactive_transfer_boxes -- models/free-market.can:43
local bin_boxes -- models/free-market.can:48
local inactive_bin_boxes -- models/free-market.can:53
local universal_transfer_boxes -- models/free-market.can:58
local inactive_universal_transfer_boxes -- models/free-market.can:63
local universal_bin_boxes -- models/free-market.can:68
local inactive_universal_bin_boxes -- models/free-market.can:73
local buy_boxes -- models/free-market.can:78
local inactive_buy_boxes -- models/free-market.can:83
local pull_boxes -- models/free-market.can:88
local open_box -- models/free-market.can:92
local all_boxes -- models/free-market.can:101
local active_forces -- models/free-market.can:107
local storages -- models/free-market.can:112
local storages_limit -- models/free-market.can:117
local default_storage_limit -- models/free-market.can:122
local item_HUD -- models/free-market.can:133
local tremove = table["remove"] -- models/free-market.can:139
local find = string["find"] -- models/free-market.can:140
local sub = string["sub"] -- models/free-market.can:141
local call = remote["call"] -- models/free-market.can:142
local floor = math["floor"] -- models/free-market.can:143
local ceil = math["ceil"] -- models/free-market.can:144
local draw_sprite = rendering["draw_sprite"] -- models/free-market.can:145
local Rget_type = rendering["get_type"] -- models/free-market.can:146
local get_render_target = rendering["get_target"] -- models/free-market.can:147
local is_render_valid = rendering["is_valid"] -- models/free-market.can:148
local rendering_destroy = rendering["destroy"] -- models/free-market.can:149
local print_to_rcon = rcon["print"] -- models/free-market.can:150
local CHECK_FORCES_TICK = 60 * 60 * 1.5 -- models/free-market.can:170
local CHECK_TEAMS_DATA_TICK = 60 * 60 * 25 -- models/free-market.can:171
local EMPTY_TABLE = {} -- models/free-market.can:172
local WHITE_COLOR = { -- models/free-market.can:173
	1, -- models/free-market.can:173
	1, -- models/free-market.can:173
	1 -- models/free-market.can:173
} -- models/free-market.can:173
local BOX_TYPE_SPRITE_OFFSET = { -- models/free-market.can:174
	0, -- models/free-market.can:174
	0.2 -- models/free-market.can:174
} -- models/free-market.can:174
local HINT_SPRITE_OFFSET = { -- models/free-market.can:175
	0, -- models/free-market.can:175
	- 0.25 -- models/free-market.can:175
} -- models/free-market.can:175
local COLON = { "colon" } -- models/free-market.can:176
local LABEL = { ["type"] = "label" } -- models/free-market.can:177
local FLOW = { ["type"] = "flow" } -- models/free-market.can:178
local VERTICAL_FLOW = { -- models/free-market.can:179
	["type"] = "flow", -- models/free-market.can:179
	["direction"] = "vertical" -- models/free-market.can:179
} -- models/free-market.can:179
local SPRITE_BUTTON = { ["type"] = "sprite-button" } -- models/free-market.can:180
local SLOT_BUTTON = { -- models/free-market.can:181
	["type"] = "sprite-button", -- models/free-market.can:181
	["style"] = "slot_button" -- models/free-market.can:181
} -- models/free-market.can:181
local EMPTY_WIDGET = { ["type"] = "empty-widget" } -- models/free-market.can:182
local PRICE_LABEL = { -- models/free-market.can:183
	["type"] = "label", -- models/free-market.can:183
	["style"] = "FM_price_label" -- models/free-market.can:183
} -- models/free-market.can:183
local POST_PRICE_LABEL = { -- models/free-market.can:184
	["type"] = "label", -- models/free-market.can:184
	["style"] = "FM_price_label", -- models/free-market.can:184
	["caption"] = "$" -- models/free-market.can:184
} -- models/free-market.can:184
local PRICE_FRAME = { -- models/free-market.can:185
	["type"] = "frame", -- models/free-market.can:185
	["style"] = "FM_price_frame" -- models/free-market.can:185
} -- models/free-market.can:185
local SELL_PRICE_BUTTON = { -- models/free-market.can:186
	["type"] = "sprite-button", -- models/free-market.can:186
	["style"] = "slot_button", -- models/free-market.can:186
	["name"] = "FM_open_sell_price" -- models/free-market.can:186
} -- models/free-market.can:186
local BUY_PRICE_BUTTON = { -- models/free-market.can:187
	["type"] = "sprite-button", -- models/free-market.can:187
	["style"] = "slot_button", -- models/free-market.can:187
	["name"] = "FM_open_buy_price" -- models/free-market.can:187
} -- models/free-market.can:187
local ALLOWED_TYPES = { -- models/free-market.can:188
	["container"] = true, -- models/free-market.can:188
	["logistic-container"] = true -- models/free-market.can:188
} -- models/free-market.can:188
local TITLEBAR_FLOW = { -- models/free-market.can:189
	["type"] = "flow", -- models/free-market.can:189
	["style"] = "flib_titlebar_flow", -- models/free-market.can:189
	["name"] = "titlebar" -- models/free-market.can:189
} -- models/free-market.can:189
local DRAG_HANDLER = { -- models/free-market.can:190
	["type"] = "empty-widget", -- models/free-market.can:190
	["style"] = "flib_dialog_footer_drag_handle", -- models/free-market.can:190
	["name"] = "drag_handler" -- models/free-market.can:190
} -- models/free-market.can:190
local STORAGE_LIMIT_TEXTFIELD = { -- models/free-market.can:191
	["type"] = "textfield", -- models/free-market.can:191
	["name"] = "storage_limit", -- models/free-market.can:191
	["style"] = "FM_price_textfield", -- models/free-market.can:191
	["numeric"] = true, -- models/free-market.can:191
	["allow_decimal"] = false, -- models/free-market.can:191
	["allow_negative"] = false -- models/free-market.can:191
} -- models/free-market.can:191
local DEFAULT_LIMIT_TEXTFIELD = { -- models/free-market.can:192
	["type"] = "textfield", -- models/free-market.can:192
	["name"] = "FM_default_limit", -- models/free-market.can:192
	["style"] = "FM_price_textfield", -- models/free-market.can:192
	["numeric"] = true, -- models/free-market.can:192
	["allow_decimal"] = false, -- models/free-market.can:192
	["allow_negative"] = false -- models/free-market.can:192
} -- models/free-market.can:192
local SELL_PRICE_TEXTFIELD = { -- models/free-market.can:193
	["type"] = "textfield", -- models/free-market.can:193
	["name"] = "sell_price", -- models/free-market.can:193
	["style"] = "FM_price_textfield", -- models/free-market.can:193
	["numeric"] = true, -- models/free-market.can:193
	["allow_decimal"] = false, -- models/free-market.can:193
	["allow_negative"] = false -- models/free-market.can:193
} -- models/free-market.can:193
local BUY_PRICE_TEXTFIELD = { -- models/free-market.can:194
	["type"] = "textfield", -- models/free-market.can:194
	["name"] = "buy_price", -- models/free-market.can:194
	["style"] = "FM_price_textfield", -- models/free-market.can:194
	["numeric"] = true, -- models/free-market.can:194
	["allow_decimal"] = false, -- models/free-market.can:194
	["allow_negative"] = false -- models/free-market.can:194
} -- models/free-market.can:194
local SCROLL_PANE = { -- models/free-market.can:195
	["type"] = "scroll-pane", -- models/free-market.can:196
	["name"] = "scroll-pane", -- models/free-market.can:197
	["horizontal_scroll_policy"] = "never" -- models/free-market.can:198
} -- models/free-market.can:198
local CLOSE_BUTTON = { -- models/free-market.can:200
	["hovered_sprite"] = "utility/close_black", -- models/free-market.can:201
	["clicked_sprite"] = "utility/close_black", -- models/free-market.can:202
	["sprite"] = "utility/close_white", -- models/free-market.can:203
	["style"] = "frame_action_button", -- models/free-market.can:204
	["type"] = "sprite-button", -- models/free-market.can:205
	["name"] = "FM_close" -- models/free-market.can:206
} -- models/free-market.can:206
local ITEM_FILTERS = { -- models/free-market.can:208
	{ -- models/free-market.can:209
		["filter"] = "type", -- models/free-market.can:209
		["type"] = "blueprint-book", -- models/free-market.can:209
		["invert"] = true, -- models/free-market.can:209
		["mode"] = "and" -- models/free-market.can:209
	}, -- models/free-market.can:209
	{ -- models/free-market.can:210
		["filter"] = "selection-tool", -- models/free-market.can:210
		["invert"] = true, -- models/free-market.can:210
		["mode"] = "and" -- models/free-market.can:210
	} -- models/free-market.can:210
} -- models/free-market.can:210
local FM_ITEM_ELEMENT = { -- models/free-market.can:212
	["type"] = "choose-elem-button", -- models/free-market.can:212
	["name"] = "FM_item", -- models/free-market.can:212
	["elem_type"] = "item", -- models/free-market.can:212
	["elem_filters"] = ITEM_FILTERS -- models/free-market.can:212
} -- models/free-market.can:212
local CHECK_BUTTON = { -- models/free-market.can:213
	["type"] = "sprite-button", -- models/free-market.can:214
	["style"] = "item_and_count_select_confirm", -- models/free-market.can:215
	["sprite"] = "utility/check_mark" -- models/free-market.can:216
} -- models/free-market.can:216
local update_buy_tick = settings["global"]["FM_update-tick"]["value"] -- models/free-market.can:223
local update_transfer_tick = settings["global"]["FM_update-transfer-tick"]["value"] -- models/free-market.can:226
local update_pull_tick = settings["global"]["FM_update-pull-tick"]["value"] -- models/free-market.can:229
local is_auto_embargo = settings["global"]["FM_enable-auto-embargo"]["value"] -- models/free-market.can:232
local money_treshold = settings["global"]["FM_money-treshold"]["value"] -- models/free-market.can:235
local minimal_price = settings["global"]["FM_minimal-price"]["value"] -- models/free-market.can:238
local maximal_price = settings["global"]["FM_maximal-price"]["value"] -- models/free-market.can:241
local skip_offline_team_chance = settings["global"]["FM_skip_offline_team_chance"]["value"] -- models/free-market.can:244
local max_storage_threshold = settings["global"]["FM_max_storage_threshold"]["value"] -- models/free-market.can:247
local pull_cost_per_item = settings["global"]["FM_pull_cost_per_item"]["value"] -- models/free-market.can:250
local is_public_titles = settings["global"]["FM_is-public-titles"]["value"] -- models/free-market.can:253
local is_reset_public = settings["global"]["FM_is_reset_public"]["value"] -- models/free-market.can:256
local stack = { -- models/free-market.can:261
	["name"] = "", -- models/free-market.can:261
	["count"] = 0 -- models/free-market.can:261
} -- models/free-market.can:261
clear_invalid_data = nil -- models/free-market.can:266
print_force_data = function(target, getter) -- models/free-market.can:270
	if getter then -- models/free-market.can:271
		if not getter["valid"] then -- models/free-market.can:272
			log("Invalid object") -- models/free-market.can:273
			return  -- models/free-market.can:274
		end -- models/free-market.can:274
	else -- models/free-market.can:274
		getter = game -- models/free-market.can:277
	end -- models/free-market.can:277
	local index -- models/free-market.can:280
	local object_name = target["object_name"] -- models/free-market.can:281
	if object_name == "LuaPlayer" then -- models/free-market.can:282
		index = target["force"]["index"] -- models/free-market.can:283
	elseif object_name == "LuaForce" then -- models/free-market.can:284
		index = target["index"] -- models/free-market.can:285
	else -- models/free-market.can:285
		log("Invalid type") -- models/free-market.can:287
		return  -- models/free-market.can:288
	end -- models/free-market.can:288
	local print_to_target = getter["print"] -- models/free-market.can:291
	print_to_target("") -- models/free-market.can:292
	print_to_target("Inactive sell prices:" .. serpent["line"](inactive_sell_prices[index])) -- models/free-market.can:293
	print_to_target("Inactive buy prices:" .. serpent["line"](inactive_buy_prices[index])) -- models/free-market.can:294
	print_to_target("Sell prices:" .. serpent["line"](sell_prices[index])) -- models/free-market.can:295
	print_to_target("Buy prices:" .. serpent["line"](buy_prices[index])) -- models/free-market.can:296
	print_to_target("Universal transferers:" .. serpent["line"](universal_transfer_boxes[index])) -- models/free-market.can:297
	print_to_target("Transferers:" .. serpent["line"](transfer_boxes[index])) -- models/free-market.can:298
	print_to_target("Bin boxes:" .. serpent["line"](bin_boxes[index])) -- models/free-market.can:299
	print_to_target("Universal bin boxes:" .. serpent["line"](universal_bin_boxes[index])) -- models/free-market.can:300
	print_to_target("Pull boxes:" .. serpent["line"](pull_boxes[index])) -- models/free-market.can:301
	print_to_target("Buy boxes:" .. serpent["line"](buy_boxes[index])) -- models/free-market.can:302
	print_to_target("Embargoes:" .. serpent["line"](embargoes[index])) -- models/free-market.can:303
	print_to_target("Storage:" .. serpent["line"](storages[index])) -- models/free-market.can:304
end -- models/free-market.can:304
resetBuyBoxes = function(force_index) -- models/free-market.can:309
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:310
	if f_buy_boxes == nil then -- models/free-market.can:311
		return  -- models/free-market.can:311
	end -- models/free-market.can:311
	for _, forces_data in pairs(f_buy_boxes) do -- models/free-market.can:313
		for _, entities_data in pairs(forces_data) do -- models/free-market.can:314
			local unit_number = entities_data[1]["unit_number"] -- models/free-market.can:315
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:316
			all_boxes[unit_number] = nil -- models/free-market.can:317
		end -- models/free-market.can:317
	end -- models/free-market.can:317
	buy_boxes[force_index] = {} -- models/free-market.can:320
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:322
	if f_buy_prices == nil then -- models/free-market.can:323
		return  -- models/free-market.can:323
	end -- models/free-market.can:323
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:324
	if f_inactive_buy_prices == nil then -- models/free-market.can:325
		return  -- models/free-market.can:325
	end -- models/free-market.can:325
	for item_name, price in pairs(f_buy_prices) do -- models/free-market.can:326
		f_inactive_buy_prices[item_name] = price -- models/free-market.can:327
	end -- models/free-market.can:327
	buy_prices[force_index] = {} -- models/free-market.can:329
end -- models/free-market.can:329
resetTransferBoxes = function(force_index) -- models/free-market.can:334
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:335
	if f_transfer_boxes == nil then -- models/free-market.can:336
		return  -- models/free-market.can:336
	end -- models/free-market.can:336
	for _, entities_data in pairs(f_transfer_boxes) do -- models/free-market.can:338
		for i = 1, # entities_data do -- models/free-market.can:339
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:340
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:341
			all_boxes[unit_number] = nil -- models/free-market.can:342
		end -- models/free-market.can:342
	end -- models/free-market.can:342
	transfer_boxes[force_index] = {} -- models/free-market.can:345
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:347
	if f_inactive_sell_prices == nil then -- models/free-market.can:348
		return  -- models/free-market.can:348
	end -- models/free-market.can:348
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:349
	if f_sell_prices == nil then -- models/free-market.can:350
		return  -- models/free-market.can:350
	end -- models/free-market.can:350
	local storage = storages[force_index] -- models/free-market.can:351
	if storage == nil then -- models/free-market.can:352
		return  -- models/free-market.can:352
	end -- models/free-market.can:352
	for item_name, price in pairs(f_sell_prices) do -- models/free-market.can:354
		local count = storage[item_name] -- models/free-market.can:355
		if count == nil or count <= 0 then -- models/free-market.can:356
			f_inactive_sell_prices[item_name] = price -- models/free-market.can:357
			f_sell_prices[item_name] = nil -- models/free-market.can:358
		end -- models/free-market.can:358
	end -- models/free-market.can:358
end -- models/free-market.can:358
resetUniversalTransferBoxes = function(force_index) -- models/free-market.can:365
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:366
	if entities == nil then -- models/free-market.can:367
		return  -- models/free-market.can:367
	end -- models/free-market.can:367
	for i = 1, # entities do -- models/free-market.can:369
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:370
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:371
		all_boxes[unit_number] = nil -- models/free-market.can:372
	end -- models/free-market.can:372
	universal_transfer_boxes[force_index] = {} -- models/free-market.can:374
end -- models/free-market.can:374
resetBinBoxes = function(force_index) -- models/free-market.can:379
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:380
	if f_bin_boxes == nil then -- models/free-market.can:381
		return  -- models/free-market.can:381
	end -- models/free-market.can:381
	for _, entities_data in pairs(f_bin_boxes) do -- models/free-market.can:383
		for i = 1, # entities_data do -- models/free-market.can:384
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:385
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:386
			all_boxes[unit_number] = nil -- models/free-market.can:387
		end -- models/free-market.can:387
	end -- models/free-market.can:387
	bin_boxes[force_index] = {} -- models/free-market.can:390
end -- models/free-market.can:390
resetUniversalBinBoxes = function(force_index) -- models/free-market.can:395
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:396
	if entities == nil then -- models/free-market.can:397
		return  -- models/free-market.can:397
	end -- models/free-market.can:397
	for i = 1, # entities do -- models/free-market.can:399
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:400
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:401
		all_boxes[unit_number] = nil -- models/free-market.can:402
	end -- models/free-market.can:402
	universal_bin_boxes[force_index] = {} -- models/free-market.can:404
end -- models/free-market.can:404
resetPullBoxes = function(force_index) -- models/free-market.can:409
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:410
	if f_pull_boxes == nil then -- models/free-market.can:411
		return  -- models/free-market.can:411
	end -- models/free-market.can:411
	for _, entities_data in pairs(f_pull_boxes) do -- models/free-market.can:413
		for i = 1, # entities_data do -- models/free-market.can:414
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:415
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:416
			all_boxes[unit_number] = nil -- models/free-market.can:417
		end -- models/free-market.can:417
	end -- models/free-market.can:417
	pull_boxes[force_index] = {} -- models/free-market.can:420
end -- models/free-market.can:420
resetAllBoxes = function(force_index) -- models/free-market.can:425
	resetTransferBoxes(force_index) -- models/free-market.can:426
	resetUniversalTransferBoxes(force_index) -- models/free-market.can:427
	resetBinBoxes(force_index) -- models/free-market.can:428
	resetUniversalBinBoxes(force_index) -- models/free-market.can:429
	resetPullBoxes(force_index) -- models/free-market.can:430
	resetBuyBoxes(force_index) -- models/free-market.can:431
end -- models/free-market.can:431
getRconData = function(name) -- models/free-market.can:440
	print_to_rcon(game["table_to_json"](mod_data[name])) -- models/free-market.can:441
end -- models/free-market.can:441
getRconForceData = function(name, force) -- models/free-market.can:446
	if not force["valid"] then -- models/free-market.can:447
		return  -- models/free-market.can:447
	end -- models/free-market.can:447
	print_to_rcon(game["table_to_json"](mod_data[name][force["index"]])) -- models/free-market.can:448
end -- models/free-market.can:448
getRconForceDataByIndex = function(name, force_index) -- models/free-market.can:453
	print_to_rcon(game["table_to_json"](mod_data[name][force_index])) -- models/free-market.can:454
end -- models/free-market.can:454
local function clear_force_data(index) -- models/free-market.can:463
	default_storage_limit[index] = nil -- models/free-market.can:464
	inactive_sell_prices[index] = nil -- models/free-market.can:465
	inactive_buy_prices[index] = nil -- models/free-market.can:466
	bin_boxes[index] = nil -- models/free-market.can:467
	inactive_bin_boxes[index] = nil -- models/free-market.can:468
	universal_bin_boxes[index] = nil -- models/free-market.can:469
	inactive_universal_bin_boxes[index] = nil -- models/free-market.can:470
	inactive_universal_transfer_boxes[index] = nil -- models/free-market.can:471
	inactive_transfer_boxes[index] = nil -- models/free-market.can:472
	inactive_buy_boxes[index] = nil -- models/free-market.can:473
	storages_limit[index] = nil -- models/free-market.can:474
	sell_prices[index] = nil -- models/free-market.can:475
	buy_prices[index] = nil -- models/free-market.can:476
	pull_boxes[index] = nil -- models/free-market.can:477
	universal_transfer_boxes[index] = nil -- models/free-market.can:478
	transfer_boxes[index] = nil -- models/free-market.can:479
	buy_boxes[index] = nil -- models/free-market.can:480
	embargoes[index] = nil -- models/free-market.can:481
	storages[index] = nil -- models/free-market.can:482
	for _, force_data in pairs(embargoes) do -- models/free-market.can:484
		force_data[index] = nil -- models/free-market.can:485
	end -- models/free-market.can:485
	for i, force_index in pairs(active_forces) do -- models/free-market.can:488
		if force_index == index then -- models/free-market.can:489
			tremove(active_forces, i) -- models/free-market.can:490
			break -- models/free-market.can:491
		end -- models/free-market.can:491
	end -- models/free-market.can:491
end -- models/free-market.can:491
local function init_force_data(index) -- models/free-market.can:497
	inactive_sell_prices[index] = inactive_sell_prices[index] or {} -- models/free-market.can:498
	inactive_buy_prices[index] = inactive_buy_prices[index] or {} -- models/free-market.can:499
	bin_boxes[index] = bin_boxes[index] or {} -- models/free-market.can:500
	inactive_bin_boxes[index] = inactive_bin_boxes[index] or {} -- models/free-market.can:501
	universal_bin_boxes[index] = universal_bin_boxes[index] or {} -- models/free-market.can:502
	inactive_universal_bin_boxes[index] = inactive_universal_bin_boxes[index] or {} -- models/free-market.can:503
	inactive_universal_transfer_boxes[index] = inactive_universal_transfer_boxes[index] or {} -- models/free-market.can:504
	inactive_transfer_boxes[index] = inactive_transfer_boxes[index] or {} -- models/free-market.can:505
	inactive_buy_boxes[index] = inactive_buy_boxes[index] or {} -- models/free-market.can:506
	sell_prices[index] = sell_prices[index] or {} -- models/free-market.can:507
	buy_prices[index] = buy_prices[index] or {} -- models/free-market.can:508
	pull_boxes[index] = pull_boxes[index] or {} -- models/free-market.can:509
	universal_transfer_boxes[index] = universal_transfer_boxes[index] or {} -- models/free-market.can:510
	transfer_boxes[index] = transfer_boxes[index] or {} -- models/free-market.can:511
	buy_boxes[index] = buy_boxes[index] or {} -- models/free-market.can:512
	embargoes[index] = embargoes[index] or {} -- models/free-market.can:513
	storages[index] = storages[index] or {} -- models/free-market.can:514
	if storages_limit[index] == nil then -- models/free-market.can:516
		storages_limit[index] = {} -- models/free-market.can:517
		local f_storages_limit = storages_limit[index] -- models/free-market.can:518
		for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:519
			if item["stack_size"] <= 5 then -- models/free-market.can:520
				f_storages_limit[item_name] = 1 -- models/free-market.can:521
			end -- models/free-market.can:521
		end -- models/free-market.can:521
	end -- models/free-market.can:521
end -- models/free-market.can:521
local function remove_certain_transfer_box(entity, box_data) -- models/free-market.can:529
	local force_index = entity["force"]["index"] -- models/free-market.can:530
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:531
	local item_name = box_data[5] -- models/free-market.can:532
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:533
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:534
	if entities == nil then -- models/free-market.can:535
		return  -- models/free-market.can:535
	end -- models/free-market.can:535
	for i = # entities, 1, - 1 do -- models/free-market.can:536
		if entities[i] == entity then -- models/free-market.can:537
			tremove(entities, i) -- models/free-market.can:538
			if # entities == 0 then -- models/free-market.can:539
				f_transfer_boxes[item_name] = nil -- models/free-market.can:540
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:541
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:542
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:543
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:544
					if sell_price then -- models/free-market.can:545
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:546
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:547
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:548
							f_sell_prices[item_name] = nil -- models/free-market.can:549
						end -- models/free-market.can:549
					end -- models/free-market.can:549
				end -- models/free-market.can:549
			end -- models/free-market.can:549
			return  -- models/free-market.can:554
		end -- models/free-market.can:554
	end -- models/free-market.can:554
end -- models/free-market.can:554
local function remove_certain_bin_box(entity, box_data) -- models/free-market.can:561
	local force_index = entity["force"]["index"] -- models/free-market.can:562
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:563
	local item_name = box_data[5] -- models/free-market.can:564
	local entities = f_bin_boxes[item_name] -- models/free-market.can:565
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:566
	if entities == nil then -- models/free-market.can:567
		return  -- models/free-market.can:567
	end -- models/free-market.can:567
	for i = # entities, 1, - 1 do -- models/free-market.can:568
		if entities[i] == entity then -- models/free-market.can:569
			tremove(entities, i) -- models/free-market.can:570
			if # entities == 0 then -- models/free-market.can:571
				f_bin_boxes[item_name] = nil -- models/free-market.can:572
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:573
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:574
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:575
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:576
					if sell_price and transfer_boxes[force_index][item_name] == nil then -- models/free-market.can:577
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:578
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:579
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:580
							f_sell_prices[item_name] = nil -- models/free-market.can:581
						end -- models/free-market.can:581
					end -- models/free-market.can:581
				end -- models/free-market.can:581
			end -- models/free-market.can:581
			return  -- models/free-market.can:586
		end -- models/free-market.can:586
	end -- models/free-market.can:586
end -- models/free-market.can:586
local function remove_certain_universal_transfer_box(entity) -- models/free-market.can:592
	local force_index = entity["force"]["index"] -- models/free-market.can:593
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:594
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:595
	if entities == nil then -- models/free-market.can:596
		return  -- models/free-market.can:596
	end -- models/free-market.can:596
	for i = # entities, 1, - 1 do -- models/free-market.can:597
		if entities[i] == entity then -- models/free-market.can:598
			tremove(entities, i) -- models/free-market.can:599
			return  -- models/free-market.can:600
		end -- models/free-market.can:600
	end -- models/free-market.can:600
end -- models/free-market.can:600
local function remove_certain_universal_bin_box(entity) -- models/free-market.can:606
	local force_index = entity["force"]["index"] -- models/free-market.can:607
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:608
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:609
	if entities == nil then -- models/free-market.can:610
		return  -- models/free-market.can:610
	end -- models/free-market.can:610
	for i = # entities, 1, - 1 do -- models/free-market.can:611
		if entities[i] == entity then -- models/free-market.can:612
			tremove(entities, i) -- models/free-market.can:613
			return  -- models/free-market.can:614
		end -- models/free-market.can:614
	end -- models/free-market.can:614
end -- models/free-market.can:614
local function remove_certain_buy_box(entity, box_data) -- models/free-market.can:621
	local force_index = entity["force"]["index"] -- models/free-market.can:622
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:623
	local item_name = box_data[5] -- models/free-market.can:624
	local items_data = f_buy_boxes[item_name] -- models/free-market.can:625
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:626
	if items_data == nil then -- models/free-market.can:627
		return  -- models/free-market.can:627
	end -- models/free-market.can:627
	for i = # items_data, 1, - 1 do -- models/free-market.can:628
		local buy_box = items_data[i] -- models/free-market.can:629
		if buy_box[1] == entity then -- models/free-market.can:630
			tremove(items_data, i) -- models/free-market.can:631
			if # items_data == 0 then -- models/free-market.can:632
				f_buy_boxes[item_name] = nil -- models/free-market.can:633
				local f_buy_prices = buy_prices[force_index] -- models/free-market.can:634
				local buy_price = f_buy_prices[item_name] -- models/free-market.can:635
				if buy_price then -- models/free-market.can:636
					inactive_buy_prices[force_index][item_name] = buy_price -- models/free-market.can:637
					f_buy_prices[item_name] = nil -- models/free-market.can:638
				end -- models/free-market.can:638
			end -- models/free-market.can:638
			return  -- models/free-market.can:641
		end -- models/free-market.can:641
	end -- models/free-market.can:641
end -- models/free-market.can:641
local function remove_certain_pull_box(entity, box_data) -- models/free-market.can:648
	local force_index = entity["force"]["index"] -- models/free-market.can:649
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:650
	local item_name = box_data[5] -- models/free-market.can:651
	local entities = f_pull_boxes[item_name] -- models/free-market.can:652
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:653
	if entities == nil then -- models/free-market.can:654
		return  -- models/free-market.can:654
	end -- models/free-market.can:654
	for i = # entities, 1, - 1 do -- models/free-market.can:655
		if entities[i] == entity then -- models/free-market.can:656
			tremove(entities, i) -- models/free-market.can:657
			if # entities == 0 then -- models/free-market.can:658
				f_pull_boxes[item_name] = nil -- models/free-market.can:659
			end -- models/free-market.can:659
			return  -- models/free-market.can:661
		end -- models/free-market.can:661
	end -- models/free-market.can:661
end -- models/free-market.can:661
local function change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:670
	local data = buy_boxes[entity["force"]["index"]][item_name] -- models/free-market.can:671
	for i = 1, # data do -- models/free-market.can:672
		local buy_box = data[i] -- models/free-market.can:673
		if buy_box[1] == entity then -- models/free-market.can:674
			buy_box[2] = count -- models/free-market.can:675
			return  -- models/free-market.can:676
		end -- models/free-market.can:676
	end -- models/free-market.can:676
end -- models/free-market.can:676
local function clear_invalid_embargoes() -- models/free-market.can:681
	local forces = game["forces"] -- models/free-market.can:682
	for index in pairs(embargoes) do -- models/free-market.can:683
		if forces[index] == nil then -- models/free-market.can:684
			embargoes[index] = nil -- models/free-market.can:685
		end -- models/free-market.can:685
	end -- models/free-market.can:685
	for _, forces_data in pairs(embargoes) do -- models/free-market.can:688
		for index in pairs(forces_data) do -- models/free-market.can:689
			if forces[index] == nil then -- models/free-market.can:690
				forces_data[index] = nil -- models/free-market.can:691
			end -- models/free-market.can:691
		end -- models/free-market.can:691
	end -- models/free-market.can:691
end -- models/free-market.can:691
local function show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:700
	if # force["connected_players"] > 1 then -- models/free-market.can:701
		draw_sprite({ -- models/free-market.can:702
			["sprite"] = "item." .. item_name, -- models/free-market.can:703
			["target"] = entity, -- models/free-market.can:704
			["surface"] = entity["surface"], -- models/free-market.can:705
			["forces"] = { force }, -- models/free-market.can:706
			["time_to_live"] = 200, -- models/free-market.can:707
			["x_scale"] = 0.9, -- models/free-market.can:708
			["target_offset"] = HINT_SPRITE_OFFSET -- models/free-market.can:709
		}) -- models/free-market.can:709
	end -- models/free-market.can:709
end -- models/free-market.can:709
local function clear_invalid_prices(prices) -- models/free-market.can:714
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:715
	local forces = game["forces"] -- models/free-market.can:716
	for index, forces_data in pairs(prices) do -- models/free-market.can:717
		if forces[index] == nil then -- models/free-market.can:718
			sell_prices[index] = nil -- models/free-market.can:719
			buy_prices[index] = nil -- models/free-market.can:720
			inactive_sell_prices[index] = nil -- models/free-market.can:721
			inactive_buy_prices[index] = nil -- models/free-market.can:722
		else -- models/free-market.can:722
			for item_name in pairs(forces_data) do -- models/free-market.can:724
				if item_prototypes[item_name] == nil then -- models/free-market.can:725
					forces_data[item_name] = nil -- models/free-market.can:726
				end -- models/free-market.can:726
			end -- models/free-market.can:726
		end -- models/free-market.can:726
	end -- models/free-market.can:726
end -- models/free-market.can:726
local function clear_invalid_storage_data() -- models/free-market.can:733
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:734
	local forces = game["forces"] -- models/free-market.can:735
	for index, data in pairs(pull_boxes) do -- models/free-market.can:736
		if forces[index] == nil then -- models/free-market.can:737
			clear_force_data(index) -- models/free-market.can:738
		else -- models/free-market.can:738
			for item_name, count in pairs(data) do -- models/free-market.can:740
				if item_prototypes[item_name] == nil or count == 0 then -- models/free-market.can:741
					data[item_name] = nil -- models/free-market.can:742
				end -- models/free-market.can:742
			end -- models/free-market.can:742
		end -- models/free-market.can:742
	end -- models/free-market.can:742
end -- models/free-market.can:742
local function clear_invalid_pull_boxes_data() -- models/free-market.can:749
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:750
	local forces = game["forces"] -- models/free-market.can:751
	for index, data in pairs(pull_boxes) do -- models/free-market.can:752
		if forces[index] == nil then -- models/free-market.can:753
			clear_force_data(index) -- models/free-market.can:754
		else -- models/free-market.can:754
			for item_name, entities in pairs(data) do -- models/free-market.can:756
				if item_prototypes[item_name] == nil then -- models/free-market.can:757
					data[item_name] = nil -- models/free-market.can:758
				else -- models/free-market.can:758
					for i = # entities, 1, - 1 do -- models/free-market.can:760
						local entity = entities[i] -- models/free-market.can:761
						if entity["valid"] == false then -- models/free-market.can:762
							tremove(entities, i) -- models/free-market.can:763
						else -- models/free-market.can:763
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:765
							if box_data == nil then -- models/free-market.can:766
								tremove(entities, i) -- models/free-market.can:767
							elseif entity ~= box_data[1] then -- models/free-market.can:768
								rendering_destroy(box_data[2]) -- models/free-market.can:769
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:770
								tremove(entities, i) -- models/free-market.can:771
							end -- models/free-market.can:771
						end -- models/free-market.can:771
					end -- models/free-market.can:771
					if # entities == 0 then -- models/free-market.can:775
						data[item_name] = nil -- models/free-market.can:776
					end -- models/free-market.can:776
				end -- models/free-market.can:776
			end -- models/free-market.can:776
		end -- models/free-market.can:776
	end -- models/free-market.can:776
end -- models/free-market.can:776
local function clear_invalid_transfer_boxes_data(_data) -- models/free-market.can:785
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:786
	local forces = game["forces"] -- models/free-market.can:787
	for index, data in pairs(_data) do -- models/free-market.can:788
		if forces[index] == nil then -- models/free-market.can:789
			clear_force_data(index) -- models/free-market.can:790
		else -- models/free-market.can:790
			for item_name, entities in pairs(data) do -- models/free-market.can:792
				if item_prototypes[item_name] == nil then -- models/free-market.can:793
					data[item_name] = nil -- models/free-market.can:794
				else -- models/free-market.can:794
					for i = # entities, 1, - 1 do -- models/free-market.can:796
						local entity = entities[i] -- models/free-market.can:797
						if entity["valid"] == false then -- models/free-market.can:798
							tremove(entities, i) -- models/free-market.can:799
						else -- models/free-market.can:799
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:801
							if box_data == nil then -- models/free-market.can:802
								tremove(entities, i) -- models/free-market.can:803
							elseif entity ~= box_data[1] then -- models/free-market.can:804
								rendering_destroy(box_data[2]) -- models/free-market.can:805
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:806
								tremove(entities, i) -- models/free-market.can:807
							end -- models/free-market.can:807
						end -- models/free-market.can:807
					end -- models/free-market.can:807
					if # entities == 0 then -- models/free-market.can:811
						data[item_name] = nil -- models/free-market.can:812
					end -- models/free-market.can:812
				end -- models/free-market.can:812
			end -- models/free-market.can:812
		end -- models/free-market.can:812
	end -- models/free-market.can:812
end -- models/free-market.can:812
local function clear_invalid_buy_boxes_data(_data) -- models/free-market.can:821
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:822
	local forces = game["forces"] -- models/free-market.can:823
	for index, data in pairs(_data) do -- models/free-market.can:824
		if forces[index] == nil then -- models/free-market.can:825
			clear_force_data(index) -- models/free-market.can:826
		else -- models/free-market.can:826
			for item_name, entities in pairs(data) do -- models/free-market.can:828
				if item_prototypes[item_name] == nil then -- models/free-market.can:829
					data[item_name] = nil -- models/free-market.can:830
				else -- models/free-market.can:830
					for i = # entities, 1, - 1 do -- models/free-market.can:832
						local box_data = entities[i] -- models/free-market.can:833
						local entity = box_data[1] -- models/free-market.can:834
						if entity["valid"] == false then -- models/free-market.can:835
							tremove(entities, i) -- models/free-market.can:836
						elseif not box_data[2] then -- models/free-market.can:837
							tremove(entities, i) -- models/free-market.can:838
							all_boxes[entity["unit_number"]] = nil -- models/free-market.can:839
						else -- models/free-market.can:839
							local _box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:841
							if _box_data == nil then -- models/free-market.can:842
								tremove(entities, i) -- models/free-market.can:843
							elseif entity ~= _box_data[1] then -- models/free-market.can:844
								rendering_destroy(box_data[2]) -- models/free-market.can:845
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:846
								tremove(entities, i) -- models/free-market.can:847
							end -- models/free-market.can:847
						end -- models/free-market.can:847
					end -- models/free-market.can:847
					if # entities == 0 then -- models/free-market.can:851
						data[item_name] = nil -- models/free-market.can:852
					end -- models/free-market.can:852
				end -- models/free-market.can:852
			end -- models/free-market.can:852
		end -- models/free-market.can:852
	end -- models/free-market.can:852
end -- models/free-market.can:852
local function clear_invalid_simple_boxes(data) -- models/free-market.can:861
	for _, entities in pairs(data) do -- models/free-market.can:862
		for i = # entities, 1, - 1 do -- models/free-market.can:863
			local entity = entities[i] -- models/free-market.can:864
			if entity["valid"] == false then -- models/free-market.can:865
				tremove(entities, i) -- models/free-market.can:866
			else -- models/free-market.can:866
				local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:868
				if box_data == nil then -- models/free-market.can:869
					tremove(entities, i) -- models/free-market.can:870
				elseif entity ~= box_data[1] then -- models/free-market.can:871
					rendering_destroy(box_data[2]) -- models/free-market.can:872
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:873
					tremove(entities, i) -- models/free-market.can:874
				end -- models/free-market.can:874
			end -- models/free-market.can:874
		end -- models/free-market.can:874
	end -- models/free-market.can:874
end -- models/free-market.can:874
local function delete_item_price_HUD(player) -- models/free-market.can:882
	local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:883
	if frame then -- models/free-market.can:884
		frame["destroy"]() -- models/free-market.can:885
		item_HUD[player["index"]] = nil -- models/free-market.can:886
	end -- models/free-market.can:886
end -- models/free-market.can:886
local function clear_invalid_player_data() -- models/free-market.can:890
	for player_index in pairs(item_HUD) do -- models/free-market.can:891
		local player = game["get_player"](player_index) -- models/free-market.can:892
		if not (player and player["valid"]) then -- models/free-market.can:893
			item_HUD[player_index] = nil -- models/free-market.can:894
		elseif not player["connected"] then -- models/free-market.can:895
			delete_item_price_HUD(player) -- models/free-market.can:896
		end -- models/free-market.can:896
	end -- models/free-market.can:896
end -- models/free-market.can:896
local function clear_invalid_entities() -- models/free-market.can:901
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:902
	for unit_number, data in pairs(all_boxes) do -- models/free-market.can:903
		if not data[1]["valid"] then -- models/free-market.can:904
			all_boxes[unit_number] = nil -- models/free-market.can:905
		else -- models/free-market.can:905
			local item_name = data[5] -- models/free-market.can:907
			if item_name and item_prototypes[item_name] == nil then -- models/free-market.can:908
				rendering_destroy(data[2]) -- models/free-market.can:909
				all_boxes[unit_number] = nil -- models/free-market.can:910
			end -- models/free-market.can:910
		end -- models/free-market.can:910
	end -- models/free-market.can:910
	clear_invalid_storage_data() -- models/free-market.can:915
	clear_invalid_pull_boxes_data() -- models/free-market.can:916
	clear_invalid_transfer_boxes_data(transfer_boxes) -- models/free-market.can:917
	clear_invalid_transfer_boxes_data(inactive_transfer_boxes) -- models/free-market.can:918
	clear_invalid_transfer_boxes_data(bin_boxes) -- models/free-market.can:919
	clear_invalid_transfer_boxes_data(inactive_bin_boxes) -- models/free-market.can:920
	clear_invalid_buy_boxes_data(buy_boxes) -- models/free-market.can:921
	clear_invalid_buy_boxes_data(inactive_buy_boxes) -- models/free-market.can:922
	clear_invalid_simple_boxes(universal_transfer_boxes) -- models/free-market.can:923
	clear_invalid_simple_boxes(inactive_universal_transfer_boxes) -- models/free-market.can:924
	clear_invalid_simple_boxes(universal_bin_boxes) -- models/free-market.can:925
	clear_invalid_simple_boxes(inactive_universal_bin_boxes) -- models/free-market.can:926
end -- models/free-market.can:926
clear_invalid_data = function() -- models/free-market.can:929
	clear_invalid_entities() -- models/free-market.can:930
	clear_invalid_prices(storages_limit) -- models/free-market.can:931
	clear_invalid_prices(inactive_sell_prices) -- models/free-market.can:932
	clear_invalid_prices(inactive_buy_prices) -- models/free-market.can:933
	clear_invalid_prices(sell_prices) -- models/free-market.can:934
	clear_invalid_prices(buy_prices) -- models/free-market.can:935
	clear_invalid_embargoes() -- models/free-market.can:936
	clear_invalid_player_data() -- models/free-market.can:937
end -- models/free-market.can:937
local function get_distance(start, stop) -- models/free-market.can:941
	local xdiff = start["x"] - stop["x"] -- models/free-market.can:942
	local ydiff = start["y"] - stop["y"] -- models/free-market.can:943
	return (xdiff * xdiff + ydiff * ydiff) ^ 0.5 -- models/free-market.can:944
end -- models/free-market.can:944
local function delete_player_data(event) -- models/free-market.can:947
	local player_index = event["player_index"] -- models/free-market.can:948
	open_box[player_index] = nil -- models/free-market.can:949
	item_HUD[player_index] = nil -- models/free-market.can:950
end -- models/free-market.can:950
local function make_prices_header(table) -- models/free-market.can:953
	local dummy -- models/free-market.can:954
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:955
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:956
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:957
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:958
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:959
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:960
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:961
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:962
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:963
	table["add"](LABEL)["caption"] = { "team-name" } -- models/free-market.can:965
	table["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:966
	table["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:967
end -- models/free-market.can:967
local function make_storage_header(table) -- models/free-market.can:970
	local dummy -- models/free-market.can:971
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:972
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:973
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:974
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:975
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:976
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:977
	table["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:979
	table["add"](LABEL)["caption"] = { "gui-logistic.count" } -- models/free-market.can:980
end -- models/free-market.can:980
local function make_price_list_header(table_element) -- models/free-market.can:984
	local dummy -- models/free-market.can:985
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:986
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:987
	dummy["style"]["minimal_width"] = 30 -- models/free-market.can:988
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:989
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:990
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:991
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:992
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:993
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:994
	table_element["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:996
	table_element["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:997
	table_element["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:998
end -- models/free-market.can:998
local function update_prices_table(player, item_name, table_element) -- models/free-market.can:1004
	table_element["clear"]() -- models/free-market.can:1005
	make_prices_header(table_element) -- models/free-market.can:1006
	local force = player["force"] -- models/free-market.can:1007
	local result = {} -- models/free-market.can:1008
	for name, _force in pairs(game["forces"]) do -- models/free-market.can:1009
		if force ~= _force then -- models/free-market.can:1010
			result[_force["index"]] = { ["name"] = name } -- models/free-market.can:1011
		end -- models/free-market.can:1011
	end -- models/free-market.can:1011
	for index, force_items in pairs(buy_prices) do -- models/free-market.can:1014
		local data = result[index] -- models/free-market.can:1015
		if data then -- models/free-market.can:1016
			local buy_value = force_items[item_name] -- models/free-market.can:1017
			if buy_value then -- models/free-market.can:1018
				data["buy_price"] = tostring(buy_value) -- models/free-market.can:1019
			end -- models/free-market.can:1019
		end -- models/free-market.can:1019
	end -- models/free-market.can:1019
	for index, force_items in pairs(sell_prices) do -- models/free-market.can:1023
		local data = result[index] -- models/free-market.can:1024
		if data then -- models/free-market.can:1025
			local sell_price = force_items[item_name] -- models/free-market.can:1026
			if sell_price then -- models/free-market.can:1027
				data["sell_price"] = tostring(sell_price) -- models/free-market.can:1028
			end -- models/free-market.can:1028
		end -- models/free-market.can:1028
	end -- models/free-market.can:1028
	local add = table_element["add"] -- models/free-market.can:1033
	for _, data in pairs(result) do -- models/free-market.can:1034
		if data["buy_price"] or data["sell_price"] then -- models/free-market.can:1035
			add(LABEL)["caption"] = data["name"] -- models/free-market.can:1036
			add(LABEL)["caption"] = (data["buy_price"] or "") -- models/free-market.can:1037
			add(LABEL)["caption"] = (data["sell_price"] or "") -- models/free-market.can:1038
		end -- models/free-market.can:1038
	end -- models/free-market.can:1038
end -- models/free-market.can:1038
local function update_price_list_table(force, scroll_pane) -- models/free-market.can:1045
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1046
	short_price_list_table["clear"]() -- models/free-market.can:1047
	short_price_list_table["visible"] = false -- models/free-market.can:1048
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1049
	price_list_table["clear"]() -- models/free-market.can:1050
	price_list_table["visible"] = true -- models/free-market.can:1051
	make_price_list_header(price_list_table) -- models/free-market.can:1052
	local force_index = force["index"] -- models/free-market.can:1054
	local f_buy_prices = buy_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1055
	local f_sell_prices = sell_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1056
	local add = price_list_table["add"] -- models/free-market.can:1058
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1059
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1060
		add(LABEL)["caption"] = buy_price -- models/free-market.can:1061
		add(LABEL)["caption"] = (f_sell_prices[item_name] or "") -- models/free-market.can:1062
	end -- models/free-market.can:1062
	for item_name, sell_price in pairs(f_sell_prices) do -- models/free-market.can:1065
		if f_buy_prices[item_name] == nil then -- models/free-market.can:1066
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1067
			add(EMPTY_WIDGET) -- models/free-market.can:1068
			add(LABEL)["caption"] = sell_price -- models/free-market.can:1069
		end -- models/free-market.can:1069
	end -- models/free-market.can:1069
end -- models/free-market.can:1069
local function update_price_list_by_sell_filter(force, scroll_pane, text_filter) -- models/free-market.can:1077
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1078
	short_price_list_table["clear"]() -- models/free-market.can:1079
	short_price_list_table["visible"] = true -- models/free-market.can:1080
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1081
	price_list_table["clear"]() -- models/free-market.can:1082
	price_list_table["visible"] = false -- models/free-market.can:1083
	make_price_list_header(short_price_list_table) -- models/free-market.can:1085
	short_price_list_table["children"][5]["destroy"]() -- models/free-market.can:1086
	short_price_list_table["children"][2]["destroy"]() -- models/free-market.can:1087
	local f_sell_prices = sell_prices[force["index"]] -- models/free-market.can:1089
	if f_sell_prices == nil then -- models/free-market.can:1090
		return  -- models/free-market.can:1090
	end -- models/free-market.can:1090
	local add = short_price_list_table["add"] -- models/free-market.can:1092
	for item_name, buy_price in pairs(f_sell_prices) do -- models/free-market.can:1093
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1094
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1095
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1096
		end -- models/free-market.can:1096
	end -- models/free-market.can:1096
end -- models/free-market.can:1096
local function update_price_list_by_buy_filter(force, scroll_pane, text_filter) -- models/free-market.can:1104
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1105
	short_price_list_table["clear"]() -- models/free-market.can:1106
	short_price_list_table["visible"] = true -- models/free-market.can:1107
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1108
	price_list_table["clear"]() -- models/free-market.can:1109
	price_list_table["visible"] = false -- models/free-market.can:1110
	make_price_list_header(short_price_list_table) -- models/free-market.can:1112
	short_price_list_table["children"][6]["destroy"]() -- models/free-market.can:1113
	short_price_list_table["children"][3]["destroy"]() -- models/free-market.can:1114
	local f_buy_prices = buy_prices[force["index"]] -- models/free-market.can:1116
	if f_buy_prices == nil then -- models/free-market.can:1117
		return  -- models/free-market.can:1117
	end -- models/free-market.can:1117
	local add = short_price_list_table["add"] -- models/free-market.can:1119
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1120
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1121
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1122
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1123
		end -- models/free-market.can:1123
	end -- models/free-market.can:1123
end -- models/free-market.can:1123
local function destroy_prices_gui(player) -- models/free-market.can:1129
	local screen = player["gui"]["screen"] -- models/free-market.can:1130
	if screen["FM_prices_frame"] then -- models/free-market.can:1131
		screen["FM_prices_frame"]["destroy"]() -- models/free-market.can:1132
	end -- models/free-market.can:1132
end -- models/free-market.can:1132
local function destroy_price_list_gui(player) -- models/free-market.can:1137
	local screen = player["gui"]["screen"] -- models/free-market.can:1138
	if screen["FM_price_list_frame"] then -- models/free-market.can:1139
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1140
	end -- models/free-market.can:1140
end -- models/free-market.can:1140
local function update_embargo_table(embargo_table, player) -- models/free-market.can:1146
	embargo_table["clear"]() -- models/free-market.can:1147
	embargo_table["add"](LABEL)["caption"] = { "free-market.without-embargo-title" } -- models/free-market.can:1149
	embargo_table["add"](EMPTY_WIDGET) -- models/free-market.can:1150
	embargo_table["add"](LABEL)["caption"] = { "free-market.with-embargo-title" } -- models/free-market.can:1151
	local force_index = player["force"]["index"] -- models/free-market.can:1153
	local in_embargo_list = {} -- models/free-market.can:1154
	local no_embargo_list = {} -- models/free-market.can:1155
	local f_embargoes = embargoes[force_index] -- models/free-market.can:1156
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1157
		if # force["players"] > 0 and force["index"] ~= force_index then -- models/free-market.can:1158
			if f_embargoes[force["index"]] then -- models/free-market.can:1159
				in_embargo_list[# in_embargo_list + 1] = force_name -- models/free-market.can:1160
			else -- models/free-market.can:1160
				no_embargo_list[# no_embargo_list + 1] = force_name -- models/free-market.can:1162
			end -- models/free-market.can:1162
		end -- models/free-market.can:1162
	end -- models/free-market.can:1162
	local forces_list = embargo_table["add"]({ -- models/free-market.can:1167
		["type"] = "list-box", -- models/free-market.can:1167
		["name"] = "forces_list", -- models/free-market.can:1167
		["items"] = no_embargo_list -- models/free-market.can:1167
	}) -- models/free-market.can:1167
	forces_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1168
	forces_list["style"]["height"] = 200 -- models/free-market.can:1169
	local buttons_flow = embargo_table["add"](VERTICAL_FLOW) -- models/free-market.can:1170
	buttons_flow["add"]({ -- models/free-market.can:1171
		["type"] = "sprite-button", -- models/free-market.can:1171
		["name"] = "FM_cancel_embargo", -- models/free-market.can:1171
		["style"] = "tool_button", -- models/free-market.can:1171
		["sprite"] = "utility/left_arrow" -- models/free-market.can:1171
	}) -- models/free-market.can:1171
	buttons_flow["add"]({ -- models/free-market.can:1172
		["type"] = "sprite-button", -- models/free-market.can:1172
		["name"] = "FM_declare_embargo", -- models/free-market.can:1172
		["style"] = "tool_button", -- models/free-market.can:1172
		["sprite"] = "utility/right_arrow" -- models/free-market.can:1172
	}) -- models/free-market.can:1172
	local embargo_list = embargo_table["add"]({ -- models/free-market.can:1173
		["type"] = "list-box", -- models/free-market.can:1173
		["name"] = "embargo_list", -- models/free-market.can:1173
		["items"] = in_embargo_list -- models/free-market.can:1173
	}) -- models/free-market.can:1173
	embargo_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1174
	embargo_list["style"]["height"] = 200 -- models/free-market.can:1175
end -- models/free-market.can:1175
local function add_item_in_sell_prices(player, item_name, price, force_index) -- models/free-market.can:1181
	local prices_table = player["gui"]["screen"]["FM_sell_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1182
	local add = prices_table["add"] -- models/free-market.can:1183
	local button = add(FLOW)["add"](SELL_PRICE_BUTTON) -- models/free-market.can:1184
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1185
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1186
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1187
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1189
	add(POST_PRICE_LABEL) -- models/free-market.can:1190
	local children = prices_table["children"] -- models/free-market.can:1192
	if # children / 2 > player["mod_settings"]["FM_sell_notification_size"]["value"] then -- models/free-market.can:1193
		children[2]["destroy"]() -- models/free-market.can:1194
		children[1]["destroy"]() -- models/free-market.can:1195
	end -- models/free-market.can:1195
end -- models/free-market.can:1195
local function add_item_in_buy_prices(player, item_name, price, force_index) -- models/free-market.can:1202
	local prices_table = player["gui"]["screen"]["FM_buy_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1203
	local add = prices_table["add"] -- models/free-market.can:1204
	local button = add(FLOW)["add"](BUY_PRICE_BUTTON) -- models/free-market.can:1205
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1206
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1207
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1208
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1210
	add(POST_PRICE_LABEL) -- models/free-market.can:1211
	local children = prices_table["children"] -- models/free-market.can:1213
	if # children / 2 > player["mod_settings"]["FM_buy_notification_size"]["value"] then -- models/free-market.can:1214
		children[2]["destroy"]() -- models/free-market.can:1215
		children[1]["destroy"]() -- models/free-market.can:1216
	end -- models/free-market.can:1216
end -- models/free-market.can:1216
local function notify_sell_price(source_index, item_name, sell_price) -- models/free-market.can:1223
	local forces = game["forces"] -- models/free-market.can:1224
	local f_embargoes = embargoes[source_index] -- models/free-market.can:1225
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1226
		if force_index ~= source_index and not f_embargoes[f_embargoes] then -- models/free-market.can:1227
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1228
				pcall(add_item_in_sell_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1229
			end -- models/free-market.can:1229
		end -- models/free-market.can:1229
	end -- models/free-market.can:1229
end -- models/free-market.can:1229
local function notify_buy_price(source_index, item_name, sell_price) -- models/free-market.can:1238
	local forces = game["forces"] -- models/free-market.can:1239
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1240
		if force_index ~= source_index and not embargoes[force_index][source_index] then -- models/free-market.can:1241
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1242
				pcall(add_item_in_buy_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1243
			end -- models/free-market.can:1243
		end -- models/free-market.can:1243
	end -- models/free-market.can:1243
end -- models/free-market.can:1243
local function change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:1253
	local force_index = player["force"]["index"] -- models/free-market.can:1254
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1255
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1256
	if sell_price == nil then -- models/free-market.can:1257
		f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1258
		f_sell_prices[item_name] = nil -- models/free-market.can:1259
		return  -- models/free-market.can:1260
	end -- models/free-market.can:1260
	local active_sell_price = f_sell_prices[item_name] -- models/free-market.can:1263
	local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1264
	local prev_sell_price = f_sell_prices[item_name] or inactive_sell_price -- models/free-market.can:1265
	if prev_sell_price == sell_price then -- models/free-market.can:1266
		if inactive_sell_price then -- models/free-market.can:1267
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1268
			if count_in_storage and count_in_storage > 0 then -- models/free-market.can:1269
				f_sell_prices[item_name] = sell_price -- models/free-market.can:1270
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1271
				notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1272
			end -- models/free-market.can:1272
		end -- models/free-market.can:1272
		return  -- models/free-market.can:1275
	end -- models/free-market.can:1275
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1278
	if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then -- models/free-market.can:1279
		player["print"]({ -- models/free-market.can:1280
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1280
			sell_price, -- models/free-market.can:1280
			buy_price or minimal_price, -- models/free-market.can:1280
			maximal_price -- models/free-market.can:1280
		}) -- models/free-market.can:1280
		return active_sell_price or inactive_sell_price or "" -- models/free-market.can:1281
	end -- models/free-market.can:1281
	if active_sell_price then -- models/free-market.can:1284
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1285
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1286
	elseif inactive_sell_price then -- models/free-market.can:1287
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1288
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1289
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1290
		else -- models/free-market.can:1290
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1292
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1293
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1294
		end -- models/free-market.can:1294
	elseif transfer_boxes[force_index][item_name] then -- models/free-market.can:1296
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1297
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1298
	else -- models/free-market.can:1298
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1300
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1301
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1302
		else -- models/free-market.can:1302
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1304
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1305
		end -- models/free-market.can:1305
	end -- models/free-market.can:1305
end -- models/free-market.can:1305
local function change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:1314
	local force_index = player["force"]["index"] -- models/free-market.can:1315
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1316
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1317
	if buy_price == nil then -- models/free-market.can:1318
		f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1319
		f_buy_prices[item_name] = nil -- models/free-market.can:1320
		return  -- models/free-market.can:1321
	end -- models/free-market.can:1321
	local prev_buy_price = f_buy_prices[item_name] or f_inactive_buy_prices[item_name] -- models/free-market.can:1324
	if prev_buy_price == buy_price then -- models/free-market.can:1325
		return  -- models/free-market.can:1326
	end -- models/free-market.can:1326
	local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:1329
	if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then -- models/free-market.can:1330
		player["print"]({ -- models/free-market.can:1331
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1331
			buy_price, -- models/free-market.can:1331
			minimal_price, -- models/free-market.can:1331
			sell_price or maximal_price -- models/free-market.can:1331
		}) -- models/free-market.can:1331
		return f_buy_prices[item_name] or f_inactive_buy_prices[item_name] or "" -- models/free-market.can:1332
	end -- models/free-market.can:1332
	if f_buy_prices[item_name] then -- models/free-market.can:1335
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1336
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1337
	elseif f_inactive_buy_prices[item_name] then -- models/free-market.can:1338
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1339
	elseif buy_boxes[force_index][item_name] then -- models/free-market.can:1340
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1341
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1342
	else -- models/free-market.can:1342
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1344
	end -- models/free-market.can:1344
end -- models/free-market.can:1344
local function create_price_notification_handler(gui, button_name, is_top_handler) -- models/free-market.can:1351
	local flow = gui["add"](TITLEBAR_FLOW) -- models/free-market.can:1352
	flow["style"]["padding"] = 0 -- models/free-market.can:1353
	if is_top_handler then -- models/free-market.can:1354
		local button = flow["add"]({ -- models/free-market.can:1355
			["type"] = "sprite-button", -- models/free-market.can:1356
			["sprite"] = "FM_price", -- models/free-market.can:1357
			["style"] = "frame_action_button", -- models/free-market.can:1358
			["name"] = button_name -- models/free-market.can:1359
		}) -- models/free-market.can:1359
		button["style"]["margin"] = 0 -- models/free-market.can:1361
	end -- models/free-market.can:1361
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:1363
	drag_handler["drag_target"] = gui -- models/free-market.can:1364
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:1365
	if is_top_handler then -- models/free-market.can:1366
		flow["style"]["horizontal_spacing"] = 0 -- models/free-market.can:1367
		drag_handler["style"]["width"] = 27 -- models/free-market.can:1368
		drag_handler["style"]["height"] = 25 -- models/free-market.can:1369
		drag_handler["style"]["horizontally_stretchable"] = false -- models/free-market.can:1370
	else -- models/free-market.can:1370
		drag_handler["style"]["width"] = 24 -- models/free-market.can:1372
		drag_handler["style"]["height"] = 46 -- models/free-market.can:1373
		drag_handler["add"]({ -- models/free-market.can:1374
			["type"] = "sprite-button", -- models/free-market.can:1375
			["sprite"] = "FM_price", -- models/free-market.can:1376
			["style"] = "frame_action_button", -- models/free-market.can:1377
			["name"] = button_name -- models/free-market.can:1378
		}) -- models/free-market.can:1378
	end -- models/free-market.can:1378
end -- models/free-market.can:1378
local function switch_sell_prices_gui(player, location) -- models/free-market.can:1385
	local screen = player["gui"]["screen"] -- models/free-market.can:1386
	local main_frame = screen["FM_sell_prices_frame"] -- models/free-market.can:1387
	if main_frame then -- models/free-market.can:1388
		local children = main_frame["children"] -- models/free-market.can:1389
		if # children > 1 then -- models/free-market.can:1390
			children[2]["destroy"]() -- models/free-market.can:1391
			return  -- models/free-market.can:1392
		else -- models/free-market.can:1392
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1394
				["type"] = "frame", -- models/free-market.can:1394
				["name"] = "FM_prices_flow", -- models/free-market.can:1394
				["style"] = "FM_prices_frame", -- models/free-market.can:1394
				["direction"] = "vertical" -- models/free-market.can:1394
			}) -- models/free-market.can:1394
			local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1395
			prices_flow["add"]({ -- models/free-market.can:1396
				["type"] = "table", -- models/free-market.can:1396
				["name"] = "FM_prices_table", -- models/free-market.can:1396
				["style"] = "FM_prices_table", -- models/free-market.can:1396
				["column_count"] = column_count -- models/free-market.can:1396
			}) -- models/free-market.can:1396
		end -- models/free-market.can:1396
	else -- models/free-market.can:1396
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1406
		local is_vertical = (column_count == 2) -- models/free-market.can:1407
		if is_vertical then -- models/free-market.can:1408
			direction = "vertical" -- models/free-market.can:1409
		else -- models/free-market.can:1409
			direction = "horizontal" -- models/free-market.can:1411
		end -- models/free-market.can:1411
		main_frame = screen["add"]({ -- models/free-market.can:1413
			["type"] = "frame", -- models/free-market.can:1413
			["name"] = "FM_sell_prices_frame", -- models/free-market.can:1413
			["style"] = "borderless_frame", -- models/free-market.can:1413
			["direction"] = direction -- models/free-market.can:1413
		}) -- models/free-market.can:1413
		main_frame["location"] = location or { -- models/free-market.can:1414
			["x"] = player["display_resolution"]["width"] - 752, -- models/free-market.can:1414
			["y"] = 272 -- models/free-market.can:1414
		} -- models/free-market.can:1414
		create_price_notification_handler(main_frame, "FM_switch_sell_prices_gui", is_vertical) -- models/free-market.can:1415
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1416
			["type"] = "frame", -- models/free-market.can:1416
			["name"] = "FM_prices_flow", -- models/free-market.can:1416
			["style"] = "FM_prices_frame", -- models/free-market.can:1416
			["direction"] = "vertical" -- models/free-market.can:1416
		}) -- models/free-market.can:1416
		prices_flow["add"]({ -- models/free-market.can:1417
			["type"] = "table", -- models/free-market.can:1417
			["name"] = "FM_prices_table", -- models/free-market.can:1417
			["style"] = "FM_prices_table", -- models/free-market.can:1417
			["column_count"] = column_count -- models/free-market.can:1417
		}) -- models/free-market.can:1417
	end -- models/free-market.can:1417
end -- models/free-market.can:1417
local function switch_buy_prices_gui(player, location) -- models/free-market.can:1423
	local screen = player["gui"]["screen"] -- models/free-market.can:1424
	local main_frame = screen["FM_buy_prices_frame"] -- models/free-market.can:1425
	if main_frame then -- models/free-market.can:1426
		local children = main_frame["children"] -- models/free-market.can:1427
		if # children > 1 then -- models/free-market.can:1428
			children[2]["destroy"]() -- models/free-market.can:1429
			return  -- models/free-market.can:1430
		else -- models/free-market.can:1430
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1432
				["type"] = "frame", -- models/free-market.can:1432
				["name"] = "FM_prices_flow", -- models/free-market.can:1432
				["style"] = "FM_prices_frame", -- models/free-market.can:1432
				["direction"] = "vertical" -- models/free-market.can:1432
			}) -- models/free-market.can:1432
			local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1433
			prices_flow["add"]({ -- models/free-market.can:1434
				["type"] = "table", -- models/free-market.can:1434
				["name"] = "FM_prices_table", -- models/free-market.can:1434
				["style"] = "FM_prices_table", -- models/free-market.can:1434
				["column_count"] = column_count -- models/free-market.can:1434
			}) -- models/free-market.can:1434
		end -- models/free-market.can:1434
	else -- models/free-market.can:1434
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1444
		local is_vertical = (column_count == 2) -- models/free-market.can:1445
		if is_vertical then -- models/free-market.can:1446
			direction = "vertical" -- models/free-market.can:1447
		else -- models/free-market.can:1447
			direction = "horizontal" -- models/free-market.can:1449
		end -- models/free-market.can:1449
		main_frame = screen["add"]({ -- models/free-market.can:1451
			["type"] = "frame", -- models/free-market.can:1451
			["name"] = "FM_buy_prices_frame", -- models/free-market.can:1451
			["style"] = "borderless_frame", -- models/free-market.can:1451
			["direction"] = direction -- models/free-market.can:1451
		}) -- models/free-market.can:1451
		main_frame["location"] = location or { -- models/free-market.can:1452
			["x"] = player["display_resolution"]["width"] - 712, -- models/free-market.can:1452
			["y"] = 272 -- models/free-market.can:1452
		} -- models/free-market.can:1452
		create_price_notification_handler(main_frame, "FM_switch_buy_prices_gui", is_vertical) -- models/free-market.can:1453
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1454
			["type"] = "frame", -- models/free-market.can:1454
			["name"] = "FM_prices_flow", -- models/free-market.can:1454
			["style"] = "FM_prices_frame", -- models/free-market.can:1454
			["direction"] = "vertical" -- models/free-market.can:1454
		}) -- models/free-market.can:1454
		prices_flow["add"]({ -- models/free-market.can:1455
			["type"] = "table", -- models/free-market.can:1455
			["name"] = "FM_prices_table", -- models/free-market.can:1455
			["style"] = "FM_prices_table", -- models/free-market.can:1455
			["column_count"] = column_count -- models/free-market.can:1455
		}) -- models/free-market.can:1455
	end -- models/free-market.can:1455
end -- models/free-market.can:1455
local function open_embargo_gui(player) -- models/free-market.can:1460
	local screen = player["gui"]["screen"] -- models/free-market.can:1461
	if screen["FM_embargo_frame"] then -- models/free-market.can:1462
		screen["FM_embargo_frame"]["destroy"]() -- models/free-market.can:1463
		return  -- models/free-market.can:1464
	end -- models/free-market.can:1464
	local main_frame = screen["add"]({ -- models/free-market.can:1466
		["type"] = "frame", -- models/free-market.can:1466
		["name"] = "FM_embargo_frame", -- models/free-market.can:1466
		["direction"] = "vertical" -- models/free-market.can:1466
	}) -- models/free-market.can:1466
	main_frame["style"]["minimal_width"] = 340 -- models/free-market.can:1467
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1468
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1469
	flow["add"]({ -- models/free-market.can:1470
		["type"] = "label", -- models/free-market.can:1471
		["style"] = "frame_title", -- models/free-market.can:1472
		["caption"] = { "free-market.embargo-gui" }, -- models/free-market.can:1473
		["ignored_by_interaction"] = true -- models/free-market.can:1474
	}) -- models/free-market.can:1474
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1476
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1477
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1479
		["type"] = "frame", -- models/free-market.can:1479
		["name"] = "shallow_frame", -- models/free-market.can:1479
		["style"] = "inside_shallow_frame" -- models/free-market.can:1479
	}) -- models/free-market.can:1479
	local embargo_table = shallow_frame["add"]({ -- models/free-market.can:1480
		["type"] = "table", -- models/free-market.can:1480
		["name"] = "embargo_table", -- models/free-market.can:1480
		["column_count"] = 3 -- models/free-market.can:1480
	}) -- models/free-market.can:1480
	embargo_table["style"]["horizontally_stretchable"] = true -- models/free-market.can:1481
	embargo_table["style"]["vertically_stretchable"] = true -- models/free-market.can:1482
	embargo_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1483
	embargo_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1484
	embargo_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1485
	update_embargo_table(embargo_table, player) -- models/free-market.can:1487
	main_frame["force_auto_center"]() -- models/free-market.can:1488
end -- models/free-market.can:1488
local function set_transfer_box_data(item_name, player, entity) -- models/free-market.can:1494
	local player_force = player["force"] -- models/free-market.can:1495
	local force_index = player_force["index"] -- models/free-market.can:1496
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:1497
	if f_transfer_boxes[item_name] == nil then -- models/free-market.can:1498
		local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1499
		local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1500
		if inactive_sell_price then -- models/free-market.can:1501
			sell_prices[force_index][item_name] = inactive_sell_price -- models/free-market.can:1502
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1503
			notify_sell_price(force_index, item_name, inactive_sell_price) -- models/free-market.can:1504
		end -- models/free-market.can:1504
		f_transfer_boxes[item_name] = {} -- models/free-market.can:1506
	end -- models/free-market.can:1506
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:1508
	entities[# entities + 1] = entity -- models/free-market.can:1509
	local sprite_data = { -- models/free-market.can:1510
		["sprite"] = "FM_transfer", -- models/free-market.can:1511
		["target"] = entity, -- models/free-market.can:1512
		["surface"] = entity["surface"], -- models/free-market.can:1513
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1514
		["only_in_alt_mode"] = true, -- models/free-market.can:1515
		["x_scale"] = 0.4, -- models/free-market.can:1516
		["y_scale"] = 0.4 -- models/free-market.can:1516
	} -- models/free-market.can:1516
	if is_public_titles == false then -- models/free-market.can:1518
		sprite_data["forces"] = { player_force } -- models/free-market.can:1519
	end -- models/free-market.can:1519
	local id = draw_sprite(sprite_data) -- models/free-market.can:1522
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1523
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1525
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1528
		entity, -- models/free-market.can:1528
		id, -- models/free-market.can:1528
		4, -- models/free-market.can:1
		entities, -- models/free-market.can:1528
		item_name -- models/free-market.can:1528
	} -- models/free-market.can:1528
end -- models/free-market.can:1528
local function set_universal_transfer_box_data(player, entity) -- models/free-market.can:1533
	local player_force = player["force"] -- models/free-market.can:1534
	local force_index = player_force["index"] -- models/free-market.can:1535
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:1536
	entities[# entities + 1] = entity -- models/free-market.can:1537
	local sprite_data = { -- models/free-market.can:1538
		["sprite"] = "FM_universal_transfer", -- models/free-market.can:1539
		["target"] = entity, -- models/free-market.can:1540
		["surface"] = entity["surface"], -- models/free-market.can:1541
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1542
		["only_in_alt_mode"] = true, -- models/free-market.can:1543
		["x_scale"] = 0.4, -- models/free-market.can:1544
		["y_scale"] = 0.4 -- models/free-market.can:1544
	} -- models/free-market.can:1544
	if is_public_titles == false then -- models/free-market.can:1546
		sprite_data["forces"] = { player_force } -- models/free-market.can:1547
	end -- models/free-market.can:1547
	local id = draw_sprite(sprite_data) -- models/free-market.can:1550
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1553
		entity, -- models/free-market.can:1553
		id, -- models/free-market.can:1553
		5, -- models/free-market.can:1
		entities, -- models/free-market.can:1553
		nil -- models/free-market.can:1553
	} -- models/free-market.can:1553
end -- models/free-market.can:1553
local function set_bin_box_data(item_name, player, entity) -- models/free-market.can:1559
	local player_force = player["force"] -- models/free-market.can:1560
	local force_index = player_force["index"] -- models/free-market.can:1561
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:1562
	if f_bin_boxes[item_name] == nil then -- models/free-market.can:1563
		f_bin_boxes[item_name] = {} -- models/free-market.can:1564
	end -- models/free-market.can:1564
	local entities = f_bin_boxes[item_name] -- models/free-market.can:1566
	entities[# entities + 1] = entity -- models/free-market.can:1567
	local sprite_data = { -- models/free-market.can:1568
		["sprite"] = "FM_bin", -- models/free-market.can:1569
		["target"] = entity, -- models/free-market.can:1570
		["surface"] = entity["surface"], -- models/free-market.can:1571
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1572
		["only_in_alt_mode"] = true, -- models/free-market.can:1573
		["x_scale"] = 0.4, -- models/free-market.can:1574
		["y_scale"] = 0.4 -- models/free-market.can:1574
	} -- models/free-market.can:1574
	if is_public_titles == false then -- models/free-market.can:1576
		sprite_data["forces"] = { player_force } -- models/free-market.can:1577
	end -- models/free-market.can:1577
	local id = draw_sprite(sprite_data) -- models/free-market.can:1580
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1581
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1584
		entity, -- models/free-market.can:1584
		id, -- models/free-market.can:1584
		6, -- models/free-market.can:1
		entities, -- models/free-market.can:1584
		item_name -- models/free-market.can:1584
	} -- models/free-market.can:1584
end -- models/free-market.can:1584
local function set_universal_bin_box_data(player, entity) -- models/free-market.can:1589
	local player_force = player["force"] -- models/free-market.can:1590
	local force_index = player_force["index"] -- models/free-market.can:1591
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:1592
	entities[# entities + 1] = entity -- models/free-market.can:1593
	local sprite_data = { -- models/free-market.can:1594
		["sprite"] = "FM_universal_bin", -- models/free-market.can:1595
		["target"] = entity, -- models/free-market.can:1596
		["surface"] = entity["surface"], -- models/free-market.can:1597
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1598
		["only_in_alt_mode"] = true, -- models/free-market.can:1599
		["x_scale"] = 0.4, -- models/free-market.can:1600
		["y_scale"] = 0.4 -- models/free-market.can:1600
	} -- models/free-market.can:1600
	if is_public_titles == false then -- models/free-market.can:1602
		sprite_data["forces"] = { player_force } -- models/free-market.can:1603
	end -- models/free-market.can:1603
	local id = draw_sprite(sprite_data) -- models/free-market.can:1606
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1609
		entity, -- models/free-market.can:1609
		id, -- models/free-market.can:1609
		7, -- models/free-market.can:1
		entities, -- models/free-market.can:1609
		nil -- models/free-market.can:1609
	} -- models/free-market.can:1609
end -- models/free-market.can:1609
local function set_pull_box_data(item_name, player, entity) -- models/free-market.can:1615
	local player_force = player["force"] -- models/free-market.can:1616
	local force_index = player_force["index"] -- models/free-market.can:1617
	local force_pull_boxes = pull_boxes[force_index] -- models/free-market.can:1618
	force_pull_boxes[item_name] = force_pull_boxes[item_name] or {} -- models/free-market.can:1619
	local items = force_pull_boxes[item_name] -- models/free-market.can:1620
	items[# items + 1] = entity -- models/free-market.can:1621
	local sprite_data = { -- models/free-market.can:1622
		["sprite"] = "FM_pull_out", -- models/free-market.can:1623
		["target"] = entity, -- models/free-market.can:1624
		["surface"] = entity["surface"], -- models/free-market.can:1625
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1626
		["only_in_alt_mode"] = true, -- models/free-market.can:1627
		["x_scale"] = 0.4, -- models/free-market.can:1628
		["y_scale"] = 0.4 -- models/free-market.can:1628
	} -- models/free-market.can:1628
	if is_public_titles == false then -- models/free-market.can:1630
		sprite_data["forces"] = { player_force } -- models/free-market.can:1631
	end -- models/free-market.can:1631
	local id = draw_sprite(sprite_data) -- models/free-market.can:1634
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1635
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1637
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1640
		entity, -- models/free-market.can:1640
		id, -- models/free-market.can:1640
		3, -- models/free-market.can:1
		items, -- models/free-market.can:1640
		item_name -- models/free-market.can:1640
	} -- models/free-market.can:1640
end -- models/free-market.can:1640
local function set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:1647
	count = count or game["item_prototypes"][item_name]["stack_size"] -- models/free-market.can:1648
	local player_force = player["force"] -- models/free-market.can:1650
	local force_index = player_force["index"] -- models/free-market.can:1651
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:1652
	if f_buy_boxes[item_name] == nil then -- models/free-market.can:1653
		local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1654
		local inactive_buy_price = f_inactive_buy_prices[item_name] -- models/free-market.can:1655
		if inactive_buy_price then -- models/free-market.can:1656
			buy_prices[force_index][item_name] = inactive_buy_price -- models/free-market.can:1657
			f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1658
			notify_buy_price(force_index, item_name, inactive_buy_price) -- models/free-market.can:1659
		end -- models/free-market.can:1659
		f_buy_boxes[item_name] = {} -- models/free-market.can:1661
	end -- models/free-market.can:1661
	local items = f_buy_boxes[item_name] -- models/free-market.can:1663
	items[# items + 1] = { -- models/free-market.can:1664
		entity, -- models/free-market.can:1664
		count -- models/free-market.can:1664
	} -- models/free-market.can:1664
	local sprite_data = { -- models/free-market.can:1665
		["sprite"] = "FM_buy", -- models/free-market.can:1666
		["target"] = entity, -- models/free-market.can:1667
		["surface"] = entity["surface"], -- models/free-market.can:1668
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1669
		["only_in_alt_mode"] = true, -- models/free-market.can:1670
		["x_scale"] = 0.4, -- models/free-market.can:1671
		["y_scale"] = 0.4 -- models/free-market.can:1671
	} -- models/free-market.can:1671
	if is_public_titles == false then -- models/free-market.can:1673
		sprite_data["forces"] = { player_force } -- models/free-market.can:1674
	end -- models/free-market.can:1674
	local id = draw_sprite(sprite_data) -- models/free-market.can:1677
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1678
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1681
		entity, -- models/free-market.can:1681
		id, -- models/free-market.can:1681
		1, -- models/free-market.can:1
		items, -- models/free-market.can:1681
		item_name -- models/free-market.can:1681
	} -- models/free-market.can:1681
end -- models/free-market.can:1681
local function destroy_force_configuration(player) -- models/free-market.can:1685
	local frame = player["gui"]["screen"]["FM_force_configuration"] -- models/free-market.can:1686
	if frame then -- models/free-market.can:1687
		frame["destroy"]() -- models/free-market.can:1688
	end -- models/free-market.can:1688
end -- models/free-market.can:1688
local function open_force_configuration(player) -- models/free-market.can:1693
	local screen = player["gui"]["screen"] -- models/free-market.can:1694
	if screen["FM_force_configuration"] then -- models/free-market.can:1695
		screen["FM_force_configuration"]["destroy"]() -- models/free-market.can:1696
		return  -- models/free-market.can:1697
	end -- models/free-market.can:1697
	local is_player_admin = player["admin"] -- models/free-market.can:1700
	local force = player["force"] -- models/free-market.can:1701
	local main_frame = screen["add"]({ -- models/free-market.can:1703
		["type"] = "frame", -- models/free-market.can:1703
		["name"] = "FM_force_configuration", -- models/free-market.can:1703
		["direction"] = "vertical" -- models/free-market.can:1703
	}) -- models/free-market.can:1703
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1704
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1705
	flow["add"]({ -- models/free-market.can:1706
		["type"] = "label", -- models/free-market.can:1707
		["style"] = "frame_title", -- models/free-market.can:1708
		["caption"] = { "free-market.team-configuration" }, -- models/free-market.can:1709
		["ignored_by_interaction"] = true -- models/free-market.can:1710
	}) -- models/free-market.can:1710
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1712
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1713
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1714
		["type"] = "frame", -- models/free-market.can:1714
		["name"] = "shallow_frame", -- models/free-market.can:1714
		["style"] = "inside_shallow_frame", -- models/free-market.can:1714
		["direction"] = "vertical" -- models/free-market.can:1714
	}) -- models/free-market.can:1714
	local content = shallow_frame["add"]({ -- models/free-market.can:1715
		["type"] = "flow", -- models/free-market.can:1715
		["name"] = "content_flow", -- models/free-market.can:1715
		["direction"] = "vertical" -- models/free-market.can:1715
	}) -- models/free-market.can:1715
	content["style"]["padding"] = 12 -- models/free-market.can:1716
	if is_player_admin then -- models/free-market.can:1718
		local admin_row = content["add"](FLOW) -- models/free-market.can:1719
		admin_row["name"] = "admin_row" -- models/free-market.can:1720
		admin_row["add"](LABEL)["caption"] = { -- models/free-market.can:1721
			"", -- models/free-market.can:1721
			{ "gui-multiplayer-lobby.allow-commands-admins-only" }, -- models/free-market.can:1721
			COLON -- models/free-market.can:1721
		} -- models/free-market.can:1721
		admin_row["add"]({ -- models/free-market.can:1722
			["type"] = "button", -- models/free-market.can:1722
			["caption"] = { "free-market.print-force-data-button" }, -- models/free-market.can:1722
			["name"] = "FM_print_force_data" -- models/free-market.can:1722
		}) -- models/free-market.can:1722
		admin_row["add"]({ -- models/free-market.can:1723
			["type"] = "button", -- models/free-market.can:1723
			["caption"] = "Clear invalid data", -- models/free-market.can:1723
			["name"] = "FM_clear_invalid_data" -- models/free-market.can:1723
		}) -- models/free-market.can:1723
	end -- models/free-market.can:1723
	if is_reset_public or is_player_admin or # force["players"] == 1 then -- models/free-market.can:1726
		if is_player_admin then -- models/free-market.can:1727
			content["add"](LABEL)["caption"] = { -- models/free-market.can:1728
				"", -- models/free-market.can:1728
				"Attention", -- models/free-market.can:1728
				COLON, -- models/free-market.can:1728
				"reset is public" -- models/free-market.can:1728
			} -- models/free-market.can:1728
		end -- models/free-market.can:1728
		local reset_caption = { -- models/free-market.can:1730
			"", -- models/free-market.can:1730
			{ "free-market.reset-gui" }, -- models/free-market.can:1730
			COLON -- models/free-market.can:1730
		} -- models/free-market.can:1730
		local reset_prices_row = content["add"](FLOW) -- models/free-market.can:1731
		reset_prices_row["name"] = "reset_prices_row" -- models/free-market.can:1732
		reset_prices_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1733
		reset_prices_row["add"]({ -- models/free-market.can:1734
			["type"] = "button", -- models/free-market.can:1734
			["caption"] = { "free-market.reset-buy-prices" }, -- models/free-market.can:1734
			["name"] = "FM_reset_buy_prices" -- models/free-market.can:1734
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1734
		reset_prices_row["add"]({ -- models/free-market.can:1735
			["type"] = "button", -- models/free-market.can:1735
			["caption"] = { "free-market.reset-sell-prices" }, -- models/free-market.can:1735
			["name"] = "FM_reset_sell_prices" -- models/free-market.can:1735
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1735
		reset_prices_row["add"]({ -- models/free-market.can:1736
			["type"] = "button", -- models/free-market.can:1736
			["caption"] = { "free-market.reset-all-prices" }, -- models/free-market.can:1736
			["name"] = "FM_reset_all_prices" -- models/free-market.can:1736
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1736
		local reset_boxes_row = content["add"](FLOW) -- models/free-market.can:1738
		reset_boxes_row["name"] = "reset_boxes_row" -- models/free-market.can:1739
		reset_boxes_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1740
		reset_boxes_row["add"]({ -- models/free-market.can:1741
			["type"] = "button", -- models/free-market.can:1741
			["style"] = "FM_transfer_button", -- models/free-market.can:1741
			["name"] = "FM_reset_transfer_boxes" -- models/free-market.can:1741
		}) -- models/free-market.can:1741
		reset_boxes_row["add"]({ -- models/free-market.can:1742
			["type"] = "button", -- models/free-market.can:1742
			["style"] = "FM_universal_transfer_button", -- models/free-market.can:1742
			["name"] = "FM_reset_universal_transfer_boxes" -- models/free-market.can:1742
		}) -- models/free-market.can:1742
		reset_boxes_row["add"]({ -- models/free-market.can:1743
			["type"] = "button", -- models/free-market.can:1743
			["style"] = "FM_bin_button", -- models/free-market.can:1743
			["name"] = "FM_reset_bin_boxes" -- models/free-market.can:1743
		}) -- models/free-market.can:1743
		reset_boxes_row["add"]({ -- models/free-market.can:1744
			["type"] = "button", -- models/free-market.can:1744
			["style"] = "FM_universal_bin_button", -- models/free-market.can:1744
			["name"] = "FM_reset_universal_bin_boxes" -- models/free-market.can:1744
		}) -- models/free-market.can:1744
		reset_boxes_row["add"]({ -- models/free-market.can:1745
			["type"] = "button", -- models/free-market.can:1745
			["style"] = "FM_pull_out_button", -- models/free-market.can:1745
			["name"] = "FM_reset_pull_boxes" -- models/free-market.can:1745
		}) -- models/free-market.can:1745
		reset_boxes_row["add"]({ -- models/free-market.can:1746
			["type"] = "button", -- models/free-market.can:1746
			["style"] = "FM_buy_button", -- models/free-market.can:1746
			["name"] = "FM_reset_buy_boxes" -- models/free-market.can:1746
		}) -- models/free-market.can:1746
		reset_boxes_row["add"]({ -- models/free-market.can:1747
			["type"] = "button", -- models/free-market.can:1747
			["caption"] = { "free-market.reset-all-types" }, -- models/free-market.can:1747
			["name"] = "FM_reset_all_boxes" -- models/free-market.can:1747
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1747
	end -- models/free-market.can:1747
	local setting_row = content["add"](FLOW) -- models/free-market.can:1750
	setting_row["style"]["vertical_align"] = "center" -- models/free-market.can:1751
	setting_row["add"](LABEL)["caption"] = { -- models/free-market.can:1752
		"", -- models/free-market.can:1752
		{ "free-market.default-storage-limit" }, -- models/free-market.can:1752
		COLON -- models/free-market.can:1752
	} -- models/free-market.can:1752
	local default_limit_textfield = setting_row["add"](DEFAULT_LIMIT_TEXTFIELD) -- models/free-market.can:1753
	local default_limit = default_storage_limit[force["index"]] or max_storage_threshold -- models/free-market.can:1754
	default_limit_textfield["text"] = tostring(default_limit) -- models/free-market.can:1755
	setting_row["add"](CHECK_BUTTON)["name"] = "FM_confirm_default_limit" -- models/free-market.can:1756
	local label = content["add"](LABEL) -- models/free-market.can:1758
	label["caption"] = { -- models/free-market.can:1759
		"", -- models/free-market.can:1759
		{ "gui.credits" }, -- models/free-market.can:1759
		COLON -- models/free-market.can:1759
	} -- models/free-market.can:1759
	label["style"]["font"] = "heading-1" -- models/free-market.can:1760
	local translations_row = content["add"](FLOW) -- models/free-market.can:1761
	translations_row["add"](LABEL)["caption"] = { -- models/free-market.can:1762
		"", -- models/free-market.can:1762
		"Translations", -- models/free-market.can:1762
		COLON -- models/free-market.can:1762
	} -- models/free-market.can:1762
	local link = translations_row["add"]({ -- models/free-market.can:1763
		["type"] = "textfield", -- models/free-market.can:1763
		["text"] = "https://crowdin.com/project/factorio-mods-localization" -- models/free-market.can:1763
	}) -- models/free-market.can:1763
	link["style"]["horizontally_stretchable"] = true -- models/free-market.can:1764
	link["style"]["width"] = 320 -- models/free-market.can:1765
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1766
		"", -- models/free-market.can:1766
		"Translators", -- models/free-market.can:1766
		COLON, -- models/free-market.can:1766
		" ", -- models/free-market.can:1766
		"Eerrikki (Robin Braathen), eifel (Eifel87), zszzlzm (刘泽民), Spielen01231 (TheFakescribtx2), Drilzxx_ (Kévin), eifel (Eifel87), Felix_Manning (Felix Manning), ZwerOxotnik" -- models/free-market.can:1766
	} -- models/free-market.can:1766
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1767
		"", -- models/free-market.can:1767
		"Supporters", -- models/free-market.can:1767
		COLON, -- models/free-market.can:1767
		" ", -- models/free-market.can:1767
		"Eerrikki" -- models/free-market.can:1767
	} -- models/free-market.can:1767
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1768
		"", -- models/free-market.can:1768
		{ "gui-other-settings.developer" }, -- models/free-market.can:1768
		COLON, -- models/free-market.can:1768
		" ", -- models/free-market.can:1768
		"ZwerOxotnik" -- models/free-market.can:1768
	} -- models/free-market.can:1768
	local text_box = content["add"]({ ["type"] = "text-box" }) -- models/free-market.can:1769
	text_box["read_only"] = true -- models/free-market.can:1770
	text_box["text"] = "see-prices.png from https://www.svgrepo.com/svg/77065/price-tag\
" .. "change-price.png from https://www.svgrepo.com/svg/96982/price-tag\
" .. "embargo.png is modified version of https://www.svgrepo.com/svg/97012/price-tag" .. "Modified versions of https://www.svgrepo.com/svg/11042/shopping-cart-with-down-arrow-e-commerce-symbol" .. "Modified versions of https://www.svgrepo.com/svg/89258/rubbish-bin" -- models/free-market.can:1775
	text_box["style"]["maximal_width"] = 0 -- models/free-market.can:1776
	text_box["style"]["height"] = 70 -- models/free-market.can:1777
	text_box["style"]["horizontally_stretchable"] = true -- models/free-market.can:1778
	text_box["style"]["vertically_stretchable"] = true -- models/free-market.can:1779
	main_frame["force_auto_center"]() -- models/free-market.can:1781
end -- models/free-market.can:1781
local function switch_prices_gui(player, item_name) -- models/free-market.can:1786
	local screen = player["gui"]["screen"] -- models/free-market.can:1787
	local main_frame = screen["FM_prices_frame"] -- models/free-market.can:1788
	if main_frame then -- models/free-market.can:1789
		if item_name == nil then -- models/free-market.can:1790
			main_frame["destroy"]() -- models/free-market.can:1791
		else -- models/free-market.can:1791
			local content_flow = main_frame["shallow_frame"]["content_flow"] -- models/free-market.can:1793
			local item_row = main_frame["shallow_frame"]["content_flow"]["item_row"] -- models/free-market.can:1794
			item_row["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:1795
			local force_index = player["force"]["index"] -- models/free-market.can:1797
			local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1798
			if sell_price then -- models/free-market.can:1799
				item_row["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:1800
			end -- models/free-market.can:1800
			local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1802
			if buy_price then -- models/free-market.can:1803
				item_row["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:1804
			end -- models/free-market.can:1804
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:1806
		end -- models/free-market.can:1806
		return  -- models/free-market.can:1808
	end -- models/free-market.can:1808
	local force_index = player["force"]["index"] -- models/free-market.can:1811
	main_frame = screen["add"]({ -- models/free-market.can:1813
		["type"] = "frame", -- models/free-market.can:1813
		["name"] = "FM_prices_frame", -- models/free-market.can:1813
		["direction"] = "vertical" -- models/free-market.can:1813
	}) -- models/free-market.can:1813
	main_frame["location"] = { -- models/free-market.can:1814
		["x"] = 100 / player["display_scale"], -- models/free-market.can:1814
		["y"] = 50 -- models/free-market.can:1814
	} -- models/free-market.can:1814
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1815
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1816
	flow["add"]({ -- models/free-market.can:1817
		["type"] = "label", -- models/free-market.can:1818
		["style"] = "frame_title", -- models/free-market.can:1819
		["caption"] = { "free-market.prices" }, -- models/free-market.can:1820
		["ignored_by_interaction"] = true -- models/free-market.can:1821
	}) -- models/free-market.can:1821
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1823
	flow["add"]({ -- models/free-market.can:1824
		["type"] = "sprite-button", -- models/free-market.can:1825
		["style"] = "frame_action_button", -- models/free-market.can:1826
		["sprite"] = "refresh_white_icon", -- models/free-market.can:1827
		["name"] = "FM_refresh_prices_table" -- models/free-market.can:1828
	}) -- models/free-market.can:1828
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1830
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1831
		["type"] = "frame", -- models/free-market.can:1831
		["name"] = "shallow_frame", -- models/free-market.can:1831
		["style"] = "inside_shallow_frame", -- models/free-market.can:1831
		["direction"] = "vertical" -- models/free-market.can:1831
	}) -- models/free-market.can:1831
	local content = shallow_frame["add"]({ -- models/free-market.can:1832
		["type"] = "flow", -- models/free-market.can:1832
		["name"] = "content_flow", -- models/free-market.can:1832
		["direction"] = "vertical" -- models/free-market.can:1832
	}) -- models/free-market.can:1832
	content["style"]["padding"] = 12 -- models/free-market.can:1833
	local item_row = content["add"](FLOW) -- models/free-market.can:1835
	local add = item_row["add"] -- models/free-market.can:1836
	item_row["name"] = "item_row" -- models/free-market.can:1837
	item_row["style"]["vertical_align"] = "center" -- models/free-market.can:1838
	local item = add({ -- models/free-market.can:1839
		["type"] = "choose-elem-button", -- models/free-market.can:1839
		["name"] = "FM_prices_item", -- models/free-market.can:1839
		["elem_type"] = "item", -- models/free-market.can:1839
		["elem_filters"] = ITEM_FILTERS -- models/free-market.can:1839
	}) -- models/free-market.can:1839
	item["elem_value"] = item_name -- models/free-market.can:1840
	add(LABEL)["caption"] = { "free-market.buy-gui" } -- models/free-market.can:1841
	local buy_textfield = add(BUY_PRICE_TEXTFIELD) -- models/free-market.can:1842
	if item_name then -- models/free-market.can:1843
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1844
		if price then -- models/free-market.can:1845
			buy_textfield["text"] = tostring(price) -- models/free-market.can:1846
		end -- models/free-market.can:1846
	end -- models/free-market.can:1846
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price" -- models/free-market.can:1849
	add(LABEL)["caption"] = { "free-market.sell-gui" } -- models/free-market.can:1850
	local sell_textfield = add(SELL_PRICE_TEXTFIELD) -- models/free-market.can:1851
	if item_name then -- models/free-market.can:1852
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1853
		if price then -- models/free-market.can:1854
			sell_textfield["text"] = tostring(price) -- models/free-market.can:1855
		end -- models/free-market.can:1855
	end -- models/free-market.can:1855
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price" -- models/free-market.can:1858
	local storage_row = content["add"](FLOW) -- models/free-market.can:1860
	local add = storage_row["add"] -- models/free-market.can:1861
	storage_row["name"] = "storage_row" -- models/free-market.can:1862
	storage_row["style"]["vertical_align"] = "center" -- models/free-market.can:1863
	add(LABEL)["caption"] = { -- models/free-market.can:1864
		"", -- models/free-market.can:1864
		{ "description.storage" }, -- models/free-market.can:1864
		COLON -- models/free-market.can:1864
	} -- models/free-market.can:1864
	local storage_count = add(LABEL) -- models/free-market.can:1865
	storage_count["name"] = "storage_count" -- models/free-market.can:1866
	add(LABEL)["caption"] = "/" -- models/free-market.can:1867
	local storage_limit_textfield = add(STORAGE_LIMIT_TEXTFIELD) -- models/free-market.can:1868
	add(CHECK_BUTTON)["name"] = "FM_confirm_storage_limit" -- models/free-market.can:1869
	if item_name == nil then -- models/free-market.can:1870
		storage_row["visible"] = false -- models/free-market.can:1871
	else -- models/free-market.can:1871
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:1873
		storage_count["caption"] = tostring(count) -- models/free-market.can:1874
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:1875
		storage_limit_textfield["text"] = tostring(limit) -- models/free-market.can:1876
	end -- models/free-market.can:1876
	local prices_frame = content["add"]({ -- models/free-market.can:1879
		["type"] = "frame", -- models/free-market.can:1879
		["name"] = "other_prices_frame", -- models/free-market.can:1879
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1879
		["direction"] = "vertical" -- models/free-market.can:1879
	}) -- models/free-market.can:1879
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1880
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1881
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1882
		["type"] = "table", -- models/free-market.can:1882
		["name"] = "prices_table", -- models/free-market.can:1882
		["column_count"] = 3 -- models/free-market.can:1882
	}) -- models/free-market.can:1882
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1883
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1884
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:1885
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1886
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1887
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1888
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:1889
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:1890
	if item_name then -- models/free-market.can:1891
		update_prices_table(player, item_name, prices_table) -- models/free-market.can:1892
	else -- models/free-market.can:1892
		make_prices_header(prices_table) -- models/free-market.can:1894
	end -- models/free-market.can:1894
	return content -- models/free-market.can:1897
end -- models/free-market.can:1897
local function open_storage_gui(player) -- models/free-market.can:1900
	local screen = player["gui"]["screen"] -- models/free-market.can:1901
	local main_frame = screen["FM_storage_frame"] -- models/free-market.can:1902
	if main_frame then -- models/free-market.can:1903
		main_frame["destroy"]() -- models/free-market.can:1904
		return  -- models/free-market.can:1905
	end -- models/free-market.can:1905
	main_frame = screen["add"]({ -- models/free-market.can:1908
		["type"] = "frame", -- models/free-market.can:1908
		["name"] = "FM_storage_frame", -- models/free-market.can:1908
		["direction"] = "vertical" -- models/free-market.can:1908
	}) -- models/free-market.can:1908
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1909
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1910
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1911
	flow["add"]({ -- models/free-market.can:1912
		["type"] = "label", -- models/free-market.can:1913
		["style"] = "frame_title", -- models/free-market.can:1914
		["caption"] = { "description.storage" }, -- models/free-market.can:1915
		["ignored_by_interaction"] = true -- models/free-market.can:1916
	}) -- models/free-market.can:1916
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1918
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1919
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1920
		["type"] = "frame", -- models/free-market.can:1920
		["name"] = "shallow_frame", -- models/free-market.can:1920
		["style"] = "inside_shallow_frame", -- models/free-market.can:1920
		["direction"] = "vertical" -- models/free-market.can:1920
	}) -- models/free-market.can:1920
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1921
		["type"] = "flow", -- models/free-market.can:1921
		["name"] = "content_flow", -- models/free-market.can:1921
		["direction"] = "vertical" -- models/free-market.can:1921
	}) -- models/free-market.can:1921
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1922
	local scroll_pane = content_flow["add"](SCROLL_PANE) -- models/free-market.can:1924
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1925
	local storage_table = scroll_pane["add"]({ -- models/free-market.can:1926
		["type"] = "table", -- models/free-market.can:1926
		["name"] = "FM_storage_table", -- models/free-market.can:1926
		["column_count"] = 2 -- models/free-market.can:1926
	}) -- models/free-market.can:1926
	storage_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1927
	storage_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1928
	storage_table["style"]["top_margin"] = - 16 -- models/free-market.can:1929
	storage_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1930
	storage_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1931
	storage_table["draw_horizontal_lines"] = true -- models/free-market.can:1932
	storage_table["draw_vertical_lines"] = true -- models/free-market.can:1933
	make_storage_header(storage_table) -- models/free-market.can:1934
	local add = storage_table["add"] -- models/free-market.can:1936
	for item_name, count in pairs(storages[player["force"]["index"]]) do -- models/free-market.can:1937
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1938
		add(LABEL)["caption"] = tostring(count) -- models/free-market.can:1939
	end -- models/free-market.can:1939
	main_frame["force_auto_center"]() -- models/free-market.can:1942
end -- models/free-market.can:1942
local function open_price_list_gui(player) -- models/free-market.can:1945
	local screen = player["gui"]["screen"] -- models/free-market.can:1946
	if screen["FM_price_list_frame"] then -- models/free-market.can:1947
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1948
		return  -- models/free-market.can:1949
	end -- models/free-market.can:1949
	local main_frame = screen["add"]({ -- models/free-market.can:1951
		["type"] = "frame", -- models/free-market.can:1951
		["name"] = "FM_price_list_frame", -- models/free-market.can:1951
		["direction"] = "vertical" -- models/free-market.can:1951
	}) -- models/free-market.can:1951
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1952
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1953
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1954
	flow["add"]({ -- models/free-market.can:1955
		["type"] = "label", -- models/free-market.can:1956
		["style"] = "frame_title", -- models/free-market.can:1957
		["caption"] = { "free-market.price-list" }, -- models/free-market.can:1958
		["ignored_by_interaction"] = true -- models/free-market.can:1959
	}) -- models/free-market.can:1959
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1961
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1962
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1963
		["type"] = "frame", -- models/free-market.can:1963
		["name"] = "shallow_frame", -- models/free-market.can:1963
		["style"] = "inside_shallow_frame", -- models/free-market.can:1963
		["direction"] = "vertical" -- models/free-market.can:1963
	}) -- models/free-market.can:1963
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1964
		["type"] = "flow", -- models/free-market.can:1964
		["name"] = "content_flow", -- models/free-market.can:1964
		["direction"] = "vertical" -- models/free-market.can:1964
	}) -- models/free-market.can:1964
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1965
	local team_row = content_flow["add"](FLOW) -- models/free-market.can:1967
	team_row["name"] = "team_row" -- models/free-market.can:1968
	team_row["add"](LABEL)["caption"] = { -- models/free-market.can:1969
		"", -- models/free-market.can:1969
		{ "team" }, -- models/free-market.can:1969
		COLON -- models/free-market.can:1969
	} -- models/free-market.can:1969
	local items = {} -- models/free-market.can:1970
	local size = 0 -- models/free-market.can:1971
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1972
		local force_index = force["index"] -- models/free-market.can:1973
		local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1974
		local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1975
		if (f_sell_prices and next(f_sell_prices)) or (f_buy_prices and next(f_buy_prices)) then -- models/free-market.can:1976
			size = size + 1 -- models/free-market.can:1977
			items[size] = force_name -- models/free-market.can:1978
		end -- models/free-market.can:1978
	end -- models/free-market.can:1978
	team_row["add"]({ -- models/free-market.can:1981
		["type"] = "drop-down", -- models/free-market.can:1981
		["name"] = "FM_force_price_list", -- models/free-market.can:1981
		["items"] = items -- models/free-market.can:1981
	}) -- models/free-market.can:1981
	local search_row = content_flow["add"]({ -- models/free-market.can:1983
		["type"] = "table", -- models/free-market.can:1983
		["name"] = "search_row", -- models/free-market.can:1983
		["column_count"] = 4 -- models/free-market.can:1983
	}) -- models/free-market.can:1983
	search_row["add"]({ -- models/free-market.can:1984
		["type"] = "textfield", -- models/free-market.can:1984
		["name"] = "FM_search_text" -- models/free-market.can:1984
	}) -- models/free-market.can:1984
	search_row["add"](LABEL)["caption"] = { -- models/free-market.can:1985
		"", -- models/free-market.can:1985
		{ "gui.search" }, -- models/free-market.can:1985
		COLON -- models/free-market.can:1985
	} -- models/free-market.can:1985
	search_row["add"]({ -- models/free-market.can:1986
		["type"] = "drop-down", -- models/free-market.can:1987
		["name"] = "FM_search_price_drop_down", -- models/free-market.can:1988
		["items"] = { -- models/free-market.can:1989
			{ "free-market.sell-offer-gui" }, -- models/free-market.can:1989
			{ "free-market.buy-request-gui" } -- models/free-market.can:1989
		} -- models/free-market.can:1989
	}) -- models/free-market.can:1989
	search_row["add"]({ -- models/free-market.can:1991
		["type"] = "sprite-button", -- models/free-market.can:1992
		["style"] = "frame_action_button", -- models/free-market.can:1993
		["name"] = "FM_search_by_price", -- models/free-market.can:1994
		["hovered_sprite"] = "utility/search_black", -- models/free-market.can:1995
		["clicked_sprite"] = "utility/search_black", -- models/free-market.can:1996
		["sprite"] = "utility/search_white" -- models/free-market.can:1997
	}) -- models/free-market.can:1997
	local prices_frame = content_flow["add"]({ -- models/free-market.can:2000
		["type"] = "frame", -- models/free-market.can:2000
		["name"] = "deep_frame", -- models/free-market.can:2000
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:2000
		["direction"] = "vertical" -- models/free-market.can:2000
	}) -- models/free-market.can:2000
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:2001
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:2002
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:2003
		["type"] = "table", -- models/free-market.can:2003
		["name"] = "price_list_table", -- models/free-market.can:2003
		["column_count"] = 3 -- models/free-market.can:2003
	}) -- models/free-market.can:2003
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2004
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2005
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2006
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2007
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2008
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2009
	prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2010
	prices_table["style"]["column_alignments"][5] = "center" -- models/free-market.can:2011
	prices_table["style"]["column_alignments"][6] = "center" -- models/free-market.can:2012
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2013
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:2014
	make_price_list_header(prices_table) -- models/free-market.can:2015
	local short_prices_table = scroll_pane["add"]({ -- models/free-market.can:2017
		["type"] = "table", -- models/free-market.can:2017
		["name"] = "short_price_list_table", -- models/free-market.can:2017
		["column_count"] = 2 -- models/free-market.can:2017
	}) -- models/free-market.can:2017
	short_prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2018
	short_prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2019
	short_prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2020
	short_prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2021
	short_prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2022
	short_prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2023
	short_prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2024
	short_prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2025
	short_prices_table["draw_vertical_lines"] = true -- models/free-market.can:2026
	short_prices_table["visible"] = false -- models/free-market.can:2027
	main_frame["force_auto_center"]() -- models/free-market.can:2029
end -- models/free-market.can:2029
local function open_buy_box_gui(player, is_new, entity) -- models/free-market.can:2035
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2036
	box_operations["clear"]() -- models/free-market.can:2037
	if box_operations["buy_content"] and not is_new then -- models/free-market.can:2038
		return  -- models/free-market.can:2039
	end -- models/free-market.can:2039
	local row = box_operations["add"]({ -- models/free-market.can:2042
		["type"] = "table", -- models/free-market.can:2042
		["name"] = "buy_content", -- models/free-market.can:2042
		["column_count"] = 4 -- models/free-market.can:2042
	}) -- models/free-market.can:2042
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2043
	row["add"]({ -- models/free-market.can:2044
		["type"] = "label", -- models/free-market.can:2044
		["caption"] = { -- models/free-market.can:2044
			"", -- models/free-market.can:2044
			{ "free-market.count-gui" }, -- models/free-market.can:2044
			COLON -- models/free-market.can:2044
		} -- models/free-market.can:2044
	}) -- models/free-market.can:2044
	local count_element = row["add"]({ -- models/free-market.can:2045
		["type"] = "textfield", -- models/free-market.can:2045
		["name"] = "count", -- models/free-market.can:2045
		["numeric"] = true, -- models/free-market.can:2045
		["allow_decimal"] = false, -- models/free-market.can:2045
		["allow_negative"] = false -- models/free-market.can:2045
	}) -- models/free-market.can:2045
	count_element["style"]["width"] = 70 -- models/free-market.can:2046
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2047
	if is_new then -- models/free-market.can:2048
		confirm_button["name"] = "FM_confirm_buy_box" -- models/free-market.can:2049
	else -- models/free-market.can:2049
		confirm_button["name"] = "FM_change_buy_box" -- models/free-market.can:2051
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2052
		local entities_data = box_data[4] -- models/free-market.can:2053
		for i = 1, # entities_data do -- models/free-market.can:2054
			local buy_box = entities_data[i] -- models/free-market.can:2055
			if buy_box[1] == entity then -- models/free-market.can:2056
				count_element["text"] = tostring(buy_box[2]) -- models/free-market.can:2057
				break -- models/free-market.can:2058
			end -- models/free-market.can:2058
		end -- models/free-market.can:2058
		local item_name = box_data[5] -- models/free-market.can:2061
		FM_item["elem_value"] = item_name -- models/free-market.can:2062
	end -- models/free-market.can:2062
end -- models/free-market.can:2062
local function clear_boxes_gui(player) -- models/free-market.can:2066
	open_box[player["index"]] = nil -- models/free-market.can:2067
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:2068
end -- models/free-market.can:2068
local function open_transfer_box_gui(player, is_new, entity) -- models/free-market.can:2074
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2075
	box_operations["clear"]() -- models/free-market.can:2076
	if box_operations["transfer_content"] and not is_new then -- models/free-market.can:2077
		return  -- models/free-market.can:2078
	end -- models/free-market.can:2078
	local row = box_operations["add"]({ -- models/free-market.can:2081
		["type"] = "table", -- models/free-market.can:2081
		["name"] = "transfer_content", -- models/free-market.can:2081
		["column_count"] = 2 -- models/free-market.can:2081
	}) -- models/free-market.can:2081
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2082
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2083
	if is_new then -- models/free-market.can:2084
		confirm_button["name"] = "FM_confirm_transfer_box" -- models/free-market.can:2085
	else -- models/free-market.can:2085
		confirm_button["name"] = "FM_change_transfer_box" -- models/free-market.can:2087
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2088
	end -- models/free-market.can:2088
end -- models/free-market.can:2088
local function open_bin_box_gui(player, is_new, entity) -- models/free-market.can:2095
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2096
	box_operations["clear"]() -- models/free-market.can:2097
	if box_operations["bin_content"] and not is_new then -- models/free-market.can:2098
		return  -- models/free-market.can:2099
	end -- models/free-market.can:2099
	local row = box_operations["add"]({ -- models/free-market.can:2102
		["type"] = "table", -- models/free-market.can:2102
		["name"] = "bin_content", -- models/free-market.can:2102
		["column_count"] = 2 -- models/free-market.can:2102
	}) -- models/free-market.can:2102
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2103
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2104
	if is_new then -- models/free-market.can:2105
		confirm_button["name"] = "FM_confirm_bin_box" -- models/free-market.can:2106
	else -- models/free-market.can:2106
		confirm_button["name"] = "FM_change_bin_box" -- models/free-market.can:2108
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2109
	end -- models/free-market.can:2109
end -- models/free-market.can:2109
local function create_top_relative_gui(player) -- models/free-market.can:2113
	local relative = player["gui"]["relative"] -- models/free-market.can:2114
	local main_frame = relative["FM_boxes_frame"] -- models/free-market.can:2115
	if main_frame then -- models/free-market.can:2116
		main_frame["destroy"]() -- models/free-market.can:2117
	end -- models/free-market.can:2117
	local boxes_anchor = { -- models/free-market.can:2120
		["gui"] = defines["relative_gui_type"]["container_gui"], -- models/free-market.can:2120
		["position"] = defines["relative_gui_position"]["top"] -- models/free-market.can:2120
	} -- models/free-market.can:2120
	main_frame = relative["add"]({ -- models/free-market.can:2121
		["type"] = "frame", -- models/free-market.can:2121
		["name"] = "FM_boxes_frame", -- models/free-market.can:2121
		["anchor"] = boxes_anchor -- models/free-market.can:2121
	}) -- models/free-market.can:2121
	main_frame["style"]["vertical_align"] = "center" -- models/free-market.can:2122
	main_frame["style"]["horizontally_stretchable"] = false -- models/free-market.can:2123
	main_frame["style"]["bottom_margin"] = - 14 -- models/free-market.can:2124
	local frame = main_frame["add"]({ -- models/free-market.can:2125
		["type"] = "frame", -- models/free-market.can:2125
		["name"] = "content", -- models/free-market.can:2125
		["style"] = "inside_shallow_frame" -- models/free-market.can:2125
	}) -- models/free-market.can:2125
	local main_flow = frame["add"]({ -- models/free-market.can:2126
		["type"] = "flow", -- models/free-market.can:2126
		["name"] = "main_flow", -- models/free-market.can:2126
		["direction"] = "vertical" -- models/free-market.can:2126
	}) -- models/free-market.can:2126
	main_flow["style"]["vertical_spacing"] = 0 -- models/free-market.can:2127
	main_flow["add"](FLOW)["name"] = "box_operations" -- models/free-market.can:2128
	local flow = main_flow["add"](FLOW) -- models/free-market.can:2129
	flow["add"]({ -- models/free-market.can:2130
		["type"] = "button", -- models/free-market.can:2130
		["style"] = "FM_transfer_button", -- models/free-market.can:2130
		["name"] = "FM_set_transfer_box" -- models/free-market.can:2130
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2130
	flow["add"]({ -- models/free-market.can:2131
		["type"] = "button", -- models/free-market.can:2131
		["style"] = "FM_universal_transfer_button", -- models/free-market.can:2131
		["name"] = "FM_set_universal_transfer_box" -- models/free-market.can:2131
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2131
	flow["add"]({ -- models/free-market.can:2132
		["type"] = "button", -- models/free-market.can:2132
		["style"] = "FM_bin_button", -- models/free-market.can:2132
		["name"] = "FM_set_bin_box" -- models/free-market.can:2132
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2132
	flow["add"]({ -- models/free-market.can:2133
		["type"] = "button", -- models/free-market.can:2133
		["style"] = "FM_universal_bin_button", -- models/free-market.can:2133
		["name"] = "FM_set_universal_bin_box" -- models/free-market.can:2133
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2133
	flow["add"]({ -- models/free-market.can:2134
		["type"] = "button", -- models/free-market.can:2134
		["style"] = "FM_pull_out_button", -- models/free-market.can:2134
		["name"] = "FM_set_pull_box" -- models/free-market.can:2134
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2134
	flow["add"]({ -- models/free-market.can:2135
		["type"] = "button", -- models/free-market.can:2135
		["style"] = "FM_buy_button", -- models/free-market.can:2135
		["name"] = "FM_set_buy_box" -- models/free-market.can:2135
	}) -- models/free-market.can:2135
end -- models/free-market.can:2135
local function open_pull_box_gui(player, is_new, entity) -- models/free-market.can:2141
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2142
	box_operations["clear"]() -- models/free-market.can:2143
	if box_operations["pull_content"] then -- models/free-market.can:2144
		return  -- models/free-market.can:2145
	end -- models/free-market.can:2145
	local row = box_operations["add"]({ -- models/free-market.can:2147
		["type"] = "table", -- models/free-market.can:2147
		["name"] = "pull_content", -- models/free-market.can:2147
		["column_count"] = 2 -- models/free-market.can:2147
	}) -- models/free-market.can:2147
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2148
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2149
	if is_new then -- models/free-market.can:2150
		confirm_button["name"] = "FM_confirm_pull_box" -- models/free-market.can:2151
	else -- models/free-market.can:2151
		confirm_button["name"] = "FM_change_pull_box" -- models/free-market.can:2153
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2154
	end -- models/free-market.can:2154
end -- models/free-market.can:2154
local function create_left_relative_gui(player) -- models/free-market.can:2158
	local relative = player["gui"]["relative"] -- models/free-market.can:2159
	local main_table = relative["FM_buttons"] -- models/free-market.can:2160
	if main_table then -- models/free-market.can:2161
		main_table["destroy"]() -- models/free-market.can:2162
	end -- models/free-market.can:2162
	local left_anchor = { -- models/free-market.can:2165
		["gui"] = defines["relative_gui_type"]["controller_gui"], -- models/free-market.can:2165
		["position"] = defines["relative_gui_position"]["left"] -- models/free-market.can:2165
	} -- models/free-market.can:2165
	main_table = relative["add"]({ -- models/free-market.can:2166
		["type"] = "table", -- models/free-market.can:2166
		["name"] = "FM_buttons", -- models/free-market.can:2166
		["anchor"] = left_anchor, -- models/free-market.can:2166
		["column_count"] = 2 -- models/free-market.can:2166
	}) -- models/free-market.can:2166
	main_table["style"]["vertical_align"] = "center" -- models/free-market.can:2167
	main_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2168
	main_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2169
	local button = main_table["add"]({ -- models/free-market.can:2171
		["type"] = "button", -- models/free-market.can:2171
		["style"] = "side_menu_button", -- models/free-market.can:2171
		["caption"] = ">", -- models/free-market.can:2171
		["name"] = "FM_hide_left_buttons" -- models/free-market.can:2171
	}) -- models/free-market.can:2171
	button["style"]["font"] = "default-dialog-button" -- models/free-market.can:2172
	button["style"]["font_color"] = WHITE_COLOR -- models/free-market.can:2173
	button["style"]["top_padding"] = - 4 -- models/free-market.can:2174
	button["style"]["width"] = 18 -- models/free-market.can:2175
	button["style"]["height"] = 20 -- models/free-market.can:2176
	local frame = main_table["add"]({ -- models/free-market.can:2178
		["type"] = "frame", -- models/free-market.can:2178
		["name"] = "content" -- models/free-market.can:2178
	}) -- models/free-market.can:2178
	frame["style"]["right_margin"] = - 14 -- models/free-market.can:2179
	local shallow_frame = frame["add"]({ -- models/free-market.can:2180
		["type"] = "frame", -- models/free-market.can:2180
		["name"] = "shallow_frame", -- models/free-market.can:2180
		["style"] = "inside_shallow_frame" -- models/free-market.can:2180
	}) -- models/free-market.can:2180
	local buttons_table = shallow_frame["add"]({ -- models/free-market.can:2181
		["type"] = "table", -- models/free-market.can:2181
		["column_count"] = 3 -- models/free-market.can:2181
	}) -- models/free-market.can:2181
	buttons_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2182
	buttons_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2183
	buttons_table["add"]({ -- models/free-market.can:2184
		["type"] = "sprite-button", -- models/free-market.can:2184
		["sprite"] = "FM_change-price", -- models/free-market.can:2184
		["style"] = "slot_button", -- models/free-market.can:2184
		["name"] = "FM_open_price" -- models/free-market.can:2184
	}) -- models/free-market.can:2184
	buttons_table["add"]({ -- models/free-market.can:2185
		["type"] = "sprite-button", -- models/free-market.can:2185
		["sprite"] = "FM_see-prices", -- models/free-market.can:2185
		["style"] = "slot_button", -- models/free-market.can:2185
		["name"] = "FM_open_price_list" -- models/free-market.can:2185
	}) -- models/free-market.can:2185
	buttons_table["add"]({ -- models/free-market.can:2186
		["type"] = "sprite-button", -- models/free-market.can:2186
		["sprite"] = "FM_embargo", -- models/free-market.can:2186
		["style"] = "slot_button", -- models/free-market.can:2186
		["name"] = "FM_open_embargo" -- models/free-market.can:2186
	}) -- models/free-market.can:2186
	buttons_table["add"]({ -- models/free-market.can:2187
		["type"] = "sprite-button", -- models/free-market.can:2187
		["sprite"] = "item/wooden-chest", -- models/free-market.can:2187
		["style"] = "slot_button", -- models/free-market.can:2187
		["name"] = "FM_open_storage" -- models/free-market.can:2187
	}) -- models/free-market.can:2187
	buttons_table["add"]({ -- models/free-market.can:2188
		["type"] = "sprite-button", -- models/free-market.can:2188
		["sprite"] = "virtual-signal/signal-info", -- models/free-market.can:2188
		["style"] = "slot_button", -- models/free-market.can:2188
		["name"] = "FM_show_hint" -- models/free-market.can:2188
	}) -- models/free-market.can:2188
	buttons_table["add"]({ -- models/free-market.can:2189
		["type"] = "sprite-button", -- models/free-market.can:2190
		["sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2191
		["hovered_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2192
		["clicked_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2193
		["style"] = "slot_button", -- models/free-market.can:2194
		["name"] = "FM_open_force_configuration" -- models/free-market.can:2195
	}) -- models/free-market.can:2195
end -- models/free-market.can:2195
local function check_buy_price(player, item_name) -- models/free-market.can:2201
	local force_index = player["force"]["index"] -- models/free-market.can:2202
	if buy_prices[force_index][item_name] == nil then -- models/free-market.can:2203
		local screen = player["gui"]["screen"] -- models/free-market.can:2204
		local prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2205
		local content_flow -- models/free-market.can:2206
		if prices_frame == nil then -- models/free-market.can:2207
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2208
			prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2209
		else -- models/free-market.can:2209
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2211
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2212
			local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2213
			if sell_price then -- models/free-market.can:2214
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:2215
			end -- models/free-market.can:2215
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2217
		end -- models/free-market.can:2217
		content_flow["item_row"]["buy_price"]["focus"]() -- models/free-market.can:2219
	end -- models/free-market.can:2219
end -- models/free-market.can:2219
local function check_sell_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2226
	local force_index = player["force"]["index"] -- models/free-market.can:2227
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2228
	if sell_price then -- models/free-market.can:2229
		return  -- models/free-market.can:2229
	end -- models/free-market.can:2229
	local row = gui["add"]({ -- models/free-market.can:2231
		["type"] = "table", -- models/free-market.can:2231
		["name"] = "sell_price_table", -- models/free-market.can:2231
		["column_count"] = 4 -- models/free-market.can:2231
	}) -- models/free-market.can:2231
	local add = row["add"] -- models/free-market.can:2232
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2233
	add(LABEL)["caption"] = { -- models/free-market.can:2234
		"", -- models/free-market.can:2234
		{ "free-market.sell-price-label" }, -- models/free-market.can:2234
		COLON -- models/free-market.can:2234
	} -- models/free-market.can:2234
	add(SELL_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2235
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price_for_chest" -- models/free-market.can:2236
end -- models/free-market.can:2236
local function check_buy_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2242
	local force_index = player["force"]["index"] -- models/free-market.can:2243
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2244
	if buy_price then -- models/free-market.can:2245
		return  -- models/free-market.can:2245
	end -- models/free-market.can:2245
	local row = gui["add"]({ -- models/free-market.can:2247
		["type"] = "table", -- models/free-market.can:2247
		["name"] = "buy_price_table", -- models/free-market.can:2247
		["column_count"] = 4 -- models/free-market.can:2247
	}) -- models/free-market.can:2247
	local add = row["add"] -- models/free-market.can:2248
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2249
	add(LABEL)["caption"] = { -- models/free-market.can:2250
		"", -- models/free-market.can:2250
		{ "free-market.buy-price-label" }, -- models/free-market.can:2250
		COLON -- models/free-market.can:2250
	} -- models/free-market.can:2250
	add(BUY_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2251
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price_for_chest" -- models/free-market.can:2252
end -- models/free-market.can:2252
local function check_sell_price(player, item_name) -- models/free-market.can:2257
	local force_index = player["force"]["index"] -- models/free-market.can:2258
	if sell_prices[force_index][item_name] == nil then -- models/free-market.can:2259
		local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2260
		local content_flow -- models/free-market.can:2261
		if prices_frame == nil then -- models/free-market.can:2262
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2263
			prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2264
		else -- models/free-market.can:2264
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2266
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2267
			local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2268
			if buy_price then -- models/free-market.can:2269
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:2270
			end -- models/free-market.can:2270
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2272
		end -- models/free-market.can:2272
		content_flow["item_row"]["sell_price"]["focus"]() -- models/free-market.can:2274
	end -- models/free-market.can:2274
end -- models/free-market.can:2274
local function create_item_price_HUD(player) -- models/free-market.can:2279
	local screen = player["gui"]["screen"] -- models/free-market.can:2280
	local main_frame = screen["FM_item_price_frame"] -- models/free-market.can:2281
	if main_frame then -- models/free-market.can:2282
		return  -- models/free-market.can:2283
	end -- models/free-market.can:2283
	main_frame = screen["add"]({ -- models/free-market.can:2286
		["type"] = "frame", -- models/free-market.can:2286
		["name"] = "FM_item_price_frame", -- models/free-market.can:2286
		["style"] = "FM_item_price_frame", -- models/free-market.can:2286
		["direction"] = "horizontal" -- models/free-market.can:2286
	}) -- models/free-market.can:2286
	main_frame["location"] = { -- models/free-market.can:2287
		["x"] = player["display_resolution"]["width"] / 2, -- models/free-market.can:2287
		["y"] = 10 -- models/free-market.can:2287
	} -- models/free-market.can:2287
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:2289
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:2290
	drag_handler["drag_target"] = main_frame -- models/free-market.can:2291
	drag_handler["style"]["vertically_stretchable"] = true -- models/free-market.can:2292
	drag_handler["style"]["minimal_height"] = 22 -- models/free-market.can:2293
	drag_handler["style"]["maximal_height"] = 0 -- models/free-market.can:2294
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:2295
	drag_handler["style"]["width"] = 10 -- models/free-market.can:2296
	local info_flow = main_frame["add"](VERTICAL_FLOW) -- models/free-market.can:2298
	info_flow["visible"] = false -- models/free-market.can:2299
	local hud_table = info_flow["add"]({ -- models/free-market.can:2300
		["type"] = "table", -- models/free-market.can:2300
		["column_count"] = 2 -- models/free-market.can:2300
	}) -- models/free-market.can:2300
	local add = hud_table["add"] -- models/free-market.can:2301
	hud_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2302
	hud_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2303
	add(LABEL)["caption"] = { -- models/free-market.can:2305
		"", -- models/free-market.can:2305
		{ "free-market.sell-price-label" }, -- models/free-market.can:2305
		COLON -- models/free-market.can:2305
	} -- models/free-market.can:2305
	local sell_price = add(LABEL) -- models/free-market.can:2306
	add(LABEL)["caption"] = { -- models/free-market.can:2308
		"", -- models/free-market.can:2308
		{ "free-market.buy-price-label" }, -- models/free-market.can:2308
		COLON -- models/free-market.can:2308
	} -- models/free-market.can:2308
	local buy_price = add(LABEL) -- models/free-market.can:2309
	local storage_flow = info_flow["add"](FLOW) -- models/free-market.can:2312
	local add = storage_flow["add"] -- models/free-market.can:2313
	local item_label = add(LABEL) -- models/free-market.can:2314
	add(LABEL)["caption"] = { -- models/free-market.can:2315
		"", -- models/free-market.can:2315
		{ "description.storage" }, -- models/free-market.can:2315
		COLON -- models/free-market.can:2315
	} -- models/free-market.can:2315
	local storage_count = add(LABEL) -- models/free-market.can:2316
	add(LABEL)["caption"] = "/" -- models/free-market.can:2318
	local storage_limit = add(LABEL) -- models/free-market.can:2319
	item_HUD[player["index"]] = { -- models/free-market.can:2322
		info_flow, -- models/free-market.can:2323
		sell_price, -- models/free-market.can:2324
		buy_price, -- models/free-market.can:2325
		item_label, -- models/free-market.can:2326
		storage_count, -- models/free-market.can:2327
		storage_limit -- models/free-market.can:2328
	} -- models/free-market.can:2328
end -- models/free-market.can:2328
local function hide_item_price_HUD(player) -- models/free-market.can:2333
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2334
	if hinter then -- models/free-market.can:2335
		hinter[1]["visible"] = false -- models/free-market.can:2336
	end -- models/free-market.can:2336
end -- models/free-market.can:2336
local function show_item_info_HUD(player, item_name) -- models/free-market.can:2342
	local force_index = player["force"]["index"] -- models/free-market.can:2343
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2344
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2345
	local count = storages[force_index][item_name] -- models/free-market.can:2346
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2347
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2349
	hinter[1]["visible"] = true -- models/free-market.can:2350
	if sell_price then -- models/free-market.can:2351
		hinter[2]["caption"] = tostring(sell_price) -- models/free-market.can:2352
	else -- models/free-market.can:2352
		hinter[2]["caption"] = "" -- models/free-market.can:2354
	end -- models/free-market.can:2354
	if buy_price then -- models/free-market.can:2356
		hinter[3]["caption"] = tostring(buy_price) -- models/free-market.can:2357
	else -- models/free-market.can:2357
		hinter[3]["caption"] = "" -- models/free-market.can:2359
	end -- models/free-market.can:2359
	hinter[4]["caption"] = "[item=" .. item_name .. "]" -- models/free-market.can:2361
	if count then -- models/free-market.can:2362
		hinter[5]["caption"] = tostring(count) -- models/free-market.can:2363
	else -- models/free-market.can:2363
		hinter[5]["caption"] = "0" -- models/free-market.can:2365
	end -- models/free-market.can:2365
	hinter[6]["caption"] = limit -- models/free-market.can:2367
end -- models/free-market.can:2367
local REMOVE_BOX_FUNCS = { -- models/free-market.can:2375
	[1] = remove_certain_buy_box, -- models/free-market.can:2376
	[3] = remove_certain_pull_box, -- models/free-market.can:2377
	[4] = remove_certain_transfer_box, -- models/free-market.can:2378
	[5] = remove_certain_universal_transfer_box, -- models/free-market.can:2379
	[6] = remove_certain_bin_box, -- models/free-market.can:2380
	[7] = remove_certain_universal_bin_box -- models/free-market.can:2381
} -- models/free-market.can:2381
local function clear_box_data(event) -- models/free-market.can:2383
	local entity = event["entity"] -- models/free-market.can:2384
	local unit_number = entity["unit_number"] -- models/free-market.can:2385
	local box_data = all_boxes[unit_number] -- models/free-market.can:2386
	if box_data == nil then -- models/free-market.can:2387
		return  -- models/free-market.can:2387
	end -- models/free-market.can:2387
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2389
end -- models/free-market.can:2389
local function clear_box_data_by_entity(entity) -- models/free-market.can:2393
	local unit_number = entity["unit_number"] -- models/free-market.can:2394
	local box_data = all_boxes[unit_number] -- models/free-market.can:2395
	if box_data == nil then -- models/free-market.can:2396
		return  -- models/free-market.can:2396
	end -- models/free-market.can:2396
	rendering_destroy(box_data[2]) -- models/free-market.can:2398
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2399
	return true -- models/free-market.can:2400
end -- models/free-market.can:2400
local function on_player_created(event) -- models/free-market.can:2403
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2404
	if not (player and player["valid"]) then -- models/free-market.can:2405
		return  -- models/free-market.can:2405
	end -- models/free-market.can:2405
	create_item_price_HUD(player) -- models/free-market.can:2407
	create_top_relative_gui(player) -- models/free-market.can:2408
	create_left_relative_gui(player) -- models/free-market.can:2409
	switch_sell_prices_gui(player) -- models/free-market.can:2410
	switch_buy_prices_gui(player) -- models/free-market.can:2411
	if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2412
		create_item_price_HUD(player) -- models/free-market.can:2413
	end -- models/free-market.can:2413
end -- models/free-market.can:2413
local function on_player_joined_game(event) -- models/free-market.can:2418
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2419
	if not (player and player["valid"]) then -- models/free-market.can:2420
		return  -- models/free-market.can:2420
	end -- models/free-market.can:2420
	if # game["connected_players"] == 1 then -- models/free-market.can:2422
		clear_invalid_player_data() -- models/free-market.can:2423
	end -- models/free-market.can:2423
	clear_boxes_gui(player) -- models/free-market.can:2426
	destroy_prices_gui(player) -- models/free-market.can:2427
	destroy_price_list_gui(player) -- models/free-market.can:2428
	create_item_price_HUD(player) -- models/free-market.can:2429
end -- models/free-market.can:2429
local function on_player_cursor_stack_changed(event) -- models/free-market.can:2451
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2452
	local cursor_stack = player["cursor_stack"] -- models/free-market.can:2453
	if cursor_stack["valid_for_read"] then -- models/free-market.can:2454
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2455
			show_item_info_HUD(player, cursor_stack["name"]) -- models/free-market.can:2456
		end -- models/free-market.can:2456
	else -- models/free-market.can:2456
		hide_item_price_HUD(player) -- models/free-market.can:2459
	end -- models/free-market.can:2459
end -- models/free-market.can:2459
local function on_force_created(event) -- models/free-market.can:2463
	init_force_data(event["force"]["index"]) -- models/free-market.can:2464
end -- models/free-market.can:2464
local function check_teams_data() -- models/free-market.can:2467
	for _, storage in pairs(storages) do -- models/free-market.can:2468
		for item_name, count in pairs(storage) do -- models/free-market.can:2469
			if count == 0 then -- models/free-market.can:2470
				storage[item_name] = nil -- models/free-market.can:2471
			end -- models/free-market.can:2471
		end -- models/free-market.can:2471
	end -- models/free-market.can:2471
end -- models/free-market.can:2471
local function check_forces() -- models/free-market.can:2477
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:2478
	local neutral_force = game["forces"]["neutral"] -- models/free-market.can:2480
	mod_data["active_forces"] = {} -- models/free-market.can:2481
	active_forces = mod_data["active_forces"] -- models/free-market.can:2482
	local size = 0 -- models/free-market.can:2483
	for _, force in pairs(game["forces"]) do -- models/free-market.can:2485
		if # force["connected_players"] > 0 then -- models/free-market.can:2486
			local force_index = force["index"] -- models/free-market.can:2487
			local items_data = buy_boxes[force_index] -- models/free-market.can:2488
			local storage_data = storages[force_index] -- models/free-market.can:2489
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2490
				local buyer_money = forces_money[force_index] -- models/free-market.can:2491
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2492
					size = size + 1 -- models/free-market.can:2493
					active_forces[size] = force_index -- models/free-market.can:2494
				end -- models/free-market.can:2494
			end -- models/free-market.can:2494
		elseif math["random"](99) > skip_offline_team_chance or force == neutral_force then -- models/free-market.can:2497
			local force_index = force["index"] -- models/free-market.can:2498
			local items_data = buy_boxes[force_index] -- models/free-market.can:2499
			local storage_data = storages[force_index] -- models/free-market.can:2500
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2501
				local buyer_money = forces_money[force_index] -- models/free-market.can:2502
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2503
					size = size + 1 -- models/free-market.can:2504
					active_forces[size] = force_index -- models/free-market.can:2505
				end -- models/free-market.can:2505
			end -- models/free-market.can:2505
		end -- models/free-market.can:2505
	end -- models/free-market.can:2505
	if # active_forces < 2 then -- models/free-market.can:2511
		mod_data["active_forces"] = {} -- models/free-market.can:2512
		active_forces = mod_data["active_forces"] -- models/free-market.can:2513
	end -- models/free-market.can:2513
end -- models/free-market.can:2513
local function on_forces_merging(event) -- models/free-market.can:2521
	local source = event["source"] -- models/free-market.can:2522
	local source_index = source["index"] -- models/free-market.can:2523
	local source_storage = storages[source_index] -- models/free-market.can:2525
	if source_storage then -- models/free-market.can:2526
		local destination_storage = storages[event["destination"]["index"]] -- models/free-market.can:2527
		for item_name, count in pairs(source_storage) do -- models/free-market.can:2528
			destination_storage[item_name] = count + (destination_storage[item_name] or 0) -- models/free-market.can:2529
		end -- models/free-market.can:2529
	end -- models/free-market.can:2529
	clear_force_data(source_index) -- models/free-market.can:2532
	local ids = rendering["get_all_ids"]() -- models/free-market.can:2534
	for i = 1, # ids do -- models/free-market.can:2535
		local id = ids[i] -- models/free-market.can:2536
		if is_render_valid(id) then -- models/free-market.can:2537
			local target = get_render_target(id) -- models/free-market.can:2538
			if target then -- models/free-market.can:2539
				local entity = target["entity"] -- models/free-market.can:2540
				if (not (entity and entity["valid"]) or entity["force"] == source) and Rget_type(id) == "text" then -- models/free-market.can:2541
					rendering_destroy(id) -- models/free-market.can:2542
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:2543
				end -- models/free-market.can:2543
			end -- models/free-market.can:2543
		end -- models/free-market.can:2543
	end -- models/free-market.can:2543
	check_forces() -- models/free-market.can:2548
end -- models/free-market.can:2548
local function on_force_cease_fire_changed(event) -- models/free-market.can:2551
	local force_index = event["force"]["index"] -- models/free-market.can:2552
	local other_force_index = event["other_force"]["index"] -- models/free-market.can:2553
	if event["added"] then -- models/free-market.can:2554
		embargoes[force_index][other_force_index] = nil -- models/free-market.can:2555
	else -- models/free-market.can:2555
		embargoes[force_index][other_force_index] = true -- models/free-market.can:2557
	end -- models/free-market.can:2557
end -- models/free-market.can:2557
local function set_transfer_box_key_pressed(event) -- models/free-market.can:2561
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2562
	local entity = player["selected"] -- models/free-market.can:2563
	if not (entity and entity["valid"]) then -- models/free-market.can:2564
		return  -- models/free-market.can:2564
	end -- models/free-market.can:2564
	if not entity["operable"] then -- models/free-market.can:2565
		return  -- models/free-market.can:2565
	end -- models/free-market.can:2565
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2566
		return  -- models/free-market.can:2566
	end -- models/free-market.can:2566
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2567
		return  -- models/free-market.can:2567
	end -- models/free-market.can:2567
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2569
	if box_data then -- models/free-market.can:2570
		local item_name = box_data[5] -- models/free-market.can:2571
		local box_type = box_data[3] -- models/free-market.can:2572
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2574
		elseif box_type == 4 or box_type == 5 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2576
		end -- models/free-market.can:2576
		return  -- models/free-market.can:2578
	end -- models/free-market.can:2578
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2581
	if not item["valid_for_read"] then -- models/free-market.can:2582
		player["print"]({ -- models/free-market.can:2583
			"multiplayer.no-address", -- models/free-market.can:2583
			{ "item" } -- models/free-market.can:2583
		}) -- models/free-market.can:2583
		return  -- models/free-market.can:2584
	end -- models/free-market.can:2584
	set_transfer_box_data(item["name"], player, entity) -- models/free-market.can:2587
end -- models/free-market.can:2587
local function set_bin_box_key_pressed(event) -- models/free-market.can:2590
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2591
	local entity = player["selected"] -- models/free-market.can:2592
	if not (entity and entity["valid"]) then -- models/free-market.can:2593
		return  -- models/free-market.can:2593
	end -- models/free-market.can:2593
	if not entity["operable"] then -- models/free-market.can:2594
		return  -- models/free-market.can:2594
	end -- models/free-market.can:2594
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2595
		return  -- models/free-market.can:2595
	end -- models/free-market.can:2595
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2596
		return  -- models/free-market.can:2596
	end -- models/free-market.can:2596
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2598
		return  -- models/free-market.can:2599
	end -- models/free-market.can:2599
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2602
	if not item["valid_for_read"] then -- models/free-market.can:2603
		player["print"]({ -- models/free-market.can:2604
			"multiplayer.no-address", -- models/free-market.can:2604
			{ "item" } -- models/free-market.can:2604
		}) -- models/free-market.can:2604
		return  -- models/free-market.can:2605
	end -- models/free-market.can:2605
	set_bin_box_data(item["name"], player, entity) -- models/free-market.can:2608
end -- models/free-market.can:2608
local function set_universal_transfer_box_key_pressed(event) -- models/free-market.can:2611
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2612
	local entity = player["selected"] -- models/free-market.can:2613
	if not (entity and entity["valid"]) then -- models/free-market.can:2614
		return  -- models/free-market.can:2614
	end -- models/free-market.can:2614
	if not entity["operable"] then -- models/free-market.can:2615
		return  -- models/free-market.can:2615
	end -- models/free-market.can:2615
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2616
		return  -- models/free-market.can:2616
	end -- models/free-market.can:2616
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2617
		return  -- models/free-market.can:2617
	end -- models/free-market.can:2617
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2619
	if box_data == nil then -- models/free-market.can:2620
		set_universal_transfer_box_data(player, entity) -- models/free-market.can:2621
	else -- models/free-market.can:2621
		local item_name = box_data[5] -- models/free-market.can:2623
		local box_type = box_data[3] -- models/free-market.can:2624
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2626
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2628
		end -- models/free-market.can:2628
	end -- models/free-market.can:2628
end -- models/free-market.can:2628
local function set_universal_bin_box_key_pressed(event) -- models/free-market.can:2633
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2634
	local entity = player["selected"] -- models/free-market.can:2635
	if not (entity and entity["valid"]) then -- models/free-market.can:2636
		return  -- models/free-market.can:2636
	end -- models/free-market.can:2636
	if not entity["operable"] then -- models/free-market.can:2637
		return  -- models/free-market.can:2637
	end -- models/free-market.can:2637
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2638
		return  -- models/free-market.can:2638
	end -- models/free-market.can:2638
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2639
		return  -- models/free-market.can:2639
	end -- models/free-market.can:2639
	if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:2641
		set_universal_bin_box_data(player, entity) -- models/free-market.can:2642
	end -- models/free-market.can:2642
end -- models/free-market.can:2642
local function set_pull_box_key_pressed(event) -- models/free-market.can:2646
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2647
	local entity = player["selected"] -- models/free-market.can:2648
	if not (entity and entity["valid"]) then -- models/free-market.can:2649
		return  -- models/free-market.can:2649
	end -- models/free-market.can:2649
	if not entity["operable"] then -- models/free-market.can:2650
		return  -- models/free-market.can:2650
	end -- models/free-market.can:2650
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2651
		return  -- models/free-market.can:2651
	end -- models/free-market.can:2651
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2652
		return  -- models/free-market.can:2652
	end -- models/free-market.can:2652
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2654
		return  -- models/free-market.can:2655
	end -- models/free-market.can:2655
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2658
	if not item["valid_for_read"] then -- models/free-market.can:2659
		player["print"]({ -- models/free-market.can:2660
			"multiplayer.no-address", -- models/free-market.can:2660
			{ "item" } -- models/free-market.can:2660
		}) -- models/free-market.can:2660
		return  -- models/free-market.can:2661
	end -- models/free-market.can:2661
	set_pull_box_data(item["name"], player, entity) -- models/free-market.can:2664
end -- models/free-market.can:2664
local function set_buy_box_key_pressed(event) -- models/free-market.can:2667
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2668
	local entity = player["selected"] -- models/free-market.can:2669
	if not (entity and entity["valid"]) then -- models/free-market.can:2670
		return  -- models/free-market.can:2670
	end -- models/free-market.can:2670
	if not entity["operable"] then -- models/free-market.can:2671
		return  -- models/free-market.can:2671
	end -- models/free-market.can:2671
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2672
		return  -- models/free-market.can:2672
	end -- models/free-market.can:2672
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2673
		return  -- models/free-market.can:2673
	end -- models/free-market.can:2673
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2675
	if box_data then -- models/free-market.can:2676
		local item_name = box_data[5] -- models/free-market.can:2677
		local box_type = box_data[3] -- models/free-market.can:2678
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2680
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2682
		end -- models/free-market.can:2682
		return  -- models/free-market.can:2684
	end -- models/free-market.can:2684
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2687
	if not item["valid_for_read"] then -- models/free-market.can:2688
		player["print"]({ -- models/free-market.can:2689
			"multiplayer.no-address", -- models/free-market.can:2689
			{ "item" } -- models/free-market.can:2689
		}) -- models/free-market.can:2689
		return  -- models/free-market.can:2690
	end -- models/free-market.can:2690
	set_buy_box_data(item["name"], player, entity) -- models/free-market.can:2693
end -- models/free-market.can:2693
local function on_gui_elem_changed(event) -- models/free-market.can:2696
	local element = event["element"] -- models/free-market.can:2697
	if not (element and element["valid"]) then -- models/free-market.can:2698
		return  -- models/free-market.can:2698
	end -- models/free-market.can:2698
	if element["name"] ~= "FM_prices_item" then -- models/free-market.can:2699
		return  -- models/free-market.can:2699
	end -- models/free-market.can:2699
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2700
	if not (player and player["valid"]) then -- models/free-market.can:2701
		return  -- models/free-market.can:2701
	end -- models/free-market.can:2701
	local item_row = element["parent"] -- models/free-market.can:2703
	local content_flow = item_row["parent"] -- models/free-market.can:2704
	local storage_row = content_flow["storage_row"] -- models/free-market.can:2705
	local item_name = element["elem_value"] -- models/free-market.can:2706
	if item_name == nil then -- models/free-market.can:2707
		item_row["sell_price"]["text"] = "" -- models/free-market.can:2708
		item_row["buy_price"]["text"] = "" -- models/free-market.can:2709
		local prices_table = content_flow["other_prices_frame"]["scroll-pane"]["prices_table"] -- models/free-market.can:2710
		prices_table["clear"]() -- models/free-market.can:2711
		make_prices_header(prices_table) -- models/free-market.can:2712
		storage_row["visible"] = false -- models/free-market.can:2713
		return  -- models/free-market.can:2714
	end -- models/free-market.can:2714
	local force_index = player["force"]["index"] -- models/free-market.can:2717
	storage_row["visible"] = true -- models/free-market.can:2719
	local count = storages[force_index][item_name] or 0 -- models/free-market.can:2720
	storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:2721
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2722
	storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:2723
	item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:2725
	item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:2726
	update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2727
end -- models/free-market.can:2727
local function on_gui_selection_state_changed(event) -- models/free-market.can:2730
	local element = event["element"] -- models/free-market.can:2731
	if not (element and element["valid"]) then -- models/free-market.can:2732
		return  -- models/free-market.can:2732
	end -- models/free-market.can:2732
	if element["name"] ~= "FM_force_price_list" then -- models/free-market.can:2733
		return  -- models/free-market.can:2733
	end -- models/free-market.can:2733
	local scroll_pane = element["parent"]["parent"]["deep_frame"]["scroll-pane"] -- models/free-market.can:2735
	local force = game["forces"][element["items"][element["selected_index"]]] -- models/free-market.can:2736
	if force == nil then -- models/free-market.can:2737
		scroll_pane["clear"]() -- models/free-market.can:2738
		make_price_list_header(scroll_pane) -- models/free-market.can:2739
		return  -- models/free-market.can:2740
	end -- models/free-market.can:2740
	update_price_list_table(force, scroll_pane) -- models/free-market.can:2743
end -- models/free-market.can:2743
local GUIS = { -- models/free-market.can:2747
	[""] = function(element, player) -- models/free-market.can:2748
		if element["type"] ~= "sprite-button" then -- models/free-market.can:2749
			return  -- models/free-market.can:2749
		end -- models/free-market.can:2749
		local parent_name = element["parent"]["name"] -- models/free-market.can:2750
		if parent_name == "price_list_table" then -- models/free-market.can:2751
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2752
			local force_index = player["force"]["index"] -- models/free-market.can:2753
			local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2754
			if prices_frame == nil then -- models/free-market.can:2755
				switch_prices_gui(player, item_name) -- models/free-market.can:2756
			else -- models/free-market.can:2756
				local content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2758
				content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2759
				local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2760
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price or "") -- models/free-market.can:2761
				local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2762
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price or "") -- models/free-market.can:2763
				update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2764
			end -- models/free-market.can:2764
		elseif parent_name == "FM_storage_table" then -- models/free-market.can:2766
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2767
			switch_prices_gui(player, item_name) -- models/free-market.can:2768
		end -- models/free-market.can:2768
	end, -- models/free-market.can:2768
	["FM_close"] = function(element) -- models/free-market.can:2771
		element["parent"]["parent"]["destroy"]() -- models/free-market.can:2772
	end, -- models/free-market.can:2772
	["FM_confirm_default_limit"] = function(element, player) -- models/free-market.can:2774
		local setting_row = element["parent"] -- models/free-market.can:2775
		local default_limit = tonumber(setting_row["FM_default_limit"]["text"]) -- models/free-market.can:2776
		if default_limit == nil or default_limit < 1 or default_limit > max_storage_threshold then -- models/free-market.can:2777
			player["print"]({ -- models/free-market.can:2778
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2778
				default_limit or "", -- models/free-market.can:2778
				1, -- models/free-market.can:2778
				max_storage_threshold -- models/free-market.can:2778
			}) -- models/free-market.can:2778
			return  -- models/free-market.can:2779
		end -- models/free-market.can:2779
		local force_index = player["force"]["index"] -- models/free-market.can:2782
		default_storage_limit[force_index] = default_limit -- models/free-market.can:2783
	end, -- models/free-market.can:2783
	["FM_confirm_storage_limit"] = function(element, player) -- models/free-market.can:2785
		local storage_row = element["parent"] -- models/free-market.can:2786
		local storage_limit = tonumber(storage_row["storage_limit"]["text"]) -- models/free-market.can:2787
		if storage_limit == nil or storage_limit < 1 or storage_limit > max_storage_threshold then -- models/free-market.can:2788
			player["print"]({ -- models/free-market.can:2789
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2789
				storage_limit or "", -- models/free-market.can:2789
				1, -- models/free-market.can:2789
				max_storage_threshold -- models/free-market.can:2789
			}) -- models/free-market.can:2789
			return  -- models/free-market.can:2790
		end -- models/free-market.can:2790
		local item_name = storage_row["parent"]["item_row"]["FM_prices_item"]["elem_value"] -- models/free-market.can:2793
		if item_name == nil then -- models/free-market.can:2794
			return  -- models/free-market.can:2794
		end -- models/free-market.can:2794
		local force_index = player["force"]["index"] -- models/free-market.can:2796
		storages_limit[force_index][item_name] = storage_limit -- models/free-market.can:2797
	end, -- models/free-market.can:2797
	["FM_confirm_buy_box"] = function(element, player) -- models/free-market.can:2799
		local parent = element["parent"] -- models/free-market.can:2800
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:2801
		if count == nil then -- models/free-market.can:2803
			player["print"]({ -- models/free-market.can:2804
				"multiplayer.no-address", -- models/free-market.can:2804
				{ "gui-train.add-item-count-condition" } -- models/free-market.can:2804
			}) -- models/free-market.can:2804
			return  -- models/free-market.can:2805
		elseif count < 1 then -- models/free-market.can:2806
			player["print"]({ -- models/free-market.can:2807
				"count-must-be-more-n", -- models/free-market.can:2807
				0 -- models/free-market.can:2807
			}) -- models/free-market.can:2807
			return  -- models/free-market.can:2808
		end -- models/free-market.can:2808
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2811
		if not item_name then -- models/free-market.can:2812
			player["print"]({ -- models/free-market.can:2813
				"multiplayer.no-address", -- models/free-market.can:2813
				{ "item" } -- models/free-market.can:2813
			}) -- models/free-market.can:2813
			return  -- models/free-market.can:2814
		end -- models/free-market.can:2814
		local box_operations = parent["parent"] -- models/free-market.can:2817
		local player_index = player["index"] -- models/free-market.can:2818
		local entity = open_box[player_index] -- models/free-market.can:2819
		if entity then -- models/free-market.can:2820
			local inventory_size = # entity["get_inventory"](1) -- models/free-market.can:1
			local max_count = game["item_prototypes"][item_name]["stack_size"] * inventory_size -- models/free-market.can:2822
			if count > max_count then -- models/free-market.can:2823
				player["print"]({ -- models/free-market.can:2824
					"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2824
					count, -- models/free-market.can:2824
					1, -- models/free-market.can:2824
					max_count -- models/free-market.can:2824
				}) -- models/free-market.can:2824
				parent["count"]["text"] = tostring(max_count) -- models/free-market.can:2825
				return  -- models/free-market.can:2826
			end -- models/free-market.can:2826
			set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:2829
			box_operations["clear"]() -- models/free-market.can:2830
			check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2831
		else -- models/free-market.can:2831
			box_operations["clear"]() -- models/free-market.can:2833
			player["print"]({ -- models/free-market.can:2834
				"multiplayer.no-address", -- models/free-market.can:2834
				{ "item-name.linked-chest" } -- models/free-market.can:2834
			}) -- models/free-market.can:2834
		end -- models/free-market.can:2834
		if # box_operations["children"] == 0 then -- models/free-market.can:2837
			open_box[player_index] = nil -- models/free-market.can:2838
		end -- models/free-market.can:2838
	end, -- models/free-market.can:2838
	["FM_confirm_buy_price_for_chest"] = function(element, player) -- models/free-market.can:2841
		local box_operations = element["parent"] -- models/free-market.can:2842
		local entity = open_box[player["index"]] -- models/free-market.can:2843
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2844
		if box_data == nil then -- models/free-market.can:2845
			box_operations["clear"]() -- models/free-market.can:2847
			return  -- models/free-market.can:2848
		end -- models/free-market.can:2848
		local buy_price = tonumber(box_operations["buy_price"]["text"]) -- models/free-market.can:2851
		if not buy_price then -- models/free-market.can:2852
			box_operations["clear"]() -- models/free-market.can:2853
		elseif buy_price < 1 then -- models/free-market.can:2854
			player["print"]({ -- models/free-market.can:2856
				"count-must-be-more-n", -- models/free-market.can:2856
				0 -- models/free-market.can:2856
			}) -- models/free-market.can:2856
			return  -- models/free-market.can:2857
		end -- models/free-market.can:2857
		local item_name = box_data[5] -- models/free-market.can:2860
		change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:2861
		box_operations["clear"]() -- models/free-market.can:2862
	end, -- models/free-market.can:2862
	["FM_confirm_transfer_box"] = function(element, player) -- models/free-market.can:2864
		local parent = element["parent"] -- models/free-market.can:2865
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2866
		if not item_name then -- models/free-market.can:2867
			player["print"]({ -- models/free-market.can:2868
				"multiplayer.no-address", -- models/free-market.can:2868
				{ "item" } -- models/free-market.can:2868
			}) -- models/free-market.can:2868
			return  -- models/free-market.can:2869
		end -- models/free-market.can:2869
		local box_operations = parent["parent"] -- models/free-market.can:2872
		local player_index = player["index"] -- models/free-market.can:2873
		local entity = open_box[player_index] -- models/free-market.can:2874
		if entity then -- models/free-market.can:2875
			set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2876
			box_operations["clear"]() -- models/free-market.can:2877
			check_sell_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2878
		else -- models/free-market.can:2878
			box_operations["clear"]() -- models/free-market.can:2880
			player["print"]({ -- models/free-market.can:2881
				"multiplayer.no-address", -- models/free-market.can:2881
				{ "item-name.linked-chest" } -- models/free-market.can:2881
			}) -- models/free-market.can:2881
		end -- models/free-market.can:2881
		if # box_operations["children"] == 0 then -- models/free-market.can:2884
			open_box[player_index] = nil -- models/free-market.can:2885
		end -- models/free-market.can:2885
	end, -- models/free-market.can:2885
	["FM_confirm_bin_box"] = function(element, player) -- models/free-market.can:2888
		local parent = element["parent"] -- models/free-market.can:2889
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2890
		if not item_name then -- models/free-market.can:2891
			player["print"]({ -- models/free-market.can:2892
				"multiplayer.no-address", -- models/free-market.can:2892
				{ "item" } -- models/free-market.can:2892
			}) -- models/free-market.can:2892
			return  -- models/free-market.can:2893
		end -- models/free-market.can:2893
		local box_operations = parent["parent"] -- models/free-market.can:2896
		local player_index = player["index"] -- models/free-market.can:2897
		local entity = open_box[player_index] -- models/free-market.can:2898
		if entity then -- models/free-market.can:2899
			set_bin_box_data(item_name, player, entity) -- models/free-market.can:2900
		else -- models/free-market.can:2900
			player["print"]({ -- models/free-market.can:2902
				"multiplayer.no-address", -- models/free-market.can:2902
				{ "item-name.linked-chest" } -- models/free-market.can:2902
			}) -- models/free-market.can:2902
		end -- models/free-market.can:2902
		box_operations["clear"]() -- models/free-market.can:2904
		open_box[player_index] = nil -- models/free-market.can:2905
	end, -- models/free-market.can:2905
	["FM_confirm_sell_price_for_chest"] = function(element, player) -- models/free-market.can:2907
		local box_operations = element["parent"] -- models/free-market.can:2908
		local entity = open_box[player["index"]] -- models/free-market.can:2909
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2910
		if box_data == nil then -- models/free-market.can:2911
			box_operations["clear"]() -- models/free-market.can:2913
			return  -- models/free-market.can:2914
		end -- models/free-market.can:2914
		local sell_price = tonumber(box_operations["sell_price"]["text"]) -- models/free-market.can:2917
		if not sell_price then -- models/free-market.can:2918
			box_operations["clear"]() -- models/free-market.can:2919
		elseif sell_price < 1 then -- models/free-market.can:2920
			player["print"]({ -- models/free-market.can:2922
				"count-must-be-more-n", -- models/free-market.can:2922
				0 -- models/free-market.can:2922
			}) -- models/free-market.can:2922
			return  -- models/free-market.can:2923
		end -- models/free-market.can:2923
		local item_name = box_data[5] -- models/free-market.can:2926
		change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:2927
		box_operations["clear"]() -- models/free-market.can:2928
	end, -- models/free-market.can:2928
	["FM_confirm_pull_box"] = function(element, player) -- models/free-market.can:2930
		local parent = element["parent"] -- models/free-market.can:2931
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2932
		if not item_name then -- models/free-market.can:2933
			player["print"]({ -- models/free-market.can:2934
				"multiplayer.no-address", -- models/free-market.can:2934
				{ "item" } -- models/free-market.can:2934
			}) -- models/free-market.can:2934
			return  -- models/free-market.can:2935
		end -- models/free-market.can:2935
		local player_index = player["index"] -- models/free-market.can:2938
		local entity = open_box[player_index] -- models/free-market.can:2939
		if entity then -- models/free-market.can:2940
			set_pull_box_data(item_name, player, entity) -- models/free-market.can:2941
		else -- models/free-market.can:2941
			player["print"]({ -- models/free-market.can:2943
				"multiplayer.no-address", -- models/free-market.can:2943
				{ "item-name.linked-chest" } -- models/free-market.can:2943
			}) -- models/free-market.can:2943
		end -- models/free-market.can:2943
		open_box[player_index] = nil -- models/free-market.can:2945
		local box_operations = parent["parent"] -- models/free-market.can:2946
		box_operations["clear"]() -- models/free-market.can:2947
	end, -- models/free-market.can:2947
	["FM_change_transfer_box"] = function(element, player) -- models/free-market.can:2949
		local parent = element["parent"] -- models/free-market.can:2950
		local player_index = player["index"] -- models/free-market.can:2951
		local entity = open_box[player_index] -- models/free-market.can:2952
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2953
		if entity then -- models/free-market.can:2954
			local player_force = player["force"] -- models/free-market.can:2955
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2956
			if item_name then -- models/free-market.can:2957
				if box_data and box_data[3] == 4 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2959
					remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2960
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2961
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2962
				else -- models/free-market.can:2962
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2964
				end -- models/free-market.can:2964
			else -- models/free-market.can:2964
				rendering_destroy(box_data[2]) -- models/free-market.can:2967
				remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2968
			end -- models/free-market.can:2968
		else -- models/free-market.can:2968
			player["print"]({ -- models/free-market.can:2971
				"multiplayer.no-address", -- models/free-market.can:2971
				{ "item-name.linked-chest" } -- models/free-market.can:2971
			}) -- models/free-market.can:2971
		end -- models/free-market.can:2971
		open_box[player_index] = nil -- models/free-market.can:2973
		local box_operations = element["parent"]["parent"] -- models/free-market.can:2974
		box_operations["clear"]() -- models/free-market.can:2975
	end, -- models/free-market.can:2975
	["FM_change_bin_box"] = function(element, player) -- models/free-market.can:2977
		local parent = element["parent"] -- models/free-market.can:2978
		local player_index = player["index"] -- models/free-market.can:2979
		local entity = open_box[player_index] -- models/free-market.can:2980
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2981
		if entity then -- models/free-market.can:2982
			local player_force = player["force"] -- models/free-market.can:2983
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2984
			if item_name then -- models/free-market.can:2985
				if box_data and box_data[3] == 6 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2987
					remove_certain_bin_box(entity, box_data) -- models/free-market.can:2988
					set_bin_box_data(item_name, player, entity) -- models/free-market.can:2989
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2990
				else -- models/free-market.can:2990
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2992
				end -- models/free-market.can:2992
			else -- models/free-market.can:2992
				rendering_destroy(box_data[2]) -- models/free-market.can:2995
				remove_certain_bin_box(entity, box_data) -- models/free-market.can:2996
			end -- models/free-market.can:2996
		else -- models/free-market.can:2996
			player["print"]({ -- models/free-market.can:2999
				"multiplayer.no-address", -- models/free-market.can:2999
				{ "item-name.linked-chest" } -- models/free-market.can:2999
			}) -- models/free-market.can:2999
		end -- models/free-market.can:2999
		open_box[player_index] = nil -- models/free-market.can:3001
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3002
		box_operations["clear"]() -- models/free-market.can:3003
	end, -- models/free-market.can:3003
	["FM_change_pull_box"] = function(element, player) -- models/free-market.can:3005
		local parent = element["parent"] -- models/free-market.can:3006
		local player_index = player["index"] -- models/free-market.can:3007
		local entity = open_box[player_index] -- models/free-market.can:3008
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3009
		if entity then -- models/free-market.can:3010
			local player_force = player["force"] -- models/free-market.can:3011
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3012
			if item_name then -- models/free-market.can:3013
				if box_data and box_data[3] == 3 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:3015
					remove_certain_pull_box(entity, box_data) -- models/free-market.can:3016
					set_pull_box_data(item_name, player, entity) -- models/free-market.can:3017
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3018
				else -- models/free-market.can:3018
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3020
				end -- models/free-market.can:3020
			else -- models/free-market.can:3020
				rendering_destroy(box_data[2]) -- models/free-market.can:3023
				remove_certain_pull_box(entity, box_data) -- models/free-market.can:3024
			end -- models/free-market.can:3024
		else -- models/free-market.can:3024
			player["print"]({ -- models/free-market.can:3027
				"multiplayer.no-address", -- models/free-market.can:3027
				{ "item-name.linked-chest" } -- models/free-market.can:3027
			}) -- models/free-market.can:3027
		end -- models/free-market.can:3027
		open_box[player_index] = nil -- models/free-market.can:3029
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3030
		box_operations["clear"]() -- models/free-market.can:3031
	end, -- models/free-market.can:3031
	["FM_change_buy_box"] = function(element, player) -- models/free-market.can:3033
		local parent = element["parent"] -- models/free-market.can:3034
		local player_index = player["index"] -- models/free-market.can:3035
		local entity = open_box[player_index] -- models/free-market.can:3036
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:3037
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3038
		if entity then -- models/free-market.can:3039
			local player_force = player["force"] -- models/free-market.can:3040
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3041
			if item_name and count then -- models/free-market.can:3042
				local prev_item_name = box_data[5] -- models/free-market.can:3043
				if prev_item_name == item_name then -- models/free-market.can:3044
					change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:3045
				else -- models/free-market.can:3045
					if box_data and box_data[3] == 1 then -- models/free-market.can:1
						rendering_destroy(box_data[2]) -- models/free-market.can:3048
						remove_certain_buy_box(entity, box_data) -- models/free-market.can:3049
						set_buy_box_data(item_name, player, entity) -- models/free-market.can:3050
						show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3051
					else -- models/free-market.can:3051
						player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3053
					end -- models/free-market.can:3053
				end -- models/free-market.can:3053
			else -- models/free-market.can:3053
				rendering_destroy(box_data[2]) -- models/free-market.can:3057
				remove_certain_buy_box(entity, box_data) -- models/free-market.can:3058
			end -- models/free-market.can:3058
		else -- models/free-market.can:3058
			player["print"]({ -- models/free-market.can:3061
				"multiplayer.no-address", -- models/free-market.can:3061
				{ "item-name.linked-chest" } -- models/free-market.can:3061
			}) -- models/free-market.can:3061
		end -- models/free-market.can:3061
		open_box[player_index] = nil -- models/free-market.can:3063
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3064
		box_operations["clear"]() -- models/free-market.can:3065
	end, -- models/free-market.can:3065
	["FM_confirm_sell_price"] = function(element, player) -- models/free-market.can:3067
		local parent = element["parent"] -- models/free-market.can:3068
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3069
		if item_name == nil then -- models/free-market.can:3070
			return  -- models/free-market.can:3070
		end -- models/free-market.can:3070
		local sell_price_element = parent["sell_price"] -- models/free-market.can:3072
		local sell_price = tonumber(sell_price_element["text"]) -- models/free-market.can:3073
		local prev_sell_price = change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:3074
		if prev_sell_price then -- models/free-market.can:3075
			sell_price_element["text"] = tostring(prev_sell_price) -- models/free-market.can:3076
		end -- models/free-market.can:3076
	end, -- models/free-market.can:3076
	["FM_confirm_buy_price"] = function(element, player) -- models/free-market.can:3079
		local parent = element["parent"] -- models/free-market.can:3080
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3081
		if item_name == nil then -- models/free-market.can:3082
			return  -- models/free-market.can:3082
		end -- models/free-market.can:3082
		local buy_price_element = parent["buy_price"] -- models/free-market.can:3084
		local buy_price = tonumber(buy_price_element["text"]) -- models/free-market.can:3085
		local prev_buy_price = change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:3086
		if prev_buy_price then -- models/free-market.can:3087
			buy_price_element["text"] = tostring(prev_buy_price) -- models/free-market.can:3088
		end -- models/free-market.can:3088
	end, -- models/free-market.can:3088
	["FM_refresh_prices_table"] = function(element, player) -- models/free-market.can:3091
		local content_flow = element["parent"]["parent"]["shallow_frame"]["content_flow"] -- models/free-market.can:3092
		local item_row = content_flow["item_row"] -- models/free-market.can:3093
		local item_name = item_row["FM_prices_item"]["elem_value"] -- models/free-market.can:3094
		if item_name == nil then -- models/free-market.can:3095
			return  -- models/free-market.can:3095
		end -- models/free-market.can:3095
		local force_index = player["force"]["index"] -- models/free-market.can:3097
		item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:3098
		item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:3099
		local storage_row = content_flow["storage_row"] -- models/free-market.can:3101
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:3102
		storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:3103
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:3104
		storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:3105
		update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:3107
	end, -- models/free-market.can:3107
	["FM_set_transfer_box"] = function(element, player) -- models/free-market.can:3109
		local entity = player["opened"] -- models/free-market.can:3110
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3112
			if player["force"] ~= entity["force"] then -- models/free-market.can:3113
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3114
				return  -- models/free-market.can:3115
			end -- models/free-market.can:3115
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3118
			if box_data then -- models/free-market.can:3119
				local box_type = box_data[3] -- models/free-market.can:3120
				if box_type == 4 then -- models/free-market.can:1
					open_transfer_box_gui(player, false, entity) -- models/free-market.can:3122
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3124
					return  -- models/free-market.can:3125
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3127
					return  -- models/free-market.can:3128
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3130
					return  -- models/free-market.can:3131
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3133
					return  -- models/free-market.can:3134
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3136
					return  -- models/free-market.can:3137
				end -- models/free-market.can:3137
			else -- models/free-market.can:3137
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3140
				if not item["valid_for_read"] then -- models/free-market.can:3141
					open_transfer_box_gui(player, true) -- models/free-market.can:3142
				else -- models/free-market.can:3142
					local item_name = item["name"] -- models/free-market.can:3144
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:3145
					check_sell_price(player, item_name) -- models/free-market.can:3146
				end -- models/free-market.can:3146
			end -- models/free-market.can:3146
			open_box[player["index"]] = entity -- models/free-market.can:3149
		end -- models/free-market.can:3149
	end, -- models/free-market.can:3149
	["FM_set_universal_transfer_box"] = function(element, player) -- models/free-market.can:3152
		local entity = player["opened"] -- models/free-market.can:3153
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3155
			if player["force"] ~= entity["force"] then -- models/free-market.can:3156
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3157
				return  -- models/free-market.can:3158
			end -- models/free-market.can:3158
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3161
			if box_data then -- models/free-market.can:3162
				local box_type = box_data[3] -- models/free-market.can:3163
				if box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3165
					return  -- models/free-market.can:3166
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3168
					return  -- models/free-market.can:3169
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3171
					return  -- models/free-market.can:3172
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3174
					return  -- models/free-market.can:3175
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3177
					return  -- models/free-market.can:3178
				end -- models/free-market.can:3178
			else -- models/free-market.can:3178
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3181
			end -- models/free-market.can:3181
			open_box[player["index"]] = entity -- models/free-market.can:3183
		end -- models/free-market.can:3183
	end, -- models/free-market.can:3183
	["FM_set_bin_box"] = function(element, player) -- models/free-market.can:3186
		local entity = player["opened"] -- models/free-market.can:3187
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3189
			if player["force"] ~= entity["force"] then -- models/free-market.can:3190
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3191
				return  -- models/free-market.can:3192
			end -- models/free-market.can:3192
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3195
			if box_data then -- models/free-market.can:3196
				local box_type = box_data[3] -- models/free-market.can:3197
				if box_type == 6 then -- models/free-market.can:1
					open_bin_box_gui(player, false, entity) -- models/free-market.can:3199
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3201
					return  -- models/free-market.can:3202
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3204
					return  -- models/free-market.can:3205
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3207
					return  -- models/free-market.can:3208
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3210
					return  -- models/free-market.can:3211
				end -- models/free-market.can:3211
			else -- models/free-market.can:3211
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3214
				if not item["valid_for_read"] then -- models/free-market.can:3215
					open_bin_box_gui(player, true) -- models/free-market.can:3216
				else -- models/free-market.can:3216
					set_bin_box_data(item["name"], player, entity) -- models/free-market.can:3218
				end -- models/free-market.can:3218
			end -- models/free-market.can:3218
			open_box[player["index"]] = entity -- models/free-market.can:3221
		end -- models/free-market.can:3221
	end, -- models/free-market.can:3221
	["FM_set_universal_bin_box"] = function(element, player) -- models/free-market.can:3224
		local entity = player["opened"] -- models/free-market.can:3225
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3227
			if player["force"] ~= entity["force"] then -- models/free-market.can:3228
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3229
				return  -- models/free-market.can:3230
			end -- models/free-market.can:3230
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3233
			if box_data then -- models/free-market.can:3234
				local box_type = box_data[3] -- models/free-market.can:3235
				if box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3237
					return  -- models/free-market.can:3238
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3240
					return  -- models/free-market.can:3241
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3243
					return  -- models/free-market.can:3244
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3246
					return  -- models/free-market.can:3247
				end -- models/free-market.can:3247
			else -- models/free-market.can:3247
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3250
			end -- models/free-market.can:3250
			open_box[player["index"]] = entity -- models/free-market.can:3252
		end -- models/free-market.can:3252
	end, -- models/free-market.can:3252
	["FM_set_pull_box"] = function(element, player) -- models/free-market.can:3255
		local entity = player["opened"] -- models/free-market.can:3256
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3258
			if player["force"] ~= entity["force"] then -- models/free-market.can:3259
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3260
				return  -- models/free-market.can:3261
			end -- models/free-market.can:3261
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3264
			if box_data then -- models/free-market.can:3265
				local box_type = box_data[3] -- models/free-market.can:3266
				if box_type == 3 then -- models/free-market.can:1
					open_pull_box_gui(player, false, entity) -- models/free-market.can:3268
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3270
					return  -- models/free-market.can:3271
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3273
					return  -- models/free-market.can:3274
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3276
					return  -- models/free-market.can:3277
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3279
					return  -- models/free-market.can:3280
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3282
					return  -- models/free-market.can:3283
				end -- models/free-market.can:3283
			else -- models/free-market.can:3283
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3286
				if not item["valid_for_read"] then -- models/free-market.can:3287
					open_pull_box_gui(player, true) -- models/free-market.can:3288
				else -- models/free-market.can:3288
					set_pull_box_data(item["name"], player, entity) -- models/free-market.can:3290
				end -- models/free-market.can:3290
			end -- models/free-market.can:3290
			open_box[player["index"]] = entity -- models/free-market.can:3293
		end -- models/free-market.can:3293
	end, -- models/free-market.can:3293
	["FM_set_buy_box"] = function(element, player) -- models/free-market.can:3296
		local entity = player["opened"] -- models/free-market.can:3297
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3299
			if player["force"] ~= entity["force"] then -- models/free-market.can:3300
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3301
				return  -- models/free-market.can:3302
			end -- models/free-market.can:3302
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3305
			if box_data then -- models/free-market.can:3306
				local box_type = box_data[3] -- models/free-market.can:3307
				if box_type == 1 then -- models/free-market.can:1
					open_buy_box_gui(player, false, entity) -- models/free-market.can:3309
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3311
					return  -- models/free-market.can:3312
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3314
					return  -- models/free-market.can:3315
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3317
					return  -- models/free-market.can:3318
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3320
					return  -- models/free-market.can:3321
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3323
					return  -- models/free-market.can:3324
				end -- models/free-market.can:3324
			else -- models/free-market.can:3324
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3327
				if not item["valid_for_read"] then -- models/free-market.can:3328
					open_buy_box_gui(player, true) -- models/free-market.can:3329
				else -- models/free-market.can:3329
					local box_operations = element["parent"]["parent"]["box_operations"] -- models/free-market.can:3331
					local item_name = item["name"] -- models/free-market.can:3332
					set_buy_box_data(item_name, player, entity) -- models/free-market.can:3333
					check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:3334
				end -- models/free-market.can:3334
			end -- models/free-market.can:3334
			open_box[player["index"]] = entity -- models/free-market.can:3337
		end -- models/free-market.can:3337
	end, -- models/free-market.can:3337
	["FM_print_force_data"] = function(element, player) -- models/free-market.can:3340
		if player["admin"] then -- models/free-market.can:3341
			print_force_data(player["force"], player) -- models/free-market.can:3342
		else -- models/free-market.can:3342
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3344
		end -- models/free-market.can:3344
	end, -- models/free-market.can:3344
	["FM_clear_invalid_data"] = clear_invalid_data, -- models/free-market.can:3347
	["FM_reset_buy_prices"] = function(element, player) -- models/free-market.can:3348
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3349
			local force_index = player["force"]["index"] -- models/free-market.can:3350
			buy_prices[force_index] = {} -- models/free-market.can:3351
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3352
		else -- models/free-market.can:3352
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3354
		end -- models/free-market.can:3354
	end, -- models/free-market.can:3354
	["FM_reset_sell_prices"] = function(element, player) -- models/free-market.can:3357
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3358
			local force_index = player["force"]["index"] -- models/free-market.can:3359
			sell_prices[force_index] = {} -- models/free-market.can:3360
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3361
		else -- models/free-market.can:3361
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3363
		end -- models/free-market.can:3363
	end, -- models/free-market.can:3363
	["FM_reset_all_prices"] = function(element, player) -- models/free-market.can:3366
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3367
			local force_index = player["force"]["index"] -- models/free-market.can:3368
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3369
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3370
			sell_prices[force_index] = {} -- models/free-market.can:3371
			buy_prices[force_index] = {} -- models/free-market.can:3372
		else -- models/free-market.can:3372
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3374
		end -- models/free-market.can:3374
	end, -- models/free-market.can:3374
	["FM_reset_buy_boxes"] = function(element, player) -- models/free-market.can:3377
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3378
			resetBuyBoxes(player["force"]["index"]) -- models/free-market.can:3379
		else -- models/free-market.can:3379
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3381
		end -- models/free-market.can:3381
	end, -- models/free-market.can:3381
	["FM_reset_transfer_boxes"] = function(element, player) -- models/free-market.can:3384
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3385
			resetTransferBoxes(player["force"]["index"]) -- models/free-market.can:3386
		else -- models/free-market.can:3386
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3388
		end -- models/free-market.can:3388
	end, -- models/free-market.can:3388
	["FM_reset_universal_transfer_boxes"] = function(element, player) -- models/free-market.can:3391
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3392
			resetUniversalTransferBoxes(player["force"]["index"]) -- models/free-market.can:3393
		else -- models/free-market.can:3393
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3395
		end -- models/free-market.can:3395
	end, -- models/free-market.can:3395
	["FM_reset_bin_boxes"] = function(element, player) -- models/free-market.can:3398
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3399
			resetBinBoxes(player["force"]["index"]) -- models/free-market.can:3400
		else -- models/free-market.can:3400
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3402
		end -- models/free-market.can:3402
	end, -- models/free-market.can:3402
	["FM_reset_universal_bin_boxes"] = function(element, player) -- models/free-market.can:3405
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3406
			resetUniversalBinBoxes(player["force"]["index"]) -- models/free-market.can:3407
		else -- models/free-market.can:3407
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3409
		end -- models/free-market.can:3409
	end, -- models/free-market.can:3409
	["FM_reset_pull_boxes"] = function(element, player) -- models/free-market.can:3412
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3413
			resetPullBoxes(player["force"]["index"]) -- models/free-market.can:3414
		else -- models/free-market.can:3414
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3416
		end -- models/free-market.can:3416
	end, -- models/free-market.can:3416
	["FM_reset_all_boxes"] = function(element, player) -- models/free-market.can:3419
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3420
			resetAllBoxes(player["force"]["index"]) -- models/free-market.can:3421
		else -- models/free-market.can:3421
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3423
		end -- models/free-market.can:3423
	end, -- models/free-market.can:3423
	["FM_declare_embargo"] = function(element, player) -- models/free-market.can:3426
		local table_element = element["parent"]["parent"] -- models/free-market.can:3427
		local forces_list = table_element["forces_list"] -- models/free-market.can:3428
		if forces_list["selected_index"] == 0 then -- models/free-market.can:3429
			return  -- models/free-market.can:3429
		end -- models/free-market.can:3429
		local force_name = forces_list["items"][forces_list["selected_index"]] -- models/free-market.can:3431
		local other_force = game["forces"][force_name] -- models/free-market.can:3432
		if other_force and other_force["valid"] then -- models/free-market.can:3433
			local force = player["force"] -- models/free-market.can:3434
			embargoes[force["index"]][other_force["index"]] = true -- models/free-market.can:3435
			local message = { -- models/free-market.can:3436
				"free-market.declared-embargo", -- models/free-market.can:3436
				force["name"], -- models/free-market.can:3436
				other_force["name"], -- models/free-market.can:3436
				player["name"] -- models/free-market.can:3436
			} -- models/free-market.can:3436
			force["print"](message) -- models/free-market.can:3437
			other_force["print"](message) -- models/free-market.can:3438
		end -- models/free-market.can:3438
		update_embargo_table(table_element, player) -- models/free-market.can:3440
	end, -- models/free-market.can:3440
	["FM_cancel_embargo"] = function(element, player) -- models/free-market.can:3442
		local table_element = element["parent"]["parent"] -- models/free-market.can:3443
		local embargo_list = table_element["embargo_list"] -- models/free-market.can:3444
		if embargo_list["selected_index"] == 0 then -- models/free-market.can:3445
			return  -- models/free-market.can:3445
		end -- models/free-market.can:3445
		local force_name = embargo_list["items"][embargo_list["selected_index"]] -- models/free-market.can:3447
		local other_force = game["forces"][force_name] -- models/free-market.can:3448
		if other_force and other_force["valid"] then -- models/free-market.can:3449
			local force = player["force"] -- models/free-market.can:3450
			embargoes[force["index"]][other_force["index"]] = nil -- models/free-market.can:3451
			local message = { -- models/free-market.can:3452
				"free-market.canceled-embargo", -- models/free-market.can:3452
				force["name"], -- models/free-market.can:3452
				other_force["name"], -- models/free-market.can:3452
				player["name"] -- models/free-market.can:3452
			} -- models/free-market.can:3452
			force["print"](message) -- models/free-market.can:3453
			other_force["print"](message) -- models/free-market.can:3454
		end -- models/free-market.can:3454
		update_embargo_table(table_element, player) -- models/free-market.can:3456
	end, -- models/free-market.can:3456
	["FM_open_force_configuration"] = function(element, player) -- models/free-market.can:3458
		open_force_configuration(player) -- models/free-market.can:3459
	end, -- models/free-market.can:3459
	["FM_open_price"] = function(element, player) -- models/free-market.can:3461
		switch_prices_gui(player) -- models/free-market.can:3462
	end, -- models/free-market.can:3462
	["FM_switch_sell_prices_gui"] = function(element, player) -- models/free-market.can:3464
		switch_sell_prices_gui(player) -- models/free-market.can:3465
	end, -- models/free-market.can:3465
	["FM_switch_buy_prices_gui"] = function(element, player) -- models/free-market.can:3467
		switch_buy_prices_gui(player) -- models/free-market.can:3468
	end, -- models/free-market.can:3468
	["FM_open_sell_price"] = function(element, player, event) -- models/free-market.can:3470
		local force_index = tonumber(element["children"][1]["name"]) -- models/free-market.can:3471
		local force = game["forces"][force_index or 0] -- models/free-market.can:3472
		if not (force and force["valid"]) then -- models/free-market.can:3473
			game["print"]({ -- models/free-market.can:3474
				"force-doesnt-exist", -- models/free-market.can:3474
				"?" -- models/free-market.can:3474
			}) -- models/free-market.can:3474
			return  -- models/free-market.can:3475
		end -- models/free-market.can:3475
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3478
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3479
			game["print"]({ -- models/free-market.can:3480
				"missing-item", -- models/free-market.can:3480
				item_name -- models/free-market.can:3480
			}) -- models/free-market.can:3480
			return  -- models/free-market.can:3481
		end -- models/free-market.can:3481
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:3484
		if price then -- models/free-market.can:3485
			if event["shift"] then -- models/free-market.can:3486
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3488
			end -- models/free-market.can:3488
			if event["control"] then -- models/free-market.can:3490
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3492
			end -- models/free-market.can:3492
			if event["alt"] then -- models/free-market.can:3494
				switch_prices_gui(player, item_name) -- models/free-market.can:3495
			end -- models/free-market.can:3495
			game["print"]({ -- models/free-market.can:3497
				"free-market.team-selling-item-for", -- models/free-market.can:3497
				force["name"], -- models/free-market.can:3497
				item_name, -- models/free-market.can:3497
				price -- models/free-market.can:3497
			}) -- models/free-market.can:3497
		else -- models/free-market.can:3497
			game["print"]({ -- models/free-market.can:3500
				"free-market.team-doesnt-sell-item", -- models/free-market.can:3500
				force["name"], -- models/free-market.can:3500
				item_name -- models/free-market.can:3500
			}) -- models/free-market.can:3500
		end -- models/free-market.can:3500
	end, -- models/free-market.can:3500
	["FM_open_buy_price"] = function(element, player, event) -- models/free-market.can:3503
		local force_index = tonumber(element["children"][1]["name"]) or 0 -- models/free-market.can:3504
		local force = game["forces"][force_index] -- models/free-market.can:3505
		if not (force and force["valid"]) then -- models/free-market.can:3506
			game["print"]({ -- models/free-market.can:3507
				"force-doesnt-exist", -- models/free-market.can:3507
				"?" -- models/free-market.can:3507
			}) -- models/free-market.can:3507
			return  -- models/free-market.can:3508
		end -- models/free-market.can:3508
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3511
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3512
			game["print"]({ -- models/free-market.can:3513
				"missing-item", -- models/free-market.can:3513
				item_name -- models/free-market.can:3513
			}) -- models/free-market.can:3513
			return  -- models/free-market.can:3514
		end -- models/free-market.can:3514
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:3517
		if price then -- models/free-market.can:3518
			if event["shift"] then -- models/free-market.can:3519
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3521
			end -- models/free-market.can:3521
			if event["control"] then -- models/free-market.can:3523
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3525
			end -- models/free-market.can:3525
			if event["alt"] then -- models/free-market.can:3527
				switch_prices_gui(player, item_name) -- models/free-market.can:3528
			end -- models/free-market.can:3528
			game["print"]({ -- models/free-market.can:3530
				"free-market.team-buying-item-for", -- models/free-market.can:3530
				force["name"], -- models/free-market.can:3530
				item_name, -- models/free-market.can:3530
				price -- models/free-market.can:3530
			}) -- models/free-market.can:3530
		else -- models/free-market.can:3530
			game["print"]({ -- models/free-market.can:3533
				"free-market.team-doesnt-buy-item", -- models/free-market.can:3533
				force["name"], -- models/free-market.can:3533
				item_name -- models/free-market.can:3533
			}) -- models/free-market.can:3533
		end -- models/free-market.can:3533
	end, -- models/free-market.can:3533
	["FM_open_price_list"] = function(element, player) -- models/free-market.can:3536
		open_price_list_gui(player) -- models/free-market.can:3537
	end, -- models/free-market.can:3537
	["FM_open_embargo"] = function(element, player) -- models/free-market.can:3539
		open_embargo_gui(player) -- models/free-market.can:3540
	end, -- models/free-market.can:3540
	["FM_open_storage"] = function(element, player) -- models/free-market.can:3542
		open_storage_gui(player) -- models/free-market.can:3543
	end, -- models/free-market.can:3543
	["FM_show_hint"] = function(element, player) -- models/free-market.can:3545
		player["print"]({ "free-market.hint" }) -- models/free-market.can:3546
	end, -- models/free-market.can:3546
	["FM_hide_left_buttons"] = function(element, player) -- models/free-market.can:3548
		element["name"] = "FM_show_left_buttons" -- models/free-market.can:3549
		element["caption"] = "<" -- models/free-market.can:3550
		element["parent"]["children"][2]["visible"] = false -- models/free-market.can:3551
	end, -- models/free-market.can:3551
	["FM_show_left_buttons"] = function(element, player) -- models/free-market.can:3553
		element["name"] = "FM_hide_left_buttons" -- models/free-market.can:3554
		element["caption"] = ">" -- models/free-market.can:3555
		element["parent"]["children"][2]["visible"] = true -- models/free-market.can:3556
	end, -- models/free-market.can:3556
	["FM_search_by_price"] = function(element, player) -- models/free-market.can:3558
		local search_row = element["parent"] -- models/free-market.can:3559
		local selected_index = search_row["FM_search_price_drop_down"]["selected_index"] -- models/free-market.can:3560
		if selected_index == 0 then -- models/free-market.can:3561
			return  -- models/free-market.can:3562
		end -- models/free-market.can:3562
		local content_flow = search_row["parent"] -- models/free-market.can:3565
		local drop_down = content_flow["team_row"]["FM_force_price_list"] -- models/free-market.can:3566
		local dp_selected_index = drop_down["selected_index"] -- models/free-market.can:3567
		if dp_selected_index == nil or dp_selected_index == 0 then -- models/free-market.can:3568
			return  -- models/free-market.can:3568
		end -- models/free-market.can:3568
		local force = game["forces"][drop_down["items"][dp_selected_index]] -- models/free-market.can:3569
		if not (force and force["valid"]) then -- models/free-market.can:3570
			return  -- models/free-market.can:3570
		end -- models/free-market.can:3570
		local search_text = search_row["FM_search_text"]["text"] -- models/free-market.can:3572
		if # search_text > 50 then -- models/free-market.can:3573
			return  -- models/free-market.can:3574
		end -- models/free-market.can:3574
		local scroll_pane = content_flow["deep_frame"]["scroll-pane"] -- models/free-market.can:3576
		if search_text == "" then -- models/free-market.can:3577
			update_price_list_table(force, scroll_pane) -- models/free-market.can:3578
			return  -- models/free-market.can:3579
		end -- models/free-market.can:3579
		search_text = ".?" .. search_text:lower():gsub(" ", ".?") .. ".?" -- models/free-market.can:3582
		if selected_index == 1 then -- models/free-market.can:3583
			update_price_list_by_sell_filter(force, scroll_pane, search_text) -- models/free-market.can:3584
		else -- models/free-market.can:3584
			update_price_list_by_buy_filter(force, scroll_pane, search_text) -- models/free-market.can:3586
		end -- models/free-market.can:3586
	end -- models/free-market.can:3586
} -- models/free-market.can:3586
local function on_gui_click(event) -- models/free-market.can:3590
	local element = event["element"] -- models/free-market.can:3591
	local f = GUIS[element["name"]] -- models/free-market.can:3592
	if f then -- models/free-market.can:3593
		f(element, game["get_player"](event["player_index"]), event) -- models/free-market.can:3593
	end -- models/free-market.can:3593
end -- models/free-market.can:3593
local function on_gui_closed(event) -- models/free-market.can:3596
	local entity = event["entity"] -- models/free-market.can:3597
	if not (entity and entity["valid"]) then -- models/free-market.can:3598
		return  -- models/free-market.can:3598
	end -- models/free-market.can:3598
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3599
		return  -- models/free-market.can:3599
	end -- models/free-market.can:3599
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3600
	if not (player and player["valid"]) then -- models/free-market.can:3601
		return  -- models/free-market.can:3601
	end -- models/free-market.can:3601
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:3602
end -- models/free-market.can:3602
local function check_pull_boxes() -- models/free-market.can:3605
	local pulled_item_count = {} -- models/free-market.can:3606
	for force_index, _items_data in pairs(pull_boxes) do -- models/free-market.can:3607
		if pull_cost_per_item == 0 or call("EasyAPI", "get_force_money", force_index) > money_treshold then -- models/free-market.can:3608
			local inserted_count_in_total = 0 -- models/free-market.can:3609
			pulled_item_count[force_index] = 0 -- models/free-market.can:3610
			local storage = storages[force_index] -- models/free-market.can:3611
			for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3612
				local count_in_storage = storage[item_name] -- models/free-market.can:3613
				if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3614
					stack["name"] = item_name -- models/free-market.can:3615
					for i = 1, # force_entities do -- models/free-market.can:3616
						if count_in_storage <= 0 then -- models/free-market.can:3617
							break -- models/free-market.can:3618
						end -- models/free-market.can:3618
						stack["count"] = count_in_storage -- models/free-market.can:3620
						local inserted_count = force_entities[i]["insert"](stack) -- models/free-market.can:3621
						inserted_count_in_total = inserted_count_in_total + inserted_count -- models/free-market.can:3622
						count_in_storage = count_in_storage - inserted_count -- models/free-market.can:3623
					end -- models/free-market.can:3623
					storage[item_name] = count_in_storage -- models/free-market.can:3625
				end -- models/free-market.can:3625
			end -- models/free-market.can:3625
			pulled_item_count[force_index] = inserted_count_in_total -- models/free-market.can:3628
		end -- models/free-market.can:3628
	end -- models/free-market.can:3628
	if pull_cost_per_item == 0 then -- models/free-market.can:3632
		return  -- models/free-market.can:3632
	end -- models/free-market.can:3632
	for force_index, count in pairs(pulled_item_count) do -- models/free-market.can:3633
		if count > 0 then -- models/free-market.can:3634
			call("EasyAPI", "deposit_force_money_by_index", force_index, - ceil(count * pull_cost_per_item)) -- models/free-market.can:3637
		end -- models/free-market.can:3637
	end -- models/free-market.can:3637
end -- models/free-market.can:3637
local function check_transfer_boxes() -- models/free-market.can:3643
	stack["count"] = 4000000000 -- models/free-market.can:3644
	for force_index, force_entities in pairs(universal_bin_boxes) do -- models/free-market.can:3645
		local storage = storages[force_index] -- models/free-market.can:3646
		for i = 1, # force_entities do -- models/free-market.can:3647
			local entity = force_entities[i] -- models/free-market.can:3648
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3649
			for item_name in pairs(contents) do -- models/free-market.can:3650
				local count = storage[item_name] or 0 -- models/free-market.can:3651
				stack["name"] = item_name -- models/free-market.can:3652
				local sum = entity["remove_item"](stack) -- models/free-market.can:3653
				if sum > 0 then -- models/free-market.can:3654
					storage[item_name] = count + sum -- models/free-market.can:3655
				end -- models/free-market.can:3655
			end -- models/free-market.can:3655
		end -- models/free-market.can:3655
	end -- models/free-market.can:3655
	for force_index, _items_data in pairs(bin_boxes) do -- models/free-market.can:3661
		local storage = storages[force_index] -- models/free-market.can:3662
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3663
			local count = storage[item_name] or 0 -- models/free-market.can:3664
			stack["name"] = item_name -- models/free-market.can:3665
			local sum = 0 -- models/free-market.can:3666
			for i = 1, # force_entities do -- models/free-market.can:3667
				sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3668
			end -- models/free-market.can:3668
			if sum > 0 then -- models/free-market.can:3670
				storage[item_name] = count + sum -- models/free-market.can:3671
			end -- models/free-market.can:3671
		end -- models/free-market.can:3671
	end -- models/free-market.can:3671
	for force_index, force_entities in pairs(universal_transfer_boxes) do -- models/free-market.can:3677
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3678
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3679
		local storage = storages[force_index] -- models/free-market.can:3680
		for i = 1, # force_entities do -- models/free-market.can:3681
			local entity = force_entities[i] -- models/free-market.can:3682
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3683
			for item_name in pairs(contents) do -- models/free-market.can:3684
				local count = storage[item_name] or 0 -- models/free-market.can:3685
				local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3686
				if max_count > 0 then -- models/free-market.can:3687
					stack["count"] = max_count -- models/free-market.can:3688
					stack["name"] = item_name -- models/free-market.can:3689
					local sum = entity["remove_item"](stack) -- models/free-market.can:3690
					if sum > 0 then -- models/free-market.can:3691
						storage[item_name] = count + sum -- models/free-market.can:3692
					end -- models/free-market.can:3692
				end -- models/free-market.can:3692
			end -- models/free-market.can:3692
		end -- models/free-market.can:3692
	end -- models/free-market.can:3692
	for force_index, _items_data in pairs(transfer_boxes) do -- models/free-market.can:3699
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3700
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3701
		local storage = storages[force_index] -- models/free-market.can:3702
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3703
			local count = storage[item_name] or 0 -- models/free-market.can:3704
			local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3705
			if max_count > 0 then -- models/free-market.can:3706
				stack["count"] = max_count -- models/free-market.can:3707
				stack["name"] = item_name -- models/free-market.can:3708
				local sum = 0 -- models/free-market.can:3709
				for i = 1, # force_entities do -- models/free-market.can:3710
					sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3711
				end -- models/free-market.can:3711
				if sum > 0 then -- models/free-market.can:3713
					storage[item_name] = count + sum -- models/free-market.can:3714
				end -- models/free-market.can:3714
			end -- models/free-market.can:3714
		end -- models/free-market.can:3714
	end -- models/free-market.can:3714
end -- models/free-market.can:3714
local function check_buy_boxes() -- models/free-market.can:3721
	local last_checked_index = mod_data["last_checked_index"] -- models/free-market.can:3722
	local buyer_index -- models/free-market.can:3723
	if last_checked_index then -- models/free-market.can:3724
		buyer_index = active_forces[last_checked_index] -- models/free-market.can:3725
		if buyer_index then -- models/free-market.can:3726
			mod_data["last_checked_index"] = last_checked_index + 1 -- models/free-market.can:3727
		else -- models/free-market.can:3727
			mod_data["last_checked_index"] = nil -- models/free-market.can:3729
			return  -- models/free-market.can:3730
		end -- models/free-market.can:3730
	else -- models/free-market.can:3730
		last_checked_index, buyer_index = next(active_forces) -- models/free-market.can:3733
		if last_checked_index then -- models/free-market.can:3734
			mod_data["last_checked_index"] = last_checked_index -- models/free-market.can:3735
		else -- models/free-market.can:3735
			return  -- models/free-market.can:3737
		end -- models/free-market.can:3737
	end -- models/free-market.can:3737
	local items_data = buy_boxes[buyer_index] -- models/free-market.can:3741
	if items_data == nil then -- models/free-market.can:3743
		return  -- models/free-market.can:3743
	end -- models/free-market.can:3743
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:3745
	local forces_money_copy = {} -- models/free-market.can:3746
	for _force_index, value in pairs(forces_money) do -- models/free-market.can:3747
		forces_money_copy[_force_index] = value -- models/free-market.can:3748
	end -- models/free-market.can:3748
	local buyer_money = forces_money_copy[buyer_index] -- models/free-market.can:3751
	if buyer_money and buyer_money > money_treshold then -- models/free-market.can:3752
		local stack_count = 0 -- models/free-market.can:3753
		local payment = 0 -- models/free-market.can:3754
		local f_buy_prices = buy_prices[buyer_index] -- models/free-market.can:3755
		local inserted_count_in_total = 0 -- models/free-market.can:3756
		for item_name, entities in pairs(items_data) do -- models/free-market.can:3757
			if money_treshold >= buyer_money then -- models/free-market.can:3758
				goto not_enough_money -- models/free-market.can:3760
			end -- models/free-market.can:3760
			local buy_price = f_buy_prices[item_name] -- models/free-market.can:3762
			if buy_price and buyer_money >= buy_price then -- models/free-market.can:3763
				for i = 1, # entities do -- models/free-market.can:3764
					local buy_data = entities[i] -- models/free-market.can:3765
					local purchasable_count = buyer_money / buy_price -- models/free-market.can:3766
					if purchasable_count < 1 then -- models/free-market.can:3767
						goto skip_buy -- models/free-market.can:3768
					else -- models/free-market.can:3768
						purchasable_count = floor(purchasable_count) -- models/free-market.can:3770
					end -- models/free-market.can:3770
					local buy_box = buy_data[1] -- models/free-market.can:3772
					local need_count = buy_data[2] -- models/free-market.can:3773
					if purchasable_count < need_count then -- models/free-market.can:3774
						need_count = purchasable_count -- models/free-market.can:3775
					end -- models/free-market.can:3775
					local count = buy_box["get_item_count"](item_name) -- models/free-market.can:3777
					stack["name"] = item_name -- models/free-market.can:3778
					if need_count < count then -- models/free-market.can:3779
						stack_count = count -- models/free-market.can:3780
					else -- models/free-market.can:3780
						need_count = need_count - count -- models/free-market.can:3782
						if need_count <= 0 then -- models/free-market.can:3783
							goto skip_buy -- models/free-market.can:3784
						end -- models/free-market.can:3784
						local buyer_storage = storages[buyer_index] -- models/free-market.can:3787
						local count_in_storage = buyer_storage[item_name] -- models/free-market.can:3788
						if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3789
							stack_count = need_count - count_in_storage -- models/free-market.can:3790
							if stack_count <= 0 then -- models/free-market.can:3791
								buyer_storage[item_name] = count_in_storage - need_count -- models/free-market.can:3792
								stack_count = 0 -- models/free-market.can:3793
								goto fulfilled_needs -- models/free-market.can:3794
							else -- models/free-market.can:3794
								buyer_storage[item_name] = count_in_storage + (stack_count - need_count) -- models/free-market.can:3796
							end -- models/free-market.can:3796
						else -- models/free-market.can:3796
							stack_count = need_count -- models/free-market.can:3799
						end -- models/free-market.can:3799
						for seller_index, seller_storage in pairs(storages) do -- models/free-market.can:3802
							if buyer_index ~= seller_index and forces_money[seller_index] and not embargoes[seller_index][buyer_index] then -- models/free-market.can:3803
								local sell_price = sell_prices[seller_index][item_name] -- models/free-market.can:3804
								if sell_price and buy_price >= sell_price then -- models/free-market.can:3805
									count_in_storage = seller_storage[item_name] -- models/free-market.can:3806
									if count_in_storage then -- models/free-market.can:3807
										if count_in_storage > stack_count then -- models/free-market.can:3808
											seller_storage[item_name] = count_in_storage - stack_count -- models/free-market.can:3809
											stack_count = 0 -- models/free-market.can:3810
											payment = need_count * sell_price -- models/free-market.can:3811
											buyer_money = buyer_money - payment -- models/free-market.can:3812
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3813
											goto fulfilled_needs -- models/free-market.can:3814
										else -- models/free-market.can:3814
											stack_count = stack_count - count_in_storage -- models/free-market.can:3816
											seller_storage[item_name] = 0 -- models/free-market.can:3817
											payment = (need_count - stack_count) * sell_price -- models/free-market.can:3818
											buyer_money = buyer_money - payment -- models/free-market.can:3819
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3820
										end -- models/free-market.can:3820
									end -- models/free-market.can:3820
								end -- models/free-market.can:3820
							end -- models/free-market.can:3820
						end -- models/free-market.can:3820
					end -- models/free-market.can:3820
					::fulfilled_needs:: -- models/free-market.can:3827
					local found_items = need_count - stack_count -- models/free-market.can:3828
					if found_items > 0 then -- models/free-market.can:3829
						stack["count"] = found_items -- models/free-market.can:3830
						inserted_count_in_total = inserted_count_in_total + buy_box["insert"](stack) -- models/free-market.can:3831
					end -- models/free-market.can:3831
					::skip_buy:: -- models/free-market.can:3833
				end -- models/free-market.can:3833
			end -- models/free-market.can:3833
		end -- models/free-market.can:3833
		::not_enough_money:: -- models/free-market.can:3837
		if pull_cost_per_item == 0 then -- models/free-market.can:3838
			forces_money_copy[buyer_index] = buyer_money -- models/free-market.can:3839
		else -- models/free-market.can:3839
			forces_money_copy[buyer_index] = buyer_money - ceil(inserted_count_in_total * pull_cost_per_item) -- models/free-market.can:3841
		end -- models/free-market.can:3841
	else -- models/free-market.can:3841
		return  -- models/free-market.can:3844
	end -- models/free-market.can:3844
	local forces = game["forces"] -- models/free-market.can:3847
	for _force_index, money in pairs(forces_money_copy) do -- models/free-market.can:3848
		local prev_money = forces_money[_force_index] -- models/free-market.can:3849
		if prev_money ~= money then -- models/free-market.can:3850
			local force = forces[_force_index] -- models/free-market.can:3851
			call("EasyAPI", "set_force_money", force, money) -- models/free-market.can:3852
			force["item_production_statistics"]["on_flow"]("trading", money - prev_money) -- models/free-market.can:3854
		end -- models/free-market.can:3854
	end -- models/free-market.can:3854
end -- models/free-market.can:3854
local function on_player_changed_force(event) -- models/free-market.can:3859
	local player_index = event["player_index"] -- models/free-market.can:3860
	local player = game["get_player"](player_index) -- models/free-market.can:3861
	if not (player and player["valid"]) then -- models/free-market.can:3862
		return  -- models/free-market.can:3862
	end -- models/free-market.can:3862
	if open_box[player_index] then -- models/free-market.can:3864
		clear_boxes_gui(player) -- models/free-market.can:3865
	end -- models/free-market.can:3865
	local index = player["force"]["index"] -- models/free-market.can:3868
	if transfer_boxes[index] == nil then -- models/free-market.can:3869
		init_force_data(index) -- models/free-market.can:3870
	end -- models/free-market.can:3870
end -- models/free-market.can:3870
local function on_player_changed_surface(event) -- models/free-market.can:3874
	local player_index = event["player_index"] -- models/free-market.can:3875
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3876
	if not (player and player["valid"]) then -- models/free-market.can:3877
		return  -- models/free-market.can:3877
	end -- models/free-market.can:3877
	if open_box[player_index] then -- models/free-market.can:3879
		clear_boxes_gui(player) -- models/free-market.can:3880
	end -- models/free-market.can:3880
end -- models/free-market.can:3880
local function on_player_left_game(event) -- models/free-market.can:3884
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3885
	if not (player and player["valid"]) then -- models/free-market.can:3886
		return  -- models/free-market.can:3886
	end -- models/free-market.can:3886
	clear_boxes_gui(player) -- models/free-market.can:3888
	destroy_prices_gui(player) -- models/free-market.can:3889
	delete_item_price_HUD(player) -- models/free-market.can:3890
	destroy_price_list_gui(player) -- models/free-market.can:3891
	destroy_force_configuration(player) -- models/free-market.can:3892
end -- models/free-market.can:3892
local function on_selected_entity_changed(event) -- models/free-market.can:3895
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3896
	if not (player and player["valid"]) then -- models/free-market.can:3897
		return  -- models/free-market.can:3897
	end -- models/free-market.can:3897
	local entity = player["selected"] -- models/free-market.can:3898
	if not (entity and entity["valid"]) then -- models/free-market.can:3899
		return  -- models/free-market.can:3899
	end -- models/free-market.can:3899
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3900
		return  -- models/free-market.can:3900
	end -- models/free-market.can:3900
	if entity["force"] ~= player["force"] then -- models/free-market.can:3901
		return  -- models/free-market.can:3901
	end -- models/free-market.can:3901
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3902
	if box_data == nil then -- models/free-market.can:3903
		return  -- models/free-market.can:3903
	end -- models/free-market.can:3903
	local item_name = box_data[5] -- models/free-market.can:3904
	if item_name == nil then -- models/free-market.can:3905
		return  -- models/free-market.can:3905
	end -- models/free-market.can:3905
	show_item_info_HUD(player, item_name) -- models/free-market.can:3907
end -- models/free-market.can:3907
local SELECT_TOOLS = { -- models/free-market.can:3911
	["FM_set_pull_boxes_tool"] = set_pull_box_data, -- models/free-market.can:3912
	["FM_set_bin_boxes_tool"] = set_bin_box_data, -- models/free-market.can:3913
	["FM_set_transfer_boxes_tool"] = set_transfer_box_data, -- models/free-market.can:3914
	["FM_set_buy_boxes_tool"] = set_buy_box_data -- models/free-market.can:3915
} -- models/free-market.can:3915
local function on_player_selected_area(event) -- models/free-market.can:3917
	local tool_name = event["item"] -- models/free-market.can:3918
	local func = SELECT_TOOLS[tool_name] -- models/free-market.can:3919
	if func then -- models/free-market.can:3920
		local entities = event["entities"] -- models/free-market.can:3921
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3922
		for i = 1, # entities do -- models/free-market.can:3923
			local entity = entities[i] -- models/free-market.can:3924
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3925
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3926
				if item["valid_for_read"] then -- models/free-market.can:3927
					func(item["name"], player, entity) -- models/free-market.can:3928
				end -- models/free-market.can:3928
			end -- models/free-market.can:3928
		end -- models/free-market.can:3928
	elseif tool_name == "FM_set_universal_transfer_boxes_tool" then -- models/free-market.can:3932
		local entities = event["entities"] -- models/free-market.can:3933
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3934
		for i = 1, # entities do -- models/free-market.can:3935
			local entity = entities[i] -- models/free-market.can:3936
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3937
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3938
			end -- models/free-market.can:3938
		end -- models/free-market.can:3938
	elseif tool_name == "FM_set_universal_bin_boxes_tool" then -- models/free-market.can:3941
		local entities = event["entities"] -- models/free-market.can:3942
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3943
		for i = 1, # entities do -- models/free-market.can:3944
			local entity = entities[i] -- models/free-market.can:3945
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3946
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3947
			end -- models/free-market.can:3947
		end -- models/free-market.can:3947
	elseif tool_name == "FM_remove_boxes_tool" then -- models/free-market.can:3950
		local entities = event["entities"] -- models/free-market.can:3951
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3952
		local count = 0 -- models/free-market.can:3953
		for i = 1, # entities do -- models/free-market.can:3954
			local is_deleted = clear_box_data_by_entity(entities[i]) -- models/free-market.can:3955
			if is_deleted then -- models/free-market.can:3956
				count = count + 1 -- models/free-market.can:3957
			end -- models/free-market.can:3957
		end -- models/free-market.can:3957
		if count > 0 then -- models/free-market.can:3960
			player["print"]({ -- models/free-market.can:3961
				"", -- models/free-market.can:3961
				{ "gui-migrated-content.removed-entity" }, -- models/free-market.can:3961
				COLON, -- models/free-market.can:3961
				" ", -- models/free-market.can:3961
				count -- models/free-market.can:3961
			}) -- models/free-market.can:3961
		end -- models/free-market.can:3961
	end -- models/free-market.can:3961
end -- models/free-market.can:3961
do -- models/free-market.can:3968
	local TOOL_TO_TYPE = { -- models/free-market.can:3968
		["FM_set_pull_boxes_tool"] = 3, -- models/free-market.can:1
		["FM_set_transfer_boxes_tool"] = 4, -- models/free-market.can:1
		["FM_set_universal_transfer_boxes_tool"] = 5, -- models/free-market.can:1
		["FM_set_universal_bin_boxes_tool"] = 7, -- models/free-market.can:1
		["FM_set_bin_boxes_tool"] = 6, -- models/free-market.can:1
		["FM_set_buy_boxes_tool"] = 1 -- models/free-market.can:1
	} -- models/free-market.can:1
	on_player_alt_selected_area = function(event) -- models/free-market.can:3976
		local box_type = TOOL_TO_TYPE[event["item"]] -- models/free-market.can:3977
		if box_type == nil then -- models/free-market.can:3978
			return  -- models/free-market.can:3978
		end -- models/free-market.can:3978
		local remove_box = REMOVE_BOX_FUNCS[box_type] -- models/free-market.can:3980
		local entities = event["entities"] -- models/free-market.can:3981
		for i = # entities, 1, - 1 do -- models/free-market.can:3982
			local entity = entities[i] -- models/free-market.can:3983
			if entity["valid"] then -- models/free-market.can:3984
				local unit_number = entity["unit_number"] -- models/free-market.can:3985
				local box_data = all_boxes[unit_number] -- models/free-market.can:3986
				if box_data and box_data[3] == box_type then -- models/free-market.can:3987
					rendering_destroy(box_data[2]) -- models/free-market.can:3988
					remove_box(entity, box_data) -- models/free-market.can:3989
				end -- models/free-market.can:3989
			end -- models/free-market.can:3989
		end -- models/free-market.can:3989
	end -- models/free-market.can:3989
end -- models/free-market.can:3989
local mod_settings = { -- models/free-market.can:3997
	["FM_enable-auto-embargo"] = function(value) -- models/free-market.can:3998
		is_auto_embargo = value -- models/free-market.can:3998
	end, -- models/free-market.can:3998
	["FM_is-public-titles"] = function(value) -- models/free-market.can:3999
		is_public_titles = value -- models/free-market.can:3999
	end, -- models/free-market.can:3999
	["FM_is_reset_public"] = function(value) -- models/free-market.can:4000
		is_reset_public = value -- models/free-market.can:4000
	end, -- models/free-market.can:4000
	["FM_money-treshold"] = function(value) -- models/free-market.can:4001
		money_treshold = value -- models/free-market.can:4001
	end, -- models/free-market.can:4001
	["FM_minimal-price"] = function(value) -- models/free-market.can:4002
		minimal_price = value -- models/free-market.can:4002
	end, -- models/free-market.can:4002
	["FM_maximal-price"] = function(value) -- models/free-market.can:4003
		maximal_price = value -- models/free-market.can:4003
	end, -- models/free-market.can:4003
	["FM_skip_offline_team_chance"] = function(value) -- models/free-market.can:4004
		skip_offline_team_chance = value -- models/free-market.can:4004
	end, -- models/free-market.can:4004
	["FM_max_storage_threshold"] = function(value) -- models/free-market.can:4005
		max_storage_threshold = value -- models/free-market.can:4005
	end, -- models/free-market.can:4005
	["FM_pull_cost_per_item"] = function(value) -- models/free-market.can:4006
		pull_cost_per_item = value -- models/free-market.can:4006
	end, -- models/free-market.can:4006
	["FM_update-tick"] = function(value) -- models/free-market.can:4007
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4008
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4010
			return  -- models/free-market.can:4012
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4013
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4015
			return  -- models/free-market.can:4017
		elseif update_pull_tick == value then -- models/free-market.can:4018
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4020
			return  -- models/free-market.can:4022
		elseif update_transfer_tick == value then -- models/free-market.can:4023
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4025
			return  -- models/free-market.can:4027
		end -- models/free-market.can:4027
		script["on_nth_tick"](update_buy_tick, nil) -- models/free-market.can:4029
		update_buy_tick = value -- models/free-market.can:4030
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4031
	end, -- models/free-market.can:4031
	["FM_update-transfer-tick"] = function(value) -- models/free-market.can:4033
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4034
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4036
			return  -- models/free-market.can:4038
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4039
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4041
			return  -- models/free-market.can:4043
		elseif update_pull_tick == value then -- models/free-market.can:4044
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4046
			return  -- models/free-market.can:4048
		elseif update_buy_tick == value then -- models/free-market.can:4049
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4051
			return  -- models/free-market.can:4053
		end -- models/free-market.can:4053
		script["on_nth_tick"](update_transfer_tick, nil) -- models/free-market.can:4055
		update_transfer_tick = value -- models/free-market.can:4056
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4057
	end, -- models/free-market.can:4057
	["FM_update-pull-tick"] = function(value) -- models/free-market.can:4059
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4060
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4062
			return  -- models/free-market.can:4064
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4065
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4067
			return  -- models/free-market.can:4069
		elseif update_transfer_tick == value then -- models/free-market.can:4070
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4072
			return  -- models/free-market.can:4074
		elseif update_buy_tick == value then -- models/free-market.can:4075
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4077
			return  -- models/free-market.can:4079
		end -- models/free-market.can:4079
		script["on_nth_tick"](update_pull_tick, nil) -- models/free-market.can:4081
		update_pull_tick = value -- models/free-market.can:4082
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4083
	end, -- models/free-market.can:4083
	["FM_show_item_price"] = function(player) -- models/free-market.can:4085
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4086
			create_item_price_HUD(player) -- models/free-market.can:4087
		else -- models/free-market.can:4087
			delete_item_price_HUD(player) -- models/free-market.can:4089
		end -- models/free-market.can:4089
	end, -- models/free-market.can:4089
	["FM_sell_notification_column_count"] = function(player) -- models/free-market.can:4092
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:4093
		local is_vertical = (column_count == 2) -- models/free-market.can:4094
		local frame = player["gui"]["screen"]["FM_sell_prices_frame"] -- models/free-market.can:4095
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4096
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4097
			local last_location = frame["location"] -- models/free-market.can:4098
			frame["destroy"]() -- models/free-market.can:4099
			switch_sell_prices_gui(player, last_location) -- models/free-market.can:4100
		end -- models/free-market.can:4100
	end, -- models/free-market.can:4100
	["FM_buy_notification_column_count"] = function(player) -- models/free-market.can:4103
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:4104
		local is_vertical = (column_count == 2) -- models/free-market.can:4105
		local frame = player["gui"]["screen"]["FM_buy_prices_frame"] -- models/free-market.can:4106
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4107
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4108
			local last_location = frame["location"] -- models/free-market.can:4109
			frame["destroy"]() -- models/free-market.can:4110
			switch_buy_prices_gui(player, last_location) -- models/free-market.can:4111
		end -- models/free-market.can:4111
	end -- models/free-market.can:4111
} -- models/free-market.can:4111
on_runtime_mod_setting_changed = function(event) -- models/free-market.can:4115
	local setting_name = event["setting"] -- models/free-market.can:4116
	local f = mod_settings[setting_name] -- models/free-market.can:4117
	if f == nil then -- models/free-market.can:4118
		return  -- models/free-market.can:4118
	end -- models/free-market.can:4118
	if event["setting_type"] == "runtime-global" then -- models/free-market.can:4120
		f(settings["global"][setting_name]["value"]) -- models/free-market.can:4121
	else -- models/free-market.can:4121
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4123
		if player and player["valid"] then -- models/free-market.can:4124
			f(player) -- models/free-market.can:4125
		end -- models/free-market.can:4125
	end -- models/free-market.can:4125
end -- models/free-market.can:4125
local function add_remote_interface() -- models/free-market.can:4135
	remote["remove_interface"]("free-market") -- models/free-market.can:4137
	remote["add_interface"]("free-market", { -- models/free-market.can:4138
		["get_mod_data"] = function() -- models/free-market.can:4139
			return mod_data -- models/free-market.can:4139
		end, -- models/free-market.can:4139
		["get_internal_data"] = function(name) -- models/free-market.can:4140
			return mod_data[name] -- models/free-market.can:4140
		end, -- models/free-market.can:4140
		["change_count_in_buy_box_data"] = change_count_in_buy_box_data, -- models/free-market.can:4141
		["remove_certain_pull_box"] = remove_certain_pull_box, -- models/free-market.can:4142
		["remove_certain_transfer_box"] = remove_certain_transfer_box, -- models/free-market.can:4143
		["remove_certain_universal_transfer_box"] = remove_certain_universal_transfer_box, -- models/free-market.can:4144
		["remove_certain_bin_box"] = remove_certain_bin_box, -- models/free-market.can:4145
		["remove_certain_universal_bin_box"] = remove_certain_universal_bin_box, -- models/free-market.can:4146
		["remove_certain_buy_box"] = remove_certain_buy_box, -- models/free-market.can:4147
		["clear_box_data_by_entity"] = clear_box_data_by_entity, -- models/free-market.can:4148
		["resetTransferBoxes"] = resetTransferBoxes, -- models/free-market.can:4149
		["resetUniversalTransferBoxes"] = resetUniversalTransferBoxes, -- models/free-market.can:4150
		["resetBinBoxes"] = resetBinBoxes, -- models/free-market.can:4151
		["resetUniversalBinBoxes"] = resetUniversalBinBoxes, -- models/free-market.can:4152
		["resetPullBoxes"] = resetPullBoxes, -- models/free-market.can:4153
		["resetBuyBoxes"] = resetBuyBoxes, -- models/free-market.can:4154
		["resetAllBoxes"] = resetAllBoxes, -- models/free-market.can:4155
		["clear_force_data"] = clear_force_data, -- models/free-market.can:4156
		["init_force_data"] = init_force_data, -- models/free-market.can:4157
		["set_universal_transfer_box_data"] = set_universal_transfer_box_data, -- models/free-market.can:4158
		["set_universal_bin_box_data"] = set_universal_bin_box_data, -- models/free-market.can:4159
		["set_transfer_box_data"] = set_transfer_box_data, -- models/free-market.can:4160
		["set_bin_box_data"] = set_bin_box_data, -- models/free-market.can:4161
		["set_pull_box_data"] = set_pull_box_data, -- models/free-market.can:4162
		["set_buy_box_data"] = set_buy_box_data, -- models/free-market.can:4163
		["set_item_limit"] = function(item_name, force_index, count) -- models/free-market.can:4164
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4165
			if f_storages_limit == nil then -- models/free-market.can:4166
				return  -- models/free-market.can:4166
			end -- models/free-market.can:4166
			f_storages_limit[item_name] = count -- models/free-market.can:4167
		end, -- models/free-market.can:4167
		["set_default_storage_limit"] = function(force_index, count) -- models/free-market.can:4169
			local f_default_storage_limit = default_storage_limit[force_index] -- models/free-market.can:4170
			if f_default_storage_limit == nil then -- models/free-market.can:4171
				return  -- models/free-market.can:4171
			end -- models/free-market.can:4171
			default_storage_limit[force_index] = count -- models/free-market.can:4172
		end, -- models/free-market.can:4172
		["set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4174
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4175
			if f_sell_prices == nil then -- models/free-market.can:4176
				return  -- models/free-market.can:4176
			end -- models/free-market.can:4176
			local transferers = transfer_boxes[force_index][item_name] -- models/free-market.can:4178
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:4179
			if f_sell_prices[item_name] or transferers ~= nil or (count_in_storage and count_in_storage > 0) then -- models/free-market.can:4180
				f_sell_prices[item_name] = price -- models/free-market.can:4181
				inactive_sell_prices[force_index] = nil -- models/free-market.can:4182
			else -- models/free-market.can:4182
				f_sell_prices[item_name] = nil -- models/free-market.can:4184
				inactive_sell_prices[force_index][item_name] = price -- models/free-market.can:4185
			end -- models/free-market.can:4185
		end, -- models/free-market.can:4185
		["set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4188
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4189
			if f_buy_prices == nil then -- models/free-market.can:4190
				return  -- models/free-market.can:4190
			end -- models/free-market.can:4190
			local f_buy_boxes = buy_boxes[force_index][item_name] -- models/free-market.can:4192
			if f_buy_prices[item_name] or f_buy_boxes ~= nil then -- models/free-market.can:4193
				f_buy_prices[item_name] = price -- models/free-market.can:4194
				inactive_buy_prices[force_index] = nil -- models/free-market.can:4195
			else -- models/free-market.can:4195
				f_buy_prices[item_name] = nil -- models/free-market.can:4197
				inactive_buy_prices[force_index][item_name] = price -- models/free-market.can:4198
			end -- models/free-market.can:4198
		end, -- models/free-market.can:4198
		["force_set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4201
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4202
			if f_sell_prices == nil then -- models/free-market.can:4203
				return  -- models/free-market.can:4203
			end -- models/free-market.can:4203
			f_sell_prices[item_name] = price -- models/free-market.can:4204
			inactive_sell_prices[force_index][item_name] = nil -- models/free-market.can:4205
		end, -- models/free-market.can:4205
		["force_set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4207
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4208
			if f_buy_prices == nil then -- models/free-market.can:4209
				return  -- models/free-market.can:4209
			end -- models/free-market.can:4209
			f_buy_prices[item_name] = price -- models/free-market.can:4210
			inactive_buy_prices[force_index][item_name] = nil -- models/free-market.can:4211
		end, -- models/free-market.can:4211
		["reset_AI_force_storage"] = function(force_index) -- models/free-market.can:4213
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4214
			if f_sell_prices == nil then -- models/free-market.can:4215
				return  -- models/free-market.can:4215
			end -- models/free-market.can:4215
			local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:4217
			for item_name, price in pairs(f_inactive_sell_prices) do -- models/free-market.can:4218
				f_sell_prices[item_name] = price -- models/free-market.can:4219
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:4220
			end -- models/free-market.can:4220
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4222
			local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:4223
			for item_name, price in pairs(f_inactive_buy_prices) do -- models/free-market.can:4224
				f_buy_prices[item_name] = price -- models/free-market.can:4225
				f_inactive_buy_prices[item_name] = nil -- models/free-market.can:4226
			end -- models/free-market.can:4226
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4230
			local f_storage = storages[force_index] -- models/free-market.can:4231
			for item_name in pairs(f_buy_prices) do -- models/free-market.can:4232
				f_storage[item_name] = 2000000000 -- models/free-market.can:4233
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4234
			end -- models/free-market.can:4234
			for item_name in pairs(f_sell_prices) do -- models/free-market.can:4236
				f_storage[item_name] = 2000000000 -- models/free-market.can:4237
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4238
			end -- models/free-market.can:4238
		end, -- models/free-market.can:4238
		["get_item_limit"] = function(item_name, force_index) -- models/free-market.can:4241
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4242
			if f_storages_limit == nil then -- models/free-market.can:4243
				return  -- models/free-market.can:4243
			end -- models/free-market.can:4243
			return f_storages_limit[item_name] -- models/free-market.can:4244
		end, -- models/free-market.can:4244
		["get_default_storage_limit"] = function(force_index) -- models/free-market.can:4246
			return default_storage_limit[force_index] -- models/free-market.can:4247
		end, -- models/free-market.can:4247
		["get_inactive_universal_transfer_boxes"] = function() -- models/free-market.can:4249
			return inactive_universal_transfer_boxes -- models/free-market.can:4249
		end, -- models/free-market.can:4249
		["get_inactive_universal_bin_boxes"] = function() -- models/free-market.can:4250
			return inactive_universal_bin_boxes -- models/free-market.can:4250
		end, -- models/free-market.can:4250
		["get_inactive_bin_boxes"] = function() -- models/free-market.can:4251
			return inactive_bin_boxes -- models/free-market.can:4251
		end, -- models/free-market.can:4251
		["get_inactive_transfer_boxes"] = function() -- models/free-market.can:4252
			return inactive_transfer_boxes -- models/free-market.can:4252
		end, -- models/free-market.can:4252
		["get_inactive_sell_prices"] = function() -- models/free-market.can:4253
			return inactive_sell_prices -- models/free-market.can:4253
		end, -- models/free-market.can:4253
		["get_inactive_buy_prices"] = function() -- models/free-market.can:4254
			return inactive_buy_prices -- models/free-market.can:4254
		end, -- models/free-market.can:4254
		["get_inactive_buy_boxes"] = function() -- models/free-market.can:4255
			return inactive_buy_boxes -- models/free-market.can:4255
		end, -- models/free-market.can:4255
		["get_universal_bin_boxes"] = function() -- models/free-market.can:4256
			return universal_bin_boxes -- models/free-market.can:4256
		end, -- models/free-market.can:4256
		["get_transfer_boxes"] = function() -- models/free-market.can:4257
			return transfer_boxes -- models/free-market.can:4257
		end, -- models/free-market.can:4257
		["get_bin_boxes"] = function() -- models/free-market.can:4258
			return bin_boxes -- models/free-market.can:4258
		end, -- models/free-market.can:4258
		["get_pull_boxes"] = function() -- models/free-market.can:4259
			return pull_boxes -- models/free-market.can:4259
		end, -- models/free-market.can:4259
		["get_buy_boxes"] = function() -- models/free-market.can:4260
			return buy_boxes -- models/free-market.can:4260
		end, -- models/free-market.can:4260
		["get_sell_prices"] = function() -- models/free-market.can:4261
			return sell_prices -- models/free-market.can:4261
		end, -- models/free-market.can:4261
		["get_buy_prices"] = function() -- models/free-market.can:4262
			return buy_prices -- models/free-market.can:4262
		end, -- models/free-market.can:4262
		["get_embargoes"] = function() -- models/free-market.can:4263
			return embargoes -- models/free-market.can:4263
		end, -- models/free-market.can:4263
		["get_open_box"] = function() -- models/free-market.can:4264
			return open_box -- models/free-market.can:4264
		end, -- models/free-market.can:4264
		["get_all_boxes"] = function() -- models/free-market.can:4265
			return all_boxes -- models/free-market.can:4265
		end, -- models/free-market.can:4265
		["get_active_forces"] = function() -- models/free-market.can:4266
			return active_forces -- models/free-market.can:4266
		end, -- models/free-market.can:4266
		["get_storages"] = function() -- models/free-market.can:4267
			return storages -- models/free-market.can:4267
		end -- models/free-market.can:4267
	}) -- models/free-market.can:4267
end -- models/free-market.can:4267
local function link_data() -- models/free-market.can:4271
	mod_data = global["free_market"] -- models/free-market.can:4272
	bin_boxes = mod_data["bin_boxes"] -- models/free-market.can:4273
	inactive_bin_boxes = mod_data["inactive_bin_boxes"] -- models/free-market.can:4274
	universal_bin_boxes = mod_data["universal_bin_boxes"] -- models/free-market.can:4275
	inactive_universal_bin_boxes = mod_data["universal_inactive_bin_boxes"] -- models/free-market.can:4276
	pull_boxes = mod_data["pull_boxes"] -- models/free-market.can:4277
	inactive_universal_transfer_boxes = mod_data["inactive_universal_transfer_boxes"] -- models/free-market.can:4278
	inactive_transfer_boxes = mod_data["inactive_transfer_boxes"] -- models/free-market.can:4279
	inactive_buy_boxes = mod_data["inactive_buy_boxes"] -- models/free-market.can:4280
	universal_transfer_boxes = mod_data["universal_transfer_boxes"] -- models/free-market.can:4281
	transfer_boxes = mod_data["transfer_boxes"] -- models/free-market.can:4282
	buy_boxes = mod_data["buy_boxes"] -- models/free-market.can:4283
	embargoes = mod_data["embargoes"] -- models/free-market.can:4284
	inactive_sell_prices = mod_data["inactive_sell_prices"] -- models/free-market.can:4285
	inactive_buy_prices = mod_data["inactive_buy_prices"] -- models/free-market.can:4286
	sell_prices = mod_data["sell_prices"] -- models/free-market.can:4287
	buy_prices = mod_data["buy_prices"] -- models/free-market.can:4288
	item_HUD = mod_data["item_hinter"] -- models/free-market.can:4289
	open_box = mod_data["open_box"] -- models/free-market.can:4290
	all_boxes = mod_data["all_boxes"] -- models/free-market.can:4291
	active_forces = mod_data["active_forces"] -- models/free-market.can:4292
	default_storage_limit = mod_data["default_storage_limit"] -- models/free-market.can:4293
	storages_limit = mod_data["storages_limit"] -- models/free-market.can:4294
	storages = mod_data["storages"] -- models/free-market.can:4295
end -- models/free-market.can:4295
local function update_global_data() -- models/free-market.can:4298
	global["free_market"] = global["free_market"] or {} -- models/free-market.can:4299
	mod_data = global["free_market"] -- models/free-market.can:4300
	mod_data["item_hinter"] = mod_data["item_hinter"] or {} -- models/free-market.can:4301
	mod_data["open_box"] = {} -- models/free-market.can:4302
	mod_data["active_forces"] = mod_data["active_forces"] or {} -- models/free-market.can:4303
	mod_data["bin_boxes"] = mod_data["bin_boxes"] or {} -- models/free-market.can:4304
	mod_data["inactive_bin_boxes"] = mod_data["inactive_bin_boxes"] or {} -- models/free-market.can:4305
	mod_data["universal_bin_boxes"] = mod_data["universal_bin_boxes"] or {} -- models/free-market.can:4306
	mod_data["universal_inactive_bin_boxes"] = mod_data["universal_inactive_bin_boxes"] or {} -- models/free-market.can:4307
	mod_data["inactive_universal_transfer_boxes"] = mod_data["inactive_universal_transfer_boxes"] or {} -- models/free-market.can:4308
	mod_data["inactive_transfer_boxes"] = mod_data["inactive_transfer_boxes"] or {} -- models/free-market.can:4309
	mod_data["inactive_buy_boxes"] = mod_data["inactive_buy_boxes"] or {} -- models/free-market.can:4310
	mod_data["universal_transfer_boxes"] = mod_data["universal_transfer_boxes"] or {} -- models/free-market.can:4311
	mod_data["transfer_boxes"] = mod_data["transfer_boxes"] or {} -- models/free-market.can:4312
	mod_data["pull_boxes"] = mod_data["pull_boxes"] or {} -- models/free-market.can:4313
	mod_data["buy_boxes"] = mod_data["buy_boxes"] or {} -- models/free-market.can:4314
	mod_data["inactive_sell_prices"] = mod_data["inactive_sell_prices"] or {} -- models/free-market.can:4315
	mod_data["inactive_buy_prices"] = mod_data["inactive_buy_prices"] or {} -- models/free-market.can:4316
	mod_data["sell_prices"] = mod_data["sell_prices"] or {} -- models/free-market.can:4317
	mod_data["buy_prices"] = mod_data["buy_prices"] or {} -- models/free-market.can:4318
	mod_data["embargoes"] = mod_data["embargoes"] or {} -- models/free-market.can:4319
	mod_data["all_boxes"] = mod_data["all_boxes"] or {} -- models/free-market.can:4320
	mod_data["default_storage_limit"] = mod_data["default_storage_limit"] or {} -- models/free-market.can:4321
	mod_data["storages_limit"] = mod_data["storages_limit"] or {} -- models/free-market.can:4322
	mod_data["storages"] = mod_data["storages"] or {} -- models/free-market.can:4323
	link_data() -- models/free-market.can:4325
	clear_invalid_data() -- models/free-market.can:4327
	for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:4329
		if item["stack_size"] <= 5 then -- models/free-market.can:4330
			for _, f_storage_limit in pairs(storages_limit) do -- models/free-market.can:4331
				f_storage_limit[item_name] = f_storage_limit[item_name] or 1 -- models/free-market.can:4332
			end -- models/free-market.can:4332
		end -- models/free-market.can:4332
	end -- models/free-market.can:4332
	init_force_data(game["forces"]["player"]["index"]) -- models/free-market.can:4337
	for _, force in pairs(game["forces"]) do -- models/free-market.can:4339
		if # force["players"] > 0 then -- models/free-market.can:4340
			init_force_data(force["index"]) -- models/free-market.can:4341
		end -- models/free-market.can:4341
	end -- models/free-market.can:4341
	for _, player in pairs(game["players"]) do -- models/free-market.can:4346
		if player["valid"] then -- models/free-market.can:4347
			local relative = player["gui"]["relative"] -- models/free-market.can:4348
			if relative["FM_buttons"] == nil then -- models/free-market.can:4349
				create_left_relative_gui(player) -- models/free-market.can:4350
			end -- models/free-market.can:4350
			if relative["FM_boxes_frame"] == nil then -- models/free-market.can:4352
				create_top_relative_gui(player) -- models/free-market.can:4353
			end -- models/free-market.can:4353
		end -- models/free-market.can:4353
	end -- models/free-market.can:4353
end -- models/free-market.can:4353
local function on_configuration_changed(event) -- models/free-market.can:4359
	update_global_data() -- models/free-market.can:4360
	local mod_changes = event["mod_changes"]["iFreeMarket"] -- models/free-market.can:4362
	if not (mod_changes and mod_changes["old_version"]) then -- models/free-market.can:4363
		return  -- models/free-market.can:4363
	end -- models/free-market.can:4363
	local version = tonumber(string["gmatch"](mod_changes["old_version"], "%d+.%d+")()) -- models/free-market.can:4365
	if version < 0.34 then -- models/free-market.can:4367
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4368
			local index = force["index"] -- models/free-market.can:4369
			if sell_prices[index] then -- models/free-market.can:4370
				init_force_data(index) -- models/free-market.can:4371
			end -- models/free-market.can:4371
		end -- models/free-market.can:4371
		for _, player in pairs(game["players"]) do -- models/free-market.can:4375
			if player["valid"] then -- models/free-market.can:4376
				create_top_relative_gui(player) -- models/free-market.can:4377
			end -- models/free-market.can:4377
		end -- models/free-market.can:4377
	end -- models/free-market.can:4377
	if version < 0.33 then -- models/free-market.can:4382
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4383
			local index = force["index"] -- models/free-market.can:4384
			if sell_prices[index] and mod_data["sell_boxes"] then -- models/free-market.can:4386
				transfer_boxes[index] = mod_data["sell_boxes"][index] -- models/free-market.can:4387
				inactive_transfer_boxes[index] = mod_data["inactive_sell_boxes"][index] -- models/free-market.can:4388
			end -- models/free-market.can:4388
			mod_data["sell_boxes"] = nil -- models/free-market.can:4390
			mod_data["inactive_sell_boxes"] = nil -- models/free-market.can:4391
		end -- models/free-market.can:4391
		local sprite_data = { -- models/free-market.can:4394
			["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:4395
			["only_in_alt_mode"] = true, -- models/free-market.can:4396
			["x_scale"] = 0.4, -- models/free-market.can:4397
			["y_scale"] = 0.4 -- models/free-market.can:4397
		} -- models/free-market.can:4397
		for _, box_data in pairs(all_boxes) do -- models/free-market.can:4399
			rendering_destroy(box_data[2]) -- models/free-market.can:4400
			local entity = box_data[1] -- models/free-market.can:4402
			sprite_data["target"] = entity -- models/free-market.can:4403
			sprite_data["surface"] = entity["surface"] -- models/free-market.can:4404
			if is_public_titles == false then -- models/free-market.can:4405
				sprite_data["forces"] = { entity["force"] } -- models/free-market.can:4406
			end -- models/free-market.can:4406
			local box_type = box_data[3] -- models/free-market.can:4409
			if box_type == 2 then -- models/free-market.can:1
				box_data[3] = 4 -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transfer" -- models/free-market.can:4412
			elseif box_type == 3 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_pull_out" -- models/free-market.can:4414
			elseif box_type == 1 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_buy" -- models/free-market.can:4416
			end -- models/free-market.can:4416
			box_data[2] = draw_sprite(sprite_data) -- models/free-market.can:4419
		end -- models/free-market.can:4419
		for _, player in pairs(game["players"]) do -- models/free-market.can:4422
			if player["valid"] then -- models/free-market.can:4423
				create_top_relative_gui(player) -- models/free-market.can:4424
			end -- models/free-market.can:4424
		end -- models/free-market.can:4424
	end -- models/free-market.can:4424
	if version < 0.32 then -- models/free-market.can:4429
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4430
			local index = force["index"] -- models/free-market.can:4431
			if transfer_boxes[index] then -- models/free-market.can:4432
				init_force_data(index) -- models/free-market.can:4433
				default_storage_limit[index] = max_storage_threshold -- models/free-market.can:4434
			end -- models/free-market.can:4434
		end -- models/free-market.can:4434
	end -- models/free-market.can:4434
	if version < 0.31 then -- models/free-market.can:4439
		for _, player in pairs(game["players"]) do -- models/free-market.can:4440
			if player["valid"] then -- models/free-market.can:4441
				delete_item_price_HUD(player) -- models/free-market.can:4442
				if player["connected"] then -- models/free-market.can:4443
					create_item_price_HUD(player) -- models/free-market.can:4444
				end -- models/free-market.can:4444
			end -- models/free-market.can:4444
		end -- models/free-market.can:4444
	end -- models/free-market.can:4444
	if version < 0.30 then -- models/free-market.can:4450
		for _, player in pairs(game["players"]) do -- models/free-market.can:4451
			if player["valid"] then -- models/free-market.can:4452
				local screen = player["gui"]["screen"] -- models/free-market.can:4453
				local frame = screen["FM_prices_frame"] -- models/free-market.can:4454
				if frame then -- models/free-market.can:4455
					frame["destroy"]() -- models/free-market.can:4456
				end -- models/free-market.can:4456
			end -- models/free-market.can:4456
		end -- models/free-market.can:4456
	end -- models/free-market.can:4456
	if version < 0.29 then -- models/free-market.can:4462
		for _, player in pairs(game["players"]) do -- models/free-market.can:4463
			if player["valid"] then -- models/free-market.can:4464
				local screen = player["gui"]["screen"] -- models/free-market.can:4465
				if screen["FM_sell_prices_frame"] then -- models/free-market.can:4466
					screen["FM_sell_prices_frame"]["destroy"]() -- models/free-market.can:4467
				end -- models/free-market.can:4467
				if screen["FM_buy_prices_frame"] then -- models/free-market.can:4469
					screen["FM_buy_prices_frame"]["destroy"]() -- models/free-market.can:4470
				end -- models/free-market.can:4470
				switch_buy_prices_gui(player) -- models/free-market.can:4472
				switch_sell_prices_gui(player) -- models/free-market.can:4473
			end -- models/free-market.can:4473
		end -- models/free-market.can:4473
	end -- models/free-market.can:4473
	if version < 0.28 then -- models/free-market.can:4478
		for _, player in pairs(game["players"]) do -- models/free-market.can:4479
			if player["valid"] and player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4480
				create_item_price_HUD(player) -- models/free-market.can:4481
			end -- models/free-market.can:4481
		end -- models/free-market.can:4481
	end -- models/free-market.can:4481
	if version < 0.21 then -- models/free-market.can:4486
		for _, player in pairs(game["players"]) do -- models/free-market.can:4487
			if player["valid"] then -- models/free-market.can:4488
				create_top_relative_gui(player) -- models/free-market.can:4489
			end -- models/free-market.can:4489
		end -- models/free-market.can:4489
	end -- models/free-market.can:4489
	if version < 0.22 then -- models/free-market.can:4494
		for _, player in pairs(game["players"]) do -- models/free-market.can:4495
			if player["valid"] then -- models/free-market.can:4496
				create_left_relative_gui(player) -- models/free-market.can:4497
			end -- models/free-market.can:4497
		end -- models/free-market.can:4497
	end -- models/free-market.can:4497
	if version < 0.26 then -- models/free-market.can:4502
		for _, player in pairs(game["players"]) do -- models/free-market.can:4503
			if player["valid"] then -- models/free-market.can:4504
				switch_sell_prices_gui(player) -- models/free-market.can:4505
				switch_buy_prices_gui(player) -- models/free-market.can:4506
			end -- models/free-market.can:4506
		end -- models/free-market.can:4506
		game["print"]({ -- models/free-market.can:4509
			"", -- models/free-market.can:4509
			{ "mod-name.free-market" }, -- models/free-market.can:4509
			COLON, -- models/free-market.can:4509
			" added price notification with settings" -- models/free-market.can:4509
		}) -- models/free-market.can:4509
	end -- models/free-market.can:4509
end -- models/free-market.can:4509
do -- models/free-market.can:4514
	local function set_filters() -- models/free-market.can:4514
		local filters = { -- models/free-market.can:4515
			{ -- models/free-market.can:4516
				["filter"] = "type", -- models/free-market.can:4516
				["mode"] = "or", -- models/free-market.can:4516
				["type"] = "container" -- models/free-market.can:4516
			}, -- models/free-market.can:4516
			{ -- models/free-market.can:4517
				["filter"] = "type", -- models/free-market.can:4517
				["mode"] = "or", -- models/free-market.can:4517
				["type"] = "logistic-container" -- models/free-market.can:4517
			} -- models/free-market.can:4517
		} -- models/free-market.can:4517
		script["set_event_filter"](defines["events"]["on_entity_died"], filters) -- models/free-market.can:4519
		script["set_event_filter"](defines["events"]["on_robot_mined_entity"], filters) -- models/free-market.can:4520
		script["set_event_filter"](defines["events"]["script_raised_destroy"], filters) -- models/free-market.can:4521
		script["set_event_filter"](defines["events"]["on_player_mined_entity"], filters) -- models/free-market.can:4522
	end -- models/free-market.can:4522
	M["on_load"] = function() -- models/free-market.can:4525
		link_data() -- models/free-market.can:4526
		set_filters() -- models/free-market.can:4527
	end -- models/free-market.can:4527
	M["on_init"] = function() -- models/free-market.can:4529
		update_global_data() -- models/free-market.can:4530
		set_filters() -- models/free-market.can:4531
	end -- models/free-market.can:4531
end -- models/free-market.can:4531
M["on_configuration_changed"] = on_configuration_changed -- models/free-market.can:4534
M["add_remote_interface"] = add_remote_interface -- models/free-market.can:4535
M["events"] = { -- models/free-market.can:4540
	[defines["events"]["on_surface_deleted"]] = clear_invalid_entities, -- models/free-market.can:4541
	[defines["events"]["on_surface_cleared"]] = clear_invalid_entities, -- models/free-market.can:4542
	[defines["events"]["on_chunk_deleted"]] = clear_invalid_entities, -- models/free-market.can:4543
	[defines["events"]["on_player_created"]] = on_player_created, -- models/free-market.can:4544
	[defines["events"]["on_player_joined_game"]] = on_player_joined_game, -- models/free-market.can:4545
	[defines["events"]["on_player_left_game"]] = on_player_left_game, -- models/free-market.can:4546
	[defines["events"]["on_player_cursor_stack_changed"]] = function(event) -- models/free-market.can:4547
		pcall(on_player_cursor_stack_changed, event) -- models/free-market.can:4548
	end, -- models/free-market.can:4548
	[defines["events"]["on_player_removed"]] = delete_player_data, -- models/free-market.can:4550
	[defines["events"]["on_player_changed_force"]] = on_player_changed_force, -- models/free-market.can:4551
	[defines["events"]["on_player_changed_surface"]] = on_player_changed_surface, -- models/free-market.can:4552
	[defines["events"]["on_player_selected_area"]] = on_player_selected_area, -- models/free-market.can:4553
	[defines["events"]["on_player_alt_selected_area"]] = on_player_alt_selected_area, -- models/free-market.can:4554
	[defines["events"]["on_player_mined_entity"]] = clear_box_data, -- models/free-market.can:4555
	[defines["events"]["on_gui_selection_state_changed"]] = on_gui_selection_state_changed, -- models/free-market.can:4556
	[defines["events"]["on_gui_elem_changed"]] = on_gui_elem_changed, -- models/free-market.can:4557
	[defines["events"]["on_gui_click"]] = function(event) -- models/free-market.can:4558
		on_gui_click(event) -- models/free-market.can:4559
	end, -- models/free-market.can:4559
	[defines["events"]["on_gui_closed"]] = on_gui_closed, -- models/free-market.can:4561
	[defines["events"]["on_selected_entity_changed"]] = on_selected_entity_changed, -- models/free-market.can:4562
	[defines["events"]["on_force_created"]] = on_force_created, -- models/free-market.can:4563
	[defines["events"]["on_forces_merging"]] = on_forces_merging, -- models/free-market.can:4564
	[defines["events"]["on_runtime_mod_setting_changed"]] = on_runtime_mod_setting_changed, -- models/free-market.can:4565
	[defines["events"]["on_force_cease_fire_changed"]] = function(event) -- models/free-market.can:4566
		if is_auto_embargo then -- models/free-market.can:4568
			pcall(on_force_cease_fire_changed, event) -- models/free-market.can:4569
		end -- models/free-market.can:4569
	end, -- models/free-market.can:4569
	[defines["events"]["on_robot_mined_entity"]] = clear_box_data, -- models/free-market.can:4572
	[defines["events"]["script_raised_destroy"]] = clear_box_data, -- models/free-market.can:4573
	[defines["events"]["on_entity_died"]] = clear_box_data, -- models/free-market.can:4574
	["FM_set-pull-box"] = function(event) -- models/free-market.can:4575
		pcall(set_pull_box_key_pressed, event) -- models/free-market.can:4576
	end, -- models/free-market.can:4576
	["FM_set-transfer-box"] = function(event) -- models/free-market.can:4578
		pcall(set_transfer_box_key_pressed, event) -- models/free-market.can:4579
	end, -- models/free-market.can:4579
	["FM_set-universal-transfer-box"] = function(event) -- models/free-market.can:4581
		pcall(set_universal_transfer_box_key_pressed, event) -- models/free-market.can:4582
	end, -- models/free-market.can:4582
	["FM_set-bin-box"] = function(event) -- models/free-market.can:4584
		pcall(set_bin_box_key_pressed, event) -- models/free-market.can:4585
	end, -- models/free-market.can:4585
	["FM_set-universal-bin-box"] = function(event) -- models/free-market.can:4587
		pcall(set_universal_bin_box_key_pressed, event) -- models/free-market.can:4588
	end, -- models/free-market.can:4588
	["FM_set-buy-box"] = function(event) -- models/free-market.can:4590
		pcall(set_buy_box_key_pressed, event) -- models/free-market.can:4591
	end -- models/free-market.can:4591
} -- models/free-market.can:4591
M["on_nth_tick"] = { -- models/free-market.can:4595
	[update_buy_tick] = check_buy_boxes, -- models/free-market.can:4596
	[update_transfer_tick] = check_transfer_boxes, -- models/free-market.can:4597
	[update_pull_tick] = check_pull_boxes, -- models/free-market.can:4598
	[CHECK_FORCES_TICK] = check_forces, -- models/free-market.can:4599
	[CHECK_TEAMS_DATA_TICK] = check_teams_data -- models/free-market.can:4600
} -- models/free-market.can:4600
M["commands"] = { -- models/free-market.can:4603
	["embargo"] = function(cmd) -- models/free-market.can:4604
		open_embargo_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4605
	end, -- models/free-market.can:4605
	["prices"] = function(cmd) -- models/free-market.can:4607
		switch_prices_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4608
	end, -- models/free-market.can:4608
	["price_list"] = function(cmd) -- models/free-market.can:4610
		open_price_list_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4611
	end, -- models/free-market.can:4611
	["storage"] = function(cmd) -- models/free-market.can:4613
		open_storage_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4614
	end -- models/free-market.can:4614
} -- models/free-market.can:4614
return M -- models/free-market.can:4619
