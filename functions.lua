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
	local tmp = {}
	local groundItems = tibia.groundItems
	for y = 0, sea.map.ySize do
		if groundItems[y] then
			for x = 0, sea.map.xSize do
				if groundItems[y][x] and groundItems[y][x][1] then
					tmp[y] = tmp[y] or {}
					tmp[y][x] = {}

					for j = 1, #groundItems[y][x] do
						local item = groundItems[y][x][j]
						tmp[y][x][j] = {item.id, item.attributes}
					end
				end
			end
		end
	end

	for k, v in pairs(tmp) do
		sea.game.tempGroundItems[k] = v
	end
	
	local tmp = {}
	for i, v in pairs(tibia.house) do
		if v.owner then
			tmp[i] = {owner = v.owner, endtime = v.endtime, allow = v.allow, doors = v.doors}
		end
	end

	for k, v in pairs(tmp) do
		sea.game.tempHouses[k] = v
	end
end

function tibia.loadServer()
	for y = 0, sea.map.ySize do
		if sea.game.tempGroundItems[y] then
			for x = 0, sea.map.xSize do
				if sea.game.tempGroundItems[y][x] then
					for _, item in ipairs(sea.game.tempGroundItems[y][x]) do
						tibia.Item.spawn(item[1], x, y, item[2])
					end
				end
			end
		end
	end

	for i, v in pairs(sea.game.tempHouses) do
		for k, l in pairs(v) do
			tibia.house[i][k] = l
		end
	end
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
	sea.game.time = t or (sea.game.time + 1) % 1440

	if sea.game.rain == 0 then
		if math.random(480) == 1 then
			sea.game.rain = 1
			parse("trigger", "rain")
		end
	elseif sea.game.rain == 1 then
		if math.random(5) == 1 then
			sea.game.rain = 2
			parse("trigger", "storm")
		else
			sea.game.rain = 3
		end
	elseif sea.game.rain == 2 then
		if math.random(20) == 1 then
			sea.game.rain = 3
			parse("trigger", "storm")
		end
	elseif sea.game.rain == 3 then
		if math.random(20) == 1 then
			sea.game.rain = 0
			parse("trigger", "rain")
		end
	end

	local text = string.format("%02d:%02d", math.floor(sea.game.time / 60), tostring(sea.game.time % 60))
	tibia.config.item[3].desc = "The time is "..text.."."

	-- Max set 133 to not have the pitch black
	sea.game.daylightTime = math.max(sea.game.time / 4, 133)
					
	return sea.game.time
end

function tibia.houseExpire(id)
	local house = tibia.house[id]
	if not house.owner then
		return false
	end

	local online = sea.Player.getByUSGN(house.owner)
	local playerData, save
	if not online then
		playerData, save = sea.Player.dataStream(house.owner, 'usgn')
	end

	for y = house.pos1[2], house.pos2[2] do
		for x = house.pos1[1], house.pos2[1] do
			local ground = tibia.Item.get(x, y)
			local height = #ground
			while height > 0 do
				local item = ground[height]

				if online then
					online:addItem(item)
				else
					if item.config.currency then
						save('rupee', playerData.rupee + item.amount)
					else
						local tempInventory = tibia.Inventory.new(playerData.inventory)
						tempInventory:addItem(item)
						save()
					end
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