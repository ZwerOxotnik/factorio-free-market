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
local CHECK_FORCES_TICK = 60 * 60 * 1.5 -- models/free-market.can:158
local CHECK_TEAMS_DATA_TICK = 60 * 60 * 25 -- models/free-market.can:159
local EMPTY_TABLE = {} -- models/free-market.can:161
local WHITE_COLOR = { -- models/free-market.can:162
	1, -- models/free-market.can:162
	1, -- models/free-market.can:162
	1 -- models/free-market.can:162
} -- models/free-market.can:162
local BOX_TYPE_SPRITE_OFFSET = { -- models/free-market.can:163
	0, -- models/free-market.can:163
	0.2 -- models/free-market.can:163
} -- models/free-market.can:163
local HINT_SPRITE_OFFSET = { -- models/free-market.can:164
	0, -- models/free-market.can:164
	- 0.25 -- models/free-market.can:164
} -- models/free-market.can:164
local COLON = { "colon" } -- models/free-market.can:165
local LABEL = { ["type"] = "label" } -- models/free-market.can:166
local FLOW = { ["type"] = "flow" } -- models/free-market.can:167
local VERTICAL_FLOW = { -- models/free-market.can:168
	["type"] = "flow", -- models/free-market.can:168
	["direction"] = "vertical" -- models/free-market.can:168
} -- models/free-market.can:168
local SPRITE_BUTTON = { ["type"] = "sprite-button" } -- models/free-market.can:169
local SLOT_BUTTON = { -- models/free-market.can:170
	["type"] = "sprite-button", -- models/free-market.can:170
	["style"] = "slot_button" -- models/free-market.can:170
} -- models/free-market.can:170
local EMPTY_WIDGET = { ["type"] = "empty-widget" } -- models/free-market.can:171
local PRICE_LABEL = { -- models/free-market.can:172
	["type"] = "label", -- models/free-market.can:172
	["style"] = "FM_price_label" -- models/free-market.can:172
} -- models/free-market.can:172
local POST_PRICE_LABEL = { -- models/free-market.can:173
	["type"] = "label", -- models/free-market.can:173
	["style"] = "FM_price_label", -- models/free-market.can:173
	["caption"] = "$" -- models/free-market.can:173
} -- models/free-market.can:173
local PRICE_FRAME = { -- models/free-market.can:174
	["type"] = "frame", -- models/free-market.can:174
	["style"] = "FM_price_frame" -- models/free-market.can:174
} -- models/free-market.can:174
local SELL_PRICE_BUTTON = { -- models/free-market.can:175
	["type"] = "sprite-button", -- models/free-market.can:175
	["style"] = "slot_button", -- models/free-market.can:175
	["name"] = "FM_open_sell_price" -- models/free-market.can:175
} -- models/free-market.can:175
local BUY_PRICE_BUTTON = { -- models/free-market.can:176
	["type"] = "sprite-button", -- models/free-market.can:176
	["style"] = "slot_button", -- models/free-market.can:176
	["name"] = "FM_open_buy_price" -- models/free-market.can:176
} -- models/free-market.can:176
local ALLOWED_TYPES = { -- models/free-market.can:177
	["container"] = true, -- models/free-market.can:177
	["logistic-container"] = true -- models/free-market.can:177
} -- models/free-market.can:177
local TITLEBAR_FLOW = { -- models/free-market.can:178
	["type"] = "flow", -- models/free-market.can:178
	["style"] = "flib_titlebar_flow", -- models/free-market.can:178
	["name"] = "titlebar" -- models/free-market.can:178
} -- models/free-market.can:178
local DRAG_HANDLER = { -- models/free-market.can:179
	["type"] = "empty-widget", -- models/free-market.can:179
	["style"] = "flib_dialog_footer_drag_handle", -- models/free-market.can:179
	["name"] = "drag_handler" -- models/free-market.can:179
} -- models/free-market.can:179
local STORAGE_LIMIT_TEXTFIELD = { -- models/free-market.can:180
	["type"] = "textfield", -- models/free-market.can:180
	["name"] = "storage_limit", -- models/free-market.can:180
	["style"] = "FM_price_textfield", -- models/free-market.can:180
	["numeric"] = true, -- models/free-market.can:180
	["allow_decimal"] = false, -- models/free-market.can:180
	["allow_negative"] = false -- models/free-market.can:180
} -- models/free-market.can:180
local DEFAULT_LIMIT_TEXTFIELD = { -- models/free-market.can:181
	["type"] = "textfield", -- models/free-market.can:181
	["name"] = "FM_default_limit", -- models/free-market.can:181
	["style"] = "FM_price_textfield", -- models/free-market.can:181
	["numeric"] = true, -- models/free-market.can:181
	["allow_decimal"] = false, -- models/free-market.can:181
	["allow_negative"] = false -- models/free-market.can:181
} -- models/free-market.can:181
local SELL_PRICE_TEXTFIELD = { -- models/free-market.can:182
	["type"] = "textfield", -- models/free-market.can:182
	["name"] = "sell_price", -- models/free-market.can:182
	["style"] = "FM_price_textfield", -- models/free-market.can:182
	["numeric"] = true, -- models/free-market.can:182
	["allow_decimal"] = false, -- models/free-market.can:182
	["allow_negative"] = false -- models/free-market.can:182
} -- models/free-market.can:182
local BUY_PRICE_TEXTFIELD = { -- models/free-market.can:183
	["type"] = "textfield", -- models/free-market.can:183
	["name"] = "buy_price", -- models/free-market.can:183
	["style"] = "FM_price_textfield", -- models/free-market.can:183
	["numeric"] = true, -- models/free-market.can:183
	["allow_decimal"] = false, -- models/free-market.can:183
	["allow_negative"] = false -- models/free-market.can:183
} -- models/free-market.can:183
local SCROLL_PANE = { -- models/free-market.can:184
	["type"] = "scroll-pane", -- models/free-market.can:185
	["name"] = "scroll-pane", -- models/free-market.can:186
	["horizontal_scroll_policy"] = "never" -- models/free-market.can:187
} -- models/free-market.can:187
local CLOSE_BUTTON = { -- models/free-market.can:189
	["hovered_sprite"] = "utility/close_black", -- models/free-market.can:190
	["clicked_sprite"] = "utility/close_black", -- models/free-market.can:191
	["sprite"] = "utility/close_white", -- models/free-market.can:192
	["style"] = "frame_action_button", -- models/free-market.can:193
	["type"] = "sprite-button", -- models/free-market.can:194
	["name"] = "FM_close" -- models/free-market.can:195
} -- models/free-market.can:195
local ITEM_FILTERS = { -- models/free-market.can:197
	{ -- models/free-market.can:198
		["filter"] = "type", -- models/free-market.can:198
		["type"] = "blueprint-book", -- models/free-market.can:198
		["invert"] = true, -- models/free-market.can:198
		["mode"] = "and" -- models/free-market.can:198
	}, -- models/free-market.can:198
	{ -- models/free-market.can:199
		["filter"] = "selection-tool", -- models/free-market.can:199
		["invert"] = true, -- models/free-market.can:199
		["mode"] = "and" -- models/free-market.can:199
	} -- models/free-market.can:199
} -- models/free-market.can:199
local FM_ITEM_ELEMENT = { -- models/free-market.can:201
	["type"] = "choose-elem-button", -- models/free-market.can:201
	["name"] = "FM_item", -- models/free-market.can:201
	["elem_type"] = "item", -- models/free-market.can:201
	["elem_filters"] = ITEM_FILTERS -- models/free-market.can:201
} -- models/free-market.can:201
local CHECK_BUTTON = { -- models/free-market.can:202
	["type"] = "sprite-button", -- models/free-market.can:203
	["style"] = "item_and_count_select_confirm", -- models/free-market.can:204
	["sprite"] = "utility/check_mark" -- models/free-market.can:205
} -- models/free-market.can:205
local update_buy_tick = settings["global"]["FM_update-tick"]["value"] -- models/free-market.can:212
local update_transfer_tick = settings["global"]["FM_update-transfer-tick"]["value"] -- models/free-market.can:215
local update_pull_tick = settings["global"]["FM_update-pull-tick"]["value"] -- models/free-market.can:218
local is_auto_embargo = settings["global"]["FM_enable-auto-embargo"]["value"] -- models/free-market.can:221
local money_treshold = settings["global"]["FM_money-treshold"]["value"] -- models/free-market.can:224
local minimal_price = settings["global"]["FM_minimal-price"]["value"] -- models/free-market.can:227
local maximal_price = settings["global"]["FM_maximal-price"]["value"] -- models/free-market.can:230
local skip_offline_team_chance = settings["global"]["FM_skip_offline_team_chance"]["value"] -- models/free-market.can:233
local max_storage_threshold = settings["global"]["FM_max_storage_threshold"]["value"] -- models/free-market.can:236
local pull_cost_per_item = settings["global"]["FM_pull_cost_per_item"]["value"] -- models/free-market.can:239
local is_public_titles = settings["global"]["FM_is-public-titles"]["value"] -- models/free-market.can:242
local is_reset_public = settings["global"]["FM_is_reset_public"]["value"] -- models/free-market.can:245
clear_invalid_data = nil -- models/free-market.can:251
print_force_data = function(target, getter) -- models/free-market.can:255
	if getter then -- models/free-market.can:256
		if not getter["valid"] then -- models/free-market.can:257
			log("Invalid object") -- models/free-market.can:258
			return  -- models/free-market.can:259
		end -- models/free-market.can:259
	else -- models/free-market.can:259
		getter = game -- models/free-market.can:262
	end -- models/free-market.can:262
	local index -- models/free-market.can:265
	local object_name = target["object_name"] -- models/free-market.can:266
	if object_name == "LuaPlayer" then -- models/free-market.can:267
		index = target["force"]["index"] -- models/free-market.can:268
	elseif object_name == "LuaForce" then -- models/free-market.can:269
		index = target["index"] -- models/free-market.can:270
	else -- models/free-market.can:270
		log("Invalid type") -- models/free-market.can:272
		return  -- models/free-market.can:273
	end -- models/free-market.can:273
	local print_to_target = getter["print"] -- models/free-market.can:276
	print_to_target("") -- models/free-market.can:277
	print_to_target("Inactive sell prices:" .. serpent["line"](inactive_sell_prices[index])) -- models/free-market.can:278
	print_to_target("Inactive buy prices:" .. serpent["line"](inactive_buy_prices[index])) -- models/free-market.can:279
	print_to_target("Sell prices:" .. serpent["line"](sell_prices[index])) -- models/free-market.can:280
	print_to_target("Buy prices:" .. serpent["line"](buy_prices[index])) -- models/free-market.can:281
	print_to_target("Universal transferers:" .. serpent["line"](universal_transfer_boxes[index])) -- models/free-market.can:282
	print_to_target("Transferers:" .. serpent["line"](transfer_boxes[index])) -- models/free-market.can:283
	print_to_target("Bin boxes:" .. serpent["line"](bin_boxes[index])) -- models/free-market.can:284
	print_to_target("Universal bin boxes:" .. serpent["line"](universal_bin_boxes[index])) -- models/free-market.can:285
	print_to_target("Pull boxes:" .. serpent["line"](pull_boxes[index])) -- models/free-market.can:286
	print_to_target("Buy boxes:" .. serpent["line"](buy_boxes[index])) -- models/free-market.can:287
	print_to_target("Embargoes:" .. serpent["line"](embargoes[index])) -- models/free-market.can:288
	print_to_target("Storage:" .. serpent["line"](storages[index])) -- models/free-market.can:289
end -- models/free-market.can:289
resetBuyBoxes = function(force_index) -- models/free-market.can:294
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:295
	if f_buy_boxes == nil then -- models/free-market.can:296
		return  -- models/free-market.can:296
	end -- models/free-market.can:296
	for _, forces_data in pairs(f_buy_boxes) do -- models/free-market.can:298
		for _, entities_data in pairs(forces_data) do -- models/free-market.can:299
			local unit_number = entities_data[1]["unit_number"] -- models/free-market.can:300
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:301
			all_boxes[unit_number] = nil -- models/free-market.can:302
		end -- models/free-market.can:302
	end -- models/free-market.can:302
	buy_boxes[force_index] = {} -- models/free-market.can:305
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:307
	if f_buy_prices == nil then -- models/free-market.can:308
		return  -- models/free-market.can:308
	end -- models/free-market.can:308
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:309
	if f_inactive_buy_prices == nil then -- models/free-market.can:310
		return  -- models/free-market.can:310
	end -- models/free-market.can:310
	for item_name, price in pairs(f_buy_prices) do -- models/free-market.can:311
		f_inactive_buy_prices[item_name] = price -- models/free-market.can:312
	end -- models/free-market.can:312
	buy_prices[force_index] = {} -- models/free-market.can:314
end -- models/free-market.can:314
resetTransferBoxes = function(force_index) -- models/free-market.can:319
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:320
	if f_transfer_boxes == nil then -- models/free-market.can:321
		return  -- models/free-market.can:321
	end -- models/free-market.can:321
	for _, entities_data in pairs(f_transfer_boxes) do -- models/free-market.can:323
		for i = 1, # entities_data do -- models/free-market.can:324
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:325
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:326
			all_boxes[unit_number] = nil -- models/free-market.can:327
		end -- models/free-market.can:327
	end -- models/free-market.can:327
	transfer_boxes[force_index] = {} -- models/free-market.can:330
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:332
	if f_inactive_sell_prices == nil then -- models/free-market.can:333
		return  -- models/free-market.can:333
	end -- models/free-market.can:333
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:334
	if f_sell_prices == nil then -- models/free-market.can:335
		return  -- models/free-market.can:335
	end -- models/free-market.can:335
	local storage = storages[force_index] -- models/free-market.can:336
	if storage == nil then -- models/free-market.can:337
		return  -- models/free-market.can:337
	end -- models/free-market.can:337
	for item_name, price in pairs(f_sell_prices) do -- models/free-market.can:339
		local count = storage[item_name] -- models/free-market.can:340
		if count == nil or count <= 0 then -- models/free-market.can:341
			f_inactive_sell_prices[item_name] = price -- models/free-market.can:342
			f_sell_prices[item_name] = nil -- models/free-market.can:343
		end -- models/free-market.can:343
	end -- models/free-market.can:343
end -- models/free-market.can:343
resetUniversalTransferBoxes = function(force_index) -- models/free-market.can:350
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:351
	if entities == nil then -- models/free-market.can:352
		return  -- models/free-market.can:352
	end -- models/free-market.can:352
	for i = 1, # entities do -- models/free-market.can:354
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:355
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:356
		all_boxes[unit_number] = nil -- models/free-market.can:357
	end -- models/free-market.can:357
	universal_transfer_boxes[force_index] = {} -- models/free-market.can:359
end -- models/free-market.can:359
resetBinBoxes = function(force_index) -- models/free-market.can:364
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:365
	if f_bin_boxes == nil then -- models/free-market.can:366
		return  -- models/free-market.can:366
	end -- models/free-market.can:366
	for _, entities_data in pairs(f_bin_boxes) do -- models/free-market.can:368
		for i = 1, # entities_data do -- models/free-market.can:369
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:370
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:371
			all_boxes[unit_number] = nil -- models/free-market.can:372
		end -- models/free-market.can:372
	end -- models/free-market.can:372
	bin_boxes[force_index] = {} -- models/free-market.can:375
end -- models/free-market.can:375
resetUniversalBinBoxes = function(force_index) -- models/free-market.can:380
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:381
	if entities == nil then -- models/free-market.can:382
		return  -- models/free-market.can:382
	end -- models/free-market.can:382
	for i = 1, # entities do -- models/free-market.can:384
		local unit_number = entities[i]["unit_number"] -- models/free-market.can:385
		rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:386
		all_boxes[unit_number] = nil -- models/free-market.can:387
	end -- models/free-market.can:387
	universal_bin_boxes[force_index] = {} -- models/free-market.can:389
end -- models/free-market.can:389
resetPullBoxes = function(force_index) -- models/free-market.can:394
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:395
	if f_pull_boxes == nil then -- models/free-market.can:396
		return  -- models/free-market.can:396
	end -- models/free-market.can:396
	for _, entities_data in pairs(f_pull_boxes) do -- models/free-market.can:398
		for i = 1, # entities_data do -- models/free-market.can:399
			local unit_number = entities_data[i]["unit_number"] -- models/free-market.can:400
			rendering_destroy(all_boxes[unit_number][2]) -- models/free-market.can:401
			all_boxes[unit_number] = nil -- models/free-market.can:402
		end -- models/free-market.can:402
	end -- models/free-market.can:402
	pull_boxes[force_index] = {} -- models/free-market.can:405
end -- models/free-market.can:405
resetAllBoxes = function(force_index) -- models/free-market.can:410
	resetTransferBoxes(force_index) -- models/free-market.can:411
	resetUniversalTransferBoxes(force_index) -- models/free-market.can:412
	resetBinBoxes(force_index) -- models/free-market.can:413
	resetUniversalBinBoxes(force_index) -- models/free-market.can:414
	resetPullBoxes(force_index) -- models/free-market.can:415
	resetBuyBoxes(force_index) -- models/free-market.can:416
end -- models/free-market.can:416
getRconData = function(name) -- models/free-market.can:425
	print_to_rcon(game["table_to_json"](mod_data[name])) -- models/free-market.can:426
end -- models/free-market.can:426
getRconForceData = function(name, force) -- models/free-market.can:431
	if not force["valid"] then -- models/free-market.can:432
		return  -- models/free-market.can:432
	end -- models/free-market.can:432
	print_to_rcon(game["table_to_json"](mod_data[name][force["index"]])) -- models/free-market.can:433
end -- models/free-market.can:433
getRconForceDataByIndex = function(name, force_index) -- models/free-market.can:438
	print_to_rcon(game["table_to_json"](mod_data[name][force_index])) -- models/free-market.can:439
end -- models/free-market.can:439
local function clear_force_data(index) -- models/free-market.can:448
	default_storage_limit[index] = nil -- models/free-market.can:449
	inactive_sell_prices[index] = nil -- models/free-market.can:450
	inactive_buy_prices[index] = nil -- models/free-market.can:451
	bin_boxes[index] = nil -- models/free-market.can:452
	inactive_bin_boxes[index] = nil -- models/free-market.can:453
	universal_bin_boxes[index] = nil -- models/free-market.can:454
	inactive_universal_bin_boxes[index] = nil -- models/free-market.can:455
	inactive_universal_transfer_boxes[index] = nil -- models/free-market.can:456
	inactive_transfer_boxes[index] = nil -- models/free-market.can:457
	inactive_buy_boxes[index] = nil -- models/free-market.can:458
	storages_limit[index] = nil -- models/free-market.can:459
	sell_prices[index] = nil -- models/free-market.can:460
	buy_prices[index] = nil -- models/free-market.can:461
	pull_boxes[index] = nil -- models/free-market.can:462
	universal_transfer_boxes[index] = nil -- models/free-market.can:463
	transfer_boxes[index] = nil -- models/free-market.can:464
	buy_boxes[index] = nil -- models/free-market.can:465
	embargoes[index] = nil -- models/free-market.can:466
	storages[index] = nil -- models/free-market.can:467
	for _, force_data in pairs(embargoes) do -- models/free-market.can:469
		force_data[index] = nil -- models/free-market.can:470
	end -- models/free-market.can:470
	for i, force_index in pairs(active_forces) do -- models/free-market.can:473
		if force_index == index then -- models/free-market.can:474
			tremove(active_forces, i) -- models/free-market.can:475
			break -- models/free-market.can:476
		end -- models/free-market.can:476
	end -- models/free-market.can:476
end -- models/free-market.can:476
local function init_force_data(index) -- models/free-market.can:482
	inactive_sell_prices[index] = inactive_sell_prices[index] or {} -- models/free-market.can:483
	inactive_buy_prices[index] = inactive_buy_prices[index] or {} -- models/free-market.can:484
	bin_boxes[index] = bin_boxes[index] or {} -- models/free-market.can:485
	inactive_bin_boxes[index] = inactive_bin_boxes[index] or {} -- models/free-market.can:486
	universal_bin_boxes[index] = universal_bin_boxes[index] or {} -- models/free-market.can:487
	inactive_universal_bin_boxes[index] = inactive_universal_bin_boxes[index] or {} -- models/free-market.can:488
	inactive_universal_transfer_boxes[index] = inactive_universal_transfer_boxes[index] or {} -- models/free-market.can:489
	inactive_transfer_boxes[index] = inactive_transfer_boxes[index] or {} -- models/free-market.can:490
	inactive_buy_boxes[index] = inactive_buy_boxes[index] or {} -- models/free-market.can:491
	sell_prices[index] = sell_prices[index] or {} -- models/free-market.can:492
	buy_prices[index] = buy_prices[index] or {} -- models/free-market.can:493
	pull_boxes[index] = pull_boxes[index] or {} -- models/free-market.can:494
	universal_transfer_boxes[index] = universal_transfer_boxes[index] or {} -- models/free-market.can:495
	transfer_boxes[index] = transfer_boxes[index] or {} -- models/free-market.can:496
	buy_boxes[index] = buy_boxes[index] or {} -- models/free-market.can:497
	embargoes[index] = embargoes[index] or {} -- models/free-market.can:498
	storages[index] = storages[index] or {} -- models/free-market.can:499
	if storages_limit[index] == nil then -- models/free-market.can:501
		storages_limit[index] = {} -- models/free-market.can:502
		local f_storages_limit = storages_limit[index] -- models/free-market.can:503
		for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:504
			if item["stack_size"] <= 5 then -- models/free-market.can:505
				f_storages_limit[item_name] = 1 -- models/free-market.can:506
			end -- models/free-market.can:506
		end -- models/free-market.can:506
	end -- models/free-market.can:506
end -- models/free-market.can:506
local function remove_certain_transfer_box(entity, box_data) -- models/free-market.can:514
	local force_index = entity["force"]["index"] -- models/free-market.can:515
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:516
	local item_name = box_data[5] -- models/free-market.can:517
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:518
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:519
	if entities == nil then -- models/free-market.can:520
		return  -- models/free-market.can:520
	end -- models/free-market.can:520
	for i = # entities, 1, - 1 do -- models/free-market.can:521
		if entities[i] == entity then -- models/free-market.can:522
			tremove(entities, i) -- models/free-market.can:523
			if # entities == 0 then -- models/free-market.can:524
				f_transfer_boxes[item_name] = nil -- models/free-market.can:525
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:526
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:527
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:528
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:529
					if sell_price then -- models/free-market.can:530
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:531
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:532
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:533
							f_sell_prices[item_name] = nil -- models/free-market.can:534
						end -- models/free-market.can:534
					end -- models/free-market.can:534
				end -- models/free-market.can:534
			end -- models/free-market.can:534
			return  -- models/free-market.can:539
		end -- models/free-market.can:539
	end -- models/free-market.can:539
end -- models/free-market.can:539
local function remove_certain_bin_box(entity, box_data) -- models/free-market.can:546
	local force_index = entity["force"]["index"] -- models/free-market.can:547
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:548
	local item_name = box_data[5] -- models/free-market.can:549
	local entities = f_bin_boxes[item_name] -- models/free-market.can:550
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:551
	if entities == nil then -- models/free-market.can:552
		return  -- models/free-market.can:552
	end -- models/free-market.can:552
	for i = # entities, 1, - 1 do -- models/free-market.can:553
		if entities[i] == entity then -- models/free-market.can:554
			tremove(entities, i) -- models/free-market.can:555
			if # entities == 0 then -- models/free-market.can:556
				f_bin_boxes[item_name] = nil -- models/free-market.can:557
				local quantity_stored = storages[force_index][item_name] -- models/free-market.can:558
				if quantity_stored == nil or quantity_stored <= 0 then -- models/free-market.can:559
					local f_sell_prices = sell_prices[force_index] -- models/free-market.can:560
					local sell_price = f_sell_prices[item_name] -- models/free-market.can:561
					if sell_price and transfer_boxes[force_index][item_name] == nil then -- models/free-market.can:562
						local count_in_storage = storages[force_index][item_name] -- models/free-market.can:563
						if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:564
							inactive_sell_prices[force_index][item_name] = sell_price -- models/free-market.can:565
							f_sell_prices[item_name] = nil -- models/free-market.can:566
						end -- models/free-market.can:566
					end -- models/free-market.can:566
				end -- models/free-market.can:566
			end -- models/free-market.can:566
			return  -- models/free-market.can:571
		end -- models/free-market.can:571
	end -- models/free-market.can:571
end -- models/free-market.can:571
local function remove_certain_universal_transfer_box(entity) -- models/free-market.can:577
	local force_index = entity["force"]["index"] -- models/free-market.can:578
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:579
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:580
	if entities == nil then -- models/free-market.can:581
		return  -- models/free-market.can:581
	end -- models/free-market.can:581
	for i = # entities, 1, - 1 do -- models/free-market.can:582
		if entities[i] == entity then -- models/free-market.can:583
			tremove(entities, i) -- models/free-market.can:584
			return  -- models/free-market.can:585
		end -- models/free-market.can:585
	end -- models/free-market.can:585
end -- models/free-market.can:585
local function remove_certain_universal_bin_box(entity) -- models/free-market.can:591
	local force_index = entity["force"]["index"] -- models/free-market.can:592
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:593
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:594
	if entities == nil then -- models/free-market.can:595
		return  -- models/free-market.can:595
	end -- models/free-market.can:595
	for i = # entities, 1, - 1 do -- models/free-market.can:596
		if entities[i] == entity then -- models/free-market.can:597
			tremove(entities, i) -- models/free-market.can:598
			return  -- models/free-market.can:599
		end -- models/free-market.can:599
	end -- models/free-market.can:599
end -- models/free-market.can:599
local function remove_certain_buy_box(entity, box_data) -- models/free-market.can:606
	local force_index = entity["force"]["index"] -- models/free-market.can:607
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:608
	local item_name = box_data[5] -- models/free-market.can:609
	local items_data = f_buy_boxes[item_name] -- models/free-market.can:610
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:611
	if items_data == nil then -- models/free-market.can:612
		return  -- models/free-market.can:612
	end -- models/free-market.can:612
	for i = # items_data, 1, - 1 do -- models/free-market.can:613
		local buy_box = items_data[i] -- models/free-market.can:614
		if buy_box[1] == entity then -- models/free-market.can:615
			tremove(items_data, i) -- models/free-market.can:616
			if # items_data == 0 then -- models/free-market.can:617
				f_buy_boxes[item_name] = nil -- models/free-market.can:618
				local f_buy_prices = buy_prices[force_index] -- models/free-market.can:619
				local buy_price = f_buy_prices[item_name] -- models/free-market.can:620
				if buy_price then -- models/free-market.can:621
					inactive_buy_prices[force_index][item_name] = buy_price -- models/free-market.can:622
					f_buy_prices[item_name] = nil -- models/free-market.can:623
				end -- models/free-market.can:623
			end -- models/free-market.can:623
			return  -- models/free-market.can:626
		end -- models/free-market.can:626
	end -- models/free-market.can:626
end -- models/free-market.can:626
local function remove_certain_pull_box(entity, box_data) -- models/free-market.can:633
	local force_index = entity["force"]["index"] -- models/free-market.can:634
	local f_pull_boxes = pull_boxes[force_index] -- models/free-market.can:635
	local item_name = box_data[5] -- models/free-market.can:636
	local entities = f_pull_boxes[item_name] -- models/free-market.can:637
	all_boxes[entity["unit_number"]] = nil -- models/free-market.can:638
	if entities == nil then -- models/free-market.can:639
		return  -- models/free-market.can:639
	end -- models/free-market.can:639
	for i = # entities, 1, - 1 do -- models/free-market.can:640
		if entities[i] == entity then -- models/free-market.can:641
			tremove(entities, i) -- models/free-market.can:642
			if # entities == 0 then -- models/free-market.can:643
				f_pull_boxes[item_name] = nil -- models/free-market.can:644
			end -- models/free-market.can:644
			return  -- models/free-market.can:646
		end -- models/free-market.can:646
	end -- models/free-market.can:646
end -- models/free-market.can:646
local function change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:655
	local data = buy_boxes[entity["force"]["index"]][item_name] -- models/free-market.can:656
	for i = 1, # data do -- models/free-market.can:657
		local buy_box = data[i] -- models/free-market.can:658
		if buy_box[1] == entity then -- models/free-market.can:659
			buy_box[2] = count -- models/free-market.can:660
			return  -- models/free-market.can:661
		end -- models/free-market.can:661
	end -- models/free-market.can:661
end -- models/free-market.can:661
local function clear_invalid_embargoes() -- models/free-market.can:666
	local forces = game["forces"] -- models/free-market.can:667
	for index in pairs(embargoes) do -- models/free-market.can:668
		if forces[index] == nil then -- models/free-market.can:669
			embargoes[index] = nil -- models/free-market.can:670
		end -- models/free-market.can:670
	end -- models/free-market.can:670
	for _, forces_data in pairs(embargoes) do -- models/free-market.can:673
		for index in pairs(forces_data) do -- models/free-market.can:674
			if forces[index] == nil then -- models/free-market.can:675
				forces_data[index] = nil -- models/free-market.can:676
			end -- models/free-market.can:676
		end -- models/free-market.can:676
	end -- models/free-market.can:676
end -- models/free-market.can:676
local function show_item_sprite_above_chest(item_name, force, entity) -- models/free-market.can:685
	if # force["connected_players"] > 1 then -- models/free-market.can:686
		draw_sprite({ -- models/free-market.can:687
			["sprite"] = "item." .. item_name, -- models/free-market.can:688
			["target"] = entity, -- models/free-market.can:689
			["surface"] = entity["surface"], -- models/free-market.can:690
			["forces"] = { force }, -- models/free-market.can:691
			["time_to_live"] = 200, -- models/free-market.can:692
			["x_scale"] = 0.9, -- models/free-market.can:693
			["target_offset"] = HINT_SPRITE_OFFSET -- models/free-market.can:694
		}) -- models/free-market.can:694
	end -- models/free-market.can:694
end -- models/free-market.can:694
local function clear_invalid_prices(prices) -- models/free-market.can:699
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:700
	local forces = game["forces"] -- models/free-market.can:701
	for index, forces_data in pairs(prices) do -- models/free-market.can:702
		if forces[index] == nil then -- models/free-market.can:703
			sell_prices[index] = nil -- models/free-market.can:704
			buy_prices[index] = nil -- models/free-market.can:705
			inactive_sell_prices[index] = nil -- models/free-market.can:706
			inactive_buy_prices[index] = nil -- models/free-market.can:707
		else -- models/free-market.can:707
			for item_name in pairs(forces_data) do -- models/free-market.can:709
				if item_prototypes[item_name] == nil then -- models/free-market.can:710
					forces_data[item_name] = nil -- models/free-market.can:711
				end -- models/free-market.can:711
			end -- models/free-market.can:711
		end -- models/free-market.can:711
	end -- models/free-market.can:711
end -- models/free-market.can:711
local function clear_invalid_storage_data() -- models/free-market.can:718
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:719
	local forces = game["forces"] -- models/free-market.can:720
	for index, data in pairs(pull_boxes) do -- models/free-market.can:721
		if forces[index] == nil then -- models/free-market.can:722
			clear_force_data(index) -- models/free-market.can:723
		else -- models/free-market.can:723
			for item_name, count in pairs(data) do -- models/free-market.can:725
				if item_prototypes[item_name] == nil or count == 0 then -- models/free-market.can:726
					data[item_name] = nil -- models/free-market.can:727
				end -- models/free-market.can:727
			end -- models/free-market.can:727
		end -- models/free-market.can:727
	end -- models/free-market.can:727
end -- models/free-market.can:727
local function clear_invalid_pull_boxes_data() -- models/free-market.can:734
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:735
	local forces = game["forces"] -- models/free-market.can:736
	for index, data in pairs(pull_boxes) do -- models/free-market.can:737
		if forces[index] == nil then -- models/free-market.can:738
			clear_force_data(index) -- models/free-market.can:739
		else -- models/free-market.can:739
			for item_name, entities in pairs(data) do -- models/free-market.can:741
				if item_prototypes[item_name] == nil then -- models/free-market.can:742
					data[item_name] = nil -- models/free-market.can:743
				else -- models/free-market.can:743
					for i = # entities, 1, - 1 do -- models/free-market.can:745
						local entity = entities[i] -- models/free-market.can:746
						if entity["valid"] == false then -- models/free-market.can:747
							tremove(entities, i) -- models/free-market.can:748
						else -- models/free-market.can:748
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:750
							if box_data == nil then -- models/free-market.can:751
								tremove(entities, i) -- models/free-market.can:752
							elseif entity ~= box_data[1] then -- models/free-market.can:753
								rendering_destroy(box_data[2]) -- models/free-market.can:754
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:755
								tremove(entities, i) -- models/free-market.can:756
							end -- models/free-market.can:756
						end -- models/free-market.can:756
					end -- models/free-market.can:756
					if # entities == 0 then -- models/free-market.can:760
						data[item_name] = nil -- models/free-market.can:761
					end -- models/free-market.can:761
				end -- models/free-market.can:761
			end -- models/free-market.can:761
		end -- models/free-market.can:761
	end -- models/free-market.can:761
