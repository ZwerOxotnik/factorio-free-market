local dummy_forces_count = 7
local repeat_pull_count = 1
local repeat_sell_count = 8
local repeat_buy_count = 8
local max_items = 200
local PROHIBIT_ITEMS_TYPES = {
	["mining-tool"] = true
}
local function place_dummy_trading_boxes(player)
	local stack = {name = "", count = 10}
	local position = {x=0, y=0}
	local pull_box_count = global.pull_box_count
	local sell_box_count = global.sell_box_count
	local buy_box_count  = global.buy_box_count
	local force = player.force
	local force_index = force.index
	local surface = player.surface
	local create_entity = surface.create_entity
	local entity
	local i = 0
	position.y = 2
	for item_name, item in pairs(game.item_prototypes) do
		if not PROHIBIT_ITEMS_TYPES[item.type] then
			i = i + 1
			if i > max_items then
				break
			end
			stack.name = item_name
			for _=1, repeat_pull_count do
				pull_box_count = pull_box_count + 1
				position.x = pull_box_count
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_pull_box_data", item_name, player, entity)
				entity.insert(stack)
			end
		end
	end

	i = 0
	position.y = -2
	for item_name, item in pairs(game.item_prototypes) do
		if not PROHIBIT_ITEMS_TYPES[item.type] then
			i = i + 1
			if i > max_items then
				break
			end
			remote.call("free-market", "set_sell_price", item_name, force_index, 1)
			stack.name = item_name
			for _=1, repeat_sell_count do
				sell_box_count = sell_box_count + 1
				position.x = sell_box_count
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_sell_box_data", item_name, player, entity)
				entity.insert(stack)
			end
		end
	end

	i = 0
	position.y = 6
	for item_name, item in pairs(game.item_prototypes) do
		if not PROHIBIT_ITEMS_TYPES[item.type] then
			i = i + 1
			if i > max_items then
				break
			end
			remote.call("free-market", "set_buy_price", item_name, force_index, 1)
			stack.name = item_name
			for _=1, repeat_buy_count do
				buy_box_count = buy_box_count + 1
				position.x = buy_box_count
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_buy_box_data", item_name, player, entity, 50)
				-- entity.insert(stack)
			end
		end
	end

	global.pull_box_count = pull_box_count
	global.sell_box_count = sell_box_count
	global.buy_box_count = buy_box_count
end

script.on_event(defines.events.on_player_created, function(event)
	if event.player_index ~= 1 then return end
	global.pull_box_count = 0
	global.sell_box_count = 0
	global.buy_box_count = 0

	local player = game.get_player(1)
	for i=1, dummy_forces_count do
		local new_force = game.create_force("dummy_team" .. i)
		player.force = new_force
		remote.call("EasyAPI", "set_force_money", new_force, 100000000)
		place_dummy_trading_boxes(player)
	end
	if max_items > #game.item_prototypes then
		max_items = #game.item_prototypes
	end

	local pull_box_count = global.pull_box_count
	local sell_box_count = global.sell_box_count
	local buy_box_count  = global.buy_box_count
	game.print("This scenario uses for testing \"Free market\".")
	game.print("Created " .. dummy_forces_count .. " dummy forces and using " .. max_items .. " items.")
	game.print("Created " .. sell_box_count .. " sell boxes")
	game.print("Created " .. buy_box_count .. " buy boxes")
	game.print("Created " .. pull_box_count .. " pull boxes")
end)
