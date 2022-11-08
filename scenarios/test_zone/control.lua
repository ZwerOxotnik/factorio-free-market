local dummy_forces_count = 7
local universal_transfer_count = 1000
local universal_bin_count = 1000
local repeat_transfer_count = 8
local repeat_bin_count = 8
local repeat_pull_count = 1
local repeat_buy_count = 8
local max_items = 200
local PROHIBIT_ITEMS_TYPES = {
	["mining-tool"] = true
}
local function place_dummy_trading_boxes(player)
	local stack = {name = "", count = 10}
	local position = {x=0, y=0}
	local universal_transferers_count = global.universal_transferers_count
	local universal_bin_boxes_count = global.universal_bin_boxes_count
	local bin_boxes_count = global.bin_boxes_count
	local transferers_count = global.transferers_count
	local pull_box_count = global.pull_box_count
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
				remote.call("free-market", "set_pull_box_data", item_name, entity)
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
			for _=1, repeat_transfer_count do
				transferers_count = transferers_count + 1
				position.x = transferers_count
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_transfer_box_data", item_name, entity)
				entity.insert(stack)
			end
		end
	end

	i = 0
	position.y = -6
	for item_name, item in pairs(game.item_prototypes) do
		if not PROHIBIT_ITEMS_TYPES[item.type] then
			i = i + 1
			if i > max_items then
				break
			end
			stack.name = item_name
			for _=1, repeat_bin_count do
				bin_boxes_count = bin_boxes_count + 1
				position.x = bin_boxes_count
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_bin_box_data", item_name, entity)
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
				remote.call("free-market", "set_buy_box_data", item_name, entity, 50)
				-- entity.insert(stack)
			end
		end
	end

	i = 0
	position.y = -10
	for _=1, universal_transfer_count do
		universal_transferers_count = universal_transferers_count + 1
		position.x = universal_transferers_count
		entity = create_entity{name="steel-chest", position=position, force=force}
		remote.call("free-market", "set_universal_transfer_box_data", entity)
		-- entity.insert(stack)
	end

	i = 0
	position.y = -14
	for _=1, universal_bin_count do
		universal_bin_boxes_count = universal_bin_boxes_count + 1
		position.x = universal_bin_boxes_count
		entity = create_entity{name="steel-chest", position=position, force=force}
		remote.call("free-market", "set_universal_bin_box_data", entity)
		-- entity.insert(stack)
	end

	global.universal_transferers_count = universal_transferers_count
	global.universal_bin_boxes_count = universal_bin_boxes_count
	global.bin_boxes_count = bin_boxes_count
	global.transferers_count = transferers_count
	global.pull_box_count = pull_box_count
	global.buy_box_count = buy_box_count
end

script.on_event(defines.events.on_player_created, function(event)
	if event.player_index ~= 1 then return end
	global.universal_transferers_count = 0
	global.universal_bin_boxes_count = 0
	global.transferers_count = 0
	global.bin_boxes_count = 0
	global.pull_box_count = 0
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

	local universal_transferers_count = global.universal_transferers_count
	local universal_bin_boxes_count = global.universal_bin_boxes_count
	local transferers_count = global.transferers_count
	local bin_boxes_count = global.bin_boxes_count
	local pull_box_count = global.pull_box_count
	local buy_box_count  = global.buy_box_count
	game.print("This scenario uses for testing \"Free market\".")
	game.print("Created " .. dummy_forces_count .. " dummy forces and using " .. max_items .. " items.")
	game.print("Created " .. universal_transferers_count .. " universal transferers")
	game.print("Created " .. transferers_count .. " transferers")
	game.print("Created " .. universal_bin_boxes_count .. " universal bin boxes")
	game.print("Created " .. bin_boxes_count .. " bin boxes")
	game.print("Created " .. buy_box_count .. " buy boxes")
	game.print("Created " .. pull_box_count .. " pull boxes")
end)
