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

function shutdown(delay)
	if type(delay) ~= 'string' then
		sea.message('\169255100100Server is shutting down in ' .. math.floor(delay/1000,0.1) .. ' seconds.@C')

		timer(delay, 'shutdown', '', 1)

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

function updateTime(t)
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

function houseexpire(id)
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

function spawnitem(itemid, x, y, amount)
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
	updateTileItems(x, y)

	return true
end

local MAXHEIGHT = tibia.config.maxHeight
function updateTileItems(x, y)
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
	for i = #tile-MAXHEIGHT+1 > 0 and #tile-MAXHEIGHT+1 or 1, #tile do
		height = height + 1
		local item = tile[i]
		local itemid = item[1]
		local amount = item[3]
		local x = ITEMS[itemid].offsetx and x*32+16+ITEMS[itemid].offsetx or x*32+16
		local y = ITEMS[itemid].offsety and y*32+16+ITEMS[itemid].offsety or y*32+16
		local heightoffset = (height < MAXHEIGHT and height or MAXHEIGHT)*3
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

function inventory(player, page)
	page = page or 0
	local text = "Inventory" .. string.rep(" ", page) .. ","
	for i = page*5+1, (page+1)*5 do
		local name
		if ITEMS[player.inventory[i]] then
			name = ITEMS[player.inventory[i]].name
		else
			name = player.inventory[i] or ""
		end
		text = text..name.."|"..i..","
	end
	text = text..',,Prev Page,Next Page|Page'..page+1
	menu(id, text)
end

function equipment(player)
	local text = "Equipment"
	for i, v in ipairs(tibia.config.slots) do
		text = text..","..(ITEMS[player.equipment[i] or 0].name or ("ITEM ID "..player.equipment[i])).. "|"..v
	end

	menu(id, text)
end

