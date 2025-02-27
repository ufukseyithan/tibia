tibia.monster = {}
local Monster = class()

function Monster:constructor(id, config, x, y)
    self.id = id
    self.config = config

    local image = sea.Image.create(config.image, x, y, 0)
    image:scale(config.scaleX, config.scaleY)
    image:hitZone(1)
    self.image = image

    self.x, self.y = x, y
    self.health = config.health
    self.angle = 0
    self.imageAngle = 0
end

function Monster:setPosition(x, y)
	if not x and not y then
		return self.x, self.y
	else
		self.x, self.y = x or self.x, y or self.y
		self.image:setPosition(self.x, self.y, self.imageAngle)
	end

	return true
end

function Monster:move(dir, amt)
    local config = self.config

	local x, y = -math.sin(dir) * amt * config.speed, math.cos(dir) * amt * config.speed
	x, y = self.x + x, self.y + y
	
	local tileX, tileY = pixelToTile(x), pixelToTile(y)
	local tile = sea.Tile.get(tileX, tileY)

	if tile and tile.walkable and tile.frame ~= 34 and not tile.zone.SAFE and not tile.zone.NOMONSTERS then
		self:setPosition(x, y)
		return true
	end

	self:rotate(math.random(-1, 1) * math.pi / 2)
	return false
end

function Monster:rotate(rot)
	if not rot then
		return self.angle
	else
		self.angle = (self.angle + rot) % (math.pi * 2)
	end

	return true
end

function Monster:damage(player, damage, weapon)
    local config = self.config

	player:showTutorial("Damage Monster", "You have attacked a monster! Good job! Keep on attacking it until it dies.")

	self.health = self.health - damage

	if self.health <= 0 then
		player:showTutorial("Kill Monster", "Congratulation! You have killed your first monster. You can proceed to pick up the loot by using the drop weapon button (default G)")

		player:addExp(math.floor(config.exp * tibia.config.expRate))

		self:die()
	else
		sea.effect("colorsmoke", self.x, self.y, 10, config.scaleY, config.r or 192, config.g or 0, config.b or 0)
	end

	tibia.radiusSound("weapons/machete_hit.wav", self.x, self.y)

	return true
end

function Monster:hit(player, damage)
	player:showTutorial("Hit Monster", "A monster is attacking you! You can fight back by swinging your weapon at it.")

	if player.weapon == 41 and (math.abs(math.rad(player.rotation) - math.atan2(player.y - self.y, player.x - self.x) + math.pi / 2) % (2 * math.pi) <= math.pi * 2 / 3) then
		damage = damage / 4

		tibia.radiusSound("weapons/ricmetal"..math.random(1,2)..".wav", self.x, self.y)
	else
		tibia.radiusSound("weapons/knife_hit.wav", self.x, self.y)
	end

    player:hit(self, -1, damage * self.config.attack)
end

function Monster:die()
    local config = self.config

	local size = config.scaleX + config.scaleY
	sea.effect("colorsmoke", self.x, self.y, size, 64, config.r or 192, config.g or 0, config.b or 0)
	
	local tileX, tileY = pixelToTile(self.x), pixelToTile(self.y)

	tibia.Item.spawnRupee(math.floor(config.rupee * math.random(50, 150) / 100) * tibia.config.moneyRate, tileX, tileY)

	for _, loot in ipairs(config.loot) do
		local chance = math.random(10000)
		if chance <= loot.chance then
			tibia.Item.spawn(loot.id, tileX, tileY)
		end
	end

	tibia.radiusSound("weapons/c4_explode.wav", self.x, self.y)

	self:destroy()
end

function Monster:destroy()
    self.image:destroy()

    tibia.monster[self.id] = nil
end

-------------------------
--        CONST        --
-------------------------

function Monster.spawn(config, x, y)
    local id = #tibia.monster + 1

	local monster = Monster.new(id, config, x, y)

    tibia.monster[id] = monster

	return monster
