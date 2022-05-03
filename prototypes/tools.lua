local flags = {"hidden", "not-stackable", "only-in-cursor", "spawnable"}
local selection_mode = {"entity-with-health", "same-force", "avoid-rolling-stock"}
local entity_type_filters = {"container", "logistic-container"}

---@param name string
---@param style string
---@param hotkey_name string
---@param icon string
local function create_FM_select_tool(name, style, hotkey_name, icon)
	local order = "free-market[" .. name .. "]"

	local selection_cursor_box_type
	if style == "red" then
		selection_cursor_box_type = "not-allowed"
	else
		selection_cursor_box_type = "entity"
	end

	data:extend({
		{type = "custom-input", name = hotkey_name, key_sequence = "", consuming = "game-only"},
		{
			type = "selection-tool",
			name = name,
			icon = "__iFreeMarket__/graphics/" .. icon .. ".png",
			icon_size = 64,
			order = order,
			flags = flags,
			icon_mipmaps = nil,
			subgroup = "tool",
			stack_size = 1,
			entity_filter_count = nil,
			tile_filter_count = nil,
			entity_type_filters = entity_type_filters,
			selection_color = {255, 145, 0},
			-- selection_count_button_color = {195, 52, 52},
			alt_selection_color = {239, 153, 34},
			-- alt_selection_count_button_color = {255, 176, 66},
			selection_mode = selection_mode,
			alt_selection_mode = selection_mode,
			selection_cursor_box_type = selection_cursor_box_type,
			alt_selection_cursor_box_type = selection_cursor_box_type
		}, {
			type = "shortcut",
			name = name,
			action = "spawn-item",
			item_to_spawn = name,
			associated_control_input = hotkey_name,
			icon = {
				filename = "__iFreeMarket__/graphics/" .. icon .. ".png",
				priority = "low",
				size = 64,
				flags = {"gui-icon"}
			},
			toggleable = true,
			order = order,
			style = style
		}
	})
end


-- TODO: change icons
create_FM_select_tool("FM_set_pull_boxes_tool", "green", "FM_get-pull-box-selection-tool", "pull-out")
create_FM_select_tool("FM_set_transfer_boxes_tool", "green", "FM_get-transfer-box-selection-tool", "transfer")
create_FM_select_tool("FM_set_universal_transfer_boxes_tool", "green", "FM_get-universal-transfer-box-selection-tool", "universal-transfer")
create_FM_select_tool("FM_set_bin_boxes_tool", "green", "FM_get-bin-box-selection-tool", "bin")
create_FM_select_tool("FM_set_universal_bin_boxes_tool", "green", "FM_get-universal-bin-box-selection-tool", "universal-bin")
create_FM_select_tool("FM_set_buy_boxes_tool", "green", "FM_get-buy-box-selection-tool", "buy")
create_FM_select_tool("FM_remove_boxes_tool", "red", "FM_get-remove-boxes-selection-tool", "embargo")
