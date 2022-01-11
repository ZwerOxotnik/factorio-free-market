local deepcopy = util.table.deepcopy
local styles = data.raw["gui-style"].default

styles.fm_subheader_frame = {
	type = "frame_style",
	parent = "subheader_frame",
	height = 0, -- Negate the height requirement
	minimal_height = 36
}

styles["FM_price_label"] = {
	type = "label_style",
	font = "heading-2",
	top_padding = -7,
	font_color = {206, 206, 190},
	rich_text_setting = "disabled"
}

styles["FM_price_textfield"] = {type = "textbox_style", rich_text_setting = "disabled", width = 70}

styles["FM_prices_frame"] = {
	type = "frame_style",
	right_padding = -1,
	vertically_stretchable = "on",
	horizontally_stretchable = "on",
	graphical_set = {
		base = {
			center = {position = {336, 0}, size = {1, 1}},
			opacity = 0.1,
			background_blur = false,
			blend_mode = "multiplicative-with-alpha"
		},
		shadow = default_glow(hard_shadow_color, 1)
	}
}

styles["FM_price_frame"] = {
	type = "frame_style",
	left_padding = 6,
	right_margin = 10,
	maximal_height = 20,
	graphical_set = {
		base = {
			center = {position = {336, 0}, size = {1, 1}},
			opacity = 0.4,
			background_blur = true,
			background_blur_sigma = 0.5,
			blend_mode = "additive-soft-with-alpha"
		},
		shadow = default_glow(default_shadow_color, 0.5)
	}
}

styles["FM_item_price_frame"] = {
	type = "frame_style",
	padding = 0,
	right_padding = 6,
	graphical_set = {
		base = {
			center = {position = {336, 0}, size = {1, 1}},
			opacity = 0.4,
			background_blur = true,
			background_blur_sigma = 0.5,
			blend_mode = "additive-soft-with-alpha"
		},
		shadow = default_glow(default_shadow_color, 0.5)
	}
}

styles["FM_prices_table"] = {
	type = "table_style",
	vertical_centering = true,
	vertical_spacing = 0,
	horizontal_spacing = 0
}

styles.FM_box_button = {type = "button_style", parent = "slot_button", maximal_width = 0, font_color = {255, 230, 192}}

local slot_button = styles.slot_button

styles.FM_buy_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.buy-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_buy_button = styles.FM_buy_button
FM_buy_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/buy.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_buy_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/buy.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_buy_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/buy.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}

styles.FM_pull_out_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.pull-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_pull_out_button = styles.FM_pull_out_button
FM_pull_out_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/pull-out.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_pull_out_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/pull-out.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_pull_out_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/pull-out.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}

styles.FM_transfer_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.transfer-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_transfer_button = styles.FM_transfer_button
FM_transfer_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_transfer_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_transfer_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}

styles.FM_universal_transfer_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.universal-transfer-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_universal_transfer_button = styles.FM_universal_transfer_button
FM_universal_transfer_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/universal-transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_universal_transfer_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/universal-transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_universal_transfer_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/universal-transfer.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}

styles.FM_bin_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.bin-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_bin_button = styles.FM_bin_button
FM_bin_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_bin_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_bin_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}

styles.FM_universal_bin_button = {
	type = "button_style",
	parent = "FM_box_button",
	tooltip = "free-market.universal-bin-gui",
	default_graphical_set = deepcopy(slot_button.default_graphical_set),
	hovered_graphical_set = deepcopy(slot_button.hovered_graphical_set),
	clicked_graphical_set = deepcopy(slot_button.clicked_graphical_set)
}
local FM_universal_bin_button = styles.FM_universal_bin_button
FM_universal_bin_button.default_graphical_set.glow = {
	top_outer_border_shift = 4,
	bottom_outer_border_shift = -4,
	left_outer_border_shift = 4,
	right_outer_border_shift = -4,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/universal-bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_universal_bin_button.hovered_graphical_set.glow.center = {
	filename = "__iFreeMarket__/graphics/universal-bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
FM_universal_bin_button.clicked_graphical_set.glow = {
	top_outer_border_shift = 2,
	bottom_outer_border_shift = -2,
	left_outer_border_shift = 2,
	right_outer_border_shift = -2,
	draw_type = "outer",
	filename = "__iFreeMarket__/graphics/universal-bin.png",
	flags = {"gui-icon"},
	size = 64, scale = 1
}
