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
clear_invalid_data = nil -- models/free-market.can:262
print_force_data = function(target, getter) -- models/free-market.can:266
	if getter then -- models/free-market.can:267
		if not getter["valid"] then -- models/free-market.can:268
			log("Invalid object") -- models/free-market.can:269
			return  -- models/free-market.can:270
		end -- models/free-market.can:270
	else -- models/free-market.can:270
		getter = game -- models/free-market.can:273
	end -- models/free-market.can:273
	local index -- models/free-market.can:276
	local object_name = target["object_name"] -- models/free-market.can:277
	if object_name == "LuaPlayer" then -- models/free-market.can:278
		index = target["force"]["index"] -- models/free-market.can:279
	elseif object_name == "LuaForce" then -- models/free-market.can:280
		index = target["index"] -- models/free-market.can:281
	else -- models/free-market.can:281
		log("Invalid type") -- models/free-market.can:283
		return  -- models/free-market.can:284
	end -- models/free-market.can:284
	local print_to_target = getter["print"] -- models/free-market.can:287
	print_to_target("") -- models/free-market.can:288
	print_to_target("Inactive sell prices:" .. serpent["line"](inactive_sell_prices[index])) -- models/free-market.can:289
	print_to_target("Inactive buy prices:" .. serpent["line"](inactive_buy_prices[index])) -- models/free-market.can:290
	print_to_target("Sell prices:" .. serpent["line"](sell_prices[index])) -- models/free-market.can:291
	print_to_target("Buy prices:" .. serpent["line"](buy_prices[index])) -- models/free-market.can:292
	print_to_target("Universal transferers:" .. serpent["line"](universal_transfer_boxes[index])) -- models/free-market.can:293
	print_to_target("Transferers:" .. serpent["line"](transfer_boxes[index])) -- models/free-market.can:294
	print_to_target("Bin boxes:" .. serpent["line"](bin_boxes[index])) -- models/free-market.can:295
	print_to_target("Universal bin boxes:" .. serpent["line"](universal_bin_boxes[index])) -- models/free-market.can:296
	print_to_target("Pull boxes:" .. serpent["line"](pull_boxes[index])) -- models/free-market.can:297
	print_to_target("Buy boxes:" .. serpent["line"](buy_boxes[index])) -- models/free-market.can:298
	print_to_target("Embargoes:" .. serpent["line"](embargoes[index])) -- models/free-market.can:299
	print_to_target("Storage:" .. serpent["line"](storages[index])) -- models/free-market.can:300
end -- models/free-market.can:300
resetBuyBoxes = function(force_index) -- models/free-market.can:305
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:306
	if f_buy_boxes == nil then -- models/free-market.can:307
		return  -- models/free-market.can:307
	end -- models/free-market.can:307
	for _, forces_data in pairs(f_buy_boxes) do -- models/free-market.can:309
		for _, entities_data in pairs(forces_data) do -- models/free-market.can:310
			local unit_number = entities_data[1]["unit_number"] -- models/free-market.can:311
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:312
			all_boxes[unit_number] = nil -- models/free-market.can:313
		end -- models/free-market.can:313
	end -- models/free-market.can:313
	buy_boxes[force_index] = {} -- models/free-market.can:316
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:318
	if f_buy_prices == nil then -- models/free-market.can:319
		return  -- models/free-market.can:319
	end -- models/free-market.can:319
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:320
	if f_inactive_buy_prices == nil then -- models/free-market.can:321
		return  -- models/free-market.can:321
	end -- models/free-market.can:321
	for item_name, price in pairs(f_buy_prices) do -- models/free-market.can:322
		f_inactive_buy_prices[item_name] = price -- models/free-market.can:323
	end -- models/free-market.can:323
	buy_prices[force_index] = {} -- models/free-market.can:325
end -- models/free-market.can:325
resetTransferBoxes = function(force_index) -- models/free-market.can:330
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:331
	if f_transfer_boxes == nil then -- models/free-market.can:332
		return  -- models/free-market.can:332
	end -- models/free-market.can:332
	for _, entities_data in pairs(f_transfer_boxes) do -- models/free-market.can:334
		for i = 1, # entities_data do -- models/free-market.can:335
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:336
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:337
			all_boxes[unit_number] = nil -- models/free-market.can:338
		end -- models/free-market.can:338
	end -- models/free-market.can:338
	transfer_boxes[force_index] = {} -- models/free-market.can:341
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:343
	if f_inactive_sell_prices == nil then -- models/free-market.can:344
		return  -- models/free-market.can:344
	end -- models/free-market.can:344
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:345
	if f_sell_prices == nil then -- models/free-market.can:346
		return  -- models/free-market.can:346
	end -- models/free-market.can:346
	local storage = storages[force_index] -- models/free-market.can:347
	if storage == nil then -- models/free-market.can:348
		return  -- models/free-market.can:348
	end -- models/free-market.can:348
	for item_name, price in pairs(f_sell_prices) do -- models/free-market.can:350
		local count = storage[item_name] -- models/free-market.can:351
		if count == nil or count <= 0 then -- models/free-market.can:352
			f_inactive_sell_prices[item_name] = price -- models/free-market.can:353
			f_sell_prices[item_name] = nil -- models/free-market.can:354
		end -- models/free-market.can:354
	end -- models/free-market.can:354
end -- models/free-market.can:354
resetUniversalTransferBoxes = function(force_index) -- models/free-market.can:361
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:362
	if entities == nil then -- models/free-market.can:363
		return  -- models/free-market.can:363
	end -- models/free-market.can:363
	for i = 1, # entities do -- models/free-market.can:365
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:366
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:367
		all_boxes[unit_number] = nil -- models/free-market.can:368
	end -- models/free-market.can:368
	universal_transfer_boxes[force_index] = {} -- models/free-market.can:370
end -- models/free-market.can:370
resetBinBoxes = function(force_index) -- models/free-market.can:375
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:376
	if f_bin_boxes == nil then -- models/free-market.can:377
		return  -- models/free-market.can:377
	end -- models/free-market.can:377
	for _, entities_data in pairs(f_bin_boxes) do -- models/free-market.can:379
		for i = 1, # entities_data do -- models/free-market.can:380
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:381
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:382
			all_boxes[unit_number] = nil -- models/free-market.can:383
		end -- models/free-market.can:383
	end -- models/free-market.can:383
	bin_boxes[force_index] = {} -- models/free-market.can:386
end -- models/free-market.can:386
resetUniversalBinBoxes = function(force_index) -- models/free-market.can:391
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:392
	if entities == nil then -- models/free-market.can:393
		return  -- models/free-market.can:393
	end -- models/free-market.can:393
	for i = 1, # entities do -- models/free-market.can:395
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:396
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:397
		all_boxes[unit_number] = nil -- models/free-market.can:398
	end -- models/free-market.can:398
	universal_bin_boxes[force_index] = {} -- models/free-market.can:400
end -- models/free-market.can:400
resetPullBoxes = function(force_index) -- models/free-market.can:405
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:406
	if f_pull_boxes == nil then -- models/free-market.can:407
		return  -- models/free-market.can:407
	end -- models/free-market.can:407
	for _, entities_data in pairs(f_pull_boxes) do -- models/free-market.can:409
		for i = 1, # entities_data do -- models/free-market.can:410
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:411
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:412
			all_boxes[unit_number] = nil -- models/free-market.can:413
		end -- models/free-market.can:413
	end -- models/free-market.can:413
	pull_boxes[force_index] = {} -- models/free-market.can:416
end -- models/free-market.can:416
resetAllBoxes = function(force_index) -- models/free-market.can:421
	resetTransferBoxes(force_index) -- models/free-market.can:422
	resetUniversalTransferBoxes(force_index) -- models/free-market.can:423
	resetBinBoxes(force_index) -- models/free-market.can:424
	resetUniversalBinBoxes(force_index) -- models/free-market.can:425
	resetPullBoxes(force_index) -- models/free-market.can:426
	resetBuyBoxes(force_index) -- models/free-market.can:427
end -- models/free-market.can:427
getRconData = function(name) -- models/free-market.can:436
	print_to_rcon(game["table_to_json"](mod_data[name])) -- models/free-market.can:437
end -- models/free-market.can:437
getRconForceData = function(name, force) -- models/free-market.can:442
	if not force["valid"] then -- models/free-market.can:443
		return  -- models/free-market.can:443
	end -- models/free-market.can:443
	print_to_rcon(game["table_to_json"](mod_data[name][force["index"]])) -- models/free-market.can:444
end -- models/free-market.can:444
getRconForceDataByIndex = function(name, force_index) -- models/free-market.can:449
	print_to_rcon(game["table_to_json"](mod_data[name][force_index])) -- models/free-market.can:450
end -- models/free-market.can:450
local function clear_force_data(index) -- models/free-market.can:459
	default_storage_limit[index] = nil -- models/free-market.can:460
	inactive_sell_prices[index] = nil -- models/free-market.can:461
	inactive_buy_prices[index] = nil -- models/free-market.can:462
	bin_boxes[index] = nil -- models/free-market.can:463
	inactive_bin_boxes[index] = nil -- models/free-market.can:464
	universal_bin_boxes[index] = nil -- models/free-market.can:465
	inactive_universal_bin_boxes[index] = nil -- models/free-market.can:466
	inactive_universal_transfer_boxes[index] = nil -- models/free-market.can:467
	inactive_transfer_boxes[index] = nil -- models/free-market.can:468
	inactive_buy_boxes[index] = nil -- models/free-market.can:469
	storages_limit[index] = nil -- models/free-market.can:470
	sell_prices[index] = nil -- models/free-market.can:471
	buy_prices[index] = nil -- models/free-market.can:472
	pull_boxes[index] = nil -- models/free-market.can:473
	universal_transfer_boxes[index] = nil -- models/free-market.can:474
	transfer_boxes[index] = nil -- models/free-market.can:475
	buy_boxes[index] = nil -- models/free-market.can:476
	embargoes[index] = nil -- models/free-market.can:477
	storages[index] = nil -- models/free-market.can:478
	for _, force_data in pairs(embargoes) do -- models/free-market.can:480
		force_data[index] = nil -- models/free-market.can:481
	end -- models/free-market.can:481
	for i, force_index in pairs(active_forces) do -- models/free-market.can:484
		if force_index == index then -- models/free-market.can:485
			tremove(active_forces, i) -- models/free-market.can:486
			break -- models/free-market.can:487
		end -- models/free-market.can:487
	end -- models/free-market.can:487
end -- models/free-market.can:487
local function init_force_data(index) -- models/free-market.can:493
	inactive_sell_prices[index] = inactive_sell_prices[index] or {} -- models/free-market.can:494
	inactive_buy_prices[index] = inactive_buy_prices[index] or {} -- models/free-market.can:495
	bin_boxes[index] = bin_boxes[index] or {} -- models/free-market.can:496
	inactive_bin_boxes[index] = inactive_bin_boxes[index] or {} -- models/free-market.can:497
	universal_bin_boxes[index] = universal_bin_boxes[index] or {} -- models/free-market.can:498
	inactive_universal_bin_boxes[index] = inactive_universal_bin_boxes[index] or {} -- models/free-market.can:499
	inactive_universal_transfer_boxes[index] = inactive_universal_transfer_boxes[index] or {} -- models/free-market.can:500
	inactive_transfer_boxes[index] = inactive_transfer_boxes[index] or {} -- models/free-market.can:501
	inactive_buy_boxes[index] = inactive_buy_boxes[index] or {} -- models/free-market.can:502
	sell_prices[index] = sell_prices[index] or {} -- models/free-market.can:503
	buy_prices[index] = buy_prices[index] or {} -- models/free-market.can:504
	pull_boxes[index] = pull_boxes[index] or {} -- models/free-market.can:505
	universal_transfer_boxes[index] = universal_transfer_boxes[index] or {} -- models/free-market.can:506
	transfer_boxes[index] = transfer_boxes[index] or {} -- models/free-market.can:507
	buy_boxes[index] = buy_boxes[index] or {} -- models/free-market.can:508
	embargoes[index] = embargoes[index] or {} -- models/free-market.can:509
	storages[index] = storages[index] or {} -- models/free-market.can:510
	if storages_limit[index] == nil then -- models/free-market.can:512
		storages_limit[index] = {} -- models/free-market.can:513
		local f_storages_limit = storages_limit[index] -- models/free-market.can:514
		for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:515
			if item["stack_size"] <= 5 then -- models/free-market.can:516
				f_storages_limit[item_name] = 1 -- models/free-market.can:517
			end -- models/free-market.can:517
		end -- models/free-market.can:517
	end -- models/free-market.can:517
end -- models/free-market.can:517
local function remove_certain_transfer_box(entity, box_data) -- models/free-market.can:525
	local force_index = entity["force"]["index"] -- models/free-market.can:526
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:527
	local item_name = box_data[5] -- models/free-market.can:528
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:529
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:530
	if entities == nil then -- models/free-market.can:531
		return  -- models/free-market.can:531
	end -- models/free-market.can:531
	for i = # entities, 1, - 1 do -- models/free-market.can:532
		if entities[i] == entity then -- models/free-market.can:533
			tremove(entities, i) -- models/free-market.can:534
			if # entities == 0 then -- models/free-market.can:535
				f_transfer_boxes[item_name] = nil -- models/free-market.can:536
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:537
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:538
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:539
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:540
					if sell_price then -- models/free-market.can:541
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:542
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:543
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:544
							f_sell_prices[item_name] = nil -- models/free-market.can:545
						end -- models/free-market.can:545
					end -- models/free-market.can:545
				end -- models/free-market.can:545
			end -- models/free-market.can:545
			return  -- models/free-market.can:550
		end -- models/free-market.can:550
	end -- models/free-market.can:550
end -- models/free-market.can:550
local function remove_certain_bin_box(entity, box_data) -- models/free-market.can:557
	local force_index = entity["force"]["index"] -- models/free-market.can:558
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:559
	local item_name = box_data[5] -- models/free-market.can:560
	local entities = f_bin_boxes[item_name] -- models/free-market.can:561
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:562
	if entities == nil then -- models/free-market.can:563
		return  -- models/free-market.can:563
	end -- models/free-market.can:563
	for i = # entities, 1, - 1 do -- models/free-market.can:564
		if entities[i] == entity then -- models/free-market.can:565
			tremove(entities, i) -- models/free-market.can:566
			if # entities == 0 then -- models/free-market.can:567
				f_bin_boxes[item_name] = nil -- models/free-market.can:568
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:569
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:570
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:571
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:572
					if sell_price and transfer_boxes[force_index][item_name] == nil then -- models/free-market.can:573
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:574
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:575
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:576
							f_sell_prices[item_name] = nil -- models/free-market.can:577
						end -- models/free-market.can:577
					end -- models/free-market.can:577
				end -- models/free-market.can:577
			end -- models/free-market.can:577
			return  -- models/free-market.can:582
		end -- models/free-market.can:582
	end -- models/free-market.can:582
end -- models/free-market.can:582
local function remove_certain_universal_transfer_box(entity) -- models/free-market.can:588
	local force_index = entity["force"]["index"] -- models/free-market.can:589
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:590
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:591
	if entities == nil then -- models/free-market.can:592
		return  -- models/free-market.can:592
	end -- models/free-market.can:592
	for i = # entities, 1, - 1 do -- models/free-market.can:593
		if entities[i] == entity then -- models/free-market.can:594
			tremove(entities, i) -- models/free-market.can:595
			return  -- models/free-market.can:596
		end -- models/free-market.can:596
	end -- models/free-market.can:596
end -- models/free-market.can:596
local function remove_certain_universal_bin_box(entity) -- models/free-market.can:602
	local force_index = entity["force"]["index"] -- models/free-market.can:603
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:604
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:605
	if entities == nil then -- models/free-market.can:606
		return  -- models/free-market.can:606
	end -- models/free-market.can:606
	for i = # entities, 1, - 1 do -- models/free-market.can:607
		if entities[i] == entity then -- models/free-market.can:608
			tremove(entities, i) -- models/free-market.can:609
			return  -- models/free-market.can:610
		end -- models/free-market.can:610
	end -- models/free-market.can:610
end -- models/free-market.can:610
local function remove_certain_buy_box(entity, box_data) -- models/free-market.can:617
	local force_index = entity["force"]["index"] -- models/free-market.can:618
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:619
	local item_name = box_data[5] -- models/free-market.can:620
	local items_data = f_buy_boxes[item_name] -- models/free-market.can:621
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:622
	if items_data == nil then -- models/free-market.can:623
		return  -- models/free-market.can:623
	end -- models/free-market.can:623
	for i = # items_data, 1, - 1 do -- models/free-market.can:624
		local buy_box = items_data[i] -- models/free-market.can:625
		if buy_box[1] == entity then -- models/free-market.can:626
			tremove(items_data, i) -- models/free-market.can:627
			if # items_data == 0 then -- models/free-market.can:628
				f_buy_boxes[item_name] = nil -- models/free-market.can:629
				local f_buy_prices = buy_prices[force_index] -- models/free-market.can:630
				local buy_price = f_buy_prices[item_name] -- models/free-market.can:631
				if buy_price then -- models/free-market.can:632
					inactive_buy_prices[force_index][item_name] = buy_price -- models/free-market.can:633
					f_buy_prices[item_name] = nil -- models/free-market.can:634
				end -- models/free-market.can:634
			end -- models/free-market.can:634
			return  -- models/free-market.can:637
		end -- models/free-market.can:637
	end -- models/free-market.can:637
end -- models/free-market.can:637
local function remove_certain_pull_box(entity, box_data) -- models/free-market.can:644
	local force_index = entity["force"]["index"] -- models/free-market.can:645
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:646
	local item_name = box_data[5] -- models/free-market.can:647
	local entities = f_pull_boxes[item_name] -- models/free-market.can:648
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:649
	if entities == nil then -- models/free-market.can:650
		return  -- models/free-market.can:650
	end -- models/free-market.can:650
	for i = # entities, 1, - 1 do -- models/free-market.can:651
		if entities[i] == entity then -- models/free-market.can:652
			tremove(entities, i) -- models/free-market.can:653
			if # entities == 0 then -- models/free-market.can:654
				f_pull_boxes[item_name] = nil -- models/free-market.can:655
			end -- models/free-market.can:655
			return  -- models/free-market.can:657
		end -- models/free-market.can:657
	end -- models/free-market.can:657
end -- models/free-market.can:657
local function change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:666
	local data = buy_boxes[entity["force"]["index"]][item_name] -- models/free-market.can:667
	for i = 1, # data do -- models/free-market.can:668
		local buy_box = data[i] -- models/free-market.can:669
		if buy_box[1] == entity then -- models/free-market.can:670
			buy_box[2] = count -- models/free-market.can:671
			return  -- models/free-market.can:672
		end -- models/free-market.can:672
	end -- models/free-market.can:672
end -- models/free-market.can:672
local function clear_invalid_embargoes() -- models/free-market.can:677
	local forces = game["forces"] -- models/free-market.can:678
	for index in pairs(embargoes) do -- models/free-market.can:679
		if forces[index] == nil then -- models/free-market.can:680
			embargoes[index] = nil -- models/free-market.can:681
		end -- models/free-market.can:681
	end -- models/free-market.can:681
	for _, forces_data in pairs(embargoes) do -- models/free-market.can:684
		for index in pairs(forces_data) do -- models/free-market.can:685
			if forces[index] == nil then -- models/free-market.can:686
				forces_data[index] = nil -- models/free-market.can:687
			end -- models/free-market.can:687
		end -- models/free-market.can:687
	end -- models/free-market.can:687
end -- models/free-market.can:687
local function show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:696
	if # force["connected_players"] > 1 then -- models/free-market.can:697
		draw_sprite({ -- models/free-market.can:698
			["sprite"] = "item." .. item_name, -- models/free-market.can:699
			["target"] = entity, -- models/free-market.can:700
			["surface"] = entity["surface"], -- models/free-market.can:701
			["forces"] = { force }, -- models/free-market.can:702
			["time_to_live"] = 200, -- models/free-market.can:703
			["x_scale"] = 0.9, -- models/free-market.can:704
			["target_offset"] = HINT_SPRITE_OFFSET -- models/free-market.can:705
		}) -- models/free-market.can:705
	end -- models/free-market.can:705
end -- models/free-market.can:705
local function clear_invalid_prices(prices) -- models/free-market.can:710
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:711
	local forces = game["forces"] -- models/free-market.can:712
	for index, forces_data in pairs(prices) do -- models/free-market.can:713
		if forces[index] == nil then -- models/free-market.can:714
			sell_prices[index] = nil -- models/free-market.can:715
			buy_prices[index] = nil -- models/free-market.can:716
			inactive_sell_prices[index] = nil -- models/free-market.can:717
			inactive_buy_prices[index] = nil -- models/free-market.can:718
		else -- models/free-market.can:718
			for item_name in pairs(forces_data) do -- models/free-market.can:720
				if item_prototypes[item_name] == nil then -- models/free-market.can:721
					forces_data[item_name] = nil -- models/free-market.can:722
				end -- models/free-market.can:722
			end -- models/free-market.can:722
		end -- models/free-market.can:722
	end -- models/free-market.can:722
end -- models/free-market.can:722
local function clear_invalid_storage_data() -- models/free-market.can:729
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:730
	local forces = game["forces"] -- models/free-market.can:731
	for index, data in pairs(pull_boxes) do -- models/free-market.can:732
		if forces[index] == nil then -- models/free-market.can:733
			clear_force_data(index) -- models/free-market.can:734
		else -- models/free-market.can:734
			for item_name, count in pairs(data) do -- models/free-market.can:736
				if item_prototypes[item_name] == nil or count == 0 then -- models/free-market.can:737
					data[item_name] = nil -- models/free-market.can:738
				end -- models/free-market.can:738
			end -- models/free-market.can:738
		end -- models/free-market.can:738
	end -- models/free-market.can:738
end -- models/free-market.can:738
local function clear_invalid_pull_boxes_data() -- models/free-market.can:745
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:746
	local forces = game["forces"] -- models/free-market.can:747
	for index, data in pairs(pull_boxes) do -- models/free-market.can:748
		if forces[index] == nil then -- models/free-market.can:749
			clear_force_data(index) -- models/free-market.can:750
		else -- models/free-market.can:750
			for item_name, entities in pairs(data) do -- models/free-market.can:752
				if item_prototypes[item_name] == nil then -- models/free-market.can:753
					data[item_name] = nil -- models/free-market.can:754
				else -- models/free-market.can:754
					for i = # entities, 1, - 1 do -- models/free-market.can:756
						local entity = entities[i] -- models/free-market.can:757
						if entity["valid"] == false then -- models/free-market.can:758
							tremove(entities, i) -- models/free-market.can:759
						else -- models/free-market.can:759
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:761
							if box_data == nil then -- models/free-market.can:762
								tremove(entities, i) -- models/free-market.can:763
							elseif entity ~= box_data[1] then -- models/free-market.can:764
								rendering_destroy(box_data[2]) -- models/free-market.can:765
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:766
								tremove(entities, i) -- models/free-market.can:767
							end -- models/free-market.can:767
						end -- models/free-market.can:767
					end -- models/free-market.can:767
					if # entities == 0 then -- models/free-market.can:771
						data[item_name] = nil -- models/free-market.can:772
					end -- models/free-market.can:772
				end -- models/free-market.can:772
			end -- models/free-market.can:772
		end -- models/free-market.can:772
	end -- models/free-market.can:772
end -- models/free-market.can:772
local function clear_invalid_transfer_boxes_data(_data) -- models/free-market.can:781
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:782
	local forces = game["forces"] -- models/free-market.can:783
	for index, data in pairs(_data) do -- models/free-market.can:784
		if forces[index] == nil then -- models/free-market.can:785
			clear_force_data(index) -- models/free-market.can:786
		else -- models/free-market.can:786
			for item_name, entities in pairs(data) do -- models/free-market.can:788
				if item_prototypes[item_name] == nil then -- models/free-market.can:789
					data[item_name] = nil -- models/free-market.can:790
				else -- models/free-market.can:790
					for i = # entities, 1, - 1 do -- models/free-market.can:792
						local entity = entities[i] -- models/free-market.can:793
						if entity["valid"] == false then -- models/free-market.can:794
							tremove(entities, i) -- models/free-market.can:795
						else -- models/free-market.can:795
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:797
							if box_data == nil then -- models/free-market.can:798
								tremove(entities, i) -- models/free-market.can:799
							elseif entity ~= box_data[1] then -- models/free-market.can:800
								rendering_destroy(box_data[2]) -- models/free-market.can:801
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:802
								tremove(entities, i) -- models/free-market.can:803
							end -- models/free-market.can:803
						end -- models/free-market.can:803
					end -- models/free-market.can:803
					if # entities == 0 then -- models/free-market.can:807
						data[item_name] = nil -- models/free-market.can:808
					end -- models/free-market.can:808
				end -- models/free-market.can:808
			end -- models/free-market.can:808
		end -- models/free-market.can:808
	end -- models/free-market.can:808
end -- models/free-market.can:808
local function clear_invalid_buy_boxes_data(_data) -- models/free-market.can:817
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:818
	local forces = game["forces"] -- models/free-market.can:819
	for index, data in pairs(_data) do -- models/free-market.can:820
		if forces[index] == nil then -- models/free-market.can:821
			clear_force_data(index) -- models/free-market.can:822
		else -- models/free-market.can:822
			for item_name, entities in pairs(data) do -- models/free-market.can:824
				if item_prototypes[item_name] == nil then -- models/free-market.can:825
					data[item_name] = nil -- models/free-market.can:826
				else -- models/free-market.can:826
					for i = # entities, 1, - 1 do -- models/free-market.can:828
						local box_data = entities[i] -- models/free-market.can:829
						local entity = box_data[1] -- models/free-market.can:830
						if entity["valid"] == false then -- models/free-market.can:831
							tremove(entities, i) -- models/free-market.can:832
						elseif not box_data[2] then -- models/free-market.can:833
							tremove(entities, i) -- models/free-market.can:834
							all_boxes[entity["unit_number"]] = nil -- models/free-market.can:835
						else -- models/free-market.can:835
							local _box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:837
							if _box_data == nil then -- models/free-market.can:838
								tremove(entities, i) -- models/free-market.can:839
							elseif entity ~= _box_data[1] then -- models/free-market.can:840
								rendering_destroy(box_data[2]) -- models/free-market.can:841
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:842
								tremove(entities, i) -- models/free-market.can:843
							end -- models/free-market.can:843
						end -- models/free-market.can:843
					end -- models/free-market.can:843
					if # entities == 0 then -- models/free-market.can:847
						data[item_name] = nil -- models/free-market.can:848
					end -- models/free-market.can:848
				end -- models/free-market.can:848
			end -- models/free-market.can:848
		end -- models/free-market.can:848
	end -- models/free-market.can:848
end -- models/free-market.can:848
local function clear_invalid_simple_boxes(data) -- models/free-market.can:857
	for _, entities in pairs(data) do -- models/free-market.can:858
		for i = # entities, 1, - 1 do -- models/free-market.can:859
			local entity = entities[i] -- models/free-market.can:860
			if entity["valid"] == false then -- models/free-market.can:861
				tremove(entities, i) -- models/free-market.can:862
			else -- models/free-market.can:862
				local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:864
				if box_data == nil then -- models/free-market.can:865
					tremove(entities, i) -- models/free-market.can:866
				elseif entity ~= box_data[1] then -- models/free-market.can:867
					rendering_destroy(box_data[2]) -- models/free-market.can:868
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:869
					tremove(entities, i) -- models/free-market.can:870
				end -- models/free-market.can:870
			end -- models/free-market.can:870
		end -- models/free-market.can:870
	end -- models/free-market.can:870
end -- models/free-market.can:870
local function delete_item_price_HUD(player) -- models/free-market.can:878
	local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:879
	if frame then -- models/free-market.can:880
		frame["destroy"]() -- models/free-market.can:881
		item_HUD[player["index"]] = nil -- models/free-market.can:882
	end -- models/free-market.can:882
end -- models/free-market.can:882
local function clear_invalid_player_data() -- models/free-market.can:886
	for player_index in pairs(item_HUD) do -- models/free-market.can:887
		local player = game["get_player"](player_index) -- models/free-market.can:888
		if not (player and player["valid"]) then -- models/free-market.can:889
			item_HUD[player_index] = nil -- models/free-market.can:890
		elseif not player["connected"] then -- models/free-market.can:891
			delete_item_price_HUD(player) -- models/free-market.can:892
		end -- models/free-market.can:892
	end -- models/free-market.can:892
end -- models/free-market.can:892
local function clear_invalid_entities() -- models/free-market.can:897
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:898
	for unit_number, data in pairs(all_boxes) do -- models/free-market.can:899
		if not data[1]["valid"] then -- models/free-market.can:900
			all_boxes[unit_number] = nil -- models/free-market.can:901
		else -- models/free-market.can:901
			local item_name = data[5] -- models/free-market.can:903
			if item_name and item_prototypes[item_name] == nil then -- models/free-market.can:904
				rendering_destroy(data[2]) -- models/free-market.can:905
				all_boxes[unit_number] = nil -- models/free-market.can:906
			end -- models/free-market.can:906
		end -- models/free-market.can:906
	end -- models/free-market.can:906
	clear_invalid_storage_data() -- models/free-market.can:911
	clear_invalid_pull_boxes_data() -- models/free-market.can:912
	clear_invalid_transfer_boxes_data(transfer_boxes) -- models/free-market.can:913
	clear_invalid_transfer_boxes_data(inactive_transfer_boxes) -- models/free-market.can:914
	clear_invalid_transfer_boxes_data(bin_boxes) -- models/free-market.can:915
	clear_invalid_transfer_boxes_data(inactive_bin_boxes) -- models/free-market.can:916
	clear_invalid_buy_boxes_data(buy_boxes) -- models/free-market.can:917
	clear_invalid_buy_boxes_data(inactive_buy_boxes) -- models/free-market.can:918
	clear_invalid_simple_boxes(universal_transfer_boxes) -- models/free-market.can:919
	clear_invalid_simple_boxes(inactive_universal_transfer_boxes) -- models/free-market.can:920
	clear_invalid_simple_boxes(universal_bin_boxes) -- models/free-market.can:921
	clear_invalid_simple_boxes(inactive_universal_bin_boxes) -- models/free-market.can:922
