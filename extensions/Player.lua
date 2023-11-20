function sea.Player:isAtZone(zone)
	return sea.tile[self.lastPosition.x][self.lastPosition.y].zone[zone]
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

	for k, v in ipairs(seşf.inventory) do
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
				self:message("You have received "..fullname(itemID)..".")
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
			spawnitem(itemID, self.lastPosition.x, self.lastPosition.y)
			dropped = dropped + 1
		end

		if tell then
			if remaining == 0 then
				player:message("You have received "..fullname(itemID, added)..".")
			else
				player:message("You have received "..fullname(itemID, added)..". ".. remaining.." are dropped due to lack of space.")
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
		elseif additem(self, item[1]) then
			local tile = sea.Tile.get(self.lastPosition.x, self.lastPosition.y)
			if tile.zone.HEAL and ITEMS[item[1]].heal then
				tile.zone.HEAL = tile.zone.HEAL - ITEMS[item[1]].heal
				if tile.zone.HEAL == 0 then
					tile.zone.HEAL = nil
				end
			end

			freeimage(item[2])

			self:message("You have picked up " .. fullname(item[1]) .. ".")

			tibia.groundItems[self.lastPosition.y][self.lastPosition.x][height] = nil
		end

		updateTileItems(unpack(self.lastPosition))
	end
	return true
end

function sea.Player:dropItem(itemSlot, equip)
	local inv = (equip and self.equipment or self.inventory)
	if spawnitem(inv[itemSlot], unpack(self.lastPosition)) then
		self:message("You have dropped " .. fullname(inv[itemSlot]) .. ".")

		if equip then
			updateEQ(self, {[itemSlot] = 0}, {[itemSlot] = inv[itemSlot]})
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
					self:message("You have lost " .. fullname(itemID, amount) .. ".")
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