function itemactions(player, itemSlot, equip)
	local itemID
	local text = (equip and "Equip" or "Item") .. " Actions" .. string.rep(" ", itemSlot-1) .. ","
	if equip then
		itemID = player.equipment[itemSlot] or 0
	else
		itemID = player.inventory[itemSlot] or 0
	end
	for i, v in ipairs(ITEMS[itemID].action) do
		text = text .. v .. ","
	end
	text = text .. string.rep(",", 7-#ITEMS[itemID].action) .. "Examine,Drop"
	menu(id, text)
end

-- END OF ITEMS --



-- EQUIP --

function eat(player, itemslot, itemID, equip)
	radiusmsg(player.name.." eats "..ITEMS[itemID].article.." ".. ITEMS[itemID].name .. ".", player.x, player.y, 384)
	player.health = player.health + ITEMS[itemID].food()

	player.hp = health

	destroyitem(player, itemslot)
end

function explosion(x, y, size, damage, player)
	for _, m in ipairs(MONSTERS) do
		if math.sqrt((m.x-player.x)^2+(m.y-player.y)^2) <= size then
			m:damage(id, math.floor(damage*math.random(60,140)/100), 251)
		end
	end

	parse("explosion", x, y, size, damage, player.id)
end

function equip(player, itemSlot, itemID, equip)
	local index = equip and "Equipment" or "Inventory"
	local previousItems, newItems = {}, {}
	if equip then
		if not additem(player, itemID) then return end
		previousItems[itemSlot] = player.equipment[itemSlot] or 0
		player.equipment[itemSlot] = nil
		newItems[itemSlot] = 0
	else
		if ITEMS[itemID].level and player.level < ITEMS[itemID].level then
			player:message("You need to be level " .. ITEMS[itemID].level .. " or above to equip it.")
			return
		end
		newItems[ITEMS[itemID].slot] = itemID
		if ITEMS[itemID].slot == 4 then
			if player.equipment[3] then
				if ITEMS[player.equipment[3]].twohand then
						if not additem(id, player.equipment[3]) then return end
						previousItems[3] = player.equipment[3] or 0
						player.equipment[3] = nil
						newItems[3] = 0
				end
			end
		elseif ITEMS[itemID].slot == 3 then
			if ITEMS[itemID].twohand then
				if player.equipment[4] then
					if not additem(player, player.equipment[4]) then return end
					previousItems[4] = player.equipment[4] or 0
					player.equipment[4] = nil
					newItems[4] = 0
				end
			end
		end
		destroyitem(id, itemSlot)
		if player.equipment[ITEMS[itemID].slot] then
			previousItems[ITEMS[itemID].slot] = player.equipment[ITEMS[itemID].slot]
			additem(player, player.equipment[ITEMS[itemID].slot])
		else
			previousItems[ITEMS[itemID].slot] = 0
		end
		player.equipment[ITEMS[itemID].slot] = itemID
	end
	updateEQ(player, newItems, previousItems)
end

function updateEQ(player, newItems, previousItems)
	previousItems = previousItems or {}

	if not newItems then 
		return 
	end

	player:equipAndSet(50)

	local hp, spd, atk, def = 0, 0, 0, 0
	local equip, strip = player:getItems(), {50, 41}

	for i, v in pairs(newItems) do
		if previousItems[i] then
			if player.tmp.equip[i].image then
				freeimage(player.tmp.equip[i].image)
				player.tmp.equip[i].image = nil
			end
			if player.tmp.equip[i].equip then
				parse("strip " .. id .. " " .. player.tmp.equip[i].equip)
				table.insert(strip, player.tmp.equip[i].equip)
				player.tmp.equip[i].equip = nil
			end
			if ITEMS[previousItems[i]].hp then
				hp=hp-ITEMS[previousItems[i]].hp
			end
			if ITEMS[previousItems[i]].speed then
				spd=spd-ITEMS[previousItems[i]].speed
			end
			if ITEMS[previousItems[i]].atk then
				atk=atk-ITEMS[previousItems[i]].atk
			end
			if ITEMS[previousItems[i]].def then
				def=def-ITEMS[previousItems[i]].def
			end
		end
		if newItems[i] ~= 0 then
			if ITEMS[newItems[i]].hp then
				hp=hp+ITEMS[newItems[i]].hp
			end
			if ITEMS[newItems[i]].speed then
				spd=spd+ITEMS[newItems[i]].speed
			end
			if ITEMS[newItems[i]].atk then
				atk=atk+ITEMS[newItems[i]].atk
			end
			if ITEMS[newItems[i]].def then
				def=def+ITEMS[newItems[i]].def
			end
			if ITEMS[newItems[i]].equip then
				player.tmp.equip[i].equip = ITEMS[newItems[i]].equip
				parse("equip", id, ITEMS[newItems[i]].equip)
				table.insert(equip, ITEMS[newItems[i]].equip)
			end
			if ITEMS[newItems[i]].eimage then 
				if not player.tmp.equip[i].image then
					player.tmp.equip[i].image = image(ITEMS[newItems[i]].eimage, ITEMS[newItems[i]].static and 0 or 1, 0, (ITEMS[newItems[i]].ground and 100 or 200)+id)
					if ITEMS[newItems[i]].r then
						imagecolor(player.tmp.equip[i].image, ITEMS[newItems[i]].r, ITEMS[newItems[i]].g, ITEMS[newItems[i]].b)
					end
					local scalex, scaley = ITEMS[newItems[i]].escalex or 1, ITEMS[newItems[i]].escaley or 1
					scalex = scalex * -1
					imagescale(player.tmp.equip[i].image, scalex, scaley)
					if ITEMS[newItems[i]].blend then
						imageblend(player.tmp.equip[i].image, ITEMS[newItems[i]].blend)
					end
				end
			end
		end
	end

	for i, v in ipairs(equip) do
		if not table.contains(strip, v.id) then
			player.weapon = v.id
			player:strip(50)
		end
	end

	player.tmp.atk = player.tmp.atk + atk
	player.tmp.def = player.tmp.def + def
	player.tmp.spd = player.tmp.spd + spd
	player.tmp.hp = player.tmp.hp + hp

	local temphp = player.health
	player.maxHealth = player.tmp.hp
	player.health = temphp

	player.speed = player.tmp.spd
end

-- END OF EQUIP --