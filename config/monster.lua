tibia.config.monsterSpawn = {
	fullMap = {{0, 0}, {150, 150}},
	bottomHalf = {{0, 100}, {150, 150}},
	onixCave = {{165, 30}, {184, 48}},
}

local spawn = tibia.config.monsterSpawn

tibia.config.monster = {
	{
		name = 'Bulbasaur', health = 100, image = 'gfx/weiwen/pokemon/1.png', scaleX = 2, scaleY = 2, r = 136, g = 224, b = 32, 
		attack = 1.9, defence = 2.1, speed = 6, attackSpeed = 8, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 15, rupee = 100, loot = {{chance = 5000, id = 102}, {chance = 250, id = 221}}, 
		spc = {1500, function(self) 
			tibia.radiusMessage("Bulbasaur casts heal!", self.x, self.y)
			sea.effect("colorsmoke", self.x, self.y, 5, 5, 255, 255, 255)
		end}, 
	}, 
	{
		name = 'Charmander', health = 100, image = 'gfx/weiwen/pokemon/4.png', scaleX = 2, scaleY = 2, 
		attack = 2.2, defence = 1.8, speed = 6, attackSpeed = 8, runAt = 10,  
		spawnChance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 15, rupee = 100, loot = {{chance = 5000, id = 100}, {chance = 250, id = 222}}, 
		spc = {1000, function(self) 
			tibia.radiusMessage("Charmander uses ember!", self.x, self.y)
			sea.explosion(self.x, self.y, 96, 40)
			sea.effect("colorsmoke", self.x, self.y, 100, 64, 255, 128, 0)
			sea.effect("colorsmoke", self.x, self.y, 100, 96, 255, 255, 0)
		end},
	}, 
	{
		name = 'Squirtle', health = 100, image = 'gfx/weiwen/pokemon/7.png', scaleX = 2, scaleY = 2, 
		attack = 1.7, defence = 2.3, speed = 6, attackSpeed = 8, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 15, rupee = 100, loot = {{chance = 5000, id = 101}, {chance = 250, id = 223}}, 
		spc = {1000, function(self) 
			tibia.radiusMessage("Squirtle uses watergun!", self.x, self.y)
			sea.explosion(self.x, self.y, 96, 40)
			sea.effect("colorsmoke", self.x, self.y, 100, 96, 255, 255, 255)
			sea.effect("colorsmoke", self.x, self.y, 75, 96, 128, 128, 255)
		end},
	}, 
	{
		name = 'Caterpie', health = 100, image = 'gfx/weiwen/pokemon/10.png', scaleX = 1.5, scaleY = 1.5, r = 104, g = 152, b = 40, 
		attack = 1.1, defence = 1.2, speed = 7, attackSpeed = 10, runAt = 20, 
		spawnChance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 5, rupee = 30, loot = {{chance = 8000, id = 1}}, 
	}, 
	{
		name = 'Weedle', health = 100, image = 'gfx/weiwen/pokemon/13.png', scaleX = 1.5, scaleY = 1.5, r = 104, g = 152, b = 40, 
		attack = 1.2, defence = 1.1, speed = 7, attackSpeed = 10, runAt = 20, 
		spawnChance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 5, rupee = 30, loot = {{chance = 8000, id = 1}}, 
	}, 
	{
		name = 'Pidgey', health = 100, image = 'gfx/weiwen/pokemon/16.png', scaleX = 2, scaleY = 2, 
		attack = 1.2, defence = 1.2, speed = 10, attackSpeed = 7, runAt = 20, 
		spawnChance = {['rpg_mapb'] = {50}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 13, rupee = 60, loot = {}, 
		spc = {500, function(self) 
			tibia.radiusMessage("Pidgey uses sand attack!", self.x, self.y)
			sea.flashAtPosition(self.x, self.y, 100)
		end},
	}, 
	{
		name = 'Ratata', health = 100, image = 'gfx/weiwen/pokemon/19.png', scaleX = 1.5, scaleY = 1.5, 
		attack = 1.0, defence = 1.0, speed = 9, attackSpeed = 5, runAt = 20, 
		spawnChance = {['rpg_mapb'] = {100}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 7, rupee = 50, loot = {{chance = 8000, id = 4}}, 
	}, 
	{
		name = 'Spearow', health = 100, image = 'gfx/weiwen/pokemon/21.png', scaleX = 2, scaleY = 2, 
		attack = 1.4, defence = 1.0, speed = 10, attackSpeed = 7, runAt = 20, 
		spawnChance = {['rpg_mapb'] = {50}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 13, rupee =60, loot = {}, 
		spc = {2500, function(self, target, dist) 
			if not self.agility then
				tibia.radiusMessage("Spearow uses agility!", self.x, self.y)
				sea.effect("colorsmoke", self.x, self.y, 5, 5, 155, 255, 155)
				tibia.radiusSound("weapons/g_flash.wav", self.x, self.y)
				self._spd = self.config.speed
				self.config.speed = 10
				self.agility = true
				self.image.color = sea.Color.new(155, 255, 155)
				timerEx(5000, "tibia.config.monsterSkill.endAgility", 1, self)
			elseif dist <= 32 then
				self:hit(target, 10)
			end
		end},
	}, 
	{
		name = 'Ekans', health = 100, image = 'gfx/weiwen/pokemon/23.png', scaleX = 2, scaleY = 2, 
		attack = 1.8, defence = 1.2, speed = 7, attackSpeed = 8, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 10, rupee = 80, loot = {}, 
		spc = {500, function(self, target, dist) 
			if dist <= 96 then
				tibia.radiusMessage("Ekans uses poison sting!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Pikachu', health = 100, image = 'gfx/weiwen/pokemon/25.png', scaleX = 2, scaleY = 2, 
		attack = 2.1, defence = 2.1, speed = 7, attackSpeed = 7, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 25, rupee = 120, loot = {{chance = 5000, id = 103}, {chance = 250, id = 220}}, 
		spc = {500, function(self) 
			tibia.radiusMessage("Pikachu uses thundershock!", self.x, self.y)
			sea.explosion(self.x, self.y, 96, 40)
			sea.effect("colorsmoke", self.x, self.y, 100, 96, 255, 255, 0)
			sea.effect("colorsmoke", self.x, self.y, 75, 64, 255, 255, 255)
		end},
	}, 
	{
		name = 'Sandshrew', health = 100, image = 'gfx/weiwen/pokemon/27.png', scaleX = 2, scaleY = 2, 
		attack = 1.7, defence = 2.1, speed = 7, attackSpeed = 7, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {5, 20}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf, spawn.onixCave}
		}, 
		exp = 18, rupee = 120, loot = {}, 
		spc = {1000, function(self) 
			tibia.radiusMessage("Sandshrew uses sand attack!", self.x, self.y)
			sea.flashPositionAt(self.x, self.y, 100)
		end},
	},
	{
		name = 'NidoranF', health = 100, image = 'gfx/weiwen/pokemon/29.png', scaleX = 2, scaleY = 2, 
		attack = 1.8, defence = 1.2, speed = 7, attackSpeed = 8, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 10, rupee = 80, loot = {}, 
		spc = {750, function(self, target, dist) 
			if dist <= 96 then
				tibia.radiusMessage("NidoranF uses poison sting!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'NidoranM', health = 100, image = 'gfx/weiwen/pokemon/32.png', scaleX = 2, scaleY = 2, 
		attack = 1.8, defence = 1.2, speed = 7, attackSpeed = 8, runAt = 10, 
		spawnChance = {['rpg_mapb'] = {20}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 10, rupee = 80, loot = {}, 
		spc = {750, function(self, target, dist) 
			if dist <= 96 then
				tibia.radiusMessage("NidoranM uses horn attack!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Vulpix', health = 100, image = 'gfx/weiwen/pokemon/37.png', scaleX = 2, scaleY = 2, 
		attack = 2.2, defence = 1.8, speed = 7, attackSpeed = 8, runAt = 0, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		},  
		exp = 10, rupee = 100, loot = {{chance = 5000, id = 104}}, 
		spc = {500, function(self, target, dist) 
			tibia.radiusMessage("Vulpix uses flamethrower!", self.x, self.y)

			local x1, y1 = self.x, self.y
			local rot = math.atan2(target.y - y1, target.x - x1) + math.pi / 2
			local x2, y2 = math.sin(rot), -math.cos(rot)
			local fire = sea.Image.create("gfx/sprites/spot.bmp", 0, 0, 1)
			fire:setPosition(x1 + x2 * 64, y1 + y2 * 64, math.deg(rot) + 180)
			fire:scale(1.5, 2)
			fire.color = sea.Color.new(255, 64, 0)
			fire.blend = 1
			fire:destroyIn(500)

			sea.explosion(x1 + x2 * 100, y1 + y2 * 100, 48, 40)
			sea.explosion(x1 + x2 * 50, y1 + y2 * 50, 32, 40)
		end},
	}, 
	{
		name = 'Meowth', health = 100, image = 'gfx/weiwen/pokemon/52.png', scaleX = 2, scaleY = 2, 
		attack = 2.2, defence = 2.2, speed = 10, attackSpeed = 6, runAt = 0, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 25, rupee = 100, loot = {{chance = 1000, id = 230}},
	}, 
	{
		name = 'Mankey', health = 100, image = 'gfx/weiwen/pokemon/56.png', scaleX = 2, scaleY = 2, 
		attack = 2.5, defence = 1.8, speed = 10, attackSpeed = 6, runAt = 0, range = 48, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 25, rupee = 120, loot = {{chance = 1000, id = 300},{chance = 1000, id = 301},{chance = 1000, id = 302},{chance = 1000, id = 303},{chance = 1000, id = 304},{chance = 1000, id = 305},{chance = 1000, id = 306}}, 
		spc = {1000, function(self, target, dist) 
			if not self.rage then
				tibia.radiusMessage("Mankey uses rage!", self.x, self.y)
				sea.effect("colorsmoke", self.x, self.y, 5, 5, 255, 155, 155)
				tibia.radiusSound("weapons/g_flash.wav", self.x, self.y)
				self._atk = self.attack
				self.attack = 3.3
				self.rage = true
				self.image.color = sea.Color.new(255, 155, 155)
				timerEx(5000, "tibia.config.monsterSkill.endRage", 1, self)
			elseif dist <= 96 then
				tibia.radiusMessage("Mankey uses karate chop!", self.x, self.y)
				self:hit(target, 20)
			end
		end},
	}, 
	{
		name = 'Abra', health = 100, image = 'gfx/weiwen/pokemon/63.png', scaleX = 2, scaleY = 2, 
		attack = 0.6, defence = 1.0, speed = 5, attackSpeed = 10, runAt = 100, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.fullMap}
		}, 
		exp = 8, rupee = 50, loot = {{chance = 5000, id = 105}}, 
		spc = {2500, function(self) 
			tibia.radiusMessage("Abra uses teleport!", self.x, self.y)
			sea.effect("colorsmoke", self.x, self.y, 5, 5, 255, 255, 255)
			local dir = math.random(math.pi * 2)
			if self:move(dir, 40) or self:move(dir, -40) then
				sea.effect("colorsmoke", self.x, self.y, 5, 5, 255, 255, 255)
			end
		end},
	}, 
	{
		name = 'Gastly', health = 100, image = 'gfx/weiwen/pokemon/92.png', scaleX = 2, scaleY = 2, r = 64, g = 0, b = 64, 
		attack = 1.2, defence = 1.5, speed = 8, attackSpeed = 10, runAt = 50, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 8, rupee = 100, loot = {}, 
		spc = {1000, function(self, target, dist)
			if dist <= 64 and not target.tmp.paralyse then
				tibia.radiusMessage("Gastly uses lick!", self.x, self.y)
				target.tmp.paralyse = true
				target:message("You are paralysed.")
				sea.effect("colorsmoke", target.x, target.y, 5, 5, 64, 0, 64)
				timerEx(3000, "rem.paralyse", 1, target)
			elseif dist <= 32 then
				self:hit(target, 10)
			end
		end},
	}, 
	{
		name = 'Onix', health = 125, image = 'gfx/weiwen/pokemon/95.png', scaleX = 3, scaleY = 3, r = 144, g = 144, b = 144, 
		attack = 1.8, defence = 5.0, speed = 3, attackSpeed = 10, runAt = 0, range = 64, 
		spawnChance = {['rpg_mapb'] = {5}}, 
		spawn = {
			['rpg_mapb'] = {spawn.onixCave}
		}, 
		exp = 100, rupee = 300, loot = {{chance = 1000, id = 310},{chance = 1000, id = 311},{chance = 1000, id = 312},{chance = 1000, id = 313},{chance = 1000, id = 314},{chance = 1000, id = 315},{chance = 1000, id = 316}}, 
		spc = {1000, function(self) 
			if not self.harden then
				tibia.radiusMessage("Onix uses harden!", self.x, self.y)
				sea.effect("colorsmoke", self.x, self.y, 5, 5, 192, 192, 192)
				tibia.radiusSound("weapons/g_flash.wav", self.x, self.y)
				self._def = self.config.defence
				self.config.defence = 7.5
				self.harden = true
				self.image.color = sea.Color.new(155, 155, 255)
				timerEx(5000, "tibia.config.monsterSkill.endHarden", 1, self)
			end
		end},
	}, 
	{
		name = 'Voltorb', health = 100, image = 'gfx/weiwen/pokemon/100.png', scaleX = 2, scaleY = 2, r = 144, g = 144, b = 144, 
		attack = 2.3, defence = 2.3, speed = 5, attackSpeed = 8, runAt = 20, range = 48, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 30, rupee = 130, loot = {{chance = 5000, id = 103}}, 
		spc = {1000, function(self) 
			if self.health < 20 then
				tibia.radiusMessage("Voltorb uses selfdestruct!", self.x, self.y)
				sea.explosion(self.x, self.y, 128, 80)
				sea.effect("colorsmoke", self.x, self.y, 100, 128, 255, 128, 0)
				sea.effect("colorsmoke", self.x, self.y, 100, 128, 255, 255, 0)
				self:destroy()
			else
				tibia.radiusMessage("Voltorb uses thundershock!", self.x, self.y)
				sea.explosion(self.x, self.y, 96, 40)
				sea.effect("colorsmoke", self.x, self.y, 100, 96, 255, 255, 0)
				sea.effect("colorsmoke", self.x, self.y, 75, 64, 255, 255, 255)
			end
		end},
	}, 
	{
		name = 'Koffing', health = 100, image = 'gfx/weiwen/pokemon/109.png', scaleX = 2, scaleY = 2, r = 128, g = 128, b = 0, 
		attack = 2.0, defence = 1.7, speed = 4, attackSpeed = 10, runAt = 20, range = 48, 
		spawnChance = {['rpg_mapb'] = {10}}, 
		spawn = {
			['rpg_mapb'] = {spawn.bottomHalf}
		}, 
		exp = 30, rupee = 150, loot = {{chance = 5000, id = 106}}, 
		spc = {1000, function(self) 
			if self.health < 20 then
				tibia.radiusMessage("Koffing uses explosion!", self.x, self.y)
				sea.explosion(self.x, self.y, 128, 40)
				sea.effect("colorsmoke", self.x, self.y, 100, 128, 255, 128, 0)
				sea.effect("colorsmoke", self.x, self.y, 100, 128, 255, 255, 0)
				self:destroy()
			else
				tibia.radiusMessage("Koffing uses poison fog!", self.x, self.y)
				sea.explosion(self.x, self.y, 96, 40)
				sea.effect("colorsmoke", self.x, self.y, 100, 96, 128, 128, 0)
			end
		end},
	}, 
}

tibia.config.monsterSkill = {
	endAgility = function(self)
		self.speed = self._spd
		self._spd = nil
		self.image.color = sea.Color.white
		self.agility = nil
	end,
	endRage = function(id)
		self.attack = self._atk
		self._atk = nil
		self.image.color = sea.Color.white
		self.rage = nil
	end,
	endHarden = function(id)
		self.defence = self._def
		self._def = nil
		self.image.color = sea.Color.white
		self.harden = nil
	end,
}