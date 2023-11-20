function tibia.radiusMessage(text, x, y, radiusX, radiusY, color)
	sea.print("default", text)
	
	if not (radiusX and radiusY) then 
		radiusX, radiusY = 320, 240 
	end

	local x1, y1, x2, y2 = x - radiusX, y - radiusY, x + radiusX, y + radiusY

	for _, player in ipairs(sea.Player.get()) do
		if isInside(player.x, player.y, x1, y1, x2, y2) then
			player:message(text, color)
		end
	end

	return 1
end

function tibia.radiusSound(sound, x, y)
	sea.Player.playSoundForAll(sound, x, y)

	return 1
end

function tibia.explosion(x, y, size, damage, player)
	for _, m in ipairs(MONSTERS) do
		if math.sqrt((m.x - player.x) ^ 2 + (m.y - player.y) ^ 2) <= size then
			m:damage(id, math.floor(damage*math.random(60,140)/100), 251)
		end
	end

	sea.explosion(x, y, size, damage, player)
end

-- BASIC FUNCTIONS --

rem = {}
function rem.talkExhaust(player)
	player.tmp.exhaust.talk = false
end

function rem.pickExhaust(player)
	player.tmp.exhaust.pick = false
end

function rem.useExhaust(player)
	player.tmp.exhaust.use = false
end

function rem.paralyse(player)
	player.tmp.paralyse = false
end

-- END OF BASIC FUNCTIONS --



-- SERVER FUNCTIONS --

function tibia.saveServer()
	local file = io.open(dir .. "saves/" .. map'name' .. ".lua", 'w+') or io.tmpfile()
	
	local tmp = {}
	for y = 0, map'ysize' do
		if groundItems[y] then
			for x = 0, map'xsize' do
				if groundItems[y][x] and groundItems[y][x][1] then
					tmp[y] = tmp[y] or {}
					tmp[y][x] = {}
					for j = 1, #groundItems[y][x] do
						tmp[y][x][j] = groundItems[y][x][j][3] and -groundItems[y][x][j][3] or groundItems[y][x][j][1]
					end
				end
			end
		end
	end
	file:write("-- GROUND ITEMS --\n\n")
	for k, v in pairs(tmp) do
		local text = "TMPGROUNDITEMS[" .. table.valToString(k) .. "] = " .. table.valToString(v) .. "\n"
		file:write(text)
	end
	
	local tmp = {}
	for i, v in pairs(houses) do
		if v.owner then
			tmp[i] = {owner = v.owner, endtime = v.endtime, allow = v.allow, doors = v.doors}
		end
	end
	file:write("\n\n-- houses --\n\n")
	for k, v in pairs(tmp) do
		local text = "TMPHOUSES[" .. table.valToString(k) .. "] = " .. table.valToString(v) .. "\n"
		file:write(text)
	end
	file:close()
	
	file:write("\n\n-- GLOBAL STORAGES --\n\n")
	for k, v in pairs(GLOBAL) do
		local text = "GLOBAL[" .. table.valToString(k) .. "] = " .. table.valToString(v) .. "\n"
		file:write(text)
	end
	file:close()
end

function tibia.shutdown(delay)
	if type(delay) ~= 'string' then
		sea.message('\169255100100Server is shutting down in ' .. math.floor(delay/1000,0.1) .. ' seconds.@C')

		timer(delay, 'tibia.shutdown', '', 1)

		local password = math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9)
		print("PASSWORD = "..password)
		sea.game.password = password

		return true
	else
		for _, player in ipairs(sea.Player.get()) do
			player:kick()
		end

		tibia.saveServer()

		timer(3000, "parse", "quit")
	end
end

function tibia.updateTime(t)
	tibia.global.time = t or (tibia.global.time + 1) % 1440

	if tibia.global.rain == 0 then
		if math.random(480) == 1 then
			tibia.global.rain = 1
			parse("trigger", "rain")
		end
	elseif tibia.global.rain == 1 then
		if math.random(5) == 1 then
			tibia.global.rain = 2
			parse("trigger", "storm")
		else
			tibia.global.rain = 3
		end
	elseif tibia.global.rain == 2 then
		if math.random(20) == 1 then
			tibia.global.rain = 3
			parse("trigger", "storm")
		end
	elseif tibia.global.rain == 3 then
		if math.random(20) == 1 then
			tibia.global.rain = 0
			parse("trigger", "rain")
		end
	end

	local text = string.format("%02d:%02d", math.floor(tibia.global.TIME / 60), tostring(tibia.global.TIME % 60))
	ITEMS[3].desc = "The time is "..text.."."

	sea.game.daylightTime = tibia.global.TIME / 4
					
	return tibia.global.time
end

