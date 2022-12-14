sea.addEvent("onHookJoin", function(player)
	player.tmp = {hp = 100, atk = 1, def = 1, spd = 0, usgn = player.usgn, equip = {}, exhaust = {}}

	for k, v in ipairs(CONFIG.SLOTS) do
		player.tmp.equip[k] = {}
	end
end, -1)

sea.addEvent("onHookLeave", function(player, reason)
	for k, v in ipairs(player.tmp.equip) do
		if v.image then freeimage(v.image) end
	end
end, -1)

sea.addEvent("onHookLeave", function(player, oldName, newName)
	--hudtxt2(id, 0, player.usgn ~= 0 and newName or "NOT LOGGED IN", "255100100", 565, 407-CONFIG.PIXELS, 1)
end, -1)

sea.addEvent("onHookWalkover", function()
	return 1
end, -1)

sea.addEvent("onHookMovetile", function(player, x, y)
	local entity = sea.Entity.new(x, y)
	local entityTypeName = entity.typeName

	if entityTypeName == "Info_T" or entityTypeName == "Info_CT" then
		return
	end

	local playerLastPosition = player.lastPosition

	if inarray(CONFIG.WATERTILES, tile(x, y, 'frame')) or player.tmp.paralyse then
		if not (player.equipment[7] and ITEMS[player.equipment[7]].water) then
			parse("setpos", id, playerLastPosition.x*32+16, playerLastPosition.y*32+16)
			return
		end
	end

	local tile = gettile(x, y)
	if tile.HOUSE then
		player:showTutorial("House", "This is a house. For more information about houses, type !house")

		house = HOUSES[tile.HOUSE]
		if not house.owner then
			parse("setpos", id, playerLastPosition.x*32+16, playerLastPosition.y*32+16)
			player:message("This house has no owner. Type \"!house\" for a list of house commands.")
			return
		elseif not (player.usgn == house.owner or inarray(house.allow, player.usgn)) then
			parse("setpos", id, house.ent[1]*32+16, house.ent[2]*32+16)
			
			player:message("You are not invited into " .. PLAYERCACHE[house.owner].name .. "'s house. Type \"!house\" for a list of house commands.", "255255255")
			return
		end
	end

	if GROUNDITEMS[y][x][1] then
		player:showTutorial("Pick", "You have stumbled upon something. Press the drop weapon button (default G) to pick it up.")
	end

	--hudtxt2(id, CONFIG.HUDTXT.SAFE, (tile.SAFE and "SAFE") or (tile.NOMONSTERSPVP and "NO MONSTERS") or (tile.NOPVP and "NO PVP") or (tile.PVP and "DEATHMATCH") or "","255064000", 320, 200, 1)
	
	if not tile.SAFE then
		player:showTutorial("Safe", "You have left a SAFE zone. From now, you will be able to both damage and be damaged.")
	elseif tile.NOMONSTERS and not tile.PVP then
		player:showTutorial("No Monsters", "You have entered a NO MONSTERS zone. No monsters will spawn here. However, PVP is still allowed!")
	elseif tile.NOPVP then
		player:showTutorial("No PvP", "You have entered a NO PVP zone. PVP is disabled here, but monsters can still spawn.")
	elseif tile.PVP then
		player:showTutorial("PvP", "You have entered a DEATHMATCH zone. In this area, you may fight for money. If you die here, you will drop a maximum of $100.")
	end

	player.lastPosition.x, player.lastPosition.y = x, y
end, -1)

