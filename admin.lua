adminList = {132253}

function isAdmin(player)
	for _, usgn in ipairs(adminList) do
		if player.usgn == usgn then
			return true
		end
	end

	return false
end

--[[
Admin Commands
!a - teleport forward
!b - broadcast to server with name
!c - teleport player to you
!d - broadcast to server without name
!e - explosion
!i - spawn item
!h - heal player
!l - run lua script (expensive)
!m - summon monster
!n - return npc position
!o - return tile position
!p - return position
!q - earthquake
!s - speedmod
!t - teleport you to player
!u - shutdown
!v - save server
]]
sea.addEvent("onHookSay", function(player, words)
	if isAdmin(player) and words:sub(1,1) =='!' then
		local command = words:lower():sub(2,2)
		if words:sub(3,3) ~= ' ' and #words ~= 2 then 
			return 
		end
		print(player.name..' used a command:'..words)

		if command =='a' then
			local distance = tonumber(words:sub(4))
			if distance then
				local rot = math.rad(player.rotation - 180)
				local x, y = -math.sin(rot)*distance*32, math.cos(rot)*distance*32
				player:setPosition(player.x + x, player.y + y)
			else
				player:message("Teleport forward: \"!a <distance>\"")
			end

			return 1
		elseif command =='b' then
			sea.message(0, player.name.." : "..words:sub(4).."@C", "255100100")
			return 1
		elseif command =='c' then
			local targetID = tonumber(words:sub(4))
			
			if targetID then
				local target = sea.player[targetID]

				if target.exists then
					if target == player then
						player:message("You may not teleport to yourself!")
					end

					target:setPosition(player.x, player.y)
					return 1
				end
			end

			player:message("Teleport player to you: \"!c <targetid>\"")

			return 1
		elseif command =='d' then
			sea.message(0, words:sub(4).."@C", "255100100")

			return 1
		elseif command =='e' then
			local dmg = tonumber(words:sub(4))

			if dmg then
				sea.explosion(player.x, player.y, dmg, dmg, player.id)

				return 1
			end

			player:message("Spawn explosion: \"!e <dmg>\"")

			return 1
		elseif command =='i' then
			local itemID = tonumber(words:sub(4))

			if itemID then
				player:addItem(tibia.Item.create(itemID))

				return 1
			end

			player:message("Spawn item: \"!i <itemid>\"")

			return 1
		elseif command =='h' then
			local s = words:find(' ',4)
			local targetID = tonumber(words:sub(4,s))

			if targetID then
				local target = sea.player[targetID]

				if target.exists then
					local heal = s and tonumber(words:sub(s+1,words:find(' ',s+1))) or nil
					if heal then
						sea.explosion(target.x, target.y, 1, -heal)
						return 1
					end
				end
			end

			player:message("Heal player: \"!h <targetid> <amount>\"")

			return 1
		elseif command =='l' then
			local script = words:sub(4)
			if script then
				player:message(tostring(assert(loadstring(script))() or 'done!'))

				return
			end

			player:message("Run lua script: \"!l <script>\"")

			return 1
		elseif command =='m' then
			if sea.tile[player.tileX][player.tileY].zone.SAFE then
				player:message("You may not spawn a monster in a safe zone.")
				
				return 1
			end

			local name = words:sub(4)

			if name then
				for i, v in pairs(CONFIG.tibia.monster) do
					if v.name:lower() == name:lower() then
						local m = deepcopy(v)
						m.x, m.y = player(id, 'x'), player(id, 'y')
						Monster:new(m)
						player:message("Monster "..name.." spawned.")

						return 1
					end
				end
			end

			player:message("Monster "..name.." does not exist.")

			return 1
		elseif command =='n' then
			player:message("{"..(player.tileX*32+16)..", "..(player.tileY*32+16)..'}')

			return 1
		elseif command =='o' then
			player:message('{'..player.tileX..', '..player.tileY..'}')

			return 1
		elseif command =='p' then
			player:message('{'..player.x..', '..player.y..'}')

			return 1
		elseif command =='q' then
			local length = tonumber(words:sub(3))

			if length then
				length = math.min(length * 50, 250)
				for _, player in ipairs(sea.Player.get()) do
					player:shake(length)
				end

				for i = 1, 6 do
					if math.random(0,1) == 1 then
						parse("sv_sound", "weapons/explode"..i..".wav")
					end
				end
			else
				player:message("Earthquake: \"!q <length in seconds, max 5>\"")
			end

			return 1
		elseif command =='s' then
			local s = words:find(' ',4)
			local targetID = tonumber(words:sub(4,s))

			if targetID then
				local target = sea.player[targetID]

				if target.exists then
					local speed = s and tonumber(words:sub(s+1,words:find(' ',s+1))) or nil

					if speed then
						target.speed = speed
						
						return 1
					end
				end
			end

			player:message("Speed modifier: \"!s <targetid> <speedmod, between -100 and 100>\"")
			
			return 1
		elseif command =='t' then
			local targetID = tonumber(words:sub(3))

			if targetID then
				local target = sea.player[targetID]

				if target.exists then
					if target == player then
						player:message("You may not teleport to yourself!")
					end

					player:setPosition(target.x, target.y)
					
					return 1
				end
			end
			
			player:message("Teleport to player: \"!t <targetid>\"")
			return 1
		elseif command =='u' then
			local delay = tonumber(words:sub(3)) or 0

			tibia.shutdown(delay*1000)

			return 1
		elseif command =='v' then
			tibia.saveServer()

			player:message("Saved server!")

			return 1
		end
	end
end)
