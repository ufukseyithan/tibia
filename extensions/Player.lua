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
			self:updateStats()
		end
	else
		self:message("You may not drop something here.")
	end
end

function sea.Player:updateStats()
	local hp, spd, atk, def = self.tmp.hp, self.tmp.speed, self.tmp.attack, self.tmp.defence

	self:stripAll()
	
	local equipmentImage = self.tmp.equipmentImage

	for k, equipmentImage in pairs(equipmentImage) do
		equipmentImage:destroy()
		equipmentImage[k] = nil
	end

	local equipmentSlots = self.equipment.slots
	for _, slotName in ipairs(tibia.config.slots) do
		local slot = equipmentSlots[slotName]

		if slot:isOccupied() then
			local item = equipmentSlots[slotName].item
			local config = item.config

			hp = hp + (config.hp or 0)
			spd = spd + (config.speed or 0)
			atk = atk + (config.atk or 0)
			def = def + (config.def or 0)

			if config.equip then
				self:equip(config.equip)
			end

			if config.eimage then 
				if not equipmentImage[slotName].image then
					local image = sea.Image.create(config.eimage, config.static and 0 or 1, 0, (config.ground and 100 or 200) + self.id)
					
					if config.r then
						image.color = sea.Color.new(config.r, config.g, config.b)
					end

					local scaleX, scaleY = -(config.escalex or 1), config.escaley or 1
					image:scale(scaleX, scaleY)

					if config.blend then
						image.blend = config.blend
					end

					equipmentImage[slotName] = image
				end
			end
		end		
	end

	self.tmp.attack = atk
	self.tmp.defence = def
	self.tmp.speed = spd
	self.tmp.hp = hp

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
	local config = item.config

	if equip then
		if not self:addItem(item) then
			return
		end
	else
		if config.level and self.level < config.level then
			self:message("You need to be level "..config.level.." or above to equip it.")
			return
		end

		local slot = config.slot
		local equipment = self.equipment
		local leftHandSlot, rightHandSlot = equipment.slots["Left Hand"], equipment.slots["Right Hand"]

		if slot == "Left Hand" then
			if rightHandSlot:isOccupied() then
				if rightHandSlot.item.twohand then
					if not self:addItem(rightHandSlot.item) then 
						return 
					end
				end
			end
		elseif config.slot == "Right Hand" then
			if config.twohand then
				if leftHandSlot:isOccupied() then
					if not self:addItem(leftHandSlot.item) then 
						return 
					end
				end
			end
		end

		item:occupy(equipment.slots[slot])
	end

	self:updateStats()
end

function sea.Player:viewInventory(page)
	self:displayMenu(self.inventory:getMenu(), page)
end

function sea.Player:viewEquipment()
	self:displayMenu(self.equipment:getMenu(), page)
end