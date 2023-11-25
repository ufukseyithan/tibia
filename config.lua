tibia.config = {
	password = "", 

	inventoryCapacity = 50, 
	
	-- maximum number of monsters on the map at one time. if set to 0, monsters.lua is not loaded at all.
	maxMonsters = 192, 
	
	-- maximum height an item stack on the ground can be (they can be as high as you want, but only the top few will be shown when this is set).
	maxHeight = 5, 
	
	exp = {
		-- function for calculation experience for each level.
		calc = function(level)
			level = level - 1
			return (level) ^ 3 - 3 * (level) ^ 2 + 8 * (level)
		end
	}, 
	
	stats = {'Experience', 'Level', 'Money'}, --ignore

	-- slot names for each slot. can be customised.
	-- the order is important since the last item will always be renderer last
	slots = {
		"Legs", 
		"Feet", 
		"Mount", 
		"Accessories", 
		
		"Right Hand", 
		"Left Hand", 
		"Runes", 
		"Torso", 
		"Head", 
	}, 
	
	-- colour for hudtxt (only one for now... no point then)
	hudTxt = {
		safe = 49, 
	}, 
	-- pixels to leave between each line of hudtxt
	pixels = 14, 
	
	-- used for ^[1-9a-z] colour codes
	colours = {
		"192192192",
		"128128128",
		"255000000",
		"000255000",
		"000000255",
		"255255000",
		"000255255",
		"255000255",
		"128000000",
		"000128000",
		"128128000",
		"000000128",
		"000128128",
		"128000128",
		"255128128",
		"128255128",
		"128128255",
		"255128000",
		"000255128",
		"128000255",
		"255000128",
		"128255000",
		"000128255",
		"128000000",
		"000128000",
		"000000128",
		"255128255",
		"128255255",
		"255128255",
		"192128128",
		"128192128",
		"128128192",
		"192192128",
		"128192192",
		"192128192",
		[0] = "255255255",
	}, 
	
	-- tiles that cannot be walked on unless you have an item that allows water walking (or was it a specific mount only?)
	waterTiles = {34},
	
	-- if map data (safe zone, houses, monster spawn etc) is not found, use this
	defaultMap = 'rpg_mapb', 
	
	-- experience gained will be multiplied by this value.
	expRAte = 1, 
	-- money loot will be multiplied by this value.
	moneyRate = 1, 
	-- drop chance will be multiplied by this value.
	dropRate = 1, 
	-- player death money loot will be multiplied by this value.
	playerMoneyRate = 1, 
	-- player drop chance will be this value out of 10000. i.e. 2000 means 20%
	playerDropRate = 2000, 
	
	exhaust = {
		-- ms after each talk, any faster, the message will not be showed
		talk = 500, 
		-- ms after each pick up attempt, any faster, the pick up will be aborted
		pick = 500, 
		-- ms after each use attempt, any faster, the use will be aborted
		use = 2000, 
	},
}

tibia.config.safeZone = { -- safezones e.g. {{x1, y1},{x2, y2}} means a rectangular area from (x1, y1) to (x2, y2)
	['rpg_mapb'] = {
		{{2,2},{29,19}},
		{{74,0},{108,44}},
		{{90,90},{99,99}},
		{{0,20},{12,33}},
		{{7,84},{15,90}},
		{{75,49},{82,60}},
		{{83,57},{92,60}},
		{{107,36},{122,40}},
		{{109,46},{149,99}},
		{{70,122},{79,131}},
	}
}

tibia.config.noPvpZone = { -- non-pvp zones, preventing pvp within the area. syntax same as above
	['rpg_mapb'] = {
	}
}

tibia.config.noMonstersZone = { -- no-monsters zones, preventing monsters spawning/entering/attacking inside the area. syntax same as above
	['rpg_mapb'] = {
		{{88,32},{98,43}},
	}
}

tibia.config.pvpZone = { -- deathmatch zones, if a player dies in this area, he will drop $100 and nothing else. monsters DO spawn here now, but you can set it to be a no-monsters zone to prevent that. guess the syntax
	['rpg_mapb'] = {
		{{88,32},{98,43}},
	}
}