end -- models/free-market.can:922
clear_invalid_data = function() -- models/free-market.can:925
	clear_invalid_entities() -- models/free-market.can:926
	clear_invalid_prices(storages_limit) -- models/free-market.can:927
	clear_invalid_prices(inactive_sell_prices) -- models/free-market.can:928
	clear_invalid_prices(inactive_buy_prices) -- models/free-market.can:929
	clear_invalid_prices(sell_prices) -- models/free-market.can:930
	clear_invalid_prices(buy_prices) -- models/free-market.can:931
	clear_invalid_embargoes() -- models/free-market.can:932
	clear_invalid_player_data() -- models/free-market.can:933
end -- models/free-market.can:933
local function get_distance(start, stop) -- models/free-market.can:937
	local xdiff = start["x"] - stop["x"] -- models/free-market.can:938
	local ydiff = start["y"] - stop["y"] -- models/free-market.can:939
	return (xdiff * xdiff + ydiff * ydiff) ^ 0.5 -- models/free-market.can:940
end -- models/free-market.can:940
local function delete_player_data(event) -- models/free-market.can:943
	local player_index = event["player_index"] -- models/free-market.can:944
	open_box[player_index] = nil -- models/free-market.can:945
	item_HUD[player_index] = nil -- models/free-market.can:946
