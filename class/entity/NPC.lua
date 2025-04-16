tibia.npc = {}
local NPC = class()

function NPC:constructor(config)
    self.config = config

    local x, y = unpack(config.pos)

    local image = sea.Image.create(config.image, x, y, 0)
    image.rotation = config.rot or 0
    self.image = image

    self.x, self.y = x, y
end

function NPC:speak(words)
	local text = string.format("�255255100%s %s says : %s", os.date'%X',  self.config.name, words)

	return tibia.radiusMessage(words, self.config.pos[1], self.config.pos[2])
end

function NPC:getTradeMenu()
	local trade = self.config.trade

	local menu = sea.Menu.new(self.config.name)

	menu.closeButtonFunc = function(player)
		if self.config.bye then
			self:speak(self.config.bye)
		end
	end

	for _, button in pairs(trade) do
		local itemId, price = unpack(button)
		local sell = price < 0

		local itemConfig = tibia.config.item[itemId]

		menu:addButton(itemConfig.name, function(player)
			if sell then
				if player:removeItem(itemId, 1, true) then
					player:addRupee(price)
					player:message("You have lost $" .. price .. ".", sea.Color.white)
					player:message("You have sold " .. itemConfig.article .. " " .. itemConfig.name .. " for $" .. price .. ".")
					return true
				end
				
				player:message("You do not have "..itemConfig.article.." "..tibia.config.item[itemid].name.." to sell.")
				return
			elseif player:addRupee(-price) then
				local item = tibia.Item.create(itemId)

				if player:addItem(item, true) then
					player:message("You have lost $"..price..".", sea.Color.white)
					player:message("You have bought "..itemConfig.article.." "..itemConfig.name.." for $"..price..".")
					return true
				end

				player:message("You do not have enough capacity.")
				return
			end
		end, price)
	end

	return menu
end

-------------------------
--        CONST        --
-------------------------

function NPC.spawn(config)
	local id = #tibia.npc + 1

	local npc = NPC.new(config)
	
    tibia.npc[id] = npc

	return npc
end

-------------------------
--        INIT         --
-------------------------

for _, config in ipairs(tibia.config.npc) do
	NPC.spawn(config)
end

local function contains(words, text) 
	words = words:lower(); 
	return words == text or words:find(text .. " ") or words:find(" " .. text) 
end

sea.addEvent("onHookSay", function(player, words)
	words = words:lower()

	local npcState = player.tmp.npcState
	if npcState then
		local npc = tibia.config.npc[npcState[1]]
		if isInside(player.x, player.y, npc.pos[1] - 96, npc.pos[2] - 96, npc.pos[1] + 96, npc.pos[2] + 96) then
			npc.func(npcState[1], player, words, npcState[2])
			return
		else
			player.tmp.npcState = nil
		end
	end

	if contains(words, "hi") or contains(words, "hello") or contains(words, "yo") or contains(words, "hey") then
		for _, npc in ipairs(tibia.npc) do
			local config = npc.config

			if isInside(player.x, player.y, config.pos[1] - 96, config.pos[2] - 96, config.pos[1] + 96, config.pos[2] + 96) then
				if config.func then
					config.func(player, "hi")
				elseif config.menu then
					player:displayMenu(npc:getTradeMenu())
				else
					npc:speak("Hello, I'm busy right now, speak to me later.")
					break
				end

				if config.greet then
					npc:speak(string.format(config.greet, player.name))
				end

				break
			end
		end
	end
end)

return NPC