local M = {}

local shop = {}

shop.weapons = {
	{ "Dagger", 8, 4, 0 },
	{ "Shortsword", 10, 5, 0 },
	{ "Warhammer", 25, 6, 0 },
	{ "Longsword", 40, 7, 0 },
	{ "Greataxe", 74, 8, 0 },
}

shop.armor = {
	{ "Leather", 13, 0, 1 },
	{ "Chainmail", 31, 0, 2 },
	{ "Splintmail", 53, 0, 3 },
	{ "Bandedmail", 75, 0, 4 },
	{ "Platemail", 102, 0, 5 },
}

shop.rings = {
	{ "Damage +1", 25, 1, 0 },
	{ "Damage +2", 50, 2, 0 },
	{ "Damage +3", 100, 3, 0 },
	{ "Defense +1", 20, 0, 1 },
	{ "Defense +2", 40, 0, 2 },
	{ "Defense +3", 80, 0, 3 },
	{ "", 0, 0, 0 },
	{ "", 0, 0, 0 },
}

local function load_data(file)
	local data = {}

	data.hp = tonumber(file:read():match("%d+"))
	data.dmg = tonumber(file:read():match("%d+"))
	data.def = tonumber(file:read():match("%d+"))

	file:close()
	return data
end

local function do_battle(player, boss)
	local turn = 1
	while player.hp > 0 and boss.hp > 0 do
		local p_dmg = math.max(player.dmg - boss.def, 1)
		local b_dmg = math.max(boss.dmg - player.def, 1)

		if turn % 2 == 1 then
			boss.hp = boss.hp - p_dmg
		else
			player.hp = player.hp - b_dmg
		end

		turn = turn + 1
	end
end

M["1"] = function(file)
	local data = load_data(file)
	local player = {}

	local min = math.huge
	for _, weapon in ipairs(shop.weapons) do
		for _, armor in ipairs(shop.armor) do
			for _, right in ipairs(shop.rings) do
				for i = #right + 1, #shop.rings do
					local left = shop.rings[i]
					local cost = weapon[2]
					cost = cost + armor[2]
					cost = cost + left[2]
					cost = cost + right[2]

					player.hp = 100
					player.dmg = weapon[3] + left[3] + right[3]
					player.def = armor[4] + left[4] + right[4]
					local boss = { hp = data.hp, dmg = data.dmg, def = data.def }

					do_battle(player, boss)

					if player.hp > 0 and cost < min then
						min = cost
					end
				end
			end
		end
	end

	return min
end

return M
