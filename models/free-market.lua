---@class FreeMarket : module
local M = {}


--#region Global data
---@class mod_data
---@type table<string, table>
local mod_data

-- {force index = {[force index] = boolean}}
---@class embargoes
---@type table<number, table<number, boolean>>
local embargoes

-- {force index = {[item name] = price}}
---@class sell_prices
---@type table<number, table<string, number>>
local sell_prices

-- {force index = {[item name] = price}}
---@class inactive_sell_prices
---@type table<number, table<string, number>>
local inactive_sell_prices

-- {force index = {[item name] = price}}
---@class buy_prices
---@type table<number, table<string, number>>
local buy_prices

-- {force index = {[item name] = price}}
---@class inactive_buy_prices
---@type table<number, table<string, number>>
local inactive_buy_prices

--- {force index = {[item name] = {LuaEntity}}}
---@class transfer_boxes
---@type table<number, table<string, table<number, LuaEntity>>>
local transfer_boxes

--- {force index = {[item name] = {LuaEntity}}}
---@class inactive_transfer_boxes
---@type table<number, table<string, table<number, LuaEntity>>>
local inactive_transfer_boxes

-- {force index = {[item name] = {LuaEntity}}}
---@class bin_boxes
---@type table<number, table>
local bin_boxes

-- {force index = {[item name] = {LuaEntity}}}
---@class inactive_bin_boxes
---@type table<number, table>
local inactive_bin_boxes

--- {force index = {LuaEntity}}
---@class universal_transfer_boxes
---@type table<number, table<number, LuaEntity>>
local universal_transfer_boxes

--- {force index = {LuaEntity}}
---@class inactive_universal_transfer_boxes
---@type table<number, table<number, LuaEntity>>
local inactive_universal_transfer_boxes

--- {force index = {LuaEntity}}
---@class universal_bin_boxes
---@type table<number, table<number, LuaEntity>>
local universal_bin_boxes

--- {force index = {LuaEntity}}
---@class inactive_universal_bin_boxes
---@type table<number, table<number, LuaEntity>>
local inactive_universal_bin_boxes

-- {force index = {[item name] = {LuaEntity, count}}}
---@class buy_boxes
---@type table<number, table>
local buy_boxes

-- {force index = {[item name] = {LuaEntity, count}}}
---@class inactive_buy_boxes
---@type table<number, table>
local inactive_buy_boxes

--- {force index = {[item name] = {LuaEntity}}}
---@class pull_boxes
---@type table<number, table<string, table<number, LuaEntity>>>
local pull_boxes

---@class open_box
---@type table<number, table>
local open_box

---@class all_boxes
---@field [1] LuaEntity
---@field [2] number # id
---@field [3] number # box_type
---@field [4] table # items data of box
---@field [5] string? # item name
---@type table<number, table>
local all_boxes

-- key, force index\
-- Should give valid force indexes
---@class active_forces
---@type table<number, number>
local active_forces

-- {force index = {[item name] = count}}
---@class storages
---@type table<number, table<string, number>>
local storages

-- {force index = {[item name] = max count}}
---@class storages_limit
---@type table<number, table<string, number>>
local storages_limit

-- {force index = max count}
---@class default_storage_limit
---@type table<number, number>
local default_storage_limit

-- {force index = {Gui elements}}
---@class item_HUD
---@type table<number, table>
---@field [1] GuiElement # flow
---@field [2] GuiElement # sell_price
---@field [3] GuiElement # buy_price
---@field [4] GuiElement # item_label
---@field [5] GuiElement # storage_count
---@field [6] GuiElement # storage_limit
local item_HUD

--#endregion


--#region Constants
local tremove = table.remove
local find = string.find
local sub = string.sub
local call = remote.call
local draw_sprite = rendering.draw_sprite
local Rget_type = rendering.get_type
local get_render_target = rendering.get_target
local is_render_valid = rendering.is_valid
local rendering_destroy = rendering.destroy
local print_to_rcon = rcon.print
local UNIVERSAL_BIN_TYPE = 7
local BIN_TYPE = 6
local UNIVERSAL_TRANSFER_TYPE = 5
local TRANSFER_TYPE = 4
local PULL_TYPE = 3
local SELL_TYPE = 2
local BUY_TYPE = 1
local CHECK_FORCES_TICK = 60 * 60 * 1.5
local CHECK_TEAMS_DATA_TICK = 60 * 60 * 25
local chest_inventory_type = defines.inventory.chest
local EMPTY_TABLE = {}
local WHITE_COLOR = {1, 1, 1}
local BOX_TYPE_SPRITE_OFFSET = {0, 0.2}
local HINT_SPRITE_OFFSET = {0, -0.25}
local COLON = {"colon"}
local LABEL = {type = "label"}
local FLOW = {type = "flow"}
local VERTICAL_FLOW = {type = "flow", direction = "vertical"}
local SPRITE_BUTTON = {type = "sprite-button"}
local SLOT_BUTTON = {type = "sprite-button", style = "slot_button"}
local EMPTY_WIDGET = {type = "empty-widget"}
local PRICE_LABEL = {type = "label", style = "FM_price_label"}
local POST_PRICE_LABEL = {type = "label", style = "FM_price_label", caption = '$'}
local PRICE_FRAME = {type = "frame", style = "FM_price_frame"}
local SELL_PRICE_BUTTON = {type = "sprite-button", style = "slot_button", name = "FM_open_sell_price"} -- TODO: change the style
local BUY_PRICE_BUTTON = {type = "sprite-button", style = "slot_button", name = "FM_open_buy_price"} -- TODO: change the style
local ALLOWED_TYPES = {["container"] = true, ["logistic-container"] = true}
local TITLEBAR_FLOW = {type = "flow", style = "flib_titlebar_flow", name = "titlebar"}
local DRAG_HANDLER = {type = "empty-widget", style = "flib_dialog_footer_drag_handle", name = "drag_handler"}
local STORAGE_LIMIT_TEXTFIELD = {type = "textfield", name = "storage_limit",  style = "FM_price_textfield", numeric = true, allow_decimal = false, allow_negative = false}
local DEFAULT_LIMIT_TEXTFIELD = {type = "textfield", name = "FM_default_limit",  style = "FM_price_textfield", numeric = true, allow_decimal = false, allow_negative = false}
local SELL_PRICE_TEXTFIELD = {type = "textfield", name = "sell_price", style = "FM_price_textfield", numeric = true, allow_decimal = false, allow_negative = false}
local BUY_PRICE_TEXTFIELD = {type = "textfield", name = "buy_price",  style = "FM_price_textfield", numeric = true, allow_decimal = false, allow_negative = false}
local SCROLL_PANE = {
	type = "scroll-pane",
	name = "scroll-pane",
	horizontal_scroll_policy = "never"
}
local CLOSE_BUTTON = {
	hovered_sprite = "utility/close_black",
	clicked_sprite = "utility/close_black",
	sprite = "utility/close_white",
	style = "frame_action_button",
	type = "sprite-button",
	name = "FM_close"
}
local ITEM_FILTERS = {
	{filter = "type", type = "blueprint-book", invert = true, mode = "and"},
	{filter = "selection-tool", invert = true, mode = "and"}
}
local FM_ITEM_ELEMENT = {type = "choose-elem-button", name = "FM_item", elem_type = "item", elem_filters = ITEM_FILTERS}
local CHECK_BUTTON = {
	type = "sprite-button",
	style = "item_and_count_select_confirm",
	sprite = "utility/check_mark"
}
--#endregion


--#region Settings
---@type number
local update_buy_tick = settings.global["FM_update-tick"].value

---@type number
local update_transfer_tick = settings.global["FM_update-transfer-tick"].value

---@type number
local update_pull_tick = settings.global["FM_update-pull-tick"].value

---@type boolean
local is_auto_embargo = settings.global["FM_enable-auto-embargo"].value

---@type number
local money_treshold = settings.global["FM_money-treshold"].value

---@type number
local minimal_price = settings.global["FM_minimal-price"].value

---@type number
local maximal_price = settings.global["FM_maximal-price"].value

---@type number
local skip_offline_team_chance = settings.global["FM_skip_offline_team_chance"].value

---@type number
local max_storage_threshold = settings.global["FM_max_storage_threshold"].value

---@type boolean
local is_public_titles = settings.global["FM_is-public-titles"].value

---@type boolean
local is_reset_public = settings.global["FM_is_reset_public"].value
--#endregion


--#region Global functions

---@param target  LuaForce|LuaPlayer # From whom the data?
---@param getter? LuaForce|LuaPlayer # Print to whom? (game by default)
function print_force_data(target, getter)
	if getter then
		if not getter.valid then
			log("Invalid object")
			return
		end
	else
		getter = game
	end

	local index
	local object_name = target.object_name
	if object_name == "LuaPlayer" then
		index = target.force.index
	elseif object_name == "LuaForce" then
		index = target.index
	else
		log("Invalid type")
		return
	end

	local print_to_target = getter.print
	print_to_target("Inactive sell prices:" .. serpent.line(inactive_sell_prices[index]))
	print_to_target("Inactive buy prices:" .. serpent.line(inactive_buy_prices[index]))
	print_to_target("Sell prices:" .. serpent.line(sell_prices[index]))
	print_to_target("Buy prices:" .. serpent.line(buy_prices[index]))
	print_to_target("Universal transferers:" .. serpent.line(universal_transfer_boxes[index]))
	print_to_target("Transferers:" .. serpent.line(transfer_boxes[index]))
	print_to_target("Bin boxes:" .. serpent.line(bin_boxes[index]))
	print_to_target("Universal bin boxes:" .. serpent.line(universal_bin_boxes[index]))
	print_to_target("Pull boxes:" .. serpent.line(pull_boxes[index]))
	print_to_target("Buy boxes:" .. serpent.line(buy_boxes[index]))
	print_to_target("Embargoes:" .. serpent.line(embargoes[index]))
	print_to_target("Storage:" .. serpent.line(storages[index]))
end

--#endregion


--#region Function for RCON

---@param name string
function getRconData(name)
	print_to_rcon(game.table_to_json(mod_data[name]))
end

---@param name string
---@param force LuaForce
function getRconForceData(name, force)
	if not force.valid then return end
	print_to_rcon(game.table_to_json(mod_data[name][force.index]))
end

---@param name string
---@param force_index number
function getRconForceDataByIndex(name, force_index)
	print_to_rcon(game.table_to_json(mod_data[name][force_index]))
end

--#endregion


--#region utils

---@param index number
local function clear_force_data(index)
	default_storage_limit[index] = nil
	inactive_sell_prices[index] = nil
	inactive_buy_prices[index] = nil
	bin_boxes[index] = nil
	inactive_bin_boxes[index] = nil
	universal_bin_boxes[index] = nil
	inactive_universal_bin_boxes[index] = nil
	inactive_universal_transfer_boxes[index] = nil
	inactive_transfer_boxes[index] = nil
	inactive_buy_boxes[index] = nil
	storages_limit[index] = nil
	sell_prices[index] = nil
	buy_prices[index] = nil
	pull_boxes[index] = nil
	universal_transfer_boxes[index] = nil
	transfer_boxes[index] = nil
	buy_boxes[index] = nil
	embargoes[index] = nil
	storages[index] = nil

	for _, force_data in pairs(embargoes) do
		force_data[index] = nil
	end

	for i, force_index in pairs(active_forces) do
		if force_index == index then
			tremove(active_forces, i)
			break
		end
	end
end

---@param index number
local function init_force_data(index)
	inactive_sell_prices[index] = inactive_sell_prices[index] or {}
	inactive_buy_prices[index] = inactive_buy_prices[index] or {}
	bin_boxes[index] = bin_boxes[index] or {}
	inactive_bin_boxes[index] = inactive_bin_boxes[index] or {}
	universal_bin_boxes[index] = universal_bin_boxes[index] or {}
	inactive_universal_bin_boxes[index] = inactive_universal_bin_boxes[index] or {}
	inactive_universal_transfer_boxes[index] = inactive_universal_transfer_boxes[index] or {}
	inactive_transfer_boxes[index] = inactive_transfer_boxes[index] or {}
	inactive_buy_boxes[index] = inactive_buy_boxes[index] or {}
	sell_prices[index] = sell_prices[index] or {}
	buy_prices[index] = buy_prices[index] or {}
	pull_boxes[index] = pull_boxes[index] or {}
	universal_transfer_boxes[index] = universal_transfer_boxes[index] or {}
	transfer_boxes[index] = transfer_boxes[index] or {}
	buy_boxes[index] = buy_boxes[index] or {}
	embargoes[index] = embargoes[index] or {}
	storages[index] = storages[index] or {}

	if storages_limit[index] == nil then
		storages_limit[index] = {}
		local f_storages_limit = storages_limit[index]
		for item_name, item in pairs(game.item_prototypes) do
			if item.stack_size <= 5 then
				f_storages_limit[item_name] = 1
			end
		end
	end
end

---@param entity LuaEntity #LuaEntity
---@param box_data all_boxes
local function remove_certain_transfer_box(entity, box_data)
	local force_index = entity.force.index
	local f_transfer_boxes = transfer_boxes[force_index]
	local item_name = box_data[5]
	local entities = f_transfer_boxes[item_name]
	for i = #entities, 1, -1 do
		if entities[i] == entity then
			all_boxes[entity.unit_number] = nil
			tremove(entities, i)
			if #entities == 0 then
				f_transfer_boxes[item_name] = nil
				local quantity_stored = storages[force_index][item_name]
				if quantity_stored == nil or quantity_stored <= 0 then
					local f_sell_prices = sell_prices[force_index]
					local sell_price = f_sell_prices[item_name]
					if sell_price then
						local count_in_storage = storages[force_index][item_name]
						if count_in_storage == nil or count_in_storage <= 0 then
							inactive_sell_prices[force_index][item_name] = sell_price
							f_sell_prices[item_name] = nil
						end
					end
				end
			end
			return
		end
	end
end

---@param entity LuaEntity #LuaEntity
---@param box_data all_boxes
local function remove_certain_bin_box(entity, box_data)
	local force_index = entity.force.index
	local f_bin_boxes = bin_boxes[force_index]
	local item_name = box_data[5]
	local entities = f_bin_boxes[item_name]
	for i = #entities, 1, -1 do
		if entities[i] == entity then
			all_boxes[entity.unit_number] = nil
			tremove(entities, i)
			if #entities == 0 then
				f_bin_boxes[item_name] = nil
				local quantity_stored = storages[force_index][item_name]
				if quantity_stored == nil or quantity_stored <= 0 then
					local f_sell_prices = sell_prices[force_index]
					local sell_price = f_sell_prices[item_name]
					if sell_price and transfer_boxes[force_index][item_name] == nil then
						local count_in_storage = storages[force_index][item_name]
						if count_in_storage == nil or count_in_storage <= 0 then
							inactive_sell_prices[force_index][item_name] = sell_price
							f_sell_prices[item_name] = nil
						end
					end
				end
			end
			return
		end
	end
end

---@param entity LuaEntity #LuaEntity
local function remove_certain_universal_transfer_box(entity)
	local force_index = entity.force.index
	local entities = universal_transfer_boxes[force_index]
	for i = #entities, 1, -1 do
		if entities[i] == entity then
			all_boxes[entity.unit_number] = nil
			tremove(entities, i)
			return
		end
	end
end

---@param entity LuaEntity #LuaEntity
local function remove_certain_universal_bin_box(entity)
	local force_index = entity.force.index
	local entities = universal_bin_boxes[force_index]
	for i = #entities, 1, -1 do
		if entities[i] == entity then
			all_boxes[entity.unit_number] = nil
			tremove(entities, i)
			return
		end
	end
end

---@param entity LuaEntity #LuaEntity
---@param box_data all_boxes
local function remove_certain_buy_box(entity, box_data)
	local force_index = entity.force.index
	local f_buy_boxes = buy_boxes[force_index]
	local item_name = box_data[5]
	local items_data = f_buy_boxes[item_name]
	for i = #items_data, 1, -1 do
		local buy_box = items_data[i]
		if buy_box[1] == entity then
			tremove(items_data, i)
			all_boxes[entity.unit_number] = nil
			if #items_data == 0 then
				f_buy_boxes[item_name] = nil
				local f_buy_prices = buy_prices[force_index]
				local buy_price = f_buy_prices[item_name]
				if buy_price then
					inactive_buy_prices[force_index][item_name] = buy_price
					f_buy_prices[item_name] = nil
				end
			end
			return
		end
	end
end

---@param entity LuaEntity #LuaEntity
---@param box_data all_boxes
local function remove_certain_pull_box(entity, box_data)
	local force_index = entity.force.index
	local f_pull_boxes = pull_boxes[force_index]
	local item_name = box_data[5]
	local entities = f_pull_boxes[item_name]
	for i = #entities, 1, -1 do
		if entities[i] == entity then
			all_boxes[entity.unit_number] = nil
			tremove(entities, i)
			if #entities == 0 then
				f_pull_boxes[item_name] = nil
			end
			return
		end
	end
