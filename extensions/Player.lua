function sea.Player:isAtZone(zone)
	local tile = sea.Tile.get(self.lastPosition.x, self.lastPosition.y)

	return tile and tile.zone[zone] or false
end

function sea.Player:addExp(amount)
    self.xp = self.xp + amount

	local previousLevel = self.level
	while self.xp >= tibia.config.expTable[self.level + 1] do
		self.level = self.level + 1
	end

	if previousLevel ~= self.level then
        player:message("You have leveled up to level "..player.level.."!")

        parse("sv_sound2", id, 'fun/Victory_Fanfare.ogg')
	end

	updateHUD(id)
	return true
end

function sea.Player:hit(source, weapon, hpdmg)
	local hp, damage, weaponName, name = self.health
	if hpdmg <= 0 or source == 0 then
		self.hp = hp - hpdmg
		return
	end

	local defence = self.tmp.defence

	if source.exists then
		if self == source then 
			return 1 
		end

		if table.contains({400, 401, 402, 403, 404}, source.equipment[7]) then 
			source:message("You may not attack on a horse.") 
			return 1 
		end
		
		if self:isAtZone("SAFE") or source:isAtZone("SAFE") or self:isAtZone("NOPVP") or source:isAtZone("NOPVP") then 
			source:message("You may not attack someone in a SAFE or PVP disabled area.") 
			return 1 
		end

		self:showTutorial("Hit", "A player is attacking you! You can fight back by swinging your weapon at him.")

		local attack = source.tmp.attack
		if weapon == 251 then
			damage = math.ceil(2500 / math.random(80, 120))
			weaponName = 'Rune'
		elseif weapon == 46 then
			damage = math.ceil(500 / math.random(80, 120))
			weaponName = 'Firewave'
		else
			local dmgMul = ((self.level + 50) * attack / defence) / math.random(60, 140)
			damage = math.ceil(20 * dmgMul)
			weaponName = source.equipment[3] and tibia.config.item[source.equipment[3]].name or 'Dagger'
		end
	elseif type(source) == "table" then
		if self:isAtZone("SAFE") or self:isAtZone("NOMONSTERS") then 
			return 1 
		end
		
		damage = math.ceil(math.random(10, 20) * hpdmg * source.config.attack / defence / 15)
		source, weaponName = 0, source.config.name
	end

	local resultHP = hp - damage
	if resultHP > 0 then
		self.health = resultHP

		parse("effect", "colorsmoke", self.x, self.y, 5, 16, 192, 0, 0)
	else
		self:killBy(source, weaponName)
	end

	self.hp = resultHP

	return 1
end

function sea.Player:addMoney(amount)
	if amount < 0 and self.money + amount < 0 then
		return false
	end

	self.money = self.money + amount
	
	return true
end

function sea.Player:showTutorial(name, message)
    if not self.tutorial[name] then
		self:hint(message)
		self.tutorial[name] = true
	end
end

function sea.Player:addItem(item, tell)
	local left = self.inventory:addItem(item)

	if left then
		if tell then
			if type(addition) == "table" then
				self:message("You have received "..item.fullName..". "..left.amount.." are dropped due to lack of space.")
			else
				self:message("You have received "..item.fullName..".")
			end
		end
	end

	return left
end

function sea.Player:removeItem(id, amount, tell)
	if self.inventory:removeItem(id, amount) then
		if tell then
			-- self:message("You have lost "..item.fullName..".")
			self:message("You have lost item.")
		end
	end
end

function sea.Player:pickItem()
	local ground = tibia.Item.getGroundItems(self.lastPosition.x, self.lastPosition.y)
	local height = #ground

	if height > 0 then
		local item = ground[height]
		if item.config.currency then
			self:addMoney(item.amount)
			self:message("You have picked up "..item.amount.." rupees.")

			item:destroy()
		elseif self:addItem(item) then
			self:message("You have picked up "..item.fullName..".")
			player:showTutorial("Pick", "You have picked up something. Press F3 to access your inventory!")
		end
	end

	return true
end

function sea.Player:dropItem(item, equip)
	if item:reposition(self.lastPosition.x, self.lastPosition.y) then
		self:message("You have dropped "..item.fullName..".")

		if equip then
			self:updateEQ({[itemSlot] = 0}, {[itemSlot] = inv[itemSlot]})
		end
	else
		self:message("You may not drop something here.")
	end
end