sea.addEvent("onHookSay", function(player, words)
	local id = player.id

	if player.tmp.exhaust.talk then return 1 end
	player.tmp.exhaust.talk = true
	timerEx(CONFIG.EXHAUST.TALK, "rem.talkExhaust", 1, player)
	if words:sub(1,1) == '!' then
		command = words:sub(2):split(' ')
		local func = COMMANDS[command[1]]
		if func then
			table.remove(command,1)
			func(id,command)
		end
		return 1
	end

	player:showTutorial("Say", "Talking! I don't think you need a tutorial on that, but just to let you know, whatever you say can only be heard by people around you.")

	local picture = 'gfx/weiwen/talk.png'
	words = words:gsub('%s+', ' ')
	local radiusx, radiusy, colour, action
	if words:sub(-1) == '!' then
		words = words:upper()
		action = "yells"
		radiusx, radiusy = 1280, 960
	elseif words:sub(-1) == '?' then
		action = "asks"
		picture = 'gfx/weiwen/ask.png'
	elseif words:sub(1,2) == '::' then
		words = words:sub(3)
		action = "whispers"
		radiusx, radiusy = 48, 48
	end

	if words:find':D' or words:find'=D' or words:find':)' or words:find'=)' or words:find'%(:' or words:find'%(=' or words:find'xD' or words:find'lol' then
		picture = 'gfx/weiwen/happy.png'
	elseif words:find'>:%(' or words:find':@' or words:find'fuck' then
		picture = 'gfx/weiwen/angry.png'
	elseif words:find':%(' or words:find'=%(' or words:find'):' or words:find'):' or words:find':\'%(' or words:find':<' then
		picture = 'gfx/weiwen/sad.png'
	end

	timer(1000, "freeimage", image(picture, 0, 0, 200+id))
	local code = words:sub(1,2):lower()
	if code:sub(1,1) == '^' then
		colour = CONFIG.COLOURS[tonumber(code:sub(2,2), 36)]
		words = words:sub(3)
	end
	if player.team == 0 then
		radiusx, radiusy = 0, 0
	end

	local text = string.format("%s %s %s : %s", os.date'%X', player.name, action or "says", words)
	--text = os.date'%X' .. " " .. player(id, "name") .. " " .. (action or "says") .. " : " .. words
	radiusmsg(text, player.x, player.y, radiusx, radiusy, colour or 255255100)
	
	return 1
end, -1)

--[[addhook("say","_EXPsay",100)
function _EXPsay(id,words)
	return 1
end]]

sea.addEvent("onHookSpawn", function(player)
	local id = player.id

	if player.usgn == 0 then
		player:message("Please register a U.S.G.N. account at \"http://www.usgn.de/\" and make sure that you are logged in!", sea.Color.red)
	else
		if player.info[1] then
			for i, v in ipairs(player.info) do
				message(id, v, "255100100")
			end

			player.info = {}
		end
	end

	local playerLastPosition = player.lastPosition
	if playerLastPosition.x then
		parse("setpos", id, playerLastPosition.x * 32 + 16, playerLastPosition.y * 32 + 16)
	else
		parse("setpos", id, player.respawnPosition[1], player.respawnPosition[2])
	end

	--updateHUD(id)
	--hudtxt2(id,0,player.usgn ~= 0 and player.name or "NOT LOGGED IN","255100100", 565, 407-CONFIG.PIXELS, 1)

	local newItems, previousItems = {}, {}
	for i, v in ipairs(CONFIG.SLOTS) do
		newItems[i] = player.equipment[i]
		previousItems[i] = 0
	end

	updateEQ(player, newItems, previousItems)
	parse("sethealth", id, player.hp <= 0 and 250 or player.hp)

	return 'x'
end, -1)

sea.addEvent("onHookDrop", function(player, item, x, y)
	if player.tmp.exhaust.pick then
		if GROUNDITEMS[y][x][1] then
			player:showTutorial("Pick Exhaust", "Try not to spam picking up, as there is an exhaust of 1 second per try.")
		end

		return 1
	end

	player.tmp.exhaust.pick = true

	timerEx(CONFIG.EXHAUST.PICK, "rem.pickExhaust", 1, player)

	player:showTutorial("Pick", "You have picked up something. Press F2 to access your inventory!")
	
	pickitem(player)
	return 1
end, -1)

sea.addEvent("onHookSecond", function()
	updateTime()

	for _, player in ipairs(sea.Player.get()) do
		if player.health > 0 then
			player.score = player.level
			player.deaths = player.id
		end

		if player.lastPosition.x then
			local tile = gettile(unpack(player.lastPosition))
			if tile.HEAL and ((tile.HEAL > 0 and tile.HOUSE) or (tile.HEAL < 0 and not tile.SAFE)) and player.tmp.hp > player.hp then
				player.hp = player.health + math.min(10, tile.HEAL)
				player.health = player.hp
			end
		end
	end
end, -1)

