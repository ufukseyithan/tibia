print('initialising...')
local _map = map
dofile('sys/lua/wrapper.lua')
map = _map
math.randomseed(os.time())

dir = 'sys/lua/sea-framework/app/tibia/'
dofile(dir .. 'config.lua')

EXPTABLE = {}
for level = 1, 500 do
	EXPTABLE[level] = CONFIG.EXP.CALC(level)
end
EXPTABLE.__index = function(t, k)
	t[k] = CONFIG.EXP.CALC(k)
	return t[k]
end
setmetatable(EXPTABLE, EXPTABLE)

mapName = map'name'
PVPZONE = PVPZONE[mapName] or PVPZONE[CONFIG.DEFAULTMAP]
NOPVPZONE = NOPVPZONE[mapName] or NOPVPZONE[CONFIG.DEFAULTMAP]
NOMONSTERSZONE = NOMONSTERSZONE[mapName] or NOMONSTERSZONE[CONFIG.DEFAULTMAP]
SAFEZONE = SAFEZONE[mapName] or SAFEZONE[CONFIG.DEFAULTMAP]
HOUSES = HOUSES[mapName] or HOUSES[CONFIG.DEFAULTMAP]
GROUNDITEMS = {}
TILEZONE = {}

for y = 0, sea.map.xSize do
	GROUNDITEMS[y], TILEZONE[y] = {}, {}
	for x = 0, sea.map.xSize do
		GROUNDITEMS[y][x], TILEZONE[y][x] = {}, {}

		for i, v in ipairs(SAFEZONE) do
			TILEZONE[y][x].SAFE = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if TILEZONE[y][x].SAFE then
				TILEZONE[y][x].NOPVP = true
				TILEZONE[y][x].NOMONSTERS = true
				TILEZONE[y][x].PVP = false
				break
			end
		end

		for i, v in ipairs(NOPVPZONE) do
			TILEZONE[y][x].NOPVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if TILEZONE[y][x].NOPVP then
				TILEZONE[y][x].NOMONSTERS = false
				TILEZONE[y][x].SAFE = false
				break
			end
		end

		for i, v in ipairs(NOMONSTERSZONE) do
			TILEZONE[y][x].NOMONSTERS = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2])
			if TILEZONE[y][x].NOMONSTERS then
				if TILEZONE[y][x].NOPVP then
					TILEZONE[y][x].SAFE = true
				else
					TILEZONE[y][x].SAFE = false
				end
			end
		end

		for i, v in ipairs(PVPZONE) do
			TILEZONE[y][x].PVP = (x >= v[1][1] and x <= v[2][1] and y >= v[1][2] and y <= v[2][2]) and i or nil
			if TILEZONE[y][x].PVP then 
				TILEZONE[y][x].NOPVP = false
				TILEZONE[y][x].SAFE = false
				break
			end
		end

		for i, v in ipairs(HOUSES) do
			TILEZONE[y][x].HOUSE = (x >= v.pos1[1] and x <= v.pos2[1] and y >= v.pos1[2] and y <= v.pos2[2]) and i or nil
			TILEZONE[y][x].HOUSEDOOR = (x == v.door[1] and y == v.door[2]) and i or nil
			TILEZONE[y][x].HOUSEENT = (x == v.ent[1] and y == v.ent[2]) and i or nil
			if TILEZONE[y][x].HOUSE or TILEZONE[y][x].HOUSEDOOR or TILEZONE[y][x].HOUSEENT then break end
		end
	end
end

PLAYERS = {}
PLAYERCACHE = {}

HUDImage = image('gfx/weiwen/1x1.png', 565, 407+#CONFIG.STATS*CONFIG.PIXELS/2, 2)
imagescale(HUDImage, 130,CONFIG.PIXELS+#CONFIG.STATS*CONFIG.PIXELS)
imagealpha(HUDImage, 0.5)

MINUTES = 0
GLOBAL = {}
GLOBAL.TIME = 720
GLOBAL.RAIN = 0

dofile(dir .. 'functions.lua')
dofile(dir .. 'admin.lua')
dofile(dir .. 'commands.lua')
dofile(dir .. 'player.lua')
dofile(dir .. 'items.lua')
dofile(dir .. 'npcs.lua')
if CONFIG.MAXMONSTERS > 0 then
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
			HOUSES[i][k] = l
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