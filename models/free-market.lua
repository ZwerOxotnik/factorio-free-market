---@class FreeMarket : module
local M = {}


--#region Global data
---@type table<string, table>
local mod_data
---@type table<number, table>
local embargoes
---@type table<number, table>
local sell_prices
---@type table<number, table>
local buy_prices
---@type table<number, table>
local sell_boxes
---@type table<number, table>
local buy_boxes
---@type table<number, table>
local open_box
---@type table<number, table>
local all_boxes
---@type table<number, number>
local active_forces
--#endregion


--#region Constants
local floor = math.floor
local remove = table.remove
local sub = string.sub
local call = remote.call
local draw_text = rendering.draw_text
local CHECK_FORCES_TICK = 3600
local WHITE_COLOR = {1, 1, 1}
local RED_COLOR = {1, 0, 0}
local GREEN_COLOR = {0, 1, 0}
local TEXT_OFFSET = {0, 0.3}
local BUYING_TEXT = {"free-market.buying"}
local SELLING_TEXT = {"free-market.selling"}
local EMPTY_WIDGET = {type = "empty-widget"}
local ALLOWED_TYPES = {["container"] = true, ["logistic-container"] = true}
local TITLEBAR_FLOW = {type = "flow", style = "flib_titlebar_flow"}
local DRAG_HANDLER = {type = "empty-widget", style = "flib_dialog_footer_drag_handle"}
local CLOSE_BUTTON = {
	hovered_sprite = "utility/close_black",
	clicked_sprite = "utility/close_black",
	sprite = "utility/close_white",
	style = "frame_action_button",
	type = "sprite-button",
	name = "FM_close"
}
--#endregion


--#region Settings
local update_tick = settings.global["FM_update-tick"].value
local is_auto_embargo = settings.global["FM_enable-auto-embargo"].value
local money_treshold = settings.global["FM_money-treshold"].value
local minimal_price = settings.global["FM_minimal-price"].value
local maximal_price = settings.global["FM_maximal-price"].value
local is_public_titles = settings.global["FM_is-public-titles"].value
--#endregion


--#region utils

---@param t? table
---@return boolean
local function is_empty(t)
	return next(t) == nil
end

---@param entity LuaEntity
---@param item_name string
---@return number?
local function find_sell_box_data_by_item_name(entity, item_name)
	local entities = sell_boxes[entity.force.index][item_name]
	if entities == nil then return end

	for k, _entity in pairs(entities) do
		if _entity == entity then
			return k
		end
	end
end

---@param entity LuaEntity
---@return string? #item name
local function find_sell_box_data(entity)
	for item_name, data in pairs(sell_boxes[entity.force.index]) do
		for _, _entity in pairs(data) do
			if _entity == entity then
				return item_name
			end
		end
	end
end

---@param entity LuaEntity
---@return string? #item name
---@return number? #count
local function find_buy_box_data(entity)
	for item_name, entities in pairs(buy_boxes[entity.force.index]) do
		for _, buy_box in pairs(entities) do
			if buy_box[1] == entity then
				return item_name, buy_box[2]
			end
		end
	end
end

---@param entity LuaEntity
---@param item_name string
local function remove_certain_sell_box(entity, item_name)
	local data = sell_boxes[entity.force.index][item_name]
	for k, _entity in pairs(data) do
		if _entity == entity then
			remove(data, k)
			if #data == 0 then
				sell_boxes[entity.force.index][item_name] = nil
			end
			return
		end
	end
end

---@param entity LuaEntity
---@param item_name string
local function remove_certain_buy_box(entity, item_name)
	local data = buy_boxes[entity.force.index][item_name]
	for k, buy_box in pairs(data) do
		if buy_box[1] == entity then
			remove(data, k)
			if #data == 0 then
				buy_boxes[entity.force.index][item_name] = nil
			end
			return
		end
	end
end

---@param entity LuaEntity
---@param item_name string
---@param count number
local function change_count_in_buy_box_data(entity, item_name, count)
	local data = buy_boxes[entity.force.index][item_name]
	for _, buy_box in pairs(data) do
		if buy_box[1] == entity then
			buy_box[2] = count
			return
		end
	end
end

---@param entity LuaEntity
---@return boolean?
local function find_clear_sell_box_data(entity)
	for _, data in pairs(sell_boxes[entity.force.index]) do
		for k, _entity in pairs(data) do
			if _entity == entity then
				remove(data, k)
				return true
			end
		end
	end
end

---@param entity LuaEntity
---@return boolean?
local function find_clear_buy_box_data(entity)
	for _, entities in pairs(buy_boxes[entity.force.index]) do
		for k, buy_box in pairs(entities) do
			if buy_box[1] == entity then
				remove(entities, k)
				return true
			end
		end
	end
end

---@param entity LuaEntity
---@return boolean
local function find_clear_box_data(entity)
	if find_clear_sell_box_data(entity) then
		return true
	elseif find_clear_buy_box_data(entity) then
		return true
	else
		return false
	end
end

local function clear_invalid_embargoes()
	for index in pairs(embargoes) do
		if game.forces[index] == nil then
			embargoes[index] = nil
		end
	end
	for _, forces_data in pairs(embargoes) do
		for index in pairs(forces_data) do
			if type(index) == "table" then -- TODO: change this
				forces_data[index] = nil
			elseif game.forces[index] == nil then
				forces_data[index] = nil
			end
		end
	end
end

---@param item_name string
---@param player PlayerIdentification
---@param entity LuaEntity
local function set_sell_box_data(item_name, player, entity)
	local force_sell_boxes = sell_boxes[player.force.index]
	force_sell_boxes[item_name] = force_sell_boxes[item_name] or {}
	table.insert(force_sell_boxes[item_name], entity)
	local text_data = {
		text = SELLING_TEXT,
		vertical_alignment = "middle",
		surface = player.surface,
		scale_with_zoom = false,
		only_in_alt_mode = true,
		alignment = "center",
		color = GREEN_COLOR,
		target = entity,
		target_offset = TEXT_OFFSET,
		scale = 0.7,
	}
	if is_public_titles == false then
		text_data.forces = {player.force}
	end
	local id = draw_text(text_data)
	all_boxes[entity.unit_number] = {entity, id}
