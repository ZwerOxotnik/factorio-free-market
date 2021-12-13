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
	top_padding = -7
}

styles["FM_prices_flow"] = {
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

styles["FM_prices_table"] = {
	type = "table_style",
	vertical_centering = true,
	vertical_spacing = 0,
	horizontal_spacing = 0
}
