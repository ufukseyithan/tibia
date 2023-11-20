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

function sea.Player:clearInventory(slot)
	if slot then
		table.remove(self.inventory, slot)
	else
		self.inventory = {}
	end

	return true
end

function sea.Player:itemCount(itemID)
	local amount, items = 0, {}

	for k, v in ipairs(self.inventory) do
		if v == itemID then
			amount = amount + 1
			table.insert(items, k)
		end
	end

	return amount, items
end

function sea.Player:addItem(itemID, amount, tell)
	if not ITEMS[itemID] or itemID == 0 then 
		return false 
	end

	amount = amount and math.floor(amount) or 1

	if amount == 1 then
		if #self.inventory < tibia.config.maxItems then
			table.insert(self.inventory, itemID)

			if tell then
				self:message("You have received "..tibia.itemFullName(itemID)..".")
			end

			return true
		end

		return false
	else
		local added = 0
		while #self.inventory < tibia.config.maxItems and added < amount do
			table.insert(self.inventory, itemID)
			added = added + 1
		end

		local remaining = amount - added
		local dropped = 0
		while dropped < remaining do
			tibia.spawnItem(itemID, self.lastPosition.x, self.lastPosition.y)
			dropped = dropped + 1
		end

		if tell then
			if remaining == 0 then
				player:message("You have received "..tibia.itemFullName(itemID, added)..".")
			else
				player:message("You have received "..tibia.itemFullName(itemID, added)..". ".. remaining.." are dropped due to lack of space.")
			end
		end

		return true
	end
end

function sea.Player:pickItem()
	local ground = tibia.groundItems[self.lastPosition.y][self.lastPosition.x]
	local height = #ground

	if height > 0 then
		local item = ground[height]
		if item[1] == 1337 then
			if item[2] then 
				freeimage(item[2]) 
			end

			self:addMoney(item[3])
			self:message("You have picked up $" .. item[3] .. ".")

			tibia.groundItems[self.lastPosition.y][self.lastPosition.x][height] = nil
		elseif self:addItem(item[1]) then
			local tile = sea.Tile.get(self.lastPosition.x, self.lastPosition.y)
			if tile.zone.HEAL and ITEMS[item[1]].heal then
				tile.zone.HEAL = tile.zone.HEAL - ITEMS[item[1]].heal
				if tile.zone.HEAL == 0 then
					tile.zone.HEAL = nil
				end
			end

			freeimage(item[2])

			self:message("You have picked up "..tibia.itemFullName(item[1])..".")

			tibia.groundItems[self.lastPosition.y][self.lastPosition.x][height] = nil
		end

		tibia.updateTileItems(unpack(self.lastPosition))
	end

	return true
end

function sea.Player:dropItem(itemSlot, equip)
	local inv = (equip and self.equipment or self.inventory)

	if tibia.spawnItem(inv[itemSlot], self.lastPosition.x, self.lastPosition.y) then
		self:message("You have dropped " .. tibia.itemFullName(inv[itemSlot]) .. ".")

		if equip then
			self:updateEQ({[itemSlot] = 0}, {[itemSlot] = inv[itemSlot]})
			inv[itemSlot] = nil
		else
			table.remove(inv, itemSlot)
		end
	else
		self:message("You may not drop something here.")
	end
end

function sea.Player:removeItem(itemID, amount, tell)
	if not ITEMS[itemID] or itemID == 0 then 
		return false 
	end

	amount = amount and math.floor(amount) or 1

	local removed = 0
	local has, toremove = itemcount(self, itemID)
	if has >= amount then
		for k, v in ipairs(toremove) do
			if removed < amount then
				table.remove(self.inventory, v+1-k)
				removed = removed + 1
			end
			if removed == amount then
				if tell then
					self:message("You have lost " .. tibia.itemFullName(itemID, amount) .. ".")
				end
				return true
			end
		end
	end

	return false
end

function sea.Player:destroyItem(itemSlot, equip)
	if equip then
		self.equipment[itemSlot] = nil
	else
		table.remove(self.inventory, itemSlot)
	end

	return true
end