end

--TODO: improve for inactive boxes
---@param entity LuaEntity #LuaEntity
---@param item_name string
---@param count number
local function change_count_in_buy_box_data(entity, item_name, count)
	local data = buy_boxes[entity.force.index][item_name]
	for i = 1, #data do
		local buy_box = data[i]
		if buy_box[1] == entity then
			buy_box[2] = count
			return
		end
	end
end

local function clear_invalid_embargoes()
	local forces = game.forces
	for index in pairs(embargoes) do
		if forces[index] == nil then
			embargoes[index] = nil
		end
	end
	for _, forces_data in pairs(embargoes) do
		for index in pairs(forces_data) do
			if forces[index] == nil then
				forces_data[index] = nil
			end
		end
	end
end

---@param item_name string
---@param force LuaForce #LuaForce
---@param entity LuaEntity #LuaEntity
local function show_item_sprite_above_chest(item_name, force, entity)
	if #force.connected_players > 1 then
		draw_sprite{
			sprite = "item." .. item_name,
			target = entity,
			surface = entity.surface,
			forces = {force},
			time_to_live = 200,
			x_scale = 0.9,
			target_offset = HINT_SPRITE_OFFSET
		}
	end
end

---@param force_index number
local function reset_buy_boxes(force_index)
	for _, forces_data in pairs(buy_boxes[force_index]) do
		for _, entities_data in pairs(forces_data) do
			local unit_number = entities_data[1].unit_number
			rendering_destroy(all_boxes[unit_number][2])
			all_boxes[unit_number] = nil
		end
	end
	buy_boxes[force_index] = {}
end

---@param force_index number
local function reset_transfer_boxes(force_index)
	for _, entities_data in pairs(transfer_boxes[force_index]) do
		for i=1, #entities_data do
			local unit_number = entities_data[i].unit_number
			rendering_destroy(all_boxes[unit_number][2])
			all_boxes[unit_number] = nil
		end
	end
	transfer_boxes[force_index] = {}

	local entities = universal_transfer_boxes[force_index]
	for i=1, #entities do
		local unit_number = entities[i].unit_number
		rendering_destroy(all_boxes[unit_number][2])
		all_boxes[unit_number] = nil
	end
	universal_transfer_boxes[force_index] = {}
end

--TODO: improve for inactive boxes
---@param force_index number
local function reset_pull_boxes(force_index)
	for _, entities_data in pairs(pull_boxes[force_index]) do
		for i=1, #entities_data do
			local unit_number = entities_data[i].unit_number
			rendering_destroy(all_boxes[unit_number][2])
			all_boxes[unit_number] = nil
		end
	end
	pull_boxes[force_index] = {}
end

local function clear_invalid_prices(prices)
	local item_prototypes = game.item_prototypes
	local forces = game.forces
	for index, forces_data in pairs(prices) do
		if forces[index] == nil then
			sell_prices[index] = nil
			buy_prices[index] = nil
			inactive_sell_prices[index] = nil
			inactive_buy_prices[index] = nil
		else
			for item_name in pairs(forces_data) do
				if item_prototypes[item_name] == nil then
					forces_data[item_name] = nil
				end
			end
		end
	end
end

local function clear_invalid_storage_data()
	local item_prototypes = game.item_prototypes
	local forces = game.forces
	for index, data in pairs(pull_boxes) do
		if forces[index] == nil then
			clear_force_data(index)
		else
			for item_name, count in pairs(data) do
				if item_prototypes[item_name] == nil or count == 0 then
					data[item_name] = nil
				end
			end
		end
	end
end

local function clear_invalid_pull_boxes_data()
	local item_prototypes = game.item_prototypes
	local forces = game.forces
	for index, data in pairs(pull_boxes) do
		if forces[index] == nil then
			clear_force_data(index)
		else
			for item_name, entities in pairs(data) do
				if item_prototypes[item_name] == nil then
					data[item_name] = nil
				else
					for i=#entities, 1, -1 do
						if entities[i].valid == false then
							tremove(entities, i)
						end
					end
					if #entities == 0 then
						data[item_name] = nil
					end
				end
			end
		end
	end
end

---@param _data transfer_boxes|inactive_transfer_boxes
local function clear_invalid_transfer_boxes_data(_data)
	local item_prototypes = game.item_prototypes
	local forces = game.forces
	for index, data in pairs(_data) do
		if forces[index] == nil then
			clear_force_data(index)
		else
			for item_name, entities in pairs(data) do
				if item_prototypes[item_name] == nil then
					data[item_name] = nil
				else
					for i=#entities, 1, -1 do
						if entities[i].valid == false then
							tremove(entities, i)
						end
					end
					if #entities == 0 then
						data[item_name] = nil
					end
				end
			end
		end
	end
end

---@param _data buy_boxes|inactive_buy_boxes
local function clear_invalid_buy_boxes_data(_data)
	local item_prototypes = game.item_prototypes
	local forces = game.forces
	for index, data in pairs(_data) do
		if forces[index] == nil then
			clear_force_data(index)
		else
			for item_name, entities in pairs(data) do
				if item_prototypes[item_name] == nil then
					data[item_name] = nil
				else
					for i=#entities, 1, -1 do
						if entities[i][1].valid == false then
							tremove(entities, i)
						elseif not entities[i][2] then
							tremove(entities, i)
						end
					end
					if #entities == 0 then
						data[item_name] = nil
					end
				end
			end
		end
	end
end

---@param data universal_bin_boxes|inactive_universal_bin_boxes|universal_transfer_boxes|inactive_universal_transfer_boxes
local function clear_invalid_simple_boxes(data)
	for _, force_data in pairs(data) do
		for i=#force_data, 1, -1 do
			if not force_data[i].valid then
				tremove(force_data, i)
			end
		end
	end
end

local function clear_invalid_entities()
	clear_invalid_storage_data()
	clear_invalid_pull_boxes_data()
	clear_invalid_transfer_boxes_data(transfer_boxes)
	clear_invalid_transfer_boxes_data(inactive_transfer_boxes)
	clear_invalid_transfer_boxes_data(bin_boxes)
	clear_invalid_transfer_boxes_data(inactive_bin_boxes)
	clear_invalid_buy_boxes_data(buy_boxes)
	clear_invalid_buy_boxes_data(inactive_buy_boxes)
	clear_invalid_simple_boxes(universal_transfer_boxes)
	clear_invalid_simple_boxes(inactive_universal_transfer_boxes)
	clear_invalid_simple_boxes(universal_bin_boxes)
	clear_invalid_simple_boxes(inactive_universal_bin_boxes)

	local item_prototypes = game.item_prototypes
	for unit_number, data in pairs(all_boxes) do
		if not data[1].valid then
			all_boxes[unit_number] = nil
		else
			local item_name = data[5]
			if item_name and item_prototypes[item_name] == nil then
				rendering_destroy(data[2])
				all_boxes[unit_number] = nil
			end
		end
	end
end

---@return number
local function get_distance(start, stop)
	local xdiff = start.x - stop.x
	local ydiff = start.y - stop.y
	return (xdiff * xdiff + ydiff * ydiff)^0.5
end

local function delete_player_data(event)
	local player_index = event.player_index
	open_box[player_index] = nil
	item_HUD[player_index] = nil
end

local function make_prices_header(table)
	local dummy
	dummy = table.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60
	dummy = table.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60
	dummy = table.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60

	table.add(LABEL).caption = {"team-name"}
	table.add(LABEL).caption = {"free-market.buy-header"}
	table.add(LABEL).caption = {"free-market.sell-header"}
end

local function make_storage_header(table)
	local dummy
	dummy = table.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60
	dummy = table.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60

	table.add(LABEL).caption = {"item"}
	table.add(LABEL).caption = {"gui-logistic.count"}
end

---@param table_element GuiElement #GuiElement
local function make_price_list_header(table_element)
	local dummy
	dummy = table_element.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 30
	dummy = table_element.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60
	dummy = table_element.add(EMPTY_WIDGET)
	dummy.style.horizontally_stretchable = true
	dummy.style.minimal_width = 60

	table_element.add(LABEL).caption = {"item"}
	table_element.add(LABEL).caption = {"free-market.buy-header"}
	table_element.add(LABEL).caption = {"free-market.sell-header"}
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
---@param table_element GuiElement #GuiElement
local function update_prices_table(player, item_name, table_element)
	table_element.clear()
	make_prices_header(table_element)
	local force = player.force
	local result = {}
	for name, _force in pairs(game.forces) do
		if force ~= _force then
			result[_force.index] = {name = name}
		end
	end
	for index, force_items in pairs(buy_prices) do
		local data = result[index]
		if data then
			local buy_value = force_items[item_name]
			if buy_value then
				data.buy_price = tostring(buy_value)
			end
		end
	end
	for index, force_items in pairs(sell_prices) do
		local data = result[index]
		if data then
			local sell_price = force_items[item_name]
			if sell_price then
				data.sell_price = tostring(sell_price)
			end
		end
	end

	local add = table_element.add
	for _, data in pairs(result) do
		if data.buy_price or data.sell_price then
			add(LABEL).caption = data.name
			add(LABEL).caption = (data.buy_price or '')
			add(LABEL).caption = (data.sell_price or '')
		end
	end
end

---@param force LuaForce
---@param scroll_pane GuiElement #GuiElement
local function update_price_list_table(force, scroll_pane)
	local short_price_list_table = scroll_pane.short_price_list_table
	short_price_list_table.clear()
	short_price_list_table.visible = false
	local price_list_table = scroll_pane.price_list_table
	price_list_table.clear()
	price_list_table.visible = true
	make_price_list_header(price_list_table)

	local force_index = force.index
	local f_buy_prices = buy_prices[force_index] or EMPTY_TABLE
	local f_sell_prices = sell_prices[force_index] or EMPTY_TABLE

	local add = price_list_table.add
	for item_name, buy_price in pairs(f_buy_prices) do
		add(SPRITE_BUTTON).sprite = "item/" .. item_name
		add(LABEL).caption = buy_price
		add(LABEL).caption = (f_sell_prices[item_name] or '')
	end

	for item_name, sell_price in pairs(f_sell_prices) do
		if f_buy_prices[item_name] == nil then
			add(SPRITE_BUTTON).sprite = "item/" .. item_name
			add(EMPTY_WIDGET)
			add(LABEL).caption = sell_price
		end
	end
end

---@param force LuaForce
---@param scroll_pane GuiElement #GuiElement
---@param text_filter string
local function update_price_list_by_sell_filter(force, scroll_pane, text_filter)
	local short_price_list_table = scroll_pane.short_price_list_table
	short_price_list_table.clear()
	short_price_list_table.visible = true
	local price_list_table = scroll_pane.price_list_table
	price_list_table.clear()
	price_list_table.visible = false

	make_price_list_header(short_price_list_table)
	short_price_list_table.children[5].destroy()
	short_price_list_table.children[2].destroy()

	local f_sell_prices = sell_prices[force.index]
	if f_sell_prices == nil then return end

	local add = short_price_list_table.add
	for item_name, buy_price in pairs(f_sell_prices) do
		if find(item_name:lower(), text_filter) then
			add(SPRITE_BUTTON).sprite = "item/" .. item_name
			add(LABEL).caption = buy_price
		end
	end
end

---@param force LuaForce
---@param scroll_pane GuiElement #GuiElement
---@param text_filter string
local function update_price_list_by_buy_filter(force, scroll_pane, text_filter)
	local short_price_list_table = scroll_pane.short_price_list_table
	short_price_list_table.clear()
	short_price_list_table.visible = true
	local price_list_table = scroll_pane.price_list_table
	price_list_table.clear()
	price_list_table.visible = false

	make_price_list_header(short_price_list_table)
	short_price_list_table.children[6].destroy()
	short_price_list_table.children[3].destroy()

	local f_buy_prices = buy_prices[force.index]
	if f_buy_prices == nil then return end

	local add = short_price_list_table.add
	for item_name, buy_price in pairs(f_buy_prices) do
		if find(item_name:lower(), text_filter) then
			add(SPRITE_BUTTON).sprite = "item/" .. item_name
			add(LABEL).caption = buy_price
		end
	end
end

---@param player LuaPlayer #LuaPlayer
local function destroy_prices_gui(player)
	local screen = player.gui.screen
	if screen.FM_prices_frame then
		screen.FM_prices_frame.destroy()
	end
end

---@param player LuaPlayer #LuaPlayer
local function destroy_price_list_gui(player)
	local screen = player.gui.screen
	if screen.FM_price_list_frame then
		screen.FM_price_list_frame.destroy()
	end
end

