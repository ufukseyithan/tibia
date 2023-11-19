Monster = {name = 'Monster', health = 100, image = 'gfx/weiwen/circle.png', scalex = 1, scaley = 1, atk = 1, def = 1, spd = 5, x = 0, y = 0, ang = 0, imgang = 0, exp = 5, money = 50, type = 'monster', loot = {}}
MONSTERS = {}
local t = 0

local SPAWNS = {
	FULLMAP = {{0, 0}, {150, 150}},
	BOTTOMHALF = {{0, 100}, {150, 150}},
	ONIXCAVE = {{165, 30}, {184, 48}},
}

CONFIG.MONSTERS = {
	{
		name = 'Bulbasaur', health = 100, image = 'gfx/weiwen/pokemon/1.png', scalex = 2, scaley = 2, r = 136, g = 224, b = 32, 
		atk = 1.9, def = 2.1, spd = 6, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 15, money = 100, loot = {{chance = 5000, id = 102}, {chance = 250, id = 221}}, 
		spc = {1500, function(self) 
			radiusmsg("Bulbasaur casts heal!", self.x, self.y)
			parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 255 255 255")
		end}, 
	}, 
	{
		name = 'Charmander', health = 100, image = 'gfx/weiwen/pokemon/4.png', scalex = 2, scaley = 2, 
		atk = 2.2, def = 1.8, spd = 6, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10,  
		spawnchance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 15, money = 100, loot = {{chance = 5000, id = 100}, {chance = 250, id = 222}}, 
		spc = {1000, function(self) 
			radiusmsg("Charmander uses ember!", self.x, self.y)
			parse('explosion ' .. self.x .. ' ' .. self.y .. ' 96 40')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 64 255 128 0')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 96 255 255 0')
		end},
	}, 
	{
		name = 'Squirtle', health = 100, image = 'gfx/weiwen/pokemon/7.png', scalex = 2, scaley = 2, 
		atk = 1.7, def = 2.3, spd = 6, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 15, money = 100, loot = {{chance = 5000, id = 101}, {chance = 250, id = 223}}, 
		spc = {1000, function(self) 
			radiusmsg("Squirtle uses watergun!", self.x, self.y)
			parse('explosion ' .. self.x .. ' ' .. self.y .. ' 96 40')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 96 255 255 255')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 75 96 128 128 255')
		end},
	}, 
	{
		name = 'Caterpie', health = 100, image = 'gfx/weiwen/pokemon/10.png', scalex = 1.5, scaley = 1.5, r = 104, g = 152, b = 40, 
		atk = 1.1, def = 1.2, spd = 7, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, 
		spawnchance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 5, money = 30, loot = {{chance = 8000, id = 1}}, 
	}, 
	{
		name = 'Weedle', health = 100, image = 'gfx/weiwen/pokemon/13.png', scalex = 1.5, scaley = 1.5, r = 104, g = 152, b = 40, 
		atk = 1.2, def = 1.1, spd = 7, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, 
		spawnchance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 5, money = 30, loot = {{chance = 8000, id = 1}}, 
	}, 
	{
		name = 'Pidgey', health = 100, image = 'gfx/weiwen/pokemon/16.png', scalex = 2, scaley = 2, 
		atk = 1.2, def = 1.2, spd = 10, atkspd = 7, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, 
		spawnchance = {['rpg_mapb'] = {50}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 13, money = 60, loot = {}, 
		spc = {500, function(self) 
			radiusmsg("Pidgey uses sand attack!", self.x, self.y)
			parse('flashposition ' .. self.x .. ' ' .. self.y .. ' 100')
		end},
	}, 
	{
		name = 'Ratata', health = 100, image = 'gfx/weiwen/pokemon/19.png', scalex = 1.5, scaley = 1.5, 
		atk = 1.0, def = 1.0, spd = 9, atkspd = 5, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, 
		spawnchance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 7, money = 50, loot = {{chance = 8000, id = 4}}, 
	}, 
	{
		name = 'Spearow', health = 100, image = 'gfx/weiwen/pokemon/21.png', scalex = 2, scaley = 2, 
		atk = 1.4, def = 1.0, spd = 10, atkspd = 7, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, 
		spawnchance = {['rpg_mapb'] = {50}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 13, money =60, loot = {}, 
		spc = {2500, function(self, target, dist) 
			if not self.agility then
				radiusmsg("Spearow uses agility!", self.x, self.y)
				parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 155 255 155")
				radiussound("weapons/g_flash.wav", self.x, self.y)
				self._spd = self.spd
				self.spd = 10
				self.agility = true
				imagecolor(self.image, 155, 255, 155)
				timer(5000, "CONFIG.MONSTERSKILLS.endAgility", self.id)
			elseif dist <= 32 then
				self:hit(target, 10)
			end
		end},
	}, 
	{
		name = 'Ekans', health = 100, image = 'gfx/weiwen/pokemon/23.png', scalex = 2, scaley = 2, 
		atk = 1.8, def = 1.2, spd = 7, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 10, money = 80, loot = {}, 
		spc = {500, function(self, target, dist) 
			if dist <= 96 then
				radiusmsg("Ekans uses poison sting!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Pikachu', health = 100, image = 'gfx/weiwen/pokemon/25.png', scalex = 2, scaley = 2, 
		atk = 2.1, def = 2.1, spd = 7, atkspd = 7, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 25, money = 120, loot = {{chance = 5000, id = 103}, {chance = 250, id = 220}}, 
		spc = {500, function(self) 
			radiusmsg("Pikachu uses thundershock!", self.x, self.y)
			parse('explosion ' .. self.x .. ' ' .. self.y .. ' 96 40')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 96 255 255 0')
			parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 75 64 255 255 255')
		end},
	}, 
	{
		name = 'Sandshrew', health = 100, image = 'gfx/weiwen/pokemon/27.png', scalex = 2, scaley = 2, 
		atk = 1.7, def = 2.1, spd = 7, atkspd = 7, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {5, 20}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF, SPAWNS.ONIXCAVE}
		}, 
		exp = 18, money = 120, loot = {}, 
		spc = {1000, function(self) 
			radiusmsg("Sandshrew uses sand attack!", self.x, self.y)
			parse('flashposition ' .. self.x .. ' ' .. self.y .. ' 100')
		end},
	},
	{
		name = 'NidoranF', health = 100, image = 'gfx/weiwen/pokemon/29.png', scalex = 2, scaley = 2, 
		atk = 1.8, def = 1.2, spd = 7, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 10, money = 80, loot = {}, 
		spc = {750, function(self, target, dist) 
			if dist <= 96 then
				radiusmsg("NidoranF uses poison sting!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'NidoranM', health = 100, image = 'gfx/weiwen/pokemon/32.png', scalex = 2, scaley = 2, 
		atk = 1.8, def = 1.2, spd = 7, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 10, 
		spawnchance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 10, money = 80, loot = {}, 
		spc = {750, function(self, target, dist) 
			if dist <= 96 then
				radiusmsg("NidoranM uses horn attack!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Vulpix', health = 100, image = 'gfx/weiwen/pokemon/37.png', scalex = 2, scaley = 2, 
		atk = 2.2, def = 1.8, spd = 7, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 0, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		},  
		exp = 10, money = 100, loot = {{chance = 5000, id = 104}}, 
		spc = {500, function(self, target, dist) 
			radiusmsg("Vulpix uses flamethrower!", self.x, self.y)
			local x1, y1 = self.x, self.y
			local rot = math.atan2(target.y - y1, target.x - x1) + math.pi / 2
			local x2, y2 = math.sin(rot), -math.cos(rot)
			local fire = image("gfx/sprites/spot.bmp", 0, 0, 1)
			imagepos(fire, x1 + x2 * 64, y1 + y2 * 64, math.deg(rot) + 180)
			imagescale(fire, 1.5, 2)
			imagecolor(fire, 255, 64, 0)
			imageblend(fire, 1)
			timer(500, "freeimage", fire)
			parse('explosion ' .. x1+x2*100 .. ' ' .. y1+y2*100 .. ' 48 40')
			parse('explosion ' .. x1+x2*50 .. ' ' .. y1+y2*50 .. ' 32 40')
		end},
	}, 
	{
		name = 'Meowth', health = 100, image = 'gfx/weiwen/pokemon/52.png', scalex = 2, scaley = 2, 
		atk = 2.2, def = 2.2, spd = 10, atkspd = 6, x = 0, y = 0, ang = 0, imgang = 0, runat = 0, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 25, money = 100, loot = {{chance = 1000, id = 230}},
	}, 
	{
		name = 'Mankey', health = 100, image = 'gfx/weiwen/pokemon/56.png', scalex = 2, scaley = 2, 
		atk = 2.5, def = 1.8, spd = 10, atkspd = 6, x = 0, y = 0, ang = 0, imgang = 0, runat = 0, range = 48, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 25, money = 120, loot = {{chance = 1000, id = 300},{chance = 1000, id = 301},{chance = 1000, id = 302},{chance = 1000, id = 303},{chance = 1000, id = 304},{chance = 1000, id = 305},{chance = 1000, id = 306}}, 
		spc = {1000, function(self, target, dist) 
			if not self.rage then
				radiusmsg("Mankey uses rage!", self.x, self.y)
				parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 255 155 155")
				radiussound("weapons/g_flash.wav", self.x, self.y)
				self._atk = self.atk
				self.atk = 3.3
				self.rage = true
				imagecolor(self.image, 255, 155, 155)
				timer(5000, "CONFIG.MONSTERSKILLS.endRage", self.id)
			elseif dist <= 96 then
				radiusmsg("Mankey uses karate chop!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Abra', health = 100, image = 'gfx/weiwen/pokemon/63.png', scalex = 2, scaley = 2, 
		atk = 0.6, def = 1.0, spd = 5, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 100, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.FULLMAP}
		}, 
		exp = 8, money = 50, loot = {{chance = 5000, id = 105}}, 
		spc = {2500, function(self) 
			radiusmsg("Abra uses teleport!", self.x, self.y)
			parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 255 255 255")
			local dir = math.random(math.pi*2)
			if self:move(dir, 40) or self:move(dir, -40) then
				parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 255 255 255")
			end
		end},
	}, 
	{
		name = 'Gastly', health = 100, image = 'gfx/weiwen/pokemon/92.png', scalex = 2, scaley = 2, r = 64, g = 0, b = 64, 
		atk = 1.2, def = 1.5, spd = 8, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 50, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 8, money = 100, loot = {}, 
		spc = {1000, function(self, target, dist)
			if dist <= 64 and not target.tmp.paralyse then
				radiusmsg("Gastly uses lick!", self.x, self.y)
				target.tmp.paralyse = true
				target:message("You are paralysed.")
				parse("effect \"colorsmoke\" " .. player(id, 'x') .. " " .. player(id, 'y') .. " 5 5 64 0 64")
				timerEx(3000, "rem.paralyse", 1, target)
			elseif dist <= 32 then
				self:hit(target, 10)
			end
		end},
	}, 
	{
		name = 'Onix', health = 125, image = 'gfx/weiwen/pokemon/95.png', scalex = 3, scaley = 3, r = 144, g = 144, b = 144, 
		atk = 1.8, def = 5.0, spd = 3, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 0, range = 64, 
		spawnchance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.ONIXCAVE}
		}, 
		exp = 100, money = 300, loot = {{chance = 1000, id = 310},{chance = 1000, id = 311},{chance = 1000, id = 312},{chance = 1000, id = 313},{chance = 1000, id = 314},{chance = 1000, id = 315},{chance = 1000, id = 316}}, 
		spc = {1000, function(self) 
			if not self.harden then
				radiusmsg("Onix uses harden!", self.x, self.y)
				parse("effect \"colorsmoke\" " .. self.x .. " " .. self.y .. " 5 5 192 192 192")
				radiussound("weapons/g_flash.wav", self.x, self.y)
				self._def = self.def
				self.def = 7.5
				self.harden = true
				imagecolor(self.image, 155, 155, 255)
				timer(5000, "CONFIG.MONSTERSKILLS.endHarden", self.id)
			end
		end},
	}, 
	{
		name = 'Voltorb', health = 100, image = 'gfx/weiwen/pokemon/100.png', scalex = 2, scaley = 2, r = 144, g = 144, b = 144, 
		atk = 2.3, def = 2.3, spd = 5, atkspd = 8, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, range = 48, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 30, money = 130, loot = {{chance = 5000, id = 103}}, 
		spc = {1000, function(self) 
			if self.health < 20 then
				radiusmsg("Voltorb uses selfdestruct!", self.x, self.y)
				parse('explosion ' .. self.x .. ' ' .. self.y .. ' 128 80')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 128 255 128 0')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 128 255 255 0')
				self:destroy()
			else
				radiusmsg("Voltorb uses thundershock!", self.x, self.y)
				parse('explosion ' .. self.x .. ' ' .. self.y .. ' 96 40')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 96 255 255 0')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 75 64 255 255 255')
			end
		end},
	}, 
	{
		name = 'Koffing', health = 100, image = 'gfx/weiwen/pokemon/109.png', scalex = 2, scaley = 2, r = 128, g = 128, b = 0, 
		atk = 2.0, def = 1.7, spd = 4, atkspd = 10, x = 0, y = 0, ang = 0, imgang = 0, runat = 20, range = 48, 
		spawnchance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {SPAWNS.BOTTOMHALF}
		}, 
		exp = 30, money = 150, loot = {{chance = 5000, id = 106}}, 
		spc = {1000, function(self) 
			if self.health < 20 then
				radiusmsg("Koffing uses explosion!", self.x, self.y)
				parse('explosion ' .. self.x .. ' ' .. self.y .. ' 128 40')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 128 255 128 0')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 128 255 255 0')
				self:destroy()
			else
				radiusmsg("Koffing uses poison fog!", self.x, self.y)
				parse('explosion ' .. self.x .. ' ' .. self.y .. ' 96 40')
				parse('effect "colorsmoke" ' .. self.x .. ' ' .. self.y .. ' 100 96 128 128 0')
			end
		end},
	}, 
}