end -- models/free-market.can:761
local function clear_invalid_transfer_boxes_data(_data) -- models/free-market.can:770
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:771
	local forces = game["forces"] -- models/free-market.can:772
	for index, data in pairs(_data) do -- models/free-market.can:773
		if forces[index] == nil then -- models/free-market.can:774
			clear_force_data(index) -- models/free-market.can:775
		else -- models/free-market.can:775
			for item_name, entities in pairs(data) do -- models/free-market.can:777
				if item_prototypes[item_name] == nil then -- models/free-market.can:778
					data[item_name] = nil -- models/free-market.can:779
				else -- models/free-market.can:779
					for i = # entities, 1, - 1 do -- models/free-market.can:781
						local entity = entities[i] -- models/free-market.can:782
						if entity["valid"] == false then -- models/free-market.can:783
							tremove(entities, i) -- models/free-market.can:784
						else -- models/free-market.can:784
							local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:786
							if box_data == nil then -- models/free-market.can:787
								tremove(entities, i) -- models/free-market.can:788
							elseif entity ~= box_data[1] then -- models/free-market.can:789
								rendering_destroy(box_data[2]) -- models/free-market.can:790
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:791
								tremove(entities, i) -- models/free-market.can:792
							end -- models/free-market.can:792
						end -- models/free-market.can:792
					end -- models/free-market.can:792
					if # entities == 0 then -- models/free-market.can:796
						data[item_name] = nil -- models/free-market.can:797
					end -- models/free-market.can:797
				end -- models/free-market.can:797
			end -- models/free-market.can:797
		end -- models/free-market.can:797
	end -- models/free-market.can:797
end -- models/free-market.can:797
local function clear_invalid_buy_boxes_data(_data) -- models/free-market.can:806
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:807
	local forces = game["forces"] -- models/free-market.can:808
	for index, data in pairs(_data) do -- models/free-market.can:809
		if forces[index] == nil then -- models/free-market.can:810
			clear_force_data(index) -- models/free-market.can:811
		else -- models/free-market.can:811
			for item_name, entities in pairs(data) do -- models/free-market.can:813
				if item_prototypes[item_name] == nil then -- models/free-market.can:814
					data[item_name] = nil -- models/free-market.can:815
				else -- models/free-market.can:815
					for i = # entities, 1, - 1 do -- models/free-market.can:817
						local box_data = entities[i] -- models/free-market.can:818
						local entity = box_data[1] -- models/free-market.can:819
						if entity["valid"] == false then -- models/free-market.can:820
							tremove(entities, i) -- models/free-market.can:821
						elseif not box_data[2] then -- models/free-market.can:822
							tremove(entities, i) -- models/free-market.can:823
							all_boxes[entity["unit_number"]] = nil -- models/free-market.can:824
						else -- models/free-market.can:824
							local _box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:826
							if _box_data == nil then -- models/free-market.can:827
								tremove(entities, i) -- models/free-market.can:828
							elseif entity ~= _box_data[1] then -- models/free-market.can:829
								rendering_destroy(box_data[2]) -- models/free-market.can:830
								all_boxes[entity["unit_number"]] = nil -- models/free-market.can:831
								tremove(entities, i) -- models/free-market.can:832
							end -- models/free-market.can:832
						end -- models/free-market.can:832
					end -- models/free-market.can:832
					if # entities == 0 then -- models/free-market.can:836
						data[item_name] = nil -- models/free-market.can:837
					end -- models/free-market.can:837
				end -- models/free-market.can:837
			end -- models/free-market.can:837
		end -- models/free-market.can:837
	end -- models/free-market.can:837
end -- models/free-market.can:837
local function clear_invalid_simple_boxes(data) -- models/free-market.can:846
	for _, entities in pairs(data) do -- models/free-market.can:847
		for i = # entities, 1, - 1 do -- models/free-market.can:848
			local entity = entities[i] -- models/free-market.can:849
			if entity["valid"] == false then -- models/free-market.can:850
				tremove(entities, i) -- models/free-market.can:851
			else -- models/free-market.can:851
				local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:853
				if box_data == nil then -- models/free-market.can:854
					tremove(entities, i) -- models/free-market.can:855
				elseif entity ~= box_data[1] then -- models/free-market.can:856
					rendering_destroy(box_data[2]) -- models/free-market.can:857
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:858
					tremove(entities, i) -- models/free-market.can:859
				end -- models/free-market.can:859
			end -- models/free-market.can:859
		end -- models/free-market.can:859
	end -- models/free-market.can:859
end -- models/free-market.can:859
local function delete_item_price_HUD(player) -- models/free-market.can:867
	local frame = player["gui"]["screen"]["FM_item_price_frame"] -- models/free-market.can:868
	if frame then -- models/free-market.can:869
		frame["destroy"]() -- models/free-market.can:870
		item_HUD[player["index"]] = nil -- models/free-market.can:871
	end -- models/free-market.can:871
end -- models/free-market.can:871
local function clear_invalid_player_data() -- models/free-market.can:875
	for player_index in pairs(item_HUD) do -- models/free-market.can:876
		local player = game["get_player"](player_index) -- models/free-market.can:877
		if not (player and player["valid"]) then -- models/free-market.can:878
			item_HUD[player_index] = nil -- models/free-market.can:879
		elseif not player["connected"] then -- models/free-market.can:880
			delete_item_price_HUD(player) -- models/free-market.can:881
		end -- models/free-market.can:881
	end -- models/free-market.can:881
end -- models/free-market.can:881
local function clear_invalid_entities() -- models/free-market.can:886
	local item_prototypes = game["item_prototypes"] -- models/free-market.can:887
	for unit_number, data in pairs(all_boxes) do -- models/free-market.can:888
		if not data[1]["valid"] then -- models/free-market.can:889
			all_boxes[unit_number] = nil -- models/free-market.can:890
		else -- models/free-market.can:890
			local item_name = data[5] -- models/free-market.can:892
			if item_name and item_prototypes[item_name] == nil then -- models/free-market.can:893
				rendering_destroy(data[2]) -- models/free-market.can:894
				all_boxes[unit_number] = nil -- models/free-market.can:895
			end -- models/free-market.can:895
		end -- models/free-market.can:895
	end -- models/free-market.can:895
	clear_invalid_storage_data() -- models/free-market.can:900
	clear_invalid_pull_boxes_data() -- models/free-market.can:901
	clear_invalid_transfer_boxes_data(transfer_boxes) -- models/free-market.can:902
	clear_invalid_transfer_boxes_data(inactive_transfer_boxes) -- models/free-market.can:903
	clear_invalid_transfer_boxes_data(bin_boxes) -- models/free-market.can:904
	clear_invalid_transfer_boxes_data(inactive_bin_boxes) -- models/free-market.can:905
	clear_invalid_buy_boxes_data(buy_boxes) -- models/free-market.can:906
	clear_invalid_buy_boxes_data(inactive_buy_boxes) -- models/free-market.can:907
	clear_invalid_simple_boxes(universal_transfer_boxes) -- models/free-market.can:908
	clear_invalid_simple_boxes(inactive_universal_transfer_boxes) -- models/free-market.can:909
	clear_invalid_simple_boxes(universal_bin_boxes) -- models/free-market.can:910
	clear_invalid_simple_boxes(inactive_universal_bin_boxes) -- models/free-market.can:911
end -- models/free-market.can:911
clear_invalid_data = function() -- models/free-market.can:914
	clear_invalid_entities() -- models/free-market.can:915
	clear_invalid_prices(storages_limit) -- models/free-market.can:916
	clear_invalid_prices(inactive_sell_prices) -- models/free-market.can:917
	clear_invalid_prices(inactive_buy_prices) -- models/free-market.can:918
	clear_invalid_prices(sell_prices) -- models/free-market.can:919
	clear_invalid_prices(buy_prices) -- models/free-market.can:920
	clear_invalid_embargoes() -- models/free-market.can:921
	clear_invalid_player_data() -- models/free-market.can:922
end -- models/free-market.can:922
local function get_distance(start, stop) -- models/free-market.can:926
	local xdiff = start["x"] - stop["x"] -- models/free-market.can:927
	local ydiff = start["y"] - stop["y"] -- models/free-market.can:928
	return (xdiff * xdiff + ydiff * ydiff) ^ 0.5 -- models/free-market.can:929
end -- models/free-market.can:929
local function delete_player_data(event) -- models/free-market.can:932
	local player_index = event["player_index"] -- models/free-market.can:933
	open_box[player_index] = nil -- models/free-market.can:934
	item_HUD[player_index] = nil -- models/free-market.can:935
