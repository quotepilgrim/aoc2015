local M = {}
local player = {}
local boss = {}
local random = love.math.random

local function random_order(t)
	for i = 1, 20 do
		t[i] = random(1, 5)
	end

	return t
end

function player:reset()
	self.hp = 50
	self.mp = 500
	self.def = 0
end

local function new_spell(t)
	t.name = t.name or ""
	t.cost = t.cost or 0
	t.damage = t.damage or 0
	t.heal = t.heal or 0
	t.duration = t.duration or 0
	t.armor = t.armor or 0
	t.poison = t.poison or 0
	t.recharge = t.recharge or 0
	t.timer = 0

	return t
end

local spells = {
	new_spell({ name = "magic missile", cost = 53, damage = 4 }),
	new_spell({ name = "drain", cost = 73, damage = 2, heal = 2 }),
	new_spell({ name = "shield", cost = 113, armor = 7, duration = 6 }),
	new_spell({ name = "poison", cost = 173, poison = 3, duration = 6 }),
	new_spell({ name = "recharge", cost = 229, recharge = 101, duration = 5 }),
}

M["1"] = function(file, hard)
	local boss_hp = tonumber(file:read():match("%d+"))
	boss.dmg = tonumber(file:read():match("%d+"))
	local order = {}

	local function apply_effects()
		player.def = 0

		for _, s in ipairs(spells) do
			if s.timer > 0 then
				s.timer = s.timer - 1
				boss.hp = boss.hp - s.poison
				player.def = player.def + s.armor
				player.mp = player.mp + s.recharge
			end
		end
	end

	local min = math.huge

	for i = 1, 10000000 do
		local mana_spent = 0

		player:reset()
		boss.hp = boss_hp

		for _, spell in ipairs(spells) do
			spell.timer = 0
		end

		random_order(order)
		for _, v in ipairs(order) do
			local spell = spells[v]
			local can_use = (spell.cost <= player.mp) and (spell.timer <= 1)

			if can_use then
				if hard then
					player.hp = player.hp - 1
				end

				if player.hp <= 0 then
					break
				end

				apply_effects()
				spell.timer = spell.duration
				mana_spent = mana_spent + spell.cost

				player.mp = player.mp - spell.cost
				player.hp = player.hp + spell.heal
				boss.hp = boss.hp - spell.damage

				apply_effects()

				if boss.hp <= 0 then
					min = mana_spent < min and mana_spent or min
					break
				end

				player.hp = player.hp - (boss.dmg - player.def)

				if player.hp <= 0 or player.mp < 53 then
					break
				end
			end
		end

		if i % 1000000 == 0 then
			print(i / 1000000, min)
		end
	end

	return min
end

M["2"] = function(file)
	return M["1"](file, true)
end

return M