---@param embargo_table LuaElement #LuaElement
---@param player LuaPlayer #LuaPlayer
local function update_embargo_table(embargo_table, player)
	embargo_table.clear()

	embargo_table.add(LABEL).caption = {"free-market.without-embargo-title"}
	embargo_table.add(EMPTY_WIDGET)
	embargo_table.add(LABEL).caption = {"free-market.with-embargo-title"}

	local force_index = player.index
	local embargoes_items = {}
	local forces_items = {}
	local f_embargoes = embargoes[player.index]
	for force_name, force in pairs(game.forces) do
		if #force.players > 0 and force.index ~= force_index then
			if f_embargoes[force.index] then
				embargoes_items[#embargoes_items+1] = force_name
			else
				forces_items[#forces_items+1] = force_name
			end
		end
	end

	local forces_list = embargo_table.add{type = "list-box", name = "forces_list", items = forces_items}
	forces_list.style.horizontally_stretchable = true
	forces_list.style.height = 200
	local buttons_flow = embargo_table.add(VERTICAL_FLOW)
	buttons_flow.add{type = "sprite-button", name = "FM_cancel_embargo", style = "tool_button", sprite = "utility/left_arrow"}
	buttons_flow.add{type = "sprite-button", name = "FM_declare_embargo", style = "tool_button", sprite = "utility/right_arrow"}
	local embargo_list = embargo_table.add{type = "list-box", name = "embargo_list", items = embargoes_items}
	embargo_list.style.horizontally_stretchable = true
	embargo_list.style.height = 200
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
---@param force_index number
local function add_item_in_sell_prices(player, item_name, price, force_index)
	local prices_table = player.gui.screen.FM_sell_prices_frame.FM_prices_flow.FM_prices_table
	local add = prices_table.add
	local button = add(FLOW).add(SELL_PRICE_BUTTON)
	button.sprite = "item/" .. item_name
	button.add(EMPTY_WIDGET).name = tostring(force_index)
	add = add(PRICE_FRAME).add
	-- It's possible to make it better, but it'll require to make a style with an image
	add(PRICE_LABEL).caption = price
	add(POST_PRICE_LABEL)

	local children = prices_table.children
	if #children / 2 > player.mod_settings["FM_sell_notification_size"].value then
		children[2].destroy()
		children[1].destroy()
	end
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
---@param force_index number
local function add_item_in_buy_prices(player, item_name, price, force_index)
	local prices_table = player.gui.screen.FM_buy_prices_frame.FM_prices_flow.FM_prices_table
	local add = prices_table.add
	local button = add(FLOW).add(BUY_PRICE_BUTTON)
	button.sprite = "item/" .. item_name
	button.add(EMPTY_WIDGET).name = tostring(force_index)
	add = add(PRICE_FRAME).add
	-- It's possible to make it better, but it'll require to make a style with an image
	add(PRICE_LABEL).caption = price
	add(POST_PRICE_LABEL)

	local children = prices_table.children
	if #children / 2 > player.mod_settings["FM_buy_notification_size"].value then
		children[2].destroy()
		children[1].destroy()
	end
end

---@param source_index number # force index who changed the price
---@param item_name string
---@param sell_price count
local function notify_sell_price(source_index, item_name, sell_price)
	local forces = game.forces
	local f_embargoes = embargoes[source_index]
	for _, force_index in pairs(active_forces) do
		if force_index ~= source_index and not f_embargoes[f_embargoes] then
			for _, player in pairs(forces[force_index].connected_players) do
				pcall(add_item_in_sell_prices, player, item_name, sell_price, source_index)
			end
		end
	end
end

---@param source_index number # force index who changed the price
---@param item_name string
---@param sell_price count
local function notify_buy_price(source_index, item_name, sell_price)
	local forces = game.forces
	for _, force_index in pairs(active_forces) do
		if force_index ~= source_index and not embargoes[force_index][source_index] then
			for _, player in pairs(forces[force_index].connected_players) do
				pcall(add_item_in_buy_prices, player, item_name, sell_price, source_index)
			end
		end
	end
end

---@param item_name string
---@param player LuaPlayer
---@param sell_price? number
---@return number|string? # returns previous sell price in a case of conflict
local function change_sell_price_by_player(item_name, player, sell_price)
	local force_index = player.force.index
	local f_sell_prices = sell_prices[force_index]
	local f_inactive_sell_prices = inactive_sell_prices[force_index]
	if sell_price == nil then
		f_inactive_sell_prices[item_name] = nil
		f_sell_prices[item_name] = nil
		return
	end

	local active_sell_price = f_sell_prices[item_name]
	local inactive_sell_price = f_inactive_sell_prices[item_name]
	local prev_sell_price = f_sell_prices[item_name] or inactive_sell_price
	if prev_sell_price == sell_price then
		if inactive_sell_price then
			local count_in_storage = storages[force_index][item_name]
			if count_in_storage and count_in_storage > 0 then
				f_sell_prices[item_name] = sell_price
				f_inactive_sell_prices[item_name] = nil
				notify_sell_price(force_index, item_name, sell_price)
			end
		end
		return
	end

	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
	if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then
		player.print({"gui-map-generator.invalid-value-for-field", sell_price, buy_price or minimal_price, maximal_price})
		return active_sell_price or inactive_sell_price or ''
	end

	if active_sell_price then
		f_sell_prices[item_name] = sell_price
		notify_sell_price(force_index, item_name, sell_price)
	elseif inactive_sell_price then
		local count_in_storage = storages[force_index][item_name]
		if count_in_storage == nil or count_in_storage <= 0 then
			f_inactive_sell_prices[item_name] = sell_price
		else
			f_sell_prices[item_name] = sell_price
			f_inactive_sell_prices[item_name] = nil
			notify_sell_price(force_index, item_name, sell_price)
		end
	elseif transfer_boxes[force_index][item_name] then
		f_sell_prices[item_name] = sell_price
		notify_sell_price(force_index, item_name, sell_price)
	else
		local count_in_storage = storages[force_index][item_name]
		if count_in_storage == nil or count_in_storage <= 0 then
			f_inactive_sell_prices[item_name] = sell_price
		else
			f_sell_prices[item_name] = sell_price
			notify_sell_price(force_index, item_name, sell_price)
		end
	end
end

---@param item_name string
---@param player LuaPlayer
---@param buy_price? number
---@return number|string? # returns previous sell price in a case of conflict
local function change_buy_price_by_player(item_name, player, buy_price)
	local force_index = player.force.index
	local f_buy_prices = buy_prices[force_index]
	local f_inactive_buy_prices = inactive_buy_prices[force_index]
	if buy_price == nil then
		f_inactive_buy_prices[item_name] = nil
		f_buy_prices[item_name] = nil
		return
	end

	local prev_buy_price = f_buy_prices[item_name] or f_inactive_buy_prices[item_name]
	if prev_buy_price == buy_price then
		return
	end

	local sell_price = sell_prices[force_index][item_name]
	if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then
		player.print({"gui-map-generator.invalid-value-for-field", buy_price, minimal_price, sell_price or maximal_price})
		return f_buy_prices[item_name] or f_inactive_buy_prices[item_name] or ''
	end

	if f_buy_prices[item_name] then
		f_buy_prices[item_name] = buy_price
		notify_buy_price(force_index, item_name, buy_price)
	elseif f_inactive_buy_prices[item_name] then
		f_inactive_buy_prices[item_name] = buy_price
	elseif buy_boxes[force_index][item_name] then
		f_buy_prices[item_name] = buy_price
		notify_buy_price(force_index, item_name, buy_price)
	else
		f_inactive_buy_prices[item_name] = buy_price
	end
end

---@param gui LuaElement #LuaElement
---@param button_name string # name of button
---@param is_top_handler boolean
local function create_price_notification_handler(gui, button_name, is_top_handler)
	local flow = gui.add(TITLEBAR_FLOW)
	flow.style.padding = 0
	if is_top_handler then
		local button = flow.add{
			type = "sprite-button",
			sprite = "FM_price",
			style = "frame_action_button",
			name = button_name
		}
		button.style.margin = 0
	end
	local drag_handler = flow.add(DRAG_HANDLER)
	drag_handler.drag_target = gui
	drag_handler.style.margin = 0
	if is_top_handler then
		flow.style.horizontal_spacing = 0
		drag_handler.style.width = 27
		drag_handler.style.height = 25
		drag_handler.style.horizontally_stretchable = false
	else
		drag_handler.style.width = 24
		drag_handler.style.height = 46
		drag_handler.add{
			type = "sprite-button",
			sprite = "FM_price",
			style = "frame_action_button",
			name = button_name
		}
	end
end

---@param player LuaPlayer #LuaPlayer
---@param location? GuiLocation
local function switch_sell_prices_gui(player, location)
	local screen = player.gui.screen
	local main_frame = screen.FM_sell_prices_frame
	if main_frame then
		local children = main_frame.children
		if #children > 1 then
			children[2].destroy()
			return
		else
			local prices_flow = main_frame.add{type = "frame", name = "FM_prices_flow", style = "FM_prices_frame", direction = "vertical"}
			local column_count = 2 * player.mod_settings["FM_sell_notification_column_count"].value
			prices_flow.add{type = "table", name = "FM_prices_table", style = "FM_prices_table", column_count = column_count}
		end
else
		local column_count = 2 * player.mod_settings["FM_sell_notification_column_count"].value
		local is_vertical = (column_count == 2)
		if is_vertical then
			direction = "vertical" -- it works weird
		else
			direction = "horizontal"
		end
		main_frame = screen.add{type = "frame", name = "FM_sell_prices_frame", style = "borderless_frame", direction = direction}
		main_frame.location = location or {x = player.display_resolution.width - 752, y = 272}
		create_price_notification_handler(main_frame, "FM_switch_sell_prices_gui", is_vertical)
		local prices_flow = main_frame.add{type = "frame", name = "FM_prices_flow", style = "FM_prices_frame", direction = "vertical"}
		prices_flow.add{type = "table", name = "FM_prices_table", style = "FM_prices_table", column_count = column_count}
	end
end

---@param player LuaPlayer #LuaPlayer
---@param location? GuiLocation
local function switch_buy_prices_gui(player, location)
	local screen = player.gui.screen
	local main_frame = screen.FM_buy_prices_frame
	if main_frame then
		local children = main_frame.children
		if #children > 1 then
			children[2].destroy()
			return
		else
			local prices_flow = main_frame.add{type = "frame", name = "FM_prices_flow", style = "FM_prices_frame", direction = "vertical"}
			local column_count = 2 * player.mod_settings["FM_buy_notification_column_count"].value
			prices_flow.add{type = "table", name = "FM_prices_table", style = "FM_prices_table", column_count = column_count}
		end
	else
		local column_count = 2 * player.mod_settings["FM_buy_notification_column_count"].value
		local is_vertical = (column_count == 2)
		if is_vertical then
			direction = "vertical" -- it works weird
		else
			direction = "horizontal"
		end
		main_frame = screen.add{type = "frame", name = "FM_buy_prices_frame", style = "borderless_frame", direction = direction}
		main_frame.location = location or {x = player.display_resolution.width - 712, y = 272}
		create_price_notification_handler(main_frame, "FM_switch_buy_prices_gui", is_vertical)
		local prices_flow = main_frame.add{type = "frame", name = "FM_prices_flow", style = "FM_prices_frame", direction = "vertical"}
		prices_flow.add{type = "table", name = "FM_prices_table", style = "FM_prices_table", column_count = column_count}
	end
end

---@param player LuaPlayer #LuaPlayer
local function open_embargo_gui(player)
	local screen = player.gui.screen
	if screen.FM_embargo_frame then
		screen.FM_embargo_frame.destroy()
		return
	end
	local main_frame = screen.add{type = "frame", name = "FM_embargo_frame", direction = "vertical"}
	main_frame.style.minimal_width = 340
	main_frame.style.horizontally_stretchable = true
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"free-market.embargo-gui"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)

	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame"}
	local embargo_table = shallow_frame.add{type = "table", name = "embargo_table", column_count = 3}
	embargo_table.style.horizontally_stretchable = true
	embargo_table.style.vertically_stretchable = true
	embargo_table.style.column_alignments[1] = "center"
	embargo_table.style.column_alignments[2] = "center"
	embargo_table.style.column_alignments[3] = "center"

	update_embargo_table(embargo_table, player)
	main_frame.force_auto_center()
end

---@param item_name string
---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
local function set_transfer_box_data(item_name, player, entity)
	local player_force = player.force
	local force_index = player_force.index
	local f_transfer_boxes = transfer_boxes[force_index]
	if f_transfer_boxes[item_name] == nil then
		local f_inactive_sell_prices = inactive_sell_prices[force_index]
		local inactive_sell_price = f_inactive_sell_prices[item_name]
		if inactive_sell_price then
			sell_prices[force_index][item_name] = inactive_sell_price
			f_inactive_sell_prices[item_name] = nil
			notify_sell_price(force_index, item_name, inactive_sell_price)
		end
		f_transfer_boxes[item_name] = {}
	end
	local entities = f_transfer_boxes[item_name]
	entities[#entities+1] = entity
	local sprite_data = {
		sprite = "FM_transfer",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)
	show_item_sprite_above_chest(item_name, player_force, entity)

	entity.get_inventory(chest_inventory_type).set_bar(2)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, TRANSFER_TYPE, entities, item_name}
end

---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
local function set_universal_transfer_box_data(player, entity)
	local player_force = player.force
	local force_index = player_force.index
	local entities = universal_transfer_boxes[force_index]
	entities[#entities+1] = entity
	local sprite_data = {
		sprite = "FM_universal_transfer",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, UNIVERSAL_TRANSFER_TYPE, entities, nil}
end

---@param item_name string
---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
local function set_bin_box_data(item_name, player, entity)
	local player_force = player.force
	local force_index = player_force.index
	local f_bin_boxes = bin_boxes[force_index]
	if f_bin_boxes[item_name] == nil then
		f_bin_boxes[item_name] = {}
	end
	local entities = f_bin_boxes[item_name]
	entities[#entities+1] = entity
	local sprite_data = {
		sprite = "FM_bin",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)
	show_item_sprite_above_chest(item_name, player_force, entity)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, BIN_TYPE, entities, item_name}
end

---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
local function set_universal_bin_box_data(player, entity)
	local player_force = player.force
	local force_index = player_force.index
	local entities = universal_bin_boxes[force_index]
	entities[#entities+1] = entity
	local sprite_data = {
		sprite = "FM_universal_bin",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, UNIVERSAL_BIN_TYPE, entities, nil}
end

---@param item_name string
---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
local function set_pull_box_data(item_name, player, entity)
	local player_force = player.force
	local force_index = player_force.index
	local force_pull_boxes = pull_boxes[force_index]
	force_pull_boxes[item_name] = force_pull_boxes[item_name] or {}
	local items = force_pull_boxes[item_name]
	items[#items+1] = entity
	local sprite_data = {
		sprite = "FM_pull_out",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)
	show_item_sprite_above_chest(item_name, player_force, entity)

	entity.get_inventory(chest_inventory_type).set_bar(2)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, PULL_TYPE, items, item_name}
end

---@param item_name string
---@param player LuaPlayer #LuaPlayer
---@param entity LuaEntity #LuaEntity
---@param count? number
local function set_buy_box_data(item_name, player, entity, count)
	count = count or game.item_prototypes[item_name].stack_size

	local player_force = player.force
	local force_index = player_force.index
	local f_buy_boxes = buy_boxes[force_index]
	if f_buy_boxes[item_name] == nil then
		local f_inactive_buy_prices = inactive_buy_prices[force_index]
		local inactive_buy_price = f_inactive_buy_prices[item_name]
		if inactive_buy_price then
			buy_prices[force_index][item_name] = inactive_buy_price
			f_inactive_buy_prices[item_name] = nil
			notify_buy_price(force_index, item_name, inactive_buy_price)
		end
		f_buy_boxes[item_name] = {}
	end
	local items = f_buy_boxes[item_name]
	items[#items+1] = {entity, count}
	local sprite_data = {
		sprite = "FM_buy",
		target = entity,
		surface = entity.surface,
		target_offset = BOX_TYPE_SPRITE_OFFSET,
		only_in_alt_mode = true,
		x_scale = 0.4, y_scale = 0.4
	}
	if is_public_titles == false then
		sprite_data.forces = {player_force}
	end
	---@type number
	local id = draw_sprite(sprite_data)
	show_item_sprite_above_chest(item_name, player_force, entity)

	-- (it's kind of messy data. Perhaps, there's another way)
	all_boxes[entity.unit_number] = {entity, id, BUY_TYPE, items, item_name}
end

---@param player LuaPlayer #LuaPlayer
local function destroy_force_configuration(player)
	local frame = player.gui.screen.FM_force_configuration
	if frame then
		frame.destroy()
	end
end

---@param player LuaPlayer #LuaPlayer
local function open_force_configuration(player)
	local screen = player.gui.screen
	if screen.FM_force_configuration then
		screen.FM_force_configuration.destroy()
		return
	end

	local is_player_admin = player.admin
	local force_index = player.force.index

	local main_frame = screen.add{type = "frame", name = "FM_force_configuration", direction = "vertical"}
	main_frame.style.horizontally_stretchable = true
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"free-market.team-configuration"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content.style.padding = 12

	if is_player_admin then
		local admin_row = content.add(FLOW)
		admin_row.name = "admin_row"
		admin_row.add(LABEL).caption = {'', {"gui-multiplayer-lobby.allow-commands-admins-only"}, COLON}
		admin_row.add{type = "button", caption = {"free-market.print-force-data-button"}, name = "FM_print_force_data"}
	end

	if is_reset_public or is_player_admin then
		if is_player_admin then
			content.add(LABEL).caption = {'', "Attention", COLON, "reset is public"}
		end
		local reset_caption = {'', {"free-market.reset-gui"}, COLON}
		local reset_prices_row = content.add(FLOW)
		reset_prices_row.name = "reset_prices_row"
		reset_prices_row.add(LABEL).caption = reset_caption
		reset_prices_row.add{type = "button", caption = {"free-market.reset-buy-prices"} , name = "FM_reset_buy_prices"}.style.minimal_width = 10
		reset_prices_row.add{type = "button", caption = {"free-market.reset-sell-prices"}, name = "FM_reset_sell_prices"}.style.minimal_width = 10
		reset_prices_row.add{type = "button", caption = {"free-market.reset-all-prices"} , name = "FM_reset_all_prices"}.style.minimal_width = 10

		local reset_boxes_row = content.add(FLOW)
		reset_boxes_row.name = "reset_boxes_row"
		reset_boxes_row.add(LABEL).caption = reset_caption
		reset_boxes_row.add{type = "button", caption = {"free-market.reset-buy-requests"},  name = "FM_reset_buy_boxes"}.style.minimal_width = 10
		reset_boxes_row.add{type = "button", caption = {"free-market.reset-transferers"},   name = "FM_reset_transfer_boxes"}.style.minimal_width = 10
		reset_boxes_row.add{type = "button", caption = {"free-market.reset-pull-requests"}, name = "FM_reset_pull_boxes"}.style.minimal_width = 10
		reset_boxes_row.add{type = "button", caption = {"free-market.reset-all-types"},     name = "FM_reset_all_boxes"}.style.minimal_width = 10
	end

	local setting_row = content.add(FLOW)
	setting_row.style.vertical_align = "center"
	setting_row.add(LABEL).caption = {'', {"free-market.default-storage-limit"}, COLON}
	local default_limit_textfield = setting_row.add(DEFAULT_LIMIT_TEXTFIELD)
	local default_limit = default_storage_limit[force_index] or max_storage_threshold
	default_limit_textfield.text = tostring(default_limit)
	setting_row.add(CHECK_BUTTON).name = "FM_confirm_default_limit"

	local label = content.add(LABEL)
	label.caption = {'', {"gui.credits"}, COLON}
	label.style.font = "heading-1"
	local translations_row = content.add(FLOW)
	translations_row.add(LABEL).caption = {'', "Translations", COLON}
	local link = translations_row.add({type = "textfield", text = "https://crowdin.com/project/factorio-mods-localization"})
	link.style.horizontally_stretchable = true
	link.style.width = 320
	content.add(LABEL).caption = {'', "Translators", COLON, ' ', "eifel (Eifel87), zszzlzm (刘泽民), Spielen01231 (TheFakescribtx2), Drilzxx_ (Kévin), eifel (Eifel87), Felix_Manning (Felix Manning), ZwerOxotnik"}
	content.add(LABEL).caption = {'', "Supporters", COLON, ' ', "Eerrikki"}
	content.add(LABEL).caption = {'', {"gui-other-settings.developer"}, COLON, ' ', "ZwerOxotnik"}
	local text_box = content.add({type = "text-box"})
	text_box.read_only = true
	text_box.text = "see-prices.png from https://www.svgrepo.com/svg/77065/price-tag\n" ..
	"change-price.png from https://www.svgrepo.com/svg/96982/price-tag\n" ..
	"embargo.png is modified version of https://www.svgrepo.com/svg/97012/price-tag" ..
	"Modified versions of https://www.svgrepo.com/svg/11042/shopping-cart-with-down-arrow-e-commerce-symbol" ..
	"Modified versions of https://www.svgrepo.com/svg/89258/rubbish-bin"
	text_box.style.maximal_width = 0
	text_box.style.height = 70
	text_box.style.horizontally_stretchable = true -- it works weird
	text_box.style.vertically_stretchable = true -- it works weird

	main_frame.force_auto_center()
end

---@param player LuaPlayer #LuaPlayer
---@param item_name? string
local function switch_prices_gui(player, item_name)
	local screen = player.gui.screen
	local main_frame = screen.FM_prices_frame
	if main_frame then
		if item_name == nil then
			main_frame.destroy()
		else
			local content_flow = main_frame.shallow_frame.content_flow
			local item_row = main_frame.shallow_frame.content_flow.item_row
			item_row.FM_prices_item.elem_value = item_name

			local force_index = player.force.index
			local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name]
			if sell_price then
				item_row.sell_price.text = tostring(sell_price)
			end
			local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
			if buy_price then
				item_row.buy_price.text = tostring(buy_price)
			end
			update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
		end
		return
	end

	local force_index = player.force.index

	main_frame = screen.add{type = "frame", name = "FM_prices_frame", direction = "vertical"}
	main_frame.location = {x = 100 / player.display_scale, y = 50}
	main_frame.style.horizontally_stretchable = true
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"free-market.prices"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add{
		type = "sprite-button",
		style = "frame_action_button",
		sprite = "refresh_white_icon",
		name = "FM_refresh_prices_table"
	}
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content.style.padding = 12

	local item_row = content.add(FLOW)
	local add = item_row.add
	item_row.name = "item_row"
	item_row.style.vertical_align = "center"
	local item = add{type = "choose-elem-button", name = "FM_prices_item", elem_type = "item", elem_filters = ITEM_FILTERS}
	item.elem_value = item_name
	add(LABEL).caption = {"free-market.buy-gui"}
	local buy_textfield = add(BUY_PRICE_TEXTFIELD)
	if item_name then
		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
		if price then
			buy_textfield.text = tostring(price)
		end
	end
	add(CHECK_BUTTON).name = "FM_confirm_buy_price"
	add(LABEL).caption = {"free-market.sell-gui"}
	local sell_textfield = add(SELL_PRICE_TEXTFIELD)
	if item_name then
		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name]
		if price then
			sell_textfield.text = tostring(price)
		end
	end
	add(CHECK_BUTTON).name = "FM_confirm_sell_price"

	local storage_row = content.add(FLOW)
	local add = storage_row.add
	storage_row.name = "storage_row"
	storage_row.style.vertical_align = "center"
	add(LABEL).caption = {'', {"description.storage"}, COLON}
	local storage_count = add(LABEL)
	storage_count.name = "storage_count"
	add(LABEL).caption = '/'
	local storage_limit_textfield = add(STORAGE_LIMIT_TEXTFIELD)
	add(CHECK_BUTTON).name = "FM_confirm_storage_limit"
	if item_name == nil then
		storage_row.visible = false
	else
		local count = storages[force_index][item_name] or 0
		storage_count.caption = tostring(count)
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold
		storage_limit_textfield.text = tostring(limit)
	end

	local prices_frame = content.add{type = "frame", name = "other_prices_frame", style = "deep_frame_in_shallow_frame", direction = "vertical"}
	local scroll_pane = prices_frame.add(SCROLL_PANE)
	scroll_pane.style.padding = 12
	local prices_table = scroll_pane.add{type = "table", name = "prices_table", column_count = 3}
	prices_table.style.horizontal_spacing = 16
	prices_table.style.vertical_spacing = 8
	prices_table.style.top_margin = -16
	prices_table.style.column_alignments[1] = "center"
	prices_table.style.column_alignments[2] = "center"
	prices_table.style.column_alignments[3] = "center"
	prices_table.draw_horizontal_lines = true
	prices_table.draw_vertical_lines = true
	if item_name then
		update_prices_table(player, item_name, prices_table)
	else
		make_prices_header(prices_table)
	end

	return content
end

local function open_storage_gui(player)
	local screen = player.gui.screen
	local main_frame = screen.FM_storage_frame
	if main_frame then
		main_frame.destroy()
		return
	end

	main_frame = screen.add{type = "frame", name = "FM_storage_frame", direction = "vertical"}
	main_frame.style.horizontally_stretchable = true
	main_frame.style.maximal_height = 700
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"description.storage"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content_flow = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content_flow.style.padding = 12

	local scroll_pane = content_flow.add(SCROLL_PANE)
	scroll_pane.style.padding = 12
	local storage_table = scroll_pane.add{type = "table", name = "FM_storage_table", column_count = 2}
	storage_table.style.horizontal_spacing = 16
	storage_table.style.vertical_spacing = 8
	storage_table.style.top_margin = -16
	storage_table.style.column_alignments[1] = "center"
	storage_table.style.column_alignments[2] = "center"
	storage_table.draw_horizontal_lines = true
	storage_table.draw_vertical_lines = true
	make_storage_header(storage_table)

	local add = storage_table.add
	for item_name, count in pairs(storages[player.force.index]) do
		add(SPRITE_BUTTON).sprite = "item/" .. item_name
		add(LABEL).caption = tostring(count)
	end

	main_frame.force_auto_center()
end

local function open_price_list_gui(player)
	local screen = player.gui.screen
	if screen.FM_price_list_frame then
		screen.FM_price_list_frame.destroy()
		return
	end
	local main_frame = screen.add{type = "frame", name = "FM_price_list_frame", direction = "vertical"}
	main_frame.style.horizontally_stretchable = true
	main_frame.style.maximal_height = 700
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"free-market.price-list"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content_flow = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content_flow.style.padding = 12

	local team_row = content_flow.add(FLOW)
	team_row.name = "team_row"
	team_row.add(LABEL).caption = {'', {"team"}, COLON}
	local items = {}
	local size = 0
	for force_name, force in pairs(game.forces) do
		local force_index = force.index
		local f_sell_prices = sell_prices[force_index]
		local f_buy_prices = buy_prices[force_index]
		if (f_sell_prices and next(f_sell_prices)) or (f_buy_prices and next(f_buy_prices)) then
			size = size + 1
			items[size] = force_name
		end
	end
	team_row.add{type = "drop-down", name = "FM_force_price_list", items = items}

	local search_row = content_flow.add({type = "table", name = "search_row", column_count = 4})
	search_row.add{type = "textfield", name = "FM_search_text"}
	search_row.add(LABEL).caption = {'', {"gui.search"}, COLON}
	search_row.add{
		type = "drop-down",
		name = "FM_search_price_drop_down",
		items = {{"free-market.sell-offer-gui"}, {"free-market.buy-request-gui"}}
	}
	search_row.add{
		type = "sprite-button",
		style = "frame_action_button",
		name = "FM_search_by_price",
		hovered_sprite = "utility/search_black",
		clicked_sprite = "utility/search_black",
		sprite = "utility/search_white"
	}

	local prices_frame = content_flow.add{type = "frame", name = "deep_frame", style = "deep_frame_in_shallow_frame", direction = "vertical"}
	local scroll_pane = prices_frame.add(SCROLL_PANE)
	scroll_pane.style.padding = 12
	local prices_table = scroll_pane.add{type = "table", name = "price_list_table", column_count = 3}
	prices_table.style.horizontal_spacing = 16
	prices_table.style.vertical_spacing = 8
	prices_table.style.top_margin = -16
	prices_table.style.column_alignments[1] = "center"
	prices_table.style.column_alignments[2] = "center"
	prices_table.style.column_alignments[3] = "center"
	prices_table.style.column_alignments[4] = "center"
	prices_table.style.column_alignments[5] = "center"
	prices_table.style.column_alignments[6] = "center"
	prices_table.draw_horizontal_lines = true
	prices_table.draw_vertical_lines = true
	make_price_list_header(prices_table)

	local short_prices_table = scroll_pane.add{type = "table", name = "short_price_list_table", column_count = 2}
	short_prices_table.style.horizontal_spacing = 16
	short_prices_table.style.vertical_spacing = 8
	short_prices_table.style.top_margin = -16
	short_prices_table.style.column_alignments[1] = "center"
	short_prices_table.style.column_alignments[2] = "center"
	short_prices_table.style.column_alignments[3] = "center"
	short_prices_table.style.column_alignments[4] = "center"
	short_prices_table.draw_horizontal_lines = true
	short_prices_table.draw_vertical_lines = true
	short_prices_table.visible = false

	main_frame.force_auto_center()
end

---@param player LuaPlayer #LuaPlayer
---@param is_new boolean# Is new buy box?
---@param entity? LuaEntity #LuaEntity # The buy box when is_new = true
local function open_buy_box_gui(player, is_new, entity)
	local box_operations = player.gui.relative.FM_boxes_frame.content.main_flow.box_operations
	box_operations.clear()
	if box_operations.buy_content and not is_new then
		return
	end

	local row = box_operations.add{type = "table", name = "buy_content", column_count = 4}
	local FM_item = row.add(FM_ITEM_ELEMENT)
	row.add{type = "label", caption = {'', {"free-market.count-gui"}, COLON}}
	local count_element = row.add{type = "textfield", name = "count", numeric = true, allow_decimal = false, allow_negative = false}
	count_element.style.width = 70
	local confirm_button = row.add(CHECK_BUTTON)
	if is_new then
		confirm_button.name = "FM_confirm_buy_box"
	else
		confirm_button.name = "FM_change_buy_box"
		local box_data = all_boxes[entity.unit_number]
		local entities_data = box_data[4]
		for i = 1, #entities_data do
			local buy_box = entities_data[i]
			if buy_box[1] == entity then
				count_element.text = tostring(buy_box[2])
				break
			end
		end
		local item_name = box_data[5]
		FM_item.elem_value = item_name
	end
end

local function clear_boxes_gui(player)
	open_box[player.index] = nil
	player.gui.relative.FM_boxes_frame.content.main_flow.box_operations.clear()
end

---@param player LuaPlayer #LuaPlayer
---@param is_new boolean # Is new sell box?
---@param entity? LuaEntity #LuaEntity # The sell box when is_new = true
local function open_transfer_box_gui(player, is_new, entity)
	local box_operations = player.gui.relative.FM_boxes_frame.content.main_flow.box_operations
	box_operations.clear()
	if box_operations.transfer_content and not is_new then
		return
	end

	local row = box_operations.add{type = "table", name = "transfer_content", column_count = 2}
	local FM_item = row.add(FM_ITEM_ELEMENT)
	local confirm_button = row.add(CHECK_BUTTON)
	if is_new then
		confirm_button.name = "FM_confirm_transfer_box"
	else
		confirm_button.name = "FM_change_transfer_box"
		FM_item.elem_value = all_boxes[entity.unit_number][5]
	end
end

---@param player LuaPlayer #LuaPlayer
---@param is_new boolean # Is new sell box?
---@param entity? LuaEntity #LuaEntity # The sell box when is_new = true
local function open_bin_box_gui(player, is_new, entity)
	local box_operations = player.gui.relative.FM_boxes_frame.content.main_flow.box_operations
	box_operations.clear()
	if box_operations.bin_content and not is_new then
		return
	end

	local row = box_operations.add{type = "table", name = "bin_content", column_count = 2}
	local FM_item = row.add(FM_ITEM_ELEMENT)
	local confirm_button = row.add(CHECK_BUTTON)
	if is_new then
		confirm_button.name = "FM_confirm_bin_box"
	else
		confirm_button.name = "FM_change_bin_box"
		FM_item.elem_value = all_boxes[entity.unit_number][5]
	end
end

local function create_top_relative_gui(player)
	local relative = player.gui.relative
	local main_frame = relative.FM_boxes_frame
	if main_frame then
		main_frame.destroy()
	end

	local boxes_anchor = {gui = defines.relative_gui_type.container_gui, position = defines.relative_gui_position.top}
	main_frame = relative.add{type = "frame", name = "FM_boxes_frame", anchor = boxes_anchor}
	main_frame.style.vertical_align = "center"
	main_frame.style.horizontally_stretchable = false
	main_frame.style.bottom_margin = -14
	local frame = main_frame.add{type = "frame", name = "content", style = "inside_shallow_frame"}
	local main_flow = frame.add{type = "flow", name = "main_flow", direction = "vertical"}
	main_flow.style.vertical_spacing = 0
	main_flow.add(FLOW).name = "box_operations"
	local flow = main_flow.add(FLOW)
	flow.add{type = "button", style="FM_transfer_button", name = "FM_set_transfer_box"}.style.right_margin = -6
	flow.add{type = "button", style="FM_universal_transfer_button", name = "FM_set_universal_transfer_box"}.style.right_margin = -6
	flow.add{type = "button", style="FM_bin_button", name = "FM_set_bin_box"}.style.right_margin = -6
	flow.add{type = "button", style="FM_universal_bin_button", name = "FM_set_universal_bin_box"}.style.right_margin = -6
	flow.add{type = "button", style="FM_pull_out_button", name = "FM_set_pull_box"}.style.right_margin = -6
	flow.add{type = "button", style="FM_buy_button", name = "FM_set_buy_box"}
end

---@param player LuaPlayer #LuaPlayer
---@param is_new boolean # Is new pull box?
---@param entity? LuaEntity #LuaEntity # The sell box when is_new = true
local function open_pull_box_gui(player, is_new, entity)
	local box_operations = player.gui.relative.FM_boxes_frame.content.main_flow.box_operations
	box_operations.clear()
	if box_operations.pull_content then
		return
	end
	local row = box_operations.add{type = "table", name = "pull_content", column_count = 2}
	local FM_item = row.add(FM_ITEM_ELEMENT)
	local confirm_button = row.add(CHECK_BUTTON)
	if is_new then
		confirm_button.name = "FM_confirm_pull_box"
	else
		confirm_button.name = "FM_change_pull_box"
		FM_item.elem_value = all_boxes[entity.unit_number][5]
	end
end

local function create_left_relative_gui(player)
	local relative = player.gui.relative
	local main_table = relative.FM_buttons
	if main_table then
		main_table.destroy()
	end

	local left_anchor = {gui = defines.relative_gui_type.controller_gui, position = defines.relative_gui_position.left}
	main_table = relative.add{type = "table", name = "FM_buttons", anchor = left_anchor, column_count = 2}
	main_table.style.vertical_align = "center"
	main_table.style.horizontal_spacing = 0
	main_table.style.vertical_spacing = 0

	local button = main_table.add{type = "button", style = "side_menu_button", caption = ">", name = "FM_hide_left_buttons"}
	button.style.font = "default-dialog-button"
	button.style.font_color = WHITE_COLOR
	button.style.top_padding = -4
	button.style.width = 18
	button.style.height = 20

	local frame = main_table.add{type = "frame", name = "content"}
	frame.style.right_margin = -14
	local shallow_frame = frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame"}
	local buttons_table = shallow_frame.add{type = "table", column_count = 3}
	buttons_table.style.horizontal_spacing = 0
	buttons_table.style.vertical_spacing = 0
	buttons_table.add{type = "sprite-button", sprite = "FM_change-price", style="slot_button", name = "FM_open_price"}
	buttons_table.add{type = "sprite-button", sprite = "FM_see-prices", style="slot_button", name = "FM_open_price_list"}
	buttons_table.add{type = "sprite-button", sprite = "FM_embargo", style="slot_button", name = "FM_open_embargo"}
	buttons_table.add{type = "sprite-button", sprite = "item/wooden-chest", style = "slot_button", name = "FM_open_storage"} -- TODO: change the sprite
	buttons_table.add{type = "sprite-button", sprite = "virtual-signal/signal-info", style = "slot_button", name = "FM_show_hint"}
	buttons_table.add{
		type = "sprite-button",
		sprite = "utility/side_menu_menu_icon",
		hovered_sprite = "utility/side_menu_menu_hover_icon",
		clicked_sprite = "utility/side_menu_menu_hover_icon",
		style = "slot_button",
		name = "FM_open_force_configuration"
	}
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
local function check_buy_price(player, item_name)
	local force_index = player.force.index
	if buy_prices[force_index][item_name] == nil then
		local screen = player.gui.screen
		local prices_frame = screen.FM_prices_frame
		local content_flow
		if prices_frame == nil then
			content_flow = switch_prices_gui(player, item_name)
			prices_frame = screen.FM_prices_frame
		else
			content_flow = prices_frame.shallow_frame.content_flow
			content_flow.item_row.FM_prices_item.elem_value = item_name
			local sell_price = sell_prices[force_index][item_name]
			if sell_price then
				content_flow.item_row.sell_price.text = tostring(sell_price)
			end
			update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
		end
		content_flow.item_row.buy_price.focus()
	end
end

---@param player LuaPlayer #LuaPlayer
---@param gui GuiElement # box_operations gui
---@param item_name string
local function check_sell_price_for_opened_chest(player, gui, item_name)
	local force_index = player.force.index
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name]
	if sell_price then return end

	local row = gui.add{type = "table", name = "sell_price_table", column_count = 4}
	local add = row.add
	add(SLOT_BUTTON).sprite = "item/" .. item_name
	add(LABEL).caption = {'', {"free-market.sell-price-label"}, COLON}
	add(SELL_PRICE_TEXTFIELD).focus()
	add(CHECK_BUTTON).name = "FM_confirm_sell_price_for_chest"
end

---@param player LuaPlayer #LuaPlayer
---@param gui GuiElement # box_operations gui
---@param item_name string
local function check_buy_price_for_opened_chest(player, gui, item_name)
	local force_index = player.force.index
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
	if buy_price then return end

	local row = gui.add{type = "table", name = "buy_price_table", column_count = 4}
	local add = row.add
	add(SLOT_BUTTON).sprite = "item/" .. item_name
	add(LABEL).caption = {'', {"free-market.buy-price-label"}, COLON}
	add(BUY_PRICE_TEXTFIELD).focus()
	add(CHECK_BUTTON).name = "FM_confirm_buy_price_for_chest"
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
local function check_sell_price(player, item_name)
	local force_index = player.force.index
	if sell_prices[force_index][item_name] == nil then
		local prices_frame = player.gui.screen.FM_prices_frame
		local content_flow
		if prices_frame == nil then
			content_flow = switch_prices_gui(player, item_name)
			prices_frame = player.gui.screen.FM_prices_frame
		else
			content_flow = prices_frame.shallow_frame.content_flow
			content_flow.item_row.FM_prices_item.elem_value = item_name
			local buy_price = buy_prices[force_index][item_name]
			if buy_price then
				content_flow.item_row.buy_price.text = tostring(buy_price)
			end
			update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
		end
		content_flow.item_row.sell_price.focus()
	end
end

---@param player LuaPlayer #LuaPlayer
local function delete_item_price_HUD(player)
	local frame = player.gui.screen.FM_item_price_frame
	if frame then
		frame.destroy()
		item_HUD[player.index] = nil
	end
end

---@param player LuaPlayer #LuaPlayer
local function create_item_price_HUD(player)
	local screen = player.gui.screen
	local main_frame = screen.FM_item_price_frame
	if main_frame then
		return
	end

	main_frame = screen.add{type = "frame", name = "FM_item_price_frame", style = "FM_item_price_frame", direction = "horizontal"}
	main_frame.location = {x = player.display_resolution.width / 2, y = 10}

	local flow = main_frame.add(TITLEBAR_FLOW)
	local drag_handler = flow.add(DRAG_HANDLER)
	drag_handler.drag_target = main_frame
	drag_handler.style.vertically_stretchable = true
	drag_handler.style.minimal_height = 22
	drag_handler.style.maximal_height = 0
	drag_handler.style.margin = 0
	drag_handler.style.width = 10

	local info_flow = main_frame.add(VERTICAL_FLOW)
	info_flow.visible = false
	local hud_table = info_flow.add{type = "table", column_count = 2}
	local add = hud_table.add
	hud_table.style.column_alignments[1] = "center"
	hud_table.style.column_alignments[2] = "center"

	add(LABEL).caption = {'', {"free-market.sell-price-label"}, COLON}
	local sell_price = add(LABEL)
	-- sell_price.name = "sell_price"
	add(LABEL).caption = {'', {"free-market.buy-price-label"}, COLON}
	local buy_price = add(LABEL)
	-- buy_price.name = "buy_price"

	local storage_flow = info_flow.add(FLOW)
	local add = storage_flow.add
	local item_label = add(LABEL)
	add(LABEL).caption = {'', {"description.storage"}, COLON}
	local storage_count = add(LABEL)
	-- storage_count.name = "storage_count"
	add(LABEL).caption = '/'
	local storage_limit = add(LABEL)
	-- storage_limit.name = "storage_limit"

	item_HUD[player.index] = {
		info_flow,
		sell_price,
		buy_price,
		item_label,
		storage_count,
		storage_limit
	}
end

local function clear_invalid_player_data()
	for player_index in pairs(item_HUD) do
		local player = game.get_player(player_index)
		if not (player and player.valid) then
			item_HUD[player_index] = nil
		elseif not player.connected then
			delete_item_price_HUD(player)
		end
	end
end

---@param player LuaPlayer #LuaPlayer
local function hide_item_price_HUD(player)
	local hinter = item_HUD[player.index]
	if hinter then
		hinter[1].visible = false
	end
end

---@param player LuaPlayer #LuaPlayer
---@param item_name string
local function show_item_info_HUD(player, item_name)
	local force_index = player.force.index
	local sell_price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name]
	local buy_price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
	local count = storages[force_index][item_name]
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold

	local hinter = item_HUD[player.index]
	hinter[1].visible = true
	if sell_price then
		hinter[2].caption = tostring(sell_price)
	else
		hinter[2].caption = ''
	end
	if buy_price then
		hinter[3].caption = tostring(buy_price)
	else
		hinter[3].caption = ''
	end
	hinter[4].caption = "[item=" .. item_name .. ']'
	if count then
		hinter[5].caption = tostring(count)
	else
		hinter[5].caption = '0'
	end
	hinter[6].caption = limit