end -- models/free-market.can:935
local function make_prices_header(table) -- models/free-market.can:938
	local dummy -- models/free-market.can:939
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:940
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:941
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:942
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:943
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:944
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:945
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:946
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:947
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:948
	table["add"](LABEL)["caption"] = { "team-name" } -- models/free-market.can:950
	table["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:951
	table["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:952
end -- models/free-market.can:952
local function make_storage_header(table) -- models/free-market.can:955
	local dummy -- models/free-market.can:956
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:957
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:958
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:959
	dummy = table["add"](EMPTY_WIDGET) -- models/free-market.can:960
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:961
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:962
	table["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:964
	table["add"](LABEL)["caption"] = { "gui-logistic.count" } -- models/free-market.can:965
end -- models/free-market.can:965
local function make_price_list_header(table_element) -- models/free-market.can:969
	local dummy -- models/free-market.can:970
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:971
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:972
	dummy["style"]["minimal_width"] = 30 -- models/free-market.can:973
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:974
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:975
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:976
	dummy = table_element["add"](EMPTY_WIDGET) -- models/free-market.can:977
	dummy["style"]["horizontally_stretchable"] = true -- models/free-market.can:978
	dummy["style"]["minimal_width"] = 60 -- models/free-market.can:979
	table_element["add"](LABEL)["caption"] = { "item" } -- models/free-market.can:981
	table_element["add"](LABEL)["caption"] = { "free-market.buy-header" } -- models/free-market.can:982
	table_element["add"](LABEL)["caption"] = { "free-market.sell-header" } -- models/free-market.can:983
end -- models/free-market.can:983
local function update_prices_table(player, item_name, table_element) -- models/free-market.can:989
	table_element["clear"]() -- models/free-market.can:990
	make_prices_header(table_element) -- models/free-market.can:991
	local force = player["force"] -- models/free-market.can:992
	local result = {} -- models/free-market.can:993
	for name, _force in pairs(game["forces"]) do -- models/free-market.can:994
		if force ~= _force then -- models/free-market.can:995
			result[_force["index"]] = { ["name"] = name } -- models/free-market.can:996
		end -- models/free-market.can:996
	end -- models/free-market.can:996
	for index, force_items in pairs(buy_prices) do -- models/free-market.can:999
		local data = result[index] -- models/free-market.can:1000
		if data then -- models/free-market.can:1001
			local buy_value = force_items[item_name] -- models/free-market.can:1002
			if buy_value then -- models/free-market.can:1003
				data["buy_price"] = tostring(buy_value) -- models/free-market.can:1004
			end -- models/free-market.can:1004
		end -- models/free-market.can:1004
	end -- models/free-market.can:1004
	for index, force_items in pairs(sell_prices) do -- models/free-market.can:1008
		local data = result[index] -- models/free-market.can:1009
		if data then -- models/free-market.can:1010
			local sell_price = force_items[item_name] -- models/free-market.can:1011
			if sell_price then -- models/free-market.can:1012
				data["sell_price"] = tostring(sell_price) -- models/free-market.can:1013
			end -- models/free-market.can:1013
		end -- models/free-market.can:1013
	end -- models/free-market.can:1013
	local add = table_element["add"] -- models/free-market.can:1018
	for _, data in pairs(result) do -- models/free-market.can:1019
		if data["buy_price"] or data["sell_price"] then -- models/free-market.can:1020
			add(LABEL)["caption"] = data["name"] -- models/free-market.can:1021
			add(LABEL)["caption"] = (data["buy_price"] or "") -- models/free-market.can:1022
			add(LABEL)["caption"] = (data["sell_price"] or "") -- models/free-market.can:1023
		end -- models/free-market.can:1023
	end -- models/free-market.can:1023
end -- models/free-market.can:1023
local function update_price_list_table(force, scroll_pane) -- models/free-market.can:1030
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1031
	short_price_list_table["clear"]() -- models/free-market.can:1032
	short_price_list_table["visible"] = false -- models/free-market.can:1033
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1034
	price_list_table["clear"]() -- models/free-market.can:1035
	price_list_table["visible"] = true -- models/free-market.can:1036
	make_price_list_header(price_list_table) -- models/free-market.can:1037
	local force_index = force["index"] -- models/free-market.can:1039
	local f_buy_prices = buy_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1040
	local f_sell_prices = sell_prices[force_index] or EMPTY_TABLE -- models/free-market.can:1041
	local add = price_list_table["add"] -- models/free-market.can:1043
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1044
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1045
		add(LABEL)["caption"] = buy_price -- models/free-market.can:1046
		add(LABEL)["caption"] = (f_sell_prices[item_name] or "") -- models/free-market.can:1047
	end -- models/free-market.can:1047
	for item_name, sell_price in pairs(f_sell_prices) do -- models/free-market.can:1050
		if f_buy_prices[item_name] == nil then -- models/free-market.can:1051
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1052
			add(EMPTY_WIDGET) -- models/free-market.can:1053
			add(LABEL)["caption"] = sell_price -- models/free-market.can:1054
		end -- models/free-market.can:1054
	end -- models/free-market.can:1054
end -- models/free-market.can:1054
local function update_price_list_by_sell_filter(force, scroll_pane, text_filter) -- models/free-market.can:1062
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1063
	short_price_list_table["clear"]() -- models/free-market.can:1064
	short_price_list_table["visible"] = true -- models/free-market.can:1065
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1066
	price_list_table["clear"]() -- models/free-market.can:1067
	price_list_table["visible"] = false -- models/free-market.can:1068
	make_price_list_header(short_price_list_table) -- models/free-market.can:1070
	short_price_list_table["children"][5]["destroy"]() -- models/free-market.can:1071
	short_price_list_table["children"][2]["destroy"]() -- models/free-market.can:1072
	local f_sell_prices = sell_prices[force["index"]] -- models/free-market.can:1074
	if f_sell_prices == nil then -- models/free-market.can:1075
		return  -- models/free-market.can:1075
	end -- models/free-market.can:1075
	local add = short_price_list_table["add"] -- models/free-market.can:1077
	for item_name, buy_price in pairs(f_sell_prices) do -- models/free-market.can:1078
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1079
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1080
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1081
		end -- models/free-market.can:1081
	end -- models/free-market.can:1081
end -- models/free-market.can:1081
local function update_price_list_by_buy_filter(force, scroll_pane, text_filter) -- models/free-market.can:1089
	local short_price_list_table = scroll_pane["short_price_list_table"] -- models/free-market.can:1090
	short_price_list_table["clear"]() -- models/free-market.can:1091
	short_price_list_table["visible"] = true -- models/free-market.can:1092
	local price_list_table = scroll_pane["price_list_table"] -- models/free-market.can:1093
	price_list_table["clear"]() -- models/free-market.can:1094
	price_list_table["visible"] = false -- models/free-market.can:1095
	make_price_list_header(short_price_list_table) -- models/free-market.can:1097
	short_price_list_table["children"][6]["destroy"]() -- models/free-market.can:1098
	short_price_list_table["children"][3]["destroy"]() -- models/free-market.can:1099
	local f_buy_prices = buy_prices[force["index"]] -- models/free-market.can:1101
	if f_buy_prices == nil then -- models/free-market.can:1102
		return  -- models/free-market.can:1102
	end -- models/free-market.can:1102
	local add = short_price_list_table["add"] -- models/free-market.can:1104
	for item_name, buy_price in pairs(f_buy_prices) do -- models/free-market.can:1105
		if find(item_name:lower(), text_filter) then -- models/free-market.can:1106
			add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1107
			add(LABEL)["caption"] = buy_price -- models/free-market.can:1108
		end -- models/free-market.can:1108
	end -- models/free-market.can:1108
end -- models/free-market.can:1108
local function destroy_prices_gui(player) -- models/free-market.can:1114
	local screen = player["gui"]["screen"] -- models/free-market.can:1115
	if screen["FM_prices_frame"] then -- models/free-market.can:1116
		screen["FM_prices_frame"]["destroy"]() -- models/free-market.can:1117
	end -- models/free-market.can:1117
end -- models/free-market.can:1117
local function destroy_price_list_gui(player) -- models/free-market.can:1122
	local screen = player["gui"]["screen"] -- models/free-market.can:1123
	if screen["FM_price_list_frame"] then -- models/free-market.can:1124
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1125
	end -- models/free-market.can:1125
end -- models/free-market.can:1125
local function update_embargo_table(embargo_table, player) -- models/free-market.can:1131
	embargo_table["clear"]() -- models/free-market.can:1132
	embargo_table["add"](LABEL)["caption"] = { "free-market.without-embargo-title" } -- models/free-market.can:1134
	embargo_table["add"](EMPTY_WIDGET) -- models/free-market.can:1135
	embargo_table["add"](LABEL)["caption"] = { "free-market.with-embargo-title" } -- models/free-market.can:1136
	local force_index = player["force"]["index"] -- models/free-market.can:1138
	local in_embargo_list = {} -- models/free-market.can:1139
	local no_embargo_list = {} -- models/free-market.can:1140
	local f_embargoes = embargoes[force_index] -- models/free-market.can:1141
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1142
		if # force["players"] > 0 and force["index"] ~= force_index then -- models/free-market.can:1143
			if f_embargoes[force["index"]] then -- models/free-market.can:1144
				in_embargo_list[# in_embargo_list + 1] = force_name -- models/free-market.can:1145
			else -- models/free-market.can:1145
				no_embargo_list[# no_embargo_list + 1] = force_name -- models/free-market.can:1147
			end -- models/free-market.can:1147
		end -- models/free-market.can:1147
	end -- models/free-market.can:1147
	local forces_list = embargo_table["add"]({ -- models/free-market.can:1152
		["type"] = "list-box", -- models/free-market.can:1152
		["name"] = "forces_list", -- models/free-market.can:1152
		["items"] = no_embargo_list -- models/free-market.can:1152
	}) -- models/free-market.can:1152
	forces_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1153
	forces_list["style"]["height"] = 200 -- models/free-market.can:1154
	local buttons_flow = embargo_table["add"](VERTICAL_FLOW) -- models/free-market.can:1155
	buttons_flow["add"]({ -- models/free-market.can:1156
		["type"] = "sprite-button", -- models/free-market.can:1156
		["name"] = "FM_cancel_embargo", -- models/free-market.can:1156
		["style"] = "tool_button", -- models/free-market.can:1156
		["sprite"] = "utility/left_arrow" -- models/free-market.can:1156
	}) -- models/free-market.can:1156
	buttons_flow["add"]({ -- models/free-market.can:1157
		["type"] = "sprite-button", -- models/free-market.can:1157
		["name"] = "FM_declare_embargo", -- models/free-market.can:1157
		["style"] = "tool_button", -- models/free-market.can:1157
		["sprite"] = "utility/right_arrow" -- models/free-market.can:1157
	}) -- models/free-market.can:1157
	local embargo_list = embargo_table["add"]({ -- models/free-market.can:1158
		["type"] = "list-box", -- models/free-market.can:1158
		["name"] = "embargo_list", -- models/free-market.can:1158
		["items"] = in_embargo_list -- models/free-market.can:1158
	}) -- models/free-market.can:1158
	embargo_list["style"]["horizontally_stretchable"] = true -- models/free-market.can:1159
	embargo_list["style"]["height"] = 200 -- models/free-market.can:1160
end -- models/free-market.can:1160
local function add_item_in_sell_prices(player, item_name, price, force_index) -- models/free-market.can:1166
	local prices_table = player["gui"]["screen"]["FM_sell_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1167
	local add = prices_table["add"] -- models/free-market.can:1168
	local button = add(FLOW)["add"](SELL_PRICE_BUTTON) -- models/free-market.can:1169
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1170
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1171
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1172
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1174
	add(POST_PRICE_LABEL) -- models/free-market.can:1175
	local children = prices_table["children"] -- models/free-market.can:1177
	if # children / 2 > player["mod_settings"]["FM_sell_notification_size"]["value"] then -- models/free-market.can:1178
		children[2]["destroy"]() -- models/free-market.can:1179
		children[1]["destroy"]() -- models/free-market.can:1180
	end -- models/free-market.can:1180
end -- models/free-market.can:1180
local function add_item_in_buy_prices(player, item_name, price, force_index) -- models/free-market.can:1187
	local prices_table = player["gui"]["screen"]["FM_buy_prices_frame"]["FM_prices_flow"]["FM_prices_table"] -- models/free-market.can:1188
	local add = prices_table["add"] -- models/free-market.can:1189
	local button = add(FLOW)["add"](BUY_PRICE_BUTTON) -- models/free-market.can:1190
	button["sprite"] = "item/" .. item_name -- models/free-market.can:1191
	button["add"](EMPTY_WIDGET)["name"] = tostring(force_index) -- models/free-market.can:1192
	add = add(PRICE_FRAME)["add"] -- models/free-market.can:1193
	add(PRICE_LABEL)["caption"] = price -- models/free-market.can:1195
	add(POST_PRICE_LABEL) -- models/free-market.can:1196
	local children = prices_table["children"] -- models/free-market.can:1198
	if # children / 2 > player["mod_settings"]["FM_buy_notification_size"]["value"] then -- models/free-market.can:1199
		children[2]["destroy"]() -- models/free-market.can:1200
		children[1]["destroy"]() -- models/free-market.can:1201
	end -- models/free-market.can:1201
end -- models/free-market.can:1201
local function notify_sell_price(source_index, item_name, sell_price) -- models/free-market.can:1208
	local forces = game["forces"] -- models/free-market.can:1209
	local f_embargoes = embargoes[source_index] -- models/free-market.can:1210
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1211
		if force_index ~= source_index and not f_embargoes[f_embargoes] then -- models/free-market.can:1212
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1213
				pcall(add_item_in_sell_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1214
			end -- models/free-market.can:1214
		end -- models/free-market.can:1214
	end -- models/free-market.can:1214
end -- models/free-market.can:1214
local function notify_buy_price(source_index, item_name, sell_price) -- models/free-market.can:1223
	local forces = game["forces"] -- models/free-market.can:1224
	for _, force_index in pairs(active_forces) do -- models/free-market.can:1225
		if force_index ~= source_index and not embargoes[force_index][source_index] then -- models/free-market.can:1226
			for _, player in pairs(forces[force_index]["connected_players"]) do -- models/free-market.can:1227
				pcall(add_item_in_buy_prices, player, item_name, sell_price, source_index) -- models/free-market.can:1228
			end -- models/free-market.can:1228
		end -- models/free-market.can:1228
	end -- models/free-market.can:1228
end -- models/free-market.can:1228
local function change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:1238
	local force_index = player["force"]["index"] -- models/free-market.can:1239
	local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1240
	local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1241
	if sell_price == nil then -- models/free-market.can:1242
		f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1243
		f_sell_prices[item_name] = nil -- models/free-market.can:1244
		return  -- models/free-market.can:1245
	end -- models/free-market.can:1245
	local active_sell_price = f_sell_prices[item_name] -- models/free-market.can:1248
	local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1249
	local prev_sell_price = f_sell_prices[item_name] or inactive_sell_price -- models/free-market.can:1250
	if prev_sell_price == sell_price then -- models/free-market.can:1251
		if inactive_sell_price then -- models/free-market.can:1252
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1253
			if count_in_storage and count_in_storage > 0 then -- models/free-market.can:1254
				f_sell_prices[item_name] = sell_price -- models/free-market.can:1255
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1256
				notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1257
			end -- models/free-market.can:1257
		end -- models/free-market.can:1257
		return  -- models/free-market.can:1260
	end -- models/free-market.can:1260
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1263
	if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then -- models/free-market.can:1264
		player["print"]({ -- models/free-market.can:1265
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1265
			sell_price, -- models/free-market.can:1265
			buy_price or minimal_price, -- models/free-market.can:1265
			maximal_price -- models/free-market.can:1265
		}) -- models/free-market.can:1265
		return active_sell_price or inactive_sell_price or "" -- models/free-market.can:1266
	end -- models/free-market.can:1266
	if active_sell_price then -- models/free-market.can:1269
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1270
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1271
	elseif inactive_sell_price then -- models/free-market.can:1272
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1273
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1274
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1275
		else -- models/free-market.can:1275
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1277
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1278
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1279
		end -- models/free-market.can:1279
	elseif transfer_boxes[force_index][item_name] then -- models/free-market.can:1281
		f_sell_prices[item_name] = sell_price -- models/free-market.can:1282
		notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1283
	else -- models/free-market.can:1283
		local count_in_storage = storages[force_index][item_name] -- models/free-market.can:1285
		if count_in_storage == nil or count_in_storage <= 0 then -- models/free-market.can:1286
			f_inactive_sell_prices[item_name] = sell_price -- models/free-market.can:1287
		else -- models/free-market.can:1287
			f_sell_prices[item_name] = sell_price -- models/free-market.can:1289
			notify_sell_price(force_index, item_name, sell_price) -- models/free-market.can:1290
		end -- models/free-market.can:1290
	end -- models/free-market.can:1290
end -- models/free-market.can:1290
local function change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:1299
	local force_index = player["force"]["index"] -- models/free-market.can:1300
	local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1301
	local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1302
	if buy_price == nil then -- models/free-market.can:1303
		f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1304
		f_buy_prices[item_name] = nil -- models/free-market.can:1305
		return  -- models/free-market.can:1306
	end -- models/free-market.can:1306
	local prev_buy_price = f_buy_prices[item_name] or f_inactive_buy_prices[item_name] -- models/free-market.can:1309
	if prev_buy_price == buy_price then -- models/free-market.can:1310
		return  -- models/free-market.can:1311
	end -- models/free-market.can:1311
	local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:1314
	if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then -- models/free-market.can:1315
		player["print"]({ -- models/free-market.can:1316
			"gui-map-generator.invalid-value-for-field", -- models/free-market.can:1316
			buy_price, -- models/free-market.can:1316
			minimal_price, -- models/free-market.can:1316
			sell_price or maximal_price -- models/free-market.can:1316
		}) -- models/free-market.can:1316
		return f_buy_prices[item_name] or f_inactive_buy_prices[item_name] or "" -- models/free-market.can:1317
	end -- models/free-market.can:1317
	if f_buy_prices[item_name] then -- models/free-market.can:1320
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1321
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1322
	elseif f_inactive_buy_prices[item_name] then -- models/free-market.can:1323
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1324
	elseif buy_boxes[force_index][item_name] then -- models/free-market.can:1325
		f_buy_prices[item_name] = buy_price -- models/free-market.can:1326
		notify_buy_price(force_index, item_name, buy_price) -- models/free-market.can:1327
	else -- models/free-market.can:1327
		f_inactive_buy_prices[item_name] = buy_price -- models/free-market.can:1329
	end -- models/free-market.can:1329
end -- models/free-market.can:1329
local function create_price_notification_handler(gui, button_name, is_top_handler) -- models/free-market.can:1336
	local flow = gui["add"](TITLEBAR_FLOW) -- models/free-market.can:1337
	flow["style"]["padding"] = 0 -- models/free-market.can:1338
	if is_top_handler then -- models/free-market.can:1339
		local button = flow["add"]({ -- models/free-market.can:1340
			["type"] = "sprite-button", -- models/free-market.can:1341
			["sprite"] = "FM_price", -- models/free-market.can:1342
			["style"] = "frame_action_button", -- models/free-market.can:1343
			["name"] = button_name -- models/free-market.can:1344
		}) -- models/free-market.can:1344
		button["style"]["margin"] = 0 -- models/free-market.can:1346
	end -- models/free-market.can:1346
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:1348
	drag_handler["drag_target"] = gui -- models/free-market.can:1349
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:1350
	if is_top_handler then -- models/free-market.can:1351
		flow["style"]["horizontal_spacing"] = 0 -- models/free-market.can:1352
		drag_handler["style"]["width"] = 27 -- models/free-market.can:1353
		drag_handler["style"]["height"] = 25 -- models/free-market.can:1354
		drag_handler["style"]["horizontally_stretchable"] = false -- models/free-market.can:1355
	else -- models/free-market.can:1355
		drag_handler["style"]["width"] = 24 -- models/free-market.can:1357
		drag_handler["style"]["height"] = 46 -- models/free-market.can:1358
		drag_handler["add"]({ -- models/free-market.can:1359
			["type"] = "sprite-button", -- models/free-market.can:1360
			["sprite"] = "FM_price", -- models/free-market.can:1361
			["style"] = "frame_action_button", -- models/free-market.can:1362
			["name"] = button_name -- models/free-market.can:1363
		}) -- models/free-market.can:1363
	end -- models/free-market.can:1363
end -- models/free-market.can:1363
local function switch_sell_prices_gui(player, location) -- models/free-market.can:1370
	local screen = player["gui"]["screen"] -- models/free-market.can:1371
	local main_frame = screen["FM_sell_prices_frame"] -- models/free-market.can:1372
	if main_frame then -- models/free-market.can:1373
		local children = main_frame["children"] -- models/free-market.can:1374
		if # children > 1 then -- models/free-market.can:1375
			children[2]["destroy"]() -- models/free-market.can:1376
			return  -- models/free-market.can:1377
		else -- models/free-market.can:1377
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1379
				["type"] = "frame", -- models/free-market.can:1379
				["name"] = "FM_prices_flow", -- models/free-market.can:1379
				["style"] = "FM_prices_frame", -- models/free-market.can:1379
				["direction"] = "vertical" -- models/free-market.can:1379
			}) -- models/free-market.can:1379
			local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1380
			prices_flow["add"]({ -- models/free-market.can:1381
				["type"] = "table", -- models/free-market.can:1381
				["name"] = "FM_prices_table", -- models/free-market.can:1381
				["style"] = "FM_prices_table", -- models/free-market.can:1381
				["column_count"] = column_count -- models/free-market.can:1381
			}) -- models/free-market.can:1381
			local cost = 0 -- models/free-market.can:1383
			for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:1384
				cost = cost + 1 -- models/free-market.can:1385
				add_item_in_sell_prices(player, item_name, cost, player["index"]) -- models/free-market.can:1386
			end -- models/free-market.can:1386
		end -- models/free-market.can:1386
	else -- models/free-market.can:1386
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:1391
		local is_vertical = (column_count == 2) -- models/free-market.can:1392
		if is_vertical then -- models/free-market.can:1393
			direction = "vertical" -- models/free-market.can:1394
		else -- models/free-market.can:1394
			direction = "horizontal" -- models/free-market.can:1396
		end -- models/free-market.can:1396
		main_frame = screen["add"]({ -- models/free-market.can:1398
			["type"] = "frame", -- models/free-market.can:1398
			["name"] = "FM_sell_prices_frame", -- models/free-market.can:1398
			["style"] = "borderless_frame", -- models/free-market.can:1398
			["direction"] = direction -- models/free-market.can:1398
		}) -- models/free-market.can:1398
		main_frame["location"] = location or { -- models/free-market.can:1399
			["x"] = player["display_resolution"]["width"] - 752, -- models/free-market.can:1399
			["y"] = 272 -- models/free-market.can:1399
		} -- models/free-market.can:1399
		create_price_notification_handler(main_frame, "FM_switch_sell_prices_gui", is_vertical) -- models/free-market.can:1400
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1401
			["type"] = "frame", -- models/free-market.can:1401
			["name"] = "FM_prices_flow", -- models/free-market.can:1401
			["style"] = "FM_prices_frame", -- models/free-market.can:1401
			["direction"] = "vertical" -- models/free-market.can:1401
		}) -- models/free-market.can:1401
		prices_flow["add"]({ -- models/free-market.can:1402
			["type"] = "table", -- models/free-market.can:1402
			["name"] = "FM_prices_table", -- models/free-market.can:1402
			["style"] = "FM_prices_table", -- models/free-market.can:1402
			["column_count"] = column_count -- models/free-market.can:1402
		}) -- models/free-market.can:1402
	end -- models/free-market.can:1402
end -- models/free-market.can:1402
local function switch_buy_prices_gui(player, location) -- models/free-market.can:1408
	local screen = player["gui"]["screen"] -- models/free-market.can:1409
	local main_frame = screen["FM_buy_prices_frame"] -- models/free-market.can:1410
	if main_frame then -- models/free-market.can:1411
		local children = main_frame["children"] -- models/free-market.can:1412
		if # children > 1 then -- models/free-market.can:1413
			children[2]["destroy"]() -- models/free-market.can:1414
			return  -- models/free-market.can:1415
		else -- models/free-market.can:1415
			local prices_flow = main_frame["add"]({ -- models/free-market.can:1417
				["type"] = "frame", -- models/free-market.can:1417
				["name"] = "FM_prices_flow", -- models/free-market.can:1417
				["style"] = "FM_prices_frame", -- models/free-market.can:1417
				["direction"] = "vertical" -- models/free-market.can:1417
			}) -- models/free-market.can:1417
			local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1418
			prices_flow["add"]({ -- models/free-market.can:1419
				["type"] = "table", -- models/free-market.can:1419
				["name"] = "FM_prices_table", -- models/free-market.can:1419
				["style"] = "FM_prices_table", -- models/free-market.can:1419
				["column_count"] = column_count -- models/free-market.can:1419
			}) -- models/free-market.can:1419
			local cost = 0 -- models/free-market.can:1421
			for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:1422
				cost = cost + 1 -- models/free-market.can:1423
				add_item_in_buy_prices(player, item_name, cost, player["index"]) -- models/free-market.can:1424
			end -- models/free-market.can:1424
		end -- models/free-market.can:1424
	else -- models/free-market.can:1424
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:1429
		local is_vertical = (column_count == 2) -- models/free-market.can:1430
		if is_vertical then -- models/free-market.can:1431
			direction = "vertical" -- models/free-market.can:1432
		else -- models/free-market.can:1432
			direction = "horizontal" -- models/free-market.can:1434
		end -- models/free-market.can:1434
		main_frame = screen["add"]({ -- models/free-market.can:1436
			["type"] = "frame", -- models/free-market.can:1436
			["name"] = "FM_buy_prices_frame", -- models/free-market.can:1436
			["style"] = "borderless_frame", -- models/free-market.can:1436
			["direction"] = direction -- models/free-market.can:1436
		}) -- models/free-market.can:1436
		main_frame["location"] = location or { -- models/free-market.can:1437
			["x"] = player["display_resolution"]["width"] - 712, -- models/free-market.can:1437
			["y"] = 272 -- models/free-market.can:1437
		} -- models/free-market.can:1437
		create_price_notification_handler(main_frame, "FM_switch_buy_prices_gui", is_vertical) -- models/free-market.can:1438
		local prices_flow = main_frame["add"]({ -- models/free-market.can:1439
			["type"] = "frame", -- models/free-market.can:1439
			["name"] = "FM_prices_flow", -- models/free-market.can:1439
			["style"] = "FM_prices_frame", -- models/free-market.can:1439
			["direction"] = "vertical" -- models/free-market.can:1439
		}) -- models/free-market.can:1439
		prices_flow["add"]({ -- models/free-market.can:1440
			["type"] = "table", -- models/free-market.can:1440
			["name"] = "FM_prices_table", -- models/free-market.can:1440
			["style"] = "FM_prices_table", -- models/free-market.can:1440
			["column_count"] = column_count -- models/free-market.can:1440
		}) -- models/free-market.can:1440
	end -- models/free-market.can:1440
end -- models/free-market.can:1440
local function open_embargo_gui(player) -- models/free-market.can:1445
	local screen = player["gui"]["screen"] -- models/free-market.can:1446
	if screen["FM_embargo_frame"] then -- models/free-market.can:1447
		screen["FM_embargo_frame"]["destroy"]() -- models/free-market.can:1448
		return  -- models/free-market.can:1449
	end -- models/free-market.can:1449
	local main_frame = screen["add"]({ -- models/free-market.can:1451
		["type"] = "frame", -- models/free-market.can:1451
		["name"] = "FM_embargo_frame", -- models/free-market.can:1451
		["direction"] = "vertical" -- models/free-market.can:1451
	}) -- models/free-market.can:1451
	main_frame["style"]["minimal_width"] = 340 -- models/free-market.can:1452
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1453
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1454
	flow["add"]({ -- models/free-market.can:1455
		["type"] = "label", -- models/free-market.can:1456
		["style"] = "frame_title", -- models/free-market.can:1457
		["caption"] = { "free-market.embargo-gui" }, -- models/free-market.can:1458
		["ignored_by_interaction"] = true -- models/free-market.can:1459
	}) -- models/free-market.can:1459
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1461
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1462
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1464
		["type"] = "frame", -- models/free-market.can:1464
		["name"] = "shallow_frame", -- models/free-market.can:1464
		["style"] = "inside_shallow_frame" -- models/free-market.can:1464
	}) -- models/free-market.can:1464
	local embargo_table = shallow_frame["add"]({ -- models/free-market.can:1465
		["type"] = "table", -- models/free-market.can:1465
		["name"] = "embargo_table", -- models/free-market.can:1465
		["column_count"] = 3 -- models/free-market.can:1465
	}) -- models/free-market.can:1465
	embargo_table["style"]["horizontally_stretchable"] = true -- models/free-market.can:1466
	embargo_table["style"]["vertically_stretchable"] = true -- models/free-market.can:1467
	embargo_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1468
	embargo_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1469
	embargo_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1470
	update_embargo_table(embargo_table, player) -- models/free-market.can:1472
	main_frame["force_auto_center"]() -- models/free-market.can:1473
end -- models/free-market.can:1473
local function set_transfer_box_data(item_name, player, entity) -- models/free-market.can:1479
	local player_force = player["force"] -- models/free-market.can:1480
	local force_index = player_force["index"] -- models/free-market.can:1481
	local f_transfer_boxes = transfer_boxes[force_index] -- models/free-market.can:1482
	if f_transfer_boxes[item_name] == nil then -- models/free-market.can:1483
		local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:1484
		local inactive_sell_price = f_inactive_sell_prices[item_name] -- models/free-market.can:1485
		if inactive_sell_price then -- models/free-market.can:1486
			sell_prices[force_index][item_name] = inactive_sell_price -- models/free-market.can:1487
			f_inactive_sell_prices[item_name] = nil -- models/free-market.can:1488
			notify_sell_price(force_index, item_name, inactive_sell_price) -- models/free-market.can:1489
		end -- models/free-market.can:1489
		f_transfer_boxes[item_name] = {} -- models/free-market.can:1491
	end -- models/free-market.can:1491
	local entities = f_transfer_boxes[item_name] -- models/free-market.can:1493
	entities[# entities + 1] = entity -- models/free-market.can:1494
	local sprite_data = { -- models/free-market.can:1495
		["sprite"] = "FM_transfer", -- models/free-market.can:1496
		["target"] = entity, -- models/free-market.can:1497
		["surface"] = entity["surface"], -- models/free-market.can:1498
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1499
		["only_in_alt_mode"] = true, -- models/free-market.can:1500
		["x_scale"] = 0.4, -- models/free-market.can:1501
		["y_scale"] = 0.4 -- models/free-market.can:1501
	} -- models/free-market.can:1501
	if is_public_titles == false then -- models/free-market.can:1503
		sprite_data["forces"] = { player_force } -- models/free-market.can:1504
	end -- models/free-market.can:1504
	local id = draw_sprite(sprite_data) -- models/free-market.can:1507
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1508
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1510
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1513
		entity, -- models/free-market.can:1513
		id, -- models/free-market.can:1513
		4, -- models/free-market.can:1
		entities, -- models/free-market.can:1513
		item_name -- models/free-market.can:1513
	} -- models/free-market.can:1513
end -- models/free-market.can:1513
local function set_universal_transfer_box_data(player, entity) -- models/free-market.can:1518
	local player_force = player["force"] -- models/free-market.can:1519
	local force_index = player_force["index"] -- models/free-market.can:1520
	local entities = universal_transfer_boxes[force_index] -- models/free-market.can:1521
	entities[# entities + 1] = entity -- models/free-market.can:1522
	local sprite_data = { -- models/free-market.can:1523
		["sprite"] = "FM_universal_transfer", -- models/free-market.can:1524
		["target"] = entity, -- models/free-market.can:1525
		["surface"] = entity["surface"], -- models/free-market.can:1526
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1527
		["only_in_alt_mode"] = true, -- models/free-market.can:1528
		["x_scale"] = 0.4, -- models/free-market.can:1529
		["y_scale"] = 0.4 -- models/free-market.can:1529
	} -- models/free-market.can:1529
	if is_public_titles == false then -- models/free-market.can:1531
		sprite_data["forces"] = { player_force } -- models/free-market.can:1532
	end -- models/free-market.can:1532
	local id = draw_sprite(sprite_data) -- models/free-market.can:1535
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1538
		entity, -- models/free-market.can:1538
		id, -- models/free-market.can:1538
		5, -- models/free-market.can:1
		entities, -- models/free-market.can:1538
		nil -- models/free-market.can:1538
	} -- models/free-market.can:1538
end -- models/free-market.can:1538
local function set_bin_box_data(item_name, player, entity) -- models/free-market.can:1544
	local player_force = player["force"] -- models/free-market.can:1545
	local force_index = player_force["index"] -- models/free-market.can:1546
	local f_bin_boxes = bin_boxes[force_index] -- models/free-market.can:1547
	if f_bin_boxes[item_name] == nil then -- models/free-market.can:1548
		f_bin_boxes[item_name] = {} -- models/free-market.can:1549
	end -- models/free-market.can:1549
	local entities = f_bin_boxes[item_name] -- models/free-market.can:1551
	entities[# entities + 1] = entity -- models/free-market.can:1552
	local sprite_data = { -- models/free-market.can:1553
		["sprite"] = "FM_bin", -- models/free-market.can:1554
		["target"] = entity, -- models/free-market.can:1555
		["surface"] = entity["surface"], -- models/free-market.can:1556
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1557
		["only_in_alt_mode"] = true, -- models/free-market.can:1558
		["x_scale"] = 0.4, -- models/free-market.can:1559
		["y_scale"] = 0.4 -- models/free-market.can:1559
	} -- models/free-market.can:1559
	if is_public_titles == false then -- models/free-market.can:1561
		sprite_data["forces"] = { player_force } -- models/free-market.can:1562
	end -- models/free-market.can:1562
	local id = draw_sprite(sprite_data) -- models/free-market.can:1565
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1566
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1569
		entity, -- models/free-market.can:1569
		id, -- models/free-market.can:1569
		6, -- models/free-market.can:1
		entities, -- models/free-market.can:1569
		item_name -- models/free-market.can:1569
	} -- models/free-market.can:1569
end -- models/free-market.can:1569
local function set_universal_bin_box_data(player, entity) -- models/free-market.can:1574
	local player_force = player["force"] -- models/free-market.can:1575
	local force_index = player_force["index"] -- models/free-market.can:1576
	local entities = universal_bin_boxes[force_index] -- models/free-market.can:1577
	entities[# entities + 1] = entity -- models/free-market.can:1578
	local sprite_data = { -- models/free-market.can:1579
		["sprite"] = "FM_universal_bin", -- models/free-market.can:1580
		["target"] = entity, -- models/free-market.can:1581
		["surface"] = entity["surface"], -- models/free-market.can:1582
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1583
		["only_in_alt_mode"] = true, -- models/free-market.can:1584
		["x_scale"] = 0.4, -- models/free-market.can:1585
		["y_scale"] = 0.4 -- models/free-market.can:1585
	} -- models/free-market.can:1585
	if is_public_titles == false then -- models/free-market.can:1587
		sprite_data["forces"] = { player_force } -- models/free-market.can:1588
	end -- models/free-market.can:1588
	local id = draw_sprite(sprite_data) -- models/free-market.can:1591
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1594
		entity, -- models/free-market.can:1594
		id, -- models/free-market.can:1594
		7, -- models/free-market.can:1
		entities, -- models/free-market.can:1594
		nil -- models/free-market.can:1594
	} -- models/free-market.can:1594
end -- models/free-market.can:1594
local function set_pull_box_data(item_name, player, entity) -- models/free-market.can:1600
	local player_force = player["force"] -- models/free-market.can:1601
	local force_index = player_force["index"] -- models/free-market.can:1602
	local force_pull_boxes = pull_boxes[force_index] -- models/free-market.can:1603
	force_pull_boxes[item_name] = force_pull_boxes[item_name] or {} -- models/free-market.can:1604
	local items = force_pull_boxes[item_name] -- models/free-market.can:1605
	items[# items + 1] = entity -- models/free-market.can:1606
	local sprite_data = { -- models/free-market.can:1607
		["sprite"] = "FM_pull_out", -- models/free-market.can:1608
		["target"] = entity, -- models/free-market.can:1609
		["surface"] = entity["surface"], -- models/free-market.can:1610
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1611
		["only_in_alt_mode"] = true, -- models/free-market.can:1612
		["x_scale"] = 0.4, -- models/free-market.can:1613
		["y_scale"] = 0.4 -- models/free-market.can:1613
	} -- models/free-market.can:1613
	if is_public_titles == false then -- models/free-market.can:1615
		sprite_data["forces"] = { player_force } -- models/free-market.can:1616
	end -- models/free-market.can:1616
	local id = draw_sprite(sprite_data) -- models/free-market.can:1619
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1620
	entity["get_inventory"](1)["set_bar"](2) -- models/free-market.can:1622
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1625
		entity, -- models/free-market.can:1625
		id, -- models/free-market.can:1625
		3, -- models/free-market.can:1
		items, -- models/free-market.can:1625
		item_name -- models/free-market.can:1625
	} -- models/free-market.can:1625
end -- models/free-market.can:1625
local function set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:1632
	count = count or game["item_prototypes"][item_name]["stack_size"] -- models/free-market.can:1633
	local player_force = player["force"] -- models/free-market.can:1635
	local force_index = player_force["index"] -- models/free-market.can:1636
	local f_buy_boxes = buy_boxes[force_index] -- models/free-market.can:1637
	if f_buy_boxes[item_name] == nil then -- models/free-market.can:1638
		local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:1639
		local inactive_buy_price = f_inactive_buy_prices[item_name] -- models/free-market.can:1640
		if inactive_buy_price then -- models/free-market.can:1641
			buy_prices[force_index][item_name] = inactive_buy_price -- models/free-market.can:1642
			f_inactive_buy_prices[item_name] = nil -- models/free-market.can:1643
			notify_buy_price(force_index, item_name, inactive_buy_price) -- models/free-market.can:1644
		end -- models/free-market.can:1644
		f_buy_boxes[item_name] = {} -- models/free-market.can:1646
	end -- models/free-market.can:1646
	local items = f_buy_boxes[item_name] -- models/free-market.can:1648
	items[# items + 1] = { -- models/free-market.can:1649
		entity, -- models/free-market.can:1649
		count -- models/free-market.can:1649
	} -- models/free-market.can:1649
	local sprite_data = { -- models/free-market.can:1650
		["sprite"] = "FM_buy", -- models/free-market.can:1651
		["target"] = entity, -- models/free-market.can:1652
		["surface"] = entity["surface"], -- models/free-market.can:1653
		["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:1654
		["only_in_alt_mode"] = true, -- models/free-market.can:1655
		["x_scale"] = 0.4, -- models/free-market.can:1656
		["y_scale"] = 0.4 -- models/free-market.can:1656
	} -- models/free-market.can:1656
	if is_public_titles == false then -- models/free-market.can:1658
		sprite_data["forces"] = { player_force } -- models/free-market.can:1659
	end -- models/free-market.can:1659
	local id = draw_sprite(sprite_data) -- models/free-market.can:1662
	show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:1663
	all_boxes[entity["unit_number"]] = { -- models/free-market.can:1666
		entity, -- models/free-market.can:1666
		id, -- models/free-market.can:1666
		1, -- models/free-market.can:1
		items, -- models/free-market.can:1666
		item_name -- models/free-market.can:1666
	} -- models/free-market.can:1666
end -- models/free-market.can:1666
local function destroy_force_configuration(player) -- models/free-market.can:1670
	local frame = player["gui"]["screen"]["FM_force_configuration"] -- models/free-market.can:1671
	if frame then -- models/free-market.can:1672
		frame["destroy"]() -- models/free-market.can:1673
	end -- models/free-market.can:1673
end -- models/free-market.can:1673
local function open_force_configuration(player) -- models/free-market.can:1678
	local screen = player["gui"]["screen"] -- models/free-market.can:1679
	if screen["FM_force_configuration"] then -- models/free-market.can:1680
		screen["FM_force_configuration"]["destroy"]() -- models/free-market.can:1681
		return  -- models/free-market.can:1682
	end -- models/free-market.can:1682
	local is_player_admin = player["admin"] -- models/free-market.can:1685
	local force = player["force"] -- models/free-market.can:1686
	local main_frame = screen["add"]({ -- models/free-market.can:1688
		["type"] = "frame", -- models/free-market.can:1688
		["name"] = "FM_force_configuration", -- models/free-market.can:1688
		["direction"] = "vertical" -- models/free-market.can:1688
	}) -- models/free-market.can:1688
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1689
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1690
	flow["add"]({ -- models/free-market.can:1691
		["type"] = "label", -- models/free-market.can:1692
		["style"] = "frame_title", -- models/free-market.can:1693
		["caption"] = { "free-market.team-configuration" }, -- models/free-market.can:1694
		["ignored_by_interaction"] = true -- models/free-market.can:1695
	}) -- models/free-market.can:1695
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1697
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1698
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1699
		["type"] = "frame", -- models/free-market.can:1699
		["name"] = "shallow_frame", -- models/free-market.can:1699
		["style"] = "inside_shallow_frame", -- models/free-market.can:1699
		["direction"] = "vertical" -- models/free-market.can:1699
	}) -- models/free-market.can:1699
	local content = shallow_frame["add"]({ -- models/free-market.can:1700
		["type"] = "flow", -- models/free-market.can:1700
		["name"] = "content_flow", -- models/free-market.can:1700
		["direction"] = "vertical" -- models/free-market.can:1700
	}) -- models/free-market.can:1700
	content["style"]["padding"] = 12 -- models/free-market.can:1701
	if is_player_admin then -- models/free-market.can:1703
		local admin_row = content["add"](FLOW) -- models/free-market.can:1704
		admin_row["name"] = "admin_row" -- models/free-market.can:1705
		admin_row["add"](LABEL)["caption"] = { -- models/free-market.can:1706
			"", -- models/free-market.can:1706
			{ "gui-multiplayer-lobby.allow-commands-admins-only" }, -- models/free-market.can:1706
			COLON -- models/free-market.can:1706
		} -- models/free-market.can:1706
		admin_row["add"]({ -- models/free-market.can:1707
			["type"] = "button", -- models/free-market.can:1707
			["caption"] = { "free-market.print-force-data-button" }, -- models/free-market.can:1707
			["name"] = "FM_print_force_data" -- models/free-market.can:1707
		}) -- models/free-market.can:1707
		admin_row["add"]({ -- models/free-market.can:1708
			["type"] = "button", -- models/free-market.can:1708
			["caption"] = "Clear invalid data", -- models/free-market.can:1708
			["name"] = "FM_clear_invalid_data" -- models/free-market.can:1708
		}) -- models/free-market.can:1708
	end -- models/free-market.can:1708
	if is_reset_public or is_player_admin or # force["players"] == 1 then -- models/free-market.can:1711
		if is_player_admin then -- models/free-market.can:1712
			content["add"](LABEL)["caption"] = { -- models/free-market.can:1713
				"", -- models/free-market.can:1713
				"Attention", -- models/free-market.can:1713
				COLON, -- models/free-market.can:1713
				"reset is public" -- models/free-market.can:1713
			} -- models/free-market.can:1713
		end -- models/free-market.can:1713
		local reset_caption = { -- models/free-market.can:1715
			"", -- models/free-market.can:1715
			{ "free-market.reset-gui" }, -- models/free-market.can:1715
			COLON -- models/free-market.can:1715
		} -- models/free-market.can:1715
		local reset_prices_row = content["add"](FLOW) -- models/free-market.can:1716
		reset_prices_row["name"] = "reset_prices_row" -- models/free-market.can:1717
		reset_prices_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1718
		reset_prices_row["add"]({ -- models/free-market.can:1719
			["type"] = "button", -- models/free-market.can:1719
			["caption"] = { "free-market.reset-buy-prices" }, -- models/free-market.can:1719
			["name"] = "FM_reset_buy_prices" -- models/free-market.can:1719
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1719
		reset_prices_row["add"]({ -- models/free-market.can:1720
			["type"] = "button", -- models/free-market.can:1720
			["caption"] = { "free-market.reset-sell-prices" }, -- models/free-market.can:1720
			["name"] = "FM_reset_sell_prices" -- models/free-market.can:1720
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1720
		reset_prices_row["add"]({ -- models/free-market.can:1721
			["type"] = "button", -- models/free-market.can:1721
			["caption"] = { "free-market.reset-all-prices" }, -- models/free-market.can:1721
			["name"] = "FM_reset_all_prices" -- models/free-market.can:1721
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1721
		local reset_boxes_row = content["add"](FLOW) -- models/free-market.can:1723
		reset_boxes_row["name"] = "reset_boxes_row" -- models/free-market.can:1724
		reset_boxes_row["add"](LABEL)["caption"] = reset_caption -- models/free-market.can:1725
		reset_boxes_row["add"]({ -- models/free-market.can:1726
			["type"] = "button", -- models/free-market.can:1726
			["style"] = "FM_transfer_button", -- models/free-market.can:1726
			["name"] = "FM_reset_transfer_boxes" -- models/free-market.can:1726
		}) -- models/free-market.can:1726
		reset_boxes_row["add"]({ -- models/free-market.can:1727
			["type"] = "button", -- models/free-market.can:1727
			["style"] = "FM_universal_transfer_button", -- models/free-market.can:1727
			["name"] = "FM_reset_universal_transfer_boxes" -- models/free-market.can:1727
		}) -- models/free-market.can:1727
		reset_boxes_row["add"]({ -- models/free-market.can:1728
			["type"] = "button", -- models/free-market.can:1728
			["style"] = "FM_bin_button", -- models/free-market.can:1728
			["name"] = "FM_reset_bin_boxes" -- models/free-market.can:1728
		}) -- models/free-market.can:1728
		reset_boxes_row["add"]({ -- models/free-market.can:1729
			["type"] = "button", -- models/free-market.can:1729
			["style"] = "FM_universal_bin_button", -- models/free-market.can:1729
			["name"] = "FM_reset_universal_bin_boxes" -- models/free-market.can:1729
		}) -- models/free-market.can:1729
		reset_boxes_row["add"]({ -- models/free-market.can:1730
			["type"] = "button", -- models/free-market.can:1730
			["style"] = "FM_pull_out_button", -- models/free-market.can:1730
			["name"] = "FM_reset_pull_boxes" -- models/free-market.can:1730
		}) -- models/free-market.can:1730
		reset_boxes_row["add"]({ -- models/free-market.can:1731
			["type"] = "button", -- models/free-market.can:1731
			["style"] = "FM_buy_button", -- models/free-market.can:1731
			["name"] = "FM_reset_buy_boxes" -- models/free-market.can:1731
		}) -- models/free-market.can:1731
		reset_boxes_row["add"]({ -- models/free-market.can:1732
			["type"] = "button", -- models/free-market.can:1732
			["caption"] = { "free-market.reset-all-types" }, -- models/free-market.can:1732
			["name"] = "FM_reset_all_boxes" -- models/free-market.can:1732
		})["style"]["minimal_width"] = 10 -- models/free-market.can:1732
	end -- models/free-market.can:1732
	local setting_row = content["add"](FLOW) -- models/free-market.can:1735
	setting_row["style"]["vertical_align"] = "center" -- models/free-market.can:1736
	setting_row["add"](LABEL)["caption"] = { -- models/free-market.can:1737
		"", -- models/free-market.can:1737
		{ "free-market.default-storage-limit" }, -- models/free-market.can:1737
		COLON -- models/free-market.can:1737
	} -- models/free-market.can:1737
	local default_limit_textfield = setting_row["add"](DEFAULT_LIMIT_TEXTFIELD) -- models/free-market.can:1738
	local default_limit = default_storage_limit[force["index"]] or max_storage_threshold -- models/free-market.can:1739
	default_limit_textfield["text"] = tostring(default_limit) -- models/free-market.can:1740
	setting_row["add"](CHECK_BUTTON)["name"] = "FM_confirm_default_limit" -- models/free-market.can:1741
	local label = content["add"](LABEL) -- models/free-market.can:1743
	label["caption"] = { -- models/free-market.can:1744
		"", -- models/free-market.can:1744
		{ "gui.credits" }, -- models/free-market.can:1744
		COLON -- models/free-market.can:1744
	} -- models/free-market.can:1744
	label["style"]["font"] = "heading-1" -- models/free-market.can:1745
	local translations_row = content["add"](FLOW) -- models/free-market.can:1746
	translations_row["add"](LABEL)["caption"] = { -- models/free-market.can:1747
		"", -- models/free-market.can:1747
		"Translations", -- models/free-market.can:1747
		COLON -- models/free-market.can:1747
	} -- models/free-market.can:1747
	local link = translations_row["add"]({ -- models/free-market.can:1748
		["type"] = "textfield", -- models/free-market.can:1748
		["text"] = "https://crowdin.com/project/factorio-mods-localization" -- models/free-market.can:1748
	}) -- models/free-market.can:1748
	link["style"]["horizontally_stretchable"] = true -- models/free-market.can:1749
	link["style"]["width"] = 320 -- models/free-market.can:1750
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1751
		"", -- models/free-market.can:1751
		"Translators", -- models/free-market.can:1751
		COLON, -- models/free-market.can:1751
		" ", -- models/free-market.can:1751
		"Eerrikki (Robin Braathen), eifel (Eifel87), zszzlzm (刘泽民), Spielen01231 (TheFakescribtx2), Drilzxx_ (Kévin), eifel (Eifel87), Felix_Manning (Felix Manning), ZwerOxotnik" -- models/free-market.can:1751
	} -- models/free-market.can:1751
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1752
		"", -- models/free-market.can:1752
		"Supporters", -- models/free-market.can:1752
		COLON, -- models/free-market.can:1752
		" ", -- models/free-market.can:1752
		"Eerrikki" -- models/free-market.can:1752
	} -- models/free-market.can:1752
	content["add"](LABEL)["caption"] = { -- models/free-market.can:1753
		"", -- models/free-market.can:1753
		{ "gui-other-settings.developer" }, -- models/free-market.can:1753
		COLON, -- models/free-market.can:1753
		" ", -- models/free-market.can:1753
		"ZwerOxotnik" -- models/free-market.can:1753
	} -- models/free-market.can:1753
	local text_box = content["add"]({ ["type"] = "text-box" }) -- models/free-market.can:1754
	text_box["read_only"] = true -- models/free-market.can:1755
	text_box["text"] = "see-prices.png from https://www.svgrepo.com/svg/77065/price-tag\
" .. "change-price.png from https://www.svgrepo.com/svg/96982/price-tag\
" .. "embargo.png is modified version of https://www.svgrepo.com/svg/97012/price-tag" .. "Modified versions of https://www.svgrepo.com/svg/11042/shopping-cart-with-down-arrow-e-commerce-symbol" .. "Modified versions of https://www.svgrepo.com/svg/89258/rubbish-bin" -- models/free-market.can:1760
	text_box["style"]["maximal_width"] = 0 -- models/free-market.can:1761
	text_box["style"]["height"] = 70 -- models/free-market.can:1762
	text_box["style"]["horizontally_stretchable"] = true -- models/free-market.can:1763
	text_box["style"]["vertically_stretchable"] = true -- models/free-market.can:1764
	main_frame["force_auto_center"]() -- models/free-market.can:1766
end -- models/free-market.can:1766
local function switch_prices_gui(player, item_name) -- models/free-market.can:1771
	local screen = player["gui"]["screen"] -- models/free-market.can:1772
	local main_frame = screen["FM_prices_frame"] -- models/free-market.can:1773
	if main_frame then -- models/free-market.can:1774
		if item_name == nil then -- models/free-market.can:1775
			main_frame["destroy"]() -- models/free-market.can:1776
		else -- models/free-market.can:1776
			local content_flow = main_frame["shallow_frame"]["content_flow"] -- models/free-market.can:1778
			local item_row = main_frame["shallow_frame"]["content_flow"]["item_row"] -- models/free-market.can:1779
			item_row["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:1780
			local force_index = player["force"]["index"] -- models/free-market.can:1782
			local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1783
			if sell_price then -- models/free-market.can:1784
				item_row["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:1785
			end -- models/free-market.can:1785
			local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1787
			if buy_price then -- models/free-market.can:1788
				item_row["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:1789
			end -- models/free-market.can:1789
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:1791
		end -- models/free-market.can:1791
		return  -- models/free-market.can:1793
	end -- models/free-market.can:1793
	local force_index = player["force"]["index"] -- models/free-market.can:1796
	main_frame = screen["add"]({ -- models/free-market.can:1798
		["type"] = "frame", -- models/free-market.can:1798
		["name"] = "FM_prices_frame", -- models/free-market.can:1798
		["direction"] = "vertical" -- models/free-market.can:1798
	}) -- models/free-market.can:1798
	main_frame["location"] = { -- models/free-market.can:1799
		["x"] = 100 / player["display_scale"], -- models/free-market.can:1799
		["y"] = 50 -- models/free-market.can:1799
	} -- models/free-market.can:1799
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1800
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1801
	flow["add"]({ -- models/free-market.can:1802
		["type"] = "label", -- models/free-market.can:1803
		["style"] = "frame_title", -- models/free-market.can:1804
		["caption"] = { "free-market.prices" }, -- models/free-market.can:1805
		["ignored_by_interaction"] = true -- models/free-market.can:1806
	}) -- models/free-market.can:1806
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1808
	flow["add"]({ -- models/free-market.can:1809
		["type"] = "sprite-button", -- models/free-market.can:1810
		["style"] = "frame_action_button", -- models/free-market.can:1811
		["sprite"] = "refresh_white_icon", -- models/free-market.can:1812
		["name"] = "FM_refresh_prices_table" -- models/free-market.can:1813
	}) -- models/free-market.can:1813
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1815
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1816
		["type"] = "frame", -- models/free-market.can:1816
		["name"] = "shallow_frame", -- models/free-market.can:1816
		["style"] = "inside_shallow_frame", -- models/free-market.can:1816
		["direction"] = "vertical" -- models/free-market.can:1816
	}) -- models/free-market.can:1816
	local content = shallow_frame["add"]({ -- models/free-market.can:1817
		["type"] = "flow", -- models/free-market.can:1817
		["name"] = "content_flow", -- models/free-market.can:1817
		["direction"] = "vertical" -- models/free-market.can:1817
	}) -- models/free-market.can:1817
	content["style"]["padding"] = 12 -- models/free-market.can:1818
	local item_row = content["add"](FLOW) -- models/free-market.can:1820
	local add = item_row["add"] -- models/free-market.can:1821
	item_row["name"] = "item_row" -- models/free-market.can:1822
	item_row["style"]["vertical_align"] = "center" -- models/free-market.can:1823
	local item = add({ -- models/free-market.can:1824
		["type"] = "choose-elem-button", -- models/free-market.can:1824
		["name"] = "FM_prices_item", -- models/free-market.can:1824
		["elem_type"] = "item", -- models/free-market.can:1824
		["elem_filters"] = ITEM_FILTERS -- models/free-market.can:1824
	}) -- models/free-market.can:1824
	item["elem_value"] = item_name -- models/free-market.can:1825
	add(LABEL)["caption"] = { "free-market.buy-gui" } -- models/free-market.can:1826
	local buy_textfield = add(BUY_PRICE_TEXTFIELD) -- models/free-market.can:1827
	if item_name then -- models/free-market.can:1828
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:1829
		if price then -- models/free-market.can:1830
			buy_textfield["text"] = tostring(price) -- models/free-market.can:1831
		end -- models/free-market.can:1831
	end -- models/free-market.can:1831
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price" -- models/free-market.can:1834
	add(LABEL)["caption"] = { "free-market.sell-gui" } -- models/free-market.can:1835
	local sell_textfield = add(SELL_PRICE_TEXTFIELD) -- models/free-market.can:1836
	if item_name then -- models/free-market.can:1837
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:1838
		if price then -- models/free-market.can:1839
			sell_textfield["text"] = tostring(price) -- models/free-market.can:1840
		end -- models/free-market.can:1840
	end -- models/free-market.can:1840
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price" -- models/free-market.can:1843
	local storage_row = content["add"](FLOW) -- models/free-market.can:1845
	local add = storage_row["add"] -- models/free-market.can:1846
	storage_row["name"] = "storage_row" -- models/free-market.can:1847
	storage_row["style"]["vertical_align"] = "center" -- models/free-market.can:1848
	add(LABEL)["caption"] = { -- models/free-market.can:1849
		"", -- models/free-market.can:1849
		{ "description.storage" }, -- models/free-market.can:1849
		COLON -- models/free-market.can:1849
	} -- models/free-market.can:1849
	local storage_count = add(LABEL) -- models/free-market.can:1850
	storage_count["name"] = "storage_count" -- models/free-market.can:1851
	add(LABEL)["caption"] = "/" -- models/free-market.can:1852
	local storage_limit_textfield = add(STORAGE_LIMIT_TEXTFIELD) -- models/free-market.can:1853
	add(CHECK_BUTTON)["name"] = "FM_confirm_storage_limit" -- models/free-market.can:1854
	if item_name == nil then -- models/free-market.can:1855
		storage_row["visible"] = false -- models/free-market.can:1856
	else -- models/free-market.can:1856
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:1858
		storage_count["caption"] = tostring(count) -- models/free-market.can:1859
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:1860
		storage_limit_textfield["text"] = tostring(limit) -- models/free-market.can:1861
	end -- models/free-market.can:1861
	local prices_frame = content["add"]({ -- models/free-market.can:1864
		["type"] = "frame", -- models/free-market.can:1864
		["name"] = "other_prices_frame", -- models/free-market.can:1864
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1864
		["direction"] = "vertical" -- models/free-market.can:1864
	}) -- models/free-market.can:1864
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1865
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1866
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1867
		["type"] = "table", -- models/free-market.can:1867
		["name"] = "prices_table", -- models/free-market.can:1867
		["column_count"] = 3 -- models/free-market.can:1867
	}) -- models/free-market.can:1867
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1868
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1869
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:1870
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1871
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1872
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1873
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:1874
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:1875
	if item_name then -- models/free-market.can:1876
		update_prices_table(player, item_name, prices_table) -- models/free-market.can:1877
	else -- models/free-market.can:1877
		make_prices_header(prices_table) -- models/free-market.can:1879
	end -- models/free-market.can:1879
	return content -- models/free-market.can:1882
end -- models/free-market.can:1882
local function open_storage_gui(player) -- models/free-market.can:1885
	local screen = player["gui"]["screen"] -- models/free-market.can:1886
	local main_frame = screen["FM_storage_frame"] -- models/free-market.can:1887
	if main_frame then -- models/free-market.can:1888
		main_frame["destroy"]() -- models/free-market.can:1889
		return  -- models/free-market.can:1890
	end -- models/free-market.can:1890
	main_frame = screen["add"]({ -- models/free-market.can:1893
		["type"] = "frame", -- models/free-market.can:1893
		["name"] = "FM_storage_frame", -- models/free-market.can:1893
		["direction"] = "vertical" -- models/free-market.can:1893
	}) -- models/free-market.can:1893
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1894
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1895
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1896
	flow["add"]({ -- models/free-market.can:1897
		["type"] = "label", -- models/free-market.can:1898
		["style"] = "frame_title", -- models/free-market.can:1899
		["caption"] = { "description.storage" }, -- models/free-market.can:1900
		["ignored_by_interaction"] = true -- models/free-market.can:1901
	}) -- models/free-market.can:1901
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1903
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1904
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1905
		["type"] = "frame", -- models/free-market.can:1905
		["name"] = "shallow_frame", -- models/free-market.can:1905
		["style"] = "inside_shallow_frame", -- models/free-market.can:1905
		["direction"] = "vertical" -- models/free-market.can:1905
	}) -- models/free-market.can:1905
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1906
		["type"] = "flow", -- models/free-market.can:1906
		["name"] = "content_flow", -- models/free-market.can:1906
		["direction"] = "vertical" -- models/free-market.can:1906
	}) -- models/free-market.can:1906
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1907
	local scroll_pane = content_flow["add"](SCROLL_PANE) -- models/free-market.can:1909
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1910
	local storage_table = scroll_pane["add"]({ -- models/free-market.can:1911
		["type"] = "table", -- models/free-market.can:1911
		["name"] = "FM_storage_table", -- models/free-market.can:1911
		["column_count"] = 2 -- models/free-market.can:1911
	}) -- models/free-market.can:1911
	storage_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1912
	storage_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1913
	storage_table["style"]["top_margin"] = - 16 -- models/free-market.can:1914
	storage_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1915
	storage_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1916
	storage_table["draw_horizontal_lines"] = true -- models/free-market.can:1917
	storage_table["draw_vertical_lines"] = true -- models/free-market.can:1918
	make_storage_header(storage_table) -- models/free-market.can:1919
	local add = storage_table["add"] -- models/free-market.can:1921
	for item_name, count in pairs(storages[player["force"]["index"]]) do -- models/free-market.can:1922
		add(SPRITE_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:1923
		add(LABEL)["caption"] = tostring(count) -- models/free-market.can:1924
	end -- models/free-market.can:1924
	main_frame["force_auto_center"]() -- models/free-market.can:1927
end -- models/free-market.can:1927
local function open_price_list_gui(player) -- models/free-market.can:1930
	local screen = player["gui"]["screen"] -- models/free-market.can:1931
	if screen["FM_price_list_frame"] then -- models/free-market.can:1932
		screen["FM_price_list_frame"]["destroy"]() -- models/free-market.can:1933
		return  -- models/free-market.can:1934
	end -- models/free-market.can:1934
	local main_frame = screen["add"]({ -- models/free-market.can:1936
		["type"] = "frame", -- models/free-market.can:1936
		["name"] = "FM_price_list_frame", -- models/free-market.can:1936
		["direction"] = "vertical" -- models/free-market.can:1936
	}) -- models/free-market.can:1936
	main_frame["style"]["horizontally_stretchable"] = true -- models/free-market.can:1937
	main_frame["style"]["maximal_height"] = 700 -- models/free-market.can:1938
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:1939
	flow["add"]({ -- models/free-market.can:1940
		["type"] = "label", -- models/free-market.can:1941
		["style"] = "frame_title", -- models/free-market.can:1942
		["caption"] = { "free-market.price-list" }, -- models/free-market.can:1943
		["ignored_by_interaction"] = true -- models/free-market.can:1944
	}) -- models/free-market.can:1944
	flow["add"](DRAG_HANDLER)["drag_target"] = main_frame -- models/free-market.can:1946
	flow["add"](CLOSE_BUTTON) -- models/free-market.can:1947
	local shallow_frame = main_frame["add"]({ -- models/free-market.can:1948
		["type"] = "frame", -- models/free-market.can:1948
		["name"] = "shallow_frame", -- models/free-market.can:1948
		["style"] = "inside_shallow_frame", -- models/free-market.can:1948
		["direction"] = "vertical" -- models/free-market.can:1948
	}) -- models/free-market.can:1948
	local content_flow = shallow_frame["add"]({ -- models/free-market.can:1949
		["type"] = "flow", -- models/free-market.can:1949
		["name"] = "content_flow", -- models/free-market.can:1949
		["direction"] = "vertical" -- models/free-market.can:1949
	}) -- models/free-market.can:1949
	content_flow["style"]["padding"] = 12 -- models/free-market.can:1950
	local team_row = content_flow["add"](FLOW) -- models/free-market.can:1952
	team_row["name"] = "team_row" -- models/free-market.can:1953
	team_row["add"](LABEL)["caption"] = { -- models/free-market.can:1954
		"", -- models/free-market.can:1954
		{ "team" }, -- models/free-market.can:1954
		COLON -- models/free-market.can:1954
	} -- models/free-market.can:1954
	local items = {} -- models/free-market.can:1955
	local size = 0 -- models/free-market.can:1956
	for force_name, force in pairs(game["forces"]) do -- models/free-market.can:1957
		local force_index = force["index"] -- models/free-market.can:1958
		local f_sell_prices = sell_prices[force_index] -- models/free-market.can:1959
		local f_buy_prices = buy_prices[force_index] -- models/free-market.can:1960
		if (f_sell_prices and next(f_sell_prices)) or (f_buy_prices and next(f_buy_prices)) then -- models/free-market.can:1961
			size = size + 1 -- models/free-market.can:1962
			items[size] = force_name -- models/free-market.can:1963
		end -- models/free-market.can:1963
	end -- models/free-market.can:1963
	team_row["add"]({ -- models/free-market.can:1966
		["type"] = "drop-down", -- models/free-market.can:1966
		["name"] = "FM_force_price_list", -- models/free-market.can:1966
		["items"] = items -- models/free-market.can:1966
	}) -- models/free-market.can:1966
	local search_row = content_flow["add"]({ -- models/free-market.can:1968
		["type"] = "table", -- models/free-market.can:1968
		["name"] = "search_row", -- models/free-market.can:1968
		["column_count"] = 4 -- models/free-market.can:1968
	}) -- models/free-market.can:1968
	search_row["add"]({ -- models/free-market.can:1969
		["type"] = "textfield", -- models/free-market.can:1969
		["name"] = "FM_search_text" -- models/free-market.can:1969
	}) -- models/free-market.can:1969
	search_row["add"](LABEL)["caption"] = { -- models/free-market.can:1970
		"", -- models/free-market.can:1970
		{ "gui.search" }, -- models/free-market.can:1970
		COLON -- models/free-market.can:1970
	} -- models/free-market.can:1970
	search_row["add"]({ -- models/free-market.can:1971
		["type"] = "drop-down", -- models/free-market.can:1972
		["name"] = "FM_search_price_drop_down", -- models/free-market.can:1973
		["items"] = { -- models/free-market.can:1974
			{ "free-market.sell-offer-gui" }, -- models/free-market.can:1974
			{ "free-market.buy-request-gui" } -- models/free-market.can:1974
		} -- models/free-market.can:1974
	}) -- models/free-market.can:1974
	search_row["add"]({ -- models/free-market.can:1976
		["type"] = "sprite-button", -- models/free-market.can:1977
		["style"] = "frame_action_button", -- models/free-market.can:1978
		["name"] = "FM_search_by_price", -- models/free-market.can:1979
		["hovered_sprite"] = "utility/search_black", -- models/free-market.can:1980
		["clicked_sprite"] = "utility/search_black", -- models/free-market.can:1981
		["sprite"] = "utility/search_white" -- models/free-market.can:1982
	}) -- models/free-market.can:1982
	local prices_frame = content_flow["add"]({ -- models/free-market.can:1985
		["type"] = "frame", -- models/free-market.can:1985
		["name"] = "deep_frame", -- models/free-market.can:1985
		["style"] = "deep_frame_in_shallow_frame", -- models/free-market.can:1985
		["direction"] = "vertical" -- models/free-market.can:1985
	}) -- models/free-market.can:1985
	local scroll_pane = prices_frame["add"](SCROLL_PANE) -- models/free-market.can:1986
	scroll_pane["style"]["padding"] = 12 -- models/free-market.can:1987
	local prices_table = scroll_pane["add"]({ -- models/free-market.can:1988
		["type"] = "table", -- models/free-market.can:1988
		["name"] = "price_list_table", -- models/free-market.can:1988
		["column_count"] = 3 -- models/free-market.can:1988
	}) -- models/free-market.can:1988
	prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:1989
	prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:1990
	prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:1991
	prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:1992
	prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:1993
	prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:1994
	prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:1995
	prices_table["style"]["column_alignments"][5] = "center" -- models/free-market.can:1996
	prices_table["style"]["column_alignments"][6] = "center" -- models/free-market.can:1997
	prices_table["draw_horizontal_lines"] = true -- models/free-market.can:1998
	prices_table["draw_vertical_lines"] = true -- models/free-market.can:1999
	make_price_list_header(prices_table) -- models/free-market.can:2000
	local short_prices_table = scroll_pane["add"]({ -- models/free-market.can:2002
		["type"] = "table", -- models/free-market.can:2002
		["name"] = "short_price_list_table", -- models/free-market.can:2002
		["column_count"] = 2 -- models/free-market.can:2002
	}) -- models/free-market.can:2002
	short_prices_table["style"]["horizontal_spacing"] = 16 -- models/free-market.can:2003
	short_prices_table["style"]["vertical_spacing"] = 8 -- models/free-market.can:2004
	short_prices_table["style"]["top_margin"] = - 16 -- models/free-market.can:2005
	short_prices_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2006
	short_prices_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2007
	short_prices_table["style"]["column_alignments"][3] = "center" -- models/free-market.can:2008
	short_prices_table["style"]["column_alignments"][4] = "center" -- models/free-market.can:2009
	short_prices_table["draw_horizontal_lines"] = true -- models/free-market.can:2010
	short_prices_table["draw_vertical_lines"] = true -- models/free-market.can:2011
	short_prices_table["visible"] = false -- models/free-market.can:2012
	main_frame["force_auto_center"]() -- models/free-market.can:2014
end -- models/free-market.can:2014
local function open_buy_box_gui(player, is_new, entity) -- models/free-market.can:2020
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2021
	box_operations["clear"]() -- models/free-market.can:2022
	if box_operations["buy_content"] and not is_new then -- models/free-market.can:2023
		return  -- models/free-market.can:2024
	end -- models/free-market.can:2024
	local row = box_operations["add"]({ -- models/free-market.can:2027
		["type"] = "table", -- models/free-market.can:2027
		["name"] = "buy_content", -- models/free-market.can:2027
		["column_count"] = 4 -- models/free-market.can:2027
	}) -- models/free-market.can:2027
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2028
	row["add"]({ -- models/free-market.can:2029
		["type"] = "label", -- models/free-market.can:2029
		["caption"] = { -- models/free-market.can:2029
			"", -- models/free-market.can:2029
			{ "free-market.count-gui" }, -- models/free-market.can:2029
			COLON -- models/free-market.can:2029
		} -- models/free-market.can:2029
	}) -- models/free-market.can:2029
	local count_element = row["add"]({ -- models/free-market.can:2030
		["type"] = "textfield", -- models/free-market.can:2030
		["name"] = "count", -- models/free-market.can:2030
		["numeric"] = true, -- models/free-market.can:2030
		["allow_decimal"] = false, -- models/free-market.can:2030
		["allow_negative"] = false -- models/free-market.can:2030
	}) -- models/free-market.can:2030
	count_element["style"]["width"] = 70 -- models/free-market.can:2031
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2032
	if is_new then -- models/free-market.can:2033
		confirm_button["name"] = "FM_confirm_buy_box" -- models/free-market.can:2034
	else -- models/free-market.can:2034
		confirm_button["name"] = "FM_change_buy_box" -- models/free-market.can:2036
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2037
		local entities_data = box_data[4] -- models/free-market.can:2038
		for i = 1, # entities_data do -- models/free-market.can:2039
			local buy_box = entities_data[i] -- models/free-market.can:2040
			if buy_box[1] == entity then -- models/free-market.can:2041
				count_element["text"] = tostring(buy_box[2]) -- models/free-market.can:2042
				break -- models/free-market.can:2043
			end -- models/free-market.can:2043
		end -- models/free-market.can:2043
		local item_name = box_data[5] -- models/free-market.can:2046
		FM_item["elem_value"] = item_name -- models/free-market.can:2047
	end -- models/free-market.can:2047
end -- models/free-market.can:2047
local function clear_boxes_gui(player) -- models/free-market.can:2051
	open_box[player["index"]] = nil -- models/free-market.can:2052
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:2053
end -- models/free-market.can:2053
local function open_transfer_box_gui(player, is_new, entity) -- models/free-market.can:2059
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2060
	box_operations["clear"]() -- models/free-market.can:2061
	if box_operations["transfer_content"] and not is_new then -- models/free-market.can:2062
		return  -- models/free-market.can:2063
	end -- models/free-market.can:2063
	local row = box_operations["add"]({ -- models/free-market.can:2066
		["type"] = "table", -- models/free-market.can:2066
		["name"] = "transfer_content", -- models/free-market.can:2066
		["column_count"] = 2 -- models/free-market.can:2066
	}) -- models/free-market.can:2066
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2067
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2068
	if is_new then -- models/free-market.can:2069
		confirm_button["name"] = "FM_confirm_transfer_box" -- models/free-market.can:2070
	else -- models/free-market.can:2070
		confirm_button["name"] = "FM_change_transfer_box" -- models/free-market.can:2072
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2073
	end -- models/free-market.can:2073
end -- models/free-market.can:2073
local function open_bin_box_gui(player, is_new, entity) -- models/free-market.can:2080
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2081
	box_operations["clear"]() -- models/free-market.can:2082
	if box_operations["bin_content"] and not is_new then -- models/free-market.can:2083
		return  -- models/free-market.can:2084
	end -- models/free-market.can:2084
	local row = box_operations["add"]({ -- models/free-market.can:2087
		["type"] = "table", -- models/free-market.can:2087
		["name"] = "bin_content", -- models/free-market.can:2087
		["column_count"] = 2 -- models/free-market.can:2087
	}) -- models/free-market.can:2087
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2088
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2089
	if is_new then -- models/free-market.can:2090
		confirm_button["name"] = "FM_confirm_bin_box" -- models/free-market.can:2091
	else -- models/free-market.can:2091
		confirm_button["name"] = "FM_change_bin_box" -- models/free-market.can:2093
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2094
	end -- models/free-market.can:2094
end -- models/free-market.can:2094
local function create_top_relative_gui(player) -- models/free-market.can:2098
	local relative = player["gui"]["relative"] -- models/free-market.can:2099
	local main_frame = relative["FM_boxes_frame"] -- models/free-market.can:2100
	if main_frame then -- models/free-market.can:2101
		main_frame["destroy"]() -- models/free-market.can:2102
	end -- models/free-market.can:2102
	local boxes_anchor = { -- models/free-market.can:2105
		["gui"] = defines["relative_gui_type"]["container_gui"], -- models/free-market.can:2105
		["position"] = defines["relative_gui_position"]["top"] -- models/free-market.can:2105
	} -- models/free-market.can:2105
	main_frame = relative["add"]({ -- models/free-market.can:2106
		["type"] = "frame", -- models/free-market.can:2106
		["name"] = "FM_boxes_frame", -- models/free-market.can:2106
		["anchor"] = boxes_anchor -- models/free-market.can:2106
	}) -- models/free-market.can:2106
	main_frame["style"]["vertical_align"] = "center" -- models/free-market.can:2107
	main_frame["style"]["horizontally_stretchable"] = false -- models/free-market.can:2108
	main_frame["style"]["bottom_margin"] = - 14 -- models/free-market.can:2109
	local frame = main_frame["add"]({ -- models/free-market.can:2110
		["type"] = "frame", -- models/free-market.can:2110
		["name"] = "content", -- models/free-market.can:2110
		["style"] = "inside_shallow_frame" -- models/free-market.can:2110
	}) -- models/free-market.can:2110
	local main_flow = frame["add"]({ -- models/free-market.can:2111
		["type"] = "flow", -- models/free-market.can:2111
		["name"] = "main_flow", -- models/free-market.can:2111
		["direction"] = "vertical" -- models/free-market.can:2111
	}) -- models/free-market.can:2111
	main_flow["style"]["vertical_spacing"] = 0 -- models/free-market.can:2112
	main_flow["add"](FLOW)["name"] = "box_operations" -- models/free-market.can:2113
	local flow = main_flow["add"](FLOW) -- models/free-market.can:2114
	flow["add"]({ -- models/free-market.can:2115
		["type"] = "button", -- models/free-market.can:2115
		["style"] = "FM_transfer_button", -- models/free-market.can:2115
		["name"] = "FM_set_transfer_box" -- models/free-market.can:2115
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2115
	flow["add"]({ -- models/free-market.can:2116
		["type"] = "button", -- models/free-market.can:2116
		["style"] = "FM_universal_transfer_button", -- models/free-market.can:2116
		["name"] = "FM_set_universal_transfer_box" -- models/free-market.can:2116
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2116
	flow["add"]({ -- models/free-market.can:2117
		["type"] = "button", -- models/free-market.can:2117
		["style"] = "FM_bin_button", -- models/free-market.can:2117
		["name"] = "FM_set_bin_box" -- models/free-market.can:2117
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2117
	flow["add"]({ -- models/free-market.can:2118
		["type"] = "button", -- models/free-market.can:2118
		["style"] = "FM_universal_bin_button", -- models/free-market.can:2118
		["name"] = "FM_set_universal_bin_box" -- models/free-market.can:2118
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2118
	flow["add"]({ -- models/free-market.can:2119
		["type"] = "button", -- models/free-market.can:2119
		["style"] = "FM_pull_out_button", -- models/free-market.can:2119
		["name"] = "FM_set_pull_box" -- models/free-market.can:2119
	})["style"]["right_margin"] = - 6 -- models/free-market.can:2119
	flow["add"]({ -- models/free-market.can:2120
		["type"] = "button", -- models/free-market.can:2120
		["style"] = "FM_buy_button", -- models/free-market.can:2120
		["name"] = "FM_set_buy_box" -- models/free-market.can:2120
	}) -- models/free-market.can:2120
end -- models/free-market.can:2120
local function open_pull_box_gui(player, is_new, entity) -- models/free-market.can:2126
	local box_operations = player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"] -- models/free-market.can:2127
	box_operations["clear"]() -- models/free-market.can:2128
	if box_operations["pull_content"] then -- models/free-market.can:2129
		return  -- models/free-market.can:2130
	end -- models/free-market.can:2130
	local row = box_operations["add"]({ -- models/free-market.can:2132
		["type"] = "table", -- models/free-market.can:2132
		["name"] = "pull_content", -- models/free-market.can:2132
		["column_count"] = 2 -- models/free-market.can:2132
	}) -- models/free-market.can:2132
	local FM_item = row["add"](FM_ITEM_ELEMENT) -- models/free-market.can:2133
	local confirm_button = row["add"](CHECK_BUTTON) -- models/free-market.can:2134
	if is_new then -- models/free-market.can:2135
		confirm_button["name"] = "FM_confirm_pull_box" -- models/free-market.can:2136
	else -- models/free-market.can:2136
		confirm_button["name"] = "FM_change_pull_box" -- models/free-market.can:2138
		FM_item["elem_value"] = all_boxes[entity["unit_number"]][5] -- models/free-market.can:2139
	end -- models/free-market.can:2139
end -- models/free-market.can:2139
local function create_left_relative_gui(player) -- models/free-market.can:2143
	local relative = player["gui"]["relative"] -- models/free-market.can:2144
	local main_table = relative["FM_buttons"] -- models/free-market.can:2145
	if main_table then -- models/free-market.can:2146
		main_table["destroy"]() -- models/free-market.can:2147
	end -- models/free-market.can:2147
	local left_anchor = { -- models/free-market.can:2150
		["gui"] = defines["relative_gui_type"]["controller_gui"], -- models/free-market.can:2150
		["position"] = defines["relative_gui_position"]["left"] -- models/free-market.can:2150
	} -- models/free-market.can:2150
	main_table = relative["add"]({ -- models/free-market.can:2151
		["type"] = "table", -- models/free-market.can:2151
		["name"] = "FM_buttons", -- models/free-market.can:2151
		["anchor"] = left_anchor, -- models/free-market.can:2151
		["column_count"] = 2 -- models/free-market.can:2151
	}) -- models/free-market.can:2151
	main_table["style"]["vertical_align"] = "center" -- models/free-market.can:2152
	main_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2153
	main_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2154
	local button = main_table["add"]({ -- models/free-market.can:2156
		["type"] = "button", -- models/free-market.can:2156
		["style"] = "side_menu_button", -- models/free-market.can:2156
		["caption"] = ">", -- models/free-market.can:2156
		["name"] = "FM_hide_left_buttons" -- models/free-market.can:2156
	}) -- models/free-market.can:2156
	button["style"]["font"] = "default-dialog-button" -- models/free-market.can:2157
	button["style"]["font_color"] = WHITE_COLOR -- models/free-market.can:2158
	button["style"]["top_padding"] = - 4 -- models/free-market.can:2159
	button["style"]["width"] = 18 -- models/free-market.can:2160
	button["style"]["height"] = 20 -- models/free-market.can:2161
	local frame = main_table["add"]({ -- models/free-market.can:2163
		["type"] = "frame", -- models/free-market.can:2163
		["name"] = "content" -- models/free-market.can:2163
	}) -- models/free-market.can:2163
	frame["style"]["right_margin"] = - 14 -- models/free-market.can:2164
	local shallow_frame = frame["add"]({ -- models/free-market.can:2165
		["type"] = "frame", -- models/free-market.can:2165
		["name"] = "shallow_frame", -- models/free-market.can:2165
		["style"] = "inside_shallow_frame" -- models/free-market.can:2165
	}) -- models/free-market.can:2165
	local buttons_table = shallow_frame["add"]({ -- models/free-market.can:2166
		["type"] = "table", -- models/free-market.can:2166
		["column_count"] = 3 -- models/free-market.can:2166
	}) -- models/free-market.can:2166
	buttons_table["style"]["horizontal_spacing"] = 0 -- models/free-market.can:2167
	buttons_table["style"]["vertical_spacing"] = 0 -- models/free-market.can:2168
	buttons_table["add"]({ -- models/free-market.can:2169
		["type"] = "sprite-button", -- models/free-market.can:2169
		["sprite"] = "FM_change-price", -- models/free-market.can:2169
		["style"] = "slot_button", -- models/free-market.can:2169
		["name"] = "FM_open_price" -- models/free-market.can:2169
	}) -- models/free-market.can:2169
	buttons_table["add"]({ -- models/free-market.can:2170
		["type"] = "sprite-button", -- models/free-market.can:2170
		["sprite"] = "FM_see-prices", -- models/free-market.can:2170
		["style"] = "slot_button", -- models/free-market.can:2170
		["name"] = "FM_open_price_list" -- models/free-market.can:2170
	}) -- models/free-market.can:2170
	buttons_table["add"]({ -- models/free-market.can:2171
		["type"] = "sprite-button", -- models/free-market.can:2171
		["sprite"] = "FM_embargo", -- models/free-market.can:2171
		["style"] = "slot_button", -- models/free-market.can:2171
		["name"] = "FM_open_embargo" -- models/free-market.can:2171
	}) -- models/free-market.can:2171
	buttons_table["add"]({ -- models/free-market.can:2172
		["type"] = "sprite-button", -- models/free-market.can:2172
		["sprite"] = "item/wooden-chest", -- models/free-market.can:2172
		["style"] = "slot_button", -- models/free-market.can:2172
		["name"] = "FM_open_storage" -- models/free-market.can:2172
	}) -- models/free-market.can:2172
	buttons_table["add"]({ -- models/free-market.can:2173
		["type"] = "sprite-button", -- models/free-market.can:2173
		["sprite"] = "virtual-signal/signal-info", -- models/free-market.can:2173
		["style"] = "slot_button", -- models/free-market.can:2173
		["name"] = "FM_show_hint" -- models/free-market.can:2173
	}) -- models/free-market.can:2173
	buttons_table["add"]({ -- models/free-market.can:2174
		["type"] = "sprite-button", -- models/free-market.can:2175
		["sprite"] = "utility/side_menu_menu_icon", -- models/free-market.can:2176
		["hovered_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2177
		["clicked_sprite"] = "utility/side_menu_menu_hover_icon", -- models/free-market.can:2178
		["style"] = "slot_button", -- models/free-market.can:2179
		["name"] = "FM_open_force_configuration" -- models/free-market.can:2180
	}) -- models/free-market.can:2180
end -- models/free-market.can:2180
local function check_buy_price(player, item_name) -- models/free-market.can:2186
	local force_index = player["force"]["index"] -- models/free-market.can:2187
	if buy_prices[force_index][item_name] == nil then -- models/free-market.can:2188
		local screen = player["gui"]["screen"] -- models/free-market.can:2189
		local prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2190
		local content_flow -- models/free-market.can:2191
		if prices_frame == nil then -- models/free-market.can:2192
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2193
			prices_frame = screen["FM_prices_frame"] -- models/free-market.can:2194
		else -- models/free-market.can:2194
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2196
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2197
			local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2198
			if sell_price then -- models/free-market.can:2199
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price) -- models/free-market.can:2200
			end -- models/free-market.can:2200
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2202
		end -- models/free-market.can:2202
		content_flow["item_row"]["buy_price"]["focus"]() -- models/free-market.can:2204
	end -- models/free-market.can:2204
end -- models/free-market.can:2204
local function check_sell_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2211
	local force_index = player["force"]["index"] -- models/free-market.can:2212
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2213
	if sell_price then -- models/free-market.can:2214
		return  -- models/free-market.can:2214
	end -- models/free-market.can:2214
	local row = gui["add"]({ -- models/free-market.can:2216
		["type"] = "table", -- models/free-market.can:2216
		["name"] = "sell_price_table", -- models/free-market.can:2216
		["column_count"] = 4 -- models/free-market.can:2216
	}) -- models/free-market.can:2216
	local add = row["add"] -- models/free-market.can:2217
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2218
	add(LABEL)["caption"] = { -- models/free-market.can:2219
		"", -- models/free-market.can:2219
		{ "free-market.sell-price-label" }, -- models/free-market.can:2219
		COLON -- models/free-market.can:2219
	} -- models/free-market.can:2219
	add(SELL_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2220
	add(CHECK_BUTTON)["name"] = "FM_confirm_sell_price_for_chest" -- models/free-market.can:2221
end -- models/free-market.can:2221
local function check_buy_price_for_opened_chest(player, gui, item_name) -- models/free-market.can:2227
	local force_index = player["force"]["index"] -- models/free-market.can:2228
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2229
	if buy_price then -- models/free-market.can:2230
		return  -- models/free-market.can:2230
	end -- models/free-market.can:2230
	local row = gui["add"]({ -- models/free-market.can:2232
		["type"] = "table", -- models/free-market.can:2232
		["name"] = "buy_price_table", -- models/free-market.can:2232
		["column_count"] = 4 -- models/free-market.can:2232
	}) -- models/free-market.can:2232
	local add = row["add"] -- models/free-market.can:2233
	add(SLOT_BUTTON)["sprite"] = "item/" .. item_name -- models/free-market.can:2234
	add(LABEL)["caption"] = { -- models/free-market.can:2235
		"", -- models/free-market.can:2235
		{ "free-market.buy-price-label" }, -- models/free-market.can:2235
		COLON -- models/free-market.can:2235
	} -- models/free-market.can:2235
	add(BUY_PRICE_TEXTFIELD)["focus"]() -- models/free-market.can:2236
	add(CHECK_BUTTON)["name"] = "FM_confirm_buy_price_for_chest" -- models/free-market.can:2237
end -- models/free-market.can:2237
local function check_sell_price(player, item_name) -- models/free-market.can:2242
	local force_index = player["force"]["index"] -- models/free-market.can:2243
	if sell_prices[force_index][item_name] == nil then -- models/free-market.can:2244
		local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2245
		local content_flow -- models/free-market.can:2246
		if prices_frame == nil then -- models/free-market.can:2247
			content_flow = switch_prices_gui(player, item_name) -- models/free-market.can:2248
			prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2249
		else -- models/free-market.can:2249
			content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2251
			content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2252
			local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2253
			if buy_price then -- models/free-market.can:2254
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price) -- models/free-market.can:2255
			end -- models/free-market.can:2255
			update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2257
		end -- models/free-market.can:2257
		content_flow["item_row"]["sell_price"]["focus"]() -- models/free-market.can:2259
	end -- models/free-market.can:2259
end -- models/free-market.can:2259
local function create_item_price_HUD(player) -- models/free-market.can:2264
	local screen = player["gui"]["screen"] -- models/free-market.can:2265
	local main_frame = screen["FM_item_price_frame"] -- models/free-market.can:2266
	if main_frame then -- models/free-market.can:2267
		return  -- models/free-market.can:2268
	end -- models/free-market.can:2268
	main_frame = screen["add"]({ -- models/free-market.can:2271
		["type"] = "frame", -- models/free-market.can:2271
		["name"] = "FM_item_price_frame", -- models/free-market.can:2271
		["style"] = "FM_item_price_frame", -- models/free-market.can:2271
		["direction"] = "horizontal" -- models/free-market.can:2271
	}) -- models/free-market.can:2271
	main_frame["location"] = { -- models/free-market.can:2272
		["x"] = player["display_resolution"]["width"] / 2, -- models/free-market.can:2272
		["y"] = 10 -- models/free-market.can:2272
	} -- models/free-market.can:2272
	local flow = main_frame["add"](TITLEBAR_FLOW) -- models/free-market.can:2274
	local drag_handler = flow["add"](DRAG_HANDLER) -- models/free-market.can:2275
	drag_handler["drag_target"] = main_frame -- models/free-market.can:2276
	drag_handler["style"]["vertically_stretchable"] = true -- models/free-market.can:2277
	drag_handler["style"]["minimal_height"] = 22 -- models/free-market.can:2278
	drag_handler["style"]["maximal_height"] = 0 -- models/free-market.can:2279
	drag_handler["style"]["margin"] = 0 -- models/free-market.can:2280
	drag_handler["style"]["width"] = 10 -- models/free-market.can:2281
	local info_flow = main_frame["add"](VERTICAL_FLOW) -- models/free-market.can:2283
	info_flow["visible"] = false -- models/free-market.can:2284
	local hud_table = info_flow["add"]({ -- models/free-market.can:2285
		["type"] = "table", -- models/free-market.can:2285
		["column_count"] = 2 -- models/free-market.can:2285
	}) -- models/free-market.can:2285
	local add = hud_table["add"] -- models/free-market.can:2286
	hud_table["style"]["column_alignments"][1] = "center" -- models/free-market.can:2287
	hud_table["style"]["column_alignments"][2] = "center" -- models/free-market.can:2288
	add(LABEL)["caption"] = { -- models/free-market.can:2290
		"", -- models/free-market.can:2290
		{ "free-market.sell-price-label" }, -- models/free-market.can:2290
		COLON -- models/free-market.can:2290
	} -- models/free-market.can:2290
	local sell_price = add(LABEL) -- models/free-market.can:2291
	add(LABEL)["caption"] = { -- models/free-market.can:2293
		"", -- models/free-market.can:2293
		{ "free-market.buy-price-label" }, -- models/free-market.can:2293
		COLON -- models/free-market.can:2293
	} -- models/free-market.can:2293
	local buy_price = add(LABEL) -- models/free-market.can:2294
	local storage_flow = info_flow["add"](FLOW) -- models/free-market.can:2297
	local add = storage_flow["add"] -- models/free-market.can:2298
	local item_label = add(LABEL) -- models/free-market.can:2299
	add(LABEL)["caption"] = { -- models/free-market.can:2300
		"", -- models/free-market.can:2300
		{ "description.storage" }, -- models/free-market.can:2300
		COLON -- models/free-market.can:2300
	} -- models/free-market.can:2300
	local storage_count = add(LABEL) -- models/free-market.can:2301
	add(LABEL)["caption"] = "/" -- models/free-market.can:2303
	local storage_limit = add(LABEL) -- models/free-market.can:2304
	item_HUD[player["index"]] = { -- models/free-market.can:2307
		info_flow, -- models/free-market.can:2308
		sell_price, -- models/free-market.can:2309
		buy_price, -- models/free-market.can:2310
		item_label, -- models/free-market.can:2311
		storage_count, -- models/free-market.can:2312
		storage_limit -- models/free-market.can:2313
	} -- models/free-market.can:2313
end -- models/free-market.can:2313
local function hide_item_price_HUD(player) -- models/free-market.can:2318
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2319
	if hinter then -- models/free-market.can:2320
		hinter[1]["visible"] = false -- models/free-market.can:2321
	end -- models/free-market.can:2321
end -- models/free-market.can:2321
local function show_item_info_HUD(player, item_name) -- models/free-market.can:2327
	local force_index = player["force"]["index"] -- models/free-market.can:2328
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:2329
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:2330
	local count = storages[force_index][item_name] -- models/free-market.can:2331
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2332
	local hinter = item_HUD[player["index"]] -- models/free-market.can:2334
	hinter[1]["visible"] = true -- models/free-market.can:2335
	if sell_price then -- models/free-market.can:2336
		hinter[2]["caption"] = tostring(sell_price) -- models/free-market.can:2337
	else -- models/free-market.can:2337
		hinter[2]["caption"] = "" -- models/free-market.can:2339
	end -- models/free-market.can:2339
	if buy_price then -- models/free-market.can:2341
		hinter[3]["caption"] = tostring(buy_price) -- models/free-market.can:2342
	else -- models/free-market.can:2342
		hinter[3]["caption"] = "" -- models/free-market.can:2344
	end -- models/free-market.can:2344
	hinter[4]["caption"] = "[item=" .. item_name .. "]" -- models/free-market.can:2346
	if count then -- models/free-market.can:2347
		hinter[5]["caption"] = tostring(count) -- models/free-market.can:2348
	else -- models/free-market.can:2348
		hinter[5]["caption"] = "0" -- models/free-market.can:2350
	end -- models/free-market.can:2350
	hinter[6]["caption"] = limit -- models/free-market.can:2352
end -- models/free-market.can:2352
local REMOVE_BOX_FUNCS = { -- models/free-market.can:2360
	[1] = remove_certain_buy_box, -- models/free-market.can:2361
	[3] = remove_certain_pull_box, -- models/free-market.can:2362
	[4] = remove_certain_transfer_box, -- models/free-market.can:2363
	[5] = remove_certain_universal_transfer_box, -- models/free-market.can:2364
	[6] = remove_certain_bin_box, -- models/free-market.can:2365
	[7] = remove_certain_universal_bin_box -- models/free-market.can:2366
} -- models/free-market.can:2366
local function clear_box_data(event) -- models/free-market.can:2368
	local entity = event["entity"] -- models/free-market.can:2369
	local unit_number = entity["unit_number"] -- models/free-market.can:2370
	local box_data = all_boxes[unit_number] -- models/free-market.can:2371
	if box_data == nil then -- models/free-market.can:2372
		return  -- models/free-market.can:2372
	end -- models/free-market.can:2372
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2374
end -- models/free-market.can:2374
local function clear_box_data_by_entity(entity) -- models/free-market.can:2378
	local unit_number = entity["unit_number"] -- models/free-market.can:2379
	local box_data = all_boxes[unit_number] -- models/free-market.can:2380
	if box_data == nil then -- models/free-market.can:2381
		return  -- models/free-market.can:2381
	end -- models/free-market.can:2381
	rendering_destroy(box_data[2]) -- models/free-market.can:2383
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data) -- models/free-market.can:2384
	return true -- models/free-market.can:2385
end -- models/free-market.can:2385
local function on_player_created(event) -- models/free-market.can:2388
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2389
	if not (player and player["valid"]) then -- models/free-market.can:2390
		return  -- models/free-market.can:2390
	end -- models/free-market.can:2390
	create_item_price_HUD(player) -- models/free-market.can:2392
	create_top_relative_gui(player) -- models/free-market.can:2393
	create_left_relative_gui(player) -- models/free-market.can:2394
	switch_sell_prices_gui(player) -- models/free-market.can:2395
	switch_buy_prices_gui(player) -- models/free-market.can:2396
	if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2397
		create_item_price_HUD(player) -- models/free-market.can:2398
	end -- models/free-market.can:2398
end -- models/free-market.can:2398
local function on_player_joined_game(event) -- models/free-market.can:2403
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2404
	if not (player and player["valid"]) then -- models/free-market.can:2405
		return  -- models/free-market.can:2405
	end -- models/free-market.can:2405
	if # game["connected_players"] == 1 then -- models/free-market.can:2407
		clear_invalid_player_data() -- models/free-market.can:2408
	end -- models/free-market.can:2408
	clear_boxes_gui(player) -- models/free-market.can:2411
	destroy_prices_gui(player) -- models/free-market.can:2412
	destroy_price_list_gui(player) -- models/free-market.can:2413
	create_item_price_HUD(player) -- models/free-market.can:2414
	switch_sell_prices_gui(player) -- models/free-market.can:2417
	switch_sell_prices_gui(player) -- models/free-market.can:2418
	switch_buy_prices_gui(player) -- models/free-market.can:2419
	switch_buy_prices_gui(player) -- models/free-market.can:2420
	open_embargo_gui(player) -- models/free-market.can:2422
	open_force_configuration(player) -- models/free-market.can:2423
	open_storage_gui(player) -- models/free-market.can:2424
	open_price_list_gui(player) -- models/free-market.can:2425
	switch_prices_gui(player) -- models/free-market.can:2427
	switch_prices_gui(player) -- models/free-market.can:2428
	switch_prices_gui(player) -- models/free-market.can:2429
	for item_name in pairs(game["item_prototypes"]) do -- models/free-market.can:2430
		switch_prices_gui(player, item_name) -- models/free-market.can:2431
	end -- models/free-market.can:2431
end -- models/free-market.can:2431
local function on_player_cursor_stack_changed(event) -- models/free-market.can:2436
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2437
	local cursor_stack = player["cursor_stack"] -- models/free-market.can:2438
	if cursor_stack["valid_for_read"] then -- models/free-market.can:2439
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:2440
			show_item_info_HUD(player, cursor_stack["name"]) -- models/free-market.can:2441
		end -- models/free-market.can:2441
	else -- models/free-market.can:2441
		hide_item_price_HUD(player) -- models/free-market.can:2444
	end -- models/free-market.can:2444
end -- models/free-market.can:2444
local function on_force_created(event) -- models/free-market.can:2448
	init_force_data(event["force"]["index"]) -- models/free-market.can:2449
end -- models/free-market.can:2449
local function check_teams_data() -- models/free-market.can:2452
	for _, storage in pairs(storages) do -- models/free-market.can:2453
		for item_name, count in pairs(storage) do -- models/free-market.can:2454
			if count == 0 then -- models/free-market.can:2455
				storage[item_name] = nil -- models/free-market.can:2456
			end -- models/free-market.can:2456
		end -- models/free-market.can:2456
	end -- models/free-market.can:2456
end -- models/free-market.can:2456
local function check_forces() -- models/free-market.can:2462
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:2463
	local neutral_force = game["forces"]["neutral"] -- models/free-market.can:2465
	mod_data["active_forces"] = {} -- models/free-market.can:2466
	active_forces = mod_data["active_forces"] -- models/free-market.can:2467
	local size = 0 -- models/free-market.can:2468
	for _, force in pairs(game["forces"]) do -- models/free-market.can:2470
		if # force["connected_players"] > 0 then -- models/free-market.can:2471
			local force_index = force["index"] -- models/free-market.can:2472
			local items_data = buy_boxes[force_index] -- models/free-market.can:2473
			local storage_data = storages[force_index] -- models/free-market.can:2474
			if items_data and next(items_data) or storage_data and next(storage_data) then -- models/free-market.can:2475
				local buyer_money = forces_money[force_index] -- models/free-market.can:2476
				if buyer_money and buyer_money > money_treshold then -- models/free-market.can:2477
					size = size + 1 -- models/free-market.can:2478
					active_forces[size] = force_index -- models/free-market.can:2479
				end -- models/free-market.can:2479
			end -- models/free-market.can:2479
		elseif math["random"](99) > skip_offline_team_chance or force == neutral_force then -- models/free-market.can:2482
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
		end -- models/free-market.can:2490
	end -- models/free-market.can:2490
	if # active_forces < 2 then -- models/free-market.can:2496
		mod_data["active_forces"] = {} -- models/free-market.can:2497
		active_forces = mod_data["active_forces"] -- models/free-market.can:2498
	end -- models/free-market.can:2498
	game["print"]("Active forces: " .. serpent["line"](active_forces)) -- models/free-market.can:2502
end -- models/free-market.can:2502
local function on_forces_merging(event) -- models/free-market.can:2506
	local source = event["source"] -- models/free-market.can:2507
	local source_index = source["index"] -- models/free-market.can:2508
	local source_storage = storages[source_index] -- models/free-market.can:2510
	local destination_storage = storages[event["destination"]["index"]] -- models/free-market.can:2511
	for item_name, count in pairs(source_storage) do -- models/free-market.can:2512
		destination_storage[item_name] = count + (destination_storage[item_name] or 0) -- models/free-market.can:2513
	end -- models/free-market.can:2513
	clear_force_data(source_index) -- models/free-market.can:2515
	local ids = rendering["get_all_ids"]() -- models/free-market.can:2517
	for i = 1, # ids do -- models/free-market.can:2518
		local id = ids[i] -- models/free-market.can:2519
		if is_render_valid(id) then -- models/free-market.can:2520
			local target = get_render_target(id) -- models/free-market.can:2521
			if target then -- models/free-market.can:2522
				local entity = target["entity"] -- models/free-market.can:2523
				if (not (entity and entity["valid"]) or entity["force"] == source) and Rget_type(id) == "text" then -- models/free-market.can:2524
					rendering_destroy(id) -- models/free-market.can:2525
					all_boxes[entity["unit_number"]] = nil -- models/free-market.can:2526
				end -- models/free-market.can:2526
			end -- models/free-market.can:2526
		end -- models/free-market.can:2526
	end -- models/free-market.can:2526
	check_forces() -- models/free-market.can:2531
end -- models/free-market.can:2531
local function on_force_cease_fire_changed(event) -- models/free-market.can:2534
	local force_index = event["force"]["index"] -- models/free-market.can:2535
	local other_force_index = event["other_force"]["index"] -- models/free-market.can:2536
	if event["added"] then -- models/free-market.can:2537
		embargoes[force_index][other_force_index] = nil -- models/free-market.can:2538
	else -- models/free-market.can:2538
		embargoes[force_index][other_force_index] = true -- models/free-market.can:2540
	end -- models/free-market.can:2540
end -- models/free-market.can:2540
local function set_transfer_box_key_pressed(event) -- models/free-market.can:2544
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2545
	local entity = player["selected"] -- models/free-market.can:2546
	if not (entity and entity["valid"]) then -- models/free-market.can:2547
		return  -- models/free-market.can:2547
	end -- models/free-market.can:2547
	if not entity["operable"] then -- models/free-market.can:2548
		return  -- models/free-market.can:2548
	end -- models/free-market.can:2548
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2549
		return  -- models/free-market.can:2549
	end -- models/free-market.can:2549
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2550
		return  -- models/free-market.can:2550
	end -- models/free-market.can:2550
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2552
	if box_data then -- models/free-market.can:2553
		local item_name = box_data[5] -- models/free-market.can:2554
		local box_type = box_data[3] -- models/free-market.can:2555
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2557
		elseif box_type == 4 or box_type == 5 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2559
		end -- models/free-market.can:2559
		return  -- models/free-market.can:2561
	end -- models/free-market.can:2561
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2564
	if not item["valid_for_read"] then -- models/free-market.can:2565
		player["print"]({ -- models/free-market.can:2566
			"multiplayer.no-address", -- models/free-market.can:2566
			{ "item" } -- models/free-market.can:2566
		}) -- models/free-market.can:2566
		return  -- models/free-market.can:2567
	end -- models/free-market.can:2567
	set_transfer_box_data(item["name"], player, entity) -- models/free-market.can:2570
end -- models/free-market.can:2570
local function set_bin_box_key_pressed(event) -- models/free-market.can:2573
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2574
	local entity = player["selected"] -- models/free-market.can:2575
	if not (entity and entity["valid"]) then -- models/free-market.can:2576
		return  -- models/free-market.can:2576
	end -- models/free-market.can:2576
	if not entity["operable"] then -- models/free-market.can:2577
		return  -- models/free-market.can:2577
	end -- models/free-market.can:2577
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2578
		return  -- models/free-market.can:2578
	end -- models/free-market.can:2578
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2579
		return  -- models/free-market.can:2579
	end -- models/free-market.can:2579
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2581
		return  -- models/free-market.can:2582
	end -- models/free-market.can:2582
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2585
	if not item["valid_for_read"] then -- models/free-market.can:2586
		player["print"]({ -- models/free-market.can:2587
			"multiplayer.no-address", -- models/free-market.can:2587
			{ "item" } -- models/free-market.can:2587
		}) -- models/free-market.can:2587
		return  -- models/free-market.can:2588
	end -- models/free-market.can:2588
	set_bin_box_data(item["name"], player, entity) -- models/free-market.can:2591
end -- models/free-market.can:2591
local function set_universal_transfer_box_key_pressed(event) -- models/free-market.can:2594
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2595
	local entity = player["selected"] -- models/free-market.can:2596
	if not (entity and entity["valid"]) then -- models/free-market.can:2597
		return  -- models/free-market.can:2597
	end -- models/free-market.can:2597
	if not entity["operable"] then -- models/free-market.can:2598
		return  -- models/free-market.can:2598
	end -- models/free-market.can:2598
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2599
		return  -- models/free-market.can:2599
	end -- models/free-market.can:2599
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2600
		return  -- models/free-market.can:2600
	end -- models/free-market.can:2600
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2602
	if box_data == nil then -- models/free-market.can:2603
		set_universal_transfer_box_data(player, entity) -- models/free-market.can:2604
	else -- models/free-market.can:2604
		local item_name = box_data[5] -- models/free-market.can:2606
		local box_type = box_data[3] -- models/free-market.can:2607
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2609
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2611
		end -- models/free-market.can:2611
	end -- models/free-market.can:2611
end -- models/free-market.can:2611
local function set_universal_bin_box_key_pressed(event) -- models/free-market.can:2616
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2617
	local entity = player["selected"] -- models/free-market.can:2618
	if not (entity and entity["valid"]) then -- models/free-market.can:2619
		return  -- models/free-market.can:2619
	end -- models/free-market.can:2619
	if not entity["operable"] then -- models/free-market.can:2620
		return  -- models/free-market.can:2620
	end -- models/free-market.can:2620
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2621
		return  -- models/free-market.can:2621
	end -- models/free-market.can:2621
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2622
		return  -- models/free-market.can:2622
	end -- models/free-market.can:2622
	if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:2624
		set_universal_bin_box_data(player, entity) -- models/free-market.can:2625
	end -- models/free-market.can:2625
end -- models/free-market.can:2625
local function set_pull_box_key_pressed(event) -- models/free-market.can:2629
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2630
	local entity = player["selected"] -- models/free-market.can:2631
	if not (entity and entity["valid"]) then -- models/free-market.can:2632
		return  -- models/free-market.can:2632
	end -- models/free-market.can:2632
	if not entity["operable"] then -- models/free-market.can:2633
		return  -- models/free-market.can:2633
	end -- models/free-market.can:2633
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2634
		return  -- models/free-market.can:2634
	end -- models/free-market.can:2634
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2635
		return  -- models/free-market.can:2635
	end -- models/free-market.can:2635
	if all_boxes[entity["unit_number"]] then -- models/free-market.can:2637
		return  -- models/free-market.can:2638
	end -- models/free-market.can:2638
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2641
	if not item["valid_for_read"] then -- models/free-market.can:2642
		player["print"]({ -- models/free-market.can:2643
			"multiplayer.no-address", -- models/free-market.can:2643
			{ "item" } -- models/free-market.can:2643
		}) -- models/free-market.can:2643
		return  -- models/free-market.can:2644
	end -- models/free-market.can:2644
	set_pull_box_data(item["name"], player, entity) -- models/free-market.can:2647
end -- models/free-market.can:2647
local function set_buy_box_key_pressed(event) -- models/free-market.can:2650
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2651
	local entity = player["selected"] -- models/free-market.can:2652
	if not (entity and entity["valid"]) then -- models/free-market.can:2653
		return  -- models/free-market.can:2653
	end -- models/free-market.can:2653
	if not entity["operable"] then -- models/free-market.can:2654
		return  -- models/free-market.can:2654
	end -- models/free-market.can:2654
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:2655
		return  -- models/free-market.can:2655
	end -- models/free-market.can:2655
	if get_distance(player["position"], entity["position"]) > 30 then -- models/free-market.can:2656
		return  -- models/free-market.can:2656
	end -- models/free-market.can:2656
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2658
	if box_data then -- models/free-market.can:2659
		local item_name = box_data[5] -- models/free-market.can:2660
		local box_type = box_data[3] -- models/free-market.can:2661
		if box_type == 1 then -- models/free-market.can:1
			check_buy_price(player, item_name) -- models/free-market.can:2663
		elseif box_type == 4 then -- models/free-market.can:1
			check_sell_price(player, item_name) -- models/free-market.can:2665
		end -- models/free-market.can:2665
		return  -- models/free-market.can:2667
	end -- models/free-market.can:2667
	local item = entity["get_inventory"](1)[1] -- models/free-market.can:2670
	if not item["valid_for_read"] then -- models/free-market.can:2671
		player["print"]({ -- models/free-market.can:2672
			"multiplayer.no-address", -- models/free-market.can:2672
			{ "item" } -- models/free-market.can:2672
		}) -- models/free-market.can:2672
		return  -- models/free-market.can:2673
	end -- models/free-market.can:2673
	set_buy_box_data(item["name"], player, entity) -- models/free-market.can:2676
end -- models/free-market.can:2676
local function on_gui_elem_changed(event) -- models/free-market.can:2679
	local element = event["element"] -- models/free-market.can:2680
	if not (element and element["valid"]) then -- models/free-market.can:2681
		return  -- models/free-market.can:2681
	end -- models/free-market.can:2681
	if element["name"] ~= "FM_prices_item" then -- models/free-market.can:2682
		return  -- models/free-market.can:2682
	end -- models/free-market.can:2682
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:2683
	if not (player and player["valid"]) then -- models/free-market.can:2684
		return  -- models/free-market.can:2684
	end -- models/free-market.can:2684
	local item_row = element["parent"] -- models/free-market.can:2686
	local content_flow = item_row["parent"] -- models/free-market.can:2687
	local storage_row = content_flow["storage_row"] -- models/free-market.can:2688
	local item_name = element["elem_value"] -- models/free-market.can:2689
	if item_name == nil then -- models/free-market.can:2690
		item_row["sell_price"]["text"] = "" -- models/free-market.can:2691
		item_row["buy_price"]["text"] = "" -- models/free-market.can:2692
		local prices_table = content_flow["other_prices_frame"]["scroll-pane"]["prices_table"] -- models/free-market.can:2693
		prices_table["clear"]() -- models/free-market.can:2694
		make_prices_header(prices_table) -- models/free-market.can:2695
		storage_row["visible"] = false -- models/free-market.can:2696
		return  -- models/free-market.can:2697
	end -- models/free-market.can:2697
	local force_index = player["force"]["index"] -- models/free-market.can:2700
	storage_row["visible"] = true -- models/free-market.can:2702
	local count = storages[force_index][item_name] or 0 -- models/free-market.can:2703
	storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:2704
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:2705
	storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:2706
	item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:2708
	item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:2709
	update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2710
end -- models/free-market.can:2710
local function on_gui_selection_state_changed(event) -- models/free-market.can:2713
	local element = event["element"] -- models/free-market.can:2714
	if not (element and element["valid"]) then -- models/free-market.can:2715
		return  -- models/free-market.can:2715
	end -- models/free-market.can:2715
	if element["name"] ~= "FM_force_price_list" then -- models/free-market.can:2716
		return  -- models/free-market.can:2716
	end -- models/free-market.can:2716
	local scroll_pane = element["parent"]["parent"]["deep_frame"]["scroll-pane"] -- models/free-market.can:2718
	local force = game["forces"][element["items"][element["selected_index"]]] -- models/free-market.can:2719
	if force == nil then -- models/free-market.can:2720
		scroll_pane["clear"]() -- models/free-market.can:2721
		make_price_list_header(scroll_pane) -- models/free-market.can:2722
		return  -- models/free-market.can:2723
	end -- models/free-market.can:2723
	update_price_list_table(force, scroll_pane) -- models/free-market.can:2726
end -- models/free-market.can:2726
local GUIS = { -- models/free-market.can:2730
	[""] = function(element, player) -- models/free-market.can:2731
		if element["type"] ~= "sprite-button" then -- models/free-market.can:2732
			return  -- models/free-market.can:2732
		end -- models/free-market.can:2732
		local parent_name = element["parent"]["name"] -- models/free-market.can:2733
		if parent_name == "price_list_table" then -- models/free-market.can:2734
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2735
			local force_index = player["force"]["index"] -- models/free-market.can:2736
			local prices_frame = player["gui"]["screen"]["FM_prices_frame"] -- models/free-market.can:2737
			if prices_frame == nil then -- models/free-market.can:2738
				switch_prices_gui(player, item_name) -- models/free-market.can:2739
			else -- models/free-market.can:2739
				local content_flow = prices_frame["shallow_frame"]["content_flow"] -- models/free-market.can:2741
				content_flow["item_row"]["FM_prices_item"]["elem_value"] = item_name -- models/free-market.can:2742
				local sell_price = sell_prices[force_index][item_name] -- models/free-market.can:2743
				content_flow["item_row"]["sell_price"]["text"] = tostring(sell_price or "") -- models/free-market.can:2744
				local buy_price = buy_prices[force_index][item_name] -- models/free-market.can:2745
				content_flow["item_row"]["buy_price"]["text"] = tostring(buy_price or "") -- models/free-market.can:2746
				update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:2747
			end -- models/free-market.can:2747
		elseif parent_name == "FM_storage_table" then -- models/free-market.can:2749
			local item_name = sub(element["sprite"], 6) -- models/free-market.can:2750
			switch_prices_gui(player, item_name) -- models/free-market.can:2751
		end -- models/free-market.can:2751
	end, -- models/free-market.can:2751
	["FM_close"] = function(element) -- models/free-market.can:2754
		element["parent"]["parent"]["destroy"]() -- models/free-market.can:2755
	end, -- models/free-market.can:2755
	["FM_confirm_default_limit"] = function(element, player) -- models/free-market.can:2757
		local setting_row = element["parent"] -- models/free-market.can:2758
		local default_limit = tonumber(setting_row["FM_default_limit"]["text"]) -- models/free-market.can:2759
		if default_limit == nil or default_limit < 1 or default_limit > max_storage_threshold then -- models/free-market.can:2760
			player["print"]({ -- models/free-market.can:2761
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2761
				default_limit or "", -- models/free-market.can:2761
				1, -- models/free-market.can:2761
				max_storage_threshold -- models/free-market.can:2761
			}) -- models/free-market.can:2761
			return  -- models/free-market.can:2762
		end -- models/free-market.can:2762
		local force_index = player["force"]["index"] -- models/free-market.can:2765
		default_storage_limit[force_index] = default_limit -- models/free-market.can:2766
	end, -- models/free-market.can:2766
	["FM_confirm_storage_limit"] = function(element, player) -- models/free-market.can:2768
		local storage_row = element["parent"] -- models/free-market.can:2769
		local storage_limit = tonumber(storage_row["storage_limit"]["text"]) -- models/free-market.can:2770
		if storage_limit == nil or storage_limit < 1 or storage_limit > max_storage_threshold then -- models/free-market.can:2771
			player["print"]({ -- models/free-market.can:2772
				"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2772
				storage_limit or "", -- models/free-market.can:2772
				1, -- models/free-market.can:2772
				max_storage_threshold -- models/free-market.can:2772
			}) -- models/free-market.can:2772
			return  -- models/free-market.can:2773
		end -- models/free-market.can:2773
		local item_name = storage_row["parent"]["item_row"]["FM_prices_item"]["elem_value"] -- models/free-market.can:2776
		if item_name == nil then -- models/free-market.can:2777
			return  -- models/free-market.can:2777
		end -- models/free-market.can:2777
		local force_index = player["force"]["index"] -- models/free-market.can:2779
		storages_limit[force_index][item_name] = storage_limit -- models/free-market.can:2780
	end, -- models/free-market.can:2780
	["FM_confirm_buy_box"] = function(element, player) -- models/free-market.can:2782
		local parent = element["parent"] -- models/free-market.can:2783
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:2784
		if count == nil then -- models/free-market.can:2786
			player["print"]({ -- models/free-market.can:2787
				"multiplayer.no-address", -- models/free-market.can:2787
				{ "gui-train.add-item-count-condition" } -- models/free-market.can:2787
			}) -- models/free-market.can:2787
			return  -- models/free-market.can:2788
		elseif count < 1 then -- models/free-market.can:2789
			player["print"]({ -- models/free-market.can:2790
				"count-must-be-more-n", -- models/free-market.can:2790
				0 -- models/free-market.can:2790
			}) -- models/free-market.can:2790
			return  -- models/free-market.can:2791
		end -- models/free-market.can:2791
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2794
		if not item_name then -- models/free-market.can:2795
			player["print"]({ -- models/free-market.can:2796
				"multiplayer.no-address", -- models/free-market.can:2796
				{ "item" } -- models/free-market.can:2796
			}) -- models/free-market.can:2796
			return  -- models/free-market.can:2797
		end -- models/free-market.can:2797
		local box_operations = parent["parent"] -- models/free-market.can:2800
		local player_index = player["index"] -- models/free-market.can:2801
		local entity = open_box[player_index] -- models/free-market.can:2802
		if entity then -- models/free-market.can:2803
			local inventory_size = # entity["get_inventory"](1) -- models/free-market.can:1
			local max_count = game["item_prototypes"][item_name]["stack_size"] * inventory_size -- models/free-market.can:2805
			if count > max_count then -- models/free-market.can:2806
				player["print"]({ -- models/free-market.can:2807
					"gui-map-generator.invalid-value-for-field", -- models/free-market.can:2807
					count, -- models/free-market.can:2807
					1, -- models/free-market.can:2807
					max_count -- models/free-market.can:2807
				}) -- models/free-market.can:2807
				parent["count"]["text"] = tostring(max_count) -- models/free-market.can:2808
				return  -- models/free-market.can:2809
			end -- models/free-market.can:2809
			set_buy_box_data(item_name, player, entity, count) -- models/free-market.can:2812
			box_operations["clear"]() -- models/free-market.can:2813
			check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2814
		else -- models/free-market.can:2814
			box_operations["clear"]() -- models/free-market.can:2816
			player["print"]({ -- models/free-market.can:2817
				"multiplayer.no-address", -- models/free-market.can:2817
				{ "item-name.linked-chest" } -- models/free-market.can:2817
			}) -- models/free-market.can:2817
		end -- models/free-market.can:2817
		if # box_operations["children"] == 0 then -- models/free-market.can:2820
			open_box[player_index] = nil -- models/free-market.can:2821
		end -- models/free-market.can:2821
	end, -- models/free-market.can:2821
	["FM_confirm_buy_price_for_chest"] = function(element, player) -- models/free-market.can:2824
		local box_operations = element["parent"] -- models/free-market.can:2825
		local entity = open_box[player["index"]] -- models/free-market.can:2826
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2827
		if box_data == nil then -- models/free-market.can:2828
			box_operations["clear"]() -- models/free-market.can:2830
			return  -- models/free-market.can:2831
		end -- models/free-market.can:2831
		local buy_price = tonumber(box_operations["buy_price"]["text"]) -- models/free-market.can:2834
		if not buy_price then -- models/free-market.can:2835
			box_operations["clear"]() -- models/free-market.can:2836
		elseif buy_price < 1 then -- models/free-market.can:2837
			player["print"]({ -- models/free-market.can:2839
				"count-must-be-more-n", -- models/free-market.can:2839
				0 -- models/free-market.can:2839
			}) -- models/free-market.can:2839
			return  -- models/free-market.can:2840
		end -- models/free-market.can:2840
		local item_name = box_data[5] -- models/free-market.can:2843
		change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:2844
		box_operations["clear"]() -- models/free-market.can:2845
	end, -- models/free-market.can:2845
	["FM_confirm_transfer_box"] = function(element, player) -- models/free-market.can:2847
		local parent = element["parent"] -- models/free-market.can:2848
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2849
		if not item_name then -- models/free-market.can:2850
			player["print"]({ -- models/free-market.can:2851
				"multiplayer.no-address", -- models/free-market.can:2851
				{ "item" } -- models/free-market.can:2851
			}) -- models/free-market.can:2851
			return  -- models/free-market.can:2852
		end -- models/free-market.can:2852
		local box_operations = parent["parent"] -- models/free-market.can:2855
		local player_index = player["index"] -- models/free-market.can:2856
		local entity = open_box[player_index] -- models/free-market.can:2857
		if entity then -- models/free-market.can:2858
			set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2859
			box_operations["clear"]() -- models/free-market.can:2860
			check_sell_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:2861
		else -- models/free-market.can:2861
			box_operations["clear"]() -- models/free-market.can:2863
			player["print"]({ -- models/free-market.can:2864
				"multiplayer.no-address", -- models/free-market.can:2864
				{ "item-name.linked-chest" } -- models/free-market.can:2864
			}) -- models/free-market.can:2864
		end -- models/free-market.can:2864
		if # box_operations["children"] == 0 then -- models/free-market.can:2867
			open_box[player_index] = nil -- models/free-market.can:2868
		end -- models/free-market.can:2868
	end, -- models/free-market.can:2868
	["FM_confirm_bin_box"] = function(element, player) -- models/free-market.can:2871
		local parent = element["parent"] -- models/free-market.can:2872
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2873
		if not item_name then -- models/free-market.can:2874
			player["print"]({ -- models/free-market.can:2875
				"multiplayer.no-address", -- models/free-market.can:2875
				{ "item" } -- models/free-market.can:2875
			}) -- models/free-market.can:2875
			return  -- models/free-market.can:2876
		end -- models/free-market.can:2876
		local box_operations = parent["parent"] -- models/free-market.can:2879
		local player_index = player["index"] -- models/free-market.can:2880
		local entity = open_box[player_index] -- models/free-market.can:2881
		if entity then -- models/free-market.can:2882
			set_bin_box_data(item_name, player, entity) -- models/free-market.can:2883
		else -- models/free-market.can:2883
			player["print"]({ -- models/free-market.can:2885
				"multiplayer.no-address", -- models/free-market.can:2885
				{ "item-name.linked-chest" } -- models/free-market.can:2885
			}) -- models/free-market.can:2885
		end -- models/free-market.can:2885
		box_operations["clear"]() -- models/free-market.can:2887
		open_box[player_index] = nil -- models/free-market.can:2888
	end, -- models/free-market.can:2888
	["FM_confirm_sell_price_for_chest"] = function(element, player) -- models/free-market.can:2890
		local box_operations = element["parent"] -- models/free-market.can:2891
		local entity = open_box[player["index"]] -- models/free-market.can:2892
		local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2893
		if box_data == nil then -- models/free-market.can:2894
			box_operations["clear"]() -- models/free-market.can:2896
			return  -- models/free-market.can:2897
		end -- models/free-market.can:2897
		local sell_price = tonumber(box_operations["sell_price"]["text"]) -- models/free-market.can:2900
		if not sell_price then -- models/free-market.can:2901
			box_operations["clear"]() -- models/free-market.can:2902
		elseif sell_price < 1 then -- models/free-market.can:2903
			player["print"]({ -- models/free-market.can:2905
				"count-must-be-more-n", -- models/free-market.can:2905
				0 -- models/free-market.can:2905
			}) -- models/free-market.can:2905
			return  -- models/free-market.can:2906
		end -- models/free-market.can:2906
		local item_name = box_data[5] -- models/free-market.can:2909
		change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:2910
		box_operations["clear"]() -- models/free-market.can:2911
	end, -- models/free-market.can:2911
	["FM_confirm_pull_box"] = function(element, player) -- models/free-market.can:2913
		local parent = element["parent"] -- models/free-market.can:2914
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2915
		if not item_name then -- models/free-market.can:2916
			player["print"]({ -- models/free-market.can:2917
				"multiplayer.no-address", -- models/free-market.can:2917
				{ "item" } -- models/free-market.can:2917
			}) -- models/free-market.can:2917
			return  -- models/free-market.can:2918
		end -- models/free-market.can:2918
		local player_index = player["index"] -- models/free-market.can:2921
		local entity = open_box[player_index] -- models/free-market.can:2922
		if entity then -- models/free-market.can:2923
			set_pull_box_data(item_name, player, entity) -- models/free-market.can:2924
		else -- models/free-market.can:2924
			player["print"]({ -- models/free-market.can:2926
				"multiplayer.no-address", -- models/free-market.can:2926
				{ "item-name.linked-chest" } -- models/free-market.can:2926
			}) -- models/free-market.can:2926
		end -- models/free-market.can:2926
		open_box[player_index] = nil -- models/free-market.can:2928
		local box_operations = parent["parent"] -- models/free-market.can:2929
		box_operations["clear"]() -- models/free-market.can:2930
	end, -- models/free-market.can:2930
	["FM_change_transfer_box"] = function(element, player) -- models/free-market.can:2932
		local parent = element["parent"] -- models/free-market.can:2933
		local player_index = player["index"] -- models/free-market.can:2934
		local entity = open_box[player_index] -- models/free-market.can:2935
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2936
		if entity then -- models/free-market.can:2937
			local player_force = player["force"] -- models/free-market.can:2938
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2939
			if item_name then -- models/free-market.can:2940
				if box_data and box_data[3] == 4 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2942
					remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2943
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:2944
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2945
				else -- models/free-market.can:2945
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2947
				end -- models/free-market.can:2947
			else -- models/free-market.can:2947
				rendering_destroy(box_data[2]) -- models/free-market.can:2950
				remove_certain_transfer_box(entity, box_data) -- models/free-market.can:2951
			end -- models/free-market.can:2951
		else -- models/free-market.can:2951
			player["print"]({ -- models/free-market.can:2954
				"multiplayer.no-address", -- models/free-market.can:2954
				{ "item-name.linked-chest" } -- models/free-market.can:2954
			}) -- models/free-market.can:2954
		end -- models/free-market.can:2954
		open_box[player_index] = nil -- models/free-market.can:2956
		local box_operations = element["parent"]["parent"] -- models/free-market.can:2957
		box_operations["clear"]() -- models/free-market.can:2958
	end, -- models/free-market.can:2958
	["FM_change_bin_box"] = function(element, player) -- models/free-market.can:2960
		local parent = element["parent"] -- models/free-market.can:2961
		local player_index = player["index"] -- models/free-market.can:2962
		local entity = open_box[player_index] -- models/free-market.can:2963
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2964
		if entity then -- models/free-market.can:2965
			local player_force = player["force"] -- models/free-market.can:2966
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2967
			if item_name then -- models/free-market.can:2968
				if box_data and box_data[3] == 6 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2970
					remove_certain_bin_box(entity, box_data) -- models/free-market.can:2971
					set_bin_box_data(item_name, player, entity) -- models/free-market.can:2972
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:2973
				else -- models/free-market.can:2973
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:2975
				end -- models/free-market.can:2975
			else -- models/free-market.can:2975
				rendering_destroy(box_data[2]) -- models/free-market.can:2978
				remove_certain_bin_box(entity, box_data) -- models/free-market.can:2979
			end -- models/free-market.can:2979
		else -- models/free-market.can:2979
			player["print"]({ -- models/free-market.can:2982
				"multiplayer.no-address", -- models/free-market.can:2982
				{ "item-name.linked-chest" } -- models/free-market.can:2982
			}) -- models/free-market.can:2982
		end -- models/free-market.can:2982
		open_box[player_index] = nil -- models/free-market.can:2984
		local box_operations = element["parent"]["parent"] -- models/free-market.can:2985
		box_operations["clear"]() -- models/free-market.can:2986
	end, -- models/free-market.can:2986
	["FM_change_pull_box"] = function(element, player) -- models/free-market.can:2988
		local parent = element["parent"] -- models/free-market.can:2989
		local player_index = player["index"] -- models/free-market.can:2990
		local entity = open_box[player_index] -- models/free-market.can:2991
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:2992
		if entity then -- models/free-market.can:2993
			local player_force = player["force"] -- models/free-market.can:2994
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:2995
			if item_name then -- models/free-market.can:2996
				if box_data and box_data[3] == 3 then -- models/free-market.can:1
					rendering_destroy(box_data[2]) -- models/free-market.can:2998
					remove_certain_pull_box(entity, box_data) -- models/free-market.can:2999
					set_pull_box_data(item_name, player, entity) -- models/free-market.can:3000
					show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3001
				else -- models/free-market.can:3001
					player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3003
				end -- models/free-market.can:3003
			else -- models/free-market.can:3003
				rendering_destroy(box_data[2]) -- models/free-market.can:3006
				remove_certain_pull_box(entity, box_data) -- models/free-market.can:3007
			end -- models/free-market.can:3007
		else -- models/free-market.can:3007
			player["print"]({ -- models/free-market.can:3010
				"multiplayer.no-address", -- models/free-market.can:3010
				{ "item-name.linked-chest" } -- models/free-market.can:3010
			}) -- models/free-market.can:3010
		end -- models/free-market.can:3010
		open_box[player_index] = nil -- models/free-market.can:3012
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3013
		box_operations["clear"]() -- models/free-market.can:3014
	end, -- models/free-market.can:3014
	["FM_change_buy_box"] = function(element, player) -- models/free-market.can:3016
		local parent = element["parent"] -- models/free-market.can:3017
		local player_index = player["index"] -- models/free-market.can:3018
		local entity = open_box[player_index] -- models/free-market.can:3019
		local count = tonumber(parent["count"]["text"]) -- models/free-market.can:3020
		local item_name = parent["FM_item"]["elem_value"] -- models/free-market.can:3021
		if entity then -- models/free-market.can:3022
			local player_force = player["force"] -- models/free-market.can:3023
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3024
			if item_name and count then -- models/free-market.can:3025
				local prev_item_name = box_data[5] -- models/free-market.can:3026
				if prev_item_name == item_name then -- models/free-market.can:3027
					change_count_in_buy_box_data(entity, item_name, count) -- models/free-market.can:3028
				else -- models/free-market.can:3028
					if box_data and box_data[3] == 1 then -- models/free-market.can:1
						rendering_destroy(box_data[2]) -- models/free-market.can:3031
						remove_certain_buy_box(entity, box_data) -- models/free-market.can:3032
						set_buy_box_data(item_name, player, entity) -- models/free-market.can:3033
						show_item_sprite_above_chest(item_name, player_force, entity) -- models/free-market.can:3034
					else -- models/free-market.can:3034
						player["print"]({ "gui-train.invalid" }) -- models/free-market.can:3036
					end -- models/free-market.can:3036
				end -- models/free-market.can:3036
			else -- models/free-market.can:3036
				rendering_destroy(box_data[2]) -- models/free-market.can:3040
				remove_certain_buy_box(entity, box_data) -- models/free-market.can:3041
			end -- models/free-market.can:3041
		else -- models/free-market.can:3041
			player["print"]({ -- models/free-market.can:3044
				"multiplayer.no-address", -- models/free-market.can:3044
				{ "item-name.linked-chest" } -- models/free-market.can:3044
			}) -- models/free-market.can:3044
		end -- models/free-market.can:3044
		open_box[player_index] = nil -- models/free-market.can:3046
		local box_operations = element["parent"]["parent"] -- models/free-market.can:3047
		box_operations["clear"]() -- models/free-market.can:3048
	end, -- models/free-market.can:3048
	["FM_confirm_sell_price"] = function(element, player) -- models/free-market.can:3050
		local parent = element["parent"] -- models/free-market.can:3051
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3052
		if item_name == nil then -- models/free-market.can:3053
			return  -- models/free-market.can:3053
		end -- models/free-market.can:3053
		local sell_price_element = parent["sell_price"] -- models/free-market.can:3055
		local sell_price = tonumber(sell_price_element["text"]) -- models/free-market.can:3056
		local prev_sell_price = change_sell_price_by_player(item_name, player, sell_price) -- models/free-market.can:3057
		if prev_sell_price then -- models/free-market.can:3058
			sell_price_element["text"] = tostring(prev_sell_price) -- models/free-market.can:3059
		end -- models/free-market.can:3059
	end, -- models/free-market.can:3059
	["FM_confirm_buy_price"] = function(element, player) -- models/free-market.can:3062
		local parent = element["parent"] -- models/free-market.can:3063
		local item_name = parent["FM_prices_item"]["elem_value"] -- models/free-market.can:3064
		if item_name == nil then -- models/free-market.can:3065
			return  -- models/free-market.can:3065
		end -- models/free-market.can:3065
		local buy_price_element = parent["buy_price"] -- models/free-market.can:3067
		local buy_price = tonumber(buy_price_element["text"]) -- models/free-market.can:3068
		local prev_buy_price = change_buy_price_by_player(item_name, player, buy_price) -- models/free-market.can:3069
		if prev_buy_price then -- models/free-market.can:3070
			buy_price_element["text"] = tostring(prev_buy_price) -- models/free-market.can:3071
		end -- models/free-market.can:3071
	end, -- models/free-market.can:3071
	["FM_refresh_prices_table"] = function(element, player) -- models/free-market.can:3074
		local content_flow = element["parent"]["parent"]["shallow_frame"]["content_flow"] -- models/free-market.can:3075
		local item_row = content_flow["item_row"] -- models/free-market.can:3076
		local item_name = item_row["FM_prices_item"]["elem_value"] -- models/free-market.can:3077
		if item_name == nil then -- models/free-market.can:3078
			return  -- models/free-market.can:3078
		end -- models/free-market.can:3078
		local force_index = player["force"]["index"] -- models/free-market.can:3080
		item_row["buy_price"]["text"] = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or "") -- models/free-market.can:3081
		item_row["sell_price"]["text"] = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or "") -- models/free-market.can:3082
		local storage_row = content_flow["storage_row"] -- models/free-market.can:3084
		local count = storages[force_index][item_name] or 0 -- models/free-market.can:3085
		storage_row["storage_count"]["caption"] = tostring(count) -- models/free-market.can:3086
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold -- models/free-market.can:3087
		storage_row["storage_limit"]["text"] = tostring(limit) -- models/free-market.can:3088
		update_prices_table(player, item_name, content_flow["other_prices_frame"]["scroll-pane"]["prices_table"]) -- models/free-market.can:3090
	end, -- models/free-market.can:3090
	["FM_set_transfer_box"] = function(element, player) -- models/free-market.can:3092
		local entity = player["opened"] -- models/free-market.can:3093
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3095
			if player["force"] ~= entity["force"] then -- models/free-market.can:3096
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3097
				return  -- models/free-market.can:3098
			end -- models/free-market.can:3098
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3101
			if box_data then -- models/free-market.can:3102
				local box_type = box_data[3] -- models/free-market.can:3103
				if box_type == 4 then -- models/free-market.can:1
					open_transfer_box_gui(player, false, entity) -- models/free-market.can:3105
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3107
					return  -- models/free-market.can:3108
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3110
					return  -- models/free-market.can:3111
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3113
					return  -- models/free-market.can:3114
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3116
					return  -- models/free-market.can:3117
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3119
					return  -- models/free-market.can:3120
				end -- models/free-market.can:3120
			else -- models/free-market.can:3120
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3123
				if not item["valid_for_read"] then -- models/free-market.can:3124
					open_transfer_box_gui(player, true) -- models/free-market.can:3125
				else -- models/free-market.can:3125
					local item_name = item["name"] -- models/free-market.can:3127
					set_transfer_box_data(item_name, player, entity) -- models/free-market.can:3128
					check_sell_price(player, item_name) -- models/free-market.can:3129
				end -- models/free-market.can:3129
			end -- models/free-market.can:3129
			open_box[player["index"]] = entity -- models/free-market.can:3132
		end -- models/free-market.can:3132
	end, -- models/free-market.can:3132
	["FM_set_universal_transfer_box"] = function(element, player) -- models/free-market.can:3135
		local entity = player["opened"] -- models/free-market.can:3136
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3138
			if player["force"] ~= entity["force"] then -- models/free-market.can:3139
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3140
				return  -- models/free-market.can:3141
			end -- models/free-market.can:3141
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3144
			if box_data then -- models/free-market.can:3145
				local box_type = box_data[3] -- models/free-market.can:3146
				if box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3148
					return  -- models/free-market.can:3149
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3151
					return  -- models/free-market.can:3152
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3154
					return  -- models/free-market.can:3155
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3157
					return  -- models/free-market.can:3158
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3160
					return  -- models/free-market.can:3161
				end -- models/free-market.can:3161
			else -- models/free-market.can:3161
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3164
			end -- models/free-market.can:3164
			open_box[player["index"]] = entity -- models/free-market.can:3166
		end -- models/free-market.can:3166
	end, -- models/free-market.can:3166
	["FM_set_bin_box"] = function(element, player) -- models/free-market.can:3169
		local entity = player["opened"] -- models/free-market.can:3170
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3172
			if player["force"] ~= entity["force"] then -- models/free-market.can:3173
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3174
				return  -- models/free-market.can:3175
			end -- models/free-market.can:3175
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3178
			if box_data then -- models/free-market.can:3179
				local box_type = box_data[3] -- models/free-market.can:3180
				if box_type == 6 then -- models/free-market.can:1
					open_bin_box_gui(player, false, entity) -- models/free-market.can:3182
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3184
					return  -- models/free-market.can:3185
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3187
					return  -- models/free-market.can:3188
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3190
					return  -- models/free-market.can:3191
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3193
					return  -- models/free-market.can:3194
				end -- models/free-market.can:3194
			else -- models/free-market.can:3194
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3197
				if not item["valid_for_read"] then -- models/free-market.can:3198
					open_bin_box_gui(player, true) -- models/free-market.can:3199
				else -- models/free-market.can:3199
					set_bin_box_data(item["name"], player, entity) -- models/free-market.can:3201
				end -- models/free-market.can:3201
			end -- models/free-market.can:3201
			open_box[player["index"]] = entity -- models/free-market.can:3204
		end -- models/free-market.can:3204
	end, -- models/free-market.can:3204
	["FM_set_universal_bin_box"] = function(element, player) -- models/free-market.can:3207
		local entity = player["opened"] -- models/free-market.can:3208
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3210
			if player["force"] ~= entity["force"] then -- models/free-market.can:3211
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3212
				return  -- models/free-market.can:3213
			end -- models/free-market.can:3213
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3216
			if box_data then -- models/free-market.can:3217
				local box_type = box_data[3] -- models/free-market.can:3218
				if box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3220
					return  -- models/free-market.can:3221
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3223
					return  -- models/free-market.can:3224
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3226
					return  -- models/free-market.can:3227
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3229
					return  -- models/free-market.can:3230
				end -- models/free-market.can:3230
			else -- models/free-market.can:3230
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3233
			end -- models/free-market.can:3233
			open_box[player["index"]] = entity -- models/free-market.can:3235
		end -- models/free-market.can:3235
	end, -- models/free-market.can:3235
	["FM_set_pull_box"] = function(element, player) -- models/free-market.can:3238
		local entity = player["opened"] -- models/free-market.can:3239
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3241
			if player["force"] ~= entity["force"] then -- models/free-market.can:3242
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3243
				return  -- models/free-market.can:3244
			end -- models/free-market.can:3244
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3247
			if box_data then -- models/free-market.can:3248
				local box_type = box_data[3] -- models/free-market.can:3249
				if box_type == 3 then -- models/free-market.can:1
					open_pull_box_gui(player, false, entity) -- models/free-market.can:3251
				elseif box_type == 1 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-buy-box" }) -- models/free-market.can:3253
					return  -- models/free-market.can:3254
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3256
					return  -- models/free-market.can:3257
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3259
					return  -- models/free-market.can:3260
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3262
					return  -- models/free-market.can:3263
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3265
					return  -- models/free-market.can:3266
				end -- models/free-market.can:3266
			else -- models/free-market.can:3266
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3269
				if not item["valid_for_read"] then -- models/free-market.can:3270
					open_pull_box_gui(player, true) -- models/free-market.can:3271
				else -- models/free-market.can:3271
					set_pull_box_data(item["name"], player, entity) -- models/free-market.can:3273
				end -- models/free-market.can:3273
			end -- models/free-market.can:3273
			open_box[player["index"]] = entity -- models/free-market.can:3276
		end -- models/free-market.can:3276
	end, -- models/free-market.can:3276
	["FM_set_buy_box"] = function(element, player) -- models/free-market.can:3279
		local entity = player["opened"] -- models/free-market.can:3280
		if ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3282
			if player["force"] ~= entity["force"] then -- models/free-market.can:3283
				player["print"]({ "free-market.you-cant-change" }) -- models/free-market.can:3284
				return  -- models/free-market.can:3285
			end -- models/free-market.can:3285
			local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3288
			if box_data then -- models/free-market.can:3289
				local box_type = box_data[3] -- models/free-market.can:3290
				if box_type == 1 then -- models/free-market.can:1
					open_buy_box_gui(player, false, entity) -- models/free-market.can:3292
				elseif box_type == 4 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-transfer-box" }) -- models/free-market.can:3294
					return  -- models/free-market.can:3295
				elseif box_type == 5 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-transfer-box" }) -- models/free-market.can:3297
					return  -- models/free-market.can:3298
				elseif box_type == 3 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-pull-box" }) -- models/free-market.can:3300
					return  -- models/free-market.can:3301
				elseif box_type == 6 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-bin-box" }) -- models/free-market.can:3303
					return  -- models/free-market.can:3304
				elseif box_type == 7 then -- models/free-market.can:1
					player["print"]({ "free-market.this-is-universal-bin-box" }) -- models/free-market.can:3306
					return  -- models/free-market.can:3307
				end -- models/free-market.can:3307
			else -- models/free-market.can:3307
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3310
				if not item["valid_for_read"] then -- models/free-market.can:3311
					open_buy_box_gui(player, true) -- models/free-market.can:3312
				else -- models/free-market.can:3312
					local box_operations = element["parent"]["parent"]["box_operations"] -- models/free-market.can:3314
					local item_name = item["name"] -- models/free-market.can:3315
					set_buy_box_data(item_name, player, entity) -- models/free-market.can:3316
					check_buy_price_for_opened_chest(player, box_operations, item_name) -- models/free-market.can:3317
				end -- models/free-market.can:3317
			end -- models/free-market.can:3317
			open_box[player["index"]] = entity -- models/free-market.can:3320
		end -- models/free-market.can:3320
	end, -- models/free-market.can:3320
	["FM_print_force_data"] = function(element, player) -- models/free-market.can:3323
		if player["admin"] then -- models/free-market.can:3324
			print_force_data(player["force"], player) -- models/free-market.can:3325
		else -- models/free-market.can:3325
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3327
		end -- models/free-market.can:3327
	end, -- models/free-market.can:3327
	["FM_clear_invalid_data"] = clear_invalid_data, -- models/free-market.can:3330
	["FM_reset_buy_prices"] = function(element, player) -- models/free-market.can:3331
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3332
			local force_index = player["force"]["index"] -- models/free-market.can:3333
			buy_prices[force_index] = {} -- models/free-market.can:3334
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3335
		else -- models/free-market.can:3335
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3337
		end -- models/free-market.can:3337
	end, -- models/free-market.can:3337
	["FM_reset_sell_prices"] = function(element, player) -- models/free-market.can:3340
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3341
			local force_index = player["force"]["index"] -- models/free-market.can:3342
			sell_prices[force_index] = {} -- models/free-market.can:3343
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3344
		else -- models/free-market.can:3344
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3346
		end -- models/free-market.can:3346
	end, -- models/free-market.can:3346
	["FM_reset_all_prices"] = function(element, player) -- models/free-market.can:3349
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3350
			local force_index = player["force"]["index"] -- models/free-market.can:3351
			inactive_sell_prices[force_index] = {} -- models/free-market.can:3352
			inactive_buy_prices[force_index] = {} -- models/free-market.can:3353
			sell_prices[force_index] = {} -- models/free-market.can:3354
			buy_prices[force_index] = {} -- models/free-market.can:3355
		else -- models/free-market.can:3355
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3357
		end -- models/free-market.can:3357
	end, -- models/free-market.can:3357
	["FM_reset_buy_boxes"] = function(element, player) -- models/free-market.can:3360
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3361
			resetBuyBoxes(player["force"]["index"]) -- models/free-market.can:3362
		else -- models/free-market.can:3362
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3364
		end -- models/free-market.can:3364
	end, -- models/free-market.can:3364
	["FM_reset_transfer_boxes"] = function(element, player) -- models/free-market.can:3367
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3368
			resetTransferBoxes(player["force"]["index"]) -- models/free-market.can:3369
		else -- models/free-market.can:3369
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3371
		end -- models/free-market.can:3371
	end, -- models/free-market.can:3371
	["FM_reset_universal_transfer_boxes"] = function(element, player) -- models/free-market.can:3374
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3375
			resetUniversalTransferBoxes(player["force"]["index"]) -- models/free-market.can:3376
		else -- models/free-market.can:3376
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3378
		end -- models/free-market.can:3378
	end, -- models/free-market.can:3378
	["FM_reset_bin_boxes"] = function(element, player) -- models/free-market.can:3381
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3382
			resetBinBoxes(player["force"]["index"]) -- models/free-market.can:3383
		else -- models/free-market.can:3383
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3385
		end -- models/free-market.can:3385
	end, -- models/free-market.can:3385
	["FM_reset_universal_bin_boxes"] = function(element, player) -- models/free-market.can:3388
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3389
			resetUniversalBinBoxes(player["force"]["index"]) -- models/free-market.can:3390
		else -- models/free-market.can:3390
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3392
		end -- models/free-market.can:3392
	end, -- models/free-market.can:3392
	["FM_reset_pull_boxes"] = function(element, player) -- models/free-market.can:3395
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3396
			resetPullBoxes(player["force"]["index"]) -- models/free-market.can:3397
		else -- models/free-market.can:3397
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3399
		end -- models/free-market.can:3399
	end, -- models/free-market.can:3399
	["FM_reset_all_boxes"] = function(element, player) -- models/free-market.can:3402
		if is_reset_public or # player["force"]["players"] == 1 or player["admin"] then -- models/free-market.can:3403
			resetAllBoxes(player["force"]["index"]) -- models/free-market.can:3404
		else -- models/free-market.can:3404
			player["print"]({ "command-output.parameters-require-admin" }) -- models/free-market.can:3406
		end -- models/free-market.can:3406
	end, -- models/free-market.can:3406
	["FM_declare_embargo"] = function(element, player) -- models/free-market.can:3409
		local table_element = element["parent"]["parent"] -- models/free-market.can:3410
		local forces_list = table_element["forces_list"] -- models/free-market.can:3411
		if forces_list["selected_index"] == 0 then -- models/free-market.can:3412
			return  -- models/free-market.can:3412
		end -- models/free-market.can:3412
		local force_name = forces_list["items"][forces_list["selected_index"]] -- models/free-market.can:3414
		local other_force = game["forces"][force_name] -- models/free-market.can:3415
		if other_force and other_force["valid"] then -- models/free-market.can:3416
			local force = player["force"] -- models/free-market.can:3417
			embargoes[force["index"]][other_force["index"]] = true -- models/free-market.can:3418
			local message = { -- models/free-market.can:3419
				"free-market.declared-embargo", -- models/free-market.can:3419
				force["name"], -- models/free-market.can:3419
				other_force["name"], -- models/free-market.can:3419
				player["name"] -- models/free-market.can:3419
			} -- models/free-market.can:3419
			force["print"](message) -- models/free-market.can:3420
			other_force["print"](message) -- models/free-market.can:3421
		end -- models/free-market.can:3421
		update_embargo_table(table_element, player) -- models/free-market.can:3423
	end, -- models/free-market.can:3423
	["FM_cancel_embargo"] = function(element, player) -- models/free-market.can:3425
		local table_element = element["parent"]["parent"] -- models/free-market.can:3426
		local embargo_list = table_element["embargo_list"] -- models/free-market.can:3427
		if embargo_list["selected_index"] == 0 then -- models/free-market.can:3428
			return  -- models/free-market.can:3428
		end -- models/free-market.can:3428
		local force_name = embargo_list["items"][embargo_list["selected_index"]] -- models/free-market.can:3430
		local other_force = game["forces"][force_name] -- models/free-market.can:3431
		if other_force and other_force["valid"] then -- models/free-market.can:3432
			local force = player["force"] -- models/free-market.can:3433
			embargoes[force["index"]][other_force["index"]] = nil -- models/free-market.can:3434
			local message = { -- models/free-market.can:3435
				"free-market.canceled-embargo", -- models/free-market.can:3435
				force["name"], -- models/free-market.can:3435
				other_force["name"], -- models/free-market.can:3435
				player["name"] -- models/free-market.can:3435
			} -- models/free-market.can:3435
			force["print"](message) -- models/free-market.can:3436
			other_force["print"](message) -- models/free-market.can:3437
		end -- models/free-market.can:3437
		update_embargo_table(table_element, player) -- models/free-market.can:3439
	end, -- models/free-market.can:3439
	["FM_open_force_configuration"] = function(element, player) -- models/free-market.can:3441
		open_force_configuration(player) -- models/free-market.can:3442
	end, -- models/free-market.can:3442
	["FM_open_price"] = function(element, player) -- models/free-market.can:3444
		switch_prices_gui(player) -- models/free-market.can:3445
	end, -- models/free-market.can:3445
	["FM_switch_sell_prices_gui"] = function(element, player) -- models/free-market.can:3447
		switch_sell_prices_gui(player) -- models/free-market.can:3448
	end, -- models/free-market.can:3448
	["FM_switch_buy_prices_gui"] = function(element, player) -- models/free-market.can:3450
		switch_buy_prices_gui(player) -- models/free-market.can:3451
	end, -- models/free-market.can:3451
	["FM_open_sell_price"] = function(element, player, event) -- models/free-market.can:3453
		local force_index = tonumber(element["children"][1]["name"]) -- models/free-market.can:3454
		local force = game["forces"][force_index or 0] -- models/free-market.can:3455
		if not (force and force["valid"]) then -- models/free-market.can:3456
			game["print"]({ -- models/free-market.can:3457
				"force-doesnt-exist", -- models/free-market.can:3457
				"?" -- models/free-market.can:3457
			}) -- models/free-market.can:3457
			return  -- models/free-market.can:3458
		end -- models/free-market.can:3458
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3461
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3462
			game["print"]({ -- models/free-market.can:3463
				"missing-item", -- models/free-market.can:3463
				item_name -- models/free-market.can:3463
			}) -- models/free-market.can:3463
			return  -- models/free-market.can:3464
		end -- models/free-market.can:3464
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] -- models/free-market.can:3467
		if price then -- models/free-market.can:3468
			if event["shift"] then -- models/free-market.can:3469
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3471
			end -- models/free-market.can:3471
			if event["control"] then -- models/free-market.can:3473
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3475
			end -- models/free-market.can:3475
			if event["alt"] then -- models/free-market.can:3477
				switch_prices_gui(player, item_name) -- models/free-market.can:3478
			end -- models/free-market.can:3478
			game["print"]({ -- models/free-market.can:3480
				"free-market.team-selling-item-for", -- models/free-market.can:3480
				force["name"], -- models/free-market.can:3480
				item_name, -- models/free-market.can:3480
				price -- models/free-market.can:3480
			}) -- models/free-market.can:3480
		else -- models/free-market.can:3480
			game["print"]({ -- models/free-market.can:3483
				"free-market.team-doesnt-sell-item", -- models/free-market.can:3483
				force["name"], -- models/free-market.can:3483
				item_name -- models/free-market.can:3483
			}) -- models/free-market.can:3483
		end -- models/free-market.can:3483
	end, -- models/free-market.can:3483
	["FM_open_buy_price"] = function(element, player, event) -- models/free-market.can:3486
		local force_index = tonumber(element["children"][1]["name"]) or 0 -- models/free-market.can:3487
		local force = game["forces"][force_index] -- models/free-market.can:3488
		if not (force and force["valid"]) then -- models/free-market.can:3489
			game["print"]({ -- models/free-market.can:3490
				"force-doesnt-exist", -- models/free-market.can:3490
				"?" -- models/free-market.can:3490
			}) -- models/free-market.can:3490
			return  -- models/free-market.can:3491
		end -- models/free-market.can:3491
		local item_name = sub(element["sprite"], 6) -- models/free-market.can:3494
		if game["item_prototypes"][item_name] == nil then -- models/free-market.can:3495
			game["print"]({ -- models/free-market.can:3496
				"missing-item", -- models/free-market.can:3496
				item_name -- models/free-market.can:3496
			}) -- models/free-market.can:3496
			return  -- models/free-market.can:3497
		end -- models/free-market.can:3497
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] -- models/free-market.can:3500
		if price then -- models/free-market.can:3501
			if event["shift"] then -- models/free-market.can:3502
				change_buy_price_by_player(item_name, player, price) -- models/free-market.can:3504
			end -- models/free-market.can:3504
			if event["control"] then -- models/free-market.can:3506
				change_sell_price_by_player(item_name, player, price) -- models/free-market.can:3508
			end -- models/free-market.can:3508
			if event["alt"] then -- models/free-market.can:3510
				switch_prices_gui(player, item_name) -- models/free-market.can:3511
			end -- models/free-market.can:3511
			game["print"]({ -- models/free-market.can:3513
				"free-market.team-buying-item-for", -- models/free-market.can:3513
				force["name"], -- models/free-market.can:3513
				item_name, -- models/free-market.can:3513
				price -- models/free-market.can:3513
			}) -- models/free-market.can:3513
		else -- models/free-market.can:3513
			game["print"]({ -- models/free-market.can:3516
				"free-market.team-doesnt-buy-item", -- models/free-market.can:3516
				force["name"], -- models/free-market.can:3516
				item_name -- models/free-market.can:3516
			}) -- models/free-market.can:3516
		end -- models/free-market.can:3516
	end, -- models/free-market.can:3516
	["FM_open_price_list"] = function(element, player) -- models/free-market.can:3519
		open_price_list_gui(player) -- models/free-market.can:3520
	end, -- models/free-market.can:3520
	["FM_open_embargo"] = function(element, player) -- models/free-market.can:3522
		open_embargo_gui(player) -- models/free-market.can:3523
	end, -- models/free-market.can:3523
	["FM_open_storage"] = function(element, player) -- models/free-market.can:3525
		open_storage_gui(player) -- models/free-market.can:3526
	end, -- models/free-market.can:3526
	["FM_show_hint"] = function(element, player) -- models/free-market.can:3528
		player["print"]({ "free-market.hint" }) -- models/free-market.can:3529
	end, -- models/free-market.can:3529
	["FM_hide_left_buttons"] = function(element, player) -- models/free-market.can:3531
		element["name"] = "FM_show_left_buttons" -- models/free-market.can:3532
		element["caption"] = "<" -- models/free-market.can:3533
		element["parent"]["children"][2]["visible"] = false -- models/free-market.can:3534
	end, -- models/free-market.can:3534
	["FM_show_left_buttons"] = function(element, player) -- models/free-market.can:3536
		element["name"] = "FM_hide_left_buttons" -- models/free-market.can:3537
		element["caption"] = ">" -- models/free-market.can:3538
		element["parent"]["children"][2]["visible"] = true -- models/free-market.can:3539
	end, -- models/free-market.can:3539
	["FM_search_by_price"] = function(element, player) -- models/free-market.can:3541
		local search_row = element["parent"] -- models/free-market.can:3542
		local selected_index = search_row["FM_search_price_drop_down"]["selected_index"] -- models/free-market.can:3543
		if selected_index == 0 then -- models/free-market.can:3544
			return  -- models/free-market.can:3545
		end -- models/free-market.can:3545
		local content_flow = search_row["parent"] -- models/free-market.can:3548
		local drop_down = content_flow["team_row"]["FM_force_price_list"] -- models/free-market.can:3549
		local dp_selected_index = drop_down["selected_index"] -- models/free-market.can:3550
		if dp_selected_index == nil or dp_selected_index == 0 then -- models/free-market.can:3551
			return  -- models/free-market.can:3551
		end -- models/free-market.can:3551
		local force = game["forces"][drop_down["items"][dp_selected_index]] -- models/free-market.can:3552
		if not (force and force["valid"]) then -- models/free-market.can:3553
			return  -- models/free-market.can:3553
		end -- models/free-market.can:3553
		local search_text = search_row["FM_search_text"]["text"] -- models/free-market.can:3555
		if # search_text > 50 then -- models/free-market.can:3556
			return  -- models/free-market.can:3557
		end -- models/free-market.can:3557
		local scroll_pane = content_flow["deep_frame"]["scroll-pane"] -- models/free-market.can:3559
		if search_text == "" then -- models/free-market.can:3560
			update_price_list_table(force, scroll_pane) -- models/free-market.can:3561
			return  -- models/free-market.can:3562
		end -- models/free-market.can:3562
		search_text = ".?" .. search_text:lower():gsub(" ", ".?") .. ".?" -- models/free-market.can:3565
		if selected_index == 1 then -- models/free-market.can:3566
			update_price_list_by_sell_filter(force, scroll_pane, search_text) -- models/free-market.can:3567
		else -- models/free-market.can:3567
			update_price_list_by_buy_filter(force, scroll_pane, search_text) -- models/free-market.can:3569
		end -- models/free-market.can:3569
	end -- models/free-market.can:3569
} -- models/free-market.can:3569
local function on_gui_click(event) -- models/free-market.can:3573
	local element = event["element"] -- models/free-market.can:3574
	local f = GUIS[element["name"]] -- models/free-market.can:3575
	if f then -- models/free-market.can:3576
		f(element, game["get_player"](event["player_index"]), event) -- models/free-market.can:3576
	end -- models/free-market.can:3576
end -- models/free-market.can:3576
local function on_gui_closed(event) -- models/free-market.can:3579
	local entity = event["entity"] -- models/free-market.can:3580
	if not (entity and entity["valid"]) then -- models/free-market.can:3581
		return  -- models/free-market.can:3581
	end -- models/free-market.can:3581
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3582
		return  -- models/free-market.can:3582
	end -- models/free-market.can:3582
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3583
	if not (player and player["valid"]) then -- models/free-market.can:3584
		return  -- models/free-market.can:3584
	end -- models/free-market.can:3584
	player["gui"]["relative"]["FM_boxes_frame"]["content"]["main_flow"]["box_operations"]["clear"]() -- models/free-market.can:3585
end -- models/free-market.can:3585
local function check_pull_boxes() -- models/free-market.can:3588
	local pulled_item_count = {} -- models/free-market.can:3589
	local stack = { -- models/free-market.can:3590
		["name"] = "", -- models/free-market.can:3590
		["count"] = 0 -- models/free-market.can:3590
	} -- models/free-market.can:3590
	for force_index, _items_data in pairs(pull_boxes) do -- models/free-market.can:3591
		if pull_cost_per_item == 0 or call("EasyAPI", "get_force_money", force_index) > money_treshold then -- models/free-market.can:3592
			local inserted_count_in_total = 0 -- models/free-market.can:3593
			pulled_item_count[force_index] = 0 -- models/free-market.can:3594
			local storage = storages[force_index] -- models/free-market.can:3595
			for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3596
				local count_in_storage = storage[item_name] -- models/free-market.can:3597
				if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3598
					stack["name"] = item_name -- models/free-market.can:3599
					for i = 1, # force_entities do -- models/free-market.can:3600
						if count_in_storage <= 0 then -- models/free-market.can:3601
							break -- models/free-market.can:3602
						end -- models/free-market.can:3602
						stack["count"] = count_in_storage -- models/free-market.can:3604
						local inserted_count = force_entities[i]["insert"](stack) -- models/free-market.can:3605
						inserted_count_in_total = inserted_count_in_total + inserted_count -- models/free-market.can:3606
						count_in_storage = count_in_storage - inserted_count -- models/free-market.can:3607
					end -- models/free-market.can:3607
					storage[item_name] = count_in_storage -- models/free-market.can:3609
				end -- models/free-market.can:3609
			end -- models/free-market.can:3609
			pulled_item_count[force_index] = inserted_count_in_total -- models/free-market.can:3612
		end -- models/free-market.can:3612
	end -- models/free-market.can:3612
	if pull_cost_per_item == 0 then -- models/free-market.can:3616
		return  -- models/free-market.can:3616
	end -- models/free-market.can:3616
	for force_index, count in pairs(pulled_item_count) do -- models/free-market.can:3617
		if count > 0 then -- models/free-market.can:3618
			call("EasyAPI", "deposit_force_money_by_index", force_index, - ceil(count * pull_cost_per_item)) -- models/free-market.can:3621
		end -- models/free-market.can:3621
	end -- models/free-market.can:3621
end -- models/free-market.can:3621
local function check_transfer_boxes() -- models/free-market.can:3627
	local stack = { -- models/free-market.can:3628
		["name"] = "", -- models/free-market.can:3628
		["count"] = 4000000000 -- models/free-market.can:3628
	} -- models/free-market.can:3628
	for force_index, force_entities in pairs(universal_bin_boxes) do -- models/free-market.can:3631
		local storage = storages[force_index] -- models/free-market.can:3632
		for i = 1, # force_entities do -- models/free-market.can:3633
			local entity = force_entities[i] -- models/free-market.can:3634
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3635
			for item_name in pairs(contents) do -- models/free-market.can:3636
				local count = storage[item_name] or 0 -- models/free-market.can:3637
				stack["name"] = item_name -- models/free-market.can:3638
				local sum = entity["remove_item"](stack) -- models/free-market.can:3639
				if sum > 0 then -- models/free-market.can:3640
					storage[item_name] = count + sum -- models/free-market.can:3641
				end -- models/free-market.can:3641
			end -- models/free-market.can:3641
		end -- models/free-market.can:3641
	end -- models/free-market.can:3641
	for force_index, _items_data in pairs(bin_boxes) do -- models/free-market.can:3647
		local storage = storages[force_index] -- models/free-market.can:3648
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3649
			local count = storage[item_name] or 0 -- models/free-market.can:3650
			stack["name"] = item_name -- models/free-market.can:3651
			local sum = 0 -- models/free-market.can:3652
			for i = 1, # force_entities do -- models/free-market.can:3653
				sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3654
			end -- models/free-market.can:3654
			if sum > 0 then -- models/free-market.can:3656
				storage[item_name] = count + sum -- models/free-market.can:3657
			end -- models/free-market.can:3657
		end -- models/free-market.can:3657
	end -- models/free-market.can:3657
	for force_index, force_entities in pairs(universal_transfer_boxes) do -- models/free-market.can:3663
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3664
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3665
		local storage = storages[force_index] -- models/free-market.can:3666
		for i = 1, # force_entities do -- models/free-market.can:3667
			local entity = force_entities[i] -- models/free-market.can:3668
			local contents = entity["get_inventory"](1)["get_contents"]() -- models/free-market.can:3669
			for item_name in pairs(contents) do -- models/free-market.can:3670
				local count = storage[item_name] or 0 -- models/free-market.can:3671
				local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3672
				if max_count > 0 then -- models/free-market.can:3673
					stack["count"] = max_count -- models/free-market.can:3674
					stack["name"] = item_name -- models/free-market.can:3675
					local sum = entity["remove_item"](stack) -- models/free-market.can:3676
					if sum > 0 then -- models/free-market.can:3677
						storage[item_name] = count + sum -- models/free-market.can:3678
					end -- models/free-market.can:3678
				end -- models/free-market.can:3678
			end -- models/free-market.can:3678
		end -- models/free-market.can:3678
	end -- models/free-market.can:3678
	for force_index, _items_data in pairs(transfer_boxes) do -- models/free-market.can:3685
		local default_limit = default_storage_limit[force_index] -- models/free-market.can:3686
		local storage_limit = storages_limit[force_index] -- models/free-market.can:3687
		local storage = storages[force_index] -- models/free-market.can:3688
		for item_name, force_entities in pairs(_items_data) do -- models/free-market.can:3689
			local count = storage[item_name] or 0 -- models/free-market.can:3690
			local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count -- models/free-market.can:3691
			if max_count > 0 then -- models/free-market.can:3692
				stack["count"] = max_count -- models/free-market.can:3693
				stack["name"] = item_name -- models/free-market.can:3694
				local sum = 0 -- models/free-market.can:3695
				for i = 1, # force_entities do -- models/free-market.can:3696
					sum = sum + force_entities[i]["remove_item"](stack) -- models/free-market.can:3697
				end -- models/free-market.can:3697
				if sum > 0 then -- models/free-market.can:3699
					storage[item_name] = count + sum -- models/free-market.can:3700
				end -- models/free-market.can:3700
			end -- models/free-market.can:3700
		end -- models/free-market.can:3700
	end -- models/free-market.can:3700
end -- models/free-market.can:3700
local function check_buy_boxes() -- models/free-market.can:3707
	local last_checked_index = mod_data["last_checked_index"] -- models/free-market.can:3708
	local buyer_index -- models/free-market.can:3709
	if last_checked_index then -- models/free-market.can:3710
		buyer_index = active_forces[last_checked_index] -- models/free-market.can:3711
		if buyer_index then -- models/free-market.can:3712
			mod_data["last_checked_index"] = last_checked_index + 1 -- models/free-market.can:3713
		else -- models/free-market.can:3713
			mod_data["last_checked_index"] = nil -- models/free-market.can:3715
			return  -- models/free-market.can:3716
		end -- models/free-market.can:3716
	else -- models/free-market.can:3716
		last_checked_index, buyer_index = next(active_forces) -- models/free-market.can:3719
		if last_checked_index then -- models/free-market.can:3720
			mod_data["last_checked_index"] = last_checked_index -- models/free-market.can:3721
		else -- models/free-market.can:3721
			return  -- models/free-market.can:3723
		end -- models/free-market.can:3723
	end -- models/free-market.can:3723
	local items_data = buy_boxes[buyer_index] -- models/free-market.can:3727
	if items_data == nil then -- models/free-market.can:3729
		return  -- models/free-market.can:3729
	end -- models/free-market.can:3729
	local forces_money = call("EasyAPI", "get_forces_money") -- models/free-market.can:3731
	local forces_money_copy = {} -- models/free-market.can:3732
	for _force_index, value in pairs(forces_money) do -- models/free-market.can:3733
		forces_money_copy[_force_index] = value -- models/free-market.can:3734
	end -- models/free-market.can:3734
	local buyer_money = forces_money_copy[buyer_index] -- models/free-market.can:3737
	if buyer_money and buyer_money > money_treshold then -- models/free-market.can:3738
		local stack = { -- models/free-market.can:3739
			["name"] = "", -- models/free-market.can:3739
			["count"] = 0 -- models/free-market.can:3739
		} -- models/free-market.can:3739
		local stack_count = 0 -- models/free-market.can:3740
		local payment = 0 -- models/free-market.can:3741
		local f_buy_prices = buy_prices[buyer_index] -- models/free-market.can:3742
		local inserted_count_in_total = 0 -- models/free-market.can:3743
		for item_name, entities in pairs(items_data) do -- models/free-market.can:3744
			if money_treshold >= buyer_money then -- models/free-market.can:3745
				goto not_enough_money -- models/free-market.can:3747
			end -- models/free-market.can:3747
			local buy_price = f_buy_prices[item_name] -- models/free-market.can:3749
			if buy_price and buyer_money >= buy_price then -- models/free-market.can:3750
				for i = 1, # entities do -- models/free-market.can:3751
					local buy_data = entities[i] -- models/free-market.can:3752
					local purchasable_count = buyer_money / buy_price -- models/free-market.can:3753
					if purchasable_count < 1 then -- models/free-market.can:3754
						goto skip_buy -- models/free-market.can:3755
					else -- models/free-market.can:3755
						purchasable_count = floor(purchasable_count) -- models/free-market.can:3757
					end -- models/free-market.can:3757
					local buy_box = buy_data[1] -- models/free-market.can:3759
					local need_count = buy_data[2] -- models/free-market.can:3760
					if purchasable_count < need_count then -- models/free-market.can:3761
						need_count = purchasable_count -- models/free-market.can:3762
					end -- models/free-market.can:3762
					local count = buy_box["get_item_count"](item_name) -- models/free-market.can:3764
					stack["name"] = item_name -- models/free-market.can:3765
					if need_count < count then -- models/free-market.can:3766
						stack_count = count -- models/free-market.can:3767
					else -- models/free-market.can:3767
						need_count = need_count - count -- models/free-market.can:3769
						if need_count <= 0 then -- models/free-market.can:3770
							goto skip_buy -- models/free-market.can:3771
						end -- models/free-market.can:3771
						local buyer_storage = storages[buyer_index] -- models/free-market.can:3774
						local count_in_storage = buyer_storage[item_name] -- models/free-market.can:3775
						if count_in_storage and count_in_storage > 0 then -- models/free-market.can:3776
							stack_count = need_count - count_in_storage -- models/free-market.can:3777
							if stack_count <= 0 then -- models/free-market.can:3778
								buyer_storage[item_name] = count_in_storage - need_count -- models/free-market.can:3779
								stack_count = 0 -- models/free-market.can:3780
								goto fulfilled_needs -- models/free-market.can:3781
							else -- models/free-market.can:3781
								buyer_storage[item_name] = count_in_storage + (stack_count - need_count) -- models/free-market.can:3783
							end -- models/free-market.can:3783
						else -- models/free-market.can:3783
							stack_count = need_count -- models/free-market.can:3786
						end -- models/free-market.can:3786
						for seller_index, seller_storage in pairs(storages) do -- models/free-market.can:3789
							if buyer_index ~= seller_index and forces_money[seller_index] and not embargoes[seller_index][buyer_index] then -- models/free-market.can:3790
								local sell_price = sell_prices[seller_index][item_name] -- models/free-market.can:3791
								if sell_price and buy_price >= sell_price then -- models/free-market.can:3792
									count_in_storage = seller_storage[item_name] -- models/free-market.can:3793
									if count_in_storage then -- models/free-market.can:3794
										if count_in_storage > stack_count then -- models/free-market.can:3795
											seller_storage[item_name] = count_in_storage - stack_count -- models/free-market.can:3796
											stack_count = 0 -- models/free-market.can:3797
											payment = need_count * sell_price -- models/free-market.can:3798
											buyer_money = buyer_money - payment -- models/free-market.can:3799
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3800
											goto fulfilled_needs -- models/free-market.can:3801
										else -- models/free-market.can:3801
											stack_count = stack_count - count_in_storage -- models/free-market.can:3803
											seller_storage[item_name] = 0 -- models/free-market.can:3804
											payment = (need_count - stack_count) * sell_price -- models/free-market.can:3805
											buyer_money = buyer_money - payment -- models/free-market.can:3806
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment -- models/free-market.can:3807
										end -- models/free-market.can:3807
									end -- models/free-market.can:3807
								end -- models/free-market.can:3807
							end -- models/free-market.can:3807
						end -- models/free-market.can:3807
					end -- models/free-market.can:3807
					::fulfilled_needs:: -- models/free-market.can:3814
					local found_items = need_count - stack_count -- models/free-market.can:3815
					if found_items > 0 then -- models/free-market.can:3816
						stack["count"] = found_items -- models/free-market.can:3817
						inserted_count_in_total = inserted_count_in_total + buy_box["insert"](stack) -- models/free-market.can:3818
					end -- models/free-market.can:3818
					::skip_buy:: -- models/free-market.can:3820
				end -- models/free-market.can:3820
			end -- models/free-market.can:3820
		end -- models/free-market.can:3820
		::not_enough_money:: -- models/free-market.can:3824
		if pull_cost_per_item == 0 then -- models/free-market.can:3825
			forces_money_copy[buyer_index] = buyer_money -- models/free-market.can:3826
		else -- models/free-market.can:3826
			forces_money_copy[buyer_index] = buyer_money - ceil(inserted_count_in_total * pull_cost_per_item) -- models/free-market.can:3828
		end -- models/free-market.can:3828
	else -- models/free-market.can:3828
		return  -- models/free-market.can:3831
	end -- models/free-market.can:3831
	local forces = game["forces"] -- models/free-market.can:3834
	for _force_index, money in pairs(forces_money_copy) do -- models/free-market.can:3835
		local prev_money = forces_money[_force_index] -- models/free-market.can:3836
		if prev_money ~= money then -- models/free-market.can:3837
			local force = forces[_force_index] -- models/free-market.can:3838
			call("EasyAPI", "set_force_money", force, money) -- models/free-market.can:3839
			force["item_production_statistics"]["on_flow"]("trading", money - prev_money) -- models/free-market.can:3841
		end -- models/free-market.can:3841
	end -- models/free-market.can:3841
end -- models/free-market.can:3841
local function on_player_changed_force(event) -- models/free-market.can:3846
	local player_index = event["player_index"] -- models/free-market.can:3847
	local player = game["get_player"](player_index) -- models/free-market.can:3848
	if not (player and player["valid"]) then -- models/free-market.can:3849
		return  -- models/free-market.can:3849
	end -- models/free-market.can:3849
	if open_box[player_index] then -- models/free-market.can:3851
		clear_boxes_gui(player) -- models/free-market.can:3852
	end -- models/free-market.can:3852
	local index = player["force"]["index"] -- models/free-market.can:3855
	if transfer_boxes[index] == nil then -- models/free-market.can:3856
		init_force_data(index) -- models/free-market.can:3857
	end -- models/free-market.can:3857
end -- models/free-market.can:3857
local function on_player_changed_surface(event) -- models/free-market.can:3861
	local player_index = event["player_index"] -- models/free-market.can:3862
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3863
	if not (player and player["valid"]) then -- models/free-market.can:3864
		return  -- models/free-market.can:3864
	end -- models/free-market.can:3864
	if open_box[player_index] then -- models/free-market.can:3866
		clear_boxes_gui(player) -- models/free-market.can:3867
	end -- models/free-market.can:3867
end -- models/free-market.can:3867
local function on_player_left_game(event) -- models/free-market.can:3871
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3872
	if not (player and player["valid"]) then -- models/free-market.can:3873
		return  -- models/free-market.can:3873
	end -- models/free-market.can:3873
	clear_boxes_gui(player) -- models/free-market.can:3875
	destroy_prices_gui(player) -- models/free-market.can:3876
	delete_item_price_HUD(player) -- models/free-market.can:3877
	destroy_price_list_gui(player) -- models/free-market.can:3878
	destroy_force_configuration(player) -- models/free-market.can:3879
end -- models/free-market.can:3879
local function on_selected_entity_changed(event) -- models/free-market.can:3882
	local player = game["get_player"](event["player_index"]) -- models/free-market.can:3883
	if not (player and player["valid"]) then -- models/free-market.can:3884
		return  -- models/free-market.can:3884
	end -- models/free-market.can:3884
	local entity = player["selected"] -- models/free-market.can:3885
	if not (entity and entity["valid"]) then -- models/free-market.can:3886
		return  -- models/free-market.can:3886
	end -- models/free-market.can:3886
	if not ALLOWED_TYPES[entity["type"]] then -- models/free-market.can:3887
		return  -- models/free-market.can:3887
	end -- models/free-market.can:3887
	if entity["force"] ~= player["force"] then -- models/free-market.can:3888
		return  -- models/free-market.can:3888
	end -- models/free-market.can:3888
	local box_data = all_boxes[entity["unit_number"]] -- models/free-market.can:3889
	if box_data == nil then -- models/free-market.can:3890
		return  -- models/free-market.can:3890
	end -- models/free-market.can:3890
	local item_name = box_data[5] -- models/free-market.can:3891
	if item_name == nil then -- models/free-market.can:3892
		return  -- models/free-market.can:3892
	end -- models/free-market.can:3892
	show_item_info_HUD(player, item_name) -- models/free-market.can:3894
end -- models/free-market.can:3894
local SELECT_TOOLS = { -- models/free-market.can:3898
	["FM_set_pull_boxes_tool"] = set_pull_box_data, -- models/free-market.can:3899
	["FM_set_bin_boxes_tool"] = set_bin_box_data, -- models/free-market.can:3900
	["FM_set_transfer_boxes_tool"] = set_transfer_box_data, -- models/free-market.can:3901
	["FM_set_buy_boxes_tool"] = set_buy_box_data -- models/free-market.can:3902
} -- models/free-market.can:3902
local function on_player_selected_area(event) -- models/free-market.can:3904
	local tool_name = event["item"] -- models/free-market.can:3905
	local func = SELECT_TOOLS[tool_name] -- models/free-market.can:3906
	if func then -- models/free-market.can:3907
		local entities = event["entities"] -- models/free-market.can:3908
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3909
		for i = 1, # entities do -- models/free-market.can:3910
			local entity = entities[i] -- models/free-market.can:3911
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3912
				local item = entity["get_inventory"](1)[1] -- models/free-market.can:3913
				if item["valid_for_read"] then -- models/free-market.can:3914
					func(item["name"], player, entity) -- models/free-market.can:3915
				end -- models/free-market.can:3915
			end -- models/free-market.can:3915
		end -- models/free-market.can:3915
	elseif tool_name == "FM_set_universal_transfer_boxes_tool" then -- models/free-market.can:3919
		local entities = event["entities"] -- models/free-market.can:3920
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3921
		for i = 1, # entities do -- models/free-market.can:3922
			local entity = entities[i] -- models/free-market.can:3923
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3924
				set_universal_transfer_box_data(player, entity) -- models/free-market.can:3925
			end -- models/free-market.can:3925
		end -- models/free-market.can:3925
	elseif tool_name == "FM_set_universal_bin_boxes_tool" then -- models/free-market.can:3928
		local entities = event["entities"] -- models/free-market.can:3929
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3930
		for i = 1, # entities do -- models/free-market.can:3931
			local entity = entities[i] -- models/free-market.can:3932
			if all_boxes[entity["unit_number"]] == nil then -- models/free-market.can:3933
				set_universal_bin_box_data(player, entity) -- models/free-market.can:3934
			end -- models/free-market.can:3934
		end -- models/free-market.can:3934
	elseif tool_name == "FM_remove_boxes_tool" then -- models/free-market.can:3937
		local entities = event["entities"] -- models/free-market.can:3938
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:3939
		local count = 0 -- models/free-market.can:3940
		for i = 1, # entities do -- models/free-market.can:3941
			local is_deleted = clear_box_data_by_entity(entities[i]) -- models/free-market.can:3942
			if is_deleted then -- models/free-market.can:3943
				count = count + 1 -- models/free-market.can:3944
			end -- models/free-market.can:3944
		end -- models/free-market.can:3944
		if count > 0 then -- models/free-market.can:3947
			player["print"]({ -- models/free-market.can:3948
				"", -- models/free-market.can:3948
				{ "gui-migrated-content.removed-entity" }, -- models/free-market.can:3948
				COLON, -- models/free-market.can:3948
				" ", -- models/free-market.can:3948
				count -- models/free-market.can:3948
			}) -- models/free-market.can:3948
		end -- models/free-market.can:3948
	end -- models/free-market.can:3948
end -- models/free-market.can:3948
do -- models/free-market.can:3955
	local TOOL_TO_TYPE = { -- models/free-market.can:3955
		["FM_set_pull_boxes_tool"] = 3, -- models/free-market.can:1
		["FM_set_transfer_boxes_tool"] = 4, -- models/free-market.can:1
		["FM_set_universal_transfer_boxes_tool"] = 5, -- models/free-market.can:1
		["FM_set_universal_bin_boxes_tool"] = 7, -- models/free-market.can:1
		["FM_set_bin_boxes_tool"] = 6, -- models/free-market.can:1
		["FM_set_buy_boxes_tool"] = 1 -- models/free-market.can:1
	} -- models/free-market.can:1
	on_player_alt_selected_area = function(event) -- models/free-market.can:3963
		local box_type = TOOL_TO_TYPE[event["item"]] -- models/free-market.can:3964
		if box_type == nil then -- models/free-market.can:3965
			return  -- models/free-market.can:3965
		end -- models/free-market.can:3965
		local remove_box = REMOVE_BOX_FUNCS[box_type] -- models/free-market.can:3967
		local entities = event["entities"] -- models/free-market.can:3968
		for i = # entities, 1, - 1 do -- models/free-market.can:3969
			local entity = entities[i] -- models/free-market.can:3970
			if entity["valid"] then -- models/free-market.can:3971
				local unit_number = entity["unit_number"] -- models/free-market.can:3972
				local box_data = all_boxes[unit_number] -- models/free-market.can:3973
				if box_data and box_data[3] == box_type then -- models/free-market.can:3974
					rendering_destroy(box_data[2]) -- models/free-market.can:3975
					remove_box(entity, box_data) -- models/free-market.can:3976
				end -- models/free-market.can:3976
			end -- models/free-market.can:3976
		end -- models/free-market.can:3976
	end -- models/free-market.can:3976
end -- models/free-market.can:3976
local mod_settings = { -- models/free-market.can:3984
	["FM_enable-auto-embargo"] = function(value) -- models/free-market.can:3985
		is_auto_embargo = value -- models/free-market.can:3985
	end, -- models/free-market.can:3985
	["FM_is-public-titles"] = function(value) -- models/free-market.can:3986
		is_public_titles = value -- models/free-market.can:3986
	end, -- models/free-market.can:3986
	["FM_is_reset_public"] = function(value) -- models/free-market.can:3987
		is_reset_public = value -- models/free-market.can:3987
	end, -- models/free-market.can:3987
	["FM_money-treshold"] = function(value) -- models/free-market.can:3988
		money_treshold = value -- models/free-market.can:3988
	end, -- models/free-market.can:3988
	["FM_minimal-price"] = function(value) -- models/free-market.can:3989
		minimal_price = value -- models/free-market.can:3989
	end, -- models/free-market.can:3989
	["FM_maximal-price"] = function(value) -- models/free-market.can:3990
		maximal_price = value -- models/free-market.can:3990
	end, -- models/free-market.can:3990
	["FM_skip_offline_team_chance"] = function(value) -- models/free-market.can:3991
		skip_offline_team_chance = value -- models/free-market.can:3991
	end, -- models/free-market.can:3991
	["FM_max_storage_threshold"] = function(value) -- models/free-market.can:3992
		max_storage_threshold = value -- models/free-market.can:3992
	end, -- models/free-market.can:3992
	["FM_pull_cost_per_item"] = function(value) -- models/free-market.can:3993
		pull_cost_per_item = value -- models/free-market.can:3993
	end, -- models/free-market.can:3993
	["FM_update-tick"] = function(value) -- models/free-market.can:3994
		if CHECK_FORCES_TICK == value then -- models/free-market.can:3995
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:3997
			return  -- models/free-market.can:3999
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4000
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4002
			return  -- models/free-market.can:4004
		elseif update_pull_tick == value then -- models/free-market.can:4005
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4007
			return  -- models/free-market.can:4009
		elseif update_transfer_tick == value then -- models/free-market.can:4010
			settings["global"]["FM_update-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4012
			return  -- models/free-market.can:4014
		end -- models/free-market.can:4014
		script["on_nth_tick"](update_buy_tick, nil) -- models/free-market.can:4016
		update_buy_tick = value -- models/free-market.can:4017
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4018
	end, -- models/free-market.can:4018
	["FM_update-transfer-tick"] = function(value) -- models/free-market.can:4020
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4021
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4023
			return  -- models/free-market.can:4025
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4026
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4028
			return  -- models/free-market.can:4030
		elseif update_pull_tick == value then -- models/free-market.can:4031
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4033
			return  -- models/free-market.can:4035
		elseif update_buy_tick == value then -- models/free-market.can:4036
			settings["global"]["FM_update-transfer-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4038
			return  -- models/free-market.can:4040
		end -- models/free-market.can:4040
		script["on_nth_tick"](update_transfer_tick, nil) -- models/free-market.can:4042
		update_transfer_tick = value -- models/free-market.can:4043
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4044
	end, -- models/free-market.can:4044
	["FM_update-pull-tick"] = function(value) -- models/free-market.can:4046
		if CHECK_FORCES_TICK == value then -- models/free-market.can:4047
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4049
			return  -- models/free-market.can:4051
		elseif CHECK_TEAMS_DATA_TICK == value then -- models/free-market.can:4052
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4054
			return  -- models/free-market.can:4056
		elseif update_transfer_tick == value then -- models/free-market.can:4057
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4059
			return  -- models/free-market.can:4061
		elseif update_buy_tick == value then -- models/free-market.can:4062
			settings["global"]["FM_update-pull-tick"] = { ["value"] = value + 1 } -- models/free-market.can:4064
			return  -- models/free-market.can:4066
		end -- models/free-market.can:4066
		script["on_nth_tick"](update_pull_tick, nil) -- models/free-market.can:4068
		update_pull_tick = value -- models/free-market.can:4069
		script["on_nth_tick"](value, check_buy_boxes) -- models/free-market.can:4070
	end, -- models/free-market.can:4070
	["FM_show_item_price"] = function(player) -- models/free-market.can:4072
		if player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4073
			create_item_price_HUD(player) -- models/free-market.can:4074
		else -- models/free-market.can:4074
			delete_item_price_HUD(player) -- models/free-market.can:4076
		end -- models/free-market.can:4076
	end, -- models/free-market.can:4076
	["FM_sell_notification_column_count"] = function(player) -- models/free-market.can:4079
		local column_count = 2 * player["mod_settings"]["FM_sell_notification_column_count"]["value"] -- models/free-market.can:4080
		local is_vertical = (column_count == 2) -- models/free-market.can:4081
		local frame = player["gui"]["screen"]["FM_sell_prices_frame"] -- models/free-market.can:4082
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4083
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4084
			local last_location = frame["location"] -- models/free-market.can:4085
			frame["destroy"]() -- models/free-market.can:4086
			switch_sell_prices_gui(player, last_location) -- models/free-market.can:4087
		end -- models/free-market.can:4087
	end, -- models/free-market.can:4087
	["FM_buy_notification_column_count"] = function(player) -- models/free-market.can:4090
		local column_count = 2 * player["mod_settings"]["FM_buy_notification_column_count"]["value"] -- models/free-market.can:4091
		local is_vertical = (column_count == 2) -- models/free-market.can:4092
		local frame = player["gui"]["screen"]["FM_buy_prices_frame"] -- models/free-market.can:4093
		local is_frame_vertical = (frame["direction"] == "vertical") -- models/free-market.can:4094
		if is_vertical ~= is_frame_vertical then -- models/free-market.can:4095
			local last_location = frame["location"] -- models/free-market.can:4096
			frame["destroy"]() -- models/free-market.can:4097
			switch_buy_prices_gui(player, last_location) -- models/free-market.can:4098
		end -- models/free-market.can:4098
	end -- models/free-market.can:4098
} -- models/free-market.can:4098
on_runtime_mod_setting_changed = function(event) -- models/free-market.can:4102
	local setting_name = event["setting"] -- models/free-market.can:4103
	local f = mod_settings[setting_name] -- models/free-market.can:4104
	if f == nil then -- models/free-market.can:4105
		return  -- models/free-market.can:4105
	end -- models/free-market.can:4105
	if event["setting_type"] == "runtime-global" then -- models/free-market.can:4107
		f(settings["global"][setting_name]["value"]) -- models/free-market.can:4108
	else -- models/free-market.can:4108
		local player = game["get_player"](event["player_index"]) -- models/free-market.can:4110
		if player and player["valid"] then -- models/free-market.can:4111
			f(player) -- models/free-market.can:4112
		end -- models/free-market.can:4112
	end -- models/free-market.can:4112
end -- models/free-market.can:4112
local function add_remote_interface() -- models/free-market.can:4122
	remote["remove_interface"]("free-market") -- models/free-market.can:4124
	remote["add_interface"]("free-market", { -- models/free-market.can:4125
		["get_mod_data"] = function() -- models/free-market.can:4126
			return mod_data -- models/free-market.can:4126
		end, -- models/free-market.can:4126
		["get_internal_data"] = function(name) -- models/free-market.can:4127
			return mod_data[name] -- models/free-market.can:4127
		end, -- models/free-market.can:4127
		["change_count_in_buy_box_data"] = change_count_in_buy_box_data, -- models/free-market.can:4128
		["remove_certain_pull_box"] = remove_certain_pull_box, -- models/free-market.can:4129
		["remove_certain_transfer_box"] = remove_certain_transfer_box, -- models/free-market.can:4130
		["remove_certain_universal_transfer_box"] = remove_certain_universal_transfer_box, -- models/free-market.can:4131
		["remove_certain_bin_box"] = remove_certain_bin_box, -- models/free-market.can:4132
		["remove_certain_universal_bin_box"] = remove_certain_universal_bin_box, -- models/free-market.can:4133
		["remove_certain_buy_box"] = remove_certain_buy_box, -- models/free-market.can:4134
		["clear_box_data_by_entity"] = clear_box_data_by_entity, -- models/free-market.can:4135
		["resetTransferBoxes"] = resetTransferBoxes, -- models/free-market.can:4136
		["resetUniversalTransferBoxes"] = resetUniversalTransferBoxes, -- models/free-market.can:4137
		["resetBinBoxes"] = resetBinBoxes, -- models/free-market.can:4138
		["resetUniversalBinBoxes"] = resetUniversalBinBoxes, -- models/free-market.can:4139
		["resetPullBoxes"] = resetPullBoxes, -- models/free-market.can:4140
		["resetBuyBoxes"] = resetBuyBoxes, -- models/free-market.can:4141
		["resetAllBoxes"] = resetAllBoxes, -- models/free-market.can:4142
		["clear_force_data"] = clear_force_data, -- models/free-market.can:4143
		["init_force_data"] = init_force_data, -- models/free-market.can:4144
		["set_universal_transfer_box_data"] = set_universal_transfer_box_data, -- models/free-market.can:4145
		["set_universal_bin_box_data"] = set_universal_bin_box_data, -- models/free-market.can:4146
		["set_transfer_box_data"] = set_transfer_box_data, -- models/free-market.can:4147
		["set_bin_box_data"] = set_bin_box_data, -- models/free-market.can:4148
		["set_pull_box_data"] = set_pull_box_data, -- models/free-market.can:4149
		["set_buy_box_data"] = set_buy_box_data, -- models/free-market.can:4150
		["set_item_limit"] = function(item_name, force_index, count) -- models/free-market.can:4151
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4152
			if f_storages_limit == nil then -- models/free-market.can:4153
				return  -- models/free-market.can:4153
			end -- models/free-market.can:4153
			f_storages_limit[item_name] = count -- models/free-market.can:4154
		end, -- models/free-market.can:4154
		["set_default_storage_limit"] = function(force_index, count) -- models/free-market.can:4156
			local f_default_storage_limit = default_storage_limit[force_index] -- models/free-market.can:4157
			if f_default_storage_limit == nil then -- models/free-market.can:4158
				return  -- models/free-market.can:4158
			end -- models/free-market.can:4158
			default_storage_limit[force_index] = count -- models/free-market.can:4159
		end, -- models/free-market.can:4159
		["set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4161
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4162
			if f_sell_prices == nil then -- models/free-market.can:4163
				return  -- models/free-market.can:4163
			end -- models/free-market.can:4163
			local transferers = transfer_boxes[force_index][item_name] -- models/free-market.can:4165
			local count_in_storage = storages[force_index][item_name] -- models/free-market.can:4166
			if f_sell_prices[item_name] or transferers ~= nil or (count_in_storage and count_in_storage > 0) then -- models/free-market.can:4167
				f_sell_prices[item_name] = price -- models/free-market.can:4168
				inactive_sell_prices[force_index] = nil -- models/free-market.can:4169
			else -- models/free-market.can:4169
				f_sell_prices[item_name] = nil -- models/free-market.can:4171
				inactive_sell_prices[force_index][item_name] = price -- models/free-market.can:4172
			end -- models/free-market.can:4172
		end, -- models/free-market.can:4172
		["set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4175
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4176
			if f_buy_prices == nil then -- models/free-market.can:4177
				return  -- models/free-market.can:4177
			end -- models/free-market.can:4177
			local f_buy_boxes = buy_boxes[force_index][item_name] -- models/free-market.can:4179
			if f_buy_prices[item_name] or f_buy_boxes ~= nil then -- models/free-market.can:4180
				f_buy_prices[item_name] = price -- models/free-market.can:4181
				inactive_buy_prices[force_index] = nil -- models/free-market.can:4182
			else -- models/free-market.can:4182
				f_buy_prices[item_name] = nil -- models/free-market.can:4184
				inactive_buy_prices[force_index][item_name] = price -- models/free-market.can:4185
			end -- models/free-market.can:4185
		end, -- models/free-market.can:4185
		["force_set_sell_price"] = function(item_name, force_index, price) -- models/free-market.can:4188
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4189
			if f_sell_prices == nil then -- models/free-market.can:4190
				return  -- models/free-market.can:4190
			end -- models/free-market.can:4190
			f_sell_prices[item_name] = price -- models/free-market.can:4191
			inactive_sell_prices[force_index][item_name] = nil -- models/free-market.can:4192
		end, -- models/free-market.can:4192
		["force_set_buy_price"] = function(item_name, force_index, price) -- models/free-market.can:4194
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4195
			if f_buy_prices == nil then -- models/free-market.can:4196
				return  -- models/free-market.can:4196
			end -- models/free-market.can:4196
			f_buy_prices[item_name] = price -- models/free-market.can:4197
			inactive_buy_prices[force_index][item_name] = nil -- models/free-market.can:4198
		end, -- models/free-market.can:4198
		["reset_AI_force_storage"] = function(force_index) -- models/free-market.can:4200
			local f_sell_prices = sell_prices[force_index] -- models/free-market.can:4201
			if f_sell_prices == nil then -- models/free-market.can:4202
				return  -- models/free-market.can:4202
			end -- models/free-market.can:4202
			local f_inactive_sell_prices = inactive_sell_prices[force_index] -- models/free-market.can:4204
			for item_name, price in pairs(f_inactive_sell_prices) do -- models/free-market.can:4205
				f_sell_prices[item_name] = price -- models/free-market.can:4206
				f_inactive_sell_prices[item_name] = nil -- models/free-market.can:4207
			end -- models/free-market.can:4207
			local f_buy_prices = buy_prices[force_index] -- models/free-market.can:4209
			local f_inactive_buy_prices = inactive_buy_prices[force_index] -- models/free-market.can:4210
			for item_name, price in pairs(f_inactive_buy_prices) do -- models/free-market.can:4211
				f_buy_prices[item_name] = price -- models/free-market.can:4212
				f_inactive_buy_prices[item_name] = nil -- models/free-market.can:4213
			end -- models/free-market.can:4213
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4217
			local f_storage = storages[force_index] -- models/free-market.can:4218
			for item_name in pairs(f_buy_prices) do -- models/free-market.can:4219
				f_storage[item_name] = 2000000000 -- models/free-market.can:4220
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4221
			end -- models/free-market.can:4221
			for item_name in pairs(f_sell_prices) do -- models/free-market.can:4223
				f_storage[item_name] = 2000000000 -- models/free-market.can:4224
				f_storages_limit[item_name] = 4000000000 -- models/free-market.can:4225
			end -- models/free-market.can:4225
		end, -- models/free-market.can:4225
		["get_item_limit"] = function(item_name, force_index) -- models/free-market.can:4228
			local f_storages_limit = storages_limit[force_index] -- models/free-market.can:4229
			if f_storages_limit == nil then -- models/free-market.can:4230
				return  -- models/free-market.can:4230
			end -- models/free-market.can:4230
			return f_storages_limit[item_name] -- models/free-market.can:4231
		end, -- models/free-market.can:4231
		["get_default_storage_limit"] = function(force_index) -- models/free-market.can:4233
			return default_storage_limit[force_index] -- models/free-market.can:4234
		end, -- models/free-market.can:4234
		["get_inactive_universal_transfer_boxes"] = function() -- models/free-market.can:4236
			return inactive_universal_transfer_boxes -- models/free-market.can:4236
		end, -- models/free-market.can:4236
		["get_inactive_universal_bin_boxes"] = function() -- models/free-market.can:4237
			return inactive_universal_bin_boxes -- models/free-market.can:4237
		end, -- models/free-market.can:4237
		["get_inactive_bin_boxes"] = function() -- models/free-market.can:4238
			return inactive_bin_boxes -- models/free-market.can:4238
		end, -- models/free-market.can:4238
		["get_inactive_transfer_boxes"] = function() -- models/free-market.can:4239
			return inactive_transfer_boxes -- models/free-market.can:4239
		end, -- models/free-market.can:4239
		["get_inactive_sell_prices"] = function() -- models/free-market.can:4240
			return inactive_sell_prices -- models/free-market.can:4240
		end, -- models/free-market.can:4240
		["get_inactive_buy_prices"] = function() -- models/free-market.can:4241
			return inactive_buy_prices -- models/free-market.can:4241
		end, -- models/free-market.can:4241
		["get_inactive_buy_boxes"] = function() -- models/free-market.can:4242
			return inactive_buy_boxes -- models/free-market.can:4242
		end, -- models/free-market.can:4242
		["get_universal_bin_boxes"] = function() -- models/free-market.can:4243
			return universal_bin_boxes -- models/free-market.can:4243
		end, -- models/free-market.can:4243
		["get_transfer_boxes"] = function() -- models/free-market.can:4244
			return transfer_boxes -- models/free-market.can:4244
		end, -- models/free-market.can:4244
		["get_bin_boxes"] = function() -- models/free-market.can:4245
			return bin_boxes -- models/free-market.can:4245
		end, -- models/free-market.can:4245
		["get_pull_boxes"] = function() -- models/free-market.can:4246
			return pull_boxes -- models/free-market.can:4246
		end, -- models/free-market.can:4246
		["get_buy_boxes"] = function() -- models/free-market.can:4247
			return buy_boxes -- models/free-market.can:4247
		end, -- models/free-market.can:4247
		["get_sell_prices"] = function() -- models/free-market.can:4248
			return sell_prices -- models/free-market.can:4248
		end, -- models/free-market.can:4248
		["get_buy_prices"] = function() -- models/free-market.can:4249
			return buy_prices -- models/free-market.can:4249
		end, -- models/free-market.can:4249
		["get_embargoes"] = function() -- models/free-market.can:4250
			return embargoes -- models/free-market.can:4250
		end, -- models/free-market.can:4250
		["get_open_box"] = function() -- models/free-market.can:4251
			return open_box -- models/free-market.can:4251
		end, -- models/free-market.can:4251
		["get_all_boxes"] = function() -- models/free-market.can:4252
			return all_boxes -- models/free-market.can:4252
		end, -- models/free-market.can:4252
		["get_active_forces"] = function() -- models/free-market.can:4253
			return active_forces -- models/free-market.can:4253
		end, -- models/free-market.can:4253
		["get_storages"] = function() -- models/free-market.can:4254
			return storages -- models/free-market.can:4254
		end -- models/free-market.can:4254
	}) -- models/free-market.can:4254
end -- models/free-market.can:4254
local function link_data() -- models/free-market.can:4258
	mod_data = global["free_market"] -- models/free-market.can:4259
	bin_boxes = mod_data["bin_boxes"] -- models/free-market.can:4260
	inactive_bin_boxes = mod_data["inactive_bin_boxes"] -- models/free-market.can:4261
	universal_bin_boxes = mod_data["universal_bin_boxes"] -- models/free-market.can:4262
	inactive_universal_bin_boxes = mod_data["universal_inactive_bin_boxes"] -- models/free-market.can:4263
	pull_boxes = mod_data["pull_boxes"] -- models/free-market.can:4264
	inactive_universal_transfer_boxes = mod_data["inactive_universal_transfer_boxes"] -- models/free-market.can:4265
	inactive_transfer_boxes = mod_data["inactive_transfer_boxes"] -- models/free-market.can:4266
	inactive_buy_boxes = mod_data["inactive_buy_boxes"] -- models/free-market.can:4267
	universal_transfer_boxes = mod_data["universal_transfer_boxes"] -- models/free-market.can:4268
	transfer_boxes = mod_data["transfer_boxes"] -- models/free-market.can:4269
	buy_boxes = mod_data["buy_boxes"] -- models/free-market.can:4270
	embargoes = mod_data["embargoes"] -- models/free-market.can:4271
	inactive_sell_prices = mod_data["inactive_sell_prices"] -- models/free-market.can:4272
	inactive_buy_prices = mod_data["inactive_buy_prices"] -- models/free-market.can:4273
	sell_prices = mod_data["sell_prices"] -- models/free-market.can:4274
	buy_prices = mod_data["buy_prices"] -- models/free-market.can:4275
	item_HUD = mod_data["item_hinter"] -- models/free-market.can:4276
	open_box = mod_data["open_box"] -- models/free-market.can:4277
	all_boxes = mod_data["all_boxes"] -- models/free-market.can:4278
	active_forces = mod_data["active_forces"] -- models/free-market.can:4279
	default_storage_limit = mod_data["default_storage_limit"] -- models/free-market.can:4280
	storages_limit = mod_data["storages_limit"] -- models/free-market.can:4281
	storages = mod_data["storages"] -- models/free-market.can:4282
end -- models/free-market.can:4282
local function update_global_data() -- models/free-market.can:4285
	global["free_market"] = global["free_market"] or {} -- models/free-market.can:4286
	mod_data = global["free_market"] -- models/free-market.can:4287
	mod_data["item_hinter"] = mod_data["item_hinter"] or {} -- models/free-market.can:4288
	mod_data["open_box"] = {} -- models/free-market.can:4289
	mod_data["active_forces"] = mod_data["active_forces"] or {} -- models/free-market.can:4290
	mod_data["bin_boxes"] = mod_data["bin_boxes"] or {} -- models/free-market.can:4291
	mod_data["inactive_bin_boxes"] = mod_data["inactive_bin_boxes"] or {} -- models/free-market.can:4292
	mod_data["universal_bin_boxes"] = mod_data["universal_bin_boxes"] or {} -- models/free-market.can:4293
	mod_data["universal_inactive_bin_boxes"] = mod_data["universal_inactive_bin_boxes"] or {} -- models/free-market.can:4294
	mod_data["inactive_universal_transfer_boxes"] = mod_data["inactive_universal_transfer_boxes"] or {} -- models/free-market.can:4295
	mod_data["inactive_transfer_boxes"] = mod_data["inactive_transfer_boxes"] or {} -- models/free-market.can:4296
	mod_data["inactive_buy_boxes"] = mod_data["inactive_buy_boxes"] or {} -- models/free-market.can:4297
	mod_data["universal_transfer_boxes"] = mod_data["universal_transfer_boxes"] or {} -- models/free-market.can:4298
	mod_data["transfer_boxes"] = mod_data["transfer_boxes"] or {} -- models/free-market.can:4299
	mod_data["pull_boxes"] = mod_data["pull_boxes"] or {} -- models/free-market.can:4300
	mod_data["buy_boxes"] = mod_data["buy_boxes"] or {} -- models/free-market.can:4301
	mod_data["inactive_sell_prices"] = mod_data["inactive_sell_prices"] or {} -- models/free-market.can:4302
	mod_data["inactive_buy_prices"] = mod_data["inactive_buy_prices"] or {} -- models/free-market.can:4303
	mod_data["sell_prices"] = mod_data["sell_prices"] or {} -- models/free-market.can:4304
	mod_data["buy_prices"] = mod_data["buy_prices"] or {} -- models/free-market.can:4305
	mod_data["embargoes"] = mod_data["embargoes"] or {} -- models/free-market.can:4306
	mod_data["all_boxes"] = mod_data["all_boxes"] or {} -- models/free-market.can:4307
	mod_data["default_storage_limit"] = mod_data["default_storage_limit"] or {} -- models/free-market.can:4308
	mod_data["storages_limit"] = mod_data["storages_limit"] or {} -- models/free-market.can:4309
	mod_data["storages"] = mod_data["storages"] or {} -- models/free-market.can:4310
	link_data() -- models/free-market.can:4312
	clear_invalid_data() -- models/free-market.can:4314
	for item_name, item in pairs(game["item_prototypes"]) do -- models/free-market.can:4316
		if item["stack_size"] <= 5 then -- models/free-market.can:4317
			for _, f_storage_limit in pairs(storages_limit) do -- models/free-market.can:4318
				f_storage_limit[item_name] = f_storage_limit[item_name] or 1 -- models/free-market.can:4319
			end -- models/free-market.can:4319
		end -- models/free-market.can:4319
	end -- models/free-market.can:4319
	init_force_data(game["forces"]["player"]["index"]) -- models/free-market.can:4324
	for _, force in pairs(game["forces"]) do -- models/free-market.can:4326
		if # force["players"] > 0 then -- models/free-market.can:4327
			init_force_data(force["index"]) -- models/free-market.can:4328
		end -- models/free-market.can:4328
	end -- models/free-market.can:4328
	for _, player in pairs(game["players"]) do -- models/free-market.can:4333
		if player["valid"] then -- models/free-market.can:4334
			local relative = player["gui"]["relative"] -- models/free-market.can:4335
			if relative["FM_buttons"] == nil then -- models/free-market.can:4336
				create_left_relative_gui(player) -- models/free-market.can:4337
			end -- models/free-market.can:4337
			if relative["FM_boxes_frame"] == nil then -- models/free-market.can:4339
				create_top_relative_gui(player) -- models/free-market.can:4340
			end -- models/free-market.can:4340
		end -- models/free-market.can:4340
	end -- models/free-market.can:4340
end -- models/free-market.can:4340
local function on_configuration_changed(event) -- models/free-market.can:4346
	update_global_data() -- models/free-market.can:4347
	local mod_changes = event["mod_changes"]["iFreeMarket"] -- models/free-market.can:4349
	if not (mod_changes and mod_changes["old_version"]) then -- models/free-market.can:4350
		return  -- models/free-market.can:4350
	end -- models/free-market.can:4350
	local version = tonumber(string["gmatch"](mod_changes["old_version"], "%d+.%d+")()) -- models/free-market.can:4352
	if version < 0.34 then -- models/free-market.can:4354
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4355
			local index = force["index"] -- models/free-market.can:4356
			if sell_prices[index] then -- models/free-market.can:4357
				init_force_data(index) -- models/free-market.can:4358
			end -- models/free-market.can:4358
		end -- models/free-market.can:4358
		for _, player in pairs(game["players"]) do -- models/free-market.can:4362
			if player["valid"] then -- models/free-market.can:4363
				create_top_relative_gui(player) -- models/free-market.can:4364
			end -- models/free-market.can:4364
		end -- models/free-market.can:4364
	end -- models/free-market.can:4364
	if version < 0.33 then -- models/free-market.can:4369
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4370
			local index = force["index"] -- models/free-market.can:4371
			if sell_prices[index] and mod_data["sell_boxes"] then -- models/free-market.can:4373
				transfer_boxes[index] = mod_data["sell_boxes"][index] -- models/free-market.can:4374
				inactive_transfer_boxes[index] = mod_data["inactive_sell_boxes"][index] -- models/free-market.can:4375
			end -- models/free-market.can:4375
			mod_data["sell_boxes"] = nil -- models/free-market.can:4377
			mod_data["inactive_sell_boxes"] = nil -- models/free-market.can:4378
		end -- models/free-market.can:4378
		local sprite_data = { -- models/free-market.can:4381
			["target_offset"] = BOX_TYPE_SPRITE_OFFSET, -- models/free-market.can:4382
			["only_in_alt_mode"] = true, -- models/free-market.can:4383
			["x_scale"] = 0.4, -- models/free-market.can:4384
			["y_scale"] = 0.4 -- models/free-market.can:4384
		} -- models/free-market.can:4384
		for _, box_data in pairs(all_boxes) do -- models/free-market.can:4386
			rendering_destroy(box_data[2]) -- models/free-market.can:4387
			local entity = box_data[1] -- models/free-market.can:4389
			sprite_data["target"] = entity -- models/free-market.can:4390
			sprite_data["surface"] = entity["surface"] -- models/free-market.can:4391
			if is_public_titles == false then -- models/free-market.can:4392
				sprite_data["forces"] = { entity["force"] } -- models/free-market.can:4393
			end -- models/free-market.can:4393
			local box_type = box_data[3] -- models/free-market.can:4396
			if box_type == 2 then -- models/free-market.can:1
				box_data[3] = 4 -- models/free-market.can:1
				sprite_data["sprite"] = "FM_transfer" -- models/free-market.can:4399
			elseif box_type == 3 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_pull_out" -- models/free-market.can:4401
			elseif box_type == 1 then -- models/free-market.can:1
				sprite_data["sprite"] = "FM_buy" -- models/free-market.can:4403
			end -- models/free-market.can:4403
			box_data[2] = draw_sprite(sprite_data) -- models/free-market.can:4406
		end -- models/free-market.can:4406
		for _, player in pairs(game["players"]) do -- models/free-market.can:4409
			if player["valid"] then -- models/free-market.can:4410
				create_top_relative_gui(player) -- models/free-market.can:4411
			end -- models/free-market.can:4411
		end -- models/free-market.can:4411
	end -- models/free-market.can:4411
	if version < 0.32 then -- models/free-market.can:4416
		for _, force in pairs(game["forces"]) do -- models/free-market.can:4417
			local index = force["index"] -- models/free-market.can:4418
			if transfer_boxes[index] then -- models/free-market.can:4419
				init_force_data(index) -- models/free-market.can:4420
				default_storage_limit[index] = max_storage_threshold -- models/free-market.can:4421
			end -- models/free-market.can:4421
		end -- models/free-market.can:4421
	end -- models/free-market.can:4421
	if version < 0.31 then -- models/free-market.can:4426
		for _, player in pairs(game["players"]) do -- models/free-market.can:4427
			if player["valid"] then -- models/free-market.can:4428
				delete_item_price_HUD(player) -- models/free-market.can:4429
				if player["connected"] then -- models/free-market.can:4430
					create_item_price_HUD(player) -- models/free-market.can:4431
				end -- models/free-market.can:4431
			end -- models/free-market.can:4431
		end -- models/free-market.can:4431
	end -- models/free-market.can:4431
	if version < 0.30 then -- models/free-market.can:4437
		for _, player in pairs(game["players"]) do -- models/free-market.can:4438
			if player["valid"] then -- models/free-market.can:4439
				local screen = player["gui"]["screen"] -- models/free-market.can:4440
				local frame = screen["FM_prices_frame"] -- models/free-market.can:4441
				if frame then -- models/free-market.can:4442
					frame["destroy"]() -- models/free-market.can:4443
				end -- models/free-market.can:4443
			end -- models/free-market.can:4443
		end -- models/free-market.can:4443
	end -- models/free-market.can:4443
	if version < 0.29 then -- models/free-market.can:4449
		for _, player in pairs(game["players"]) do -- models/free-market.can:4450
			if player["valid"] then -- models/free-market.can:4451
				local screen = player["gui"]["screen"] -- models/free-market.can:4452
				if screen["FM_sell_prices_frame"] then -- models/free-market.can:4453
					screen["FM_sell_prices_frame"]["destroy"]() -- models/free-market.can:4454
				end -- models/free-market.can:4454
				if screen["FM_buy_prices_frame"] then -- models/free-market.can:4456
					screen["FM_buy_prices_frame"]["destroy"]() -- models/free-market.can:4457
				end -- models/free-market.can:4457
				switch_buy_prices_gui(player) -- models/free-market.can:4459
				switch_sell_prices_gui(player) -- models/free-market.can:4460
			end -- models/free-market.can:4460
		end -- models/free-market.can:4460
	end -- models/free-market.can:4460
	if version < 0.28 then -- models/free-market.can:4465
		for _, player in pairs(game["players"]) do -- models/free-market.can:4466
			if player["valid"] and player["mod_settings"]["FM_show_item_price"]["value"] then -- models/free-market.can:4467
				create_item_price_HUD(player) -- models/free-market.can:4468
			end -- models/free-market.can:4468
		end -- models/free-market.can:4468
	end -- models/free-market.can:4468
	if version < 0.21 then -- models/free-market.can:4473
		for _, player in pairs(game["players"]) do -- models/free-market.can:4474
			if player["valid"] then -- models/free-market.can:4475
				create_top_relative_gui(player) -- models/free-market.can:4476
			end -- models/free-market.can:4476
		end -- models/free-market.can:4476
	end -- models/free-market.can:4476
	if version < 0.22 then -- models/free-market.can:4481
		for _, player in pairs(game["players"]) do -- models/free-market.can:4482
			if player["valid"] then -- models/free-market.can:4483
				create_left_relative_gui(player) -- models/free-market.can:4484
			end -- models/free-market.can:4484
		end -- models/free-market.can:4484
	end -- models/free-market.can:4484
	if version < 0.26 then -- models/free-market.can:4489
		for _, player in pairs(game["players"]) do -- models/free-market.can:4490
			if player["valid"] then -- models/free-market.can:4491
				switch_sell_prices_gui(player) -- models/free-market.can:4492
				switch_buy_prices_gui(player) -- models/free-market.can:4493
			end -- models/free-market.can:4493
		end -- models/free-market.can:4493
		game["print"]({ -- models/free-market.can:4496
			"", -- models/free-market.can:4496
			{ "mod-name.free-market" }, -- models/free-market.can:4496
			COLON, -- models/free-market.can:4496
			" added price notification with settings" -- models/free-market.can:4496
		}) -- models/free-market.can:4496
	end -- models/free-market.can:4496
end -- models/free-market.can:4496
do -- models/free-market.can:4501
	local function set_filters() -- models/free-market.can:4501
		local filters = { -- models/free-market.can:4502
			{ -- models/free-market.can:4503
				["filter"] = "type", -- models/free-market.can:4503
				["mode"] = "or", -- models/free-market.can:4503
				["type"] = "container" -- models/free-market.can:4503
			}, -- models/free-market.can:4503
			{ -- models/free-market.can:4504
				["filter"] = "type", -- models/free-market.can:4504
				["mode"] = "or", -- models/free-market.can:4504
				["type"] = "logistic-container" -- models/free-market.can:4504
			} -- models/free-market.can:4504
		} -- models/free-market.can:4504
		script["set_event_filter"](defines["events"]["on_entity_died"], filters) -- models/free-market.can:4506
		script["set_event_filter"](defines["events"]["on_robot_mined_entity"], filters) -- models/free-market.can:4507
		script["set_event_filter"](defines["events"]["script_raised_destroy"], filters) -- models/free-market.can:4508
		script["set_event_filter"](defines["events"]["on_player_mined_entity"], filters) -- models/free-market.can:4509
	end -- models/free-market.can:4509
	M["on_load"] = function() -- models/free-market.can:4512
		link_data() -- models/free-market.can:4513
		set_filters() -- models/free-market.can:4514
	end -- models/free-market.can:4514
	M["on_init"] = function() -- models/free-market.can:4516
		update_global_data() -- models/free-market.can:4517
		set_filters() -- models/free-market.can:4518
	end -- models/free-market.can:4518
end -- models/free-market.can:4518
M["on_configuration_changed"] = on_configuration_changed -- models/free-market.can:4521
M["add_remote_interface"] = add_remote_interface -- models/free-market.can:4522
M["events"] = { -- models/free-market.can:4527
	[defines["events"]["on_surface_deleted"]] = clear_invalid_entities, -- models/free-market.can:4528
	[defines["events"]["on_surface_cleared"]] = clear_invalid_entities, -- models/free-market.can:4529
	[defines["events"]["on_chunk_deleted"]] = clear_invalid_entities, -- models/free-market.can:4530
	[defines["events"]["on_player_created"]] = on_player_created, -- models/free-market.can:4531
	[defines["events"]["on_player_joined_game"]] = on_player_joined_game, -- models/free-market.can:4532
	[defines["events"]["on_player_left_game"]] = on_player_left_game, -- models/free-market.can:4533
	[defines["events"]["on_player_cursor_stack_changed"]] = function(event) -- models/free-market.can:4534
		pcall(on_player_cursor_stack_changed, event) -- models/free-market.can:4535
	end, -- models/free-market.can:4535
	[defines["events"]["on_player_removed"]] = delete_player_data, -- models/free-market.can:4537
	[defines["events"]["on_player_changed_force"]] = on_player_changed_force, -- models/free-market.can:4538
	[defines["events"]["on_player_changed_surface"]] = on_player_changed_surface, -- models/free-market.can:4539
	[defines["events"]["on_player_selected_area"]] = on_player_selected_area, -- models/free-market.can:4540
	[defines["events"]["on_player_alt_selected_area"]] = on_player_alt_selected_area, -- models/free-market.can:4541
	[defines["events"]["on_player_mined_entity"]] = clear_box_data, -- models/free-market.can:4542
	[defines["events"]["on_gui_selection_state_changed"]] = on_gui_selection_state_changed, -- models/free-market.can:4543
	[defines["events"]["on_gui_elem_changed"]] = on_gui_elem_changed, -- models/free-market.can:4544
	[defines["events"]["on_gui_click"]] = function(event) -- models/free-market.can:4545
		on_gui_click(event) -- models/free-market.can:4546
	end, -- models/free-market.can:4546
	[defines["events"]["on_gui_closed"]] = on_gui_closed, -- models/free-market.can:4548
	[defines["events"]["on_selected_entity_changed"]] = on_selected_entity_changed, -- models/free-market.can:4549
	[defines["events"]["on_force_created"]] = on_force_created, -- models/free-market.can:4550
	[defines["events"]["on_forces_merging"]] = on_forces_merging, -- models/free-market.can:4551
	[defines["events"]["on_runtime_mod_setting_changed"]] = on_runtime_mod_setting_changed, -- models/free-market.can:4552
	[defines["events"]["on_force_cease_fire_changed"]] = function(event) -- models/free-market.can:4553
		if is_auto_embargo then -- models/free-market.can:4555
			pcall(on_force_cease_fire_changed, event) -- models/free-market.can:4556
		end -- models/free-market.can:4556
	end, -- models/free-market.can:4556
	[defines["events"]["on_robot_mined_entity"]] = clear_box_data, -- models/free-market.can:4559
	[defines["events"]["script_raised_destroy"]] = clear_box_data, -- models/free-market.can:4560
	[defines["events"]["on_entity_died"]] = clear_box_data, -- models/free-market.can:4561
	["FM_set-pull-box"] = function(event) -- models/free-market.can:4562
		pcall(set_pull_box_key_pressed, event) -- models/free-market.can:4563
	end, -- models/free-market.can:4563
	["FM_set-transfer-box"] = function(event) -- models/free-market.can:4565
		pcall(set_transfer_box_key_pressed, event) -- models/free-market.can:4566
	end, -- models/free-market.can:4566
	["FM_set-universal-transfer-box"] = function(event) -- models/free-market.can:4568
		pcall(set_universal_transfer_box_key_pressed, event) -- models/free-market.can:4569
	end, -- models/free-market.can:4569
	["FM_set-bin-box"] = function(event) -- models/free-market.can:4571
		pcall(set_bin_box_key_pressed, event) -- models/free-market.can:4572
	end, -- models/free-market.can:4572
	["FM_set-universal-bin-box"] = function(event) -- models/free-market.can:4574
		pcall(set_universal_bin_box_key_pressed, event) -- models/free-market.can:4575
	end, -- models/free-market.can:4575
	["FM_set-buy-box"] = function(event) -- models/free-market.can:4577
		pcall(set_buy_box_key_pressed, event) -- models/free-market.can:4578
	end -- models/free-market.can:4578
} -- models/free-market.can:4578
M["on_nth_tick"] = { -- models/free-market.can:4582
	[update_buy_tick] = check_buy_boxes, -- models/free-market.can:4583
	[update_transfer_tick] = check_transfer_boxes, -- models/free-market.can:4584
	[update_pull_tick] = check_pull_boxes, -- models/free-market.can:4585
	[CHECK_FORCES_TICK] = check_forces, -- models/free-market.can:4586
	[CHECK_TEAMS_DATA_TICK] = check_teams_data -- models/free-market.can:4587
} -- models/free-market.can:4587
M["commands"] = { -- models/free-market.can:4590
	["embargo"] = function(cmd) -- models/free-market.can:4591
		open_embargo_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4592
	end, -- models/free-market.can:4592
	["prices"] = function(cmd) -- models/free-market.can:4594
		switch_prices_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4595
	end, -- models/free-market.can:4595
	["price_list"] = function(cmd) -- models/free-market.can:4597
		open_price_list_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4598
	end, -- models/free-market.can:4598
	["storage"] = function(cmd) -- models/free-market.can:4600
		open_storage_gui(game["get_player"](cmd["player_index"])) -- models/free-market.can:4601
	end -- models/free-market.can:4601
} -- models/free-market.can:4601
return M -- models/free-market.can:4606
