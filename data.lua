require("prototypes/styles")

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
	}
})
