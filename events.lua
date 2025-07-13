sea.listen('gameLoaded', function()
	tibia.loadServer()
end)

sea.listen('gameSaved', function()
	tibia.saveServer()
end)

sea.listen("join", function(player)
	player.tmp = {
		inventory = tibia.Inventory.new(player.inventory),
		equipment = tibia.Equipment.new(player.equipment),
		hp = 100, 
		attack = 1, 
		defence = 1, 
		speed = 0, 
		equipmentImage = {}, 
		exhaust = {},
		ui = {},
	}

	player.tmp.ui['textZone'] = player.ui:createText('', 425, 240, sea.Style.new({align = 1, color = sea.Color.new(255, 64, 0)}))

	player.tmp.ui['textName'] = player.ui:createText(player.usgn ~= 0 and player.name or "NOT LOGGED IN", 775, 407-tibia.config.pixels, sea.Style.new({align = 1, color = sea.Color.new(255, 100, 100)}))

	for k, v in pairs(tibia.config.stats) do
		local y = 407 + (k - 1) * tibia.config.pixels
		player.ui:createText(v, 720, y)
		player.tmp.ui['text'..v] = player.ui:createText(player[v:lower()], 820, y, sea.Style.new({align = 1, color = sea.Color.yellow}))
	end

	player.lastName = player.name
end, -1)

sea.listen("name", function(player, oldName, newName)
	local check = newname:lower()
	if (check:find('admin') or check:find('gm')) and not tibia.isAdmin(player) then
		return 1
	end

	player.lastName = newName
	player.tmp.ui['textName']:setText(player.usgn ~= 0 and newName or "NOT LOGGED IN")
end, -1)

sea.listen("walkover", function()
	return 1
end, -1)

sea.listen("movetile", function(player, x, y)
	local entity = sea.Entity.new(x, y)
	local entityTypeName = entity.typeName

	if entityTypeName == "Info_T" or entityTypeName == "Info_CT" then
		return
	end

	local lastPosition = player.lastPosition

	local tile = sea.Tile.get(x, y)

	if tile:isWaterTile() or player.tmp.paralyse then
		if not (player.equipment[7] and tibia.config.item[player.equipment[7]].water) then
			player:setPosition(tileToPixel(lastPosition.x), tileToPixel(lastPosition.y))
			return
		end
	end

	if tile.zone.HOUSE then
		player:showTutorial("House", "This is a house. For more information about houses, type !house")

		house = tibia.house[tile.zone.HOUSE]
		if not house.owner then
			player:setPosition(tileToPixel(lastPosition.x), tileToPixel(lastPosition.y))
			player:message("This house has no owner. Type \"!house\" for a list of house commands.")
			return
		elseif not (player.usgn == house.owner or table.contains(house.allow, player.usgn)) then
			player:setPosition(tileToPixel(house.ent[1]), tileToPixel(house.ent[2]))
			local saveData = sea.Player.getSaveData(house.owner, 'data')
			player:message("You are not invited into " .. saveData.lastName .. "'s house. Type \"!house\" for a list of house commands.", "255255255")
			return
		end
	end

	if tibia.Item.get(x, y)[1] then
		player:showTutorial("Pick", "You have stumbled upon something. Press the drop weapon button (default G) to pick it up.")
	end

	player.tmp.ui['textZone']:setText(tile.zone.SAFE and "SAFE" or (tile.zone.NOMONSTERSPVP and "NO tibia.monster") or (tile.zone.NOPVP and "NO PVP") or (tile.zone.PVP and "DEATHMATCH") or "")
	
	if not tile.zone.SAFE then
		player:showTutorial("Safe", "You have left a SAFE zone. From now, you will be able to both damage and be damaged.")
	elseif tile.zone.NOMONSTERS and not tile.zone.PVP then
		player:showTutorial("No Monsters", "You have entered a NO tibia.monster zone. No monsters will spawn here. However, PVP is still allowed!")
	elseif tile.zone.NOPVP then
		player:showTutorial("No PvP", "You have entered a NO PVP zone. PVP is disabled here, but monsters can still spawn.")
	elseif tile.zone.PVP then
		player:showTutorial("PvP", "You have entered a DEATHMATCH zone. In this area, you may fight for rupee. If you die here, you will drop a maximum of $100.")
	end

	player.lastPosition.x, player.lastPosition.y = x, y
end, -1)

