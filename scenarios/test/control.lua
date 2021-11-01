local dummy_forces_count = 5
local repeat_count = 5
local max_items = 50
local position = {x=0, y=0}
local count = 0
local stack = {name = "", count = 200}
local PROHIBIT_ITEMS_TYPES = {
	["mining-tool"] = true
}
local function place_dummy_trading_boxes(player)
	local force = player.force
	local force_index = force.index
	local surface = player.surface
	local create_entity = surface.create_entity
	local entity
	local i = 0
	for item_name, item in pairs(game.item_prototypes) do
		if not PROHIBIT_ITEMS_TYPES[item.type] then
			i = i + 1
			if i > max_items then
				break
			end
			remote.call("free-market", "set_sell_price", item_name, force_index, 1)
			remote.call("free-market", "set_buy_price", item_name, force_index, 1)
			stack.name = item_name
			for _=1, repeat_count do
				count = count + 1
				position.x = count
				position.y = 0
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_sell_box_data", item_name, player, entity)
				entity.insert(stack)
				position.y = 1
				entity = create_entity{name="steel-chest", position=position, force=force}
				remote.call("free-market", "set_buy_box_data", item_name, player, entity, 50)
				-- entity.insert(stack)
			end
		end
	end
end

script.on_event(defines.events.on_player_created, function(event)
	if event.player_index ~= 1 then return end
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
	game.print("This scenario isn't safe for multipalyer probably and it uses for testing \"Free market\".")
	game.print("Created " .. dummy_forces_count .. " dummy forces.")
	game.print("Created " .. count*2 .. " boxes, using " .. max_items .. " items.")
end)