end

---@param item_name string
---@param player PlayerIdentification
---@param entity LuaEntity
---@param count? number
local function set_buy_box_data(item_name, player, entity, count)
	count = count or game.item_prototypes[item_name].stack_size

	local force_buy_boxes = buy_boxes[player.force.index]
	force_buy_boxes[item_name] = force_buy_boxes[item_name] or {}
	table.insert(force_buy_boxes[item_name], {entity, count})
	local text_data = {
		text = BUYING_TEXT,
		vertical_alignment = "middle",
		surface = player.surface,
		scale_with_zoom = false,
		only_in_alt_mode = true,
		alignment = "center",
		color = RED_COLOR,
		target = entity,
		target_offset = TEXT_OFFSET,
		scale = 0.7,
	}
	if is_public_titles == false then
		text_data.forces = {player.force}
	end
	local id = draw_text(text_data)
	all_boxes[entity.unit_number] = {entity, id}
end

local function clear_invalid_prices(prices)
	for index, forces_data in pairs(prices) do
		if game.forces[index] == nil then
			sell_prices[index] = nil
			buy_prices[index] = nil
		else
			for item_name in pairs(forces_data) do
				if game.item_prototypes[item_name] == nil then
					forces_data[item_name] = nil
				end
			end
		end
	end
end

local function clear_invalid_sell_boxes_data()
	for index, data in pairs(sell_boxes) do
		if game.forces[index] == nil then
			sell_boxes[index] = nil
			buy_boxes[index] = nil
			embargoes[index] = nil
			sell_prices[index] = nil
			buy_prices[index] = nil
		else
			for item_name, entities in pairs(data) do
				if game.item_prototypes[item_name] == nil then
					data[item_name] = nil
				else
					for i=#entities, 1, -1 do
						if entities[i].valid == false then
							remove(entities, i)
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

local function clear_invalid_buy_boxes_data()
	for index, data in pairs(buy_boxes) do
		if game.forces[index] == nil then
			buy_boxes[index] = nil
			sell_boxes[index] = nil
			embargoes[index] = nil
			sell_prices[index] = nil
			buy_prices[index] = nil
		else
			for item_name, entities in pairs(data) do
				if game.item_prototypes[item_name] == nil then
					data[item_name] = nil
				else
					for i=#entities, 1, -1 do
						if entities[i][1].valid == false then
							remove(entities, i)
						elseif not entities[i][2] then
							remove(entities, i)
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

local function clear_invalid_entities()
	clear_invalid_sell_boxes_data()
	clear_invalid_buy_boxes_data()

	for unit_number, data in pairs(all_boxes) do
		if data[1].valid == false then
			-- rendering.destroy(data[2])
			all_boxes[unit_number] = nil
		-- else
				-- WIP
		end
	end
end

local function get_distance(start, stop)
	local xdiff = start.x - stop.x
	local ydiff = start.y - stop.y
	return (xdiff * xdiff + ydiff * ydiff)^0.5
end

local function delete_player_data(event)
	open_box[event.player_index] = nil
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

	local label_data = {type = "label", caption = {"team-name"}}
	table.add(label_data)
	label_data.caption = {"free-market.buy-header"}
	table.add(label_data)
	label_data.caption = {"free-market.sell-header"}
	table.add(label_data)
end

local function make_price_list_header(table)
	local dummy
	local dummy_data = {type = "empty-widget"}
	for _=1, 2, 1 do
		dummy = table.add(dummy_data)
		dummy.style.horizontally_stretchable = true
		dummy.style.minimal_width = 30
		dummy = table.add(dummy_data)
		dummy.style.horizontally_stretchable = true
		dummy.style.minimal_width = 60
		dummy = table.add(dummy_data)
		dummy.style.horizontally_stretchable = true
		dummy.style.minimal_width = 60
	end

	local label_data = {type = "label"}

	for _=1, 2, 1 do
		label_data.caption = {"item"}
		table.add(label_data)
		label_data.caption = {"free-market.buy-header"}
		table.add(label_data)
		label_data.caption = {"free-market.sell-header"}
		table.add(label_data)
	end
end

---@param player PlayerIdentification
---@param item_name string
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

	local label = {type = "label"}
	for _, data in pairs(result) do
		if data.buy_price or data.sell_price then
			label.caption = data.name
			table_element.add(label)
			label.caption = (data.buy_price or '')
			table_element.add(label)
			label.caption = (data.sell_price or '')
			table_element.add(label)
		end
	end
end

local function update_price_list_table(force, table)
	table.clear()
	make_price_list_header(table)
	local force_index = force.index
	local f_buy_prices = buy_prices[force_index] or {}
	local f_sell_prices = sell_prices[force_index] or {}

	local label = {type = "label"}
	local button = {type = "sprite-button"}
	for item_name, buy_price in pairs(f_buy_prices) do
		table.add(button).sprite = "item/" .. item_name
		label.caption = buy_price
		table.add(label)
		label.caption = (f_sell_prices[item_name] or '')
		table.add(label)
	end

	local empty_label = {type = "label"}
	for item_name, sell_price in pairs(f_sell_prices) do
		if f_buy_prices[item_name] == nil then
			table.add(button).sprite = "item/" .. item_name
			table.add(empty_label)
			label.caption = sell_price
			table.add(label)
		end
	end
end

local function destroy_prices_gui(player)
	local screen = player.gui.screen
	if screen.FM_prices_frame then
		screen.FM_prices_frame.destroy()
	end
end

local function destroy_price_list_gui(player)
	local screen = player.gui.screen
	if screen.FM_price_list_frame then
		screen.FM_price_list_frame.destroy()
	end
end