sea.listen("say", function(player, words)
	if not player:exhaust("talk") then 
		return 1 
	end

	if words:sub(1,1) == '!' then
		command = words:sub(2):split(' ')
		local func = tibia.command[command[1]]
		if func then
			table.remove(command, 1)
			func(player, command)
		end
		return 1
	end

	player:showTutorial("Say", "Talking! I don't think you need a tutorial on that, but just to let you know, whatever you say can only be heard by people around you.")

	local picture = 'gfx/weiwen/talk.png'
	words = words:gsub('%s+', ' ')
	local radiusX, radiusY, colour, action
	if words:sub(-1) == '!' then
		words = words:upper()
		action = "yells"
		radiusX, radiusY = 1280, 960
	elseif words:sub(-1) == '?' then
		action = "asks"
		picture = 'gfx/weiwen/ask.png'
	elseif words:sub(1,2) == '::' then
		words = words:sub(3)
		action = "whispers"
		radiusX, radiusY = 48, 48
	end

	if words:find':D' or words:find'=D' or words:find':)' or words:find'=)' or words:find'%(:' or words:find'%(=' or words:find'xD' or words:find'lol' then
		picture = 'gfx/weiwen/happy.png'
	elseif words:find'>:%(' or words:find':@' or words:find'fuck' then
		picture = 'gfx/weiwen/angry.png'
	elseif words:find':%(' or words:find'=%(' or words:find'):' or words:find'):' or words:find':\'%(' or words:find':<' then
		picture = 'gfx/weiwen/sad.png'
	end

	local image = sea.Image.create(picture, 0, 0, 200 + player.id)
	image:destroyIn(1000)

	local code = words:sub(1,2):lower()
	if code:sub(1,1) == '^' then
		colour = tibia.config.colours[tonumber(code:sub(2,2), 36)]
		words = words:sub(3)
	end

	if player.team == 0 then
		radiusX, radiusY = 0, 0
	end

	local text = string.format("%s %s %s : %s", os.date'%X', player.name, action or "says", words)
	tibia.radiusMessage(text, player.x, player.y, radiusX, radiusY, colour or 255255100)
	
	return 1
end, -1)

sea.listen("spawn", function(player)
	if not player.usgn then
		player:message("Please register a U.S.G.N. account at \"http://www.usgn.de/\" and make sure that you are logged in!", sea.Color.red)
	else
		if player.info[1] then
			for i, v in ipairs(player.info) do
				player:message(v, "255100100")
			end

			player.info = {}
		end
	end

	local lastPosition = player.lastPosition
	if lastPosition.x then
		player:setPosition(tileToPixel(lastPosition.x), tileToPixel(lastPosition.y))
	else
		player:setPosition(unpack(player.respawnPosition))
	end

	player:updateHUD()

	player:updateStats()

	player.health = player.hp <= 0 and 250 or player.hp

	return 'x'
end, -1)

sea.listen("drop", function(player, item, itemType, ammoIn, ammo, mode, x, y)
	if not player:exhaust("pick") then
		if tibia.Item.get(x, y)[1] then
			player:showTutorial("Pick Exhaust", "Try not to spam picking up, as there is an exhaust of half a second per try.")
		end

		return 1
	end
	
	player:pickItem()
end, -1)

sea.listen("second", function()
	tibia.updateTime()

	for _, player in ipairs(sea.Player.get()) do
		if player.alive then
			player.score = player.level
			player.deaths = player.id

			local lastPosition = player.lastPosition
			if lastPosition.x then
				local tile = sea.Tile.get(lastPosition.x, lastPosition.y)
				if tile.zone.HEAL and ((tile.zone.HEAL > 0 and tile.zone.HOUSE) or (tile.zone.HEAL < 0 and not tile.zone.SAFE)) and player.tmp.hp > player.hp then
					player.hp = player.health + math.min(10, tile.zone.HEAL)
					player.health = player.hp
				end
			end
		end
	end
end, -1)