end -- models/free-market.can:946
local function make_prices_header(table) -- models/free-market.can:949
	local dummy -- models/free-market.can:950
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:951
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:952
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:953
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:954
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:955
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:956
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:957
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:958
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:959
	table["add"](LABEL)["caption"] = { "team-name" } -- models/free-market.can:961
	table["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:962
	table["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:963
end -- models/free-market.can:963
local function make_storage_header(table) -- models/free-market.can:966
	local dummy -- models/free-market.can:967
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:968
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:969
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:970
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:971
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:972
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:973
	table["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:975
	table["add"](LABEL)["caption"] = { "gui-logistic.count" } -- models/free-market.can:976
end -- models/free-market.can:976
local function make_price_list_header(table_element) -- models/free-market.can:980
	local dummy -- models/free-market.can:981
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:982
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:983
	dummy["style"]["minimal_width"] = 30 -- models/free-market.can:984
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:985
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:986
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:987
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:988
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:989
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:990
	table_element["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:992
	table_element["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:993
	table_element["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:994
end -- models/free-market.can:994
local function update_prices_table(player, item_name, table_element) -- models/free-market.can:1000
	table_element["clear"]() -- models/free-market.can:1001
	make_prices_header(table_element) -- models/free-market.can:1002
	local force = player["force"] -- models/free-market.can:1003
	local result = {} -- models/free-market.can:1004
	for name, _force in pairs(game["forces"]) do -- models/free-market.can:1005
		if force ~= _force then -- models/free-market.can:1006
			result[_force["index"]] = { ["name"] = name } -- models/free-market.can:1007
		end -- models/free-market.can:1007
	end -- models/free-market.can:1007
	for index, force_items in pairs(buy_prices) do -- models/free-market.can:1010
		local data = result[index] -- models/free-market.can:1011
		if data then -- models/free-market.can:1012
			local buy_value = force_items[item_name] -- models/free-market.can:1013
			if buy_value then -- models/free-market.can:1014
				data["buy_price"] = tostring(buy_value) -- models/free-market.can:1015
			end -- models/free-market.can:1015
		end -- models/free-market.can:1015
	end -- models/free-market.can:1015
	for index, force_items in pairs(sell_prices) do -- models/free-market.can:1019
		local data = result[index] -- models/free-market.can:1020
		if data then -- models/free-market.can:1021
			local sell_price = force_items[item_name] -- models/free-market.can:1022
			if sell_price then -- models/free-market.can:1023
				data["sell_price"] = tostring(sell_price) -- models/free-market.can:1024
			end -- models/free-market.can:1024
		end -- models/free-market.can:1024
	end -- models/free-market.can:1024
	local add = table_element["add"] -- models/free-market.can:1029
	for _, data in pairs(result) do -- models/free-market.can:1030
		if data["buy_price"] or data["sell_price"] then -- models/free-market.can:1031
			add(LABEL)["caption"] = data["name"] -- models/free-market.can:1032
			add(LABEL)["caption"] = (data["buy_price"] or "") -- models/free-market.can:1033
			add(LABEL)["caption"] = (data["sell_price"] or "") -- models/free-market.can:1034
		end -- models/free-market.can:1034
	end -- models/free-market.can:1034
end -- models/free-market.can:1034
local function update_price_list_table(force, scroll_pane) -- models/free-market.can:1041
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1042
	short_price_list_table["clear"]() -- models/free-market.can:1043
	short_price_list_table["visible"] = false -- models/free-market.can:1044
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1045
	price_list_table["clear"]() -- models/free-market.can:1046
	price_list_table["visible"] = true -- models/free-market.can:1047
	make_price_list_header(price_list_table) -- models/free-market.can:1048
	local force_index = force["index"] -- models/free-market.can:1050
	local f_buy_prices = buy_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1051
	local f_sell_prices = sell_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1052
	local add = price_list_table["add"] -- models/free-market.can:1054
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1055
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1056
		add(LABEL)["caption"] = buy_price -- models/free-market.can:1057
		add(LABEL)["caption"] = (f_sell_prices[item_name] or "") -- models/free-market.can:1058
	end -- models/free-market.can:1058
	for item_name, sell_price in pairs(f_sell_prices) do -- models/free-market.can:1061
		if f_buy_prices[item_name] == nil then -- models/free-market.can:1062
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1063
			add(EMPTY_WIDGET) -- models/free-market.can:1064
			add(LABEL)["caption"] = sell_price -- models/free-market.can:1065
		end -- models/free-market.can:1065
	end -- models/free-market.can:1065
end -- models/free-market.can:1065
local function update_price_list_by_sell_filter(force, scroll_pane, text_filter) -- models/free-market.can:1073
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1074
	short_price_list_table["clear"]() -- models/free-market.can:1075
	short_price_list_table["visible"] = true -- models/free-market.can:1076
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1077
	price_list_table["clear"]() -- models/free-market.can:1078
	price_list_table["visible"] = false -- models/free-market.can:1079
	make_price_list_header(short_price_list_table) -- models/free-market.can:1081
	short_price_list_table["children"][5]["destroy"]() -- models/free-market.can:1082
	short_price_list_table["children"][2]["destroy"]() -- models/free-market.can:1083
	local f_sell_prices = sell_prices[force["index"]] -- models/free-market.can:1085
	if f_sell_prices == nil then -- models/free-market.can:1086
		return  -- models/free-market.can:1086
	end -- models/free-market.can:1086
	local add = short_price_list_table["add"] -- models/free-market.can:1088
	for item_name, buy_price in pairs(f_sell_prices) do -- models/free-market.can:1089
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1090
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1091
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1092
		end -- models/free-market.can:1092
	end -- models/free-market.can:1092
end -- models/free-market.can:1092
local function update_price_list_by_buy_filter(force, scroll_pane, text_filter) -- models/free-market.can:1100
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1101
	short_price_list_table["clear"]() -- models/free-market.can:1102
	short_price_list_table["visible"] = true -- models/free-market.can:1103
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1104
	price_list_table["clear"]() -- models/free-market.can:1105
	price_list_table["visible"] = false -- models/free-market.can:1106
	make_price_list_header(short_price_list_table) -- models/free-market.can:1108
	short_price_list_table["children"][6]["destroy"]() -- models/free-market.can:1109
	short_price_list_table["children"][3]["destroy"]() -- models/free-market.can:1110
	local f_buy_prices = buy_prices[force["index"]] -- models/free-market.can:1112
	if f_buy_prices == nil then -- models/free-market.can:1113
		return  -- models/free-market.can:1113
	end -- models/free-market.can:1113
	local add = short_price_list_table["add"] -- models/free-market.can:1115
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1116
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1117
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1118
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1119
		end -- models/free-market.can:1119
	end -- models/free-market.can:1119
end -- models/free-market.can:1119
local function destroy_prices_gui(player) -- models/free-market.can:1125
	local screen = player["gui"]["screen"] -- models/free-market.can:1126
	if screen["FM_prices_frame"] then -- models/free-market.can:1127
		screen["FM_prices_frame"]["destroy"]() -- models/free-market.can:1128
	end -- models/free-market.can:1128
end -- models/free-market.can:1128
local function destroy_price_list_gui(player) -- models/free-market.can:1133
	local screen = player["gui"]["screen"] -- models/free-market.can:1134
	if screen["FM_price_list_frame"] then -- models/free-market.can:1135
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1136
	end -- models/free-market.can:1136
end -- models/free-market.can:1136
local function update_embargo_table(embargo_table, player) -- models/free-market.can:1142
	embargo_table["clear"]() -- models/free-market.can:1143
	embargo_table["add"](LABEL)["caption"] = { "free-market.without-embargo-title" } -- models/free-market.can:1145
	embargo_table["add"](EMPTY_WIDGET) -- models/free-market.can:1146
	embargo_table["add"](LABEL)["caption"] = { "free-market.with-embargo-title" } -- models/free-market.can:1147
	local force_index = player["force"]["index"] -- models/free-market.can:1149
	local in_embargo_list = {} -- models/free-market.can:1150
	local no_embargo_list = {} -- models/free-market.can:1151
	local f_embargoes = embargoes[force_index] -- models/free-market.can:1152
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1153
		if # force["players"] > 0 and force["index"] ~= force_index then -- models/free-market.can:1154
			if f_embargoes[force["index"]] then -- models/free-market.can:1155
				in_embargo_list[# in_embargo_list + 1] = force_name -- models/free-market.can:1156
			else -- models/free-market.can:1156
				no_embargo_list[# no_embargo_list + 1] = force_name -- models/free-market.can:1158
			end -- models/free-market.can:1158
		end -- models/free-market.can:1158
	end -- models/free-market.can:1158
	local forces_list = embargo_table["add"]({ -- models/free-market.can:1163
		["type"] = "list-box", -- models/free-market.can:1163
		["name"] = "forces_list", -- models/free-market.can:1163
		["items"] = no_embargo_list -- models/free-market.can:1163
	}) -- models/free-market.can:1163
	forces_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1164
	forces_list["style"]["height"] = 200 -- models/free-market.can:1165
	local buttons_flow = embargo_table["add"](VERTICAL_FLOW) -- models/free-market.can:1166
	buttons_flow["add"]({ -- models/free-market.can:1167
		["type"] = "sprite-button", -- models/free-market.can:1167
		["name"] = "FM_cancel_embargo", -- models/free-market.can:1167
		["style"] = "tool_button", -- models/free-market.can:1167
		["sprite"] = "utility/left_arrow" -- models/free-market.can:1167
	}) -- models/free-market.can:1167
	buttons_flow["add"]({ -- models/free-market.can:1168
		["type"] = "sprite-button", -- models/free-market.can:1168
		["name"] = "FM_declare_embargo", -- models/free-market.can:1168
		["style"] = "tool_button", -- models/free-market.can:1168
		["sprite"] = "utility/right_arrow" -- models/free-market.can:1168
	}) -- models/free-market.can:1168
	local embargo_list = embargo_table["add"]({ -- models/free-market.can:1169
		["type"] = "list-box", -- models/free-market.can:1169
		["name"] = "embargo_list", -- models/free-market.can:1169
		["items"] = in_embargo_list -- models/free-market.can:1169
	}) -- models/free-market.can:1169
	embargo_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1170
	embargo_list["style"]["height"] = 200 -- models/free-market.can:1171
end -- models/free-market.can:1171
local function add_item_in_sell_prices(player, item_name, price, force_index) -- models/free-market.can:1177
	local prices_table = player["gui"]["screen"]["FM_sell_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1178
	local add = prices_table["add"] -- models/free-market.can:1179
	local button = add(FLOW)["add"](SELL_PRICE_BUTTON) -- models/free-market.can:1180
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1181
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1182
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1183
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1185
	add(POST_PRICE_LABEL) -- models/free-market.can:1186
	local children = prices_table["children"] -- models/free-market.can:1188
	if # children / 2 > player["mod_settings"]["FM_sell_notification_size"]["value"] then -- models/free-market.can:1189
		children[2]["destroy"]() -- models/free-market.can:1190
		children[1]["destroy"]() -- models/free-market.can:1191
	end -- models/free-market.can:1191
end -- models/free-market.can:1191
local function add_item_in_buy_prices(player, item_name, price, force_index) -- models/free-market.can:1198
	local prices_table = player["gui"]["screen"]["FM_buy_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1199
	local add = prices_table["add"] -- models/free-market.can:1200
	local button = add(FLOW)["add"](BUY_PRICE_BUTTON) -- models/free-market.can:1201
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1202
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1203
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1204
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1206
	add(POST_PRICE_LABEL) -- models/free-market.can:1207
	local children = prices_table["children"] -- models/free-market.can:1209
	if # children / 2 > player["mod_settings"]["FM_buy_notification_size"]["value"] then -- models/free-market.can:1210
		children[2]["destroy"]() -- models/free-market.can:1211
		children[1]["destroy"]() -- models/free-market.can:1212
	end -- models/free-market.can:1212
end -- models/free-market.can:1212
local function notify_sell_price(source_index, item_name, sell_price) -- models/free-market.can:1219
	local forces = game["forces"] -- models/free-market.can:1220
	local f_embargoes = embargoes[source_index] -- models/free-market.can:1221
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1222
		if force_index ~= source_index and not f_embargoes[f_embargoes] then -- models/free-market.can:1223
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1224
				pcall(add_item_in_sell_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1225
			end -- models/free-market.can:1225
		end -- models/free-market.can:1225
	end -- models/free-market.can:1225
end -- models/free-market.can:1225
local function notify_buy_price(source_index, item_name, sell_price) -- models/free-market.can:1234
	local forces = game["forces"] -- models/free-market.can:1235
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1236
		if force_index ~= source_index and not embargoes[force_index][source_index] then -- models/free-market.can:1237
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1238
				pcall(add_item_in_buy_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1239
			end -- models/free-market.can:1239
		end -- models/free-market.can:1239
	end -- models/free-market.can:1239
end -- models/free-market.can:1239
local function change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:1249
	local force_index = player["force"]["index"] -- models/free-market.can:1250
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1251
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1252
	if sell_price == nil then -- models/free-market.can:1253
		f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1254
		f_sell_prices[item_name] = nil -- models/free-market.can:1255
		return  -- models/free-market.can:1256
	end -- models/free-market.can:1256
	local active_sell_price = f_sell_prices[item_name] -- models/free-market.can:1259
	local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1260
	local prev_sell_price = f_sell_prices[item_name] or inactive_sell_price -- models/free-market.can:1261
	if prev_sell_price == sell_price then -- models/free-market.can:1262
		if inactive_sell_price then -- models/free-market.can:1263
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1264
			if count_in_storage and count_in_storage > 0 then -- models/free-market.can:1265
				f_sell_prices[item_name] = sell_price -- models/free-market.can:1266
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1267
				notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1268
			end -- models/free-market.can:1268
		end -- models/free-market.can:1268
		return  -- models/free-market.can:1271
	end -- models/free-market.can:1271
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1274
	if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then -- models/free-market.can:1275
		player["print"]({ -- models/free-market.can:1276
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1276
			sell_price, -- models/free-market.can:1276
			buy_price or minimal_price, -- models/free-market.can:1276
			maximal_price -- models/free-market.can:1276
		}) -- models/free-market.can:1276
		return active_sell_price or inactive_sell_price or "" -- models/free-market.can:1277
	end -- models/free-market.can:1277
	if active_sell_price then -- models/free-market.can:1280
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1281
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1282
	elseif inactive_sell_price then -- models/free-market.can:1283
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1284
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1285
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1286
		else -- models/free-market.can:1286
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1288
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1289
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1290
		end -- models/free-market.can:1290
	elseif transfer_boxes[force_index][item_name] then -- models/free-market.can:1292
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1293
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1294
	else -- models/free-market.can:1294
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1296
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1297
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1298
		else -- models/free-market.can:1298
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1300
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1301
		end -- models/free-market.can:1301
	end -- models/free-market.can:1301
end -- models/free-market.can:1301
local function change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:1310
	local force_index = player["force"]["index"] -- models/free-market.can:1311
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1312
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1313
	if buy_price == nil then -- models/free-market.can:1314
		f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1315
		f_buy_prices[item_name] = nil -- models/free-market.can:1316
		return  -- models/free-market.can:1317
	end -- models/free-market.can:1317
	local prev_buy_price = f_buy_prices[item_name] or f_inactive_buy_prices[item_name] -- models/free-market.can:1320
	if prev_buy_price == buy_price then -- models/free-market.can:1321
		return  -- models/free-market.can:1322
	end -- models/free-market.can:1322
	local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:1325
	if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then -- models/free-market.can:1326
		player["print"]({ -- models/free-market.can:1327
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1327
			buy_price, -- models/free-market.can:1327
			minimal_price, -- models/free-market.can:1327
			sell_price or maximal_price -- models/free-market.can:1327
		}) -- models/free-market.can:1327
		return f_buy_prices[item_name] or f_inactive_buy_prices[item_name] or "" -- models/free-market.can:1328
	end -- models/free-market.can:1328
	if f_buy_prices[item_name] then -- models/free-market.can:1331
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1332
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1333
	elseif f_inactive_buy_prices[item_name] then -- models/free-market.can:1334
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1335
	elseif buy_boxes[force_index][item_name] then -- models/free-market.can:1336
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1337
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1338
	else -- models/free-market.can:1338
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1340
	end -- models/free-market.can:1340
end -- models/free-market.can:1340
local function create_price_notification_handler(gui, button_name, is_top_handler) -- models/free-market.can:1347
	local flow = gui["add"](TITLEBAR_FLOW) -- models/free-market.can:1348
	flow["style"]["padding"] = 0 -- models/free-market.can:1349
	if is_top_handler then -- models/free-market.can:1350
		local button = flow["add"]({ -- models/free-market.can:1351
			["type"] = "sprite-button", -- models/free-market.can:1352
			["sprite"] = "FM_price", -- models/free-market.can:1353
			["style"] = "frame_action_button", -- models/free-market.can:1354
			["name"] = button_name -- models/free-market.can:1355
		}) -- models/free-market.can:1355
		button["style"]["margin"] = 0 -- models/free-market.can:1357
	end -- models/free-market.can:1357
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:1359
	drag_handler["drag_target"] = gui -- models/free-market.can:1360
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:1361
	if is_top_handler then -- models/free-market.can:1362
		flow["style"]["horizontal_spacing"] = 0 -- models/free-market.can:1363
		drag_handler["style"]["width"] = 27 -- models/free-market.can:1364
		drag_handler["style"]["height"] = 25 -- models/free-market.can:1365
		drag_handler["style"]["horizontally_stretchable"] = false -- models/free-market.can:1366
	else -- models/free-market.can:1366
		drag_handler["style"]["width"] = 24 -- models/free-market.can:1368
		drag_handler["style"]["height"] = 46 -- models/free-market.can:1369
		drag_handler["add"]({ -- models/free-market.can:1370
			["type"] = "sprite-button", -- models/free-market.can:1371
			["sprite"] = "FM_price", -- models/free-market.can:1372
			["style"] = "frame_action_button", -- models/free-market.can:1373
			["name"] = button_name -- models/free-market.can:1374
		}) -- models/free-market.can:1374
	end -- models/free-market.can:1374
end -- models/free-market.can:1374
local function switch_sell_prices_gui(player, location) -- models/free-market.can:1381
	local screen = player["gui"]["screen"] -- models/free-market.can:1382
	local main_frame = screen["FM_sell_prices_frame"] -- models/free-market.can:1383
	if main_frame then -- models/free-market.can:1384
		local children = main_frame["children"] -- models/free-market.can:1385
		if # children > 1 then -- models/free-market.can:1386
			children[2]["destroy"]() -- models/free-market.can:1387
			return  -- models/free-market.can:1388
		else -- models/free-market.can:1388
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1390
				["type"] = "frame", -- models/free-market.can:1390
				["name"] = "FM_prices_flow", -- models/free-market.can:1390
				["style"] = "FM_prices_frame", -- models/free-market.can:1390
				["direction"] = "vertical" -- models/free-market.can:1390
			}) -- models/free-market.can:1390
			local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1391
			prices_flow["add"]({ -- models/free-market.can:1392
				["type"] = "table", -- models/free-market.can:1392
				["name"] = "FM_prices_table", -- models/free-market.can:1392
				["style"] = "FM_prices_table", -- models/free-market.can:1392
				["column_count"] = column_count -- models/free-market.can:1392
			}) -- models/free-market.can:1392
			local cost = 0 -- models/free-market.can:1394
			for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:1395
				cost = cost + 1 -- models/free-market.can:1396
				add_item_in_sell_prices(player, item_name, cost, player["index"]) -- models/free-market.can:1397
			end -- models/free-market.can:1397
		end -- models/free-market.can:1397
	else -- models/free-market.can:1397
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1402
		local is_vertical = (column_count == 2) -- models/free-market.can:1403
		if is_vertical then -- models/free-market.can:1404
			direction = "vertical" -- models/free-market.can:1405
		else -- models/free-market.can:1405
			direction = "horizontal" -- models/free-market.can:1407
		end -- models/free-market.can:1407
		main_frame = screen["add"]({ -- models/free-market.can:1409
			["type"] = "frame", -- models/free-market.can:1409
			["name"] = "FM_sell_prices_frame", -- models/free-market.can:1409
			["style"] = "borderless_frame", -- models/free-market.can:1409
			["direction"] = direction -- models/free-market.can:1409
		}) -- models/free-market.can:1409
		main_frame["location"] = location or { -- models/free-market.can:1410
			["x"] = player["display_resolution"]["width"] - 752, -- models/free-market.can:1410
			["y"] = 272 -- models/free-market.can:1410
		} -- models/free-market.can:1410
		create_price_notification_handler(main_frame, "FM_switch_sell_prices_gui", is_vertical) -- models/free-market.can:1411
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1412
			["type"] = "frame", -- models/free-market.can:1412
			["name"] = "FM_prices_flow", -- models/free-market.can:1412
			["style"] = "FM_prices_frame", -- models/free-market.can:1412
			["direction"] = "vertical" -- models/free-market.can:1412
		}) -- models/free-market.can:1412
		prices_flow["add"]({ -- models/free-market.can:1413
			["type"] = "table", -- models/free-market.can:1413
			["name"] = "FM_prices_table", -- models/free-market.can:1413
			["style"] = "FM_prices_table", -- models/free-market.can:1413
			["column_count"] = column_count -- models/free-market.can:1413
		}) -- models/free-market.can:1413
	end -- models/free-market.can:1413
end -- models/free-market.can:1413
local function switch_buy_prices_gui(player, location) -- models/free-market.can:1419
	local screen = player["gui"]["screen"] -- models/free-market.can:1420
	local main_frame = screen["FM_buy_prices_frame"] -- models/free-market.can:1421
	if main_frame then -- models/free-market.can:1422
		local children = main_frame["children"] -- models/free-market.can:1423
		if # children > 1 then -- models/free-market.can:1424
			children[2]["destroy"]() -- models/free-market.can:1425
			return  -- models/free-market.can:1426
		else -- models/free-market.can:1426
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1428
				["type"] = "frame", -- models/free-market.can:1428
				["name"] = "FM_prices_flow", -- models/free-market.can:1428
				["style"] = "FM_prices_frame", -- models/free-market.can:1428
				["direction"] = "vertical" -- models/free-market.can:1428
			}) -- models/free-market.can:1428
			local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1429
			prices_flow["add"]({ -- models/free-market.can:1430
				["type"] = "table", -- models/free-market.can:1430
				["name"] = "FM_prices_table", -- models/free-market.can:1430
				["style"] = "FM_prices_table", -- models/free-market.can:1430
				["column_count"] = column_count -- models/free-market.can:1430
			}) -- models/free-market.can:1430
			local cost = 0 -- models/free-market.can:1432
			for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:1433
				cost = cost + 1 -- models/free-market.can:1434
				add_item_in_buy_prices(player, item_name, cost, player["index"]) -- models/free-market.can:1435
			end -- models/free-market.can:1435
		end -- models/free-market.can:1435
	else -- models/free-market.can:1435
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1440
		local is_vertical = (column_count == 2) -- models/free-market.can:1441
		if is_vertical then -- models/free-market.can:1442
			direction = "vertical" -- models/free-market.can:1443
		else -- models/free-market.can:1443
			direction = "horizontal" -- models/free-market.can:1445
		end -- models/free-market.can:1445
		main_frame = screen["add"]({ -- models/free-market.can:1447
			["type"] = "frame", -- models/free-market.can:1447
			["name"] = "FM_buy_prices_frame", -- models/free-market.can:1447
			["style"] = "borderless_frame", -- models/free-market.can:1447
			["direction"] = direction -- models/free-market.can:1447
		}) -- models/free-market.can:1447
		main_frame["location"] = location or { -- models/free-market.can:1448
			["x"] = player["display_resolution"]["width"] - 712, -- models/free-market.can:1448
			["y"] = 272 -- models/free-market.can:1448
		} -- models/free-market.can:1448
		create_price_notification_handler(main_frame, "FM_switch_buy_prices_gui", is_vertical) -- models/free-market.can:1449
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1450
			["type"] = "frame", -- models/free-market.can:1450
			["name"] = "FM_prices_flow", -- models/free-market.can:1450
			["style"] = "FM_prices_frame", -- models/free-market.can:1450
			["direction"] = "vertical" -- models/free-market.can:1450
		}) -- models/free-market.can:1450
		prices_flow["add"]({ -- models/free-market.can:1451
			["type"] = "table", -- models/free-market.can:1451
			["name"] = "FM_prices_table", -- models/free-market.can:1451
			["style"] = "FM_prices_table", -- models/free-market.can:1451
			["column_count"] = column_count -- models/free-market.can:1451
		}) -- models/free-market.can:1451
	end -- models/free-market.can:1451
end -- models/free-market.can:1451
local function open_embargo_gui(player) -- models/free-market.can:1456
	local screen = player["gui"]["screen"] -- models/free-market.can:1457
	if screen["FM_embargo_frame"] then -- models/free-market.can:1458
		screen["FM_embargo_frame"]["destroy"]() -- models/free-market.can:1459
		return  -- models/free-market.can:1460
	end -- models/free-market.can:1460
	local main_frame = screen["add"]({ -- models/free-market.can:1462
		["type"] = "frame", -- models/free-market.can:1462
		["name"] = "FM_embargo_frame", -- models/free-market.can:1462
		["direction"] = "vertical" -- models/free-market.can:1462
	}) -- models/free-market.can:1462
	main_frame["style"]["minimal_width"] = 340 -- models/free-market.can:1463
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1464
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1465
	flow["add"]({ -- models/free-market.can:1466
		["type"] = "label", -- models/free-market.can:1467
		["style"] = "frame_title", -- models/free-market.can:1468
		["caption"] = { "free-market.embargo-gui" }, -- models/free-market.can:1469
		["ignored_by_interaction"] = true -- models/free-market.can:1470
	}) -- models/free-market.can:1470
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1472
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1473
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1475
		["type"] = "frame", -- models/free-market.can:1475
		["name"] = "shallow_frame", -- models/free-market.can:1475
		["style"] = "inside_shallow_frame" -- models/free-market.can:1475
	}) -- models/free-market.can:1475
	local embargo_table = shallow_frame["add"]({ -- models/free-market.can:1476
		["type"] = "table", -- models/free-market.can:1476
		["name"] = "embargo_table", -- models/free-market.can:1476
		["column_count"] = 3 -- models/free-market.can:1476
	}) -- models/free-market.can:1476
	embargo_table["style"]["horizontally_stretchable"] = true -- models/free-market.can:1477
	embargo_table["style"]["vertically_stretchable"] = true -- models/free-market.can:1478
	embargo_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1479
	embargo_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1480
	embargo_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1481
	update_embargo_table(embargo_table, player) -- models/free-market.can:1483
	main_frame["force_auto_center"]() -- models/free-market.can:1484
end -- models/free-market.can:1484
local function set_transfer_box_data(item_name, player, entity) -- models/free-market.can:1490
	local player_force = player["force"] -- models/free-market.can:1491
	local force_index = player_force["index"] -- models/free-market.can:1492
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:1493
	if f_transfer_boxes[item_name] == nil then -- models/free-market.can:1494
		local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1495
		local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1496
		if inactive_sell_price then -- models/free-market.can:1497
			sell_prices[force_index][item_name] = inactive_sell_price -- models/free-market.can:1498
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1499
			notify_sell_price(force_index, item_name, inactive_sell_price) -- models/free-market.can:1500
		end -- models/free-market.can:1500
		f_transfer_boxes[item_name] = {} -- models/free-market.can:1502
	end -- models/free-market.can:1502
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:1504
	entities[# entities + 1] = entity -- models/free-market.can:1505
	local sprite_data = { -- models/free-market.can:1506
		["sprite"] = "FM_transfer", -- models/free-market.can:1507
		["target"] = entity, -- models/free-market.can:1508
		["surface"] = entity["surface"], -- models/free-market.can:1509
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1510
		["only_in_alt_mode"] = true, -- models/free-market.can:1511
		["x_scale"] = 0.4, -- models/free-market.can:1512
		["y_scale"] = 0.4 -- models/free-market.can:1512
	} -- models/free-market.can:1512
	if is_public_titles == false then -- models/free-market.can:1514
		sprite_data["forces"] = { player_force } -- models/free-market.can:1515
	end -- models/free-market.can:1515
	local id = draw_sprite(sprite_data) -- models/free-market.can:1518
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1519
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1521
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1524
		entity, -- models/free-market.can:1524
		id, -- models/free-market.can:1524
		4, -- models/free-market.can:1
		entities, -- models/free-market.can:1524
		item_name -- models/free-market.can:1524
	} -- models/free-market.can:1524
end -- models/free-market.can:1524
local function set_universal_transfer_box_data(player, entity) -- models/free-market.can:1529
	local player_force = player["force"] -- models/free-market.can:1530
	local force_index = player_force["index"] -- models/free-market.can:1531
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:1532
	entities[# entities + 1] = entity -- models/free-market.can:1533
	local sprite_data = { -- models/free-market.can:1534
		["sprite"] = "FM_universal_transfer", -- models/free-market.can:1535
		["target"] = entity, -- models/free-market.can:1536
		["surface"] = entity["surface"], -- models/free-market.can:1537
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1538
		["only_in_alt_mode"] = true, -- models/free-market.can:1539
		["x_scale"] = 0.4, -- models/free-market.can:1540
		["y_scale"] = 0.4 -- models/free-market.can:1540
	} -- models/free-market.can:1540
	if is_public_titles == false then -- models/free-market.can:1542
		sprite_data["forces"] = { player_force } -- models/free-market.can:1543
	end -- models/free-market.can:1543
	local id = draw_sprite(sprite_data) -- models/free-market.can:1546
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1549
		entity, -- models/free-market.can:1549
		id, -- models/free-market.can:1549
		5, -- models/free-market.can:1
		entities, -- models/free-market.can:1549
		nil -- models/free-market.can:1549
	} -- models/free-market.can:1549
end -- models/free-market.can:1549
local function set_bin_box_data(item_name, player, entity) -- models/free-market.can:1555
	local player_force = player["force"] -- models/free-market.can:1556
	local force_index = player_force["index"] -- models/free-market.can:1557
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:1558
	if f_bin_boxes[item_name] == nil then -- models/free-market.can:1559
		f_bin_boxes[item_name] = {} -- models/free-market.can:1560
	end -- models/free-market.can:1560
	local entities = f_bin_boxes[item_name] -- models/free-market.can:1562
	entities[# entities + 1] = entity -- models/free-market.can:1563
	local sprite_data = { -- models/free-market.can:1564
		["sprite"] = "FM_bin", -- models/free-market.can:1565
		["target"] = entity, -- models/free-market.can:1566
		["surface"] = entity["surface"], -- models/free-market.can:1567
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1568
		["only_in_alt_mode"] = true, -- models/free-market.can:1569
		["x_scale"] = 0.4, -- models/free-market.can:1570
		["y_scale"] = 0.4 -- models/free-market.can:1570
	} -- models/free-market.can:1570
	if is_public_titles == false then -- models/free-market.can:1572
		sprite_data["forces"] = { player_force } -- models/free-market.can:1573
	end -- models/free-market.can:1573
	local id = draw_sprite(sprite_data) -- models/free-market.can:1576
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1577
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1580
		entity, -- models/free-market.can:1580
		id, -- models/free-market.can:1580
		6, -- models/free-market.can:1
		entities, -- models/free-market.can:1580
		item_name -- models/free-market.can:1580
	} -- models/free-market.can:1580
end -- models/free-market.can:1580
local function set_universal_bin_box_data(player, entity) -- models/free-market.can:1585
	local player_force = player["force"] -- models/free-market.can:1586
	local force_index = player_force["index"] -- models/free-market.can:1587
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:1588
	entities[# entities + 1] = entity -- models/free-market.can:1589
	local sprite_data = { -- models/free-market.can:1590
		["sprite"] = "FM_universal_bin", -- models/free-market.can:1591
		["target"] = entity, -- models/free-market.can:1592
		["surface"] = entity["surface"], -- models/free-market.can:1593
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1594
		["only_in_alt_mode"] = true, -- models/free-market.can:1595
		["x_scale"] = 0.4, -- models/free-market.can:1596
		["y_scale"] = 0.4 -- models/free-market.can:1596
	} -- models/free-market.can:1596
	if is_public_titles == false then -- models/free-market.can:1598
		sprite_data["forces"] = { player_force } -- models/free-market.can:1599
	end -- models/free-market.can:1599
	local id = draw_sprite(sprite_data) -- models/free-market.can:1602
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1605
		entity, -- models/free-market.can:1605
		id, -- models/free-market.can:1605
		7, -- models/free-market.can:1
		entities, -- models/free-market.can:1605
		nil -- models/free-market.can:1605
	} -- models/free-market.can:1605
end -- models/free-market.can:1605
local function set_pull_box_data(item_name, player, entity) -- models/free-market.can:1611
	local player_force = player["force"] -- models/free-market.can:1612
	local force_index = player_force["index"] -- models/free-market.can:1613
	local force_pull_boxes = pull_boxes[force_index] -- models/free-market.can:1614
	force_pull_boxes[item_name] = force_pull_boxes[item_name] or {} -- models/free-market.can:1615
	local items = force_pull_boxes[item_name] -- models/free-market.can:1616
	items[# items + 1] = entity -- models/free-market.can:1617
	local sprite_data = { -- models/free-market.can:1618
		["sprite"] = "FM_pull_out", -- models/free-market.can:1619
		["target"] = entity, -- models/free-market.can:1620
		["surface"] = entity["surface"], -- models/free-market.can:1621
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1622
		["only_in_alt_mode"] = true, -- models/free-market.can:1623
		["x_scale"] = 0.4, -- models/free-market.can:1624
		["y_scale"] = 0.4 -- models/free-market.can:1624
	} -- models/free-market.can:1624
	if is_public_titles == false then -- models/free-market.can:1626
		sprite_data["forces"] = { player_force } -- models/free-market.can:1627
	end -- models/free-market.can:1627
	local id = draw_sprite(sprite_data) -- models/free-market.can:1630
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1631
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1633
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1636
		entity, -- models/free-market.can:1636
		id, -- models/free-market.can:1636
		3, -- models/free-market.can:1
		items, -- models/free-market.can:1636
		item_name -- models/free-market.can:1636
	} -- models/free-market.can:1636
end -- models/free-market.can:1636
local function set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:1643
	count = count or game["item_prototypes"][item_name]["stack_size"] -- models/free-market.can:1644
	local player_force = player["force"] -- models/free-market.can:1646
	local force_index = player_force["index"] -- models/free-market.can:1647
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:1648
	if f_buy_boxes[item_name] == nil then -- models/free-market.can:1649
		local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1650
		local inactive_buy_price = f_inactive_buy_prices[item_name] -- models/free-market.can:1651
		if inactive_buy_price then -- models/free-market.can:1652
			buy_prices[force_index][item_name] = inactive_buy_price -- models/free-market.can:1653
			f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1654
			notify_buy_price(force_index, item_name, inactive_buy_price) -- models/free-market.can:1655
		end -- models/free-market.can:1655
		f_buy_boxes[item_name] = {} -- models/free-market.can:1657
	end -- models/free-market.can:1657
	local items = f_buy_boxes[item_name] -- models/free-market.can:1659
	items[# items + 1] = { -- models/free-market.can:1660
		entity, -- models/free-market.can:1660
		count -- models/free-market.can:1660
	} -- models/free-market.can:1660
	local sprite_data = { -- models/free-market.can:1661
		["sprite"] = "FM_buy", -- models/free-market.can:1662
		["target"] = entity, -- models/free-market.can:1663
		["surface"] = entity["surface"], -- models/free-market.can:1664
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1665
		["only_in_alt_mode"] = true, -- models/free-market.can:1666
		["x_scale"] = 0.4, -- models/free-market.can:1667
		["y_scale"] = 0.4 -- models/free-market.can:1667
	} -- models/free-market.can:1667
	if is_public_titles == false then -- models/free-market.can:1669
		sprite_data["forces"] = { player_force } -- models/free-market.can:1670
	end -- models/free-market.can:1670
	local id = draw_sprite(sprite_data) -- models/free-market.can:1673
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1674
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1677
		entity, -- models/free-market.can:1677
		id, -- models/free-market.can:1677
		1, -- models/free-market.can:1
		items, -- models/free-market.can:1677
		item_name -- models/free-market.can:1677
	} -- models/free-market.can:1677
end -- models/free-market.can:1677
local function destroy_force_configuration(player) -- models/free-market.can:1681
	local frame = player["gui"]["screen"]["FM_force_configuration"] -- models/free-market.can:1682
	if frame then -- models/free-market.can:1683
		frame["destroy"]() -- models/free-market.can:1684
	end -- models/free-market.can:1684
end -- models/free-market.can:1684
local function open_force_configuration(player) -- models/free-market.can:1689
	local screen = player["gui"]["screen"] -- models/free-market.can:1690
	if screen["FM_force_configuration"] then -- models/free-market.can:1691
		screen["FM_force_configuration"]["destroy"]() -- models/free-market.can:1692
		return  -- models/free-market.can:1693
	end -- models/free-market.can:1693
	local is_player_admin = player["admin"] -- models/free-market.can:1696
	local force = player["force"] -- models/free-market.can:1697
	local main_frame = screen["add"]({ -- models/free-market.can:1699
		["type"] = "frame", -- models/free-market.can:1699
		["name"] = "FM_force_configuration", -- models/free-market.can:1699
		["direction"] = "vertical" -- models/free-market.can:1699
	}) -- models/free-market.can:1699
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1700
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1701
	flow["add"]({ -- models/free-market.can:1702
		["type"] = "label", -- models/free-market.can:1703
		["style"] = "frame_title", -- models/free-market.can:1704
		["caption"] = { "free-market.team-configuration" }, -- models/free-market.can:1705
		["ignored_by_interaction"] = true -- models/free-market.can:1706
	}) -- models/free-market.can:1706
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1708
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1709
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1710
		["type"] = "frame", -- models/free-market.can:1710
		["name"] = "shallow_frame", -- models/free-market.can:1710
		["style"] = "inside_shallow_frame", -- models/free-market.can:1710
		["direction"] = "vertical" -- models/free-market.can:1710
	}) -- models/free-market.can:1710
	local content = shallow_frame["add"]({ -- models/free-market.can:1711
		["type"] = "flow", -- models/free-market.can:1711
		["name"] = "content_flow", -- models/free-market.can:1711
		["direction"] = "vertical" -- models/free-market.can:1711
	}) -- models/free-market.can:1711
	content["style"]["padding"] = 12 -- models/free-market.can:1712
	if is_player_admin then -- models/free-market.can:1714
		local admin_row = content["add"](FLOW) -- models/free-market.can:1715
		admin_row["name"] = "admin_row" -- models/free-market.can:1716
		admin_row["add"](LABEL)["caption"] = { -- models/free-market.can:1717
			"", -- models/free-market.can:1717
			{ "gui-multiplayer-lobby.allow-commands-admins-only" }, -- models/free-market.can:1717
			COLON -- models/free-market.can:1717
		} -- models/free-market.can:1717
		admin_row["add"]({ -- models/free-market.can:1718
			["type"] = "button", -- models/free-market.can:1718
			["caption"] = { "free-market.print-force-data-button" }, -- models/free-market.can:1718
			["name"] = "FM_print_force_data" -- models/free-market.can:1718
		}) -- models/free-market.can:1718
		admin_row["add"]({ -- models/free-market.can:1719
			["type"] = "button", -- models/free-market.can:1719
			["caption"] = "Clear invalid data", -- models/free-market.can:1719
			["name"] = "FM_clear_invalid_data" -- models/free-market.can:1719
		}) -- models/free-market.can:1719
	end -- models/free-market.can:1719
	if is_reset_public or is_player_admin or # force["players"] == 1 then -- models/free-market.can:1722
		if is_player_admin then -- models/free-market.can:1723
			content["add"](LABEL)["caption"] = { -- models/free-market.can:1724
				"", -- models/free-market.can:1724
				"Attention", -- models/free-market.can:1724
				COLON, -- models/free-market.can:1724
				"reset is public" -- models/free-market.can:1724
			} -- models/free-market.can:1724
		end -- models/free-market.can:1724
		local reset_caption = { -- models/free-market.can:1726
			"", -- models/free-market.can:1726
			{ "free-market.reset-gui" }, -- models/free-market.can:1726
			COLON -- models/free-market.can:1726
		} -- models/free-market.can:1726
		local reset_prices_row = content["add"](FLOW) -- models/free-market.can:1727
		reset_prices_row["name"] = "reset_prices_row" -- models/free-market.can:1728
		reset_prices_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1729
		reset_prices_row["add"]({ -- models/free-market.can:1730
			["type"] = "button", -- models/free-market.can:1730
			["caption"] = { "free-market.reset-buy-prices" }, -- models/free-market.can:1730
			["name"] = "FM_reset_buy_prices" -- models/free-market.can:1730
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1730
		reset_prices_row["add"]({ -- models/free-market.can:1731
			["type"] = "button", -- models/free-market.can:1731
			["caption"] = { "free-market.reset-sell-prices" }, -- models/free-market.can:1731
			["name"] = "FM_reset_sell_prices" -- models/free-market.can:1731
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1731
		reset_prices_row["add"]({ -- models/free-market.can:1732
			["type"] = "button", -- models/free-market.can:1732
			["caption"] = { "free-market.reset-all-prices" }, -- models/free-market.can:1732
			["name"] = "FM_reset_all_prices" -- models/free-market.can:1732
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1732
		local reset_boxes_row = content["add"](FLOW) -- models/free-market.can:1734
		reset_boxes_row["name"] = "reset_boxes_row" -- models/free-market.can:1735
		reset_boxes_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1736
		reset_boxes_row["add"]({ -- models/free-market.can:1737
			["type"] = "button", -- models/free-market.can:1737
			["style"] = "FM_transfer_button", -- models/free-market.can:1737
			["name"] = "FM_reset_transfer_boxes" -- models/free-market.can:1737
		}) -- models/free-market.can:1737
		reset_boxes_row["add"]({ -- models/free-market.can:1738
			["type"] = "button", -- models/free-market.can:1738
			["style"] = "FM_universal_transfer_button", -- models/free-market.can:1738
			["name"] = "FM_reset_universal_transfer_boxes" -- models/free-market.can:1738
		}) -- models/free-market.can:1738
		reset_boxes_row["add"]({ -- models/free-market.can:1739
			["type"] = "button", -- models/free-market.can:1739
			["style"] = "FM_bin_button", -- models/free-market.can:1739
			["name"] = "FM_reset_bin_boxes" -- models/free-market.can:1739
		}) -- models/free-market.can:1739
		reset_boxes_row["add"]({ -- models/free-market.can:1740
			["type"] = "button", -- models/free-market.can:1740
			["style"] = "FM_universal_bin_button", -- models/free-market.can:1740
			["name"] = "FM_reset_universal_bin_boxes" -- models/free-market.can:1740
		}) -- models/free-market.can:1740
		reset_boxes_row["add"]({ -- models/free-market.can:1741
			["type"] = "button", -- models/free-market.can:1741
			["style"] = "FM_pull_out_button", -- models/free-market.can:1741
			["name"] = "FM_reset_pull_boxes" -- models/free-market.can:1741
		}) -- models/free-market.can:1741
		reset_boxes_row["add"]({ -- models/free-market.can:1742
			["type"] = "button", -- models/free-market.can:1742
			["style"] = "FM_buy_button", -- models/free-market.can:1742
			["name"] = "FM_reset_buy_boxes" -- models/free-market.can:1742
		}) -- models/free-market.can:1742
		reset_boxes_row["add"]({ -- models/free-market.can:1743
			["type"] = "button", -- models/free-market.can:1743
			["caption"] = { "free-market.reset-all-types" }, -- models/free-market.can:1743
			["name"] = "FM_reset_all_boxes" -- models/free-market.can:1743
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1743
	end -- models/free-market.can:1743
	local setting_row = content["add"](FLOW) -- models/free-market.can:1746
	setting_row["style"]["vertical_align"] = "center" -- models/free-market.can:1747
	setting_row["add"](LABEL)["caption"] = { -- models/free-market.can:1748
		"", -- models/free-market.can:1748
		{ "free-market.default-storage-limit" }, -- models/free-market.can:1748
		COLON -- models/free-market.can:1748
	} -- models/free-market.can:1748
	local default_limit_textfield = setting_row["add"](DEFAULT_LIMIT_TEXTFIELD) -- models/free-market.can:1749
	local default_limit = default_storage_limit[force["index"]] or max_storage_threshold -- models/free-market.can:1750
	default_limit_textfield["text"] = tostring(default_limit) -- models/free-market.can:1751
	setting_row["add"](CHECK_BUTTON)["name"] = "FM_confirm_default_limit" -- models/free-market.can:1752
	local label = content["add"](LABEL) -- models/free-market.can:1754
	label["caption"] = { -- models/free-market.can:1755
		"", -- models/free-market.can:1755
		{ "gui.credits" }, -- models/free-market.can:1755
		COLON -- models/free-market.can:1755
	} -- models/free-market.can:1755
	label["style"]["font"] = "heading-1" -- models/free-market.can:1756
	local translations_row = content["add"](FLOW) -- models/free-market.can:1757
	translations_row["add"](LABEL)["caption"] = { -- models/free-market.can:1758
		"", -- models/free-market.can:1758
		"Translations", -- models/free-market.can:1758
		COLON -- models/free-market.can:1758
	} -- models/free-market.can:1758
	local link = translations_row["add"]({ -- models/free-market.can:1759
		["type"] = "textfield", -- models/free-market.can:1759
		["text"] = "https://crowdin.com/project/factorio-mods-localization" -- models/free-market.can:1759
	}) -- models/free-market.can:1759
	link["style"]["horizontally_stretchable"] = true -- models/free-market.can:1760
	link["style"]["width"] = 320 -- models/free-market.can:1761
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1762
		"", -- models/free-market.can:1762
		"Translators", -- models/free-market.can:1762
		COLON, -- models/free-market.can:1762
		" ", -- models/free-market.can:1762
		"Eerrikki (Robin Braathen), eifel (Eifel87), zszzlzm (刘泽民), Spielen01231 (TheFakescribtx2), Drilzxx_ (Kévin), eifel (Eifel87), Felix_Manning (Felix Manning), ZwerOxotnik" -- models/free-market.can:1762
	} -- models/free-market.can:1762
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1763
		"", -- models/free-market.can:1763
		"Supporters", -- models/free-market.can:1763
		COLON, -- models/free-market.can:1763
		" ", -- models/free-market.can:1763
		"Eerrikki" -- models/free-market.can:1763
	} -- models/free-market.can:1763
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1764
		"", -- models/free-market.can:1764
		{ "gui-other-settings.developer" }, -- models/free-market.can:1764
		COLON, -- models/free-market.can:1764
		" ", -- models/free-market.can:1764
		"ZwerOxotnik" -- models/free-market.can:1764
	} -- models/free-market.can:1764
	local text_box = content["add"]({ ["type"] = "text-box" }) -- models/free-market.can:1765
	text_box["read_only"] = true -- models/free-market.can:1766
	text_box["text"] = "see-prices.png from https://www.svgrepo.com/svg/77065/price-tag\
" .. "change-price.png from https://www.svgrepo.com/svg/96982/price-tag\
" .. "embargo.png is modified version of https://www.svgrepo.com/svg/97012/price-tag" .. "Modified versions of https://www.svgrepo.com/svg/11042/shopping-cart-with-down-arrow-e-commerce-symbol" .. "Modified versions of https://www.svgrepo.com/svg/89258/rubbish-bin" -- models/free-market.can:1771
	text_box["style"]["maximal_width"] = 0 -- models/free-market.can:1772
	text_box["style"]["height"] = 70 -- models/free-market.can:1773
	text_box["style"]["horizontally_stretchable"] = true -- models/free-market.can:1774
	text_box["style"]["vertically_stretchable"] = true -- models/free-market.can:1775
	main_frame["force_auto_center"]() -- models/free-market.can:1777
end -- models/free-market.can:1777
local function switch_prices_gui(player, item_name) -- models/free-market.can:1782
	local screen = player["gui"]["screen"] -- models/free-market.can:1783
	local main_frame = screen["FM_prices_frame"] -- models/free-market.can:1784
	if main_frame then -- models/free-market.can:1785
		if item_name == nil then -- models/free-market.can:1786
			main_frame["destroy"]() -- models/free-market.can:1787
		else -- models/free-market.can:1787
			local content_flow = main_frame["shallow_frame"]["content_flow"] -- models/free-market.can:1789
			local item_row = main_frame["shallow_frame"]["content_flow"]["item_row"] -- models/free-market.can:1790
			item_row["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:1791
			local force_index = player["force"]["index"] -- models/free-market.can:1793
			local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1794
			if sell_price then -- models/free-market.can:1795
				item_row["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:1796
			end -- models/free-market.can:1796
			local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1798
			if buy_price then -- models/free-market.can:1799
				item_row["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:1800
			end -- models/free-market.can:1800
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:1802
		end -- models/free-market.can:1802
		return  -- models/free-market.can:1804
	end -- models/free-market.can:1804
	local force_index = player["force"]["index"] -- models/free-market.can:1807
	main_frame = screen["add"]({ -- models/free-market.can:1809
		["type"] = "frame", -- models/free-market.can:1809
		["name"] = "FM_prices_frame", -- models/free-market.can:1809
		["direction"] = "vertical" -- models/free-market.can:1809
	}) -- models/free-market.can:1809
	main_frame["location"] = { -- models/free-market.can:1810
		["x"] = 100 / player["display_scale"], -- models/free-market.can:1810
		["y"] = 50 -- models/free-market.can:1810
	} -- models/free-market.can:1810
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1811
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1812
	flow["add"]({ -- models/free-market.can:1813
		["type"] = "label", -- models/free-market.can:1814
		["style"] = "frame_title", -- models/free-market.can:1815
		["caption"] = { "free-market.prices" }, -- models/free-market.can:1816
		["ignored_by_interaction"] = true -- models/free-market.can:1817
	}) -- models/free-market.can:1817
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1819
	flow["add"]({ -- models/free-market.can:1820
		["type"] = "sprite-button", -- models/free-market.can:1821
		["style"] = "frame_action_button", -- models/free-market.can:1822
		["sprite"] = "refresh_white_icon", -- models/free-market.can:1823
		["name"] = "FM_refresh_prices_table" -- models/free-market.can:1824
	}) -- models/free-market.can:1824
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1826
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1827
		["type"] = "frame", -- models/free-market.can:1827
		["name"] = "shallow_frame", -- models/free-market.can:1827
		["style"] = "inside_shallow_frame", -- models/free-market.can:1827
		["direction"] = "vertical" -- models/free-market.can:1827
	}) -- models/free-market.can:1827
	local content = shallow_frame["add"]({ -- models/free-market.can:1828
		["type"] = "flow", -- models/free-market.can:1828
		["name"] = "content_flow", -- models/free-market.can:1828
		["direction"] = "vertical" -- models/free-market.can:1828
	}) -- models/free-market.can:1828
	content["style"]["padding"] = 12 -- models/free-market.can:1829
	local item_row = content["add"](FLOW) -- models/free-market.can:1831
	local add = item_row["add"] -- models/free-market.can:1832
	item_row["name"] = "item_row" -- models/free-market.can:1833
	item_row["style"]["vertical_align"] = "center" -- models/free-market.can:1834
	local item = add({ -- models/free-market.can:1835
		["type"] = "choose-elem-button", -- models/free-market.can:1835
		["name"] = "FM_prices_item", -- models/free-market.can:1835
		["elem_type"] = "item", -- models/free-market.can:1835
		["elem_filters"] = ITEM_FILTERS -- models/free-market.can:1835
	}) -- models/free-market.can:1835
	item["elem_value"] = item_name -- models/free-market.can:1836
	add(LABEL)["caption"] = { "free-market.buy-gui" } -- models/free-market.can:1837
	local buy_textfield = add(BUY_PRICE_TEXTFIELD) -- models/free-market.can:1838
	if item_name then -- models/free-market.can:1839
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1840
		if price then -- models/free-market.can:1841
			buy_textfield["text"] = tostring(price) -- models/free-market.can:1842
		end -- models/free-market.can:1842
	end -- models/free-market.can:1842
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price" -- models/free-market.can:1845
	add(LABEL)["caption"] = { "free-market.sell-gui" } -- models/free-market.can:1846
	local sell_textfield = add(SELL_PRICE_TEXTFIELD) -- models/free-market.can:1847
	if item_name then -- models/free-market.can:1848
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1849
		if price then -- models/free-market.can:1850
			sell_textfield["text"] = tostring(price) -- models/free-market.can:1851
		end -- models/free-market.can:1851
	end -- models/free-market.can:1851
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price" -- models/free-market.can:1854
	local storage_row = content["add"](FLOW) -- models/free-market.can:1856
	local add = storage_row["add"] -- models/free-market.can:1857
	storage_row["name"] = "storage_row" -- models/free-market.can:1858
	storage_row["style"]["vertical_align"] = "center" -- models/free-market.can:1859
	add(LABEL)["caption"] = { -- models/free-market.can:1860
		"", -- models/free-market.can:1860
		{ "description.storage" }, -- models/free-market.can:1860
		COLON -- models/free-market.can:1860
	} -- models/free-market.can:1860
	local storage_count = add(LABEL) -- models/free-market.can:1861
	storage_count["name"] = "storage_count" -- models/free-market.can:1862
	add(LABEL)["caption"] = "/" -- models/free-market.can:1863
	local storage_limit_textfield = add(STORAGE_LIMIT_TEXTFIELD) -- models/free-market.can:1864
	add(CHECK_BUTTON)["name"] = "FM_confirm_storage_limit" -- models/free-market.can:1865
	if item_name == nil then -- models/free-market.can:1866
		storage_row["visible"] = false -- models/free-market.can:1867
	else -- models/free-market.can:1867
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:1869
		storage_count["caption"] = tostring(count) -- models/free-market.can:1870
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:1871
		storage_limit_textfield["text"] = tostring(limit) -- models/free-market.can:1872
	end -- models/free-market.can:1872
	local prices_frame = content["add"]({ -- models/free-market.can:1875
		["type"] = "frame", -- models/free-market.can:1875
		["name"] = "other_prices_frame", -- models/free-market.can:1875
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1875
		["direction"] = "vertical" -- models/free-market.can:1875
	}) -- models/free-market.can:1875
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1876
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1877
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1878
		["type"] = "table", -- models/free-market.can:1878
		["name"] = "prices_table", -- models/free-market.can:1878
		["column_count"] = 3 -- models/free-market.can:1878
	}) -- models/free-market.can:1878
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1879
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1880
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:1881
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1882
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1883
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1884
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:1885
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:1886
	if item_name then -- models/free-market.can:1887
		update_prices_table(player, item_name, prices_table) -- models/free-market.can:1888
	else -- models/free-market.can:1888
		make_prices_header(prices_table) -- models/free-market.can:1890
	end -- models/free-market.can:1890
	return content -- models/free-market.can:1893
end -- models/free-market.can:1893
local function open_storage_gui(player) -- models/free-market.can:1896
	local screen = player["gui"]["screen"] -- models/free-market.can:1897
	local main_frame = screen["FM_storage_frame"] -- models/free-market.can:1898
	if main_frame then -- models/free-market.can:1899
		main_frame["destroy"]() -- models/free-market.can:1900
		return  -- models/free-market.can:1901
	end -- models/free-market.can:1901
	main_frame = screen["add"]({ -- models/free-market.can:1904
		["type"] = "frame", -- models/free-market.can:1904
		["name"] = "FM_storage_frame", -- models/free-market.can:1904
		["direction"] = "vertical" -- models/free-market.can:1904
	}) -- models/free-market.can:1904
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1905
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1906
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1907
	flow["add"]({ -- models/free-market.can:1908
		["type"] = "label", -- models/free-market.can:1909
		["style"] = "frame_title", -- models/free-market.can:1910
		["caption"] = { "description.storage" }, -- models/free-market.can:1911
		["ignored_by_interaction"] = true -- models/free-market.can:1912
	}) -- models/free-market.can:1912
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1914
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1915
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1916
		["type"] = "frame", -- models/free-market.can:1916
		["name"] = "shallow_frame", -- models/free-market.can:1916
		["style"] = "inside_shallow_frame", -- models/free-market.can:1916
		["direction"] = "vertical" -- models/free-market.can:1916
	}) -- models/free-market.can:1916
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1917
		["type"] = "flow", -- models/free-market.can:1917
		["name"] = "content_flow", -- models/free-market.can:1917
		["direction"] = "vertical" -- models/free-market.can:1917
	}) -- models/free-market.can:1917
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1918
	local scroll_pane = content_flow["add"](SCROLL_PANE) -- models/free-market.can:1920
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1921
	local storage_table = scroll_pane["add"]({ -- models/free-market.can:1922
		["type"] = "table", -- models/free-market.can:1922
		["name"] = "FM_storage_table", -- models/free-market.can:1922
		["column_count"] = 2 -- models/free-market.can:1922
	}) -- models/free-market.can:1922
	storage_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1923
	storage_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1924
	storage_table["style"]["top_margin"] = - 16 -- models/free-market.can:1925
	storage_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1926
	storage_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1927
	storage_table["draw_horizontal_lines"] = true -- models/free-market.can:1928
	storage_table["draw_vertical_lines"] = true -- models/free-market.can:1929
	make_storage_header(storage_table) -- models/free-market.can:1930
	local add = storage_table["add"] -- models/free-market.can:1932
	for item_name, count in pairs(storages[player["force"]["index"]]) do -- models/free-market.can:1933
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1934
		add(LABEL)["caption"] = tostring(count) -- models/free-market.can:1935
	end -- models/free-market.can:1935
	main_frame["force_auto_center"]() -- models/free-market.can:1938
