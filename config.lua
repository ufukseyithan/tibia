tibia.config = {
	password = "", 

	inventoryCapacity = 48, 
	
	-- maximum number of monsters on the map at one time. if set to 0, monsters.lua is not loaded at all.
	maxMonsters = 48, 
	
	-- maximum height an item stack on the ground can be (they can be as high as you want, but only the top few will be shown when this is set).
	maxHeight = 5, 
	
	exp = {
		-- function for calculation experience for each level.
		calc = function(level)
			level = level - 1
			return (level) ^ 3 - 3 * (level) ^ 2 + 8 * (level)
		end
	}, 

	-- slot names for each slot. can be customised.
	-- the order is important since the last item will always be rendered last
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
	expRate = 1, 
	-- rupee loot will be multiplied by this value.
	moneyRate = 1, 
	-- drop chance will be multiplied by this value.
	dropRate = 1, 
	-- player death rupee loot will be multiplied by this value.
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

tibia.config.expTable = {
	__index = function(t, level)
		return tibia.config.exp.calc(level)
	end
}
setmetatable(tibia.config.expTable, tibia.config.expTable)

return {
	player = {
		data = {
			xp = 0,
			level = 1,
			rupee = 50,
			hp = 100,
			mp = 100,
			inventory = {},
			equipment = {},
			respawnPosition = {784, 240},
			tutorial = {},
			info = {},
			lastPosition = {},
			lastName = ""
		}
	},

	game = {
		setting = {
			itemDrop = false
		},

		data = {
			rain = 0,
			time = 0,
			tempGroundItems = {},
			tempHouses = {}
		}
	},

	server = {
		setting = {
			password = tibia.config.password,
			fow = 0,
			usgnOnly = 1,
			maxClientsIP = 2,
			idleKick = 0,
			hudScale = 1,
			hud = 65,
			radar = 0,
			flashlight = 0,
			infiniteAmmo = 1,
			deathDrop = 4
		}
	}
}