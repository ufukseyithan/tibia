tibia.command = {
	['me'] = function(player, p)
		if p[1] then
			tibia.radiusMessage(string.format("* %s %s",player.name, table.concat(p)), player.x, player.y)
		else
			tibia.radiusMessage(string.format("* %s does nothing.", player.name), player.x, player.y)
		end
	end, 

	['drop'] = function(player, p)
		p[1] = math.floor(tonumber(p[1]))

		if not p[1] then 
			player:message('Usage: !drop <amount>') 
			return 
		end

		if player:isAtZone('PVP') then 
			player:message('You may not drop rupee here.') 
			return 
		end

		if p[1] <= 0 then 
			player:message('You may only drop positive amounts.') 
			return 
		end

		if not player:addRupee(-p[1]) then
			player:message('You do not have enough rupee to drop.') 
			return 
		end

		player:message('You have dropped '..p[1]..' rupees.')

		tibia.Item.spawnRupee(p[1], player.tileX, player.tileY)
	end,

	['w'] = function(player, p)
		local target = tonumber(p[1])
		if target then 
			local target = sea.player[target]

			if target and target.id ~= player.id then
				table.remove(p, 1)
				local text = table.concat(p, " ")
				player:message(target.name.." <- "..text)
				target:message(player.name.." -> "..text)
				print(player.name.." -> "..target.name.." : "..text)
			end
		end
	end, 

	['usgn'] = function(player, p)
		p[1] = tonumber(p[1])
		if p[1] then
			local target = sea.player[p[1]]

			if target then
				local usgn = target.usgn
				if usgn ~= 0 then
					player:message(target.name..' has a U.S.G.N. ID of '..usgn..'.')
				else
					player:message(target.name..' is not logged in to U.S.G.N. .')
				end

				return
			end
		end

		player:message('Usage: !usgn <targetid>')
	end, 

	['tutorial'] = function(player, p)
		player.tutorial = {}
		player:message('You have restarted your tutorial.')
	end, 

	['credits'] = function(player)
		-- if you remove this, please at least leave some credits to me, thank you. - weiwen
		player:message('This script is made by weiwen. Edited by Masea.')
	end,

	['house'] = function(player, p)
		local tile = player.tile
		local house
		if p[1] == 'info' then
			house = tibia.house[tile.houseEntrance or tile.house]
			if not house then 
				player:message('You are not in front of a house.') 
				return 
			end

			if not house.owner then 
				player:message('This house does not have an owner. It costs $' .. house.price .. ' per 24 hours.') 
				return 
			end

			local time = house.endtime - os.time()
			local seconds = time % 60
			local minutes = ((time - seconds)/60) % 60
			local hours = (time - minutes*60 - seconds) / 3600
			local saveData = sea.Player.getSaveData(house.owner, 'usgn')
			player:message('This house is owned by '..saveData.lastName..' and will expire in '..hours..' hours, '..minutes..' minutes It costs $' .. house.price .. ' per 24 hours .')
		elseif p[1] == 'buy' then
			if player.usgn == 0 then 
				player:message('You are not logged in to U.S.G.N. .') 
				return 
			end
			
			local house = tibia.house[tile.houseEntrance or tile.house]
			if not house then 
				player:message('You are not in front of a house.') 
				return 
			end
			if house.owner and house.owner ~= player.usgn then 
				player:message('This house already has an owner.') 
				return 
			end

			if player:addRupee(-house.price) then
				if house.endtime then
					house.endtime = house.endtime + 86400
					player:message('You have payed the rent for $' .. house.price .. ', 24 hours, in advance.')
				else
					house.owner = player.usgn
					house.endtime = os.time() + 86400
					player:message('You have bought this house for $' .. house.price .. ', 24 hours.')
				end
			else
				player:message('You do not have enough rupee. It costs $' .. house.price .. ' per 24 hours.')
			end

			player:save()
		elseif p[1] == 'extend' then
			if player.usgn == 0 then player:message('You are not logged in to U.S.G.N. .') return end
			house = tibia.house[tile.house]
			if not house then 
				player:message('You are not in a house.') 
				return 
			end

			if house.owner ~= player.usgn then player:message('This house already has an owner.') return end
			if player:addRupee(-house.price) then
				house.endtime = house.endtime + 86400
				player:message('You have payed the rent for $' .. house.price .. ', 24 hours in advance.')
			end
		elseif p[1] == 'exit' then
			local house = tibia.house[tile.house]
			if house then
				player:setPosition(tileToPixel(house.ent[1]), tileToPixel(house.ent[2]))
				return
			end

			player:message('You are not in or infront of a house.')
		elseif p[1] == 'allow' then
			house = tibia.house[tile.house]
			if not house then 
				player:message('You are not in a house.') 
				return 
			end

			if player.usgn ~= house.owner then 
				player:message('You are not the owner of this house.') 
				return 
			end

			local saveData
			p[2] = tonumber(p[2])
			if not p[2] then
				saveData = sea.Player.getSaveData(p[2], 'usgn')

				if not saveData then 
					player:message('Please indicate a U.S.G.N. ID to allow.') 
					return 
				end
			end

			for i, v in ipairs(house.allow) do
				if v == p[2] then
					table.remove(house.allow, i)
					player:message('You have disallowed ' .. saveData.lastName .. ' to enter your house.')
					return
				end
			end

			table.insert(house.allow, p[2])
			player:message('You have allowed ' .. saveData.lastName .. ' to enter your house.')
			table.sort(house.allow)
		elseif p[1] == 'door' then
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
			local tile = sea.Tile.get(x, y)
			local house, door
			local entity = sea.Entity.get(x, y)
			if entity and tile.house then
				house = tibia.house[tile.house]
				local name = entity.nameField
				door = tonumber(name:sub(name:find('_')+1))
			end

			if not door then 
				player:message('There is no door infront of you.') 
				return 
			end

			if player.usgn ~= house.owner then 
				player:message('You are not the owner of this house.') 
				return 
			end
			
			if p[2] == 'allow' then
				p[3] = tonumber(p[3])
				local saveData
				if not p[3] then
					saveData = sea.Player.getSaveData(p[3], 'usgn')
					if not saveData then 
						player:message('Please indicate a U.S.G.N. ID to allow.') 
						return 
					end
				end

				for i, v in ipairs(house.doors[door]) do
					if v == p[3] then
						table.remove(house.doors[door], i)
						player:message('You have disallowed ' .. saveData.lastName .. ' to open this door.')
						return
					end
				end
				table.insert(house.doors[door], p[3])
				player:message('You have allowed ' .. saveData.lastName .. ' to open this door.')
				table.sort(house.doors[door])
			elseif p[2] == 'list' then
				local text = 'Allowed players : '
				for i, v in ipairs(house.doors[door]) do
					local saveData = sea.Player.getSaveData(v, 'usgn')
					text = text.. saveData.lastName .. ' (' .. v .. '), '
				end
				text = #text == 18 and 'No players are allowed.' or text:sub(1, -3)
				player:message(text)
			end
		elseif p[1] == 'list' then
			local house = tibia.house[tile.house]
			if not house then
				player:message('You are not in a house.') 
				return 
			end

			if player.usgn ~= house.owner then 
				player:message('You are not the owner of this house.') 
				return 
			end

			local text = 'Allowed players : '
			for i, v in ipairs(house.allow) do
				local saveData = sea.Player.getSaveData(v, 'usgn')
				text = text.. saveData.lastName .. ' (' .. v .. '), '
			end
			text = #text == 18 and 'No players are allowed.' or text:sub(1, -3)
			player:message(text)
		elseif p[1] == 'transfer' then
			local house = tibia.house[tile.house]
			if not house then 
				player:message('You are not in a house.') 
				return 
			end

			if player.usgn ~= house.owner then 
				player:message('You are not the owner of this house.') 
				return 
			end
			
			p[2] = tonumber(p[2])
			if not p[2] then 
				player:message('Please indicate player ID to transfer.') 
				return 
			end

			local target = sea.player[p[2]]
			if not target then 
				player:message('That user is not online.') 
				return 
			end

			house.owner = p[2]
			player:message('You have transfered the ownership of this house to ' .. target.name .. '.')
			target:message(player.name .. ' has transfered the ownership of this house to you.')
		else
			player:message('HOUSE commands:')
			player:message('!house - gives information about all house commands')
			player:message('!house info - use infront of a house to give you information about it.')
			player:message('!house buy - buys the house you are infront of')
			player:message('!house extend - extends the ownership of the house you are in')
			player:message('!house exit - use in a house to exit it')
			player:message('!house allow <usgnid> - allows the person to enter your house')
			player:message('!house door allow <usgnid> - allows the person to open the door you are facing')
			player:message('!house door list - lists the people allowed to open the door you are facing')
			player:message('!house list - lists the people allowed to enter your house')
			player:message('!house transfer <usgnid> - transfers ownership to that player')
		end
	end, 
}
tibia.command['drop$'] = tibia.command.drop

local cmds = "The commands are : "
for i, v in pairs(tibia.command) do
	cmds = cmds .. i .. ", "
end
cmds = cmds:sub(1, -3)
tibia.command.help = function(player)
	print(cmds)
	player:message(cmds)
end
tibia.command.cmds = tibia.command.help
tibia.command.commands = tibia.command.help