local function update_embargo_table(embargo_table, player)
	embargo_table.clear()

	embargo_table.add{type = "label", caption = {"free-market.without-embargo-title"}}
	embargo_table.add(EMPTY_WIDGET)
	embargo_table.add{type = "label", caption = {"free-market.with-embargo-title"}}

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
	local buttons_flow = embargo_table.add{type = "flow", direction = "vertical"}
	buttons_flow.add{type = "sprite-button", name = "FM_cancel_embargo", style = "tool_button", sprite = "utility/left_arrow"}
	buttons_flow.add{type = "sprite-button", name = "FM_declare_embargo", style = "tool_button", sprite = "utility/right_arrow"}
	local embargo_list = embargo_table.add{type = "list-box", name = "embargo_list", items = embargoes_items}
	embargo_list.style.horizontally_stretchable = true
	embargo_list.style.height = 200
end

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
	flow.add{type = "label",
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

---@param player PlayerIdentification
---@param item_name? string
local function open_prices_gui(player, item_name)
	local screen = player.gui.screen
	if screen.FM_prices_frame then
		screen.FM_prices_frame.destroy()
		return
	end
	local main_frame = screen.add{type = "frame", name = "FM_prices_frame", direction = "vertical"}
	main_frame.style.horizontally_stretchable = true
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{type = "label",
		style = "frame_title",
		caption = {"free-market.prices"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add{type = "sprite-button",
		style = "frame_action_button",
		sprite = "refresh_white_icon",
		name = "FM_refresh_prices_table"
	}
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content.style.padding = 12
	local row = content.add{type = "table", name = "row", column_count = 7}
	-- row.style.horizontally_stretchable = true
	-- row.style.column_alignments[4] = "right"
	-- row.style.column_alignments[5] = "right"
	-- row.style.column_alignments[6] = "right"
	local item = row.add{type = "choose-elem-button", name = "FM_prices_item", elem_type = "item"}
	item.elem_value = item_name
	row.add{type = "label", caption = {"free-market.buy-gui"}}
	local buy_textfield = row.add{type = "textfield", name = "buy_price", numeric = true, allow_decimal = false, allow_negative = false}
	buy_textfield.style.width = 70
	if item_name then
		local price = buy_prices[player.force.index][item_name]
		if price then
			buy_textfield.text = tostring(price)
		end
	end
	row.add{
		type = "sprite-button",
		name = "FM_confirm_buy_price",
		style = "item_and_count_select_confirm",
		sprite = "utility/check_mark"
	}
	row.add{type = "label", caption = {"free-market.sell-gui"}}
	local sell_textfield = row.add{type = "textfield", name = "sell_price", numeric = true, allow_decimal = false, allow_negative = false}
	sell_textfield.style.width = 70
	if item_name then
		local price = sell_prices[player.force.index][item_name]
		if price then
			sell_textfield.text = tostring(price)
		end
	end
	row.add{
		type = "sprite-button",
		name = "FM_confirm_sell_price",
		style = "item_and_count_select_confirm",
		sprite = "utility/check_mark"
	}
	local prices_frame = content.add{type = "frame", name = "other_prices_frame", style = "deep_frame_in_shallow_frame", direction = "vertical"}
	local scroll_pane = prices_frame.add{
		type = "scroll-pane",
		name = "scroll-pane",
		horizontal_scroll_policy = "never"
	}
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
	main_frame.force_auto_center()
	return content
end

local function open_price_list_gui(player)
	local screen = player.gui.screen
	if screen.FM_price_list_frame then
		screen.FM_price_list_frame.destroy()
		return
	end
	local main_frame = screen.add{type = "frame", name = "FM_price_list_frame", direction = "vertical"}
	main_frame.style.horizontally_stretchable = true
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{type = "label",
		style = "frame_title",
		caption = {"free-market.price-list"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local content = shallow_frame.add{type = "flow", name = "content_flow", direction = "vertical"}
	content.style.padding = 12
	local row = content.add{type = "table", name = "row", column_count = 2}
	row.add{type = "label", caption = {'', {"team"}, {"colon"}}}
	local items = {}
	local size = 0
	for force_name, force in pairs(game.forces) do
		local force_index = force.index
		local f_sell_prices = sell_prices[force_index]
		local f_buy_prices = buy_prices[force_index]
		if (f_sell_prices and not is_empty(f_sell_prices)) or (f_buy_prices and not is_empty(f_buy_prices)) then
			size = size + 1
			items[size] = force_name
		end
	end
	row.add{type = "drop-down", name = "FM_force_price_list", items = items}
	local prices_frame = content.add{type = "frame", name = "deep_frame", style = "deep_frame_in_shallow_frame", direction = "vertical"}
	local scroll_pane = prices_frame.add{
		type = "scroll-pane",
		name = "scroll-pane",
		horizontal_scroll_policy = "never"
	}
	scroll_pane.style.padding = 12
	local prices_table = scroll_pane.add{type = "table", name = "price_list_table", column_count = 6}
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
	main_frame.force_auto_center()
end

---@param player PlayerIdentification
---@param is_new boolean# Is new buy box?
---@param entity? LuaEntity # The buy box when is_new = true
local function open_buy_box_gui(player, is_new, entity)
	local screen = player.gui.screen
	if screen.FM_buy_box_frame then
		screen.FM_buy_box_frame.destroy()
		return
	end
	if screen.FM_sell_box_frame then
		screen.FM_sell_box_frame.destroy()
	end
	local main_frame = screen.add{type = "frame", name = "FM_buy_box_frame", direction = "vertical"}
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{type = "label",
		style = "frame_title",
		caption = {"free-market.buy-request-gui"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", name = "shallow_frame", style = "inside_shallow_frame", direction = "vertical"}
	local row = shallow_frame.add{type = "table", name = "content_row", column_count = 4}
	row.style.padding = 12
	local FM_item = row.add{type = "choose-elem-button", name = "FM_item", elem_type = "item"}
	row.add{type = "label", caption = {'', {"free-market.count-gui"}, {"colon"}}}
	local count_element = row.add{type = "textfield", name = "count", numeric = true, allow_decimal = false, allow_negative = false}
	count_element.style.width = 70
	local confirm_button = row.add{
		type = "sprite-button",
		style = "item_and_count_select_confirm",
		sprite = "utility/check_mark"
	}
	if is_new then
		confirm_button.name = "FM_confirm_buy_box"
	else
		confirm_button.name = "FM_change_buy_box"
		local item_name, count = find_buy_box_data(entity)
		count_element.text = tostring(count or '')
		FM_item.elem_value = item_name
		row.add{type = "label", visible = false, name = "prev_item", caption = item_name}
	end
	main_frame.force_auto_center()
end

local function destroy_boxes_gui(player)
	local screen = player.gui.screen
	if screen.FM_sell_box_frame then
		screen.FM_sell_box_frame.destroy()
	end
	if screen.FM_buy_box_frame then
		screen.FM_buy_box_frame.destroy()
	end
	open_box[player.index] = nil
end

---@param player PlayerIdentification
---@param is_new boolean # Is new sell box?
---@param entity? LuaEntity # The sell box when is_new = true
local function open_sell_box_gui(player, is_new, entity)
	local screen = player.gui.screen
	if screen.FM_sell_box_frame then
		screen.FM_sell_box_frame.destroy()
		return
	end
	if screen.FM_buy_box_frame then
		screen.FM_buy_box_frame.destroy()
	end
	local main_frame = screen.add{type = "frame", name = "FM_sell_box_frame", direction = "vertical"}
	main_frame.style.minimal_width = 210
	local flow = main_frame.add(TITLEBAR_FLOW)
	flow.add{
		type = "label",
		style = "frame_title",
		caption = {"free-market.sell-offer-gui"},
		ignored_by_interaction = true
	}
	flow.add(DRAG_HANDLER).drag_target = main_frame
	flow.add(CLOSE_BUTTON)
	local shallow_frame = main_frame.add{type = "frame", style = "inside_shallow_frame", direction = "vertical"}
	local row = shallow_frame.add{type = "table", column_count = 2}
	row.style.padding = 12
	local FM_item = row.add{type = "choose-elem-button", name = "FM_item", elem_type = "item"}
	local confirm_button = row.add{
		type = "sprite-button",
		style = "item_and_count_select_confirm",
		sprite = "utility/check_mark"
	}
	if is_new then
		confirm_button.name = "FM_confirm_sell_box"
	else
		confirm_button.name = "FM_change_sell_box"
		FM_item.elem_value = find_sell_box_data(entity)
		row.add{type = "label", visible = false, name = "prev_item", caption = FM_item.elem_value}
	end
	main_frame.force_auto_center()
end

---@param index number
local function remove_index_among_embargoes(index)
	embargoes[index] = nil
	for _, data in pairs(embargoes) do
		data[index] = nil
	end
end

local bold_font_color = {255, 230, 192}
local top_anchor = {gui = defines.relative_gui_type.container_gui, position = defines.relative_gui_position.top}
local function create_top_relative_gui(player)
	local relative = player.gui.relative
	if relative.FM_boxes_frame then
		relative.FM_boxes_frame.destroy()
	end
	local main_frame = relative.add{type = "frame", name = "FM_boxes_frame", anchor = top_anchor}
	main_frame.style.vertical_align = "center"
	main_frame.style.horizontally_stretchable = false
	main_frame.style.bottom_margin = -14
	local frame = main_frame.add{type = "frame", name = "content", style = "inside_shallow_frame"}
	local buy_button = frame.add{type = "button", style="slot_button", name = "FM_set_buy_box", caption = {"free-market.buy-gui"}}
	buy_button.style.font_color = bold_font_color
	buy_button.style.right_margin = -6
	local sell_button = frame.add{type = "button", style="slot_button", name = "FM_set_sell_box", caption = {"free-market.sell-gui"}}
	sell_button.style.font_color = bold_font_color
end

local left_anchor = {gui = defines.relative_gui_type.controller_gui, position = defines.relative_gui_position.left}
local function create_left_relative_gui(player)
	local relative = player.gui.relative
	if relative.FM_buttons then
		relative.FM_buttons.destroy()
	end
	local main_table = relative.add{type = "table", name = "FM_buttons", anchor = left_anchor, column_count = 2}
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
	local table = shallow_frame.add{type = "table", column_count = 2}
	table.style.horizontal_spacing = 0
	table.style.vertical_spacing = 0
	table.add{type = "sprite-button", sprite = "FM_change-price", style="slot_button", name = "FM_change-price"}
	table.add{type = "sprite-button", sprite = "FM_see-prices", style="slot_button", name = "FM_see-prices"}
	table.add{type = "sprite-button", sprite = "FM_embargo", style="slot_button", name = "FM_embargo"}
	table.add{type = "sprite-button", sprite = "info", style = "slot_button", name = "FM_show_hint"}
end

---@param player PlayerIdentification
---@param item_name string
local function check_buy_price(player, item_name)
	local force_index = player.force.index
	if buy_prices[force_index][item_name] == nil then
		local prices_frame = player.gui.screen.FM_prices_frame
		local content_flow
		if prices_frame == nil then
			content_flow = open_prices_gui(player, item_name)
			prices_frame = player.gui.screen.FM_prices_frame
		else
			content_flow = prices_frame.shallow_frame.content_flow
			content_flow.row.FM_prices_item.elem_value = item_name
			local sell_price = sell_prices[force_index][item_name]
			if sell_price then
				content_flow.row.sell_price.text = tostring(sell_price)
			end
			update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
		end
		content_flow.row.buy_price.focus()
	end
end

---@param player PlayerIdentification
---@param item_name string
local function check_sell_price(player, item_name)
	local force_index = player.force.index
	if sell_prices[force_index][item_name] == nil then
		local prices_frame = player.gui.screen.FM_prices_frame
		local content_flow
		if prices_frame == nil then
			content_flow = open_prices_gui(player, item_name)
			prices_frame = player.gui.screen.FM_prices_frame
		else
			content_flow = prices_frame.shallow_frame.content_flow
			content_flow.row.FM_prices_item.elem_value = item_name
			local buy_price = buy_prices[force_index][item_name]
			if buy_price then
				content_flow.row.buy_price.text = tostring(buy_price)
			end
			update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
		end
		content_flow.row.sell_price.focus()
	end
end

--#endregion


--#region Functions of events

local function clear_box_data(event)
	if all_boxes[event.entity.unit_number] == nil then return end

	local entity = event.entity
	local unit_number = entity.unit_number
	-- rendering.destroy(all_boxes[unit_number][2])
	find_clear_box_data(entity)
	all_boxes[unit_number] = nil
end

local function on_player_created(event)
	local player = game.get_player(event.player_index)
	create_top_relative_gui(player)
	create_left_relative_gui(player)
end

-- check
local function on_player_joined_game(event)
	local player_index = event.player_index
	open_box[player_index] = nil
	local player = game.get_player(player_index)
	destroy_boxes_gui(player)
	destroy_prices_gui(player)
	destroy_price_list_gui(player)
end

local function on_force_created(event)
	local index = event.force.index
	sell_boxes[index] = {}
	buy_boxes[index] = {}
	embargoes[index] = {}
	sell_prices[index] = {}
	buy_prices[index] = {}
end

local function check_forces()
	local forces_money = call("EasyAPI", "get_forces_money")

	mod_data.active_forces = {}
	active_forces = mod_data.active_forces
	local size = 0
	for _, force in pairs(game.forces) do
		local force_index = force.index
		local items_data = buy_boxes[force_index]
		if items_data then
			local buyer_money = forces_money[force_index]
			if buyer_money and buyer_money > money_treshold then
				size = size + 1
				active_forces[size] = force_index
			end
		end
	end
end

local function on_forces_merging(event)
	local source = event.source
	local source_index = source.index
	sell_prices[source_index] = nil
	buy_prices[source_index] = nil
	sell_boxes[source_index] = nil
	buy_boxes[source_index] = nil
	remove_index_among_embargoes(source_index)

	local get_target = rendering.get_target
	local is_valid = rendering.is_valid
	local destroy = rendering.destroy
	for _, id in pairs(rendering.get_all_ids()) do
		if is_valid(id) then
			local entity = get_target(id).entity
			if not (entity and entity.valid) or entity.force == source then
				all_boxes[entity.unit_number] = nil
				destroy(id)
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

local function set_sell_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end

	local item_name = find_sell_box_data(entity)
	if item_name then
		check_sell_price(player, item_name)
		return
	end
	item_name = find_buy_box_data(entity)
	if item_name then
		check_buy_price(player, item_name)
		return
	end

	local item = entity.get_inventory(defines.inventory.chest)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_sell_box_data(item.name, player, entity)
end

local function set_buy_box_key_pressed(event)
	local player = game.get_player(event.player_index)
	local entity = player.selected
	if not entity.operable then return end
	if not ALLOWED_TYPES[entity.type] then return end
	if get_distance(player.position, entity.position) > 30 then return end

	local item_name = find_sell_box_data(entity)
	if item_name then
		check_sell_price(player, item_name)
		return
	end
	item_name = find_buy_box_data(entity)
	if item_name then
		check_buy_price(player, item_name)
		return
	end

	local item = entity.get_inventory(defines.inventory.chest)[1]
	if not item.valid_for_read then
		player.print({"multiplayer.no-address", {"item"}})
		return
	end

	set_buy_box_data(item.name, player, entity)
end

local function on_gui_elem_changed(event)
	local element = event.element
	if element.name ~= "FM_prices_item" then return end

	local player = game.get_player(event.player_index)
	local parent = element.parent
	local item_name = element.elem_value
	if item_name == nil then
		parent.sell_price.text = ''
		parent.buy_price.text = ''
		local prices_table = parent.parent.other_prices_frame["scroll-pane"].prices_table
		prices_table.clear()
		make_prices_header(prices_table)
		return
	end

	local force_index = player.force.index
	parent.sell_price.text = tostring(sell_prices[force_index][item_name] or '')
	parent.buy_price.text = tostring(buy_prices[force_index][item_name] or '')
	update_prices_table(player, item_name, parent.parent.other_prices_frame["scroll-pane"].prices_table)
end

local function on_gui_selection_state_changed(event)
	local element = event.element
	if element.name ~= "FM_force_price_list" then return end

	local parent = element.parent
	local force = game.forces[element.items[element.selected_index]]
	if force == nil then
		local price_list_table = parent.parent.deep_frame["scroll-pane"].price_list_table
		price_list_table.clear()
		make_price_list_header(price_list_table)
		return
	end

	update_price_list_table(force, parent.parent.deep_frame["scroll-pane"].price_list_table)
end


local GUIS = {
	FM_close = function(element)
		element.parent.parent.destroy()
	end,
	FM_confirm_buy_box = function(element, player)
		local count = tonumber(element.parent.count.text)
		if not count then
			player.print({"multiplayer.no-address", {"gui-train.add-item-count-condition"}})
			return
		elseif count < 1 then
			player.print({"count-must-be-more-n", 0})
			return
		end

		local item_name = element.parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local player_index = player.index
		local entity = open_box[player_index]
		if entity then
			local inventory_size = #entity.get_inventory(defines.inventory.chest)
			local max_count = game.item_prototypes[item_name].stack_size * inventory_size
			if count > max_count then
				player.print({"gui-map-generator.invalid-value-for-field", count, 1, max_count})
				element.parent.count.text = tostring(max_count)
				return
			end

			set_buy_box_data(item_name, player, entity, count)
			check_buy_price(player, item_name)
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		player.gui.screen.FM_buy_box_frame.destroy()
	end,
	FM_confirm_sell_box = function(element, player)
		local item_name = element.parent.FM_item.elem_value
		if not item_name then
			player.print({"multiplayer.no-address", {"item"}})
			return
		end

		local player_index = player.index

		local entity = open_box[player_index]
		if entity then
			set_sell_box_data(item_name, player, entity)
			check_sell_price(player, item_name)
		else
			player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
		end
		open_box[player_index] = nil
		player.gui.screen.FM_sell_box_frame.destroy()
	end,
	FM_change_sell_box = function(element, player)
		local parent = element.parent
		local prev_item_name = parent.prev_item.caption
		local player_index = player.index
		local entity = open_box[player_index]
		local item_name = parent.FM_item.elem_value
		if item_name then
			if entity then
				local key = find_sell_box_data_by_item_name(entity, prev_item_name)
				if key then
					local force_sell_boxes = sell_boxes[player.force.index]
					force_sell_boxes[item_name] = force_sell_boxes[item_name] or {}
					table.remove(force_sell_boxes[prev_item_name], key)
					if #force_sell_boxes[prev_item_name] then
						force_sell_boxes[prev_item_name] = nil
					end
					table.insert(force_sell_boxes[item_name], entity)
				else
					player.print({"gui-train.invalid"})
				end
			else
				player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
			end
		else
			remove_certain_sell_box(entity, prev_item_name)
			local unit_number = entity.unit_number
			rendering.destroy(all_boxes[unit_number][2])
			all_boxes[unit_number] = nil
		end
		open_box[player_index] = nil
		player.gui.screen.FM_sell_box_frame.destroy()
	end,
	FM_change_buy_box = function(element, player)
		local parent = element.parent
		local prev_item_name = parent.prev_item.caption
		local player_index = player.index
		local entity = open_box[player_index]
		local count = tonumber(parent.count.text)
		local item_name = parent.FM_item.elem_value
		if item_name then
			if entity then
				if prev_item_name == item_name then
					change_count_in_buy_box_data(entity, item_name, count)
				else
					local force_buy_boxes = buy_boxes[player.force.index]
					force_buy_boxes[item_name] = force_buy_boxes[item_name] or {}
					remove_certain_buy_box(entity, prev_item_name)
					table.insert(force_buy_boxes[item_name], {entity, count})
				end
			else
				player.print({"multiplayer.no-address", {"item-name.linked-chest"}})
			end
		else
			remove_certain_buy_box(entity, prev_item_name)
			local unit_number = entity.unit_number
			rendering.destroy(all_boxes[unit_number][2])
			all_boxes[unit_number] = nil
		end
		open_box[player_index] = nil
		player.gui.screen.FM_buy_box_frame.destroy()
	end,
	FM_confirm_sell_price = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_prices_item.elem_value
		if item_name == nil then return end
		local force_index = player.force.index
		local force_sell_prices = sell_prices[force_index]
		local sell_price_element = parent.sell_price
		local sell_price = tonumber(sell_price_element.text)
		if sell_price == nil then
			force_sell_prices[item_name] = nil
			return
		end

		local buy_price = tonumber(buy_prices[force_index][item_name])

		if sell_price < minimal_price or sell_price > maximal_price or (buy_price and sell_price < buy_price) then
			player.print({"gui-map-generator.invalid-value-for-field", sell_price, buy_price or minimal_price, maximal_price})
			sell_price_element.text = tostring(force_sell_prices[item_name] or '')
			return
		end

		force_sell_prices[item_name] = sell_price
	end,
	FM_confirm_buy_price = function(element, player)
		local parent = element.parent
		local item_name = parent.FM_prices_item.elem_value
		if item_name == nil then return end
		local force_index = player.force.index
		local force_buy_prices = buy_prices[force_index]
		local buy_price_element = parent.buy_price
		local buy_price = tonumber(buy_price_element.text)
		if buy_price == nil then
			force_buy_prices[item_name] = nil
			return
		end

		local sell_price = tonumber(sell_prices[force_index][item_name])

		if buy_price < minimal_price or buy_price > maximal_price or (sell_price and sell_price < buy_price) then
			player.print({"gui-map-generator.invalid-value-for-field", buy_price, minimal_price, sell_price or maximal_price})
			buy_price_element.text = tostring(force_buy_prices[item_name] or '')
			return
		end
		force_buy_prices[item_name] = buy_price
	end,
	FM_refresh_prices_table = function(element, player)
		local content_flow = element.parent.parent.shallow_frame.content_flow
		local row = content_flow.row
		local item_name = row.FM_prices_item.elem_value
		if item_name == nil then return end

		local force_index = player.force.index
		row.buy_price.text = tostring(buy_prices[force_index][item_name] or '')
		row.sell_price.text = tostring(sell_prices[force_index][item_name] or '')
		update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
	end,
	FM_set_sell_box = function(element, player)
		local entity = player.opened

		if ALLOWED_TYPES[entity.type] then
			if player.force ~= entity.force then
				player.print({"free-market.you-cant-change"})
				return
			end

			if find_sell_box_data(entity) then
				open_sell_box_gui(player, false, entity)
			elseif find_buy_box_data(entity) then
				player.print({"free-market.this-is-buy-box"})
				return
			else
				local item = entity.get_inventory(defines.inventory.chest)[1]
				if not item.valid_for_read then
					open_sell_box_gui(player, true)
				else
					local item_name = item.name
					set_sell_box_data(item_name, player, entity)
					check_sell_price(player, item_name)
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

			if find_buy_box_data(entity) then
				open_buy_box_gui(player, false, entity)
			elseif find_sell_box_data(entity) then
				player.print({"free-market.this-is-sell-box"})
				return
			else
				local item = entity.get_inventory(defines.inventory.chest)[1]
				if not item.valid_for_read then
					open_buy_box_gui(player, true)
				else
					open_buy_box_gui(player, true)
					local content_row = player.gui.screen.FM_buy_box_frame.shallow_frame.content_row
					local item_name = item.name
					content_row.FM_item.elem_value = item_name
					content_row.count.text = tostring(game.item_prototypes[item_name].stack_size)

					-- TODO: refactor
					local force_index = player.force.index
					if buy_prices[force_index][item_name] == nil then
						local prices_frame = player.gui.screen.FM_prices_frame
						local content_flow
						if prices_frame == nil then
							content_flow = open_prices_gui(player, item_name)
							prices_frame = player.gui.screen.FM_prices_frame
						else
							content_flow = prices_frame.shallow_frame.content_flow
							content_flow.row.FM_prices_item.elem_value = item_name
							local sell_price = sell_prices[force_index][item_name]
							if sell_price then
								content_flow.row.sell_price.text = tostring(sell_price)
							end
							update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
						end
						content_flow.row.buy_price.focus()
					end
				end
			end
			open_box[player.index] = entity
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
	["FM_change-price"] = function(element, player)
		open_prices_gui(player)
	end,
	["FM_see-prices"] = function(element, player)
		open_price_list_gui(player)
	end,
	["FM_embargo"] = function(element, player)
		open_embargo_gui(player)
	end,
	["FM_show_hint"] = function(element, player)
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
	end
}
local function on_gui_click(event)
	local player = game.get_player(event.player_index)
	local element = event.element
	if element.name == '' then
		if element.parent.name == "price_list_table" then
			local item_name = sub(element.sprite, 6)
			local force_index = player.force.index
			local prices_frame = player.gui.screen.FM_prices_frame
			if prices_frame == nil then
				open_prices_gui(player, item_name)
			else
				local content_flow = prices_frame.shallow_frame.content_flow
				content_flow.row.FM_prices_item.elem_value = item_name
				local sell_price = sell_prices[force_index][item_name]
				content_flow.row.sell_price.text = tostring(sell_price or '')
				local buy_price = buy_prices[force_index][item_name]
				content_flow.row.buy_price.text = tostring(buy_price or '')
				update_prices_table(player, item_name, content_flow.other_prices_frame["scroll-pane"].prices_table)
			end
		end
		return
	else
		local f = GUIS[element.name]
		if f then f(element, player) end
	end
end

local function check_buy_boxes()
	local force_index = mod_data.last_buyer_index
	for _, index in pairs(active_forces) do
		if index > force_index then
			force_index = index
			break
		end
	end

	if force_index ~= mod_data.last_buyer_index then
		mod_data.last_buyer_index = force_index
	elseif force_index == 1 then
		return
	else
		force_index = 1
		mod_data.last_buyer_index = 1
	end

	local forces_money = call("EasyAPI", "get_forces_money")
	local forces_money_copy = {}
	for _force_index, value in pairs(forces_money) do
		forces_money_copy[_force_index] = value
	end

	local items_data = buy_boxes[force_index]
	if items_data == nil then return end

	local buyer_money = forces_money_copy[force_index]
	if buyer_money and buyer_money > money_treshold then
		local stack = {name = "", count = 0}
		local f_buy_prices = buy_prices[force_index]
		for item_name, entities in pairs(items_data) do
			if money_treshold >= buyer_money then
				goto not_enough_money
			end
			local buy_price = f_buy_prices[item_name]
			if buy_price and buyer_money >= buy_price then
				for _, buy_data in pairs(entities) do
					local purchasable_count = buyer_money / buy_price
					if purchasable_count < 1 then
						goto skip_buy
					else
						purchasable_count = floor(purchasable_count)
					end
					local buy_box = buy_data[1]
					local need_count = buy_data[2]
					if purchasable_count < need_count then
						need_count = purchasable_count
					end
					local count = buy_box.get_item_count(item_name)
					stack.name = item_name
					if need_count < count then
						stack.count = count
					else
						need_count = need_count - count
						if need_count <= 0 then
							goto skip_buy
						end
						stack.count = need_count
						for other_force_index, _items_data in pairs(sell_boxes) do
							local sell_price = sell_prices[other_force_index][item_name]
							if not (sell_price and buy_price >= sell_price) then
								goto skip_seller
							end
							if force_index ~= other_force_index and forces_money[other_force_index] and not embargoes[other_force_index][force_index] then
								local item_offers = _items_data[item_name]
								if item_offers then
									local seller_money = forces_money_copy[other_force_index]
									for _, sell_box in pairs(item_offers) do
										local removed_count = sell_box.remove_item(stack)
										if removed_count > 0 then
											local amount = removed_count * sell_price
											buyer_money = buyer_money - amount
											seller_money = seller_money + amount
											stack.count = stack.count - removed_count
											if stack.count <= 0 then
												forces_money_copy[other_force_index] = seller_money
												goto fulfilled_needs
											end
										end
									end
									forces_money_copy[other_force_index] = seller_money
								end
							end
							:: skip_seller ::
						end
					end
					:: fulfilled_needs ::
					local found_items = need_count - stack.count
					if found_items > 0 then
						stack.count = found_items
						buy_box.insert(stack)
					end
					:: skip_buy ::
				end
			end
		end
		:: not_enough_money ::
		forces_money_copy[force_index] = buyer_money
	else
		return
	end

	local forces = game.forces
	for _force_index, value in pairs(forces_money_copy) do
		if forces_money[_force_index] ~= value then
			call("EasyAPI", "set_force_money", forces[_force_index], value)
		end
	end
end

-- TODO: update prices
local function on_player_changed_force(event)
	local player = game.get_player(event.player_index)
	destroy_boxes_gui(player)

	local index = player.force.index
	if sell_boxes[index] == nil then
		sell_prices[index] = sell_prices[index] or {}
		sell_boxes[index] = sell_boxes[index] or {}
		buy_prices[index] = buy_prices[index] or {}
		buy_boxes[index] = buy_boxes[index] or {}
		embargoes[index] = embargoes[index] or {}
	end
end

local function on_player_changed_surface(event)
	local player = game.get_player(event.player_index)
	destroy_boxes_gui(player)
end

local function on_player_left_game(event)
	local player = game.get_player(event.player_index)
	destroy_boxes_gui(player)
	destroy_prices_gui(player)
	destroy_price_list_gui(player)
end

local mod_settings = {
	["FM_enable-auto-embargo"] = function(value) is_auto_embargo = value end,
	["FM_is-public-titles"] = function(value) is_public_titles = value end,
	["FM_money-treshold"] = function(value) money_treshold = value end,
	["FM_minimal-price"] = function(value) minimal_price = value end,
	["FM_maximal-price"] = function(value) maximal_price = value end,
	["FM_update-tick"] = function(value)
		if CHECK_FORCES_TICK == value then
			settings.global["FM_update-tick"] = {
				value = value + 1
			}
			return
		end
		script.on_nth_tick(update_tick, nil)
		update_tick = value
		script.on_nth_tick(value, check_buy_boxes)
	end
}
local function on_runtime_mod_setting_changed(event)
	-- if event.setting_type ~= "runtime-global" then return end
	local f = mod_settings[event.setting]
	if f then f(settings.global[event.setting].value) end
end

--#endregion


--#region Commands

local function embargo_command(cmd)
	local player = game.get_player(cmd.player_index)
	if not (player and player.valid) then return end
	open_embargo_gui(player)
end

local function prices_command(cmd)
	local player = game.get_player(cmd.player_index)
	if not (player and player.valid) then return end
	open_prices_gui(player)
end

local function price_list_command(cmd)
	local player = game.get_player(cmd.player_index)
	if not (player and player.valid) then return end
	open_price_list_gui(player)
end

--#endregion


--#region Pre-game stage

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

local function add_remote_interface()
	-- https://lua-api.factorio.com/latest/LuaRemote.html
	remote.remove_interface("free-market") -- For safety
	remote.add_interface("free-market", {})
end

local function link_data()
	mod_data = global.free_market
	sell_boxes = mod_data.sell_boxes
	buy_boxes = mod_data.buy_boxes
	embargoes = mod_data.embargoes
	sell_prices = mod_data.sell_prices
	buy_prices = mod_data.buy_prices
	open_box = mod_data.open_box
	all_boxes = mod_data.all_boxes
	active_forces = mod_data.active_forces
end

local function update_global_data()
	global.free_market = global.free_market or {}
	mod_data = global.free_market
	mod_data.open_box = {}
	mod_data.active_forces = mod_data.active_forces or {}
	mod_data.sell_boxes = mod_data.sell_boxes or {}
	mod_data.buy_boxes = mod_data.buy_boxes or {}
	mod_data.sell_prices = mod_data.sell_prices or {}
	mod_data.buy_prices = mod_data.buy_prices or {}
	mod_data.embargoes = mod_data.embargoes or {}
	mod_data.all_boxes = mod_data.all_boxes or {}
	mod_data.last_buyer_index = 1

	link_data()

	clear_invalid_entities()
	clear_invalid_prices(sell_prices)
	clear_invalid_prices(buy_prices)
	clear_invalid_embargoes()

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

	for _, force in pairs(game.forces) do
		if #force.players > 0 then
			local index = force.index
			sell_prices[index] = sell_prices[index] or {}
			sell_boxes[index] = sell_boxes[index] or {}
			buy_prices[index] = buy_prices[index] or {}
			buy_boxes[index] = buy_boxes[index] or {}
			embargoes[index] = embargoes[index] or {}
		end
	end
	local index = game.forces.player.index
	sell_prices[index] = sell_prices[index] or {}
	sell_boxes[index] = sell_boxes[index] or {}
	buy_prices[index] = buy_prices[index] or {}
	buy_boxes[index] = buy_boxes[index] or {}
	embargoes[index] = embargoes[index] or {}
end

local function on_configuration_changed(event)
	update_global_data()

	local mod_changes = event.mod_changes["free-market"]
	if not (mod_changes and mod_changes.old_version) then return end

	local version = tonumber(string.gmatch(mod_changes.old_version, "%d+.%d+")())

	if version < 0.11 then
		for _, player in pairs(game.players) do
			if player.valid then
				create_left_relative_gui(player)
			end
		end
	end
end

M.on_load = function ()
	link_data()
	set_filters()
end
M.on_init = function()
	update_global_data()
	set_filters()
end
M.on_configuration_changed = on_configuration_changed
M.add_remote_interface = add_remote_interface

--#endregion


M.events = {
	-- [defines.events.on_game_created_from_scenario] = on_game_created_from_scenario,
	[defines.events.on_surface_deleted] = clear_invalid_entities,
	[defines.events.on_surface_cleared] = clear_invalid_entities,
	[defines.events.on_chunk_deleted] = clear_invalid_entities,
	[defines.events.on_player_created] = on_player_created,
	[defines.events.on_player_joined_game] = function(event)
		pcall(on_player_joined_game, event)
	end,
	[defines.events.on_gui_selection_state_changed] = on_gui_selection_state_changed,
	[defines.events.on_gui_elem_changed] = on_gui_elem_changed,
	[defines.events.on_gui_click] = function(event)
		pcall(on_gui_click, event)
	end,
	[defines.events.on_player_left_game] = function(event)
		pcall(on_player_left_game, event)
	end,
	[defines.events.on_player_removed] = delete_player_data,
	[defines.events.on_force_created] = on_force_created,
	[defines.events.on_forces_merging] = on_forces_merging,
	[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed,
	[defines.events.on_player_changed_force] = function(event)
		pcall(on_player_changed_force, event)
	end,
	[defines.events.on_player_changed_surface] = function(event)
		pcall(on_player_changed_surface, event)
	end,
	[defines.events.on_force_cease_fire_changed] = function(event)
		if is_auto_embargo then
			pcall(on_force_cease_fire_changed, event)
		end
	end,
	[defines.events.on_player_mined_entity] = clear_box_data,
	[defines.events.on_robot_mined_entity] = clear_box_data,
	[defines.events.script_raised_destroy] = clear_box_data,
	[defines.events.on_entity_died] = clear_box_data,
	["FM_set-sell-box"] = function(event)
		pcall(set_sell_box_key_pressed, event)
	end,
	["FM_set-buy-box"] = function(event)
		pcall(set_buy_box_key_pressed, event)
	end
}

M.on_nth_tick = {
	[update_tick] = check_buy_boxes,
	[CHECK_FORCES_TICK] = check_forces
}

M.commands = {
	embargo = embargo_command,
	prices = prices_command,
	price_list = price_list_command
}


return M