sea.addEvent("onHookMinute", function()
	MINUTES = MINUTES+1
	for i, v in ipairs(HOUSES) do
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
					table.insert(PLAYERCACHE[v.owner].Info, "Your house has expired. All items will be sent to your inventory.")
				else
					online:message("Your house has expired. All items will be sent to your inventory.")
					--updateHUD(online)
				end

				houseexpire(i)
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

	if sea.game.password == "" and MINUTES % 5 == 0 then
		saveserver()
	end
end, -1)

--[[addhook("serveraction","EXPserveraction")
function EXPserveraction(id,action)
	if player(id, 'health') < 0 then return end
	if action == 1 then
		if not PLAYERS[id].Tutorial.inventory then
			message(id, "This is your inventory. You can equip or use items by clicking on them. You can press F3 to access your equipment.", "255128000")
			PLAYERS[id].Tutorial.inventory = true
		end
		inventory(id)
	elseif action == 2 then
		if not PLAYERS[id].Tutorial.inventory then
			message(id, "This is your equipment. You can unequip or use items by clicking on them.", "255128000")
			PLAYERS[id].Tutorial.inventory = true
		end
		equipment(id)
	elseif action == 3 then
		if PLAYERS[id].tmp.exhaust.use then
			return
		end
		PLAYERS[id].tmp.exhaust.use = true
		timer(CONFIG.EXHAUST.USE, "rem.useExhaust", tostring(id))
		local itemid = PLAYERS[id].Equipment[9]
		if itemid then
			local amount, items = itemcount(id, itemid)
			message(id, "Using " .. (amount == 0 and ("the last " .. ITEMS[itemid].name) or ("one of " .. fullname(itemid, amount+1))) .. "...@C", "000255000")
			ITEMS[itemid].func[1](id, 9, itemid, true)
			if amount > 0 then
				table.remove(PLAYERS[id].Inventory, items[1])
				PLAYERS[id].Equipment[9] = itemid
			end
		else
			message(id, "You can hold a rune and use F4 to cast it easily.", "255255255")
		end
	end
end]]

--[[addhook("menu","EXPmenu")
function EXPmenu(id, title, button)
	if player(id, 'health') < 0 then return end
	if player(id, 'team') == 0 then return end
	if button == 0 then return end
	if title:sub(1,9) == "Inventory" then
		local page = #title-9
		if button == 9 then
			inventory(id, (page+1)%(math.ceil(CONFIG.MAXITEMS/5)))
		elseif button == 8 then
			inventory(id, (page-1)%(math.ceil(CONFIG.MAXITEMS/5)))
		elseif PLAYERS[id][itemid] ~= 0 then
			local itemslot = button+page*5
			local itemid = PLAYERS[id].Inventory[itemslot]
			itemactions(id, itemslot)
			return
		end
	elseif title:find "Actions" then
		local itemslot, itemid
		local equip = title:sub(1,5) == 'Equip'
		if equip then
			itemslot = #title-12
			itemid = PLAYERS[id].Equipment[itemslot]
		else
			itemslot = #title-11
			itemid = PLAYERS[id].Inventory[itemslot]
		end
		if button == 8 then
			message(id, "You see " .. fullname(itemid) .. ". " .. (ITEMS[itemid].desc or "") .. (ITEMS[itemid].level and "You need to be level " .. ITEMS[itemid].level .. " or above to equip it." or ""))
		elseif button == 9 then
			dropitem(id,itemslot,equip)
		else
			ITEMS[itemid].func[button](id,itemslot,itemid,equip)
		end
	elseif title == "Equipment" then
		itemactions(id,button,true)
	end
	return 
end]]

