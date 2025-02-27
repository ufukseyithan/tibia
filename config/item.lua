local equip = sea.Player.equipItem
local eat = sea.Player.eat

tibia.config.item = {
	[0] = {
		name = ""
	}, 

	[1] = {
		name = "apple", 
		article = "an", 
		stackable = true,
		desc = "No visible worms.", 
		r = 255, g = 0, b = 0, 
		action = "eat", 
		food = function() return math.random(10,20) end, 
		fimage = "gfx/weiwen/apple.png", 
		func = eat,
	}, 

	[2] = {
		name = "torch",
		plural = "torches", 
		desc = "Allows you to see clearly in the dark.",
		r = 191, g = 213, b = 128,
		action = "hold", 
		equipSlot = "Accessories", 
		fimage = "gfx/weiwen/torch.png",
		eimage = "<light>",
		escalex = -1,
		static = 1, 
		func = equip,
	}, 

	[3] = {
		name = "hourglass", 
		plural = "hourglasses", 
		article = "an", 
		r = 180, g = 180, b = 180, 
		action = {"wear","check time"}, 
		equipSlot = "Accessories", 
		func = {equip, function(player) player:message(tibia.config.item[3].desc) end},
	},
	
	[4] = {
		name = "cheese", 
		desc = "A solid food prepared from the pressed curd of milk.", 
		r = 255, g = 255, b = 0, 
		action = "eat", 
		food = function() return math.random(10,20) end, 
		fimage = "gfx/weiwen/cheese.png", 
		func = eat,
	}, 

	[5] = {
		name = "pizza", 
		desc = "Italian open pie made of thin bread dough spread with a spiced mixture of tomato sauce and cheese.", 
		action = "eat", 
		food = function() return math.random(25,50) end, 
		fimage = "gfx/weiwen/pizza.png", 
		func = eat,
	},

	[100] = {
		name = "ember rune", 
		desc = "You may only use it once.", 
		r = 128, g = 0, b = 0, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a fireball rune.', player.x, player.y)
			sea.explosion(player.x, player.y, 64, 15, player.id)
			sea.effect("colorsmoke", player.x, player.y, 100, 64, 255, 128, 0)
			sea.effect("colorsmoke", player.x, player.y, 75, 64, 255, 0, 0)
			self:destroy()
		end, equip},
	},

	[101] = {
		name = "water gun rune", 
		desc = "You may only use it once.", 
		r = 128, g = 128, b = 255, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a water gun rune.', player.x, player.y)
			sea.explosion(player.x, player.y, 64, 15, player.id)
			sea.effect("colorsmoke", player.x, player.y, 100, 64, 255, 255, 255)
			sea.effect("colorsmoke", player.x, player.y, 75, 64, 128, 128, 255)
			self:destroy()
		end, equip},
	},

	[102] = {
		name = "healing rune", 
		desc = "You may only use it once.", 
		r = 128, g = 255, b = 255, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a healing rune.', player.x, player.y)
			sea.explosion(player.x, player.y, 32, -30, player.id)
			sea.effect("colorsmoke", player.x, player.y, 5, 5, 128, 255, 255)
			sea.Player.playSoundForAll("materials/glass2.wav", player.x, player.y)
			self:destroy()
		end, equip},
	},

	[103] = {
		name = "thundershock rune", 
		desc = "An electrical attack that may paralyze the foe.",  
		r = 255, g = 255, b = 0, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a thundershock rune.', player.x, player.y)
			sea.explosion(player.x, player.y, 64, 15, player.id)
			sea.effect("colorsmoke", player.x, player.y, 100, 64, 255, 255, 0)
			sea.effect("colorsmoke", player.x, player.y, 75, 64, 255, 255, 255)
			self:destroy()
		end, equip},
	},

	[104] = {
		name = "flamethrower rune", 
		desc = "You may only use it once.", 
		r = 185, g = 25, b = 25, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a flamethrower rune.', player.x, player.y)
			player:equipAndSet(46)
			timerEx(1000, function()
				player:strip(46)
			end)
			self:destroy()
		end, equip},
	},

	[105] = {
		name = "teleport rune", 
		desc = "You may only use it once.", 
		r = 255, g = 255, b = 255, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			local health = player.health
			tibia.radiusMessage(player.name..' casts a teleport rune.', player.x, player.y)

			timerEx(1500, function()
				if player.health == health then
					tibia.radiusMessage(player.name..' failed to cast a teleport rune.', player.x, player.y)
					sea.effect('colorsmoke', player.x, player.y, 5, 5, 255, 255, 255)

					local spawnX, spawnY = player.respawnPosition[1], player.respawnPosition[2]
					sea.effect('colorsmoke', spawnX, spawnY, 5, 5, 255, 255, 255)
					player:setPosition(spawnX, spawnY)

					sea.Player.playSoundForAll("materials/glass2.wav", player.x, player.y)

					self:destroy()
				else
					tibia.radiusMessage(player.name..' failed to cast a teleport rune.', player.x, player.y)
				end
			end)

		end, equip}
	},

	[106] = {
		name = "poison fog rune", 
		desc = "You may only use it once.", 
		r = 128, g = 128, b = 0, 
		action = {"cast","hold"}, 
		equipSlot = "Runes", 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(player, self, equip)
			tibia.radiusMessage(player.name..' casts a poison fog rune.', player.x, player.y)
			sea.explosion(player.x, player.y, 64, 15, player.id)
			sea.effect("colorsmoke", player.x, player.y, 100, 96, 128, 128, 0)
			self:destroy()
		end, equip},
	},

	[200] = {
		name = "white bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 255, g = 255, b = 255,
	},

	[201] = {
		name = "pink bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 255, g = 128, b = 255,
	},

	[202] = {
		name = "green bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 128, g = 192, b = 0,
	},

	[203] = {
		name = "blue bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 0, g = 128, b = 192,
	},

	[204] = {
		name = "dark red bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 128, g = 0, b = 0,
	},

	[205] = {
		name = "light green bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 128, g = 255, b = 128,
	},

	[206] = {
		name = "light blue bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 128, g = 128, b = 255,
	},

	[207] = {
		name = "yellow bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 255, g = 255, b = 0,
	},

	[208] = {
		name = "orange bed",
		article = "an",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 255, g = 128, b = 0,
	},

	[209] = {
		name = "brown bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsetY = 16,
		heal = 5, 
		r = 128, g = 64, b = 0,
	},

	[210] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 255, g = 255, b = 255,
		rot = 0,
		heal = 3, 
		action = "rotate|South", 
		func = function(player, self)
			self:changeId(((self.id - 209) % 4) + 210)
		end,
	},

	[211] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 255, g = 255, b = 255,
		rot = 90,
		heal = 3, 
		action = "rotate|West", 
		func = function(player, self)
			self:changeId(((self.id - 209) % 4) + 210)
		end,
	},

	[212] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 180,
		heal = 3, 
		r = 255, g = 255, b = 255,
		action = "rotate|North", 
		func = function(player, self)
			self:changeId(((self.id - 209) % 4) + 210)
		end,
	},

	[213] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 270,
		heal = 3, 
		r = 255, g = 255, b = 255,
		action = "rotate|East", 
		func = function(player, self)
			self:changeId(((self.id - 209) % 4) + 210)
		end,
	},

	[214] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 169, g = 106, b = 44,
		rot = 0,
		heal = 3, 
		action = "rotate|South", 
		func = function(player, self)
			self:changeId(((self.id - 213) % 4) + 214)
		end
	},

	[215] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 169, g = 106, b = 44,
		rot = 90,
		heal = 3, 
		action = "rotate|West", 
		func = function(player, self)
			self:changeId(((self.id - 213) % 4) + 214)
		end
	},

	[216] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 180,
		heal = 3, 
		r = 169, g = 106, b = 44,
		action = "rotate|North", 
		func = function(player, self)
			self:changeId(((self.id - 213) % 4) + 214)
		end
	},

	[217] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 270,
		heal = 3, 
		r = 169, g = 106, b = 44,
		action = "rotate|East", 
		func = function(player, self)
			self:changeId(((self.id - 213) % 4) + 214)
		end
	},

	[218] = {
		name = "white table",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/table.png", 
		r = 255, g = 255, b = 255,
	},

	[219] = {
		name = "brown table",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/table.png", 
		r = 169, g = 106, b = 44,
	},

	[220] = {
		name = "pikachu doll",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/pokemon/25.png", 
	},

	[221] = {
		name = "bulbasaur doll",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/pokemon/1.png", 
	},

	[222] = {
		name = "charmander doll",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/pokemon/4.png", 
	},

	[223] = {
		name = "squirtle doll",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/pokemon/7.png", 
	},
	
	[230] = {
		name = "coin", 
		desc = "Heads or tails?", 
		r = 255, g = 200, b = 0, 
		action = "flip", 
		fimage = "gfx/weiwen/circle.png", 
		func = function(player, self, equip)
			if player:exhaust('use') then
				tibia.radiusMessage(player.name .. ' flips a coin. '..((math.random(2) == 1) and "Heads!" or "Tails!"), player.x, player.y)
			end
		end,
	}, 
	
	[231] = {
		name = "dice", 
		desc = "1d6.",
		r = 255, g = 192, b = 128, 
		action = "roll", 
		fimage = "gfx/weiwen/table.png", 
		fscalex = 0.5, 
		fscaley = 0.5, 
		func = function(player, self, equip)
			if player:exhaust('use') then
				tibia.radiusMessage(player.name .. " rolls a " .. math.random(1, 6) .. ".", player.x, player.y)
			end
		end,
	}, 

	[300] = {
		name = "leather helmet", 
		desc = "Protect yourself from headshots!", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Head", 
		eimage = "gfx/weiwen/helmet.png", 
		fimage = "gfx/weiwen/helmet.png", 
		def = 0.05, 
		speed = -1,
		func = equip,
	},

	[301] = {
		name = "leather torso", 
		desc = "A few holes here and there, but still usable.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Torso", 
		eimage = "gfx/weiwen/armour.png", 
		fimage = "gfx/weiwen/farmour.png", 
		def = 0.1, 
		speed = -1,
		func = equip,
	},

	[302] = {
		name = "leather legs", 
		plural = "pairs of leather legs", 
		article = "a pair of", 
		desc = "A few holes here and there, but still usable.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Legs", 
		fimage = "gfx/weiwen/legs.png", 
		def = 0.07, 
		speed = 1,
		func = equip,
	},

	[303] = {
		name = "leather boots", 
		plural = "pairs of leather boots", 
		article = "a pair of", 
		desc = "Waterproof.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Feet", 
		fimage = "gfx/weiwen/boots.png",  
		speed = 2, 
		func = equip,
	},

	[304] = {
		name = "wooden sword", 
		desc = "Mostly used for training.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetX = 6,
		offsetY = 17,
		equip = 69,
		atk = 0.25, 
		speed = -1, 
		func = equip,
	},

	[305] = {
		name = "wooden shield", 
		desc = "Mostly used for training.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Left Hand", 
		eimage = "gfx/weiwen/shield.png", 
		fimage = "gfx/weiwen/fshield.png", 
		equip = 41,
		def = 0.2, 
		speed = -2, 
		func = equip,
	},

	[306] = {
		name = "wooden club", 
		desc = "Now you can be a caveman too!", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/club.png", 
		fimage = "gfx/weiwen/club.png", 
		offsetY = 14,
		equip = 78,
		atk = 0.35, 
		speed = -2, 
		func = equip,
	},

	[307] = {
		name = "wooden crossbow", 
		desc = "It requires you to hold it with two hands.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		equipSlot = "Right Hand", 
		twohand = true, 
		eimage = "gfx/weiwen/bow.png", 
		fimage = "gfx/weiwen/bow.png", 
		offsetY = 9,
		equip = 46,
		atk = 0.1, 
		speed = -2.5, 
		func = equip,
	},

	[310] = {
		name = "stone helmet", 
		r = 128, g = 128, b = 128, 
		action = "equip", 
		equipSlot = "Head", 
		eimage = "gfx/weiwen/helmet.png", 
		fimage = "gfx/weiwen/helmet.png", 
		def = 0.1, 
		speed = -1.5,
		level = 5, 
		func = equip,
	},

	[311] = {
		name = "stone armour", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Torso", 
		eimage = "gfx/weiwen/armour.png", 
		fimage = "gfx/weiwen/farmour.png", 
		def = 0.2, 
		speed = -1.5,
		level = 5, 
		func = equip,
	},

	[312] = {
		name = "stone leggings", 
		plural = "pairs of iron leggings", 
		article = "a pair of", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Legs", 
		fimage = "gfx/weiwen/legs.png", 
		def = 0.15, 
		speed = -0.5,
		level = 5, 
		func = equip,
	},

	[313] = {
		name = "stone boots", 
		plural = "pairs of iron boots", 
		article = "a pair of", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Feet", 
		fimage = "gfx/weiwen/boots.png",  
		def = 0.1, 
		speed = -0.5, 
		level = 5, 
		func = equip,
	},

	[314] = {
		name = "stone sword", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetX = 6,
		offsetY = 17,
		equip = 69,
		atk = 0.5, 
		speed = -2, 
		level = 5, 
		func = equip,
	},

	[315] = {
		name = "stone shield", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Left Hand", 
		eimage = "gfx/weiwen/shield.png", 
		fimage = "gfx/weiwen/fshield.png", 
		equip = 41,
		def = 0.4, 
		speed = -3, 
		level = 5, 
		func = equip,
	},

	[316] = {
		name = "stone mace", 
		r = 128, g = 128, b = 128,
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/mace.png", 
		fimage = "gfx/weiwen/mace.png", 
		offsetX = 4, 
		offsetY = 20,
		equip = 78,
		atk = 0.7, 
		speed = -3, 
		level = 5, 
		func = equip,
	},

	[320] = {
		name = "bronze helmet", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Head", 
		eimage = "gfx/weiwen/helmet.png", 
		fimage = "gfx/weiwen/helmet.png", 
		def = 0.15, 
		speed = -1.3,
		level = 15, 
		func = equip,
	},

	[321] = {
		name = "bronze armour", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Torso", 
		eimage = "gfx/weiwen/armour.png", 
		fimage = "gfx/weiwen/farmour.png", 
		def = 0.3, 
		speed = -1.3,
		level = 15, 
		func = equip,
	},

	[322] = {
		name = "bronze leggings", 
		plural = "pairs of bronze leggings", 
		article = "a pair of", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Legs", 
		fimage = "gfx/weiwen/legs.png", 
		def = 0.2, 
		speed = -0.4,
		level = 15, 
		func = equip,
	},

	[323] = {
		name = "bronze boots", 
		plural = "pairs of bronze boots", 
		article = "a pair of", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Feet", 
		fimage = "gfx/weiwen/boots.png",  
		def = 0.15, 
		speed = -0.4, 
		level = 15, 
		func = equip,
	},

	[324] = {
		name = "bronze sword", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetX = 6,
		offsetY = 17,
		equip = 69,
		atk = 0.7, 
		speed = -1.5, 
		level = 15, 
		func = equip,
	},

	[325] = {
		name = "bronze shield", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Left Hand", 
		eimage = "gfx/weiwen/shield.png", 
		fimage = "gfx/weiwen/fshield.png", 
		equip = 41,
		def = 0.6, 
		speed = -2.5, 
		level = 15, 
		func = equip,
	},

	[326] = {
		name = "bronze mace", 
		r = 200, g = 100, b = 0, 
		action = "equip", 
		equipSlot = "Right Hand", 
		eimage = "gfx/weiwen/mace.png", 
		fimage = "gfx/weiwen/mace.png", 
		offsetX = 4, 
		offsetY = 20,
		equip = 78,
		atk = 0.9, 
		speed = -3, 
		level = 15, 
		func = equip,
	},

	[400] = {
		name = "brown horse", 
		desc = "You move faster with it, but are unable to attack with it. Your defence is also reduced significantly.", 
		r = 162, g = 107, b = 0, 
		action = "ride", 
		equipSlot = "Mount", 
		ground = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png", 
		speed = 20, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},

	[401] = {
		name = "white horse", 
		desc = "You move faster with it, but are unable to attack with it. Your defence is also reduced significantly.", 
		r = 255, g = 255, b = 255, 
		action = "ride", 
		equipSlot = "Mount", 
		ground = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png", 
		speed = 20, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},

	[402] = {
		name = "grey horse", 
		desc = "You move faster with it, but are unable to attack with it. Your defence is also reduced significantly.", 
		r = 175, g = 177, b = 186, 
		action = "ride", 
		equipSlot = "Mount", 
		ground = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png", 
		speed = 20, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},

	[403] = {
		name = "black horse", 
		desc = "You move faster with it, but are unable to attack with it. Your defence is also reduced significantly.", 
		r = 50, g = 50, b = 50, 
		action = "ride", 
		equipSlot = "Mount", 
		ground = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png", 
		speed = 20, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},

	[404] = {
		name = "seahorse", 
		desc = "You move faster with it, but are unable to attack with it. Your defence is also reduced significantly.", 
		r = 32, g = 121, b = 155, 
		action = "ride", 
		equipSlot = "Mount", 
		ground = true, 
		water = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png",  
		fscalex = 1.2, 
		fscaley = 0.8, 
		escalex = 1.2, 
		escaley = 0.8, 
		offsetY = 20, 
		speed = 25, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},
	
	[1337] = {
		name = 'Rupee', 
		currency = true,
		article = 'some', 
		r = 0, g = 150, b = 0, 
		fimage = 'gfx/weiwen/rupee.png', 
	}
}

for k, v in pairs(tibia.config.item) do
	v.article = v.article or "a"
	v.plural = v.plural or v.name.."s"
	v.action = type(v.action) == "table" and v.action or {v.action}
	v.func = type(v.func) == "table" and v.func or {v.func}
end