require("prototypes/styles")
require("prototypes/tools")

data:extend({
	{type = "custom-input", name = "FM_set-sell-box", key_sequence = "mouse-wheel-left", consuming = "game-only"},
	{type = "custom-input", name = "FM_set-buy-box" , key_sequence = "mouse-wheel-right", consuming = "game-only"},
	{
		type = "sprite",
		name = "FM_change-price",
		filename = "__free-market__/graphics/change-price.png",
		width = 32, height = 32,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_see-prices",
		filename = "__free-market__/graphics/see-prices.png",
		width = 32, height = 32,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_embargo",
		filename = "__free-market__/graphics/embargo.png",
		width = 32, height = 32,
		flags = {"gui-icon"}
	}, {
    type = "item",
    name = "trading",
    icon = "__base__/graphics/icons/market.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"hidden"},
    subgroup = "science-pack",
    order = "y",
    stack_size = 100000
  },
})