EXPhit = function(victim, source, weapon, hpdmg, apdmg)
	local hp, damage, weaponName, name = victim.health
	if hpdmg <= 0 or source == 0 then
		victim.hp = hp - hpdmg
		return
	end

	if source.exists then
		if victim == source then 
			return 1 
		end

		if inarray({400, 401, 402, 403, 404}, source.equipment[7]) then 
			source:message("You may not attack on a horse.") 
			return 1 
		end
		
		if player:isAtZone("SAFE") or source:isAtZone("SAFE") or player:isAtZone("NOPVP") or source:isAtZone("NOPVP") then 
			source:message("You may not attack someone in a SAFE or PVP disabled area.") 
			return 1 
		end

		victim:showTutorial("Hit", "A player is attacking you! You can fight back by swinging your weapon at him.")

		local atk = source.tmp.atk
		local def = victim.tmp.def
		if weapon == 251 then
			damage = math.ceil(2500/math.random(80,120))
			weaponName = 'Rune'
		elseif weapon == 46 then
			damage = math.ceil(500/math.random(80,120))
			weaponName = 'Firewave'
		else
			local dmgMul = ((victim.level+50)*atk/def)/math.random(60,140)
			damage = math.ceil(20*dmgMul)
			weaponName = source.equipment[3] and ITEMS[source.equipment[3]].name or 'Dagger'
		end
	elseif type(source) == "table" then
		if victim:isAtZone("SAFE") or victim:isAtZone("NOMONSTERS") then 
			return 1 
		end
		
		damage = math.ceil(math.random(10,20)*hpdmg*source.atk/victim.tmp.def/15)
		source, weaponName = 0, source.name
	end

	local resultHP = hp - damage
	if resultHP > 0 then
		victim.health = resultHP

		parse("effect", "colorsmoke", victim.x, victim.y, 5, 16, 192, 0, 0)
	else
		victim:killBy(source, weaponName)
	end

	victim.hp = resultHP

	return 1
end
sea.addEvent("onHookHit", EXPhit, -1)

sea.addEvent("onHookKill", function(killer, victim, weapon, x, y)
	if victim:isAtZone("PVP") then
		return
	end

	if not killer.exists then 
		return 
	end

	killer:showTutorial("Kill", "You have killed a player! This is allowed, but it may create conflict between players.")

	local xp = victim.level + 10
	killer:addXp(math.floor(xp * math.random(50, 150) / 100 * CONFIG.EXPRATE))
end, -1)

sea.addEvent("onHookDie", function(victim, killer, weapon, x, y)
	local PVP = gettile(victim.lastPosition.x, victim.lastPosition.y).PVP
	
	if not PVP then
		victim:showTutorial("Die", "You are dead. Try your best not to die, you'll drop some of your equipment and money if you do.")

		local money = math.min(victim.money, math.floor(victim.level * math.random(50, 150) / 10 * CONFIG.PLAYERMONEYRATE))
		if money ~= 0 then
			victim:addMoney(-money)

			spawnitem(1337, victim.tileX, victim.tileY, money)
		end

		if victim.level >= 5 then
			local previousItems = {}
			for i, v in ipairs(CONFIG.SLOTS) do
				if victim.equipment[i] and math.random(10000) <= CONFIG.PLAYERDROPRATE then
					dropitem(victim, i, true)
				end
			end
		end

		victim.hp, victim.lastPosition.x, victim.lastPosition.y = 85, nil, nil
	else
		victim.hp, victim.lastPosition.x, victim.lastPosition.y = 5, PVPZONE[PVP][3][1], PVPZONE[PVP][3][2]

		local money = victim.money
		if money ~= 0 then
			money = money >= 100 and 100 or money

			if victim:addMoney(money) then
				spawnitem(1337, victim.tileX, victim.tileY, money)
			end
		end
	end

	local x, y = victim.x, victim.y
	
	parse("effect", "colorsmoke", x, y, 64, 64, 192, 0, 0)
	radiussound("weapons/c4_explode.wav", x, y)

	local newItems, previousItems = {}, {}
	for i, v in ipairs(CONFIG.SLOTS) do
		previousItems[i] = victim.equipment[i]
		newItems[i] = 0
	end

	updateEQ(victim, newItems, previousItems)
end, 1)

sea.addEvent("onHookUse", function(player, event, data, x, y)
	local dir = math.floor((player.rotation+45)/90)%4
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

	local tile = gettile(x, y)
	if entity(x, y, "exists") and tile.HOUSE then
		local house = HOUSES[tile.HOUSE]
		local name = entity(x, y, "name")
		local door = tonumber(name:sub(name:find('_')+1))
		player:showTutorial("Door 1", "This door belongs to a house. The house owner can specify who is allowed to open the door.")

		if door then
			if (player.usgn == house.owner or inarray(house.doors[door], player.usgn)) then
				if player.usgn == house.owner then
					player:showTutorial("Door 2", "To choose who is allowed to open this door, use the command !house door")
				end

				parse("trigger", name)
			else
				player:message("It is locked.")
			end
		end
	end
end, -1)