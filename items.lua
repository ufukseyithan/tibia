ITEMS = {
	[0] = {
		name = ""
	}, 

	[1] = {
		name = "apple", 
		article = "an", 
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
		slot = 8, 
		fimage = "gfx/weiwen/torch.png",
		eimage = "gfx/sprites/flare3.bmp",
		escalex = 3, 
		escaley = 3, 
		blend = 1, 
		static = 1, 
		func = equip,
	}, 

	[3] = {
		name = "hourglass", 
		plural = "hourglasses", 
		article = "an", 
		r = 180, g = 180, b = 180, 
		action = {"wear","check time"}, 
		slot = 8, 
		func = {equip, function(id) msg2(id,ITEMS[3].desc) end},
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
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id,itemslot,itemid,equip)
			radiusmsg(player(id,"name") .. " casts a fireball rune.", player(id,"x"), player(id,"y"))
			explosion(player(id, "x"), player(id,"y"), 64, 15, id)
			local pos = player(id,"x") .. " " .. player(id,"y")
			parse("effect \"colorsmoke\" " .. pos .. " 100 64 255 128 0;")
			parse("effect \"colorsmoke\" " .. pos .. " 75 64 255 0 0")
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[101] = {
		name = "water gun rune", 
		desc = "You may only use it once.", 
		r = 128, g = 128, b = 255, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id,itemslot,itemid,equip)
			radiusmsg(player(id,"name") .. " casts a waterball rune.", player(id,"x"), player(id,"y"))
			explosion(player(id, "x"), player(id,"y"), 64, 15, id)
			local pos = player(id,"x") .. " " .. player(id,"y")
			parse("effect \"colorsmoke\" " .. pos .. " 100 64 255 255 255")
			parse("effect \"colorsmoke\" " .. pos .. " 75 64 128 128 255")
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[102] = {
		name = "healing rune", 
		desc = "You may only use it once.", 
		r = 128, g = 255, b = 255, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id,itemslot,itemid,equip)
			radiusmsg(player(id,"name") .. " casts a healing rune.", player(id,"x"), player(id,"y"))
			explosion(player(id, "x"), player(id,"y"), 32, -30, id)
			local pos = player(id,"x") .. " " .. player(id,"y")
			parse("effect \"colorsmoke\" " .. pos .. " 5 5 128 255 255")
			radiussound("materials/glass2.wav", player(id,"x"), player(id,"y"))
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[103] = {
		name = "thundershock rune", 
		desc = "An electrical attack that may paralyze the foe.",  
		r = 255, g = 255, b = 0, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id,itemslot,itemid,equip)
			radiusmsg(player(id,"name") .. " casts a thundershock rune.", player(id,"x"), player(id,"y"))
			explosion(player(id, "x"), player(id,"y"), 64, 15, id)
			local pos = player(id,"x") .. " " .. player(id,"y")
			parse("effect \"colorsmoke\" " .. pos .. " 100 64 255 255 0")
			parse("effect \"colorsmoke\" " .. pos .. " 75 64 255 255 255")
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[104] = {
		name = "flamethrower rune", 
		desc = "You may only use it once.", 
		r = 185, g = 25, b = 25, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id,itemslot,itemid,equip)
			radiusmsg(player(id,"name") .. " casts a firewave rune.", player(id,"x"), player(id,"y"))
			parse("equip " .. id .. " 46")
			parse("setweapon " .. id .. " 46")
			timer(1000, "parse", "strip " .. id .. " 46")
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[105] = {
		name = "teleport rune", 
		desc = "You may only use it once.", 
		r = 255, g = 255, b = 255, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id, itemslot, itemid, equip)
			radiusmsg(player(id,"name") .. " is casting a teleport rune.", player(id,"x"), player(id,"y"))
			timer(1500, "ITEMFUNCTIONS.teleport", id .. ';' .. player(id, 'health') .. ';' .. (equip and -itemslot or itemslot))
		end,equip}, 
		teleport = function(p)
			local id, health, itemslot = unpack(p:split(';'))
			id, health, itemslot = tonumber(id), tonumber(health), tonumber(itemslot)
			if player(id, 'health') == health then
				radiusmsg(player(id,"name") .. " completed casting a teleport rune.", player(id,"x"), player(id,"y"))
				parse("effect \"colorsmoke\" " .. player(id,"x") .. " " .. player(id,"y") .. " 5 5 255 255 255")
				local pos = PLAYERS[id].Spawn[1] .. " " .. PLAYERS[id].Spawn[2]
				parse("effect \"colorsmoke\" " .. pos .. " 5 5 255 255 255")
				parse("setpos " .. id .. " " .. pos)
				radiussound("materials/glass2.wav", player(id,"x"), player(id,"y"))
				destroyitem(id, math.abs(itemslot), itemslot < 0)
			else
				radiusmsg(player(id,"name") .. " failed to cast a teleport rune.", player(id,"x"), player(id,"y"))
			end
		end
	},

	[106] = {
		name = "poison fog rune", 
		desc = "You may only use it once.", 
		r = 128, g = 128, b = 0, 
		action = {"cast","hold"}, 
		slot = 9, 
		fimage = "gfx/weiwen/rune.png", 
		func = {function(id, itemslot, itemid, equip)
			radiusmsg(player(id,"name") .. " casts a poison fog rune.", player(id,"x"), player(id,"y"))
			explosion(player(id, "x"), player(id,"y"), 64, 15, id)
			local pos = player(id,"x") .. " " .. player(id,"y")
			parse("effect \"colorsmoke\" " .. pos .. " 100 96 128 128 0")
			destroyitem(id, itemslot, equip)
		end,equip},
	},

	[200] = {
		name = "white bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 255, g = 255, b = 255,
	},

	[201] = {
		name = "pink bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 255, g = 128, b = 255,
	},

	[202] = {
		name = "green bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 128, g = 192, b = 0,
	},

	[203] = {
		name = "blue bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 0, g = 128, b = 192,
	},

	[204] = {
		name = "dark red bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 128, g = 0, b = 0,
	},

	[205] = {
		name = "light green bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 128, g = 255, b = 128,
	},

	[206] = {
		name = "light blue bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 128, g = 128, b = 255,
	},

	[207] = {
		name = "yellow bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 255, g = 255, b = 0,
	},

	[208] = {
		name = "orange bed",
		article = "an",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
		heal = 5, 
		r = 255, g = 128, b = 0,
	},

	[209] = {
		name = "brown bed",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/bed.png", 
		offsety = 16,
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
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-209)%4)+210; itemactions(id,itemslot) end,
	},

	[211] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 255, g = 255, b = 255,
		rot = 90,
		heal = 3, 
		action = "rotate|West", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-209)%4)+210; itemactions(id,itemslot) end,
	},

	[212] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 180,
		heal = 3, 
		r = 255, g = 255, b = 255,
		action = "rotate|North", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-209)%4)+210; itemactions(id,itemslot) end,
	},

	[213] = {
		name = "white chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 270,
		heal = 3, 
		r = 255, g = 255, b = 255,
		action = "rotate|East", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-209)%4)+210; itemactions(id,itemslot) end,
	},

	[214] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 169, g = 106, b = 44,
		rot = 0,
		heal = 3, 
		action = "rotate|South", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-213)%4)+214; itemactions(id,itemslot) end,
	},

	[215] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		r = 169, g = 106, b = 44,
		rot = 90,
		heal = 3, 
		action = "rotate|West", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-213)%4)+214; itemactions(id,itemslot) end,
	},

	[216] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 180,
		heal = 3, 
		r = 169, g = 106, b = 44,
		action = "rotate|North", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-213)%4)+214; itemactions(id,itemslot) end,
	},

	[217] = {
		name = "brown chair",
		desc = "Used to furnish your house.",
		fimage = "gfx/weiwen/chair.png", 
		rot = 270,
		heal = 3, 
		r = 169, g = 106, b = 44,
		action = "rotate|East", 
		func = function(id,itemslot,itemid) PLAYERS[id].Inventory[itemslot] = ((itemid-213)%4)+214; itemactions(id,itemslot) end,
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
		func = function(id,itemslot,itemid)
			if PLAYERS[id].tmp.exhaust.use then
				return
			end
			PLAYERS[id].tmp.exhaust.use = true
			timer(CONFIG.EXHAUST.USE, rem.useExhaust, id)
			radiusmsg(player(id,"name") .. " flips a coin. " .. ((math.random(2) == 1) and "Heads!" or "Tails!"), player(id,"x"), player(id,"y"))
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
		func = function(id,itemslot,itemid)
			if PLAYERS[id].tmp.exhaust.use then
				return
			end
			PLAYERS[id].tmp.exhaust.use = true
			timer(CONFIG.EXHAUST.USE, rem.useExhaust, id)
			radiusmsg(player(id,"name") .. " rolls a " .. math.random(1, 6) .. ".", player(id,"x"), playerw(id,"y"))
		end,
	}, 

	[300] = {
		name = "leather helmet", 
		desc = "Protect yourself from headshots!", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		slot = 1, 
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
		slot = 2, 
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
		slot = 5, 
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
		slot = 6, 
		fimage = "gfx/weiwen/boots.png",  
		speed = 2, 
		func = equip,
	},

	[304] = {
		name = "wooden sword", 
		desc = "Mostly used for training.", 
		r = 128, g = 64, b = 0, 
		action = "equip", 
		slot = 3, 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetx = 6,
		offsety = 17,
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
		slot = 4, 
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
		slot = 3, 
		eimage = "gfx/weiwen/club.png", 
		fimage = "gfx/weiwen/club.png", 
		offsety = 14,
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
		slot = 3, 
		twohand = true, 
		eimage = "gfx/weiwen/bow.png", 
		fimage = "gfx/weiwen/bow.png", 
		offsety = 9,
		equip = 34,
		atk = 0.1, 
		speed = -2.5, 
		func = equip,
	},

	[310] = {
		name = "stone helmet", 
		r = 128, g = 128, b = 128, 
		action = "equip", 
		slot = 1, 
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
		slot = 2, 
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
		slot = 5, 
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
		slot = 6, 
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
		slot = 3, 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetx = 6,
		offsety = 17,
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
		slot = 4, 
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
		slot = 3, 
		eimage = "gfx/weiwen/mace.png", 
		fimage = "gfx/weiwen/mace.png", 
		offsetx = 4, 
		offsety = 20,
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
		slot = 1, 
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
		slot = 2, 
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
		slot = 5, 
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
		slot = 6, 
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
		slot = 3, 
		eimage = "gfx/weiwen/sword.png", 
		fimage = "gfx/weiwen/sword.png", 
		offsetx = 6,
		offsety = 17,
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
		slot = 4, 
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
		slot = 3, 
		eimage = "gfx/weiwen/mace.png", 
		fimage = "gfx/weiwen/mace.png", 
		offsetx = 4, 
		offsety = 20,
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
		slot = 7, 
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
		slot = 7, 
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
		slot = 7, 
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
		slot = 7, 
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
		slot = 7, 
		ground = true, 
		water = true, 
		fimage = "gfx/weiwen/horse.png",  
		eimage = "gfx/weiwen/horse.png",  
		fscalex = 1.2, 
		fscaley = 0.8, 
		escalex = 1.2, 
		escaley = 0.8, 
		offsety = 20, 
		speed = 25, 
		def = -0.5, 
		level = 10, 
		func = equip,
	},
	
	[1337] = {
		name = 'money', 
		article = 'some', 
		r = 0, g = 150, b = 0, 
		fimage = 'gfx/weiwen/money.png', 
	}
}
ITEMFUNCTIONS = {}
ITEMFUNCTIONS.teleport = ITEMS[105].teleport

for k, v in pairs(ITEMS) do
	v.article = v.article or "a"
	v.plural = v.plural or v.name .. "s"
	v.action = type(v.action) == "table" and v.action or {v.action}
	v.func = type(v.func) == "table" and v.func or {v.func}
end