print('initialising...')
local _map = map
dofile('sys/lua/wrapper.lua')
map = _map
math.randomseed(os.time())

dir = 'sys/lua/sea-framework/app/tibia/'

local mapName = sea.map.name
tibia.pvpZone = tibia.config.pvpZone[mapName] or tibia.config.pvpZone[tibia.config.defaultMap]
tibia.noPvpZone = tibia.config.noPvpZone[mapName] or tibia.config.noPvpZone[tibia.config.defaultMap]
tibia.noMonstersZone = tibia.config.noMonstersZone[mapName] or tibia.config.noMonstersZone[tibia.config.defaultMap]
tibia.safeZone = tibia.config.safeZone[mapName] or tibia.config.safeZone[tibia.config.defaultMap]
tibia.houses = tibia.config.houses[mapName] or tibia.config.houses[tibia.config.defaultMap]
tibia.groundItems = {}
tibia.tileZone = {}

for y = 0, sea.map.xSize do
	tibia.groundItems[y], tibia.tileZone[y] = {}, {}

	for x = 0, sea.map.xSize do
		tibia.groundItems[y][x], tibia.tileZone[y][x] = {}, {}

		for i, v in ipairs(tibia.config.safeZone) do
			tibia.tileZone[y][x].SAFE = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tibia.tileZone[y][x].SAFE then
				tibia.tileZone[y][x].NOPVP = true
				tibia.tileZone[y][x].NOMONSTERS = true
				tibia.tileZone[y][x].PVP = false
				break
			end
		end

		for i, v in ipairs(tibia.config.noPvpZone) do
			tibia.tileZone[y][x].NOPVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tibia.tileZone[y][x].NOPVP then
				tibia.tileZone[y][x].NOMONSTERS = false
				tibia.tileZone[y][x].SAFE = false
				break
			end
		end

		for i, v in ipairs(tibia.config.noMonstersZone) do
			tibia.tileZone[y][x].NOMONSTERS = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if tibia.tileZone[y][x].NOMONSTERS then
				if tibia.tileZone[y][x].NOPVP then
					tibia.tileZone[y][x].SAFE = true
				else
					tibia.tileZone[y][x].SAFE = false
				end
			end
		end

		for i, v in ipairs(tibia.config.pvpZone) do
			tibia.tileZone[y][x].PVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2]) and i or nil
			if tibia.tileZone[y][x].PVP then 
				tibia.tileZone[y][x].NOPVP = false
				tibia.tileZone[y][x].SAFE = false
				break
			end
		end

		for i, v in ipairs(tibia.config.houses) do
			tibia.tileZone[y][x].HOUSE = (x >= v.pos1[1] and x <= v.pos2[1] and y >= v.pos1[2] and y <= v.pos2[2]) and i or nil
			tibia.tileZone[y][x].HOUSEDOOR = (x == v.door[1] and y == v.door[2]) and i or nil
			tibia.tileZone[y][x].HOUSEENT = (x == v.ent[1] and y == v.ent[2]) and i or nil
			if tibia.tileZone[y][x].HOUSE or tibia.tileZone[y][x].HOUSEDOOR or tibia.tileZone[y][x].HOUSEENT then break end
		end
	end
end

PLAYERS = {}
PLAYERCACHE = {}

tibia.hudImage = sea.Image.create('gfx/weiwen/1x1.png', 565, 407 + #tibia.config.stats * tibia.config.pixels / 2, 2)
tibia.hudImage:scale(130, tibia.config.pixels + #tibia.config.stats * tibia.config.pixels)
tibia.hudImage.alpha = 0.5

tibia.minutes = 0
GLOBAL = {}
GLOBAL.TIME = 0
GLOBAL.RAIN = 0

dofile(dir .. 'functions.lua')
dofile(dir .. 'admin.lua')
dofile(dir .. 'commands.lua')
dofile(dir .. 'items.lua')
dofile(dir .. 'npcs.lua')
if tibia.config.maxMonsters > 0 then
	dofile(dir .. 'monsters.lua')
end
dofile(dir .. 'hooks.lua')

TMPGROUNDITEMS = {}
TMPHOUSES = {}
local file = io.open(dir .. "saves/" .. map'name' .. ".lua")
if file then
	io.close(file)
	dofile(dir .. "saves/" .. map'name' .. ".lua")
	for y = 0, map'ysize' do
		if TMPGROUNDITEMS[y] then
			for x = 0, map'xsize' do
				if TMPGROUNDITEMS[y][x] then
					for _, j in ipairs(TMPGROUNDITEMS[y][x]) do
						if j < 0 then
							spawnitem(1337, x, y, -j)
						else
							spawnitem(j, x, y)
						end
					end
				end
			end
		end
	end
	for i, v in pairs(TMPHOUSES) do
		for k, l in pairs(v) do
			houses[i][k] = l
		end
	end
	TMPGROUNDITEMS = nil
	TMPHOUSES = nil
end
local file = io.open(dir .. "saves/players.lua")
if file then
	io.close(file)
	dofile(dir .. "saves/players.lua")
end
file = nil

print('initialisation completed!')