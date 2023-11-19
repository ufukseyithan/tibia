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