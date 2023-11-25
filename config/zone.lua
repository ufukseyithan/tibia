tibia.config.safeZone = { -- safezones e.g. {{x1, y1},{x2, y2}} means a rectangular area from (x1, y1) to (x2, y2)
	['rpg_mapb'] = {
		{{2, 2}, {29, 19}},
		{{74, 0}, {108, 44}},
		{{90, 90}, {99, 99}},
		{{0, 20}, {12, 33}},
		{{7, 84}, {15, 90}},
		{{75, 49}, {82, 60}},
		{{83, 57}, {92, 60}},
		{{107, 36}, {122, 40}},
		{{109, 46}, {149, 99}},
		{{70, 122}, {79, 131}},
	}
}

tibia.config.noPvpZone = { -- non-pvp zones, preventing pvp within the area. syntax same as above
	['rpg_mapb'] = {

	}
}

tibia.config.noMonstersZone = { -- no-monsters zones, preventing monsters spawning/entering/attacking inside the area. syntax same as above
	['rpg_mapb'] = {
		{{88, 32}, {98, 43}},
	}
}

tibia.config.pvpZone = { -- deathmatch zones, if a player dies in this area, he will drop $100 and nothing else. monsters DO spawn here now, but you can set it to be a no-monsters zone to prevent that. guess the syntax
	['rpg_mapb'] = {
		{{88, 32}, {98, 43}},
	}
}