tibia.groundItems = {}
local Item = class()

Item.defaultMaxStack = 200

function Item:constructor(config, attributes)
    attributes = attributes or {}

    self.config = config
	self.maxStack = config.stackable and config.maxStack or self.defaultMaxStack 
	self.amount = attributes.amount or 1
end

function Item:count()
	return self.amount or 1
end

function Item:consume(amount)
	amount = amount or self.amount

	local consumeAmount = math.max(0, self.amount - amount)

	self.amount = self.amount - consumeAmount

	if self.amount <= 0 then
		self:destroy()
	end

	return consumeAmount
end

function Item:restore(amount)
	amount = amount or 1

	local restoreAmount = math.min(self.maxStack, self.amount + amount)

	self.amount = self.amount + restoreAmount

	return restoreAmount
end

function Item:split(amount)
	if not self.config.stackable then
		return
	end

	amount = amount or math.ceil(self.amount / 2)

	local newStack = Item.create(self.id, self.attributes)

	newItem:restore(self:consume(amount))

	return newStack
end

function Item:destroy()
	local x, y, height = self:isOnGround()
	local slot = self:isInSlot()

	if x then
		local tile = sea.Tile.get(x, y)
		if tile.zone.HEAL and self.config.heal then
			tile.zone.HEAL = tile.zone.HEAL - self.config.heal
			if tile.zone.HEAL == 0 then
				tile.zone.HEAL = nil
			end
		end

		Item.getGroundItems(x, y)[height] = nil
		tibia.updateTileItems(x, y)

		self.x, self.y, self.height = nil, nil, nil
	elseif slot then
		slot.item = nil
	end
end

function Item:occupy(slot)
	local config = self.config

	if slot.type and slot.type ~= config.type then
		return false
	end

	if config.stackable and slot.item and slot.item.id == self.id then
		item:restore(self:consume())

		return self.amount <= 0 and true or self
	elseif not slot.item then
		self:destroy()

		slot.item = self

		return true
	end

	return false
end

function Item:reposition(x, y)
	self:destroy()

	local ground = Item.getGroundItems(x, y)
	local tile = sea.Tile.get(x, y)
	local height = #ground + 1

	self.x, self.y, self.height = x, y, height

    if self.config.heal then
        tile.zone.HEAL = (tile.zone.HEAL or 0) + config.heal
    end

	ground[height] = self
    tibia.updateTileItems(x, y)
end

function Item:isOnGround()
	return self.x, self.y, self.height
end

function Item:isInSlot()
	return self.slot
end

function Item:getActionMenu(equip)
	local text = self.fullName.." Actions"

	local menu = sea.Menu.new(text)

	local config = self.config

	for i, v in ipairs(config.action) do
		menu:addButton(v, function(player)
			config.func[i](player, self, equip)
		end)
	end

	menu:setStaticButton(8, "Examine", function(player)
		player:message("You see "..self.fullName..". "..(config.desc or "")..(config.level and "You need to be level "..config.level.." or above to equip it." or ""))
	end)

	menu:setStaticButton(9, "Drop", function(player)
		player:dropItem(self, equip)
	end)

	return menu
end

-------------------------
--      PROPERTIES     --
-------------------------

function Item:fullNameProperty()
	return function(self)
        local config, amount = self.config, self.amount

        if not amount or amount == 1 then
            return config.article.." "..config.name
        else
            return amount.." "..config.plural
        end
    end
end

-------------------------
--        CONST        --
-------------------------

function Item.create(id, attributes)
	local config = tibia.config.item[id]
    if not config then
        return
    end

	local item = Item.new(config, attributes)

	item.id = id

	return item
end

function Item.getGroundItems(x, y)
    tibia.groundItems[y] = tibia.groundItems[y] or {}
    tibia.groundItems[y][x] = tibia.groundItems[y][x] or {}

    return tibia.groundItems[y][x]
end

function Item.spawn(id, x, y, attributes)
	local item = Item.create(id, attributes)

	item:reposition(x, y)

	return item
end

local maxHeight = tibia.config.maxHeight
function Item.updateTile(x, y)
	local groundItems = Item.getGroundItems(x, y)
	if #groundItems ~= 0 then
		for i = 1, #groundItems do
			local item = groundItems[i]
			if item and item.image then
				item.image:destroy()
			end
		end
	end

	local height = 0
	for i = (#groundItems - maxHeight + 1 > 0) and (#groundItems - maxHeight + 1) or 1, #groundItems do
		height = height + 1
		local item = groundItems[i]
        local config = item.config
		local amount = item.amount
		local x = config.offsetX and tileToPixel(x) + config.offsetX or tileToPixel(x)
		local y = config.offsetY and tileToPixel(y) + config.offsetY or tileToPixel(y)
		local heightOffset = (height < maxHeight and height or maxHeight) * 3

		if config.currency then
            item.image = sea.Image.create("gfx/weiwen/rupee.png", 0, 0, height > 3 and 1 or 0)
            item.image.alpha = 0.8

			if amount < 5 then
                item.image.color = sea.Color.new(64, 255, 0)
			elseif amount < 10 then
                item.image.color = sea.Color.new(0, 64, 255)
			elseif amount < 20 then
                item.image.color = sea.Color.new(255, 255, 0)
			elseif amount < 50 then
                item.image.color = sea.Color.new(255, 64, 0)
			elseif amount < 100 then
                item.image.color = sea.Color.new(200, 0, 200)
			elseif amount < 200 then
                item.image.color = sea.Color.new(255, 128, 0)
			elseif amount < 500 then
                item.image.color = sea.Color.new(128, 255, 128)
			elseif amount < 1000 then
                item.image.color = sea.Color.new(128, 128, 255)
				imagecolor(item[2], 128, 128, 255)
			elseif amount < 2000 then
                item.image.color = sea.Color.new(255, 128, 128)
			elseif amount < 5000 then
                item.image.color = sea.Color.new(64, 128, 64)
			elseif amount < 10000 then
                item.image.color = sea.Color.new(64, 64, 128)
			elseif amount < 20000 then
                item.image.color = sea.Color.new(128, 64, 64)
			else
                item.image.color = sea.Color.new(192, 192, 192)
			end
		else
			item.image = sea.Image.create(config.fimage or "gfx/weiwen/circle.png", 0, 0, i > 3 and 1 or 0)
			if config.r then
				item.image.color(config.r, config.g, config.b)
			end
		end

        item.image:setPosition(x - heightOffset, y - heightOffset, config.rot or 0)

		local scaleX, scaleY = config.fscalex or 1, config.fscaley or 1
		local magnification = math.min(height, 10) / 20 + 0.95
		item.image:setScale(scaleY * magnification, scaleY * magnification)
	end
end

-------------------------
--        INIT         --
-------------------------

return Item