end

--#endregion


--#region Functions of events

local REMOVE_BOX_FUNCS = {
	[BUY_TYPE] = remove_certain_buy_box,
	[PULL_TYPE] = remove_certain_pull_box,
	[TRANSFER_TYPE] = remove_certain_transfer_box,
	[UNIVERSAL_TRANSFER_TYPE] = remove_certain_universal_transfer_box,
	[BIN_TYPE] = remove_certain_bin_box,
	[UNIVERSAL_BIN_TYPE] = remove_certain_universal_bin_box,
}
local function clear_box_data(event)
	local entity = event.entity
	local unit_number = entity.unit_number
	local box_data = all_boxes[unit_number]
	if box_data == nil then return end

	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data)
end

---@param entity LuaEntity
local function clear_box_data_by_entity(entity)
	local unit_number = entity.unit_number
	local box_data = all_boxes[unit_number]
	if box_data == nil then return end

	rendering_destroy(box_data[2])
	REMOVE_BOX_FUNCS[box_data[3]](entity, box_data)
	return true
end

local function on_player_created(event)
	local player = game.get_player(event.player_index)
	create_item_price_HUD(player)
	create_top_relative_gui(player)
	create_left_relative_gui(player)
	switch_sell_prices_gui(player)
	switch_buy_prices_gui(player)
	if player.mod_settings["FM_show_item_price"].value then
		create_item_price_HUD(player)
	end