--[[ 	houses... i'll try to explain
		pos1 to pos2 forms a rectangular area similar to above. this represents the area the house controls.
		ent is right outside the main entrance of the house. IT IS NOT PART OF THE HOUSE! this is typically used when you kick yourself out of your house
			that reminds me, i have to make a command to kick people from your house
		door is the main entrance of the house. this should be in the house itself. is used when buying and checking house info, among others
		price is the price per day. this includes server offline time!
		owner should be left as nil
		endtime should be left as nil
		allow should be left as an empty array
		doors is the allow list of the doors that belong to the house.
			this also helps to open/close doors as long as you name the triggers in the houses as HOUSEID_DOORID
			e.g. for the first house, doors = {[1] = {}} means a door with a trigger 1_1 will open if you have door rights.
			
		I DID NOT NOTICE THAT I HAVE DONE DOCUMENTATION FOR houses ALREADY. I WILL JUST COPY IT OVER AND LEAVE TWO SETS FOR YOU TO READ.
		
		houses
		For house areas, they have to be rectangular.
		Fill in the house areas in config.lua

		e.g.
		{pos1 = {87,2}, pos2 = {89,5}, ent = {89,6}, door = {89,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}},

		pos1 and pos2 are the top left and bottom right of the rectangle respectively.
		ent is tile pos of the tile infront of the door, used to buy the house.
		door is tile pos of the main door of the house.
		price is the price of the house per 24 hours of ownership.
		owner is the default owner of the house. just leave it as nil, for initialisation purposes.
		endtime is the time the house ownership ends, in Unix time.
		allow is the list of allowed players, just leave it as a blank table for initialisation purposes.
		doors is the list of doors as represented in the map.
		e.g. if the name of the door is 12_3, it is door 3 of house 12.
]]
tibia.config.houses = { 
	['rpg_mapb'] = {
		{pos1 = {87,2}, pos2 = {89,5}, ent = {89,6}, door = {89,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 1_1
		{pos1 = {91,2}, pos2 = {93,5}, ent = {93,6}, door = {93,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 2_1
		{pos1 = {95,2}, pos2 = {97,5}, ent = {97,6}, door = {97,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 3_1
		
		{pos1 = {0,21}, pos2 = {3,24}, ent = {4,24}, door = {3,24}, price = 450, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 4_1
		{pos1 = {0,26}, pos2 = {3,32}, ent = {4,26}, door = {3,26}, price = 900, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}}}, -- 5_1, 5_2
		{pos1 = {8,21}, pos2 = {12,24}, ent = {7,24}, door = {8,24}, price = 450, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 6_1
		{pos1 = {8,26}, pos2 = {12,32}, ent = {7,26}, door = {8,26}, price = 900, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}}}, -- 7_1, 7_2
		
		{pos1 = {99,2}, pos2 = {101,5}, ent = {101,6}, door = {101,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 8_1
		{pos1 = {103,2}, pos2 = {105,5}, ent = {105,6}, door = {105,5}, price = 300, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 9_1
		
		{pos1 = {127,86}, pos2 = {131,90}, ent = {131,91}, door = {131,90}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 10_1
		{pos1 = {133,86}, pos2 = {137,90}, ent = {137,91}, door = {137,90}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 11_1
		{pos1 = {139,86}, pos2 = {143,90}, ent = {143,91}, door = {143,90}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 12_1
		{pos1 = {124,93}, pos2 = {128,97}, ent = {124,92}, door = {124,93}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 13_1
		{pos1 = {130,93}, pos2 = {134,97}, ent = {130,92}, door = {130,93}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 14_1
		{pos1 = {136,93}, pos2 = {140,97}, ent = {136,92}, door = {136,93}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 15_1
		{pos1 = {142,93}, pos2 = {146,97}, ent = {142,92}, door = {142,93}, price = 1000, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 16_1
		
		{pos1 = {140,67}, pos2 = {142,69}, ent = {140,70}, door = {140,69}, price = 250, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 17_1
		{pos1 = {144,67}, pos2 = {146,69}, ent = {144,70}, door = {144,69}, price = 250, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 18_1
		{pos1 = {140,72}, pos2 = {142,74}, ent = {140,71}, door = {140,72}, price = 250, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 19_1
		{pos1 = {144,72}, pos2 = {146,74}, ent = {144,71}, door = {144,72}, price = 250, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 20_1
		
		{pos1 = {93,11}, pos2 = {98,15}, ent = {93,16}, door = {93,15}, price = 1500, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}, [3] = {}}}, -- 21_1, 21_2, 21_3
		{pos1 = {100,11}, pos2 = {105,15}, ent = {105,16}, door = {105,15}, price = 1500, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}, [3] = {}}}, -- 22_1, 22_2, 22_3
		{pos1 = {93,19}, pos2 = {98,23}, ent = {93,18}, door = {93,19}, price = 1500, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}, [3] = {}}}, -- 23_1, 23_2, 23_3
		{pos1 = {100,19}, pos2 = {105,23}, ent = {105,18}, door = {105,19}, price = 1500, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}, [2] = {}, [3] = {}}}, -- 24_1, 24_2, 24_3
		
		{pos1 = {141,50}, pos2 = {145,53}, ent = {140,53}, door = {141,53}, price = 700, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 25_1
		{pos1 = {141,55}, pos2 = {145,58}, ent = {140,58}, door = {141,58}, price = 700, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 26_1
		{pos1 = {141,60}, pos2 = {145,63}, ent = {140,63}, door = {141,63}, price = 700, owner = nil, endtime = nil, allow = {}, doors = {[1] = {}}}, -- 27_1
	}
}

tibia.config.expTable = {
	__index = function(t, level)
		return tibia.config.exp.calc(k)
	end
}
setmetatable(tibia.config.expTable, tibia.config.expTable)

return {
	player = {
		data = {
			xp = 0,
			level = 1,
			money = 50,
			hp = 100,
			mp = 100,
			inventory = function() return tibia.Inventory.new() end,
			equipment = function() return tibia.Equipment.new() end,
			respawnPosition = {784, 240},
			tutorial = {},
			info = {},
			lastPosition = {0, 0}
		}
	},

	gameSetting = {
		itemDrop = false
	},

	server = {
		setting = {
			password = tibia.config.password,
			fow = 0,
			usgnOnly = 1,
			mode = 1,
			maxClientsIP = 2,
			idleKick = 0,
			hudScale = 1,
			hud = 64,
			radar = 0,
			flashlight = 0,
			infiniteAmmo = 1,
			deathDrop = 4
		}
	}
}