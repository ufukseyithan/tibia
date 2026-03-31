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
	local text = string.format("%s %s says : %s", os.date'%X',  self.config.name, words)

	return tibia.radiusMessage(text, self.config.pos[1], self.config.pos[2], nil, nil, sea.Color.new(255, 255, 100))
end

function NPC:interact(player, words)
	local config = self.config

	if config.func then
		config.func(self, player, "hi")
	elseif config.trade then
		player:displayMenu(self:getTradeMenu())
	else
		self:speak("Hello, I'm busy right now, speak to me later.")
		return
	end

	if config.greet then
		self:speak(string.format(config.greet, player.name))
	end
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
		local sell = itemId < 0
		itemId = math.abs(itemId)

		local itemConfig = tibia.config.item[itemId]
		local itemFullName = tibia.Item.getFullName(itemId)

		menu:addButton((sell and 'sell' or 'buy')..' '..itemConfig.name, function(player)
			if sell then
				if player:removeItem(itemId, 1) then
					player:addRupee(price)
					player:message("You have received "..price.." rupees.", sea.Color.white)
					player:message("You have sold "..itemFullName.." for "..price.." rupees.")
					return true
				end
				
				player:message("You do not have "..itemFullName.." to sell.")
				return
			elseif player:addRupee(-price) then
				local item = tibia.Item.create(itemId)

				if player:addItem(item) then
					player:message("You have lost "..price.." rupees.", sea.Color.white)
					player:message("You have bought "..itemFullName.." for "..price.." rupees.")
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

sea.listen("say", function(player, words)
	words = words:lower()

	local npcState = player.tmp.npcState
	if npcState then
		local npc = npcState[1]
		if isInside(player.x, player.y, npc.x - 96, npc.y - 96, npc.x + 96, npc.y + 96) then
			npc.config.func(npcState[1], player, words, npcState[2])
			return
		else
			player.tmp.npcState = nil
		end
	end

	if contains(words, "hi") or contains(words, "hello") or contains(words, "yo") or contains(words, "hey") then
		for _, npc in ipairs(tibia.npc) do
			local config = npc.config

			if isInside(player.x, player.y, config.pos[1] - 96, config.pos[2] - 96, config.pos[1] + 96, config.pos[2] + 96) then
				npc:interact(player)
				break
			end
		end
	end
end)

return NPC