end -- models/free-market.can:1938
local function open_price_list_gui(player) -- models/free-market.can:1941
	local screen = player["gui"]["screen"] -- models/free-market.can:1942
	if screen["FM_price_list_frame"] then -- models/free-market.can:1943
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1944
		return  -- models/free-market.can:1945
	end -- models/free-market.can:1945
	local main_frame = screen["add"]({ -- models/free-market.can:1947
		["type"] = "frame", -- models/free-market.can:1947
		["name"] = "FM_price_list_frame", -- models/free-market.can:1947
		["direction"] = "vertical" -- models/free-market.can:1947
	}) -- models/free-market.can:1947
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1948
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1949
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1950
	flow["add"]({ -- models/free-market.can:1951
		["type"] = "label", -- models/free-market.can:1952
		["style"] = "frame_title", -- models/free-market.can:1953
		["caption"] = { "free-market.price-list" }, -- models/free-market.can:1954
		["ignored_by_interaction"] = true -- models/free-market.can:1955
	}) -- models/free-market.can:1955
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1957
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1958
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1959
		["type"] = "frame", -- models/free-market.can:1959
		["name"] = "shallow_frame", -- models/free-market.can:1959
		["style"] = "inside_shallow_frame", -- models/free-market.can:1959
		["direction"] = "vertical" -- models/free-market.can:1959
	}) -- models/free-market.can:1959
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1960
		["type"] = "flow", -- models/free-market.can:1960
		["name"] = "content_flow", -- models/free-market.can:1960
		["direction"] = "vertical" -- models/free-market.can:1960
	}) -- models/free-market.can:1960
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1961
	local team_row = content_flow["add"](FLOW) -- models/free-market.can:1963
	team_row["name"] = "team_row" -- models/free-market.can:1964
	team_row["add"](LABEL)["caption"] = { -- models/free-market.can:1965
		"", -- models/free-market.can:1965
		{ "team" }, -- models/free-market.can:1965
		COLON -- models/free-market.can:1965
	} -- models/free-market.can:1965
	local items = {} -- models/free-market.can:1966
	local size = 0 -- models/free-market.can:1967
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1968
		local force_index = force["index"] -- models/free-market.can:1969
		local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1970
		local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1971
		if (f_sell_prices and next(f_sell_prices)) or (f_buy_prices and next(f_buy_prices)) then -- models/free-market.can:1972
			size = size + 1 -- models/free-market.can:1973
			items[size] = force_name -- models/free-market.can:1974
		end -- models/free-market.can:1974
	end -- models/free-market.can:1974
	team_row["add"]({ -- models/free-market.can:1977
		["type"] = "drop-down", -- models/free-market.can:1977
		["name"] = "FM_force_price_list", -- models/free-market.can:1977
		["items"] = items -- models/free-market.can:1977
	}) -- models/free-market.can:1977
	local search_row = content_flow["add"]({ -- models/free-market.can:1979
		["type"] = "table", -- models/free-market.can:1979
		["name"] = "search_row", -- models/free-market.can:1979
		["column_count"] = 4 -- models/free-market.can:1979
	}) -- models/free-market.can:1979
	search_row["add"]({ -- models/free-market.can:1980
		["type"] = "textfield", -- models/free-market.can:1980
		["name"] = "FM_search_text" -- models/free-market.can:1980
	}) -- models/free-market.can:1980
	search_row["add"](LABEL)["caption"] = { -- models/free-market.can:1981
		"", -- models/free-market.can:1981
		{ "gui.search" }, -- models/free-market.can:1981
		COLON -- models/free-market.can:1981
	} -- models/free-market.can:1981
	search_row["add"]({ -- models/free-market.can:1982
		["type"] = "drop-down", -- models/free-market.can:1983
		["name"] = "FM_search_price_drop_down", -- models/free-market.can:1984
		["items"] = { -- models/free-market.can:1985
			{ "free-market.sell-offer-gui" }, -- models/free-market.can:1985
			{ "free-market.buy-request-gui" } -- models/free-market.can:1985
		} -- models/free-market.can:1985
	}) -- models/free-market.can:1985
	search_row["add"]({ -- models/free-market.can:1987
		["type"] = "sprite-button", -- models/free-market.can:1988
		["style"] = "frame_action_button", -- models/free-market.can:1989
		["name"] = "FM_search_by_price", -- models/free-market.can:1990
		["hovered_sprite"] = "utility/search_black", -- models/free-market.can:1991
		["clicked_sprite"] = "utility/search_black", -- models/free-market.can:1992
		["sprite"] = "utility/search_white" -- models/free-market.can:1993
	}) -- models/free-market.can:1993
	local prices_frame = content_flow["add"]({ -- models/free-market.can:1996
		["type"] = "frame", -- models/free-market.can:1996
		["name"] = "deep_frame", -- models/free-market.can:1996
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1996
		["direction"] = "vertical" -- models/free-market.can:1996
	}) -- models/free-market.can:1996
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1997
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1998
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1999
		["type"] = "table", -- models/free-market.can:1999
		["name"] = "price_list_table", -- models/free-market.can:1999
		["column_count"] = 3 -- models/free-market.can:1999
	}) -- models/free-market.can:1999
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2000
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2001
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2002
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2003
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2004
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2005
	prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2006
	prices_table["style"]["column_alignments"][5] = "center" -- models/free-market.can:2007
	prices_table["style"]["column_alignments"][6] = "center" -- models/free-market.can:2008
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2009
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:2010
	make_price_list_header(prices_table) -- models/free-market.can:2011
	local short_prices_table = scroll_pane["add"]({ -- models/free-market.can:2013
		["type"] = "table", -- models/free-market.can:2013
		["name"] = "short_price_list_table", -- models/free-market.can:2013
		["column_count"] = 2 -- models/free-market.can:2013
	}) -- models/free-market.can:2013
	short_prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2014
	short_prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2015
	short_prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2016
	short_prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2017
	short_prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2018
	short_prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2019
	short_prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2020
	short_prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2021
	short_prices_table["draw_vertical_lines"] = true -- models/free-market.can:2022
	short_prices_table["visible"] = false -- models/free-market.can:2023
	main_frame["force_auto_center"]() -- models/free-market.can:2025
end -- models/free-market.can:2025
local function open_buy_box_gui(player, is_new, entity) -- models/free-market.can:2031
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2032
	box_operations["clear"]() -- models/free-market.can:2033
	if box_operations["buy_content"] and not is_new then -- models/free-market.can:2034
		return  -- models/free-market.can:2035
	end -- models/free-market.can:2035
	local row = box_operations["add"]({ -- models/free-market.can:2038
		["type"] = "table", -- models/free-market.can:2038
		["name"] = "buy_content", -- models/free-market.can:2038
		["column_count"] = 4 -- models/free-market.can:2038
	}) -- models/free-market.can:2038
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2039
	row["add"]({ -- models/free-market.can:2040
		["type"] = "label", -- models/free-market.can:2040
		["caption"] = { -- models/free-market.can:2040
			"", -- models/free-market.can:2040
			{ "free-market.count-gui" }, -- models/free-market.can:2040
			COLON -- models/free-market.can:2040
		} -- models/free-market.can:2040
	}) -- models/free-market.can:2040
	local count_element = row["add"]({ -- models/free-market.can:2041
		["type"] = "textfield", -- models/free-market.can:2041
		["name"] = "count", -- models/free-market.can:2041
		["numeric"] = true, -- models/free-market.can:2041
		["allow_decimal"] = false, -- models/free-market.can:2041
		["allow_negative"] = false -- models/free-market.can:2041
	}) -- models/free-market.can:2041
	count_element["style"]["width"] = 70 -- models/free-market.can:2042
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2043
	if is_new then -- models/free-market.can:2044
		confirm_button["name"] = "FM_confirm_buy_box" -- models/free-market.can:2045
	else -- models/free-market.can:2045
		confirm_button["name"] = "FM_change_buy_box" -- models/free-market.can:2047
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2048
		local entities_data = box_data[4] -- models/free-market.can:2049
		for i = 1, # entities_data do -- models/free-market.can:2050
			local buy_box = entities_data[i] -- models/free-market.can:2051
			if buy_box[1] == entity then -- models/free-market.can:2052
				count_element["text"] = tostring(buy_box[2]) -- models/free-market.can:2053
				break -- models/free-market.can:2054
			end -- models/free-market.can:2054
		end -- models/free-market.can:2054
		local item_name = box_data[5] -- models/free-market.can:2057
		FM_item["elem_value"] = item_name -- models/free-market.can:2058
	end -- models/free-market.can:2058
end -- models/free-market.can:2058
local function clear_boxes_gui(player) -- models/free-market.can:2062
	open_box[player["index"]] = nil -- models/free-market.can:2063
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:2064
end -- models/free-market.can:2064
local function open_transfer_box_gui(player, is_new, entity) -- models/free-market.can:2070
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2071
	box_operations["clear"]() -- models/free-market.can:2072
	if box_operations["transfer_content"] and not is_new then -- models/free-market.can:2073
		return  -- models/free-market.can:2074
	end -- models/free-market.can:2074
	local row = box_operations["add"]({ -- models/free-market.can:2077
		["type"] = "table", -- models/free-market.can:2077
		["name"] = "transfer_content", -- models/free-market.can:2077
		["column_count"] = 2 -- models/free-market.can:2077
	}) -- models/free-market.can:2077
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2078
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2079
	if is_new then -- models/free-market.can:2080
		confirm_button["name"] = "FM_confirm_transfer_box" -- models/free-market.can:2081
	else -- models/free-market.can:2081
		confirm_button["name"] = "FM_change_transfer_box" -- models/free-market.can:2083
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2084
	end -- models/free-market.can:2084
end -- models/free-market.can:2084
local function open_bin_box_gui(player, is_new, entity) -- models/free-market.can:2091
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2092
	box_operations["clear"]() -- models/free-market.can:2093
	if box_operations["bin_content"] and not is_new then -- models/free-market.can:2094
		return  -- models/free-market.can:2095
	end -- models/free-market.can:2095
	local row = box_operations["add"]({ -- models/free-market.can:2098
		["type"] = "table", -- models/free-market.can:2098
		["name"] = "bin_content", -- models/free-market.can:2098
		["column_count"] = 2 -- models/free-market.can:2098
	}) -- models/free-market.can:2098
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2099
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2100
	if is_new then -- models/free-market.can:2101
		confirm_button["name"] = "FM_confirm_bin_box" -- models/free-market.can:2102
	else -- models/free-market.can:2102
		confirm_button["name"] = "FM_change_bin_box" -- models/free-market.can:2104
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2105
	end -- models/free-market.can:2105
