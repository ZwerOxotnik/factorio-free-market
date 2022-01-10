require("prototypes/style")
require("prototypes/tools")

data:extend({
	{type = "custom-input", name = "FM_set-pull-box", key_sequence = "", consuming = "game-only"},
	{type = "custom-input", name = "FM_set-transfer-box", key_sequence = "mouse-wheel-left", consuming = "game-only"},
	{type = "custom-input", name = "FM_set-universal-transfer-box", key_sequence = "mouse-wheel-left", consuming = "game-only"},
	{type = "custom-input", name = "FM_set-buy-box",  key_sequence = "mouse-wheel-right", consuming = "game-only"}, {
		type = "sprite",
		name = "FM_price",
		filename = "__iFreeMarket__/graphics/price.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_change-price",
		filename = "__iFreeMarket__/graphics/change-price.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_see-prices",
		filename = "__iFreeMarket__/graphics/see-prices.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_embargo",
		filename = "__iFreeMarket__/graphics/embargo.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_buy",
		filename = "__iFreeMarket__/graphics/buy.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_pull_out",
		filename = "__iFreeMarket__/graphics/pull-out.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_transfer",
		filename = "__iFreeMarket__/graphics/transfer.png",
		width = 64, height = 64,
		flags = {"gui-icon"}
	}, {
		type = "sprite",
		name = "FM_universal_transfer",
		filename = "__iFreeMarket__/graphics/universal-transfer.png",
		width = 64, height = 64,
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
	}
})