CONFIG.MONSTERSKILLS = {
	endAgility = function(id)
		self = MONSTERS[tonumber(id)]
		self.spd = self._spd
		self._spd = nil
		imagecolor(self.image, 255, 255, 255)
		self.agility = nil
	end,
	endRage = function(id)
		self = MONSTERS[tonumber(id)]
		self.atk = self._atk
		self._atk = nil
		imagecolor(self.image, 255, 255, 255)
		self.rage = nil
	end,
	endHarden = function(id)
		self = MONSTERS[tonumber(id)]
		self.def = self._def
		self._def = nil
		imagecolor(self.image, 255, 255, 255)
		self.harden = nil
	end,
}

sea.addEvent("onHookAttack", function(player)
	local id = player.id

	if gettile(unpack(player.lastPosition)).SAFE or gettile(unpack(player.lastPosition)).NOMONSTERS then
		return
	end
	if inarray({400, 401, 402, 403, 404}, player.equipment[7]) then
		message(id, "You may not attack on a horse.")
		return
	end
	local weapon, closest = player.weapon
	for _, m in ipairs(MONSTERS) do
		local x, y = player.x, player.y
		local dist = math.sqrt((m.x-x)^2+(m.y-y)^2)
		if dist <= (closest and closest[2] or (CONFIG.WEAPONRANGE[weapon] or CONFIG.WEAPONRANGE[50])) then
			local rot = player.rotation
			if math.abs(math.rad(rot) - math.atan2(y-m.y, x-m.x) + math.pi/2)%(2*math.pi) <= (CONFIG.WEAPONWIDTH[weapon] or CONFIG.WEAPONRANGE[50]) then
				closest = {m, dist}
			end
		end
	end
	if closest then
		closest[1]:damage(player, math.ceil(20*((player.level+50)*player.tmp.atk/closest[1].def)/math.random(60, 140)), weapon)
	end
end, -1)