end -- models/free-market.can:2105
local function create_top_relative_gui(player) -- models/free-market.can:2109
	local relative = player["gui"]["relative"] -- models/free-market.can:2110
	local main_frame = relative["FM_boxes_frame"] -- models/free-market.can:2111
	if main_frame then -- models/free-market.can:2112
		main_frame["destroy"]() -- models/free-market.can:2113
	end -- models/free-market.can:2113
	local boxes_anchor = { -- models/free-market.can:2116
		["gui"] = defines["relative_gui_type"]["container_gui"], -- models/free-market.can:2116
		["position"] = defines["relative_gui_position"]["top"] -- models/free-market.can:2116
	} -- models/free-market.can:2116
	main_frame = relative["add"]({ -- models/free-market.can:2117
		["type"] = "frame", -- models/free-market.can:2117
		["name"] = "FM_boxes_frame", -- models/free-market.can:2117
		["anchor"] = boxes_anchor -- models/free-market.can:2117
	}) -- models/free-market.can:2117
	main_frame["style"]["vertical_align"] = "center" -- models/free-market.can:2118
	main_frame["style"]["horizontally_stretchable"] = false -- models/free-market.can:2119
	main_frame["style"]["bottom_margin"] = - 14 -- models/free-market.can:2120
	local frame = main_frame["add"]({ -- models/free-market.can:2121
		["type"] = "frame", -- models/free-market.can:2121
		["name"] = "content", -- models/free-market.can:2121
		["style"] = "inside_shallow_frame" -- models/free-market.can:2121
	}) -- models/free-market.can:2121
	local main_flow = frame["add"]({ -- models/free-market.can:2122
		["type"] = "flow", -- models/free-market.can:2122
		["name"] = "main_flow", -- models/free-market.can:2122
		["direction"] = "vertical" -- models/free-market.can:2122
	}) -- models/free-market.can:2122
	main_flow["style"]["vertical_spacing"] = 0 -- models/free-market.can:2123
	main_flow["add"](FLOW)["name"] = "box_operations" -- models/free-market.can:2124
	local flow = main_flow["add"](FLOW) -- models/free-market.can:2125
	flow["add"]({ -- models/free-market.can:2126
		["type"] = "button", -- models/free-market.can:2126
		["style"] = "FM_transfer_button", -- models/free-market.can:2126
		["name"] = "FM_set_transfer_box" -- models/free-market.can:2126
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2126
	flow["add"]({ -- models/free-market.can:2127
		["type"] = "button", -- models/free-market.can:2127
		["style"] = "FM_universal_transfer_button", -- models/free-market.can:2127
		["name"] = "FM_set_universal_transfer_box" -- models/free-market.can:2127
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2127
	flow["add"]({ -- models/free-market.can:2128
		["type"] = "button", -- models/free-market.can:2128
		["style"] = "FM_bin_button", -- models/free-market.can:2128
		["name"] = "FM_set_bin_box" -- models/free-market.can:2128
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2128
	flow["add"]({ -- models/free-market.can:2129
		["type"] = "button", -- models/free-market.can:2129
		["style"] = "FM_universal_bin_button", -- models/free-market.can:2129
		["name"] = "FM_set_universal_bin_box" -- models/free-market.can:2129
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2129
	flow["add"]({ -- models/free-market.can:2130
		["type"] = "button", -- models/free-market.can:2130
		["style"] = "FM_pull_out_button", -- models/free-market.can:2130
		["name"] = "FM_set_pull_box" -- models/free-market.can:2130
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2130
	flow["add"]({ -- models/free-market.can:2131
		["type"] = "button", -- models/free-market.can:2131
		["style"] = "FM_buy_button", -- models/free-market.can:2131
		["name"] = "FM_set_buy_box" -- models/free-market.can:2131
	}) -- models/free-market.can:2131
end -- models/free-market.can:2131
local function open_pull_box_gui(player, is_new, entity) -- models/free-market.can:2137
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2138
	box_operations["clear"]() -- models/free-market.can:2139
	if box_operations["pull_content"] then -- models/free-market.can:2140
		return  -- models/free-market.can:2141
	end -- models/free-market.can:2141
	local row = box_operations["add"]({ -- models/free-market.can:2143
		["type"] = "table", -- models/free-market.can:2143
		["name"] = "pull_content", -- models/free-market.can:2143
		["column_count"] = 2 -- models/free-market.can:2143
	}) -- models/free-market.can:2143
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2144
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2145
	if is_new then -- models/free-market.can:2146
		confirm_button["name"] = "FM_confirm_pull_box" -- models/free-market.can:2147
	else -- models/free-market.can:2147
		confirm_button["name"] = "FM_change_pull_box" -- models/free-market.can:2149
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2150
	end -- models/free-market.can:2150
end -- models/free-market.can:2150
local function create_left_relative_gui(player) -- models/free-market.can:2154
	local relative = player["gui"]["relative"] -- models/free-market.can:2155
	local main_table = relative["FM_buttons"] -- models/free-market.can:2156
	if main_table then -- models/free-market.can:2157
		main_table["destroy"]() -- models/free-market.can:2158
	end -- models/free-market.can:2158
	local left_anchor = { -- models/free-market.can:2161
		["gui"] = defines["relative_gui_type"]["controller_gui"], -- models/free-market.can:2161
		["position"] = defines["relative_gui_position"]["left"] -- models/free-market.can:2161
	} -- models/free-market.can:2161
	main_table = relative["add"]({ -- models/free-market.can:2162
		["type"] = "table", -- models/free-market.can:2162
		["name"] = "FM_buttons", -- models/free-market.can:2162
		["anchor"] = left_anchor, -- models/free-market.can:2162
		["column_count"] = 2 -- models/free-market.can:2162
	}) -- models/free-market.can:2162
	main_table["style"]["vertical_align"] = "center" -- models/free-market.can:2163
	main_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2164
	main_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2165
	local button = main_table["add"]({ -- models/free-market.can:2167
		["type"] = "button", -- models/free-market.can:2167
		["style"] = "side_menu_button", -- models/free-market.can:2167
		["caption"] = ">", -- models/free-market.can:2167
		["name"] = "FM_hide_left_buttons" -- models/free-market.can:2167
	}) -- models/free-market.can:2167
	button["style"]["font"] = "default-dialog-button" -- models/free-market.can:2168
	button["style"]["font_color"] = WHITE_COLOR -- models/free-market.can:2169
	button["style"]["top_padding"] = - 4 -- models/free-market.can:2170
	button["style"]["width"] = 18 -- models/free-market.can:2171
	button["style"]["height"] = 20 -- models/free-market.can:2172
	local frame = main_table["add"]({ -- models/free-market.can:2174
		["type"] = "frame", -- models/free-market.can:2174
		["name"] = "content" -- models/free-market.can:2174
	}) -- models/free-market.can:2174
	frame["style"]["right_margin"] = - 14 -- models/free-market.can:2175
	local shallow_frame = frame["add"]({ -- models/free-market.can:2176
		["type"] = "frame", -- models/free-market.can:2176
		["name"] = "shallow_frame", -- models/free-market.can:2176
		["style"] = "inside_shallow_frame" -- models/free-market.can:2176
	}) -- models/free-market.can:2176
	local buttons_table = shallow_frame["add"]({ -- models/free-market.can:2177
		["type"] = "table", -- models/free-market.can:2177
		["column_count"] = 3 -- models/free-market.can:2177
	}) -- models/free-market.can:2177
	buttons_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2178
	buttons_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2179
	buttons_table["add"]({ -- models/free-market.can:2180
		["type"] = "sprite-button", -- models/free-market.can:2180
		["sprite"] = "FM_change-price", -- models/free-market.can:2180
		["style"] = "slot_button", -- models/free-market.can:2180
		["name"] = "FM_open_price" -- models/free-market.can:2180
	}) -- models/free-market.can:2180
	buttons_table["add"]({ -- models/free-market.can:2181
		["type"] = "sprite-button", -- models/free-market.can:2181
		["sprite"] = "FM_see-prices", -- models/free-market.can:2181
		["style"] = "slot_button", -- models/free-market.can:2181
		["name"] = "FM_open_price_list" -- models/free-market.can:2181
	}) -- models/free-market.can:2181
	buttons_table["add"]({ -- models/free-market.can:2182
		["type"] = "sprite-button", -- models/free-market.can:2182
		["sprite"] = "FM_embargo", -- models/free-market.can:2182
		["style"] = "slot_button", -- models/free-market.can:2182
		["name"] = "FM_open_embargo" -- models/free-market.can:2182
	}) -- models/free-market.can:2182
	buttons_table["add"]({ -- models/free-market.can:2183
		["type"] = "sprite-button", -- models/free-market.can:2183
		["sprite"] = "item/wooden-chest", -- models/free-market.can:2183
		["style"] = "slot_button", -- models/free-market.can:2183
		["name"] = "FM_open_storage" -- models/free-market.can:2183
	}) -- models/free-market.can:2183
	buttons_table["add"]({ -- models/free-market.can:2184
		["type"] = "sprite-button", -- models/free-market.can:2184
		["sprite"] = "virtual-signal/signal-info", -- models/free-market.can:2184
		["style"] = "slot_button", -- models/free-market.can:2184
		["name"] = "FM_show_hint" -- models/free-market.can:2184
	}) -- models/free-market.can:2184
	buttons_table["add"]({ -- models/free-market.can:2185
		["type"] = "sprite-button", -- models/free-market.can:2186
		["sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2187
		["hovered_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2188
		["clicked_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2189
		["style"] = "slot_button", -- models/free-market.can:2190
		["name"] = "FM_open_force_configuration" -- models/free-market.can:2191
	}) -- models/free-market.can:2191
end -- models/free-market.can:2191
local function check_buy_price(player, item_name) -- models/free-market.can:2197
	local force_index = player["force"]["index"] -- models/free-market.can:2198
	if buy_prices[force_index][item_name] == nil then -- models/free-market.can:2199
		local screen = player["gui"]["screen"] -- models/free-market.can:2200
		local prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2201
		local content_flow -- models/free-market.can:2202
		if prices_frame == nil then -- models/free-market.can:2203
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2204
			prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2205
		else -- models/free-market.can:2205
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2207
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2208
			local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2209
			if sell_price then -- models/free-market.can:2210
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:2211
			end -- models/free-market.can:2211
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2213
		end -- models/free-market.can:2213
		content_flow["item_row"]["buy_price"]["focus"]() -- models/free-market.can:2215
	end -- models/free-market.can:2215
end -- models/free-market.can:2215
local function check_sell_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2222
	local force_index = player["force"]["index"] -- models/free-market.can:2223
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2224
	if sell_price then -- models/free-market.can:2225
		return  -- models/free-market.can:2225
	end -- models/free-market.can:2225
	local row = gui["add"]({ -- models/free-market.can:2227
		["type"] = "table", -- models/free-market.can:2227
		["name"] = "sell_price_table", -- models/free-market.can:2227
		["column_count"] = 4 -- models/free-market.can:2227
	}) -- models/free-market.can:2227
	local add = row["add"] -- models/free-market.can:2228
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2229
	add(LABEL)["caption"] = { -- models/free-market.can:2230
		"", -- models/free-market.can:2230
		{ "free-market.sell-price-label" }, -- models/free-market.can:2230
		COLON -- models/free-market.can:2230
	} -- models/free-market.can:2230
	add(SELL_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2231
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price_for_chest" -- models/free-market.can:2232
end -- models/free-market.can:2232
local function check_buy_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2238
	local force_index = player["force"]["index"] -- models/free-market.can:2239
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2240
	if buy_price then -- models/free-market.can:2241
		return  -- models/free-market.can:2241
	end -- models/free-market.can:2241
	local row = gui["add"]({ -- models/free-market.can:2243
		["type"] = "table", -- models/free-market.can:2243
		["name"] = "buy_price_table", -- models/free-market.can:2243
		["column_count"] = 4 -- models/free-market.can:2243
	}) -- models/free-market.can:2243
	local add = row["add"] -- models/free-market.can:2244
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2245
	add(LABEL)["caption"] = { -- models/free-market.can:2246
		"", -- models/free-market.can:2246
		{ "free-market.buy-price-label" }, -- models/free-market.can:2246
		COLON -- models/free-market.can:2246
	} -- models/free-market.can:2246
	add(BUY_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2247
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price_for_chest" -- models/free-market.can:2248
end -- models/free-market.can:2248
local function check_sell_price(player, item_name) -- models/free-market.can:2253
	local force_index = player["force"]["index"] -- models/free-market.can:2254
	if sell_prices[force_index][item_name] == nil then -- models/free-market.can:2255
		local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2256
		local content_flow -- models/free-market.can:2257
		if prices_frame == nil then -- models/free-market.can:2258
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2259
			prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2260
		else -- models/free-market.can:2260
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2262
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2263
			local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2264
			if buy_price then -- models/free-market.can:2265
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:2266
			end -- models/free-market.can:2266
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2268
		end -- models/free-market.can:2268
		content_flow["item_row"]["sell_price"]["focus"]() -- models/free-market.can:2270
	end -- models/free-market.can:2270
end -- models/free-market.can:2270
local function create_item_price_HUD(player) -- models/free-market.can:2275
	local screen = player["gui"]["screen"] -- models/free-market.can:2276
	local main_frame = screen["FM_item_price_frame"] -- models/free-market.can:2277
	if main_frame then -- models/free-market.can:2278
		return  -- models/free-market.can:2279
	end -- models/free-market.can:2279
	main_frame = screen["add"]({ -- models/free-market.can:2282
		["type"] = "frame", -- models/free-market.can:2282
		["name"] = "FM_item_price_frame", -- models/free-market.can:2282
		["style"] = "FM_item_price_frame", -- models/free-market.can:2282
		["direction"] = "horizontal" -- models/free-market.can:2282
	}) -- models/free-market.can:2282
	main_frame["location"] = { -- models/free-market.can:2283
		["x"] = player["display_resolution"]["width"] / 2, -- models/free-market.can:2283
		["y"] = 10 -- models/free-market.can:2283
	} -- models/free-market.can:2283
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:2285
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:2286
	drag_handler["drag_target"] = main_frame -- models/free-market.can:2287
	drag_handler["style"]["vertically_stretchable"] = true -- models/free-market.can:2288
	drag_handler["style"]["minimal_height"] = 22 -- models/free-market.can:2289
	drag_handler["style"]["maximal_height"] = 0 -- models/free-market.can:2290
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:2291
	drag_handler["style"]["width"] = 10 -- models/free-market.can:2292
	local info_flow = main_frame["add"](VERTICAL_FLOW) -- models/free-market.can:2294
	info_flow["visible"] = false -- models/free-market.can:2295
	local hud_table = info_flow["add"]({ -- models/free-market.can:2296
		["type"] = "table", -- models/free-market.can:2296
		["column_count"] = 2 -- models/free-market.can:2296
	}) -- models/free-market.can:2296
	local add = hud_table["add"] -- models/free-market.can:2297
	hud_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2298
	hud_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2299
	add(LABEL)["caption"] = { -- models/free-market.can:2301
		"", -- models/free-market.can:2301
		{ "free-market.sell-price-label" }, -- models/free-market.can:2301
		COLON -- models/free-market.can:2301
	} -- models/free-market.can:2301
	local sell_price = add(LABEL) -- models/free-market.can:2302
	add(LABEL)["caption"] = { -- models/free-market.can:2304
		"", -- models/free-market.can:2304
		{ "free-market.buy-price-label" }, -- models/free-market.can:2304
		COLON -- models/free-market.can:2304
	} -- models/free-market.can:2304
	local buy_price = add(LABEL) -- models/free-market.can:2305
	local storage_flow = info_flow["add"](FLOW) -- models/free-market.can:2308
	local add = storage_flow["add"] -- models/free-market.can:2309
	local item_label = add(LABEL) -- models/free-market.can:2310
	add(LABEL)["caption"] = { -- models/free-market.can:2311
		"", -- models/free-market.can:2311
		{ "description.storage" }, -- models/free-market.can:2311
		COLON -- models/free-market.can:2311
	} -- models/free-market.can:2311
	local storage_count = add(LABEL) -- models/free-market.can:2312
	add(LABEL)["caption"] = "/" -- models/free-market.can:2314
	local storage_limit = add(LABEL) -- models/free-market.can:2315
	item_HUD[player["index"]] = { -- models/free-market.can:2318
		info_flow, -- models/free-market.can:2319
		sell_price, -- models/free-market.can:2320
		buy_price, -- models/free-market.can:2321
		item_label, -- models/free-market.can:2322
		storage_count, -- models/free-market.can:2323
		storage_limit -- models/free-market.can:2324
	} -- models/free-market.can:2324
end -- models/free-market.can:2324
local function hide_item_price_HUD(player) -- models/free-market.can:2329
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2330
	if hinter then -- models/free-market.can:2331
		hinter[1]["visible"] = false -- models/free-market.can:2332
	end -- models/free-market.can:2332
end -- models/free-market.can:2332
local function show_item_info_HUD(player, item_name) -- models/free-market.can:2338
	local force_index = player["force"]["index"] -- models/free-market.can:2339
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2340
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2341
	local count = storages[force_index][item_name] -- models/free-market.can:2342
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2343
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2345
	hinter[1]["visible"] = true -- models/free-market.can:2346
	if sell_price then -- models/free-market.can:2347
		hinter[2]["caption"] = tostring(sell_price) -- models/free-market.can:2348
	else -- models/free-market.can:2348
		hinter[2]["caption"] = "" -- models/free-market.can:2350
	end -- models/free-market.can:2350
	if buy_price then -- models/free-market.can:2352
		hinter[3]["caption"] = tostring(buy_price) -- models/free-market.can:2353
	else -- models/free-market.can:2353
		hinter[3]["caption"] = "" -- models/free-market.can:2355
	end -- models/free-market.can:2355
	hinter[4]["caption"] = "[item=" .. item_name .. "]" -- models/free-market.can:2357
	if count then -- models/free-market.can:2358
		hinter[5]["caption"] = tostring(count) -- models/free-market.can:2359
	else -- models/free-market.can:2359
		hinter[5]["caption"] = "0" -- models/free-market.can:2361
	end -- models/free-market.can:2361
	hinter[6]["caption"] = limit -- models/free-market.can:2363
end -- models/free-market.can:2363
local REMOVE_BOX_FUNCS = { -- models/free-market.can:2371
	[1] = remove_certain_buy_box, -- models/free-market.can:2372
	[3] = remove_certain_pull_box, -- models/free-market.can:2373
	[4] = remove_certain_transfer_box, -- models/free-market.can:2374
	[5] = remove_certain_universal_transfer_box, -- models/free-market.can:2375
	[6] = remove_certain_bin_box, -- models/free-market.can:2376
	[7] = remove_certain_universal_bin_box -- models/free-market.can:2377
} -- models/free-market.can:2377
local function clear_box_data(event) -- models/free-market.can:2379
	local entity = event["entity"] -- models/free-market.can:2380
	local unit_number = entity["unit_number"] -- models/free-market.can:2381
	local box_data = all_boxes[unit_number] -- models/free-market.can:2382
	if box_data == nil then -- models/free-market.can:2383
		return  -- models/free-market.can:2383
	end -- models/free-market.can:2383
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2385
end -- models/free-market.can:2385
local function clear_box_data_by_entity(entity) -- models/free-market.can:2389
	local unit_number = entity["unit_number"] -- models/free-market.can:2390
	local box_data = all_boxes[unit_number] -- models/free-market.can:2391
	if box_data == nil then -- models/free-market.can:2392
		return  -- models/free-market.can:2392
	end -- models/free-market.can:2392
	rendering_destroy(box_data[2]) -- models/free-market.can:2394
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2395
	return true -- models/free-market.can:2396
end -- models/free-market.can:2396
local function on_player_created(event) -- models/free-market.can:2399
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2400
	if not (player and player["valid"]) then -- models/free-market.can:2401
		return  -- models/free-market.can:2401
	end -- models/free-market.can:2401
	create_item_price_HUD(player) -- models/free-market.can:2403
	create_top_relative_gui(player) -- models/free-market.can:2404
	create_left_relative_gui(player) -- models/free-market.can:2405
	switch_sell_prices_gui(player) -- models/free-market.can:2406
	switch_buy_prices_gui(player) -- models/free-market.can:2407
	if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2408
		create_item_price_HUD(player) -- models/free-market.can:2409
	end -- models/free-market.can:2409
end -- models/free-market.can:2409
local function on_player_joined_game(event) -- models/free-market.can:2414
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2415
	if not (player and player["valid"]) then -- models/free-market.can:2416
		return  -- models/free-market.can:2416
	end -- models/free-market.can:2416
	if # game["connected_players"] == 1 then -- models/free-market.can:2418
		clear_invalid_player_data() -- models/free-market.can:2419
	end -- models/free-market.can:2419
	clear_boxes_gui(player) -- models/free-market.can:2422
	destroy_prices_gui(player) -- models/free-market.can:2423
	destroy_price_list_gui(player) -- models/free-market.can:2424
	create_item_price_HUD(player) -- models/free-market.can:2425
	switch_sell_prices_gui(player) -- models/free-market.can:2428
	switch_sell_prices_gui(player) -- models/free-market.can:2429
	switch_buy_prices_gui(player) -- models/free-market.can:2430
	switch_buy_prices_gui(player) -- models/free-market.can:2431
	open_embargo_gui(player) -- models/free-market.can:2433
	open_force_configuration(player) -- models/free-market.can:2434
	open_storage_gui(player) -- models/free-market.can:2435
	open_price_list_gui(player) -- models/free-market.can:2436
	switch_prices_gui(player) -- models/free-market.can:2438
	switch_prices_gui(player) -- models/free-market.can:2439
	switch_prices_gui(player) -- models/free-market.can:2440
	for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:2441
		switch_prices_gui(player, item_name) -- models/free-market.can:2442
	end -- models/free-market.can:2442
end -- models/free-market.can:2442
local function on_player_cursor_stack_changed(event) -- models/free-market.can:2447
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2448
	local cursor_stack = player["cursor_stack"] -- models/free-market.can:2449
	if cursor_stack["valid_for_read"] then -- models/free-market.can:2450
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2451
			show_item_info_HUD(player, cursor_stack["name"]) -- models/free-market.can:2452
		end -- models/free-market.can:2452
	else -- models/free-market.can:2452
		hide_item_price_HUD(player) -- models/free-market.can:2455
	end -- models/free-market.can:2455
end -- models/free-market.can:2455
local function on_force_created(event) -- models/free-market.can:2459
	init_force_data(event["force"]["index"]) -- models/free-market.can:2460
end -- models/free-market.can:2460
local function check_teams_data() -- models/free-market.can:2463
	for _, storage in pairs(storages) do -- models/free-market.can:2464
		for item_name, count in pairs(storage) do -- models/free-market.can:2465
			if count == 0 then -- models/free-market.can:2466
				storage[item_name] = nil -- models/free-market.can:2467
			end -- models/free-market.can:2467
		end -- models/free-market.can:2467
	end -- models/free-market.can:2467
end -- models/free-market.can:2467
local function check_forces() -- models/free-market.can:2473
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:2474
	local neutral_force = game["forces"]["neutral"] -- models/free-market.can:2476
	mod_data["active_forces"] = {} -- models/free-market.can:2477
	active_forces = mod_data["active_forces"] -- models/free-market.can:2478
	local size = 0 -- models/free-market.can:2479
	for _, force in pairs(game["forces"]) do -- models/free-market.can:2481
		if # force["connected_players"] > 0 then -- models/free-market.can:2482
			local force_index = force["index"] -- models/free-market.can:2483
			local items_data = buy_boxes[force_index] -- models/free-market.can:2484
			local storage_data = storages[force_index] -- models/free-market.can:2485
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2486
				local buyer_money = forces_money[force_index] -- models/free-market.can:2487
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2488
					size = size + 1 -- models/free-market.can:2489
					active_forces[size] = force_index -- models/free-market.can:2490
				end -- models/free-market.can:2490
			end -- models/free-market.can:2490
		elseif math["random"](99) > skip_offline_team_chance or force == neutral_force then -- models/free-market.can:2493
			local force_index = force["index"] -- models/free-market.can:2494
			local items_data = buy_boxes[force_index] -- models/free-market.can:2495
			local storage_data = storages[force_index] -- models/free-market.can:2496
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2497
				local buyer_money = forces_money[force_index] -- models/free-market.can:2498
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2499
					size = size + 1 -- models/free-market.can:2500
					active_forces[size] = force_index -- models/free-market.can:2501
				end -- models/free-market.can:2501
			end -- models/free-market.can:2501
		end -- models/free-market.can:2501
	end -- models/free-market.can:2501
	if # active_forces < 2 then -- models/free-market.can:2507
		mod_data["active_forces"] = {} -- models/free-market.can:2508
		active_forces = mod_data["active_forces"] -- models/free-market.can:2509
	end -- models/free-market.can:2509
	game["print"]("Active forces: " .. serpent["line"](active_forces)) -- models/free-market.can:2513
end -- models/free-market.can:2513
local function on_forces_merging(event) -- models/free-market.can:2517
	local source = event["source"] -- models/free-market.can:2518
	local source_index = source["index"] -- models/free-market.can:2519
	local source_storage = storages[source_index] -- models/free-market.can:2521
	local destination_storage = storages[event["destination"]["index"]] -- models/free-market.can:2522
	for item_name, count in pairs(source_storage) do -- models/free-market.can:2523
		destination_storage[item_name] = count + (destination_storage[item_name] or 0) -- models/free-market.can:2524
	end -- models/free-market.can:2524
	clear_force_data(source_index) -- models/free-market.can:2526
	local ids = rendering["get_all_ids"]() -- models/free-market.can:2528
	for i = 1, # ids do -- models/free-market.can:2529
		local id = ids[i] -- models/free-market.can:2530
		if is_render_valid(id) then -- models/free-market.can:2531
			local target = get_render_target(id) -- models/free-market.can:2532
			if target then -- models/free-market.can:2533
				local entity = target["entity"] -- models/free-market.can:2534
				if (not (entity and entity["valid"]) or entity["force"] == source) and Rget_type(id) == "text" then -- models/free-market.can:2535
					rendering_destroy(id) -- models/free-market.can:2536
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:2537
				end -- models/free-market.can:2537
			end -- models/free-market.can:2537
		end -- models/free-market.can:2537
	end -- models/free-market.can:2537
	check_forces() -- models/free-market.can:2542
end -- models/free-market.can:2542
local function on_force_cease_fire_changed(event) -- models/free-market.can:2545
	local force_index = event["force"]["index"] -- models/free-market.can:2546
	local other_force_index = event["other_force"]["index"] -- models/free-market.can:2547
	if event["added"] then -- models/free-market.can:2548
		embargoes[force_index][other_force_index] = nil -- models/free-market.can:2549
	else -- models/free-market.can:2549
		embargoes[force_index][other_force_index] = true -- models/free-market.can:2551
	end -- models/free-market.can:2551
end -- models/free-market.can:2551
local function set_transfer_box_key_pressed(event) -- models/free-market.can:2555
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2556
	local entity = player["selected"] -- models/free-market.can:2557
	if not (entity and entity["valid"]) then -- models/free-market.can:2558
		return  -- models/free-market.can:2558
	end -- models/free-market.can:2558
	if not entity["operable"] then -- models/free-market.can:2559
		return  -- models/free-market.can:2559
	end -- models/free-market.can:2559
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2560
		return  -- models/free-market.can:2560
	end -- models/free-market.can:2560
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2561
		return  -- models/free-market.can:2561
	end -- models/free-market.can:2561
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2563
	if box_data then -- models/free-market.can:2564
		local item_name = box_data[5] -- models/free-market.can:2565
		local box_type = box_data[3] -- models/free-market.can:2566
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2568
		elseif box_type == 4 or box_type == 5 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2570
		end -- models/free-market.can:2570
		return  -- models/free-market.can:2572
	end -- models/free-market.can:2572
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2575
	if not item["valid_for_read"] then -- models/free-market.can:2576
		player["print"]({ -- models/free-market.can:2577
			"multiplayer.no-address", -- models/free-market.can:2577
			{ "item" } -- models/free-market.can:2577
		}) -- models/free-market.can:2577
		return  -- models/free-market.can:2578
	end -- models/free-market.can:2578
	set_transfer_box_data(item["name"], player, entity) -- models/free-market.can:2581
end -- models/free-market.can:2581
local function set_bin_box_key_pressed(event) -- models/free-market.can:2584
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2585
	local entity = player["selected"] -- models/free-market.can:2586
	if not (entity and entity["valid"]) then -- models/free-market.can:2587
		return  -- models/free-market.can:2587
	end -- models/free-market.can:2587
	if not entity["operable"] then -- models/free-market.can:2588
		return  -- models/free-market.can:2588
	end -- models/free-market.can:2588
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2589
		return  -- models/free-market.can:2589
	end -- models/free-market.can:2589
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2590
		return  -- models/free-market.can:2590
	end -- models/free-market.can:2590
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2592
		return  -- models/free-market.can:2593
	end -- models/free-market.can:2593
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2596
	if not item["valid_for_read"] then -- models/free-market.can:2597
		player["print"]({ -- models/free-market.can:2598
			"multiplayer.no-address", -- models/free-market.can:2598
			{ "item" } -- models/free-market.can:2598
		}) -- models/free-market.can:2598
		return  -- models/free-market.can:2599
	end -- models/free-market.can:2599
	set_bin_box_data(item["name"], player, entity) -- models/free-market.can:2602
end -- models/free-market.can:2602
local function set_universal_transfer_box_key_pressed(event) -- models/free-market.can:2605
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2606
	local entity = player["selected"] -- models/free-market.can:2607
	if not (entity and entity["valid"]) then -- models/free-market.can:2608
		return  -- models/free-market.can:2608
	end -- models/free-market.can:2608
	if not entity["operable"] then -- models/free-market.can:2609
		return  -- models/free-market.can:2609
	end -- models/free-market.can:2609
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2610
		return  -- models/free-market.can:2610
	end -- models/free-market.can:2610
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2611
		return  -- models/free-market.can:2611
	end -- models/free-market.can:2611
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2613
	if box_data == nil then -- models/free-market.can:2614
		set_universal_transfer_box_data(player, entity) -- models/free-market.can:2615
	else -- models/free-market.can:2615
		local item_name = box_data[5] -- models/free-market.can:2617
		local box_type = box_data[3] -- models/free-market.can:2618
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2620
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2622
		end -- models/free-market.can:2622
	end -- models/free-market.can:2622
end -- models/free-market.can:2622
local function set_universal_bin_box_key_pressed(event) -- models/free-market.can:2627
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2628
	local entity = player["selected"] -- models/free-market.can:2629
	if not (entity and entity["valid"]) then -- models/free-market.can:2630
		return  -- models/free-market.can:2630
	end -- models/free-market.can:2630
	if not entity["operable"] then -- models/free-market.can:2631
		return  -- models/free-market.can:2631
	end -- models/free-market.can:2631
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2632
		return  -- models/free-market.can:2632
	end -- models/free-market.can:2632
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2633
		return  -- models/free-market.can:2633
	end -- models/free-market.can:2633
	if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:2635
		set_universal_bin_box_data(player, entity) -- models/free-market.can:2636
	end -- models/free-market.can:2636
end -- models/free-market.can:2636
local function set_pull_box_key_pressed(event) -- models/free-market.can:2640
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2641
	local entity = player["selected"] -- models/free-market.can:2642
	if not (entity and entity["valid"]) then -- models/free-market.can:2643
		return  -- models/free-market.can:2643
	end -- models/free-market.can:2643
	if not entity["operable"] then -- models/free-market.can:2644
		return  -- models/free-market.can:2644
	end -- models/free-market.can:2644
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2645
		return  -- models/free-market.can:2645
	end -- models/free-market.can:2645
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2646
		return  -- models/free-market.can:2646
	end -- models/free-market.can:2646
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2648
		return  -- models/free-market.can:2649
	end -- models/free-market.can:2649
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2652
	if not item["valid_for_read"] then -- models/free-market.can:2653
		player["print"]({ -- models/free-market.can:2654
			"multiplayer.no-address", -- models/free-market.can:2654
			{ "item" } -- models/free-market.can:2654
		}) -- models/free-market.can:2654
		return  -- models/free-market.can:2655
	end -- models/free-market.can:2655
	set_pull_box_data(item["name"], player, entity) -- models/free-market.can:2658
end -- models/free-market.can:2658
local function set_buy_box_key_pressed(event) -- models/free-market.can:2661
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2662
	local entity = player["selected"] -- models/free-market.can:2663
	if not (entity and entity["valid"]) then -- models/free-market.can:2664
		return  -- models/free-market.can:2664
	end -- models/free-market.can:2664
	if not entity["operable"] then -- models/free-market.can:2665
		return  -- models/free-market.can:2665
	end -- models/free-market.can:2665
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2666
		return  -- models/free-market.can:2666
	end -- models/free-market.can:2666
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2667
		return  -- models/free-market.can:2667
	end -- models/free-market.can:2667
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2669
	if box_data then -- models/free-market.can:2670
		local item_name = box_data[5] -- models/free-market.can:2671
		local box_type = box_data[3] -- models/free-market.can:2672
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2674
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2676
		end -- models/free-market.can:2676
		return  -- models/free-market.can:2678
	end -- models/free-market.can:2678
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2681
	if not item["valid_for_read"] then -- models/free-market.can:2682
		player["print"]({ -- models/free-market.can:2683
			"multiplayer.no-address", -- models/free-market.can:2683
			{ "item" } -- models/free-market.can:2683
		}) -- models/free-market.can:2683
		return  -- models/free-market.can:2684
	end -- models/free-market.can:2684
	set_buy_box_data(item["name"], player, entity) -- models/free-market.can:2687
end -- models/free-market.can:2687
local function on_gui_elem_changed(event) -- models/free-market.can:2690
	local element = event["element"] -- models/free-market.can:2691
	if not (element and element["valid"]) then -- models/free-market.can:2692
		return  -- models/free-market.can:2692
	end -- models/free-market.can:2692
	if element["name"] ~= "FM_prices_item" then -- models/free-market.can:2693
		return  -- models/free-market.can:2693
	end -- models/free-market.can:2693
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2694
	if not (player and player["valid"]) then -- models/free-market.can:2695
		return  -- models/free-market.can:2695
	end -- models/free-market.can:2695
	local item_row = element["parent"] -- models/free-market.can:2697
	local content_flow = item_row["parent"] -- models/free-market.can:2698
	local storage_row = content_flow["storage_row"] -- models/free-market.can:2699
	local item_name = element["elem_value"] -- models/free-market.can:2700
	if item_name == nil then -- models/free-market.can:2701
		item_row["sell_price"]["text"] = "" -- models/free-market.can:2702
		item_row["buy_price"]["text"] = "" -- models/free-market.can:2703
		local prices_table = content_flow["other_prices_frame"]["scroll-pane"]["prices_table"] -- models/free-market.can:2704
		prices_table["clear"]() -- models/free-market.can:2705
		make_prices_header(prices_table) -- models/free-market.can:2706
		storage_row["visible"] = false -- models/free-market.can:2707
		return  -- models/free-market.can:2708
	end -- models/free-market.can:2708
	local force_index = player["force"]["index"] -- models/free-market.can:2711
	storage_row["visible"] = true -- models/free-market.can:2713
	local count = storages[force_index][item_name] or 0 -- models/free-market.can:2714
	storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:2715
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2716
	storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:2717
	item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:2719
	item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:2720
	update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2721
end -- models/free-market.can:2721
local function on_gui_selection_state_changed(event) -- models/free-market.can:2724
	local element = event["element"] -- models/free-market.can:2725
	if not (element and element["valid"]) then -- models/free-market.can:2726
		return  -- models/free-market.can:2726
	end -- models/free-market.can:2726
	if element["name"] ~= "FM_force_price_list" then -- models/free-market.can:2727
		return  -- models/free-market.can:2727
	end -- models/free-market.can:2727
	local scroll_pane = element["parent"]["parent"]["deep_frame"]["scroll-pane"] -- models/free-market.can:2729
	local force = game["forces"][element["items"][element["selected_index"]]] -- models/free-market.can:2730
	if force == nil then -- models/free-market.can:2731
		scroll_pane["clear"]() -- models/free-market.can:2732
		make_price_list_header(scroll_pane) -- models/free-market.can:2733
		return  -- models/free-market.can:2734
	end -- models/free-market.can:2734
	update_price_list_table(force, scroll_pane) -- models/free-market.can:2737
end -- models/free-market.can:2737
local GUIS = { -- models/free-market.can:2741
	[""] = function(element, player) -- models/free-market.can:2742
		if element["type"] ~= "sprite-button" then -- models/free-market.can:2743
			return  -- models/free-market.can:2743
		end -- models/free-market.can:2743
		local parent_name = element["parent"]["name"] -- models/free-market.can:2744
		if parent_name == "price_list_table" then -- models/free-market.can:2745
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2746
			local force_index = player["force"]["index"] -- models/free-market.can:2747
			local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2748
			if prices_frame == nil then -- models/free-market.can:2749
				switch_prices_gui(player, item_name) -- models/free-market.can:2750
			else -- models/free-market.can:2750
				local content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2752
				content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2753
				local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2754
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price or "") -- models/free-market.can:2755
				local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2756
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price or "") -- models/free-market.can:2757
				update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2758
			end -- models/free-market.can:2758
		elseif parent_name == "FM_storage_table" then -- models/free-market.can:2760
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2761
			switch_prices_gui(player, item_name) -- models/free-market.can:2762
		end -- models/free-market.can:2762
	end, -- models/free-market.can:2762
	["FM_close"] = function(element) -- models/free-market.can:2765
		element["parent"]["parent"]["destroy"]() -- models/free-market.can:2766
	end, -- models/free-market.can:2766
	["FM_confirm_default_limit"] = function(element, player) -- models/free-market.can:2768
		local setting_row = element["parent"] -- models/free-market.can:2769
		local default_limit = tonumber(setting_row["FM_default_limit"]["text"]) -- models/free-market.can:2770
		if default_limit == nil or default_limit < 1 or default_limit > max_storage_threshold then -- models/free-market.can:2771
			player["print"]({ -- models/free-market.can:2772
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2772
				default_limit or "", -- models/free-market.can:2772
				1, -- models/free-market.can:2772
				max_storage_threshold -- models/free-market.can:2772
			}) -- models/free-market.can:2772
			return  -- models/free-market.can:2773
		end -- models/free-market.can:2773
		local force_index = player["force"]["index"] -- models/free-market.can:2776
		default_storage_limit[force_index] = default_limit -- models/free-market.can:2777
	end, -- models/free-market.can:2777
	["FM_confirm_storage_limit"] = function(element, player) -- models/free-market.can:2779
		local storage_row = element["parent"] -- models/free-market.can:2780
		local storage_limit = tonumber(storage_row["storage_limit"]["text"]) -- models/free-market.can:2781
		if storage_limit == nil or storage_limit < 1 or storage_limit > max_storage_threshold then -- models/free-market.can:2782
			player["print"]({ -- models/free-market.can:2783
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2783
				storage_limit or "", -- models/free-market.can:2783
				1, -- models/free-market.can:2783
				max_storage_threshold -- models/free-market.can:2783
			}) -- models/free-market.can:2783
			return  -- models/free-market.can:2784
		end -- models/free-market.can:2784
		local item_name = storage_row["parent"]["item_row"]["FM_prices_item"]["elem_value"] -- models/free-market.can:2787
		if item_name == nil then -- models/free-market.can:2788
			return  -- models/free-market.can:2788
		end -- models/free-market.can:2788
		local force_index = player["force"]["index"] -- models/free-market.can:2790
		storages_limit[force_index][item_name] = storage_limit -- models/free-market.can:2791
	end, -- models/free-market.can:2791
	["FM_confirm_buy_box"] = function(element, player) -- models/free-market.can:2793
		local parent = element["parent"] -- models/free-market.can:2794
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:2795
		if count == nil then -- models/free-market.can:2797
			player["print"]({ -- models/free-market.can:2798
				"multiplayer.no-address", -- models/free-market.can:2798
				{ "gui-train.add-item-count-condition" } -- models/free-market.can:2798
			}) -- models/free-market.can:2798
			return  -- models/free-market.can:2799
		elseif count < 1 then -- models/free-market.can:2800
			player["print"]({ -- models/free-market.can:2801
				"count-must-be-more-n", -- models/free-market.can:2801
				0 -- models/free-market.can:2801
			}) -- models/free-market.can:2801
			return  -- models/free-market.can:2802
		end -- models/free-market.can:2802
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2805
		if not item_name then -- models/free-market.can:2806
			player["print"]({ -- models/free-market.can:2807
				"multiplayer.no-address", -- models/free-market.can:2807
				{ "item" } -- models/free-market.can:2807
			}) -- models/free-market.can:2807
			return  -- models/free-market.can:2808
		end -- models/free-market.can:2808
		local box_operations = parent["parent"] -- models/free-market.can:2811
		local player_index = player["index"] -- models/free-market.can:2812
		local entity = open_box[player_index] -- models/free-market.can:2813
		if entity then -- models/free-market.can:2814
			local inventory_size = # entity["get_inventory"](1) -- models/free-market.can:1
			local max_count = game["item_prototypes"][item_name]["stack_size"] * inventory_size -- models/free-market.can:2816
			if count > max_count then -- models/free-market.can:2817
				player["print"]({ -- models/free-market.can:2818
					"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2818
					count, -- models/free-market.can:2818
					1, -- models/free-market.can:2818
					max_count -- models/free-market.can:2818
				}) -- models/free-market.can:2818
				parent["count"]["text"] = tostring(max_count) -- models/free-market.can:2819
				return  -- models/free-market.can:2820
			end -- models/free-market.can:2820
			set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:2823
			box_operations["clear"]() -- models/free-market.can:2824
			check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2825
		else -- models/free-market.can:2825
			box_operations["clear"]() -- models/free-market.can:2827
			player["print"]({ -- models/free-market.can:2828
				"multiplayer.no-address", -- models/free-market.can:2828
				{ "item-name.linked-chest" } -- models/free-market.can:2828
			}) -- models/free-market.can:2828
		end -- models/free-market.can:2828
		if # box_operations["children"] == 0 then -- models/free-market.can:2831
			open_box[player_index] = nil -- models/free-market.can:2832
		end -- models/free-market.can:2832
	end, -- models/free-market.can:2832
	["FM_confirm_buy_price_for_chest"] = function(element, player) -- models/free-market.can:2835
		local box_operations = element["parent"] -- models/free-market.can:2836
		local entity = open_box[player["index"]] -- models/free-market.can:2837
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2838
		if box_data == nil then -- models/free-market.can:2839
			box_operations["clear"]() -- models/free-market.can:2841
			return  -- models/free-market.can:2842
		end -- models/free-market.can:2842
		local buy_price = tonumber(box_operations["buy_price"]["text"]) -- models/free-market.can:2845
		if not buy_price then -- models/free-market.can:2846
			box_operations["clear"]() -- models/free-market.can:2847
		elseif buy_price < 1 then -- models/free-market.can:2848
			player["print"]({ -- models/free-market.can:2850
				"count-must-be-more-n", -- models/free-market.can:2850
				0 -- models/free-market.can:2850
			}) -- models/free-market.can:2850
			return  -- models/free-market.can:2851
		end -- models/free-market.can:2851
		local item_name = box_data[5] -- models/free-market.can:2854
		change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:2855
		box_operations["clear"]() -- models/free-market.can:2856
	end, -- models/free-market.can:2856
	["FM_confirm_transfer_box"] = function(element, player) -- models/free-market.can:2858
		local parent = element["parent"] -- models/free-market.can:2859
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2860
		if not item_name then -- models/free-market.can:2861
			player["print"]({ -- models/free-market.can:2862
				"multiplayer.no-address", -- models/free-market.can:2862
				{ "item" } -- models/free-market.can:2862
			}) -- models/free-market.can:2862
			return  -- models/free-market.can:2863
		end -- models/free-market.can:2863
		local box_operations = parent["parent"] -- models/free-market.can:2866
		local player_index = player["index"] -- models/free-market.can:2867
		local entity = open_box[player_index] -- models/free-market.can:2868
		if entity then -- models/free-market.can:2869
			set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2870
			box_operations["clear"]() -- models/free-market.can:2871
			check_sell_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2872
		else -- models/free-market.can:2872
			box_operations["clear"]() -- models/free-market.can:2874
			player["print"]({ -- models/free-market.can:2875
				"multiplayer.no-address", -- models/free-market.can:2875
				{ "item-name.linked-chest" } -- models/free-market.can:2875
			}) -- models/free-market.can:2875
		end -- models/free-market.can:2875
		if # box_operations["children"] == 0 then -- models/free-market.can:2878
			open_box[player_index] = nil -- models/free-market.can:2879
		end -- models/free-market.can:2879
	end, -- models/free-market.can:2879
	["FM_confirm_bin_box"] = function(element, player) -- models/free-market.can:2882
		local parent = element["parent"] -- models/free-market.can:2883
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2884
		if not item_name then -- models/free-market.can:2885
			player["print"]({ -- models/free-market.can:2886
				"multiplayer.no-address", -- models/free-market.can:2886
				{ "item" } -- models/free-market.can:2886
			}) -- models/free-market.can:2886
			return  -- models/free-market.can:2887
		end -- models/free-market.can:2887
		local box_operations = parent["parent"] -- models/free-market.can:2890
		local player_index = player["index"] -- models/free-market.can:2891
		local entity = open_box[player_index] -- models/free-market.can:2892
		if entity then -- models/free-market.can:2893
			set_bin_box_data(item_name, player, entity) -- models/free-market.can:2894
		else -- models/free-market.can:2894
			player["print"]({ -- models/free-market.can:2896
				"multiplayer.no-address", -- models/free-market.can:2896
				{ "item-name.linked-chest" } -- models/free-market.can:2896
			}) -- models/free-market.can:2896
		end -- models/free-market.can:2896
		box_operations["clear"]() -- models/free-market.can:2898
		open_box[player_index] = nil -- models/free-market.can:2899
	end, -- models/free-market.can:2899
	["FM_confirm_sell_price_for_chest"] = function(element, player) -- models/free-market.can:2901
		local box_operations = element["parent"] -- models/free-market.can:2902
		local entity = open_box[player["index"]] -- models/free-market.can:2903
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2904
		if box_data == nil then -- models/free-market.can:2905
			box_operations["clear"]() -- models/free-market.can:2907
			return  -- models/free-market.can:2908
		end -- models/free-market.can:2908
		local sell_price = tonumber(box_operations["sell_price"]["text"]) -- models/free-market.can:2911
		if not sell_price then -- models/free-market.can:2912
			box_operations["clear"]() -- models/free-market.can:2913
		elseif sell_price < 1 then -- models/free-market.can:2914
			player["print"]({ -- models/free-market.can:2916
				"count-must-be-more-n", -- models/free-market.can:2916
				0 -- models/free-market.can:2916
			}) -- models/free-market.can:2916
			return  -- models/free-market.can:2917
		end -- models/free-market.can:2917
		local item_name = box_data[5] -- models/free-market.can:2920
		change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:2921
		box_operations["clear"]() -- models/free-market.can:2922
	end, -- models/free-market.can:2922
	["FM_confirm_pull_box"] = function(element, player) -- models/free-market.can:2924
		local parent = element["parent"] -- models/free-market.can:2925
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2926
		if not item_name then -- models/free-market.can:2927
			player["print"]({ -- models/free-market.can:2928
				"multiplayer.no-address", -- models/free-market.can:2928
				{ "item" } -- models/free-market.can:2928
			}) -- models/free-market.can:2928
			return  -- models/free-market.can:2929
		end -- models/free-market.can:2929
		local player_index = player["index"] -- models/free-market.can:2932
		local entity = open_box[player_index] -- models/free-market.can:2933
		if entity then -- models/free-market.can:2934
			set_pull_box_data(item_name, player, entity) -- models/free-market.can:2935
		else -- models/free-market.can:2935
			player["print"]({ -- models/free-market.can:2937
				"multiplayer.no-address", -- models/free-market.can:2937
				{ "item-name.linked-chest" } -- models/free-market.can:2937
			}) -- models/free-market.can:2937
		end -- models/free-market.can:2937
		open_box[player_index] = nil -- models/free-market.can:2939
		local box_operations = parent["parent"] -- models/free-market.can:2940
		box_operations["clear"]() -- models/free-market.can:2941
	end, -- models/free-market.can:2941
	["FM_change_transfer_box"] = function(element, player) -- models/free-market.can:2943
		local parent = element["parent"] -- models/free-market.can:2944
		local player_index = player["index"] -- models/free-market.can:2945
		local entity = open_box[player_index] -- models/free-market.can:2946
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2947
		if entity then -- models/free-market.can:2948
			local player_force = player["force"] -- models/free-market.can:2949
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2950
			if item_name then -- models/free-market.can:2951
				if box_data and box_data[3] == 4 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2953
					remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2954
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2955
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2956
				else -- models/free-market.can:2956
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2958
				end -- models/free-market.can:2958
			else -- models/free-market.can:2958
				rendering_destroy(box_data[2]) -- models/free-market.can:2961
				remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2962
			end -- models/free-market.can:2962
		else -- models/free-market.can:2962
			player["print"]({ -- models/free-market.can:2965
				"multiplayer.no-address", -- models/free-market.can:2965
				{ "item-name.linked-chest" } -- models/free-market.can:2965
			}) -- models/free-market.can:2965
		end -- models/free-market.can:2965
		open_box[player_index] = nil -- models/free-market.can:2967
		local box_operations = element["parent"]["parent"] -- models/free-market.can:2968
		box_operations["clear"]() -- models/free-market.can:2969
	end, -- models/free-market.can:2969
	["FM_change_bin_box"] = function(element, player) -- models/free-market.can:2971
		local parent = element["parent"] -- models/free-market.can:2972
		local player_index = player["index"] -- models/free-market.can:2973
		local entity = open_box[player_index] -- models/free-market.can:2974
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2975
		if entity then -- models/free-market.can:2976
			local player_force = player["force"] -- models/free-market.can:2977
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2978
			if item_name then -- models/free-market.can:2979
				if box_data and box_data[3] == 6 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2981
					remove_certain_bin_box(entity, box_data) -- models/free-market.can:2982
					set_bin_box_data(item_name, player, entity) -- models/free-market.can:2983
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2984
				else -- models/free-market.can:2984
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2986
				end -- models/free-market.can:2986
			else -- models/free-market.can:2986
				rendering_destroy(box_data[2]) -- models/free-market.can:2989
				remove_certain_bin_box(entity, box_data) -- models/free-market.can:2990
			end -- models/free-market.can:2990
		else -- models/free-market.can:2990
			player["print"]({ -- models/free-market.can:2993
				"multiplayer.no-address", -- models/free-market.can:2993
				{ "item-name.linked-chest" } -- models/free-market.can:2993
			}) -- models/free-market.can:2993
		end -- models/free-market.can:2993
		open_box[player_index] = nil -- models/free-market.can:2995
		local box_operations = element["parent"]["parent"] -- models/free-market.can:2996
		box_operations["clear"]() -- models/free-market.can:2997
	end, -- models/free-market.can:2997
	["FM_change_pull_box"] = function(element, player) -- models/free-market.can:2999
		local parent = element["parent"] -- models/free-market.can:3000
		local player_index = player["index"] -- models/free-market.can:3001
		local entity = open_box[player_index] -- models/free-market.can:3002
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3003
		if entity then -- models/free-market.can:3004
			local player_force = player["force"] -- models/free-market.can:3005
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3006
			if item_name then -- models/free-market.can:3007
				if box_data and box_data[3] == 3 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:3009
					remove_certain_pull_box(entity, box_data) -- models/free-market.can:3010
					set_pull_box_data(item_name, player, entity) -- models/free-market.can:3011
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3012
				else -- models/free-market.can:3012
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3014
				end -- models/free-market.can:3014
			else -- models/free-market.can:3014
				rendering_destroy(box_data[2]) -- models/free-market.can:3017
				remove_certain_pull_box(entity, box_data) -- models/free-market.can:3018
			end -- models/free-market.can:3018
		else -- models/free-market.can:3018
			player["print"]({ -- models/free-market.can:3021
				"multiplayer.no-address", -- models/free-market.can:3021
				{ "item-name.linked-chest" } -- models/free-market.can:3021
			}) -- models/free-market.can:3021
		end -- models/free-market.can:3021
		open_box[player_index] = nil -- models/free-market.can:3023
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3024
		box_operations["clear"]() -- models/free-market.can:3025
	end, -- models/free-market.can:3025
	["FM_change_buy_box"] = function(element, player) -- models/free-market.can:3027
		local parent = element["parent"] -- models/free-market.can:3028
		local player_index = player["index"] -- models/free-market.can:3029
		local entity = open_box[player_index] -- models/free-market.can:3030
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:3031
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3032
		if entity then -- models/free-market.can:3033
			local player_force = player["force"] -- models/free-market.can:3034
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3035
			if item_name and count then -- models/free-market.can:3036
				local prev_item_name = box_data[5] -- models/free-market.can:3037
				if prev_item_name == item_name then -- models/free-market.can:3038
					change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:3039
				else -- models/free-market.can:3039
					if box_data and box_data[3] == 1 then -- models/free-market.can:1
						rendering_destroy(box_data[2]) -- models/free-market.can:3042
						remove_certain_buy_box(entity, box_data) -- models/free-market.can:3043
						set_buy_box_data(item_name, player, entity) -- models/free-market.can:3044
						show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3045
					else -- models/free-market.can:3045
						player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3047
					end -- models/free-market.can:3047
				end -- models/free-market.can:3047
			else -- models/free-market.can:3047
				rendering_destroy(box_data[2]) -- models/free-market.can:3051
				remove_certain_buy_box(entity, box_data) -- models/free-market.can:3052
			end -- models/free-market.can:3052
		else -- models/free-market.can:3052
			player["print"]({ -- models/free-market.can:3055
				"multiplayer.no-address", -- models/free-market.can:3055
				{ "item-name.linked-chest" } -- models/free-market.can:3055
			}) -- models/free-market.can:3055
		end -- models/free-market.can:3055
		open_box[player_index] = nil -- models/free-market.can:3057
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3058
		box_operations["clear"]() -- models/free-market.can:3059
	end, -- models/free-market.can:3059
	["FM_confirm_sell_price"] = function(element, player) -- models/free-market.can:3061
		local parent = element["parent"] -- models/free-market.can:3062
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3063
		if item_name == nil then -- models/free-market.can:3064
			return  -- models/free-market.can:3064
		end -- models/free-market.can:3064
		local sell_price_element = parent["sell_price"] -- models/free-market.can:3066
		local sell_price = tonumber(sell_price_element["text"]) -- models/free-market.can:3067
		local prev_sell_price = change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:3068
		if prev_sell_price then -- models/free-market.can:3069
			sell_price_element["text"] = tostring(prev_sell_price) -- models/free-market.can:3070
		end -- models/free-market.can:3070
	end, -- models/free-market.can:3070
	["FM_confirm_buy_price"] = function(element, player) -- models/free-market.can:3073
		local parent = element["parent"] -- models/free-market.can:3074
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3075
		if item_name == nil then -- models/free-market.can:3076
			return  -- models/free-market.can:3076
		end -- models/free-market.can:3076
		local buy_price_element = parent["buy_price"] -- models/free-market.can:3078
		local buy_price = tonumber(buy_price_element["text"]) -- models/free-market.can:3079
		local prev_buy_price = change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:3080
		if prev_buy_price then -- models/free-market.can:3081
			buy_price_element["text"] = tostring(prev_buy_price) -- models/free-market.can:3082
		end -- models/free-market.can:3082
	end, -- models/free-market.can:3082
	["FM_refresh_prices_table"] = function(element, player) -- models/free-market.can:3085
		local content_flow = element["parent"]["parent"]["shallow_frame"]["content_flow"] -- models/free-market.can:3086
		local item_row = content_flow["item_row"] -- models/free-market.can:3087
		local item_name = item_row["FM_prices_item"]["elem_value"] -- models/free-market.can:3088
		if item_name == nil then -- models/free-market.can:3089
			return  -- models/free-market.can:3089
		end -- models/free-market.can:3089
		local force_index = player["force"]["index"] -- models/free-market.can:3091
		item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:3092
		item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:3093
		local storage_row = content_flow["storage_row"] -- models/free-market.can:3095
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:3096
		storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:3097
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:3098
		storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:3099
		update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:3101
	end, -- models/free-market.can:3101
	["FM_set_transfer_box"] = function(element, player) -- models/free-market.can:3103
		local entity = player["opened"] -- models/free-market.can:3104
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3106
			if player["force"] ~= entity["force"] then -- models/free-market.can:3107
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3108
				return  -- models/free-market.can:3109
			end -- models/free-market.can:3109
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3112
			if box_data then -- models/free-market.can:3113
				local box_type = box_data[3] -- models/free-market.can:3114
				if box_type == 4 then -- models/free-market.can:1
					open_transfer_box_gui(player, false, entity) -- models/free-market.can:3116
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3118
					return  -- models/free-market.can:3119
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3121
					return  -- models/free-market.can:3122
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3124
					return  -- models/free-market.can:3125
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3127
					return  -- models/free-market.can:3128
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3130
					return  -- models/free-market.can:3131
				end -- models/free-market.can:3131
			else -- models/free-market.can:3131
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3134
				if not item["valid_for_read"] then -- models/free-market.can:3135
					open_transfer_box_gui(player, true) -- models/free-market.can:3136
				else -- models/free-market.can:3136
					local item_name = item["name"] -- models/free-market.can:3138
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:3139
					check_sell_price(player, item_name) -- models/free-market.can:3140
				end -- models/free-market.can:3140
			end -- models/free-market.can:3140
			open_box[player["index"]] = entity -- models/free-market.can:3143
		end -- models/free-market.can:3143
	end, -- models/free-market.can:3143
	["FM_set_universal_transfer_box"] = function(element, player) -- models/free-market.can:3146
		local entity = player["opened"] -- models/free-market.can:3147
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3149
			if player["force"] ~= entity["force"] then -- models/free-market.can:3150
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3151
				return  -- models/free-market.can:3152
			end -- models/free-market.can:3152
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3155
			if box_data then -- models/free-market.can:3156
				local box_type = box_data[3] -- models/free-market.can:3157
				if box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3159
					return  -- models/free-market.can:3160
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3162
					return  -- models/free-market.can:3163
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3165
					return  -- models/free-market.can:3166
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3168
					return  -- models/free-market.can:3169
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3171
					return  -- models/free-market.can:3172
				end -- models/free-market.can:3172
			else -- models/free-market.can:3172
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3175
			end -- models/free-market.can:3175
			open_box[player["index"]] = entity -- models/free-market.can:3177
		end -- models/free-market.can:3177
	end, -- models/free-market.can:3177
	["FM_set_bin_box"] = function(element, player) -- models/free-market.can:3180
		local entity = player["opened"] -- models/free-market.can:3181
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3183
			if player["force"] ~= entity["force"] then -- models/free-market.can:3184
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3185
				return  -- models/free-market.can:3186
			end -- models/free-market.can:3186
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3189
			if box_data then -- models/free-market.can:3190
				local box_type = box_data[3] -- models/free-market.can:3191
				if box_type == 6 then -- models/free-market.can:1
					open_bin_box_gui(player, false, entity) -- models/free-market.can:3193
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3195
					return  -- models/free-market.can:3196
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3198
					return  -- models/free-market.can:3199
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3201
					return  -- models/free-market.can:3202
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3204
					return  -- models/free-market.can:3205
				end -- models/free-market.can:3205
			else -- models/free-market.can:3205
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3208
				if not item["valid_for_read"] then -- models/free-market.can:3209
					open_bin_box_gui(player, true) -- models/free-market.can:3210
				else -- models/free-market.can:3210
					set_bin_box_data(item["name"], player, entity) -- models/free-market.can:3212
				end -- models/free-market.can:3212
			end -- models/free-market.can:3212
			open_box[player["index"]] = entity -- models/free-market.can:3215
		end -- models/free-market.can:3215
	end, -- models/free-market.can:3215
	["FM_set_universal_bin_box"] = function(element, player) -- models/free-market.can:3218
		local entity = player["opened"] -- models/free-market.can:3219
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3221
			if player["force"] ~= entity["force"] then -- models/free-market.can:3222
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3223
				return  -- models/free-market.can:3224
			end -- models/free-market.can:3224
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3227
			if box_data then -- models/free-market.can:3228
				local box_type = box_data[3] -- models/free-market.can:3229
				if box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3231
					return  -- models/free-market.can:3232
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3234
					return  -- models/free-market.can:3235
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3237
					return  -- models/free-market.can:3238
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3240
					return  -- models/free-market.can:3241
				end -- models/free-market.can:3241
			else -- models/free-market.can:3241
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3244
			end -- models/free-market.can:3244
			open_box[player["index"]] = entity -- models/free-market.can:3246
		end -- models/free-market.can:3246
	end, -- models/free-market.can:3246
	["FM_set_pull_box"] = function(element, player) -- models/free-market.can:3249
		local entity = player["opened"] -- models/free-market.can:3250
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3252
			if player["force"] ~= entity["force"] then -- models/free-market.can:3253
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3254
				return  -- models/free-market.can:3255
			end -- models/free-market.can:3255
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3258
			if box_data then -- models/free-market.can:3259
				local box_type = box_data[3] -- models/free-market.can:3260
				if box_type == 3 then -- models/free-market.can:1
					open_pull_box_gui(player, false, entity) -- models/free-market.can:3262
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3264
					return  -- models/free-market.can:3265
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3267
					return  -- models/free-market.can:3268
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3270
					return  -- models/free-market.can:3271
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3273
					return  -- models/free-market.can:3274
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3276
					return  -- models/free-market.can:3277
				end -- models/free-market.can:3277
			else -- models/free-market.can:3277
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3280
				if not item["valid_for_read"] then -- models/free-market.can:3281
					open_pull_box_gui(player, true) -- models/free-market.can:3282
				else -- models/free-market.can:3282
					set_pull_box_data(item["name"], player, entity) -- models/free-market.can:3284
				end -- models/free-market.can:3284
			end -- models/free-market.can:3284
			open_box[player["index"]] = entity -- models/free-market.can:3287
		end -- models/free-market.can:3287
	end, -- models/free-market.can:3287
	["FM_set_buy_box"] = function(element, player) -- models/free-market.can:3290
		local entity = player["opened"] -- models/free-market.can:3291
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3293
			if player["force"] ~= entity["force"] then -- models/free-market.can:3294
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3295
				return  -- models/free-market.can:3296
			end -- models/free-market.can:3296
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3299
			if box_data then -- models/free-market.can:3300
				local box_type = box_data[3] -- models/free-market.can:3301
				if box_type == 1 then -- models/free-market.can:1
					open_buy_box_gui(player, false, entity) -- models/free-market.can:3303
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3305
					return  -- models/free-market.can:3306
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3308
					return  -- models/free-market.can:3309
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3311
					return  -- models/free-market.can:3312
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3314
					return  -- models/free-market.can:3315
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3317
					return  -- models/free-market.can:3318
				end -- models/free-market.can:3318
			else -- models/free-market.can:3318
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3321
				if not item["valid_for_read"] then -- models/free-market.can:3322
					open_buy_box_gui(player, true) -- models/free-market.can:3323
				else -- models/free-market.can:3323
					local box_operations = element["parent"]["parent"]["box_operations"] -- models/free-market.can:3325
					local item_name = item["name"] -- models/free-market.can:3326
					set_buy_box_data(item_name, player, entity) -- models/free-market.can:3327
					check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:3328
				end -- models/free-market.can:3328
			end -- models/free-market.can:3328
			open_box[player["index"]] = entity -- models/free-market.can:3331
		end -- models/free-market.can:3331
	end, -- models/free-market.can:3331
	["FM_print_force_data"] = function(element, player) -- models/free-market.can:3334
		if player["admin"] then -- models/free-market.can:3335
			print_force_data(player["force"], player) -- models/free-market.can:3336
		else -- models/free-market.can:3336
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3338
		end -- models/free-market.can:3338
	end, -- models/free-market.can:3338
	["FM_clear_invalid_data"] = clear_invalid_data, -- models/free-market.can:3341
	["FM_reset_buy_prices"] = function(element, player) -- models/free-market.can:3342
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3343
			local force_index = player["force"]["index"] -- models/free-market.can:3344
			buy_prices[force_index] = {} -- models/free-market.can:3345
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3346
		else -- models/free-market.can:3346
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3348
		end -- models/free-market.can:3348
	end, -- models/free-market.can:3348
	["FM_reset_sell_prices"] = function(element, player) -- models/free-market.can:3351
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3352
			local force_index = player["force"]["index"] -- models/free-market.can:3353
			sell_prices[force_index] = {} -- models/free-market.can:3354
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3355
		else -- models/free-market.can:3355
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3357
		end -- models/free-market.can:3357
	end, -- models/free-market.can:3357
	["FM_reset_all_prices"] = function(element, player) -- models/free-market.can:3360
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3361
			local force_index = player["force"]["index"] -- models/free-market.can:3362
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3363
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3364
			sell_prices[force_index] = {} -- models/free-market.can:3365
			buy_prices[force_index] = {} -- models/free-market.can:3366
		else -- models/free-market.can:3366
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3368
		end -- models/free-market.can:3368
	end, -- models/free-market.can:3368
	["FM_reset_buy_boxes"] = function(element, player) -- models/free-market.can:3371
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3372
			resetBuyBoxes(player["force"]["index"]) -- models/free-market.can:3373
		else -- models/free-market.can:3373
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3375
		end -- models/free-market.can:3375
	end, -- models/free-market.can:3375
	["FM_reset_transfer_boxes"] = function(element, player) -- models/free-market.can:3378
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3379
			resetTransferBoxes(player["force"]["index"]) -- models/free-market.can:3380
		else -- models/free-market.can:3380
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3382
		end -- models/free-market.can:3382
	end, -- models/free-market.can:3382
	["FM_reset_universal_transfer_boxes"] = function(element, player) -- models/free-market.can:3385
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3386
			resetUniversalTransferBoxes(player["force"]["index"]) -- models/free-market.can:3387
		else -- models/free-market.can:3387
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3389
		end -- models/free-market.can:3389
	end, -- models/free-market.can:3389
	["FM_reset_bin_boxes"] = function(element, player) -- models/free-market.can:3392
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3393
			resetBinBoxes(player["force"]["index"]) -- models/free-market.can:3394
		else -- models/free-market.can:3394
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3396
		end -- models/free-market.can:3396
	end, -- models/free-market.can:3396
	["FM_reset_universal_bin_boxes"] = function(element, player) -- models/free-market.can:3399
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3400
			resetUniversalBinBoxes(player["force"]["index"]) -- models/free-market.can:3401
		else -- models/free-market.can:3401
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3403
		end -- models/free-market.can:3403
	end, -- models/free-market.can:3403
	["FM_reset_pull_boxes"] = function(element, player) -- models/free-market.can:3406
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3407
			resetPullBoxes(player["force"]["index"]) -- models/free-market.can:3408
		else -- models/free-market.can:3408
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3410
		end -- models/free-market.can:3410
	end, -- models/free-market.can:3410
	["FM_reset_all_boxes"] = function(element, player) -- models/free-market.can:3413
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3414
			resetAllBoxes(player["force"]["index"]) -- models/free-market.can:3415
		else -- models/free-market.can:3415
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3417
		end -- models/free-market.can:3417
	end, -- models/free-market.can:3417
	["FM_declare_embargo"] = function(element, player) -- models/free-market.can:3420
		local table_element = element["parent"]["parent"] -- models/free-market.can:3421
		local forces_list = table_element["forces_list"] -- models/free-market.can:3422
		if forces_list["selected_index"] == 0 then -- models/free-market.can:3423
			return  -- models/free-market.can:3423
		end -- models/free-market.can:3423
		local force_name = forces_list["items"][forces_list["selected_index"]] -- models/free-market.can:3425
		local other_force = game["forces"][force_name] -- models/free-market.can:3426
		if other_force and other_force["valid"] then -- models/free-market.can:3427
			local force = player["force"] -- models/free-market.can:3428
			embargoes[force["index"]][other_force["index"]] = true -- models/free-market.can:3429
			local message = { -- models/free-market.can:3430
				"free-market.declared-embargo", -- models/free-market.can:3430
				force["name"], -- models/free-market.can:3430
				other_force["name"], -- models/free-market.can:3430
				player["name"] -- models/free-market.can:3430
			} -- models/free-market.can:3430
			force["print"](message) -- models/free-market.can:3431
			other_force["print"](message) -- models/free-market.can:3432
		end -- models/free-market.can:3432
		update_embargo_table(table_element, player) -- models/free-market.can:3434
	end, -- models/free-market.can:3434
	["FM_cancel_embargo"] = function(element, player) -- models/free-market.can:3436
		local table_element = element["parent"]["parent"] -- models/free-market.can:3437
		local embargo_list = table_element["embargo_list"] -- models/free-market.can:3438
		if embargo_list["selected_index"] == 0 then -- models/free-market.can:3439
			return  -- models/free-market.can:3439
		end -- models/free-market.can:3439
		local force_name = embargo_list["items"][embargo_list["selected_index"]] -- models/free-market.can:3441
		local other_force = game["forces"][force_name] -- models/free-market.can:3442
		if other_force and other_force["valid"] then -- models/free-market.can:3443
			local force = player["force"] -- models/free-market.can:3444
			embargoes[force["index"]][other_force["index"]] = nil -- models/free-market.can:3445
			local message = { -- models/free-market.can:3446
				"free-market.canceled-embargo", -- models/free-market.can:3446
				force["name"], -- models/free-market.can:3446
				other_force["name"], -- models/free-market.can:3446
				player["name"] -- models/free-market.can:3446
			} -- models/free-market.can:3446
			force["print"](message) -- models/free-market.can:3447
			other_force["print"](message) -- models/free-market.can:3448
		end -- models/free-market.can:3448
		update_embargo_table(table_element, player) -- models/free-market.can:3450
	end, -- models/free-market.can:3450
	["FM_open_force_configuration"] = function(element, player) -- models/free-market.can:3452
		open_force_configuration(player) -- models/free-market.can:3453
	end, -- models/free-market.can:3453
	["FM_open_price"] = function(element, player) -- models/free-market.can:3455
		switch_prices_gui(player) -- models/free-market.can:3456
	end, -- models/free-market.can:3456
	["FM_switch_sell_prices_gui"] = function(element, player) -- models/free-market.can:3458
		switch_sell_prices_gui(player) -- models/free-market.can:3459
	end, -- models/free-market.can:3459
	["FM_switch_buy_prices_gui"] = function(element, player) -- models/free-market.can:3461
		switch_buy_prices_gui(player) -- models/free-market.can:3462
	end, -- models/free-market.can:3462
	["FM_open_sell_price"] = function(element, player, event) -- models/free-market.can:3464
		local force_index = tonumber(element["children"][1]["name"]) -- models/free-market.can:3465
		local force = game["forces"][force_index or 0] -- models/free-market.can:3466
		if not (force and force["valid"]) then -- models/free-market.can:3467
			game["print"]({ -- models/free-market.can:3468
				"force-doesnt-exist", -- models/free-market.can:3468
				"?" -- models/free-market.can:3468
			}) -- models/free-market.can:3468
			return  -- models/free-market.can:3469
		end -- models/free-market.can:3469
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3472
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3473
			game["print"]({ -- models/free-market.can:3474
				"missing-item", -- models/free-market.can:3474
				item_name -- models/free-market.can:3474
			}) -- models/free-market.can:3474
			return  -- models/free-market.can:3475
		end -- models/free-market.can:3475
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:3478
		if price then -- models/free-market.can:3479
			if event["shift"] then -- models/free-market.can:3480
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3482
			end -- models/free-market.can:3482
			if event["control"] then -- models/free-market.can:3484
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3486
			end -- models/free-market.can:3486
			if event["alt"] then -- models/free-market.can:3488
				switch_prices_gui(player, item_name) -- models/free-market.can:3489
			end -- models/free-market.can:3489
			game["print"]({ -- models/free-market.can:3491
				"free-market.team-selling-item-for", -- models/free-market.can:3491
				force["name"], -- models/free-market.can:3491
				item_name, -- models/free-market.can:3491
				price -- models/free-market.can:3491
			}) -- models/free-market.can:3491
		else -- models/free-market.can:3491
			game["print"]({ -- models/free-market.can:3494
				"free-market.team-doesnt-sell-item", -- models/free-market.can:3494
				force["name"], -- models/free-market.can:3494
				item_name -- models/free-market.can:3494
			}) -- models/free-market.can:3494
		end -- models/free-market.can:3494
	end, -- models/free-market.can:3494
	["FM_open_buy_price"] = function(element, player, event) -- models/free-market.can:3497
		local force_index = tonumber(element["children"][1]["name"]) or 0 -- models/free-market.can:3498
		local force = game["forces"][force_index] -- models/free-market.can:3499
		if not (force and force["valid"]) then -- models/free-market.can:3500
			game["print"]({ -- models/free-market.can:3501
				"force-doesnt-exist", -- models/free-market.can:3501
				"?" -- models/free-market.can:3501
			}) -- models/free-market.can:3501
			return  -- models/free-market.can:3502
		end -- models/free-market.can:3502
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3505
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3506
			game["print"]({ -- models/free-market.can:3507
				"missing-item", -- models/free-market.can:3507
				item_name -- models/free-market.can:3507
			}) -- models/free-market.can:3507
			return  -- models/free-market.can:3508
		end -- models/free-market.can:3508
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:3511
		if price then -- models/free-market.can:3512
			if event["shift"] then -- models/free-market.can:3513
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3515
			end -- models/free-market.can:3515
			if event["control"] then -- models/free-market.can:3517
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3519
			end -- models/free-market.can:3519
			if event["alt"] then -- models/free-market.can:3521
				switch_prices_gui(player, item_name) -- models/free-market.can:3522
			end -- models/free-market.can:3522
			game["print"]({ -- models/free-market.can:3524
				"free-market.team-buying-item-for", -- models/free-market.can:3524
				force["name"], -- models/free-market.can:3524
				item_name, -- models/free-market.can:3524
				price -- models/free-market.can:3524
			}) -- models/free-market.can:3524
		else -- models/free-market.can:3524
			game["print"]({ -- models/free-market.can:3527
				"free-market.team-doesnt-buy-item", -- models/free-market.can:3527
				force["name"], -- models/free-market.can:3527
				item_name -- models/free-market.can:3527
			}) -- models/free-market.can:3527
		end -- models/free-market.can:3527
	end, -- models/free-market.can:3527
	["FM_open_price_list"] = function(element, player) -- models/free-market.can:3530
		open_price_list_gui(player) -- models/free-market.can:3531
	end, -- models/free-market.can:3531
	["FM_open_embargo"] = function(element, player) -- models/free-market.can:3533
		open_embargo_gui(player) -- models/free-market.can:3534
	end, -- models/free-market.can:3534
	["FM_open_storage"] = function(element, player) -- models/free-market.can:3536
		open_storage_gui(player) -- models/free-market.can:3537
	end, -- models/free-market.can:3537
	["FM_show_hint"] = function(element, player) -- models/free-market.can:3539
		player["print"]({ "free-market.hint" }) -- models/free-market.can:3540
	end, -- models/free-market.can:3540
	["FM_hide_left_buttons"] = function(element, player) -- models/free-market.can:3542
		element["name"] = "FM_show_left_buttons" -- models/free-market.can:3543
		element["caption"] = "<" -- models/free-market.can:3544
		element["parent"]["children"][2]["visible"] = false -- models/free-market.can:3545
	end, -- models/free-market.can:3545
	["FM_show_left_buttons"] = function(element, player) -- models/free-market.can:3547
		element["name"] = "FM_hide_left_buttons" -- models/free-market.can:3548
		element["caption"] = ">" -- models/free-market.can:3549
		element["parent"]["children"][2]["visible"] = true -- models/free-market.can:3550
	end, -- models/free-market.can:3550
	["FM_search_by_price"] = function(element, player) -- models/free-market.can:3552
		local search_row = element["parent"] -- models/free-market.can:3553
		local selected_index = search_row["FM_search_price_drop_down"]["selected_index"] -- models/free-market.can:3554
		if selected_index == 0 then -- models/free-market.can:3555
			return  -- models/free-market.can:3556
		end -- models/free-market.can:3556
		local content_flow = search_row["parent"] -- models/free-market.can:3559
		local drop_down = content_flow["team_row"]["FM_force_price_list"] -- models/free-market.can:3560
		local dp_selected_index = drop_down["selected_index"] -- models/free-market.can:3561
		if dp_selected_index == nil or dp_selected_index == 0 then -- models/free-market.can:3562
			return  -- models/free-market.can:3562
		end -- models/free-market.can:3562
		local force = game["forces"][drop_down["items"][dp_selected_index]] -- models/free-market.can:3563
		if not (force and force["valid"]) then -- models/free-market.can:3564
			return  -- models/free-market.can:3564
		end -- models/free-market.can:3564
		local search_text = search_row["FM_search_text"]["text"] -- models/free-market.can:3566
		if # search_text > 50 then -- models/free-market.can:3567
			return  -- models/free-market.can:3568
		end -- models/free-market.can:3568
		local scroll_pane = content_flow["deep_frame"]["scroll-pane"] -- models/free-market.can:3570
		if search_text == "" then -- models/free-market.can:3571
			update_price_list_table(force, scroll_pane) -- models/free-market.can:3572
			return  -- models/free-market.can:3573
		end -- models/free-market.can:3573
		search_text = ".?" .. search_text:lower():gsub(" ", ".?") .. ".?" -- models/free-market.can:3576
		if selected_index == 1 then -- models/free-market.can:3577
			update_price_list_by_sell_filter(force, scroll_pane, search_text) -- models/free-market.can:3578
		else -- models/free-market.can:3578
			update_price_list_by_buy_filter(force, scroll_pane, search_text) -- models/free-market.can:3580
		end -- models/free-market.can:3580
	end -- models/free-market.can:3580
} -- models/free-market.can:3580
local function on_gui_click(event) -- models/free-market.can:3584
	local element = event["element"] -- models/free-market.can:3585
	local f = GUIS[element["name"]] -- models/free-market.can:3586
	if f then -- models/free-market.can:3587
		f(element, game["get_player"](event["player_index"]), event) -- models/free-market.can:3587
	end -- models/free-market.can:3587
end -- models/free-market.can:3587
local function on_gui_closed(event) -- models/free-market.can:3590
	local entity = event["entity"] -- models/free-market.can:3591
	if not (entity and entity["valid"]) then -- models/free-market.can:3592
		return  -- models/free-market.can:3592
	end -- models/free-market.can:3592
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3593
		return  -- models/free-market.can:3593
	end -- models/free-market.can:3593
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3594
	if not (player and player["valid"]) then -- models/free-market.can:3595
		return  -- models/free-market.can:3595
	end -- models/free-market.can:3595
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:3596
end -- models/free-market.can:3596
local function check_pull_boxes() -- models/free-market.can:3599
	local pulled_item_count = {} -- models/free-market.can:3600
	local stack = { -- models/free-market.can:3601
		["name"] = "", -- models/free-market.can:3601
		["count"] = 0 -- models/free-market.can:3601
	} -- models/free-market.can:3601
	for force_index, _items_data in pairs(pull_boxes) do -- models/free-market.can:3602
		if pull_cost_per_item == 0 or call("EasyAPI", "get_force_money", force_index) > money_treshold then -- models/free-market.can:3603
			local inserted_count_in_total = 0 -- models/free-market.can:3604
			pulled_item_count[force_index] = 0 -- models/free-market.can:3605
			local storage = storages[force_index] -- models/free-market.can:3606
			for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3607
				local count_in_storage = storage[item_name] -- models/free-market.can:3608
				if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3609
					stack["name"] = item_name -- models/free-market.can:3610
					for i = 1, # force_entities do -- models/free-market.can:3611
						if count_in_storage <= 0 then -- models/free-market.can:3612
							break -- models/free-market.can:3613
						end -- models/free-market.can:3613
						stack["count"] = count_in_storage -- models/free-market.can:3615
						local inserted_count = force_entities[i]["insert"](stack) -- models/free-market.can:3616
						inserted_count_in_total = inserted_count_in_total + inserted_count -- models/free-market.can:3617
						count_in_storage = count_in_storage - inserted_count -- models/free-market.can:3618
					end -- models/free-market.can:3618
					storage[item_name] = count_in_storage -- models/free-market.can:3620
				end -- models/free-market.can:3620
			end -- models/free-market.can:3620
			pulled_item_count[force_index] = inserted_count_in_total -- models/free-market.can:3623
		end -- models/free-market.can:3623
	end -- models/free-market.can:3623
	if pull_cost_per_item == 0 then -- models/free-market.can:3627
		return  -- models/free-market.can:3627
	end -- models/free-market.can:3627
	for force_index, count in pairs(pulled_item_count) do -- models/free-market.can:3628
		if count > 0 then -- models/free-market.can:3629
			call("EasyAPI", "deposit_force_money_by_index", force_index, - ceil(count * pull_cost_per_item)) -- models/free-market.can:3632
		end -- models/free-market.can:3632
	end -- models/free-market.can:3632
end -- models/free-market.can:3632
local function check_transfer_boxes() -- models/free-market.can:3638
	local stack = { -- models/free-market.can:3639
		["name"] = "", -- models/free-market.can:3639
		["count"] = 4000000000 -- models/free-market.can:3639
	} -- models/free-market.can:3639
	for force_index, force_entities in pairs(universal_bin_boxes) do -- models/free-market.can:3642
		local storage = storages[force_index] -- models/free-market.can:3643
		for i = 1, # force_entities do -- models/free-market.can:3644
			local entity = force_entities[i] -- models/free-market.can:3645
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3646
			for item_name in pairs(contents) do -- models/free-market.can:3647
				local count = storage[item_name] or 0 -- models/free-market.can:3648
				stack["name"] = item_name -- models/free-market.can:3649
				local sum = entity["remove_item"](stack) -- models/free-market.can:3650
				if sum > 0 then -- models/free-market.can:3651
					storage[item_name] = count + sum -- models/free-market.can:3652
				end -- models/free-market.can:3652
			end -- models/free-market.can:3652
		end -- models/free-market.can:3652
	end -- models/free-market.can:3652
	for force_index, _items_data in pairs(bin_boxes) do -- models/free-market.can:3658
		local storage = storages[force_index] -- models/free-market.can:3659
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3660
			local count = storage[item_name] or 0 -- models/free-market.can:3661
			stack["name"] = item_name -- models/free-market.can:3662
			local sum = 0 -- models/free-market.can:3663
			for i = 1, # force_entities do -- models/free-market.can:3664
				sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3665
			end -- models/free-market.can:3665
			if sum > 0 then -- models/free-market.can:3667
				storage[item_name] = count + sum -- models/free-market.can:3668
			end -- models/free-market.can:3668
		end -- models/free-market.can:3668
	end -- models/free-market.can:3668
	for force_index, force_entities in pairs(universal_transfer_boxes) do -- models/free-market.can:3674
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3675
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3676
		local storage = storages[force_index] -- models/free-market.can:3677
		for i = 1, # force_entities do -- models/free-market.can:3678
			local entity = force_entities[i] -- models/free-market.can:3679
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3680
			for item_name in pairs(contents) do -- models/free-market.can:3681
				local count = storage[item_name] or 0 -- models/free-market.can:3682
				local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3683
				if max_count > 0 then -- models/free-market.can:3684
					stack["count"] = max_count -- models/free-market.can:3685
					stack["name"] = item_name -- models/free-market.can:3686
					local sum = entity["remove_item"](stack) -- models/free-market.can:3687
					if sum > 0 then -- models/free-market.can:3688
						storage[item_name] = count + sum -- models/free-market.can:3689
					end -- models/free-market.can:3689
				end -- models/free-market.can:3689
			end -- models/free-market.can:3689
		end -- models/free-market.can:3689
	end -- models/free-market.can:3689
	for force_index, _items_data in pairs(transfer_boxes) do -- models/free-market.can:3696
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3697
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3698
		local storage = storages[force_index] -- models/free-market.can:3699
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3700
			local count = storage[item_name] or 0 -- models/free-market.can:3701
			local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3702
			if max_count > 0 then -- models/free-market.can:3703
				stack["count"] = max_count -- models/free-market.can:3704
				stack["name"] = item_name -- models/free-market.can:3705
				local sum = 0 -- models/free-market.can:3706
				for i = 1, # force_entities do -- models/free-market.can:3707
					sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3708
				end -- models/free-market.can:3708
				if sum > 0 then -- models/free-market.can:3710
					storage[item_name] = count + sum -- models/free-market.can:3711
				end -- models/free-market.can:3711
			end -- models/free-market.can:3711
		end -- models/free-market.can:3711
	end -- models/free-market.can:3711
end -- models/free-market.can:3711
local function check_buy_boxes() -- models/free-market.can:3718
	local last_checked_index = mod_data["last_checked_index"] -- models/free-market.can:3719
	local buyer_index -- models/free-market.can:3720
	if last_checked_index then -- models/free-market.can:3721
		buyer_index = active_forces[last_checked_index] -- models/free-market.can:3722
		if buyer_index then -- models/free-market.can:3723
			mod_data["last_checked_index"] = last_checked_index + 1 -- models/free-market.can:3724
		else -- models/free-market.can:3724
			mod_data["last_checked_index"] = nil -- models/free-market.can:3726
			return  -- models/free-market.can:3727
		end -- models/free-market.can:3727
	else -- models/free-market.can:3727
		last_checked_index, buyer_index = next(active_forces) -- models/free-market.can:3730
		if last_checked_index then -- models/free-market.can:3731
			mod_data["last_checked_index"] = last_checked_index -- models/free-market.can:3732
		else -- models/free-market.can:3732
			return  -- models/free-market.can:3734
		end -- models/free-market.can:3734
	end -- models/free-market.can:3734
	local items_data = buy_boxes[buyer_index] -- models/free-market.can:3738
	if items_data == nil then -- models/free-market.can:3740
		return  -- models/free-market.can:3740
	end -- models/free-market.can:3740
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:3742
	local forces_money_copy = {} -- models/free-market.can:3743
	for _force_index, value in pairs(forces_money) do -- models/free-market.can:3744
		forces_money_copy[_force_index] = value -- models/free-market.can:3745
	end -- models/free-market.can:3745
	local buyer_money = forces_money_copy[buyer_index] -- models/free-market.can:3748
	if buyer_money and buyer_money > money_treshold then -- models/free-market.can:3749
		local stack = { -- models/free-market.can:3750
			["name"] = "", -- models/free-market.can:3750
			["count"] = 0 -- models/free-market.can:3750
		} -- models/free-market.can:3750
		local stack_count = 0 -- models/free-market.can:3751
		local payment = 0 -- models/free-market.can:3752
		local f_buy_prices = buy_prices[buyer_index] -- models/free-market.can:3753
		local inserted_count_in_total = 0 -- models/free-market.can:3754
		for item_name, entities in pairs(items_data) do -- models/free-market.can:3755
			if money_treshold >= buyer_money then -- models/free-market.can:3756
				goto not_enough_money -- models/free-market.can:3758
			end -- models/free-market.can:3758
			local buy_price = f_buy_prices[item_name] -- models/free-market.can:3760
			if buy_price and buyer_money >= buy_price then -- models/free-market.can:3761
				for i = 1, # entities do -- models/free-market.can:3762
					local buy_data = entities[i] -- models/free-market.can:3763
					local purchasable_count = buyer_money / buy_price -- models/free-market.can:3764
					if purchasable_count < 1 then -- models/free-market.can:3765
						goto skip_buy -- models/free-market.can:3766
					else -- models/free-market.can:3766
						purchasable_count = floor(purchasable_count) -- models/free-market.can:3768
					end -- models/free-market.can:3768
					local buy_box = buy_data[1] -- models/free-market.can:3770
					local need_count = buy_data[2] -- models/free-market.can:3771
					if purchasable_count < need_count then -- models/free-market.can:3772
						need_count = purchasable_count -- models/free-market.can:3773
					end -- models/free-market.can:3773
					local count = buy_box["get_item_count"](item_name) -- models/free-market.can:3775
					stack["name"] = item_name -- models/free-market.can:3776
					if need_count < count then -- models/free-market.can:3777
						stack_count = count -- models/free-market.can:3778
					else -- models/free-market.can:3778
						need_count = need_count - count -- models/free-market.can:3780
						if need_count <= 0 then -- models/free-market.can:3781
							goto skip_buy -- models/free-market.can:3782
						end -- models/free-market.can:3782
						local buyer_storage = storages[buyer_index] -- models/free-market.can:3785
						local count_in_storage = buyer_storage[item_name] -- models/free-market.can:3786
						if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3787
							stack_count = need_count - count_in_storage -- models/free-market.can:3788
							if stack_count <= 0 then -- models/free-market.can:3789
								buyer_storage[item_name] = count_in_storage - need_count -- models/free-market.can:3790
								stack_count = 0 -- models/free-market.can:3791
								goto fulfilled_needs -- models/free-market.can:3792
							else -- models/free-market.can:3792
								buyer_storage[item_name] = count_in_storage + (stack_count - need_count) -- models/free-market.can:3794
							end -- models/free-market.can:3794
						else -- models/free-market.can:3794
							stack_count = need_count -- models/free-market.can:3797
						end -- models/free-market.can:3797
						for seller_index, seller_storage in pairs(storages) do -- models/free-market.can:3800
							if buyer_index ~= seller_index and forces_money[seller_index] and not embargoes[seller_index][buyer_index] then -- models/free-market.can:3801
								local sell_price = sell_prices[seller_index][item_name] -- models/free-market.can:3802
								if sell_price and buy_price >= sell_price then -- models/free-market.can:3803
									count_in_storage = seller_storage[item_name] -- models/free-market.can:3804
									if count_in_storage then -- models/free-market.can:3805
										if count_in_storage > stack_count then -- models/free-market.can:3806
											seller_storage[item_name] = count_in_storage - stack_count -- models/free-market.can:3807
											stack_count = 0 -- models/free-market.can:3808
											payment = need_count * sell_price -- models/free-market.can:3809
											buyer_money = buyer_money - payment -- models/free-market.can:3810
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3811
											goto fulfilled_needs -- models/free-market.can:3812
										else -- models/free-market.can:3812
											stack_count = stack_count - count_in_storage -- models/free-market.can:3814
											seller_storage[item_name] = 0 -- models/free-market.can:3815
											payment = (need_count - stack_count) * sell_price -- models/free-market.can:3816
											buyer_money = buyer_money - payment -- models/free-market.can:3817
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3818
										end -- models/free-market.can:3818
									end -- models/free-market.can:3818
								end -- models/free-market.can:3818
							end -- models/free-market.can:3818
						end -- models/free-market.can:3818
					end -- models/free-market.can:3818
					::fulfilled_needs:: -- models/free-market.can:3825
					local found_items = need_count - stack_count -- models/free-market.can:3826
					if found_items > 0 then -- models/free-market.can:3827
						stack["count"] = found_items -- models/free-market.can:3828
						inserted_count_in_total = inserted_count_in_total + buy_box["insert"](stack) -- models/free-market.can:3829
					end -- models/free-market.can:3829
					::skip_buy:: -- models/free-market.can:3831
				end -- models/free-market.can:3831
			end -- models/free-market.can:3831
		end -- models/free-market.can:3831
		::not_enough_money:: -- models/free-market.can:3835
		if pull_cost_per_item == 0 then -- models/free-market.can:3836
			forces_money_copy[buyer_index] = buyer_money -- models/free-market.can:3837
		else -- models/free-market.can:3837
			forces_money_copy[buyer_index] = buyer_money - ceil(inserted_count_in_total * pull_cost_per_item) -- models/free-market.can:3839
		end -- models/free-market.can:3839
	else -- models/free-market.can:3839
		return  -- models/free-market.can:3842
	end -- models/free-market.can:3842
	local forces = game["forces"] -- models/free-market.can:3845
	for _force_index, money in pairs(forces_money_copy) do -- models/free-market.can:3846
		local prev_money = forces_money[_force_index] -- models/free-market.can:3847
		if prev_money ~= money then -- models/free-market.can:3848
			local force = forces[_force_index] -- models/free-market.can:3849
			call("EasyAPI", "set_force_money", force, money) -- models/free-market.can:3850
			force["item_production_statistics"]["on_flow"]("trading", money - prev_money) -- models/free-market.can:3852
		end -- models/free-market.can:3852
	end -- models/free-market.can:3852
end -- models/free-market.can:3852
local function on_player_changed_force(event) -- models/free-market.can:3857
	local player_index = event["player_index"] -- models/free-market.can:3858
	local player = game["get_player"](player_index) -- models/free-market.can:3859
	if not (player and player["valid"]) then -- models/free-market.can:3860
		return  -- models/free-market.can:3860
	end -- models/free-market.can:3860
	if open_box[player_index] then -- models/free-market.can:3862
		clear_boxes_gui(player) -- models/free-market.can:3863
	end -- models/free-market.can:3863
	local index = player["force"]["index"] -- models/free-market.can:3866
	if transfer_boxes[index] == nil then -- models/free-market.can:3867
		init_force_data(index) -- models/free-market.can:3868
	end -- models/free-market.can:3868
end -- models/free-market.can:3868
local function on_player_changed_surface(event) -- models/free-market.can:3872
	local player_index = event["player_index"] -- models/free-market.can:3873
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3874
	if not (player and player["valid"]) then -- models/free-market.can:3875
		return  -- models/free-market.can:3875
	end -- models/free-market.can:3875
	if open_box[player_index] then -- models/free-market.can:3877
		clear_boxes_gui(player) -- models/free-market.can:3878
	end -- models/free-market.can:3878
end -- models/free-market.can:3878
local function on_player_left_game(event) -- models/free-market.can:3882
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3883
	if not (player and player["valid"]) then -- models/free-market.can:3884
		return  -- models/free-market.can:3884
	end -- models/free-market.can:3884
	clear_boxes_gui(player) -- models/free-market.can:3886
	destroy_prices_gui(player) -- models/free-market.can:3887
	delete_item_price_HUD(player) -- models/free-market.can:3888
	destroy_price_list_gui(player) -- models/free-market.can:3889
	destroy_force_configuration(player) -- models/free-market.can:3890
end -- models/free-market.can:3890
local function on_selected_entity_changed(event) -- models/free-market.can:3893
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3894
	if not (player and player["valid"]) then -- models/free-market.can:3895
		return  -- models/free-market.can:3895
	end -- models/free-market.can:3895
	local entity = player["selected"] -- models/free-market.can:3896
	if not (entity and entity["valid"]) then -- models/free-market.can:3897
		return  -- models/free-market.can:3897
	end -- models/free-market.can:3897
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3898
		return  -- models/free-market.can:3898
	end -- models/free-market.can:3898
	if entity["force"] ~= player["force"] then -- models/free-market.can:3899
		return  -- models/free-market.can:3899
	end -- models/free-market.can:3899
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3900
	if box_data == nil then -- models/free-market.can:3901
		return  -- models/free-market.can:3901
	end -- models/free-market.can:3901
	local item_name = box_data[5] -- models/free-market.can:3902
	if item_name == nil then -- models/free-market.can:3903
		return  -- models/free-market.can:3903
	end -- models/free-market.can:3903
	show_item_info_HUD(player, item_name) -- models/free-market.can:3905
end -- models/free-market.can:3905
local SELECT_TOOLS = { -- models/free-market.can:3909
	["FM_set_pull_boxes_tool"] = set_pull_box_data, -- models/free-market.can:3910
	["FM_set_bin_boxes_tool"] = set_bin_box_data, -- models/free-market.can:3911
	["FM_set_transfer_boxes_tool"] = set_transfer_box_data, -- models/free-market.can:3912
	["FM_set_buy_boxes_tool"] = set_buy_box_data -- models/free-market.can:3913
} -- models/free-market.can:3913
local function on_player_selected_area(event) -- models/free-market.can:3915
	local tool_name = event["item"] -- models/free-market.can:3916
	local func = SELECT_TOOLS[tool_name] -- models/free-market.can:3917
	if func then -- models/free-market.can:3918
		local entities = event["entities"] -- models/free-market.can:3919
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3920
		for i = 1, # entities do -- models/free-market.can:3921
			local entity = entities[i] -- models/free-market.can:3922
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3923
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3924
				if item["valid_for_read"] then -- models/free-market.can:3925
					func(item["name"], player, entity) -- models/free-market.can:3926
				end -- models/free-market.can:3926
			end -- models/free-market.can:3926
		end -- models/free-market.can:3926
	elseif tool_name == "FM_set_universal_transfer_boxes_tool" then -- models/free-market.can:3930
		local entities = event["entities"] -- models/free-market.can:3931
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3932
		for i = 1, # entities do -- models/free-market.can:3933
			local entity = entities[i] -- models/free-market.can:3934
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3935
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3936
			end -- models/free-market.can:3936
		end -- models/free-market.can:3936
	elseif tool_name == "FM_set_universal_bin_boxes_tool" then -- models/free-market.can:3939
		local entities = event["entities"] -- models/free-market.can:3940
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3941
		for i = 1, # entities do -- models/free-market.can:3942
			local entity = entities[i] -- models/free-market.can:3943
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3944
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3945
			end -- models/free-market.can:3945
		end -- models/free-market.can:3945
	elseif tool_name == "FM_remove_boxes_tool" then -- models/free-market.can:3948
		local entities = event["entities"] -- models/free-market.can:3949
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3950
		local count = 0 -- models/free-market.can:3951
		for i = 1, # entities do -- models/free-market.can:3952
			local is_deleted = clear_box_data_by_entity(entities[i]) -- models/free-market.can:3953
			if is_deleted then -- models/free-market.can:3954
				count = count + 1 -- models/free-market.can:3955
			end -- models/free-market.can:3955
		end -- models/free-market.can:3955
		if count > 0 then -- models/free-market.can:3958
			player["print"]({ -- models/free-market.can:3959
				"", -- models/free-market.can:3959
				{ "gui-migrated-content.removed-entity" }, -- models/free-market.can:3959
				COLON, -- models/free-market.can:3959
				" ", -- models/free-market.can:3959
				count -- models/free-market.can:3959
			}) -- models/free-market.can:3959
		end -- models/free-market.can:3959
	end -- models/free-market.can:3959
end -- models/free-market.can:3959
do -- models/free-market.can:3966
	local TOOL_TO_TYPE = { -- models/free-market.can:3966
		["FM_set_pull_boxes_tool"] = 3, -- models/free-market.can:1
		["FM_set_transfer_boxes_tool"] = 4, -- models/free-market.can:1
		["FM_set_universal_transfer_boxes_tool"] = 5, -- models/free-market.can:1
		["FM_set_universal_bin_boxes_tool"] = 7, -- models/free-market.can:1
		["FM_set_bin_boxes_tool"] = 6, -- models/free-market.can:1
		["FM_set_buy_boxes_tool"] = 1 -- models/free-market.can:1
	} -- models/free-market.can:1
	on_player_alt_selected_area = function(event) -- models/free-market.can:3974
		local box_type = TOOL_TO_TYPE[event["item"]] -- models/free-market.can:3975
		if box_type == nil then -- models/free-market.can:3976
			return  -- models/free-market.can:3976
		end -- models/free-market.can:3976
		local remove_box = REMOVE_BOX_FUNCS[box_type] -- models/free-market.can:3978
		local entities = event["entities"] -- models/free-market.can:3979
		for i = # entities, 1, - 1 do -- models/free-market.can:3980
			local entity = entities[i] -- models/free-market.can:3981
			if entity["valid"] then -- models/free-market.can:3982
				local unit_number = entity["unit_number"] -- models/free-market.can:3983
				local box_data = all_boxes[unit_number] -- models/free-market.can:3984
				if box_data and box_data[3] == box_type then -- models/free-market.can:3985
					rendering_destroy(box_data[2]) -- models/free-market.can:3986
					remove_box(entity, box_data) -- models/free-market.can:3987
				end -- models/free-market.can:3987
			end -- models/free-market.can:3987
		end -- models/free-market.can:3987
	end -- models/free-market.can:3987
end -- models/free-market.can:3987
local mod_settings = { -- models/free-market.can:3995
	["FM_enable-auto-embargo"] = function(value) -- models/free-market.can:3996
		is_auto_embargo = value -- models/free-market.can:3996
	end, -- models/free-market.can:3996
	["FM_is-public-titles"] = function(value) -- models/free-market.can:3997
		is_public_titles = value -- models/free-market.can:3997
	end, -- models/free-market.can:3997
	["FM_is_reset_public"] = function(value) -- models/free-market.can:3998
		is_reset_public = value -- models/free-market.can:3998
	end, -- models/free-market.can:3998
	["FM_money-treshold"] = function(value) -- models/free-market.can:3999
		money_treshold = value -- models/free-market.can:3999
	end, -- models/free-market.can:3999
	["FM_minimal-price"] = function(value) -- models/free-market.can:4000
		minimal_price = value -- models/free-market.can:4000
	end, -- models/free-market.can:4000
	["FM_maximal-price"] = function(value) -- models/free-market.can:4001
		maximal_price = value -- models/free-market.can:4001
	end, -- models/free-market.can:4001
	["FM_skip_offline_team_chance"] = function(value) -- models/free-market.can:4002
		skip_offline_team_chance = value -- models/free-market.can:4002
	end, -- models/free-market.can:4002
	["FM_max_storage_threshold"] = function(value) -- models/free-market.can:4003
		max_storage_threshold = value -- models/free-market.can:4003
	end, -- models/free-market.can:4003
	["FM_pull_cost_per_item"] = function(value) -- models/free-market.can:4004
		pull_cost_per_item = value -- models/free-market.can:4004
	end, -- models/free-market.can:4004
	["FM_update-tick"] = function(value) -- models/free-market.can:4005
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4006
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4008
			return  -- models/free-market.can:4010
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4011
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4013
			return  -- models/free-market.can:4015
		elseif update_pull_tick == value then -- models/free-market.can:4016
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4018
			return  -- models/free-market.can:4020
		elseif update_transfer_tick == value then -- models/free-market.can:4021
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4023
			return  -- models/free-market.can:4025
		end -- models/free-market.can:4025
		script["on_nth_tick"](update_buy_tick, nil) -- models/free-market.can:4027
		update_buy_tick = value -- models/free-market.can:4028
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4029
	end, -- models/free-market.can:4029
	["FM_update-transfer-tick"] = function(value) -- models/free-market.can:4031
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4032
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4034
			return  -- models/free-market.can:4036
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4037
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4039
			return  -- models/free-market.can:4041
		elseif update_pull_tick == value then -- models/free-market.can:4042
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4044
			return  -- models/free-market.can:4046
		elseif update_buy_tick == value then -- models/free-market.can:4047
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4049
			return  -- models/free-market.can:4051
		end -- models/free-market.can:4051
		script["on_nth_tick"](update_transfer_tick, nil) -- models/free-market.can:4053
		update_transfer_tick = value -- models/free-market.can:4054
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4055
	end, -- models/free-market.can:4055
	["FM_update-pull-tick"] = function(value) -- models/free-market.can:4057
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4058
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4060
			return  -- models/free-market.can:4062
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4063
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4065
			return  -- models/free-market.can:4067
		elseif update_transfer_tick == value then -- models/free-market.can:4068
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4070
			return  -- models/free-market.can:4072
		elseif update_buy_tick == value then -- models/free-market.can:4073
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4075
			return  -- models/free-market.can:4077
		end -- models/free-market.can:4077
		script["on_nth_tick"](update_pull_tick, nil) -- models/free-market.can:4079
		update_pull_tick = value -- models/free-market.can:4080
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4081
	end, -- models/free-market.can:4081
	["FM_show_item_price"] = function(player) -- models/free-market.can:4083
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4084
			create_item_price_HUD(player) -- models/free-market.can:4085
		else -- models/free-market.can:4085
			delete_item_price_HUD(player) -- models/free-market.can:4087
		end -- models/free-market.can:4087
	end, -- models/free-market.can:4087
	["FM_sell_notification_column_count"] = function(player) -- models/free-market.can:4090
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:4091
		local is_vertical = (column_count == 2) -- models/free-market.can:4092
		local frame = player["gui"]["screen"]["FM_sell_prices_frame"] -- models/free-market.can:4093
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4094
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4095
			local last_location = frame["location"] -- models/free-market.can:4096
			frame["destroy"]() -- models/free-market.can:4097
			switch_sell_prices_gui(player, last_location) -- models/free-market.can:4098
		end -- models/free-market.can:4098
	end, -- models/free-market.can:4098
	["FM_buy_notification_column_count"] = function(player) -- models/free-market.can:4101
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:4102
		local is_vertical = (column_count == 2) -- models/free-market.can:4103
		local frame = player["gui"]["screen"]["FM_buy_prices_frame"] -- models/free-market.can:4104
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4105
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4106
			local last_location = frame["location"] -- models/free-market.can:4107
			frame["destroy"]() -- models/free-market.can:4108
			switch_buy_prices_gui(player, last_location) -- models/free-market.can:4109
		end -- models/free-market.can:4109
	end -- models/free-market.can:4109
} -- models/free-market.can:4109
on_runtime_mod_setting_changed = function(event) -- models/free-market.can:4113
	local setting_name = event["setting"] -- models/free-market.can:4114
	local f = mod_settings[setting_name] -- models/free-market.can:4115
	if f == nil then -- models/free-market.can:4116
		return  -- models/free-market.can:4116
	end -- models/free-market.can:4116
	if event["setting_type"] == "runtime-global" then -- models/free-market.can:4118
		f(settings["global"][setting_name]["value"]) -- models/free-market.can:4119
	else -- models/free-market.can:4119
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4121
		if player and player["valid"] then -- models/free-market.can:4122
			f(player) -- models/free-market.can:4123
		end -- models/free-market.can:4123
	end -- models/free-market.can:4123
end -- models/free-market.can:4123
local function add_remote_interface() -- models/free-market.can:4133
	remote["remove_interface"]("free-market") -- models/free-market.can:4135
	remote["add_interface"]("free-market", { -- models/free-market.can:4136
		["get_mod_data"] = function() -- models/free-market.can:4137
			return mod_data -- models/free-market.can:4137
		end, -- models/free-market.can:4137
		["get_internal_data"] = function(name) -- models/free-market.can:4138
			return mod_data[name] -- models/free-market.can:4138
		end, -- models/free-market.can:4138
		["change_count_in_buy_box_data"] = change_count_in_buy_box_data, -- models/free-market.can:4139
		["remove_certain_pull_box"] = remove_certain_pull_box, -- models/free-market.can:4140
		["remove_certain_transfer_box"] = remove_certain_transfer_box, -- models/free-market.can:4141
		["remove_certain_universal_transfer_box"] = remove_certain_universal_transfer_box, -- models/free-market.can:4142
		["remove_certain_bin_box"] = remove_certain_bin_box, -- models/free-market.can:4143
		["remove_certain_universal_bin_box"] = remove_certain_universal_bin_box, -- models/free-market.can:4144
		["remove_certain_buy_box"] = remove_certain_buy_box, -- models/free-market.can:4145
		["clear_box_data_by_entity"] = clear_box_data_by_entity, -- models/free-market.can:4146
		["resetTransferBoxes"] = resetTransferBoxes, -- models/free-market.can:4147
		["resetUniversalTransferBoxes"] = resetUniversalTransferBoxes, -- models/free-market.can:4148
		["resetBinBoxes"] = resetBinBoxes, -- models/free-market.can:4149
		["resetUniversalBinBoxes"] = resetUniversalBinBoxes, -- models/free-market.can:4150
		["resetPullBoxes"] = resetPullBoxes, -- models/free-market.can:4151
		["resetBuyBoxes"] = resetBuyBoxes, -- models/free-market.can:4152
		["resetAllBoxes"] = resetAllBoxes, -- models/free-market.can:4153
		["clear_force_data"] = clear_force_data, -- models/free-market.can:4154
		["init_force_data"] = init_force_data, -- models/free-market.can:4155
		["set_universal_transfer_box_data"] = set_universal_transfer_box_data, -- models/free-market.can:4156
		["set_universal_bin_box_data"] = set_universal_bin_box_data, -- models/free-market.can:4157
		["set_transfer_box_data"] = set_transfer_box_data, -- models/free-market.can:4158
		["set_bin_box_data"] = set_bin_box_data, -- models/free-market.can:4159
		["set_pull_box_data"] = set_pull_box_data, -- models/free-market.can:4160
		["set_buy_box_data"] = set_buy_box_data, -- models/free-market.can:4161
		["set_item_limit"] = function(item_name, force_index, count) -- models/free-market.can:4162
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4163
			if f_storages_limit == nil then -- models/free-market.can:4164
				return  -- models/free-market.can:4164
			end -- models/free-market.can:4164
			f_storages_limit[item_name] = count -- models/free-market.can:4165
		end, -- models/free-market.can:4165
		["set_default_storage_limit"] = function(force_index, count) -- models/free-market.can:4167
			local f_default_storage_limit = default_storage_limit[force_index] -- models/free-market.can:4168
			if f_default_storage_limit == nil then -- models/free-market.can:4169
				return  -- models/free-market.can:4169
			end -- models/free-market.can:4169
			default_storage_limit[force_index] = count -- models/free-market.can:4170
		end, -- models/free-market.can:4170
		["set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4172
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4173
			if f_sell_prices == nil then -- models/free-market.can:4174
				return  -- models/free-market.can:4174
			end -- models/free-market.can:4174
			local transferers = transfer_boxes[force_index][item_name] -- models/free-market.can:4176
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:4177
			if f_sell_prices[item_name] or transferers ~= nil or (count_in_storage and count_in_storage > 0) then -- models/free-market.can:4178
				f_sell_prices[item_name] = price -- models/free-market.can:4179
				inactive_sell_prices[force_index] = nil -- models/free-market.can:4180
			else -- models/free-market.can:4180
				f_sell_prices[item_name] = nil -- models/free-market.can:4182
				inactive_sell_prices[force_index][item_name] = price -- models/free-market.can:4183
			end -- models/free-market.can:4183
		end, -- models/free-market.can:4183
		["set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4186
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4187
			if f_buy_prices == nil then -- models/free-market.can:4188
				return  -- models/free-market.can:4188
			end -- models/free-market.can:4188
			local f_buy_boxes = buy_boxes[force_index][item_name] -- models/free-market.can:4190
			if f_buy_prices[item_name] or f_buy_boxes ~= nil then -- models/free-market.can:4191
				f_buy_prices[item_name] = price -- models/free-market.can:4192
				inactive_buy_prices[force_index] = nil -- models/free-market.can:4193
			else -- models/free-market.can:4193
				f_buy_prices[item_name] = nil -- models/free-market.can:4195
				inactive_buy_prices[force_index][item_name] = price -- models/free-market.can:4196
			end -- models/free-market.can:4196
		end, -- models/free-market.can:4196
		["force_set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4199
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4200
			if f_sell_prices == nil then -- models/free-market.can:4201
				return  -- models/free-market.can:4201
			end -- models/free-market.can:4201
			f_sell_prices[item_name] = price -- models/free-market.can:4202
			inactive_sell_prices[force_index][item_name] = nil -- models/free-market.can:4203
		end, -- models/free-market.can:4203
		["force_set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4205
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4206
			if f_buy_prices == nil then -- models/free-market.can:4207
				return  -- models/free-market.can:4207
			end -- models/free-market.can:4207
			f_buy_prices[item_name] = price -- models/free-market.can:4208
			inactive_buy_prices[force_index][item_name] = nil -- models/free-market.can:4209
		end, -- models/free-market.can:4209
		["reset_AI_force_storage"] = function(force_index) -- models/free-market.can:4211
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4212
			if f_sell_prices == nil then -- models/free-market.can:4213
				return  -- models/free-market.can:4213
			end -- models/free-market.can:4213
			local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:4215
			for item_name, price in pairs(f_inactive_sell_prices) do -- models/free-market.can:4216
				f_sell_prices[item_name] = price -- models/free-market.can:4217
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:4218
			end -- models/free-market.can:4218
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4220
			local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:4221
			for item_name, price in pairs(f_inactive_buy_prices) do -- models/free-market.can:4222
				f_buy_prices[item_name] = price -- models/free-market.can:4223
				f_inactive_buy_prices[item_name] = nil -- models/free-market.can:4224
			end -- models/free-market.can:4224
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4228
			local f_storage = storages[force_index] -- models/free-market.can:4229
			for item_name in pairs(f_buy_prices) do -- models/free-market.can:4230
				f_storage[item_name] = 2000000000 -- models/free-market.can:4231
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4232
			end -- models/free-market.can:4232
			for item_name in pairs(f_sell_prices) do -- models/free-market.can:4234
				f_storage[item_name] = 2000000000 -- models/free-market.can:4235
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4236
			end -- models/free-market.can:4236
		end, -- models/free-market.can:4236
		["get_item_limit"] = function(item_name, force_index) -- models/free-market.can:4239
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4240
			if f_storages_limit == nil then -- models/free-market.can:4241
				return  -- models/free-market.can:4241
			end -- models/free-market.can:4241
			return f_storages_limit[item_name] -- models/free-market.can:4242
		end, -- models/free-market.can:4242
		["get_default_storage_limit"] = function(force_index) -- models/free-market.can:4244
			return default_storage_limit[force_index] -- models/free-market.can:4245
		end, -- models/free-market.can:4245
		["get_inactive_universal_transfer_boxes"] = function() -- models/free-market.can:4247
			return inactive_universal_transfer_boxes -- models/free-market.can:4247
		end, -- models/free-market.can:4247
		["get_inactive_universal_bin_boxes"] = function() -- models/free-market.can:4248
			return inactive_universal_bin_boxes -- models/free-market.can:4248
		end, -- models/free-market.can:4248
		["get_inactive_bin_boxes"] = function() -- models/free-market.can:4249
			return inactive_bin_boxes -- models/free-market.can:4249
		end, -- models/free-market.can:4249
		["get_inactive_transfer_boxes"] = function() -- models/free-market.can:4250
			return inactive_transfer_boxes -- models/free-market.can:4250
		end, -- models/free-market.can:4250
		["get_inactive_sell_prices"] = function() -- models/free-market.can:4251
			return inactive_sell_prices -- models/free-market.can:4251
		end, -- models/free-market.can:4251
		["get_inactive_buy_prices"] = function() -- models/free-market.can:4252
			return inactive_buy_prices -- models/free-market.can:4252
		end, -- models/free-market.can:4252
		["get_inactive_buy_boxes"] = function() -- models/free-market.can:4253
			return inactive_buy_boxes -- models/free-market.can:4253
		end, -- models/free-market.can:4253
		["get_universal_bin_boxes"] = function() -- models/free-market.can:4254
			return universal_bin_boxes -- models/free-market.can:4254
		end, -- models/free-market.can:4254
		["get_transfer_boxes"] = function() -- models/free-market.can:4255
			return transfer_boxes -- models/free-market.can:4255
		end, -- models/free-market.can:4255
		["get_bin_boxes"] = function() -- models/free-market.can:4256
			return bin_boxes -- models/free-market.can:4256
		end, -- models/free-market.can:4256
		["get_pull_boxes"] = function() -- models/free-market.can:4257
			return pull_boxes -- models/free-market.can:4257
		end, -- models/free-market.can:4257
		["get_buy_boxes"] = function() -- models/free-market.can:4258
			return buy_boxes -- models/free-market.can:4258
		end, -- models/free-market.can:4258
		["get_sell_prices"] = function() -- models/free-market.can:4259
			return sell_prices -- models/free-market.can:4259
		end, -- models/free-market.can:4259
		["get_buy_prices"] = function() -- models/free-market.can:4260
			return buy_prices -- models/free-market.can:4260
		end, -- models/free-market.can:4260
		["get_embargoes"] = function() -- models/free-market.can:4261
			return embargoes -- models/free-market.can:4261
		end, -- models/free-market.can:4261
		["get_open_box"] = function() -- models/free-market.can:4262
			return open_box -- models/free-market.can:4262
		end, -- models/free-market.can:4262
		["get_all_boxes"] = function() -- models/free-market.can:4263
			return all_boxes -- models/free-market.can:4263
		end, -- models/free-market.can:4263
		["get_active_forces"] = function() -- models/free-market.can:4264
			return active_forces -- models/free-market.can:4264
		end, -- models/free-market.can:4264
		["get_storages"] = function() -- models/free-market.can:4265
			return storages -- models/free-market.can:4265
		end -- models/free-market.can:4265
	}) -- models/free-market.can:4265
end -- models/free-market.can:4265
local function link_data() -- models/free-market.can:4269
	mod_data = global["free_market"] -- models/free-market.can:4270
	bin_boxes = mod_data["bin_boxes"] -- models/free-market.can:4271
	inactive_bin_boxes = mod_data["inactive_bin_boxes"] -- models/free-market.can:4272
	universal_bin_boxes = mod_data["universal_bin_boxes"] -- models/free-market.can:4273
	inactive_universal_bin_boxes = mod_data["universal_inactive_bin_boxes"] -- models/free-market.can:4274
	pull_boxes = mod_data["pull_boxes"] -- models/free-market.can:4275
	inactive_universal_transfer_boxes = mod_data["inactive_universal_transfer_boxes"] -- models/free-market.can:4276
	inactive_transfer_boxes = mod_data["inactive_transfer_boxes"] -- models/free-market.can:4277
	inactive_buy_boxes = mod_data["inactive_buy_boxes"] -- models/free-market.can:4278
	universal_transfer_boxes = mod_data["universal_transfer_boxes"] -- models/free-market.can:4279
	transfer_boxes = mod_data["transfer_boxes"] -- models/free-market.can:4280
	buy_boxes = mod_data["buy_boxes"] -- models/free-market.can:4281
	embargoes = mod_data["embargoes"] -- models/free-market.can:4282
	inactive_sell_prices = mod_data["inactive_sell_prices"] -- models/free-market.can:4283
	inactive_buy_prices = mod_data["inactive_buy_prices"] -- models/free-market.can:4284
	sell_prices = mod_data["sell_prices"] -- models/free-market.can:4285
	buy_prices = mod_data["buy_prices"] -- models/free-market.can:4286
	item_HUD = mod_data["item_hinter"] -- models/free-market.can:4287
	open_box = mod_data["open_box"] -- models/free-market.can:4288
	all_boxes = mod_data["all_boxes"] -- models/free-market.can:4289
	active_forces = mod_data["active_forces"] -- models/free-market.can:4290
	default_storage_limit = mod_data["default_storage_limit"] -- models/free-market.can:4291
	storages_limit = mod_data["storages_limit"] -- models/free-market.can:4292
	storages = mod_data["storages"] -- models/free-market.can:4293
end -- models/free-market.can:4293
local function update_global_data() -- models/free-market.can:4296
	global["free_market"] = global["free_market"] or {} -- models/free-market.can:4297
	mod_data = global["free_market"] -- models/free-market.can:4298
	mod_data["item_hinter"] = mod_data["item_hinter"] or {} -- models/free-market.can:4299
	mod_data["open_box"] = {} -- models/free-market.can:4300
	mod_data["active_forces"] = mod_data["active_forces"] or {} -- models/free-market.can:4301
	mod_data["bin_boxes"] = mod_data["bin_boxes"] or {} -- models/free-market.can:4302
	mod_data["inactive_bin_boxes"] = mod_data["inactive_bin_boxes"] or {} -- models/free-market.can:4303
	mod_data["universal_bin_boxes"] = mod_data["universal_bin_boxes"] or {} -- models/free-market.can:4304
	mod_data["universal_inactive_bin_boxes"] = mod_data["universal_inactive_bin_boxes"] or {} -- models/free-market.can:4305
	mod_data["inactive_universal_transfer_boxes"] = mod_data["inactive_universal_transfer_boxes"] or {} -- models/free-market.can:4306
	mod_data["inactive_transfer_boxes"] = mod_data["inactive_transfer_boxes"] or {} -- models/free-market.can:4307
	mod_data["inactive_buy_boxes"] = mod_data["inactive_buy_boxes"] or {} -- models/free-market.can:4308
	mod_data["universal_transfer_boxes"] = mod_data["universal_transfer_boxes"] or {} -- models/free-market.can:4309
	mod_data["transfer_boxes"] = mod_data["transfer_boxes"] or {} -- models/free-market.can:4310
	mod_data["pull_boxes"] = mod_data["pull_boxes"] or {} -- models/free-market.can:4311
	mod_data["buy_boxes"] = mod_data["buy_boxes"] or {} -- models/free-market.can:4312
	mod_data["inactive_sell_prices"] = mod_data["inactive_sell_prices"] or {} -- models/free-market.can:4313
	mod_data["inactive_buy_prices"] = mod_data["inactive_buy_prices"] or {} -- models/free-market.can:4314
	mod_data["sell_prices"] = mod_data["sell_prices"] or {} -- models/free-market.can:4315
	mod_data["buy_prices"] = mod_data["buy_prices"] or {} -- models/free-market.can:4316
	mod_data["embargoes"] = mod_data["embargoes"] or {} -- models/free-market.can:4317
	mod_data["all_boxes"] = mod_data["all_boxes"] or {} -- models/free-market.can:4318
	mod_data["default_storage_limit"] = mod_data["default_storage_limit"] or {} -- models/free-market.can:4319
	mod_data["storages_limit"] = mod_data["storages_limit"] or {} -- models/free-market.can:4320
	mod_data["storages"] = mod_data["storages"] or {} -- models/free-market.can:4321
	link_data() -- models/free-market.can:4323
	clear_invalid_data() -- models/free-market.can:4325
	for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:4327
		if item["stack_size"] <= 5 then -- models/free-market.can:4328
			for _, f_storage_limit in pairs(storages_limit) do -- models/free-market.can:4329
				f_storage_limit[item_name] = f_storage_limit[item_name] or 1 -- models/free-market.can:4330
			end -- models/free-market.can:4330
		end -- models/free-market.can:4330
	end -- models/free-market.can:4330
	init_force_data(game["forces"]["player"]["index"]) -- models/free-market.can:4335
	for _, force in pairs(game["forces"]) do -- models/free-market.can:4337
		if # force["players"] > 0 then -- models/free-market.can:4338
			init_force_data(force["index"]) -- models/free-market.can:4339
		end -- models/free-market.can:4339
	end -- models/free-market.can:4339
	for _, player in pairs(game["players"]) do -- models/free-market.can:4344
		if player["valid"] then -- models/free-market.can:4345
			local relative = player["gui"]["relative"] -- models/free-market.can:4346
			if relative["FM_buttons"] == nil then -- models/free-market.can:4347
				create_left_relative_gui(player) -- models/free-market.can:4348
			end -- models/free-market.can:4348
			if relative["FM_boxes_frame"] == nil then -- models/free-market.can:4350
				create_top_relative_gui(player) -- models/free-market.can:4351
			end -- models/free-market.can:4351
		end -- models/free-market.can:4351
	end -- models/free-market.can:4351
end -- models/free-market.can:4351
local function on_configuration_changed(event) -- models/free-market.can:4357
	update_global_data() -- models/free-market.can:4358
	local mod_changes = event["mod_changes"]["iFreeMarket"] -- models/free-market.can:4360
	if not (mod_changes and mod_changes["old_version"]) then -- models/free-market.can:4361
		return  -- models/free-market.can:4361
	end -- models/free-market.can:4361
	local version = tonumber(string["gmatch"](mod_changes["old_version"], "%d+.%d+")()) -- models/free-market.can:4363
	if version < 0.34 then -- models/free-market.can:4365
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4366
			local index = force["index"] -- models/free-market.can:4367
			if sell_prices[index] then -- models/free-market.can:4368
				init_force_data(index) -- models/free-market.can:4369
			end -- models/free-market.can:4369
		end -- models/free-market.can:4369
		for _, player in pairs(game["players"]) do -- models/free-market.can:4373
			if player["valid"] then -- models/free-market.can:4374
				create_top_relative_gui(player) -- models/free-market.can:4375
			end -- models/free-market.can:4375
		end -- models/free-market.can:4375
	end -- models/free-market.can:4375
	if version < 0.33 then -- models/free-market.can:4380
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4381
			local index = force["index"] -- models/free-market.can:4382
			if sell_prices[index] and mod_data["sell_boxes"] then -- models/free-market.can:4384
				transfer_boxes[index] = mod_data["sell_boxes"][index] -- models/free-market.can:4385
				inactive_transfer_boxes[index] = mod_data["inactive_sell_boxes"][index] -- models/free-market.can:4386
			end -- models/free-market.can:4386
			mod_data["sell_boxes"] = nil -- models/free-market.can:4388
			mod_data["inactive_sell_boxes"] = nil -- models/free-market.can:4389
		end -- models/free-market.can:4389
		local sprite_data = { -- models/free-market.can:4392
			["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:4393
			["only_in_alt_mode"] = true, -- models/free-market.can:4394
			["x_scale"] = 0.4, -- models/free-market.can:4395
			["y_scale"] = 0.4 -- models/free-market.can:4395
		} -- models/free-market.can:4395
		for _, box_data in pairs(all_boxes) do -- models/free-market.can:4397
			rendering_destroy(box_data[2]) -- models/free-market.can:4398
			local entity = box_data[1] -- models/free-market.can:4400
			sprite_data["target"] = entity -- models/free-market.can:4401
			sprite_data["surface"] = entity["surface"] -- models/free-market.can:4402
			if is_public_titles == false then -- models/free-market.can:4403
				sprite_data["forces"] = { entity["force"] } -- models/free-market.can:4404
			end -- models/free-market.can:4404
			local box_type = box_data[3] -- models/free-market.can:4407
			if box_type == 2 then -- models/free-market.can:1
				box_data[3] = 4 -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transfer" -- models/free-market.can:4410
			elseif box_type == 3 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_pull_out" -- models/free-market.can:4412
			elseif box_type == 1 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_buy" -- models/free-market.can:4414
			end -- models/free-market.can:4414
			box_data[2] = draw_sprite(sprite_data) -- models/free-market.can:4417
		end -- models/free-market.can:4417
		for _, player in pairs(game["players"]) do -- models/free-market.can:4420
			if player["valid"] then -- models/free-market.can:4421
				create_top_relative_gui(player) -- models/free-market.can:4422
			end -- models/free-market.can:4422
		end -- models/free-market.can:4422
	end -- models/free-market.can:4422
	if version < 0.32 then -- models/free-market.can:4427
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4428
			local index = force["index"] -- models/free-market.can:4429
			if transfer_boxes[index] then -- models/free-market.can:4430
				init_force_data(index) -- models/free-market.can:4431
				default_storage_limit[index] = max_storage_threshold -- models/free-market.can:4432
			end -- models/free-market.can:4432
		end -- models/free-market.can:4432
	end -- models/free-market.can:4432
	if version < 0.31 then -- models/free-market.can:4437
		for _, player in pairs(game["players"]) do -- models/free-market.can:4438
			if player["valid"] then -- models/free-market.can:4439
				delete_item_price_HUD(player) -- models/free-market.can:4440
				if player["connected"] then -- models/free-market.can:4441
					create_item_price_HUD(player) -- models/free-market.can:4442
				end -- models/free-market.can:4442
			end -- models/free-market.can:4442
		end -- models/free-market.can:4442
	end -- models/free-market.can:4442
	if version < 0.30 then -- models/free-market.can:4448
		for _, player in pairs(game["players"]) do -- models/free-market.can:4449
			if player["valid"] then -- models/free-market.can:4450
				local screen = player["gui"]["screen"] -- models/free-market.can:4451
				local frame = screen["FM_prices_frame"] -- models/free-market.can:4452
				if frame then -- models/free-market.can:4453
					frame["destroy"]() -- models/free-market.can:4454
				end -- models/free-market.can:4454
			end -- models/free-market.can:4454
		end -- models/free-market.can:4454
	end -- models/free-market.can:4454
	if version < 0.29 then -- models/free-market.can:4460
		for _, player in pairs(game["players"]) do -- models/free-market.can:4461
			if player["valid"] then -- models/free-market.can:4462
				local screen = player["gui"]["screen"] -- models/free-market.can:4463
				if screen["FM_sell_prices_frame"] then -- models/free-market.can:4464
					screen["FM_sell_prices_frame"]["destroy"]() -- models/free-market.can:4465
				end -- models/free-market.can:4465
				if screen["FM_buy_prices_frame"] then -- models/free-market.can:4467
					screen["FM_buy_prices_frame"]["destroy"]() -- models/free-market.can:4468
				end -- models/free-market.can:4468
				switch_buy_prices_gui(player) -- models/free-market.can:4470
				switch_sell_prices_gui(player) -- models/free-market.can:4471
			end -- models/free-market.can:4471
		end -- models/free-market.can:4471
	end -- models/free-market.can:4471
	if version < 0.28 then -- models/free-market.can:4476
		for _, player in pairs(game["players"]) do -- models/free-market.can:4477
			if player["valid"] and player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4478
				create_item_price_HUD(player) -- models/free-market.can:4479
			end -- models/free-market.can:4479
		end -- models/free-market.can:4479
	end -- models/free-market.can:4479
	if version < 0.21 then -- models/free-market.can:4484
		for _, player in pairs(game["players"]) do -- models/free-market.can:4485
			if player["valid"] then -- models/free-market.can:4486
				create_top_relative_gui(player) -- models/free-market.can:4487
			end -- models/free-market.can:4487
		end -- models/free-market.can:4487
	end -- models/free-market.can:4487
	if version < 0.22 then -- models/free-market.can:4492
		for _, player in pairs(game["players"]) do -- models/free-market.can:4493
			if player["valid"] then -- models/free-market.can:4494
				create_left_relative_gui(player) -- models/free-market.can:4495
			end -- models/free-market.can:4495
		end -- models/free-market.can:4495
	end -- models/free-market.can:4495
	if version < 0.26 then -- models/free-market.can:4500
		for _, player in pairs(game["players"]) do -- models/free-market.can:4501
			if player["valid"] then -- models/free-market.can:4502
				switch_sell_prices_gui(player) -- models/free-market.can:4503
				switch_buy_prices_gui(player) -- models/free-market.can:4504
			end -- models/free-market.can:4504
		end -- models/free-market.can:4504
		game["print"]({ -- models/free-market.can:4507
			"", -- models/free-market.can:4507
			{ "mod-name.free-market" }, -- models/free-market.can:4507
			COLON, -- models/free-market.can:4507
			" added price notification with settings" -- models/free-market.can:4507
		}) -- models/free-market.can:4507
	end -- models/free-market.can:4507
end -- models/free-market.can:4507
do -- models/free-market.can:4512
	local function set_filters() -- models/free-market.can:4512
		local filters = { -- models/free-market.can:4513
			{ -- models/free-market.can:4514
				["filter"] = "type", -- models/free-market.can:4514
				["mode"] = "or", -- models/free-market.can:4514
				["type"] = "container" -- models/free-market.can:4514
			}, -- models/free-market.can:4514
			{ -- models/free-market.can:4515
				["filter"] = "type", -- models/free-market.can:4515
				["mode"] = "or", -- models/free-market.can:4515
				["type"] = "logistic-container" -- models/free-market.can:4515
			} -- models/free-market.can:4515
		} -- models/free-market.can:4515
		script["set_event_filter"](defines["events"]["on_entity_died"], filters) -- models/free-market.can:4517
		script["set_event_filter"](defines["events"]["on_robot_mined_entity"], filters) -- models/free-market.can:4518
		script["set_event_filter"](defines["events"]["script_raised_destroy"], filters) -- models/free-market.can:4519
		script["set_event_filter"](defines["events"]["on_player_mined_entity"], filters) -- models/free-market.can:4520
	end -- models/free-market.can:4520
	M["on_load"] = function() -- models/free-market.can:4523
		link_data() -- models/free-market.can:4524
		set_filters() -- models/free-market.can:4525
	end -- models/free-market.can:4525
	M["on_init"] = function() -- models/free-market.can:4527
		update_global_data() -- models/free-market.can:4528
		set_filters() -- models/free-market.can:4529
	end -- models/free-market.can:4529
end -- models/free-market.can:4529
M["on_configuration_changed"] = on_configuration_changed -- models/free-market.can:4532
M["add_remote_interface"] = add_remote_interface -- models/free-market.can:4533
M["events"] = { -- models/free-market.can:4538
	[defines["events"]["on_surface_deleted"]] = clear_invalid_entities, -- models/free-market.can:4539
	[defines["events"]["on_surface_cleared"]] = clear_invalid_entities, -- models/free-market.can:4540
	[defines["events"]["on_chunk_deleted"]] = clear_invalid_entities, -- models/free-market.can:4541
	[defines["events"]["on_player_created"]] = on_player_created, -- models/free-market.can:4542
	[defines["events"]["on_player_joined_game"]] = on_player_joined_game, -- models/free-market.can:4543
	[defines["events"]["on_player_left_game"]] = on_player_left_game, -- models/free-market.can:4544
	[defines["events"]["on_player_cursor_stack_changed"]] = function(event) -- models/free-market.can:4545
		pcall(on_player_cursor_stack_changed, event) -- models/free-market.can:4546
	end, -- models/free-market.can:4546
	[defines["events"]["on_player_removed"]] = delete_player_data, -- models/free-market.can:4548
	[defines["events"]["on_player_changed_force"]] = on_player_changed_force, -- models/free-market.can:4549
	[defines["events"]["on_player_changed_surface"]] = on_player_changed_surface, -- models/free-market.can:4550
	[defines["events"]["on_player_selected_area"]] = on_player_selected_area, -- models/free-market.can:4551
	[defines["events"]["on_player_alt_selected_area"]] = on_player_alt_selected_area, -- models/free-market.can:4552
	[defines["events"]["on_player_mined_entity"]] = clear_box_data, -- models/free-market.can:4553
	[defines["events"]["on_gui_selection_state_changed"]] = on_gui_selection_state_changed, -- models/free-market.can:4554
	[defines["events"]["on_gui_elem_changed"]] = on_gui_elem_changed, -- models/free-market.can:4555
	[defines["events"]["on_gui_click"]] = function(event) -- models/free-market.can:4556
		on_gui_click(event) -- models/free-market.can:4557
	end, -- models/free-market.can:4557
	[defines["events"]["on_gui_closed"]] = on_gui_closed, -- models/free-market.can:4559
	[defines["events"]["on_selected_entity_changed"]] = on_selected_entity_changed, -- models/free-market.can:4560
	[defines["events"]["on_force_created"]] = on_force_created, -- models/free-market.can:4561
	[defines["events"]["on_forces_merging"]] = on_forces_merging, -- models/free-market.can:4562
	[defines["events"]["on_runtime_mod_setting_changed"]] = on_runtime_mod_setting_changed, -- models/free-market.can:4563
	[defines["events"]["on_force_cease_fire_changed"]] = function(event) -- models/free-market.can:4564
		if is_auto_embargo then -- models/free-market.can:4566
			pcall(on_force_cease_fire_changed, event) -- models/free-market.can:4567
		end -- models/free-market.can:4567
	end, -- models/free-market.can:4567
	[defines["events"]["on_robot_mined_entity"]] = clear_box_data, -- models/free-market.can:4570
	[defines["events"]["script_raised_destroy"]] = clear_box_data, -- models/free-market.can:4571
	[defines["events"]["on_entity_died"]] = clear_box_data, -- models/free-market.can:4572
	["FM_set-pull-box"] = function(event) -- models/free-market.can:4573
		pcall(set_pull_box_key_pressed, event) -- models/free-market.can:4574
	end, -- models/free-market.can:4574
	["FM_set-transfer-box"] = function(event) -- models/free-market.can:4576
		pcall(set_transfer_box_key_pressed, event) -- models/free-market.can:4577
	end, -- models/free-market.can:4577
	["FM_set-universal-transfer-box"] = function(event) -- models/free-market.can:4579
		pcall(set_universal_transfer_box_key_pressed, event) -- models/free-market.can:4580
	end, -- models/free-market.can:4580
	["FM_set-bin-box"] = function(event) -- models/free-market.can:4582
		pcall(set_bin_box_key_pressed, event) -- models/free-market.can:4583
	end, -- models/free-market.can:4583
	["FM_set-universal-bin-box"] = function(event) -- models/free-market.can:4585
		pcall(set_universal_bin_box_key_pressed, event) -- models/free-market.can:4586
	end, -- models/free-market.can:4586
	["FM_set-buy-box"] = function(event) -- models/free-market.can:4588
		pcall(set_buy_box_key_pressed, event) -- models/free-market.can:4589
	end -- models/free-market.can:4589
} -- models/free-market.can:4589
M["on_nth_tick"] = { -- models/free-market.can:4593
	[update_buy_tick] = check_buy_boxes, -- models/free-market.can:4594
	[update_transfer_tick] = check_transfer_boxes, -- models/free-market.can:4595
	[update_pull_tick] = check_pull_boxes, -- models/free-market.can:4596
	[CHECK_FORCES_TICK] = check_forces, -- models/free-market.can:4597
	[CHECK_TEAMS_DATA_TICK] = check_teams_data -- models/free-market.can:4598
} -- models/free-market.can:4598
M["commands"] = { -- models/free-market.can:4601
	["embargo"] = function(cmd) -- models/free-market.can:4602
		open_embargo_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4603
	end, -- models/free-market.can:4603
	["prices"] = function(cmd) -- models/free-market.can:4605
		switch_prices_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4606
	end, -- models/free-market.can:4606
	["price_list"] = function(cmd) -- models/free-market.can:4608
		open_price_list_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4609
	end, -- models/free-market.can:4609
	["storage"] = function(cmd) -- models/free-market.can:4611
		open_storage_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4612
	end -- models/free-market.can:4612
} -- models/free-market.can:4612
return M -- models/free-market.can:4617
