COMMANDS = {
	['me'] = function(id, p)
		if p[1] then
			radiusmsg(string.format("* %s %s", player(id, 'name'), table.concat(p)), player(id, 'x'), player(id, 'y'))
		else
			radiusmsg(string.format("* %s does nothing.", player(id, 'name')), player(id, 'x'), player(id, 'y'))
		end
	end, 
	['drop'] = function(id, p)
		p[1] = math.floor(tonumber(p[1]))
		if not p[1] then message(id,'Usage: !drop <amount>','255255255') return end
		if gettile(PLAYERS[id].x, PLAYERS[id].y).PVP then message(id,'You may not drop money here.','255255255') return end
		if p[1] <= 0 then message(id,'You may only drop positive amounts.','255255255') return end
		if not addmoney(id,-p[1]) then message(id,'You do not have enough money to drop.','255255255') return end
		message(id,'You have dropped $'..p[1]..'.','255255255')
		spawnitem(1337,PLAYERS[id]['x'],PLAYERS[id]['y'],p[1])
	end,
	['w'] = function(id, p)
		local target = tonumber(p[1])
		if target and player(target, 'exists') and target ~= id then
			table.remove(p, 1)
			local text = table.concat(p, " ")
			message(id, player(target, 'name') .. " <- " .. text)
			message(target, player(id, 'name') .. " -> " .. text)
			print(player(id, 'name') .. " -> " .. player(target, 'name') .. " : " .. text)
		end
	end, 
	['usgn'] = function(id, p)
		p[1] = tonumber(p[1])
		if p[1] and player(p[1], 'exists') then
			local usgn = player(p[1], 'usgn')
			if usgn ~= 0 then
				message(id, PLAYERS[p[1]].name..' has a U.S.G.N. id of '..usgn..'.', '255255255')
				return
			else
				message(id, PLAYERS[p[1]].name..' is not logged in to U.S.G.N. .', '255255255')
				return
			end
		end
		message(id, 'Usage: !usgn <targetid>', '255255255')
	end, 
	['tutorial'] = function(id, p)
		PLAYERS[id].Tutorial = {}
		message(id, 'You have restarted your tutorial.', '255255255')
	end, 
	['credits'] = function(id)
		-- if you remove this, please at least leave some credits to me, thank you.
		message(id, 'This script is made by weiwen.')
	end,
	['house'] = function(id, p)
		local house
		if p[1] == 'info' then
			local tile = gettile(PLAYERS[id].x, PLAYERS[id].y)
			local house = HOUSES[tile.HOUSEENT or tile.HOUSE]
			if not house then message(id, 'You are not in front of a house.', '255255255') return end
			if not house.owner then message(id, 'This house does not have an owner. It costs $' .. house.price .. ' per 24 hours.', '255255255') return end
			local time = house.endtime - os.time()
			local seconds = time % 60
			local minutes = ((time - seconds)/60) % 60
			local hours = (time - minutes*60 - seconds) / 3600
			message(id, 'This house is owned by '..PLAYERCACHE[house.owner].name..' and will expire in '..hours..' hours, '..minutes..' minutes It costs $' .. house.price .. ' per 24 hours .', '255255255')
		elseif p[1] == 'buy' then
			if player(id, 'usgn') == 0 then message(id, 'You are not logged in to U.S.G.N. .', '255255255') return end
			local tile = gettile(PLAYERS[id].x, PLAYERS[id].y)
			local house = HOUSES[tile.HOUSEENT or tile.HOUSE]
			if not house then message(id, 'You are not in front of a house.', '255255255') return end
			if house.owner and house.owner ~= player(id, 'usgn') then message(id, 'This house already has an owner.', '255255255') return end
			if addmoney(id, -house.price) then
				if house.endtime then
					house.endtime = house.endtime + 86400
					message(id, 'You have payed the rent for $' .. house.price .. ', 24 hours, in advance.', '255255255')
				else
					house.owner = player(id, 'usgn')
					house.endtime = os.time() + 86400
					message(id, 'You have bought this house for $' .. house.price .. ', 24 hours.', '255255255')
				end
			else
				message(id, 'You do not have enough money. It costs $' .. house.price .. ' per 24 hours.', '255255255')
			end
		elseif p[1] == 'extend' then
			if player(id, 'usgn') == 0 then message(id, 'You are not logged in to U.S.G.N. .', '255255255') return end
			local house = HOUSES[gettile(PLAYERS[id].x, PLAYERS[id].y).HOUSE]
			if not house then message(id, 'You are not in a house.', '255255255') return end
			if house.owner ~= player(id, 'usgn') then message(id, 'This house already has an owner.', '255255255') return end
			if addmoney(id, -house.price) then
				house.endtime = house.endtime + 86400
				message(id, 'You have payed the rent for $' .. house.price .. ', 24 hours in advance.', '255255255')
			end
		elseif p[1] == 'exit' then
			local tile = gettile(PLAYERS[id].x, PLAYERS[id].y)
			local house = HOUSES[tile.HOUSE]
			if house then
				setpos(id, house.ent[1]*32+16, house.ent[2]*32+16)
				return
			end
			message(id, 'You are not in or infront of a house.', '255255255')
		elseif p[1] == 'allow' then
			local house = HOUSES[gettile(PLAYERS[id].x, PLAYERS[id].y).HOUSE]
			if not house then message(id, 'You are not in a house.', '255255255') return end
			if player(id, 'usgn') ~= house.owner then message(id, 'You are not the owner of this house.', '255255255') return end
			p[2] = tonumber(p[2])
			if not p[2] or not PLAYERCACHE[p[2]] then message(id, 'Please indicate a U.S.G.N. id to allow.', '255255255') return end
			for i, v in ipairs(house.allow) do
				if v == p[2] then
					table.remove(house.allow, i)
					message(id, 'You have disallowed ' .. PLAYERCACHE[p[2]].name .. ' to enter your house.', '255255255')
					return
				end
			end
			table.insert(house.allow, p[2])
			message(id, 'You have allowed ' .. PLAYERCACHE[p[2]].name .. ' to enter your house.', '255255255')
			table.sort(house.allow)
		elseif p[1] == 'door' then
			if p[2] == 'allow' then
				local dir = math.floor((player(id, 'rot')+45)/90)%4
				local x, y = PLAYERS[id].x, PLAYERS[id].y
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
				local house, door
				if entity(x, y, "exists") and tile.HOUSE then
					house = HOUSES[tile.HOUSE]
					local name = entity(x, y, "name")
					door = tonumber(name:sub(name:find('_')+1))
				end
				if not door then message(id, 'There is no door infront of you.', '255255255') return end
				if player(id, 'usgn') ~= house.owner then message(id, 'You are not the owner of this house.', '255255255') return end
				p[3] = tonumber(p[3])
				if not p[3] or not PLAYERCACHE[p[3]] then message(id, 'Please indicate a U.S.G.N. id to allow.', '255255255') return end
				for i, v in ipairs(house.doors[door]) do
					if v == p[3] then
						table.remove(house.doors[door], i)
						message(id, 'You have disallowed ' .. PLAYERCACHE[p[3]].name .. ' to open this door.', '255255255')
						return
					end
				end
				table.insert(house.doors[door], p[3])
				message(id, 'You have allowed ' .. PLAYERCACHE[p[3]].name .. ' to open this door.', '255255255')
				table.sort(house.doors[door])
			elseif p[2] == 'list' then
				local dir = math.floor((player(id, 'rot')+45)/90)%4
				local x, y = PLAYERS[id].x, PLAYERS[id].y
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
				local house, door
				if entity(x, y, "exists") and tile.HOUSE then
					house = HOUSES[tile.HOUSE]
					local name = entity(x, y, "name")
					door = tonumber(name:sub(name:find('_')+1))
				end
				if not door then message(id, 'There is no door infront of you.', '255255255') return end
				if player(id, 'usgn') ~= house.owner then message(id, 'You are not the owner of this house.', '255255255') return end
				local text = 'Allowed players : '
				for i, v in ipairs(house.doors[door]) do
					text = text.. PLAYERCACHE[v].name .. ' (' .. v .. '), '
				end
				text = #text == 18 and 'No players are allowed.' or text:sub(1, -3)
				message(id, text, '255255255')
			else
				message(id, 'HOUSE DOOR COMMANDS:', '255100100')
				message(id, '!house door allow <usgnid> - allows the person to open the door you are facing', '255100100')
				message(id, '!house door list - lists the people allowed to open the door you are facing', '255100100')
			end
		elseif p[1] == 'list' then
			local house = HOUSES[gettile(PLAYERS[id].x, PLAYERS[id].y).HOUSE]
			if not house then message(id, 'You are not in a house.', '255255255') return end
			if player(id, 'usgn') ~= house.owner then message(id, 'You are not the owner of this house.', '255255255') return end
			local text = 'Allowed players : '
			for i, v in ipairs(house.allow) do
				text = text.. PLAYERCACHE[v].name .. ' (' .. v .. '), '
			end
			text = #text == 18 and 'No players are allowed.' or text:sub(1, -3)
			message(id, text, '255255255')
		elseif p[1] == 'transfer' then
			local house = HOUSES[gettile(PLAYERS[id].x, PLAYERS[id].y).HOUSE]
			if not house then message(id, 'You are not in a house.', '255255255') return end
			if player(id, 'usgn') ~= house.owner then message(id, 'You are not the owner of this house.', '255255255') return end
			p[2] = tonumber(p[2])
			if not p[2] then message(id, 'That user is not online.', '255255255') return end
			local target
			for _, v in ipairs(player(0, 'table')) do
				if player(v, 'usgn') == p[2] then
					target = v
					break
				end
			end
			if not target then message(id, 'That user is not online.', '255255255') return end
			house.owner = p[2]
			message(id, 'You have transfered the ownership of this house to ' .. PLAYERCACHE[p[2]].name .. '.', '255255255')
			message(target, PLAYERCACHE[p[2]].name .. ' has transfered the ownership of this house to you.', '255255255')
		else
			message(id, 'HOUSE COMMANDS:', '255100100')
			message(id, '!house - gives information about all house commands', '255100100')
			message(id, '!house info - use infront of a house to give you information about it.', '255100100')
			message(id, '!house buy - buys the house you are infront of', '255100100')
			message(id, '!house extend - extends the ownership of the house you are in', '255100100')
			message(id, '!house exit - use in a house to exit it', '255100100')
			message(id, '!house allow <usgnid> - allows the person to enter your house', '255100100')
			message(id, '!house door allow <usgnid> - allows the person to open the door you are facing', '255100100')
			message(id, '!house door list - lists the people allowed to open the door you are facing', '255100100')
			message(id, '!house list - lists the people allowed to enter your house', '255100100')
			message(id, '!house transfer <usgnid> - transfers ownership to that player', '255100100')
		end
	end, 
}
COMMANDS['drop$'] = COMMANDS.drop

local cmds = "The commands are : "
for i, v in pairs(COMMANDS) do
	cmds = cmds .. i .. ", "
end
cmds = cmds:sub(-3)
COMMANDS.help = function(id)
	message(id, cmds)
end
COMMANDS.cmds = COMMANDS.help
COMMANDS.commands = COMMANDS.help