end

-- TODO: check
local function on_player_joined_game(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	if #game.connected_players == 1 then
		clear_invalid_player_data()
	end

	clear_boxes_gui(player)
	destroy_prices_gui(player)
	destroy_price_list_gui(player)
	create_item_price_HUD(player)
end

local function on_player_cursor_stack_changed(event)
	local player = game.get_player(event.player_index)
	local cursor_stack = player.cursor_stack
	if cursor_stack.valid_for_read then
		if player.mod_settings["FM_show_item_price"].value then
			show_item_info_HUD(player, cursor_stack.name)
		end
	else
		hide_item_price_HUD(player)
	end
end

local function on_force_created(event)
	init_force_data(event.force.index)
end

local function check_teams_data()
	for _, storage in pairs(storages) do
		for item_name, count in pairs(storage) do
			if count == 0 then
				storage[item_name] = nil
			end
		end
	end
end

local function check_forces()
	local forces_money = call("EasyAPI", "get_forces_money")

	local neutral_force = game.forces.neutral
	mod_data.active_forces = {}
	active_forces = mod_data.active_forces
	local size = 0
	-- TODO: improve and refactor
	for _, force in pairs(game.forces) do
		if #force.connected_players > 0 then
			local force_index = force.index
			local items_data = buy_boxes[force_index]
			local storage_data = storages[force_index]
			if items_data and next(items_data) or storage_data and next(storage_data) then
				local buyer_money = forces_money[force_index]
				if buyer_money and buyer_money > money_treshold then
					size = size + 1
					active_forces[size] = force_index
				end
			end
		elseif math.random(99) > skip_offline_team_chance or force == neutral_force then
			local force_index = force.index
			local items_data = buy_boxes[force_index]
			local storage_data = storages[force_index]
			if items_data and next(items_data) or storage_data and next(storage_data) then
				local buyer_money = forces_money[force_index]
				if buyer_money and buyer_money > money_treshold then
					size = size + 1
					active_forces[size] = force_index
				end
			end
		end
	end

	if #active_forces < 2 then
		mod_data.active_forces = {}
		active_forces = mod_data.active_forces
	end
end

local function on_forces_merging(event)
	local source = event.source
	local source_index = source.index

	local source_storage = storages[source_index]
	local destination_storage = storages[event.destination.index]
	for item_name, count in pairs(source_storage) do
		destination_storage[item_name] = count + (destination_storage[item_name] or 0)
	end
	clear_force_data(source_index)

	local ids = rendering.get_all_ids()
	for i = 1, #ids do
		local id = ids[i]
		if is_render_valid(id) then
			local target = get_render_target(id)
			if target then
				local entity = target.entity
				if (not (entity and entity.valid) or entity.force == source) and Rget_type(id) == "text" then
					rendering_destroy(id)
					all_boxes[entity.unit_number] = nil
				end
			end
		end
	end
	check_forces()
end

local function on_force_cease_fire_changed(event)
	local force_index = event.force.index
	local other_force_index = event.other_force.index
	if event.added then
		embargoes[force_index][other_force_index] = nil
	else
		embargoes[force_index][other_force_index] = true
	end
end

local function set_transfer_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end -- TODO: print message

	local box_data = all_boxes[entity.unit_number]
	if box_data then
		local item_name = box_data[5]
		local box_type = box_data[3]
		if box_type == BUY_TYPE then
			check_buy_price(player, item_name)
		elseif box_type == TRANSFER_TYPE or box_type == UNIVERSAL_TRANSFER_TYPE then
			check_sell_price(player, item_name)
		end
		return
	end

	local item = entity.get_inventory(chest_inventory_type)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_transfer_box_data(item.name, player, entity)
end

local function set_bin_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end -- TODO: print message

	if all_boxes[entity.unit_number] then
		return
	end

	local item = entity.get_inventory(chest_inventory_type)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_bin_box_data(item.name, player, entity)
end

local function set_universal_transfer_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end -- TODO: print message

	local box_data = all_boxes[entity.unit_number]
	if box_data == nil then
		set_universal_transfer_box_data(player, entity)
	else
		local item_name = box_data[5]
		local box_type = box_data[3]
		if box_type == BUY_TYPE then
			check_buy_price(player, item_name)
		elseif box_type == TRANSFER_TYPE then
			check_sell_price(player, item_name)
		end
	end
end

local function set_universal_bin_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end -- TODO: print message

	if all_boxes[entity.unit_number] == nil then
		set_universal_bin_box_data(player, entity)
	end
end

local function set_pull_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end -- TODO: print message

	if all_boxes[entity.unit_number] then
		return
	end

	local item = entity.get_inventory(chest_inventory_type)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_pull_box_data(item.name, player, entity)
end

local function set_buy_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end

	local box_data = all_boxes[entity.unit_number]
	if box_data then
		local item_name = box_data[5]
		local box_type = box_data[3]
		if box_type == BUY_TYPE then
			check_buy_price(player, item_name)
		elseif box_type == TRANSFER_TYPE then
			check_sell_price(player, item_name)
		end
		return
	end

	local item = entity.get_inventory(chest_inventory_type)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_buy_box_data(item.name, player, entity)
end

local function on_gui_elem_changed(event)
	local element = event.element
	if not (element and element.valid) then return end
	if element.name ~= "FM_prices_item" then return end
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	local item_row = element.parent
	local content_flow = item_row.parent
	local storage_row = content_flow.storage_row
	local item_name = element.elem_value
	if item_name == nil then
		item_row.sell_price.text = ''
		item_row.buy_price.text = ''
		local prices_table = content_flow.other_prices_frame["scroll-pane"].prices_table
		prices_table.clear()
		make_prices_header(prices_table)
		storage_row.visible = false
		return
	end

	local force_index = player.force.index

	storage_row.visible = true
	local count = storages[force_index][item_name] or 0
	storage_row.storage_count.caption = tostring(count)
	local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold
	storage_row.storage_limit.text = tostring(limit)

	item_row.sell_price.text = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or '')
	item_row.buy_price.text = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or '')
	update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
end

local function on_gui_selection_state_changed(event)
	local element = event.element
	if not (element and element.valid) then return end
	if element.name ~= "FM_force_price_list" then return end

	local scroll_pane = element.parent.parent.deep_frame["scroll-pane"]
	local force = game.forces[element.items[element.selected_index]]
	if force == nil then
		scroll_pane.clear()
		make_price_list_header(scroll_pane)
		return
	end

	update_price_list_table(force, scroll_pane)
end


