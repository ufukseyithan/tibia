local mapName = sea.map.name
tibia.pvpZone = tibia.config.pvpZone[mapName] or tibia.config.pvpZone[tibia.config.defaultMap]
tibia.noPvpZone = tibia.config.noPvpZone[mapName] or tibia.config.noPvpZone[tibia.config.defaultMap]
tibia.noMonstersZone = tibia.config.noMonstersZone[mapName] or tibia.config.noMonstersZone[tibia.config.defaultMap]
tibia.safeZone = tibia.config.safeZone[mapName] or tibia.config.safeZone[tibia.config.defaultMap]
tibia.house = tibia.config.house[mapName] or tibia.config.house[tibia.config.defaultMap]
tibia.tileZone = {}

for y = 0, sea.map.ySize do
	tibia.tileZone[y] = {}

	for x = 0, sea.map.xSize do
		tibia.tileZone[y][x] = {}

		local tileZone = tibia.tileZone[y][x]

		for i, v in ipairs(tibia.safeZone) do
			tileZone.SAFE = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tileZone.SAFE then
				tileZone.NOPVP = true
				tileZone.NOMONSTERS = true
				tileZone.PVP = false
				break
			end
		end

		for i, v in ipairs(tibia.noPvpZone) do
			tileZone.NOPVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tileZone.NOPVP then
				tileZone.NOMONSTERS = false
				tileZone.SAFE = false
				break
			end
		end

		for i, v in ipairs(tibia.noMonstersZone) do
			tileZone.NOMONSTERS = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tileZone.NOMONSTERS then
				tileZone.SAFE = tileZone.NOPVP
			end
		end

		for i, v in ipairs(tibia.pvpZone) do
			tileZone.PVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2]) and i or nil
			if tileZone.PVP then 
				tileZone.NOPVP = false
				tileZone.SAFE = false
				break
			end
		end

		for i, v in ipairs(tibia.house) do
			tileZone.HOUSE = (x >= v.pos1[1] and x <= v.pos2[1] and y >= v.pos1[2] and y <= v.pos2[2]) and i or nil
			tileZone.HOUSEDOOR = (x == v.door[1] and y == v.door[2]) and i or nil
			tileZone.HOUSEENT = (x == v.ent[1] and y == v.ent[2]) and i or nil

			if tileZone.HOUSE or tileZone.HOUSEDOOR or tileZone.HOUSEENT then 
				break 
			end
		end
	end
end

tibia.hudImage = sea.Image.create('gfx/weiwen/1x1.png', 775, 407 + #tibia.config.stats * tibia.config.pixels / 2, 2)
tibia.hudImage:scale(130, tibia.config.pixels + #tibia.config.stats * tibia.config.pixels)
tibia.hudImage.alpha = 0.5

tibia.minutes = 0