sea.listen("minute", function()
	tibia.minutes = tibia.minutes + 1
	
	for i, v in ipairs(tibia.house) do
		if v.owner then
			local difftime = os.difftime(v.endtime, os.time())
			if difftime <= 0 then
				local online
				for _, player in ipairs(sea.Player.get()) do
					if player.usgn == v.owner then
						online = player
						break
					end
				end

				if not online then
					local saveData, save = sea.Player.dataStream(v.owner, 'usgn')

					if saveData then
						local info = saveData['info']
						table.insert(info, "Your house has expired. All items will be sent to your inventory.")
						save()
					end
				else
					online:message("Your house has expired. All items will be sent to your inventory.")
					online:updateHUD()
				end

				tibia.houseExpire(i)
			elseif difftime < 300 then
				for _, id in ipairs(sea.Player.get()) do
					if player.usgn == v.owner then
						player:message("Your house will expire in " .. difftime .. " seconds.")
						break
					end
				end
			end
		end
	end
end, -1)

sea.listen("serveraction", function(player, action)
	if not player.alive then 
		return 
	end

	if action == 2 then
		player:showTutorial("Inventory", "This is your inventory. You can equip or use items by clicking on them. You can press F4 to access your equipment.")
		player:viewInventory()
	elseif action == 3 then
		player:showTutorial("Equipment", "This is your equipment. You can unequip or use items by clicking on them.")
		player:viewEquipment()
	end
end)

sea.listen("hit", sea.Player.hit, -1)

sea.listen("kill", function(killer, victim, weapon, x, y)
	if victim:isAtZone("PVP") then
		return
	end

	if not killer.exists then 
		return 
	end

	killer:showTutorial("Kill", "You have killed a player! This is allowed, but it may create conflict between players.")

	local xp = victim.level + 10
	killer:addExp(math.floor(xp * math.random(50, 150) / 100 * tibia.config.expRate))
end, -1)

sea.listen("die", function(victim, killer, weapon, x, y)
	local tileX, tileY = pixelToTile(x), pixelToTile(y)
	local PVP = sea.Tile.get(tileX, tileY).zone.PVP
	
	if not PVP then
		victim:showTutorial("Die", "You are dead. Try your best not to die, you'll drop some of your equipment and rupee if you do.")

		local rupee = math.min(victim.rupee, math.floor(victim.level * math.random(50, 150) / 10 * tibia.config.playerMoneyRate))
		if rupee ~= 0 then
			victim:addRupee(-rupee)

			tibia.Item.spawnRupee(rupee, tileX, tileY)
		end

		if victim.level >= 5 then
			for i, v in ipairs(tibia.config.slots) do
				local slot = victim.tmp.equipment.slots[v]

				if slot:isOccupied() and math.random(10000) <= tibia.config.playerDropRate then
					victim:dropItem(slot.item, true)
				end
			end
		end

		victim.hp, victim.lastPosition.x, victim.lastPosition.y = 85, nil, nil
	else
		victim.hp, victim.lastPosition.x, victim.lastPosition.y = 5, tibia.pvpZone[PVP][3][1], tibia.pvpZone[PVP][3][2]

		local rupee = victim.rupee
		if rupee ~= 0 then
			if victim:addRupee(rupee) then
				tibia.Item.spawn(math.max(100, rupee), tileX, tileY)
			end
		end
	end
	
	sea.effect("colorsmoke", x, y, 64, 64, 192, 0, 0)
	tibia.radiusSound("weapons/c4_explode.wav", x, y)
end, 1)

sea.listen("use", function(player, event, data, x, y)
	local dir = math.floor((player.rotation + 45) / 90) % 4
	local x, y = player.lastPosition.x, player.lastPosition.y
	if dir == 0 then
		y = y - 1
	elseif dir == 1 then
		x = x + 1
	elseif dir == 2 then
		y = y + 1
	else
		x = x - 1
	end

	local tile = sea.Tile.get(x, y)
	local entity = sea.Entity.get(x, y)
	if entity and tile and tile.house then
		local house = tibia.house[tile.house]
		local name = entity.nameField
		local door = tonumber(name:sub(name:find('_')+1))
		player:showTutorial("Door #1", "This door belongs to a house. The house owner can specify who is allowed to open the door.")

		if door then
			if (player.usgn == house.owner or table.contains(house.doors[door], player.usgn)) then
				if player.usgn == house.owner then
					player:showTutorial("Door #2", "To choose who is allowed to open this door, use the command !house door")
				end

				entity:trigger()
			else
				player:message("It is locked.")
			end
		end
	end
end, -1)