function sea.Player:updateEQ(newItems, previousItems)
	previousItems = previousItems or {}

	if not newItems then 
		return 
	end

	self:equipAndSet(50)

	local hp, spd, atk, def = 0, 0, 0, 0
	local equip, strip = self:getItems(), {50, 41}

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
				self.tmp.equip[i].equip = ITEMS[newItems[i]].equip
				self:equip(ITEMS[newItems[1]].equip)
				table.insert(equip, ITEMS[newItems[i]].equip)
			end
			if ITEMS[newItems[i]].eimage then 
				if not self.tmp.equip[i].image then
					self.tmp.equip[i].image = image(ITEMS[newItems[i]].eimage, ITEMS[newItems[i]].static and 0 or 1, 0, (ITEMS[newItems[i]].ground and 100 or 200)+id)
					if ITEMS[newItems[i]].r then
						imagecolor(self.tmp.equip[i].image, ITEMS[newItems[i]].r, ITEMS[newItems[i]].g, ITEMS[newItems[i]].b)
					end
					local scalex, scaley = ITEMS[newItems[i]].escalex or 1, ITEMS[newItems[i]].escaley or 1
					scalex = scalex * -1
					imagescale(self.tmp.equip[i].image, scalex, scaley)
					if ITEMS[newItems[i]].blend then
						imageblend(self.tmp.equip[i].image, ITEMS[newItems[i]].blend)
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

	self.tmp.atk = self.tmp.atk + atk
	self.tmp.def = self.tmp.def + def
	self.tmp.spd = self.tmp.spd + spd
	self.tmp.hp = self.tmp.hp + hp

	local temphp = self.health
	self.maxHealth = self.tmp.hp
	self.health = temphp

	self.speed = self.tmp.spd
end

function sea.Player:eat(itemSlot, itemID)
	tibia.radiusMessage(self.name.." eats "..ITEMS[itemID].article.." ".. ITEMS[itemID].name .. ".", self.x, self.y, 384)

	self.health = self.health + ITEMS[itemID].food()

	self.hp = health

	self:destroyItem(itemSlot)
end

function sea.Player:equipItem(itemSlot, itemID, equip)
	local index = equip and "Equipment" or "Inventory"
	local previousItems, newItems = {}, {}

	if equip then
		if not self:addItem(itemID) then
			return
		end

		previousItems[itemSlot] = self.equipment[itemSlot] or 0
		self.equipment[itemSlot] = nil
		newItems[itemSlot] = 0
	else
		if ITEMS[itemID].level and self.level < ITEMS[itemID].level then
			self:message("You need to be level " .. ITEMS[itemID].level .. " or above to equip it.")
			return
		end

		newItems[ITEMS[itemID].slot] = itemID
		if ITEMS[itemID].slot == 4 then
			if self.equipment[3] then
				if ITEMS[self.equipment[3]].twohand then
						if not self:addItem(self.equipment[3]) then return end
						previousItems[3] = self.equipment[3] or 0
						self.equipment[3] = nil
						newItems[3] = 0
				end
			end
		elseif ITEMS[itemID].slot == 3 then
			if ITEMS[itemID].twohand then
				if self.equipment[4] then
					if not self:addItem(self.equipment[4]) then return end
					previousItems[4] = self.equipment[4] or 0
					self.equipment[4] = nil
					newItems[4] = 0
				end
			end
		end
		
		self:destroyItem(itemSlot)
		if self.equipment[ITEMS[itemID].slot] then
			previousItems[ITEMS[itemID].slot] = self.equipment[ITEMS[itemID].slot]
			self:addItem(player.equipment[ITEMS[itemID].slot])
		else
			previousItems[ITEMS[itemID].slot] = 0
		end

		self.equipment[ITEMS[itemID].slot] = itemID
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

	for i, v in ipairs(ITEMS[itemID].action) do
		menu:addButton(v, function(player)
			ITEMS[itemID].func[i](player, itemSlot, itemID, equip)
		end)
	end

	menu:setStaticButton(8, "Examine", function(player)
		player:message("You see "..tibia.itemFullName(itemID)..". "..(ITEMS[itemID].desc or "")..(ITEMS[itemID].level and "You need to be level "..ITEMS[itemID].level.." or above to equip it." or ""))
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

		if ITEMS[v] then
			name = ITEMS[v].name
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
		local name = ITEMS[self.equipment[k] or 0].name or ("ITEM ID "..self.equipment[k])

		menu:addButton(name, function(player)
			return player:itemActions(k, true)
		end, v)
	end

	self:displayMenu(menu, page)
end