local GUIS = {
	[''] = function(element, player)
		local parent_name = element.parent.name
		if parent_name == "price_list_table" then
			local item_name = sub(element.sprite, 6)
			local force_index = player.force.index
			local prices_frame = player.gui.screen.FM_prices_frame
			if prices_frame == nil then
				switch_prices_gui(player, item_name)
			else
				local content_flow = prices_frame.shallow_frame.content_flow
				content_flow.item_row.FM_prices_item.elem_value = item_name
				local sell_price = sell_prices[force_index][item_name]
				content_flow.item_row.sell_price.text = tostring(sell_price or '')
				local buy_price = buy_prices[force_index][item_name]
				content_flow.item_row.buy_price.text = tostring(buy_price or '')
				update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
			end
		elseif parent_name == "FM_storage_table" then
			local item_name = sub(element.sprite, 6)
			switch_prices_gui(player, item_name)
		end
	end,
	FM_close = function(element)
		element.parent.parent.destroy()
	end,
	FM_confirm_default_limit = function(element, player)
		local setting_row = element.parent
		local default_limit = tonumber(setting_row.FM_default_limit.text)
		if default_limit == nil or default_limit < 1 or default_limit > max_storage_threshold then
			player.print({"gui-map-generator.invalid-value-for-field", default_limit or '', 1, max_storage_threshold})
			return
		end

		local force_index = player.force.index
		default_storage_limit[force_index] = default_limit
	end,
	FM_confirm_storage_limit = function(element, player)
		local storage_row = element.parent
		local storage_limit = tonumber(storage_row.storage_limit.text)
		if storage_limit == nil or storage_limit < 1 or storage_limit > max_storage_threshold then
			player.print({"gui-map-generator.invalid-value-for-field", storage_limit or '', 1, max_storage_threshold})
			return
		end

		local item_name = storage_row.parent.item_row.FM_prices_item.elem_value
		if item_name == nil then return end

		local force_index = player.force.index
		storages_limit[force_index][item_name] = storage_limit
	end,
	FM_confirm_buy_box = function(element, player)
		local parent = element.parent
		local count = tonumber(parent.count.text)
		-- TODO: change?
		if count == nil then
			player.print({"multiplayer.no-address", {"gui-train.add-item-count-condition"}})
			return
		elseif count < 1 then
			player.print({"count-must-be-more-n", 0})
			return
		end

		local item_name = parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local box_operations = parent.parent
		local player_index = player.index
		local entity = open_box[player_index] -- TODO: change?
		if entity then
			local inventory_size = #entity.get_inventory(chest_inventory_type)
			local max_count = game.item_prototypes[item_name].stack_size * inventory_size
			if count > max_count then
				player.print({"gui-map-generator.invalid-value-for-field", count, 1, max_count})
				parent.count.text = tostring(max_count)
				return
			end

			set_buy_box_data(item_name, player, entity, count)
			box_operations.clear()
			check_buy_price_for_opened_chest(player, box_operations, item_name)
		else
			box_operations.clear()
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end

		if #box_operations.children == 0 then
			open_box[player_index] = nil
		end
	end,
	FM_confirm_buy_price_for_chest = function(element, player)
		local box_operations = element.parent
		local entity = open_box[player.index] -- TODO: change?
		local box_data = all_boxes[entity.unit_number]
		if box_data == nil then
			-- TODO: improve
			box_operations.clear()
			return
		end

		local buy_price = tonumber(box_operations.buy_price.text)
		if not buy_price then
			box_operations.clear()
		elseif buy_price < 1 then
			-- TODO: change?
			player.print({"count-must-be-more-n", 0})
			return
		end

		local item_name = box_data[5]
		change_buy_price_by_player(item_name, player, buy_price)
		box_operations.clear()
	end,
	FM_confirm_transfer_box = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local box_operations = parent.parent
		local player_index = player.index
		local entity = open_box[player_index] -- TODO: change?
		if entity then
			set_transfer_box_data(item_name, player, entity)
			box_operations.clear()
			check_sell_price_for_opened_chest(player, box_operations, item_name)
		else
			box_operations.clear()
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end

		if #box_operations.children == 0 then
			open_box[player_index] = nil
		end
	end,
	FM_confirm_bin_box = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local box_operations = parent.parent
		local player_index = player.index
		local entity = open_box[player_index] -- TODO: change?
		if entity then
			set_bin_box_data(item_name, player, entity)
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		box_operations.clear()
		open_box[player_index] = nil
	end,
	FM_confirm_sell_price_for_chest = function(element, player)
		local box_operations = element.parent
		local entity = open_box[player.index] -- TODO: change?
		local box_data = all_boxes[entity.unit_number]
		if box_data == nil then
			-- TODO: improve
			box_operations.clear()
			return
		end

		local sell_price = tonumber(box_operations.sell_price.text)
		if not sell_price then
			box_operations.clear()
		elseif sell_price < 1 then
			-- TODO: change?
			player.print({"count-must-be-more-n", 0})
			return
		end

		local item_name = box_data[5]
		change_sell_price_by_player(item_name, player, sell_price)
		box_operations.clear()
	end,
	FM_confirm_pull_box = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local player_index = player.index
		local entity = open_box[player_index] -- TODO: change?
		if entity then
			set_pull_box_data(item_name, player, entity)
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		local box_operations = parent.parent
		box_operations.clear()
	end,
	FM_change_transfer_box = function(element, player)
		local parent = element.parent
		local player_index = player.index
		local entity = open_box[player_index]
		local item_name = parent.FM_item.elem_value
		if entity then
			local box_data = all_boxes[entity.unit_number]
			if item_name then
				if box_data and box_data[3] == TRANSFER_TYPE then
					local player_force = player.force
					local f_transfer_boxes = transfer_boxes[player_force.index]
					if f_transfer_boxes[item_name] then
						remove_certain_transfer_box(entity, box_data)
					end
					f_transfer_boxes[item_name] = f_transfer_boxes[item_name] or {}
					local entities = f_transfer_boxes[item_name]
					entities[#entities+1] = entity
					box_data[4] = entities
					box_data[5] = item_name
					show_item_sprite_above_chest(item_name, player_force, entity)
				else
					player.print({"gui-train.invalid"})
				end
			else
				rendering_destroy(all_boxes[entity.unit_number][2])
				remove_certain_transfer_box(entity, box_data)
			end
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		local box_operations = element.parent.parent
		box_operations.clear()
	end,
	FM_change_bin_box = function(element, player)
		local parent = element.parent
		local player_index = player.index
		local entity = open_box[player_index]
		local item_name = parent.FM_item.elem_value
		if entity then
			local box_data = all_boxes[entity.unit_number]
			if item_name then
				if box_data and box_data[3] == BIN_TYPE then
					local player_force = player.force
					local f_bin_boxes = bin_boxes[player_force.index]
					if f_bin_boxes[item_name] then
						remove_certain_bin_box(entity, box_data)
					end
					f_bin_boxes[item_name] = f_bin_boxes[item_name] or {}
					local entities = f_bin_boxes[item_name]
					entities[#entities+1] = entity
					box_data[4] = entities
					box_data[5] = item_name
					show_item_sprite_above_chest(item_name, player_force, entity)
				else
					player.print({"gui-train.invalid"})
				end
			else
				rendering_destroy(all_boxes[entity.unit_number][2])
				remove_certain_bin_box(entity, box_data)
			end
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		local box_operations = element.parent.parent
		box_operations.clear()
	end,
	FM_change_pull_box = function(element, player)
		local parent = element.parent
		local player_index = player.index
		local entity = open_box[player_index]
		local item_name = parent.FM_item.elem_value
		if entity then
			local box_data = all_boxes[entity.unit_number]
			if item_name then
				if box_data and box_data[3] == PULL_TYPE then
					local player_force = player.force
					local f_pull_boxes = pull_boxes[player_force.index]
					if f_pull_boxes[item_name] then
						remove_certain_pull_box(entity, box_data)
					end
					f_pull_boxes[item_name] = f_pull_boxes[item_name] or {}
					local entities = f_pull_boxes[item_name]
					entities[#entities+1] = entity
					box_data[4] = entities
					box_data[5] = item_name
					show_item_sprite_above_chest(item_name, player_force, entity)
				else
					player.print({"gui-train.invalid"})
				end
			else
				rendering_destroy(all_boxes[entity.unit_number][2])
				remove_certain_pull_box(entity, box_data)
			end
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		local box_operations = element.parent.parent
		box_operations.clear()
	end,
	FM_change_buy_box = function(element, player)
		local parent = element.parent
		local player_index = player.index
		local entity = open_box[player_index]
		local count = tonumber(parent.count.text)
		local item_name = parent.FM_item.elem_value
		if entity then
			local box_data = all_boxes[entity.unit_number]
			if item_name and count then
				local prev_item_name = box_data[5]
				if prev_item_name == item_name then
					change_count_in_buy_box_data(entity, item_name, count)
				else
					if box_data and box_data[3] == BUY_TYPE then
						local player_force = player.force
						local f_buy_boxes = buy_boxes[player_force.index]
						if f_buy_boxes[item_name] then
							remove_certain_buy_box(entity, box_data)
						end
						f_buy_boxes[item_name] = f_buy_boxes[item_name] or {}
						local entities = f_buy_boxes[item_name]
						entities[#entities+1] = {entity, count}
						box_data[4] = entities
						box_data[5] = item_name
						show_item_sprite_above_chest(item_name, player_force, entity)
					else
						player.print({"gui-train.invalid"})
					end
				end
			else
				rendering_destroy(all_boxes[entity.unit_number][2])
				remove_certain_buy_box(entity, box_data)
			end
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		local box_operations = element.parent.parent
		box_operations.clear()
	end,
	FM_confirm_sell_price = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_prices_item.elem_value
		if item_name == nil then return end

		local sell_price_element = parent.sell_price
		local sell_price = tonumber(sell_price_element.text)
		local prev_sell_price = change_sell_price_by_player(item_name, player, sell_price)
		if prev_sell_price then
			sell_price_element.text = tostring(prev_sell_price)
		end
	end,
	FM_confirm_buy_price = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_prices_item.elem_value
		if item_name == nil then return end

		local buy_price_element = parent.buy_price
		local buy_price = tonumber(buy_price_element.text)
		local prev_buy_price = change_buy_price_by_player(item_name, player, buy_price)
		if prev_buy_price then
			buy_price_element.text = tostring(prev_buy_price)
		end
	end,
	FM_refresh_prices_table = function(element, player)
		local content_flow = element.parent.parent.shallow_frame.content_flow
		local item_row = content_flow.item_row
		local item_name = item_row.FM_prices_item.elem_value
		if item_name == nil then return end

		local force_index = player.force.index
		item_row.buy_price.text = tostring(buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name] or '')
		item_row.sell_price.text = tostring(sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name] or '')

		local storage_row = content_flow.storage_row
		local count = storages[force_index][item_name] or 0
		storage_row.storage_count.caption = tostring(count)
		local limit = storages_limit[force_index][item_name] or default_storage_limit[force_index] or max_storage_threshold
		storage_row.storage_limit.text = tostring(limit)

		update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
	end,
	FM_set_transfer_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == TRANSFER_TYPE then
					open_transfer_box_gui(player, false, entity)
				elseif box_type == BUY_TYPE then
					player.print({"free-market.this-is-buy-box"})
					return
				elseif box_type == PULL_TYPE then
					player.print({"free-market.this-is-pull-box"})
					return
				elseif box_type == UNIVERSAL_TRANSFER_TYPE then
					player.print({"free-market.this-is-universal-transfer-box"})
					return
				elseif box_type == BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				elseif box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				local item = entity.get_inventory(chest_inventory_type)[1]
				if not item.valid_for_read then
					open_transfer_box_gui(player, true)
				else
					local item_name = item.name
					set_transfer_box_data(item_name, player, entity)
					check_sell_price(player, item_name)
				end
			end
			open_box[player.index] = entity
		end
	end,
	FM_set_universal_transfer_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == TRANSFER_TYPE then
					player.print({"free-market.this-is-transfer-box"})
					return
				elseif box_type == BUY_TYPE then
					player.print({"free-market.this-is-buy-box"})
					return
				elseif box_type == PULL_TYPE then
					player.print({"free-market.this-is-pull-box"})
					return
				elseif box_type == BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				elseif box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				set_universal_transfer_box_data(player, entity)
			end
			open_box[player.index] = entity -- is this necessary?
		end
	end,
	FM_set_bin_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == BIN_TYPE then
					open_bin_box_gui(player, false, entity)
				elseif box_type == BUY_TYPE then
					player.print({"free-market.this-is-buy-box"})
					return
				elseif box_type == PULL_TYPE then
					player.print({"free-market.this-is-pull-box"})
					return
				elseif box_type == UNIVERSAL_TRANSFER_TYPE then
					player.print({"free-market.this-is-universal-transfer-box"})
					return
				elseif box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				local item = entity.get_inventory(chest_inventory_type)[1]
				if not item.valid_for_read then
					open_bin_box_gui(player, true)
				else
					set_bin_box_data(item.name, player, entity)
				end
			end
			open_box[player.index] = entity
		end
	end,
	FM_set_universal_bin_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-transfer-box"})
					return
				elseif box_type == BUY_TYPE then
					player.print({"free-market.this-is-buy-box"})
					return
				elseif box_type == PULL_TYPE then
					player.print({"free-market.this-is-pull-box"})
					return
				elseif box_type == BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				set_universal_bin_box_data(player, entity)
			end
			open_box[player.index] = entity -- is this necessary?
		end
	end,
	FM_set_pull_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == PULL_TYPE then
					open_pull_box_gui(player, false, entity)
				elseif box_type == BUY_TYPE then
					player.print({"free-market.this-is-buy-box"})
					return
				elseif box_type == TRANSFER_TYPE then
					player.print({"free-market.this-is-transfer-box"})
					return
				elseif box_type == UNIVERSAL_TRANSFER_TYPE then
					player.print({"free-market.this-is-universal-transfer-box"})
					return
				elseif box_type == BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				elseif box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				local item = entity.get_inventory(chest_inventory_type)[1]
				if not item.valid_for_read then
					open_pull_box_gui(player, true)
				else
					set_pull_box_data(item.name, player, entity)
				end
			end
			open_box[player.index] = entity
		end
	end,
	FM_set_buy_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			local box_data = all_boxes[entity.unit_number]
			if box_data then
				local box_type = box_data[3]
				if box_type == BUY_TYPE then
					open_buy_box_gui(player, false, entity)
				elseif box_type == TRANSFER_TYPE then
					player.print({"free-market.this-is-transfer-box"})
					return
				elseif box_type == UNIVERSAL_TRANSFER_TYPE then
					player.print({"free-market.this-is-universal-transfer-box"})
					return
				elseif box_type == PULL_TYPE then
					player.print({"free-market.this-is-pull-box"})
					return
				elseif box_type == BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				elseif box_type == UNIVERSAL_BIN_TYPE then
					player.print({"free-market.this-is-universal-bin-box"})
					return
				end
			else
				local item = entity.get_inventory(chest_inventory_type)[1]
				if not item.valid_for_read then
					open_buy_box_gui(player, true)
				else
					local box_operations = element.parent.parent.box_operations
					local item_name = item.name
					set_buy_box_data(item_name, player, entity)
					check_buy_price_for_opened_chest(player, box_operations, item_name)
				end
			end
			open_box[player.index] = entity
		end
	end,
	FM_print_force_data = function(element, player)
		if player.admin then
			print_force_data(player.force, player)
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_buy_prices = function(element, player)
		if is_reset_public or player.admin then
			local force_index = player.force.index
			buy_prices[force_index] = {}
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_sell_prices = function(element, player)
		if is_reset_public or player.admin then
			local force_index = player.force.index
			sell_prices[force_index] = {}
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_all_prices = function(element, player)
		if is_reset_public or player.admin then
			local force_index = player.force.index
			sell_prices[force_index] = {}
			buy_prices[force_index] = {}
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_buy_boxes = function(element, player)
		if is_reset_public or player.admin then
			reset_buy_boxes(player.force.index)
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_transfer_boxes = function(element, player)
		if is_reset_public or player.admin then
			reset_transfer_boxes(player.force.index)
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_pull_boxes = function(element, player)
		if is_reset_public or player.admin then
			reset_pull_boxes(player.force.index)
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_reset_all_boxes = function(element, player)
		if is_reset_public or player.admin then
			local force_index = player.force.index
			reset_buy_boxes(force_index)
			reset_transfer_boxes(force_index)
			reset_pull_boxes(force_index)
		else
			player.print({"command-output.parameters-require-admin"})
		end
	end,
	FM_declare_embargo = function(element, player)
		local table_element = element.parent.parent
		local forces_list = table_element.forces_list
		if forces_list.selected_index == 0 then return end

		local force_name = forces_list.items[forces_list.selected_index]
		local other_force = game.forces[force_name]
		if other_force and other_force.valid then
			local force = player.force
			embargoes[force.index][other_force.index] = true
			local message = {"free-market.declared-embargo", force.name, other_force.name, player.name}
			force.print(message)
			other_force.print(message)
		end
		update_embargo_table(table_element, player)
	end,
	FM_cancel_embargo = function(element, player)
		local table_element = element.parent.parent
		local embargo_list = table_element.embargo_list
		if embargo_list.selected_index == 0 then return end

		local force_name = embargo_list.items[embargo_list.selected_index]
		local other_force = game.forces[force_name]
		if other_force and other_force.valid then
			local force = player.force
			embargoes[force.index][other_force.index] = nil
			local message = {"free-market.canceled-embargo", force.name, other_force.name, player.name}
			force.print(message)
			other_force.print(message)
		end
		update_embargo_table(table_element, player)
	end,
	FM_open_force_configuration = function(element, player)
		open_force_configuration(player)
	end,
	FM_open_price = function(element, player)
		switch_prices_gui(player)
	end,
	FM_switch_sell_prices_gui = function(element, player)
		switch_sell_prices_gui(player)
	end,
	FM_switch_buy_prices_gui = function(element, player)
		switch_buy_prices_gui(player)
	end,
	FM_open_sell_price = function(element, player, event)
		local force_index = tonumber(element.children[1].name)
		local force = game.forces[force_index or 0]
		if not (force and force.valid) then
			game.print({"force-doesnt-exist", '?'})
			return
		end

		local item_name = sub(element.sprite, 6)
		if game.item_prototypes[item_name] == nil then
			game.print({"missing-item", item_name})
			return
		end

		local price = sell_prices[force_index][item_name] or inactive_sell_prices[force_index][item_name]
		if price then
			if event.shift then
				-- use buy price for sell price
				change_buy_price_by_player(item_name, player, price)
			end
			if event.control then
				-- copy price
				change_sell_price_by_player(item_name, player, price)
			end
			if event.alt then
				switch_prices_gui(player, item_name)
			end
			game.print({"free-market.team-selling-item-for", force.name, item_name, price})
		else
			-- TODO: improve! (remove the row)
			game.print({"free-market.team-doesnt-sell-item", force.name, item_name})
		end
	end,
	FM_open_buy_price = function(element, player, event)
		local force_index = tonumber(element.children[1].name) or 0
		local force = game.forces[force_index]
		if not (force and force.valid) then
			game.print({"force-doesnt-exist", '?'})
			return
		end

		local item_name = sub(element.sprite, 6)
		if game.item_prototypes[item_name] == nil then
			game.print({"missing-item", item_name})
			return
		end

		local price = buy_prices[force_index][item_name] or inactive_buy_prices[force_index][item_name]
		if price then
			if event.shift then
				-- copy price
				change_buy_price_by_player(item_name, player, price)
			end
			if event.control then
				-- use buy price for sell price
				change_sell_price_by_player(item_name, player, price)
			end
			if event.alt then
				switch_prices_gui(player, item_name)
			end
			game.print({"free-market.team-buying-item-for", force.name, item_name, price})
		else
			-- TODO: improve! (remove the row)
			game.print({"free-market.team-doesnt-buy-item", force.name, item_name})
		end
	end,
	FM_open_price_list = function(element, player)
		open_price_list_gui(player)
	end,
	FM_open_embargo = function(element, player)
		open_embargo_gui(player)
	end,
	FM_open_storage = function(element, player)
		open_storage_gui(player)
	end,
	FM_show_hint = function(element, player)
		player.print({"free-market.hint"})
	end,
	FM_hide_left_buttons = function(element, player)
		element.name = "FM_show_left_buttons"
		element.caption = '<'
		element.parent.children[2].visible = false
	end,
	FM_show_left_buttons = function(element, player)
		element.name = "FM_hide_left_buttons"
		element.caption = '>'
		element.parent.children[2].visible = true
	end,
	FM_search_by_price = function(element, player)
		local search_row = element.parent
		local selected_index = search_row.FM_search_price_drop_down.selected_index
		if selected_index == 0 then -- Nothing selected
			return
		end

		local content_flow = search_row.parent
		local drop_down = content_flow.team_row.FM_force_price_list
		local force = game.forces[drop_down.items[drop_down.selected_index]]
		if force == nil then
			return
		end

		local search_text = search_row.FM_search_text.text
		if #search_text > 50 then
			return
		end
		local scroll_pane = content_flow.deep_frame["scroll-pane"]
		if search_text == '' then
			update_price_list_table(force, scroll_pane)
			return
		end

		search_text = ".?" .. search_text:lower():gsub(" ", ".?") .. ".?"
		if selected_index == 1 then -- it's sell offer
			update_price_list_by_sell_filter(force, scroll_pane, search_text)
		else -- it's buy request
			update_price_list_by_buy_filter(force, scroll_pane, search_text)
		end
	end
}
local function on_gui_click(event)
	local element = event.element
	local f = GUIS[element.name]
	if f then f(element, game.get_player(event.player_index), event) end
end

local function on_gui_closed(event)
	local entity = event.entity
	if not (entity and entity.valid) then return end
	if not ALLOWED_TYPES[entity.type] then return end
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end
	player.gui.relative.FM_boxes_frame.content.main_flow.box_operations.clear()
end

local function check_pull_boxes()
	local stack = {name = "", count = 0}
	for other_force_index, _items_data in pairs(pull_boxes) do
		local storage = storages[other_force_index]
		for item_name, force_entities in pairs(_items_data) do
			local count_in_storage = storage[item_name]
			if count_in_storage and count_in_storage > 0 then
				stack["name"] = item_name
				for i=1, #force_entities do
					if count_in_storage <= 0 then
						break
					end
					stack["count"] = count_in_storage
					count_in_storage = count_in_storage - force_entities[i].insert(stack)
				end
				storage[item_name] = count_in_storage
			end
		end
	end
end

local function check_transfer_boxes()
	local stack = {name = "", count = 4000000000}
	-- It's not safe to set count above ~4000000000

	for force_index, force_entities in pairs(universal_bin_boxes) do
		local storage = storages[force_index]
		for i=1, #force_entities do
			local entity = force_entities[i]
			local contents = entity.get_inventory(chest_inventory_type).get_contents()
			for item_name in pairs(contents) do
				local count = storage[item_name] or 0
				stack["name"] = item_name
				local sum = entity.remove_item(stack)
				if sum > 0 then
					storage[item_name] = count + sum
				end
			end
		end
	end

	for force_index, _items_data in pairs(bin_boxes) do
		local storage = storages[force_index]
		for item_name, force_entities in pairs(_items_data) do
			local count = storage[item_name] or 0
			stack["name"] = item_name
			local sum = 0
			for i=1, #force_entities do
				sum = sum + force_entities[i].remove_item(stack)
			end
			if sum > 0 then
				storage[item_name] = count + sum
			end
		end
	end

	-- Works has much more impact on UPS than transfer_boxes
	for force_index, force_entities in pairs(universal_transfer_boxes) do
		local default_limit = default_storage_limit[force_index]
		local storage_limit = storages_limit[force_index]
		local storage = storages[force_index]
		for i=1, #force_entities do
			local entity = force_entities[i]
			local contents = entity.get_inventory(chest_inventory_type).get_contents()
			for item_name in pairs(contents) do
				local count = storage[item_name] or 0
				local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count
				if max_count > 0 then
					stack["count"] = max_count
					stack["name"] = item_name
					local sum = entity.remove_item(stack)
					if sum > 0 then
						storage[item_name] = count + sum
					end
				end
			end
		end
	end

	for force_index, _items_data in pairs(transfer_boxes) do
		local default_limit = default_storage_limit[force_index]
		local storage_limit = storages_limit[force_index]
		local storage = storages[force_index]
		for item_name, force_entities in pairs(_items_data) do
			local count = storage[item_name] or 0
			local max_count = (storage_limit[item_name] or default_limit or max_storage_threshold) - count
			if max_count > 0 then
				stack["count"] = max_count
				stack["name"] = item_name
				local sum = 0
				for i=1, #force_entities do
					sum = sum + force_entities[i].remove_item(stack)
				end
				if sum > 0 then
					storage[item_name] = count + sum
				end
			end
		end
	end
end

local function check_buy_boxes()
	local last_checked_index = mod_data.last_checked_index
	local buyer_index
	if last_checked_index then
		buyer_index = active_forces[last_checked_index]
		if buyer_index then
			mod_data.last_checked_index = last_checked_index + 1
		else
			mod_data.last_checked_index = nil
			return
		end
	else
		last_checked_index, buyer_index = next(active_forces)
		if last_checked_index then
			mod_data.last_checked_index = last_checked_index
		else
			return
		end
	end

	local items_data = buy_boxes[buyer_index]
	if items_data == nil then return end

	local forces_money = call("EasyAPI", "get_forces_money")
	local forces_money_copy = {}
	for _force_index, value in pairs(forces_money) do
		forces_money_copy[_force_index] = value
	end

	local buyer_money = forces_money_copy[buyer_index]
	if buyer_money and buyer_money > money_treshold then
		local stack = {name = "", count = 0}
		local stack_count = 0 -- for optimization
		local payment = 0
		local f_buy_prices = buy_prices[buyer_index]
		for item_name, entities in pairs(items_data) do
			if money_treshold >= buyer_money then
				-- TODO: improve
				goto not_enough_money
			end
			local buy_price = f_buy_prices[item_name]
			if buy_price and buyer_money >= buy_price then
				for i=1, #entities do
					local buy_data = entities[i]
					local purchasable_count = buyer_money / buy_price
					if purchasable_count < 1 then
						goto skip_buy
					else
						purchasable_count = math.floor(purchasable_count)
					end
					local buy_box = buy_data[1]
					local need_count = buy_data[2]
					if purchasable_count < need_count then
						need_count = purchasable_count
					end
					local count = buy_box.get_item_count(item_name)
					stack["name"] = item_name
					if need_count < count then
						stack_count = count
					else
						need_count = need_count - count
						if need_count <= 0 then
							goto skip_buy
						end

						local buyer_storage = storages[buyer_index]
						local count_in_storage = buyer_storage[item_name]
						if count_in_storage and count_in_storage > 0 then
							stack_count = need_count - count_in_storage
							if stack_count <= 0 then
								buyer_storage[item_name] = count_in_storage - need_count
								stack_count = 0
								goto fulfilled_needs
							else
								buyer_storage[item_name] = count_in_storage + (stack_count - need_count)
							end
						else
							stack_count = need_count
						end

						for seller_index, seller_storage in pairs(storages) do
							if buyer_index ~= seller_index and forces_money[seller_index] and not embargoes[seller_index][buyer_index] then
								local sell_price = sell_prices[seller_index][item_name]
								if sell_price and buy_price >= sell_price then
									count_in_storage = seller_storage[item_name]
									if count_in_storage then
										if count_in_storage > stack_count then
											seller_storage[item_name] = count_in_storage - stack_count
											stack_count = 0
											payment = need_count * sell_price
											buyer_money = buyer_money - payment
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment
											goto fulfilled_needs
										else
											stack_count = stack_count - count_in_storage
											seller_storage[item_name] = 0
											payment = (need_count - stack_count) * sell_price
											buyer_money = buyer_money - payment
											forces_money_copy[seller_index] = forces_money_copy[seller_index] + payment
										end
									end
								end
							end
						end
					end
					:: fulfilled_needs ::
					local found_items = need_count - stack_count
					if found_items > 0 then
						stack["count"] = found_items
						buy_box.insert(stack)
					end
					:: skip_buy ::
				end
			end
		end
		:: not_enough_money ::
		forces_money_copy[buyer_index] = buyer_money
	else
		return
	end

	local forces = game.forces
	for _force_index, money in pairs(forces_money_copy) do
		local prev_money = forces_money[_force_index]
		if prev_money ~= money then
			local force = forces[_force_index]
			call("EasyAPI", "set_force_money", force, money)
			force.item_production_statistics.on_flow("trading", money - prev_money)
		end
	end
end

local function on_player_changed_force(event)
	local player_index = event.player_index
	local player = game.get_player(player_index)
	if not (player and player.valid) then return end

	if open_box[player_index] then
		clear_boxes_gui(player)
	end

	local index = player.force.index
	if transfer_boxes[index] == nil then
		init_force_data(index)
	end
end

local function on_player_changed_surface(event)
	local player_index = event.player_index
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	if open_box[player_index] then
		clear_boxes_gui(player)
	end
end

local function on_player_left_game(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	clear_boxes_gui(player)
	destroy_prices_gui(player)
	delete_item_price_HUD(player)
	destroy_price_list_gui(player)
	destroy_force_configuration(player)
end

local function on_selected_entity_changed(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end
	local entity = player.selected
	if not (entity and entity.valid) then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if entity.force ~= player.force then return end
	local box_data = all_boxes[entity.unit_number]
	if box_data == nil then return end
	local item_name = box_data[5]
	if item_name == nil then return end

	show_item_info_HUD(player, item_name)
end


local SELECT_TOOLS = {
	FM_set_pull_boxes_tool = set_pull_box_data,
	FM_set_bin_boxes_tool = set_bin_box_data,
	FM_set_transfer_boxes_tool = set_transfer_box_data,
	FM_set_buy_boxes_tool = set_buy_box_data
}
local function on_player_selected_area(event)
	local tool_name = event.item
	local func = SELECT_TOOLS[tool_name]
	if func then
		local entities = event.entities
		local player = game.get_player(event.player_index)
		for i=1, #entities do
			local entity = entities[i]
			if all_boxes[entity.unit_number] == nil then
				local item = entity.get_inventory(chest_inventory_type)[1]
				if item.valid_for_read then
					func(item.name, player, entity)
				end
			end
		end
	elseif tool_name == "FM_set_universal_transfer_boxes_tool" then
		local entities = event.entities
		local player = game.get_player(event.player_index)
		for i=1, #entities do
			local entity = entities[i]
			if all_boxes[entity.unit_number] == nil then
				set_universal_transfer_box_data(player, entity)
			end
		end
	elseif tool_name == "FM_set_universal_bin_boxes_tool" then
		local entities = event.entities
		local player = game.get_player(event.player_index)
		for i=1, #entities do
			local entity = entities[i]
			if all_boxes[entity.unit_number] == nil then
				set_universal_bin_box_data(player, entity)
			end
		end
	elseif tool_name == "FM_remove_boxes_tool" then
		local entities = event.entities
		local player = game.get_player(event.player_index)
		local count = 0
		for i=1, #entities do
			local is_deleted = clear_box_data_by_entity(entities[i])
			if is_deleted then
				count = count + 1
			end
		end
		if count > 0 then
			player.print({'', {"gui-migrated-content.removed-entity"}, COLON, ' ', count})
		end
	end
end


do
	local TOOL_TO_TYPE = {
		FM_set_pull_boxes_tool = PULL_TYPE,
		FM_set_transfer_boxes_tool = TRANSFER_TYPE,
		FM_set_universal_transfer_boxes_tool = UNIVERSAL_TRANSFER_TYPE,
		FM_set_universal_bin_boxes_tool = UNIVERSAL_BIN_TYPE,
		FM_set_bin_boxes_tool = BIN_TYPE,
		FM_set_buy_boxes_tool = BUY_TYPE
	}
	function on_player_alt_selected_area(event)
		local box_type = TOOL_TO_TYPE[event.item]
		if box_type == nil then return end

		local remove_box = REMOVE_BOX_FUNCS[box_type]
		local entities = event.entities
		for i=#entities, 1, -1 do
			local entity = entities[i]
			if entity.valid then
				local unit_number = entity.unit_number
				local box_data = all_boxes[unit_number]
				if box_data and box_data[3] == box_type then
					rendering_destroy(box_data[2])
					remove_box(entity, box_data)
				end
			end
		end
	end
end


local mod_settings = {
	["FM_enable-auto-embargo"] = function(value) is_auto_embargo = value end,
	["FM_is-public-titles"] = function(value) is_public_titles = value end,
	["FM_is_reset_public"] = function(value) is_reset_public = value end,
	["FM_money-treshold"] = function(value) money_treshold = value end,
	["FM_minimal-price"] = function(value) minimal_price = value end,
	["FM_maximal-price"] = function(value) maximal_price = value end,
	["FM_skip_offline_team_chance"] = function(value) skip_offline_team_chance = value end,
	["FM_max_storage_threshold"] = function(value) max_storage_threshold = value end,
	["FM_update-tick"] = function(value)
		if CHECK_FORCES_TICK == value then
			settings.global["FM_update-tick"] = {
				value = value + 1
			}
			return
		elseif CHECK_TEAMS_DATA_TICK == value then
			settings.global["FM_update-tick"] = {
				value = value + 1
			}
			return
		elseif update_pull_tick == value then
			settings.global["FM_update-tick"] = {
				value = value + 1
			}
			return
		elseif update_transfer_tick == value then
			settings.global["FM_update-tick"] = {
				value = value + 1
			}
			return
		end
		script.on_nth_tick(update_buy_tick, nil)
		update_buy_tick = value
		script.on_nth_tick(value, check_buy_boxes)
	end,
	["FM_update-transfer-tick"] = function(value)
		if CHECK_FORCES_TICK == value then
			settings.global["FM_update-transfer-tick"] = {
				value = value + 1
			}
			return
		elseif CHECK_TEAMS_DATA_TICK == value then
			settings.global["FM_update-transfer-tick"] = {
				value = value + 1
			}
			return
		elseif update_pull_tick == value then
			settings.global["FM_update-transfer-tick"] = {
				value = value + 1
			}
			return
		elseif update_buy_tick == value then
			settings.global["FM_update-transfer-tick"] = {
				value = value + 1
			}
			return
		end
		script.on_nth_tick(update_transfer_tick, nil)
		update_transfer_tick = value
		script.on_nth_tick(value, check_buy_boxes)
	end,
	["FM_update-pull-tick"] = function(value)
		if CHECK_FORCES_TICK == value then
			settings.global["FM_update-pull-tick"] = {
				value = value + 1
			}
			return
		elseif CHECK_TEAMS_DATA_TICK == value then
			settings.global["FM_update-pull-tick"] = {
				value = value + 1
			}
			return
		elseif update_transfer_tick == value then
			settings.global["FM_update-pull-tick"] = {
				value = value + 1
			}
			return
		elseif update_buy_tick == value then
			settings.global["FM_update-pull-tick"] = {
				value = value + 1
			}
			return
		end
		script.on_nth_tick(update_pull_tick, nil)
		update_pull_tick = value
		script.on_nth_tick(value, check_buy_boxes)
	end,
	FM_show_item_price = function(player)
		if player.mod_settings["FM_show_item_price"].value then
			create_item_price_HUD(player)
		else
			delete_item_price_HUD(player)
		end
	end,
	FM_sell_notification_column_count = function(player)
		local column_count = 2 * player.mod_settings["FM_sell_notification_column_count"].value
		local is_vertical = (column_count == 2)
		local frame = player.gui.screen.FM_sell_prices_frame
		local is_frame_vertical = (frame.direction == "vertical")
		if is_vertical ~= is_frame_vertical then
			local last_location = frame.location
			frame.destroy()
			switch_sell_prices_gui(player, last_location)
		end
	end,
	FM_buy_notification_column_count = function(player)
		local column_count = 2 * player.mod_settings["FM_buy_notification_column_count"].value
		local is_vertical = (column_count == 2)
		local frame = player.gui.screen.FM_buy_prices_frame
		local is_frame_vertical = (frame.direction == "vertical")
		if is_vertical ~= is_frame_vertical then
			local last_location = frame.location
			frame.destroy()
			switch_buy_prices_gui(player, last_location)
		end
	end
}
function on_runtime_mod_setting_changed(event)
	local setting_name = event.setting
	local f = mod_settings[setting_name]
	if f == nil then return end

	if event.setting_type == "runtime-global" then
		f(settings.global[setting_name].value)
	else
		local player = game.get_player(event.player_index)
		if player and player.valid then
			f(player)
		end
	end
end

--#endregion


--#region Pre-game stage

local function add_remote_interface()
	-- https://lua-api.factorio.com/latest/LuaRemote.html
	remote.remove_interface("free-market") -- For safety
	remote.add_interface("free-market", {
		get_mod_data = function() return mod_data end,
		get_internal_data = function(name) return mod_data[name] end,
		change_count_in_buy_box_data = change_count_in_buy_box_data,
		remove_certain_pull_box = remove_certain_pull_box,
		remove_certain_transfer_box = remove_certain_transfer_box,
		remove_certain_universal_transfer_box = remove_certain_universal_transfer_box,
		remove_certain_bin_box = remove_certain_bin_box,
		remove_certain_universal_bin_box = remove_certain_universal_bin_box,
		remove_certain_buy_box = remove_certain_buy_box,
		clear_box_data_by_entity = clear_box_data_by_entity,
		set_universal_transfer_box_data = set_universal_transfer_box_data,
		set_universal_bin_box_data = set_universal_bin_box_data,
		set_transfer_box_data = set_transfer_box_data,
		set_bin_box_data = set_bin_box_data,
		set_pull_box_data = set_pull_box_data,
		set_buy_box_data = set_buy_box_data,
		set_item_limit = function(item_name, force_index, count)
			local f_storages_limit = storages_limit[force_index]
			if f_storages_limit == nil then return end
			f_storages_limit[item_name] = count
		end,
		set_default_storage_limit = function(force_index, count)
			local f_default_storage_limit = default_storage_limit[force_index]
			if f_default_storage_limit == nil then return end
			default_storage_limit[force_index] = count
		end,
		set_sell_price = function(item_name, force_index, price)
			local f_sell_prices = sell_prices[force_index]
			if f_sell_prices == nil then return end

			local transferers = transfer_boxes[force_index][item_name]
			local count_in_storage = storages[force_index][item_name]
			if f_sell_prices[item_name] or transferers ~= nil or (count_in_storage and count_in_storage > 0) then
				f_sell_prices[item_name] = price
				inactive_sell_prices[force_index] = nil
			else
				f_sell_prices[item_name] = nil
				inactive_sell_prices[force_index][item_name] = price
			end
		end,
		set_buy_price = function(item_name, force_index, price)
			local f_buy_prices = buy_prices[force_index]
			if f_buy_prices == nil then return end

			local f_buy_boxes = buy_boxes[force_index][item_name]
			if f_buy_prices[item_name] or f_buy_boxes ~= nil then
				f_buy_prices[item_name] = price
				inactive_buy_prices[force_index] = nil
			else
				f_buy_prices[item_name] = nil
				inactive_buy_prices[force_index][item_name] = price
			end
		end,
		force_set_sell_price = function(item_name, force_index, price)
			local f_sell_prices = sell_prices[force_index]
			if f_sell_prices == nil then return end
			f_sell_prices[item_name] = price
			inactive_sell_prices[force_index][item_name] = nil
		end,
		force_set_buy_price = function(item_name, force_index, price)
			local f_buy_prices = buy_prices[force_index]
			if f_buy_prices == nil then return end
			f_buy_prices[item_name] = price
			inactive_buy_prices[force_index][item_name] = nil
		end,
		reset_AI_force_storage = function(force_index)
			local f_sell_prices = sell_prices[force_index]
			if f_sell_prices == nil then return end

			local f_inactive_sell_prices = inactive_sell_prices[force_index]
			for item_name, price in pairs(f_inactive_sell_prices) do
				f_sell_prices[item_name] = price
				f_inactive_sell_prices[item_name] = nil
			end
			local f_buy_prices = buy_prices[force_index]
			local f_inactive_buy_prices = inactive_buy_prices[force_index]
			for item_name, price in pairs(f_inactive_buy_prices) do
				f_buy_prices[item_name] = price
				f_inactive_buy_prices[item_name] = nil
			end

			-- TODO: change
			local f_storages_limit = storages_limit[force_index]
			local f_storage = storages[force_index]
			for item_name in pairs(f_buy_prices) do
				f_storage[item_name] = 2000000000
				f_storages_limit[item_name] = 4000000000
			end
			for item_name in pairs(f_sell_prices) do
				f_storage[item_name] = 2000000000
				f_storages_limit[item_name] = 4000000000
			end
		end,
		get_item_limit = function(item_name, force_index)
			local f_storages_limit = storages_limit[force_index]
			if f_storages_limit == nil then return end
			return f_storages_limit[item_name]
		end,
		get_default_storage_limit = function(force_index)
			return default_storage_limit[force_index]
		end,
		get_inactive_universal_transfer_boxes = function() return inactive_universal_transfer_boxes end,
		get_inactive_universal_bin_boxes = function() return inactive_universal_bin_boxes end,
		get_inactive_bin_boxes = function() return inactive_bin_boxes end,
		get_inactive_transfer_boxes = function() return inactive_transfer_boxes end,
		get_inactive_sell_prices = function() return inactive_sell_prices end,
		get_inactive_buy_prices  = function() return inactive_buy_prices end,
		get_inactive_buy_boxes   = function() return inactive_buy_boxes end,
		get_universal_bin_boxes  = function() return universal_bin_boxes end,
		get_transfer_boxes = function() return transfer_boxes end,
		get_bin_boxes      = function() return bin_boxes end,
		get_pull_boxes     = function() return pull_boxes end,
		get_buy_boxes      = function() return buy_boxes end,
		get_sell_prices    = function() return sell_prices end,
		get_buy_prices     = function() return buy_prices end,
		get_embargoes      = function() return embargoes end,
		get_open_box       = function() return open_box end,
		get_all_boxes      = function() return all_boxes end,
		get_active_forces  = function() return active_forces end,
		get_storages       = function() return storages end,
	})
end

local function link_data()
	mod_data = global.free_market
	bin_boxes = mod_data.bin_boxes
	inactive_bin_boxes = mod_data.inactive_bin_boxes
	universal_bin_boxes = mod_data.universal_bin_boxes
	inactive_universal_bin_boxes = mod_data.universal_inactive_bin_boxes
	pull_boxes = mod_data.pull_boxes
	inactive_universal_transfer_boxes = mod_data.inactive_universal_transfer_boxes
	inactive_transfer_boxes = mod_data.inactive_transfer_boxes
	inactive_buy_boxes = mod_data.inactive_buy_boxes
	universal_transfer_boxes = mod_data.universal_transfer_boxes
	transfer_boxes = mod_data.transfer_boxes
	buy_boxes = mod_data.buy_boxes
	embargoes = mod_data.embargoes
	inactive_sell_prices = mod_data.inactive_sell_prices
	inactive_buy_prices = mod_data.inactive_buy_prices
	sell_prices = mod_data.sell_prices
	buy_prices = mod_data.buy_prices
	item_HUD = mod_data.item_hinter
	open_box = mod_data.open_box
	all_boxes = mod_data.all_boxes
	active_forces = mod_data.active_forces
	default_storage_limit = mod_data.default_storage_limit
	storages_limit = mod_data.storages_limit
	storages = mod_data.storages
end

local function update_global_data()
	global.free_market = global.free_market or {}
	mod_data = global.free_market
	mod_data.item_hinter = mod_data.item_hinter or {}
	mod_data.open_box = {}
	mod_data.active_forces = mod_data.active_forces or {}
	mod_data.bin_boxes = mod_data.bin_boxes or {}
	mod_data.inactive_bin_boxes = mod_data.inactive_bin_boxes or {}
	mod_data.universal_bin_boxes = mod_data.universal_bin_boxes or {}
	mod_data.universal_inactive_bin_boxes = mod_data.universal_inactive_bin_boxes or {}
	mod_data.inactive_universal_transfer_boxes = mod_data.inactive_universal_transfer_boxes or {}
	mod_data.inactive_transfer_boxes = mod_data.inactive_transfer_boxes or {}
	mod_data.inactive_buy_boxes = mod_data.inactive_buy_boxes or {}
	mod_data.universal_transfer_boxes = mod_data.universal_transfer_boxes or {}
	mod_data.transfer_boxes = mod_data.transfer_boxes or {}
	mod_data.pull_boxes = mod_data.pull_boxes or {}
	mod_data.buy_boxes = mod_data.buy_boxes or {}
	mod_data.inactive_sell_prices = mod_data.inactive_sell_prices or {}
	mod_data.inactive_buy_prices = mod_data.inactive_buy_prices or {}
	mod_data.sell_prices = mod_data.sell_prices or {}
	mod_data.buy_prices = mod_data.buy_prices or {}
	mod_data.embargoes = mod_data.embargoes or {}
	mod_data.all_boxes = mod_data.all_boxes or {}
	mod_data.default_storage_limit = mod_data.default_storage_limit or {}
	mod_data.storages_limit = mod_data.storages_limit or {}
	mod_data.storages = mod_data.storages or {}

	link_data()

	clear_invalid_entities()
	clear_invalid_prices(storages_limit) -- it works, so it's fine
	clear_invalid_prices(inactive_sell_prices)
	clear_invalid_prices(inactive_buy_prices)
	clear_invalid_prices(sell_prices)
	clear_invalid_prices(buy_prices)
	clear_invalid_embargoes()
	clear_invalid_player_data()

	for item_name, item in pairs(game.item_prototypes) do
		if item.stack_size <= 5 then
			for _, f_storage_limit in pairs(storages_limit) do
				f_storage_limit[item_name] = f_storage_limit[item_name] or 1
			end
		end
	end

	init_force_data(game.forces.player.index)

	for _, force in pairs(game.forces) do
		if #force.players > 0 then
			init_force_data(force.index)
		end
	end


	for _, player in pairs(game.players) do
		if player.valid then
			local relative = player.gui.relative
			if relative.FM_buttons == nil then
				create_left_relative_gui(player)
			end
			if relative.FM_boxes_frame == nil then
				create_top_relative_gui(player)
			end
		end
	end
end

local function on_configuration_changed(event)
	update_global_data()

	local mod_changes = event.mod_changes["iFreeMarket"]
	if not (mod_changes and mod_changes.old_version) then return end

	local version = tonumber(string.gmatch(mod_changes.old_version, "%d+.%d+")())

	if version < 0.34 then
		for _, force in pairs(game.forces) do
			local index = force.index
			if sell_prices[index] then
				init_force_data(index)
			end
		end

		for _, player in pairs(game.players) do
			if player.valid then
				create_top_relative_gui(player)
			end
		end
	end

	if version < 0.33 then
		for _, force in pairs(game.forces) do
			local index = force.index
			-- sell_boxes -> transfer_boxes
			if sell_prices[index] and mod_data.sell_boxex then
				transfer_boxes[index] = mod_data.sell_boxes[index]
				inactive_transfer_boxes[index] = mod_data.inactive_sell_boxes[index]
			end
			mod_data.sell_boxes = nil
			mod_data.inactive_sell_boxes = nil
		end

		local sprite_data = {
			target_offset = BOX_TYPE_SPRITE_OFFSET,
			only_in_alt_mode = true,
			x_scale = 0.4, y_scale = 0.4
		}
		for  _, box_data in pairs(all_boxes) do
			rendering_destroy(box_data[2])

			local entity = box_data[1]
			sprite_data.target = entity
			sprite_data.surface = entity.surface
			if is_public_titles == false then
				sprite_data.forces = {entity.force}
			end

			local box_type = box_data[3]
			if box_type == SELL_TYPE then
				box_data[3] = TRANSFER_TYPE
				sprite_data.sprite = "FM_transfer"
			elseif box_type == PULL_TYPE then
				sprite_data.sprite = "FM_pull_out"
			elseif box_type == BUY_TYPE then
				sprite_data.sprite = "FM_buy"
			end

			box_data[2] = draw_sprite(sprite_data)
		end

		for _, player in pairs(game.players) do
			if player.valid then
				create_top_relative_gui(player)
			end
		end
	end

	if version < 0.32 then
		for _, force in pairs(game.forces) do
			local index = force.index
			if transfer_boxes[index] then
				init_force_data(index)
				default_storage_limit[index] = max_storage_threshold
			end
		end
	end

	if version < 0.31 then
		for _, player in pairs(game.players) do
			if player.valid then
				delete_item_price_HUD(player)
				if player.connected then
					create_item_price_HUD(player)
				end
			end
		end
	end

	if version < 0.30 then
		for _, player in pairs(game.players) do
			if player.valid then
				local screen = player.gui.screen
				local frame = screen.FM_prices_frame
				if frame then
					frame.destroy()
				end
			end
		end
	end

	if version < 0.29 then
		for _, player in pairs(game.players) do
			if player.valid then
				local screen = player.gui.screen
				if screen.FM_sell_prices_frame then
					screen.FM_sell_prices_frame.destroy()
				end
				if screen.FM_buy_prices_frame then
					screen.FM_buy_prices_frame.destroy()
				end
				switch_buy_prices_gui(player)
				switch_sell_prices_gui(player)
			end
		end
	end

	if version < 0.28 then
		for _, player in pairs(game.players) do
			if player.valid and player.mod_settings["FM_show_item_price"].value then
				create_item_price_HUD(player)
			end
		end
	end

	if version < 0.21 then
		for _, player in pairs(game.players) do
			if player.valid then
				create_top_relative_gui(player)
			end
		end
	end

	if version < 0.22 then
		for _, player in pairs(game.players) do
			if player.valid then
				create_left_relative_gui(player)
			end
		end
	end

	if version < 0.26 then
		for _, player in pairs(game.players) do
			if player.valid then
				switch_sell_prices_gui(player)
				switch_buy_prices_gui(player)
			end
		end
		game.print({'', {"mod-name.free-market"}, COLON, " added price notification with settings"})
	end
end

do
	local function set_filters()
		local filters = {
			{filter = "type", mode = "or", type = "container"},
			{filter = "type", mode = "or", type = "logistic-container"},
		}
		script.set_event_filter(defines.events.on_entity_died, filters)
		script.set_event_filter(defines.events.on_robot_mined_entity, filters)
		script.set_event_filter(defines.events.script_raised_destroy, filters)
		script.set_event_filter(defines.events.on_player_mined_entity, filters)
	end

	M.on_load = function()
		link_data()
		set_filters()
	end
	M.on_init = function()
		update_global_data()
		set_filters()
	end
end
M.on_configuration_changed = on_configuration_changed
M.add_remote_interface = add_remote_interface

--#endregion


M.events = {
	[defines.events.on_surface_deleted] = clear_invalid_entities,
	[defines.events.on_surface_cleared] = clear_invalid_entities,
	[defines.events.on_chunk_deleted] = clear_invalid_entities,
	[defines.events.on_player_created] = on_player_created,
	[defines.events.on_player_joined_game] = on_player_joined_game,
	[defines.events.on_player_left_game] = on_player_left_game,
	[defines.events.on_player_cursor_stack_changed] = function(event)
		pcall(on_player_cursor_stack_changed, event) -- TODO: recheck
	end,
	[defines.events.on_player_removed] = delete_player_data,
	[defines.events.on_player_changed_force] = on_player_changed_force,
	[defines.events.on_player_changed_surface] = on_player_changed_surface,
	[defines.events.on_player_selected_area] = on_player_selected_area,
	[defines.events.on_player_alt_selected_area] = on_player_alt_selected_area,
	[defines.events.on_player_mined_entity] = clear_box_data,
	[defines.events.on_gui_selection_state_changed] = on_gui_selection_state_changed,
	[defines.events.on_gui_elem_changed] = on_gui_elem_changed,
	[defines.events.on_gui_click] = function(event)
		on_gui_click(event)
	end,
	[defines.events.on_gui_closed] = on_gui_closed,
	[defines.events.on_selected_entity_changed] = on_selected_entity_changed,
	[defines.events.on_force_created] = on_force_created,
	[defines.events.on_forces_merging] = on_forces_merging,
	[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed,
	[defines.events.on_force_cease_fire_changed] = function(event)
		-- TODO: refactor
		if is_auto_embargo then
			pcall(on_force_cease_fire_changed, event)
		end
	end,
	[defines.events.on_robot_mined_entity] = clear_box_data,
	[defines.events.script_raised_destroy] = clear_box_data,
	[defines.events.on_entity_died] = clear_box_data,
	["FM_set-pull-box"] = function(event)
		pcall(set_pull_box_key_pressed, event)
	end,
	["FM_set-transfer-box"] = function(event)
		pcall(set_transfer_box_key_pressed, event)
	end,
	["FM_set-universal-transfer-box"] = function(event)
		pcall(set_universal_transfer_box_key_pressed, event)
	end,
	["FM_set-bin-box"] = function(event)
		pcall(set_bin_box_key_pressed, event)
	end,
	["FM_set-universal-bin-box"] = function(event)
		pcall(set_universal_bin_box_key_pressed, event)
	end,
	["FM_set-buy-box"] = function(event)
		pcall(set_buy_box_key_pressed, event)
	end
}

M.on_nth_tick = {
	[update_buy_tick] = check_buy_boxes,
	[update_transfer_tick] = check_transfer_boxes,
	[update_pull_tick] = check_pull_boxes,
	[CHECK_FORCES_TICK] = check_forces,
	[CHECK_TEAMS_DATA_TICK] = check_teams_data
}

M.commands = {
	embargo = function(cmd)
		open_embargo_gui(game.get_player(cmd.player_index))
	end,
	prices = function(cmd)
		switch_prices_gui(game.get_player(cmd.player_index))
	end,
	price_list = function(cmd)
		open_price_list_gui(game.get_player(cmd.player_index))
	end,
	storage = function(cmd)
		open_storage_gui(game.get_player(cmd.player_index))
	end,
}


return M
