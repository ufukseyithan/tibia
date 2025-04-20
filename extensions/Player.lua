function sea.Player:exhaust(action, delay)
	local exhaust = self.tmp.exhaust

	if exhaust[action] then
		return false
	end

	exhaust[action] = true

	local function cooldown()
		exhaust[action] = false
	end

	timerEx(delay or tibia.config.exhaust[action], cooldown)

	return true
end

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
        self:message("You have leveled up to level "..self.level.."!")
		self:playSound("fun/Victory_Fanfare.ogg")
	end

	self:updateHUD()

	return true
end

function sea.Player:updateHUD()
	for i, v in ipairs(tibia.config.stats) do
		self.tmp.ui['text'..v]:setText(self[v:lower()])
	end
end

function sea.Player:hit(source, itemType, damage)
	local hp, weaponName, name = self.health
	if damage <= 0 or source == 0 then
		self.hp = hp - damage
		return
	end

	local defence = self.tmp.defence

	if source.exists then
		if self == source then 
			return 1 
		end

		local equipmentSlots = source.tmp.equipment.slots

		local mountSlot = equipmentSlots["Mount"]
		if table.contains({400, 401, 402, 403, 404}, mountSlot:isOccupied() and mountSlot.item.id or 0) then 
			source:message("You may not attack on a horse.") 
			return 1 
		end
		
		if self:isAtZone("SAFE") or source:isAtZone("SAFE") or self:isAtZone("NOPVP") or source:isAtZone("NOPVP") then 
			source:message("You may not attack someone in a SAFE or PVP disabled area.") 
			return 1 
		end

		self:showTutorial("Hit", "A player is attacking you! You can fight back by swinging your weapon at him.")

		local attack = source.tmp.attack

		if itemType.id == 251 then
			damage = math.ceil(2500 / math.random(80, 120))
			weaponName = 'Rune'
		elseif itemType.id == 46 then
			damage = math.ceil(500 / math.random(80, 120))
			weaponName = 'Firewave'
		else
			local dmgMul = ((self.level + 50) * attack / defence) / math.random(60, 140)
			damage = math.ceil(20 * dmgMul)

			local leftHandSlot = equipmentSlots["Left Hand"]
			weaponName = leftHandSlot:isOccupied() and leftHandSlot.item.config.name or 'Dagger'
		end
	else -- if it is a monster
		if self:isAtZone("SAFE") or self:isAtZone("NOMONSTERS") then 
			return 1 
		end
		
		damage = math.ceil(math.random(10, 20) * damage / defence / 15)
		source, weaponName = 0, source.config.name
	end

	self:message(damage)

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

function sea.Player:addRupee(amount)
	if amount < 0 and self.rupee + amount < 0 then
		return false
	end

	self.rupee = self.rupee + amount

	self:updateHUD()
	
	return true
end

function sea.Player:showTutorial(name, message)
    if not self.tutorial[name] then
		self:hint(message)
		self.tutorial[name] = true
	end
end

function sea.Player:addItem(item, tell)
	if item.config.currency then		
		self:addRupee(item.amount)
		item:destroy()

		if tell then
			self:message("You have received "..item.amount.." rupees.")
		end

		return true
	end

	local left = self.tmp.inventory:addItem(item)

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
	if self.tmp.inventory:removeItem(id, amount) then
		if tell then
			-- self:message("You have lost "..item.fullName..".")
			self:message("You have lost item.")
		end

		return true
	end

	return false
end

function sea.Player:pickItem()
	local ground = tibia.Item.get(self.lastPosition.x, self.lastPosition.y)
	local height = #ground

	if height > 0 then
		local item = ground[height]
		local itemName = item.fullName

		if self:addItem(item) then
			if item.config.currency then
				self:message("You have picked up "..item.amount.." rupees.")
			else
				self:message("You have picked up "..itemName..".")
			end
			
			self:showTutorial("Pick", "You have picked up something. Press F3 to access your inventory!")
		end
	end

	return true
end

function sea.Player:dropItem(item, equip)
	item:reposition(self.lastPosition.x, self.lastPosition.y)

	self:message("You have dropped "..item.fullName..".")

	if equip then
		self:updateStats()
	end
end

function sea.Player:updateStats()
	local hp, atk, def, spd = 100, 1, 1, 0

	local toEquip = {}

	self:stripAll()
	
	local equipmentImage = self.tmp.equipmentImage
	for k, v in pairs(equipmentImage) do
		v:destroy()
		equipmentImage[k] = nil
	end

	local equipmentSlots = self.tmp.equipment.slots
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
				table.insert(toEquip, config.equip)
			end

			if config.eimage then 
				if not equipmentImage[slotName] then
					local image = sea.Image.create(config.eimage, config.static and 0 or 3, 0, (config.ground and 100 or 200) + self.id)
					
					if config.r then
						image.color = sea.Color.new(config.r, config.g, config.b)
					end

					local scaleX, scaleY = -(config.escalex or 1), config.escaley or 1
					image:scale(scaleX, scaleY)

					if config.blend then
						image.blendMode = config.blend
					end

					equipmentImage[slotName] = image
				end
			end
		end		
	end

	-- set weapon, strip knife
	for _, v in ipairs(toEquip) do
		self:equip(v)
		self.weapon = v
	end

	self:stripKnife()

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
	tibia.radiusMessage(self.name.." eats "..item.config.name..".", self.x, self.y, 384)

	self.health = self.health + item.config.food()

	self.hp = self.health

	item:consume(1)
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

		local slotName = config.equipSlot
		local equipmentSlots = self.tmp.equipment.slots
		local leftHandSlot, rightHandSlot = equipmentSlots["Left Hand"], equipmentSlots["Right Hand"]

		if slotName == "Left Hand" then
			if rightHandSlot:isOccupied() then
				if rightHandSlot.item.config.twohand then
					if not self:addItem(rightHandSlot.item) then 
						return 
					end
				end
			end
		elseif slotName == "Right Hand" then
			if config.twohand then
				if leftHandSlot:isOccupied() then
					if not self:addItem(leftHandSlot.item) then 
						return 
					end
				end
			end
		end

		local targetSlot = equipmentSlots[slotName]

		if targetSlot:isOccupied() then
			if self:addItem(targetSlot.item) then
				item:occupy(targetSlot)
			else
				item:swap(targetSlot)
			end
		else
			item:occupy(targetSlot)
		end
	end

	self:updateStats()
end

function sea.Player:viewInventory(page)
	local menu = self.tmp.inventory:getMenu()

	menu:setStaticButton(9, "Rupees", nil, self.rupee)

	self:displayMenu(menu, page)
end

function sea.Player:viewEquipment(page)
	self:displayMenu(self.tmp.equipment:getMenu(), page)
end

-------------------------
--     PROPERTIES      --
-------------------------

function sea.Player:tileProperty()
    return function(self)
        return sea.Tile.get(self.lastPosition.x, self.lastPosition.y)
    end
end