sea.addEvent("onHookMs100", function(player)
	t = t + 1

	if t % 100 == 0 then
		while #MONSTERS < CONFIG.MAXMONSTERS do
			local rand, spawnNo, mapName
			while true do 
				rand = math.random(#CONFIG.MONSTERS)
				mapName = CONFIG.MONSTERS[rand].spawn[map'name'] and map'name' or CONFIG.DEFAULTMAP
				spawnNo = math.random(#CONFIG.MONSTERS[rand].spawn[mapName])
				if math.random(0, 100) < CONFIG.MONSTERS[rand].spawnchance[mapName][spawnNo] then
					break
				end
			end 
			local m = deepcopy(CONFIG.MONSTERS[rand])
			local x, y, tilex, tiley
			local spawn = m.spawn[mapName][spawnNo]
			repeat
				tilex, tiley = math.random(spawn[1][1], spawn[2][1]), math.random(spawn[1][2], spawn[2][2])
			until 
				gettile(tilex, tiley) and
				not gettile(tilex, tiley).SAFE and 
				not gettile(tilex, tiley).NOMONSTERS and 
				tile(tilex, tiley, "walkable") and 
				tile(tilex, tiley, "frame") ~= 34
			m.x, m.y = math.floor(tilex*32+16), math.floor(tiley*32+16)
			Monster:new(m)
		end
	end

	for _, m in ipairs(MONSTERS) do
		if t % m.atkspd == 0 then
			m.target = nil
			local closest
			for _, player in ipairs(table.shuffle(sea.Player.get())) do
				if player.health > 0 and not player:isAtZone("SAFE") and not player:isAtZone("NOMONSTERS") then
					local dist = getDistance(player.x, player.y, m.x, m.y)
					if dist < 400 then
						if not closest or dist < closest[2] then
							closest = {player, dist}
						end
					end
				end
			end
			if closest then
				local dist = closest[2]
				if dist < 400 then
					m.target = closest[1]
					if m.spc and math.random(10000) <= m.spc[1] then
						m.spc[2](m, m.target, dist)
					elseif dist <= (m.range or 32) then
						m:hit(m.target, 10)
					end
				end
			end
		end

		m.imgang = math.sin(t / 2.5 * math.pi) * 15
		if m.target and m.target.exists and m.target.health > 0 and not m.target:isAtZone("SAFE") and not m.target:isAtZone("NOMONSTERS") then
			xdist, ydist = m.target.x - m.x, m.target.y - m.y
			local dist = math.sqrt(xdist ^ 2 + ydist ^ 2)
			if dist < 400 then
				m.ang = math.atan2(ydist, xdist) - math.pi / 2 + math.random(-1, 1) / 2
			else
				m.target = nil
			end
		end

		if not m.target then
			m:rot(math.random(-1, 1) / 2)
		end

		if not m:move(m:rot(), m.health > m.runat and 1 or -1) then
			repeat until m:move(math.rad(math.random(360)), 1)
		end
	end
end, -1)

function Monster:new(m)
	if not (m.x or m.y) then return false end
	m.image = image(m.image, m.x, m.y, 0)
	imagescale(m.image, m.scalex, m.scaley)
	setmetatable(m, self)
	self.__index = self
	local n = #MONSTERS+1
	MONSTERS[#MONSTERS+1] = m
	m.id = n
	return m
end

function Monster:pos(x, y)
	if not x and not y then
		return self.x, self.y
	else
		self.x, self.y = x or self.x, y or self.y
		imagepos(self.image, self.x, self.y, self.imgang)
	end
	return true
end

function Monster:move(dir, amt)
	local x, y = -math.sin(dir) * amt * self.spd, math.cos(dir) * amt * self.spd
	x, y = self.x + x, self.y + y
	
	local tileX, tileY = pixelToTile(x), pixelToTile(y)
	local tile = sea.tile[tileX] and sea.tile[tileX][tileY]
	--print("tile exists: "..tostring(tile).." | coordinates: "..tileX..","..tileY.." | x: "..tostring(sea.tile[tileX]).." y: "..tostring(sea.tile[tileX][tileY]))

	if (tile and tile.walkable and tile.frame ~= 34) and not gettile(tileX, tileY).SAFE and not gettile(tileX, tileY).NOMONSTERS then
		self:pos(x, y)
		return true
	else
		self:rot(math.random(-1, 1) * math.pi / 2)
		return false
	end
end

function Monster:damage(player, damage, weapon)
	player:showTutorial("Damage Monster", "You have attacked a monster! Good job! Keep on attacking it until it dies.")

	local weaponName
	if weapon == 251 then
		weaponName = 'rune'
	elseif weapon == 46 then
		weaponName = 'firewave'
		damage = damage/5
	else
		weaponName = player.equipment[3] and ITEMS[player.equipment[3]].name or 'dagger'
	end
	self.health = self.health - damage

	if self.health <= 0 then
		player:showTutorial("Kill Monster", "Congratulation! You have killed your first monster. You can proceed to pick up the loot by using the drop weapon button (default G)")

		player:addXp(math.floor(self.exp * CONFIG.EXPRATE))

		self:die()
	else
		parse("effect", "colorsmoke", self.x, self.y, 10, self.scaley, self.r or 192, self.g or 0, self.b or 0)
	end

	radiussound("weapons/machete_hit.wav", self.x, self.y)

	return true
end

function Monster:hit(player, damage)
	player:showTutorial("Hit Monster", "A monster is attacking you! You can fight back by swinging your weapon at it.")

	if player.weapon == 41 and (math.abs(math.rad(player.rotation) - math.atan2(player.y - self.y, player.x - self.x) + math.pi / 2) % (2 * math.pi) <= math.pi * 2 / 3) then
		damage = damage / 4

		radiussound("weapons/ricmetal" .. math.random(1,2) .. ".wav", self.x, self.y)
	else
		radiussound("weapons/knife_hit.wav", self.x, self.y)
	end

	EXPhit(player, self, -1, damage)

	return true
end

function Monster:die(id)
	local size = self.scalex + self.scaley
	parse("effect", "colorsmoke", self.x, self.y, size, 64, self.r or 192, self.g or 0, self.b or 0)
	
	local tileX, tileY = math.floor(self.x/32), math.floor(self.y/32)

	spawnitem(1337, tileX, tileY, math.floor(self.money * math.random(50, 150) / 100) * CONFIG.MONEYRATE)

	for _, loot in ipairs(self.loot) do
		local chance = math.random(10000)
		if chance <= loot.chance then
			spawnitem(loot.id, tileX, tileY)
		end
	end

	radiussound("weapons/c4_explode.wav", self.x, self.y)

	self:destroy()
end

function Monster:destroy()
	freeimage(self.image)

	table.remove(MONSTERS, self.id)

	for i, m in ipairs(MONSTERS) do
		m.id = i
	end

	return true
end

function Monster:rot(rot)
	if not rot then
		return self.ang
	else
		self.ang = (self.ang+rot)%(math.pi*2)
	end

	return true
end