end

-------------------------
--        INIT         --
-------------------------

sea.addEvent("onHookHitzone", function(image, player, object, itemType)
	local tile = sea.Tile.get(player.lastPosition.x, player.lastPosition.y)
	if tile.zone.SAFE or tile.zone.NOMONSTERS then
		return
	end

    local mountSlot = player.tmp.equipment.slots["Mount"]
	if mountSlot:isOccupied() and table.contains({400, 401, 402, 403, 404}, mountSlot.item.id) then
		player:alert("You may not attack on a horse.")
		return
	end

    for _, monster in pairs(tibia.monster) do
        if monster.image == image then
            monster:damage(player, math.ceil(20 * ((player.level + 50) * player.tmp.attack / monster.config.defence) / math.random(60, 140)), itemType)
        end
    end
end, -1)

if tibia.config.maxMonsters > 0 then
    local t = 0
    sea.addEvent("onHookMs100", function()
        t = t + 1

        if t % 100 == 0 then
            while #tibia.monster < tibia.config.maxMonsters do
                local rand, mapName, spawnNo
                while true do 
                    rand = math.random(#tibia.config.monster)
                    mapName = tibia.config.monster[rand].spawn[sea.map.name] and sea.map.name or tibia.config.defaultMap
                    spawnNo = math.random(#tibia.config.monster[rand].spawn[mapName])
                    if math.random(0, 100) < tibia.config.monster[rand].spawnChance[mapName][spawnNo] then
                        break
                    end
                end 

                local config = deepcopy(tibia.config.monster[rand])
                local x, y, tileX, tileY, tile
                local spawn = config.spawn[mapName][spawnNo]
                repeat
                    tileX, tileY = math.random(spawn[1][1], spawn[2][1]), math.random(spawn[1][2], spawn[2][2])
                    tile = sea.tile[tileX] and sea.tile[tileX][tileY]
                until 
                    tile and
                    not tile.zone.SAFE and 
                    not tile.zone.NOMONSTERS and 
                    tile.walkable and 
                    tile.frame ~= 34

                Monster.spawn(config, tileToPixel(tileX), tileToPixel(tileY))
            end
        end

        for _, m in pairs(tibia.monster) do
            local config = m.config

            if t % config.attackSpeed == 0 then
                m.target = nil

                local closest
                for _, player in ipairs(table.shuffle(sea.Player.getLiving())) do
                    if not player:isAtZone("SAFE") and not player:isAtZone("NOMONSTERS") then
                        local dist = getDistance(player.x, player.y, m.x, m.y)
                        if dist < 400 then
                            if not closest or dist < closest[2] then
                                closest = {player, dist}
                            end
                        end
                    end
                end

                if closest then
                    local dist = closest[2]
                    if dist < 400 then
                        m.target = closest[1]
                        if config.spc and math.random(10000) <= config.spc[1] then
                            config.spc[2](m, m.target, dist)
                        elseif dist <= (config.range or 32) then
                            m:hit(m.target, 10)
                        end
                    end
                end
            end

            m.imageAngle = math.sin(t / 2.5 * math.pi) * 15
            if m.target and m.target.exists and m.target.health > 0 and not m.target:isAtZone("SAFE") and not m.target:isAtZone("NOMONSTERS") then
                local xDist, yDist = m.target.x - m.x, m.target.y - m.y
                local dist = math.sqrt(xDist ^ 2 + yDist ^ 2)
                if dist < 400 then
                    m.angle = math.atan2(yDist, xDist) - math.pi / 2 + math.random(-1, 1) / 2
                else
                    m.target = nil
                end
            end

            if not m.target then
                m:rotate(math.random(-1, 1) / 2)
            end

            if not m:move(m:rotate(), m.health > config.runAt and 1 or -1) then
                repeat until m:move(math.rad(math.random(360)), 1)
            end
        end
    end, -1)
end

return Monster