function sea.Player:updateEQ(newItems, previousItems)
	previousItems = previousItems or {}

	if not newItems then 
		return
	end

	self:equipAndSet(50)

	local hp, spd, atk, def = 0, 0, 0, 0
	local equip, strip = self:getItems(), {50, 41}



	-- Head slot

	for i, v in pairs(newItems) do
		if previousItems[i] then
			if self.tmp.equip[i].image then
				freeimage(self.tmp.equip[i].image)
				self.tmp.equip[i].image = nil
			end
			if self.tmp.equip[i].equip then
				self:strip(self.tmp.equip[i].equip)
				table.insert(strip, self.tmp.equip[i].equip)
				self.tmp.equip[i].equip = nil
			end
			if tibia.config.item[previousItems[i]].hp then
				hp=hp-tibia.config.item[previousItems[i]].hp
			end
			if tibia.config.item[previousItems[i]].speed then
				spd=spd-tibia.config.item[previousItems[i]].speed
			end
			if tibia.config.item[previousItems[i]].atk then
				atk=atk-tibia.config.item[previousItems[i]].atk
			end
			if tibia.config.item[previousItems[i]].def then
				def=def-tibia.config.item[previousItems[i]].def
			end
		end

		if newItems[i] ~= 0 then
			if tibia.config.item[newItems[i]].hp then
				hp=hp+tibia.config.item[newItems[i]].hp
			end
			if tibia.config.item[newItems[i]].speed then
				spd=spd+tibia.config.item[newItems[i]].speed
			end
			if tibia.config.item[newItems[i]].atk then
				atk=atk+tibia.config.item[newItems[i]].atk
			end
			if tibia.config.item[newItems[i]].def then
				def=def+tibia.config.item[newItems[i]].def
			end
			if tibia.config.item[newItems[i]].equip then
				self.tmp.equip[i].equip = tibia.config.item[newItems[i]].equip
				self:equip(tibia.config.item[newItems[1]].equip)
				table.insert(equip, tibia.config.item[newItems[i]].equip)
			end
			if tibia.config.item[newItems[i]].eimage then 
				if not self.tmp.equip[i].image then
					self.tmp.equip[i].image = image(tibia.config.item[newItems[i]].eimage, tibia.config.item[newItems[i]].static and 0 or 1, 0, (tibia.config.item[newItems[i]].ground and 100 or 200)+id)
					if tibia.config.item[newItems[i]].r then
						imagecolor(self.tmp.equip[i].image, tibia.config.item[newItems[i]].r, tibia.config.item[newItems[i]].g, tibia.config.item[newItems[i]].b)
					end
					local scalex, scaley = tibia.config.item[newItems[i]].escalex or 1, tibia.config.item[newItems[i]].escaley or 1
					scalex = scalex * -1
					imagescale(self.tmp.equip[i].image, scalex, scaley)
					if tibia.config.item[newItems[i]].blend then
						imageblend(self.tmp.equip[i].image, tibia.config.item[newItems[i]].blend)
					end
				end
			end
		end
	end

	for i, v in ipairs(equip) do
		if not table.contains(strip, v.id) then
			self.weapon = v.id
			self:strip(50)
		end
	end

	self.tmp.attack = self.tmp.attack + atk
	self.tmp.defence = self.tmp.defence + def
	self.tmp.speed = self.tmp.speed + spd
	self.tmp.hp = self.tmp.hp + hp

	local temphp = self.health
	self.maxHealth = self.tmp.hp
	self.health = temphp

	self.speed = self.tmp.speed
end

function sea.Player:eat(item)
	tibia.radiusMessage(self.name.." eats "..item.fullName..".", self.x, self.y, 384)

	self.health = self.health + item.config.food()

	self.hp = health

	item:consume()
end

function sea.Player:equipItem(item, equip)
	local previousItems, newItems = {}, {}

	if equip then
		if not self:addItem(item) then
			return
		end

		previousItems[itemSlot] = self.equipment[itemSlot] or 0
		self.equipment[itemSlot] = nil
		newItems[itemSlot] = 0
	else
		if tibia.config.item[itemID].level and self.level < tibia.config.item[itemID].level then
			self:message("You need to be level " .. tibia.config.item[itemID].level .. " or above to equip it.")
			return
		end

		newItems[tibia.config.item[itemID].slot] = itemID
		if tibia.config.item[itemID].slot == 4 then
			if self.equipment[3] then
				if tibia.config.item[self.equipment[3]].twohand then
						if not self:addItem(self.equipment[3]) then return end
						previousItems[3] = self.equipment[3] or 0
						self.equipment[3] = nil
						newItems[3] = 0
				end
			end
		elseif tibia.config.item[itemID].slot == 3 then
			if tibia.config.item[itemID].twohand then
				if self.equipment[4] then
					if not self:addItem(self.equipment[4]) then return end
					previousItems[4] = self.equipment[4] or 0
					self.equipment[4] = nil
					newItems[4] = 0
				end
			end
		end
		
		self:destroyItem(itemSlot)
		if self.equipment[tibia.config.item[itemID].slot] then
			previousItems[tibia.config.item[itemID].slot] = self.equipment[tibia.config.item[itemID].slot]
			self:addItem(player.equipment[tibia.config.item[itemID].slot])
		else
			previousItems[tibia.config.item[itemID].slot] = 0
		end

		self.equipment[tibia.config.item[itemID].slot] = itemID
	end

	self:updateEQ(newItems, previousItems)
end

function sea.Player:itemActions(itemSlot, equip)
	local text = (equip and "Equip" or "Item").." Actions"

	local menu = sea.Menu.new(text)

	local itemID
	if equip then
		itemID = self.equipment[itemSlot] or 0
	else
		itemID = self.inventory[itemSlot] or 0
	end

	for i, v in ipairs(tibia.config.item[itemID].action) do
		menu:addButton(v, function(player)
			tibia.config.item[itemID].func[i](player, itemSlot, itemID, equip)
		end)
	end

	menu:setStaticButton(8, "Examine", function(player)
		player:message("You see "..tibia.itemFullName(itemID)..". "..(tibia.config.item[itemID].desc or "")..(tibia.config.item[itemID].level and "You need to be level "..tibia.config.item[itemID].level.." or above to equip it." or ""))
	end)

	menu:setStaticButton(9, "Drop", function(player)
		player:dropItem(itemSlot, equip)
	end)

	return menu
end

function sea.Player:viewInventory(page)
	local menu = sea.Menu.new("Inventory")

	for k, v in pairs(self.inventory) do
		local name

		if tibia.config.item[v] then
			name = tibia.config.item[v].name
		else
			name = k or ""
		end

		menu:addButton(name, function(player)
			return player:itemActions(k)
		end, k)
	end

	self:displayMenu(menu, page)
end

function sea.Player:viewEquipment()
	local menu = sea.Menu.new("Equipment")

	for k, v in ipairs(tibia.config.slots) do
		local name = tibia.config.item[self.equipment[k] or 0].name or ("ITEM ID "..self.equipment[k])

		menu:addButton(name, function(player)
			return player:itemActions(k, true)
		end, v)
	end

	self:displayMenu(menu, page)
end