function tibia.houseExpire(id)
	local house = tibia.houses[id]
	if not house.owner then
		return false
	end

	local player = PLAYERCACHE[house.owner]
	for y = house.pos1[2], house.pos2[2] do
		for x = house.pos1[1], house.pos2[1] do
			local ground = tibia.groundItems[y][x]
			local height = #ground
			while height > 0 do
				local item = ground[height]
				if item[1] == 1337 then
					freeimage(item[2])
					player.Money = player.Money + item[3]
					tibia.groundItems[y][x][height] = nil
				else
					table.insert(player.Inventory, item[1])

					local tile = sea.tile[x][y]
					if tile.zone.HEAL and ITEMS[item[1]].heal then
						tile.zone.HEAL = tile.HEAL - ITEMS[item[1]].heal
						if tile.zone.HEAL == 0 then
							tile.zone.HEAL = nil
						end
					end

					freeimage(item[2])
					tibia.groundItems[y][x][height] = nil
				end
				height = height - 1
			end
		end
	end

	house.owner, house.endtime, house.allow = nil, nil, {}
	for i, v in ipairs(house.doors) do
		house.doors[i] = {}
	end
end

-- END OF SERVER FUNCTIONS --



-- PLAYERS --

function message(id, text, colour)
	if text:sub(-2) == "@C" then
		msg2(id, (colour and "\169" .. tostring(colour) or "") .. text)
	else
		text = text:gsub("\n", "\169")

		local tbl = {}
		repeat
			table.insert(tbl, text:sub(#tbl+1, math.min(#text, (#tbl+1)*90)))
			text = text:sub(#tbl*90)
		until #text == 0

		for k, v in ipairs(tbl) do
			msg2(id, (colour and "\169" .. tostring(colour) or "") .. v)
		end
	end
end

function hudtxt2(id, txtid, text, colour, x, y, align)
	parse("hudtxt2 " .. id .. " " .. txtid .. " \"\169" .. tostring(colour) .. text .. "\" " .. x .. " " .. y .. " " .. align)
end

-- END OF PLAYERS --

-- ITEMS --

function tibia.spawnItem(itemid, x, y, amount)
	if not ITEMS[itemid] then return false end
	local ground = tibia.groundItems[y][x]

	local tile = sea.tile[x][y]
	local item = {itemid}
	if itemid == 1337 then
		item[3] = amount
	else
		if ITEMS[itemid].heal then
			tile.zone.HEAL = (tile.zone.HEAL or 0) + ITEMS[itemid].heal
		end
	end

	ground[#ground+1] = item
	tibia.updateTileItems(x, y)

	return true
end

local maxHeight = tibia.config.maxHeight
function tibia.updateTileItems(x, y)
	local tile = groundItems[y][x]
	if #tile ~= 0 then
		for i = 1, #tile do
			local item = tile[i]
			if item and item[2] then
				freeimage(item[2])
				item[2] = nil
			end
		end
	end

	local height = 0
	for i = #tile - maxHeight + 1 > 0 and #tile - maxHeight + 1 or 1, #tile do
		height = height + 1
		local item = tile[i]
		local itemid = item[1]
		local amount = item[3]
		local x = ITEMS[itemid].offsetx and x*32+16+ITEMS[itemid].offsetx or x*32+16
		local y = ITEMS[itemid].offsety and y*32+16+ITEMS[itemid].offsety or y*32+16
		local heightoffset = (height < maxHeight and height or maxHeight) * 3
		if itemid == 1337 then
			item[2] = image("gfx/weiwen/rupee.png", 0, 0, height > 3 and 1 or 0)
			if amount < 5 then
				imagecolor(item[2], 64, 255, 0)
			elseif amount < 10 then
				imagecolor(item[2], 0, 64, 255)
			elseif amount < 20 then
				imagecolor(item[2], 255, 255, 0)
			elseif amount < 50 then
				imagecolor(item[2], 255, 64, 0)
			elseif amount < 100 then
				imagecolor(item[2], 200, 0, 200)
			elseif amount < 200 then
				imagecolor(item[2], 255, 128, 0)
			elseif amount < 500 then
				imagecolor(item[2], 128, 255, 128)
			elseif amount < 1000 then
				imagecolor(item[2], 128, 128, 255)
			elseif amount < 2000 then
				imagecolor(item[2], 255, 128, 128)
			elseif amount < 5000 then
				imagecolor(item[2], 64, 128, 64)
			elseif amount < 10000 then
				imagecolor(item[2], 64, 64, 128)
			elseif amount < 20000 then
				imagecolor(item[2], 128, 64, 64)
			else
				imagecolor(item[2], 192, 192, 192)
			end
			imagealpha(item[2], 0.8)
		else
			item[2] = image(ITEMS[itemid].fimage or "gfx/weiwen/circle.png", 0, 0, i > 3 and 1 or 0)
			if ITEMS[itemid].r then
				imagecolor(item[2], ITEMS[itemid].r, ITEMS[itemid].g, ITEMS[itemid].b)
			end
		end
		imagepos(item[2], x - heightoffset, y - heightoffset, ITEMS[itemid].rot or 0)
		local scalex, scaley = ITEMS[itemid].fscalex or 1, ITEMS[itemid].fscaley or 1
		local magnification = math.min(height, 10)/20+0.95
		imagescale(item[2], scalex*magnification, scaley*magnification)
	end
end

function fullname(itemID, amount)
	if not amount or amount == 1 then
		return ITEMS[itemID].article .. " " .. ITEMS[itemID].name
	else
		return amount .. " " .. ITEMS[itemID].plural
	end
end