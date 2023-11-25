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
	for _, m in ipairs(tibia.monster) do
		if math.sqrt((m.x - player.x) ^ 2 + (m.y - player.y) ^ 2) <= size then
			m:damage(id, math.floor(damage*math.random(60,140)/100), 251)
		end
	end

	sea.explosion(x, y, size, damage, player.id)
end

function tibia.saveServer()
	local dir = 'sys/lua/sea-framework/app/tibia/'
	local file = io.open(dir.."saves/"..sea.map.name.. ".lua", 'w+') or io.tmpfile()
	
	local tmp = {}
	local groundItems = tibia.groundItems
	for y = 0, sea.map.ySize do
		if groundItems[y] then
			for x = 0, sea.map.xSize do
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
	for i, v in pairs(tibia.houses) do
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
	for k, v in pairs(tibia.global) do
		local text = "GLOBAL[" .. table.valToString(k) .. "] = " .. table.valToString(v) .. "\n"
		file:write(text)
	end
	file:close()
end

function tibia.shutdown(delay)
	if type(delay) ~= 'string' then
		sea.message(0, 'Server is shutting down in '..math.floor(delay / 1000, 0.1)..' seconds.@C', sea.Color.new(255, 100, 100))

		timerEx(delay, 'tibia.shutdown', 1, '')

		local password = math.random(0,9)..math.random(0,9)..math.random(0,9)..math.random(0,9)
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

	local text = string.format("%02d:%02d", math.floor(tibia.global.time / 60), tostring(tibia.global.time % 60))
	tibia.config.item[3].desc = "The time is "..text.."."

	sea.game.daylightTime = tibia.global.time / 4
					
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
			local ground = tibia.Item.getGroundItems(x, y)
			local height = #ground
			while height > 0 do
				local item = ground[height]

				player:addItem(item)

				height = height - 1
			end
		end
	end

	house.owner, house.endtime, house.allow = nil, nil, {}
	for i, v in ipairs(house.doors) do
		house.doors[i] = {}
	end
end