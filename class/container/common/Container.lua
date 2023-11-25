local Container = class()

function Container:constructor()
    self.slots = {}
end

function Container:clear(slot)
	if slot then
		slot:remove()
	else
		for _, slot in pairs(self.slots) do
			slot:destroy()
		end
	end

	return true
end

function Container:itemCount(id)
	local amount, items = 0, {}

	for _, item in pairs(self.slots) do
		if item.id == id then
			amount = amount + item:count()
			table.insert(items, item)
		end
	end

	return amount, items
end

function Container:removeItem(id, amount, tell)
	if not tibia.config.item[id] or id == 0 then 
		return false 
	end

	amount = amount and math.floor(amount) or 1

	local removed = 0
	local has, toRemove = self:itemCount(id)
	if has >= amount then
		for _, item in ipairs(toRemove) do
			if removed < amount then
				removed = removed + item:consume(amount)
			end

			if removed == amount then
				return true
			end
		end
	end

	return false
end

function Container:addItem(item)
	for _, slot in pairs(self.slots) do
		item:occupy(slot)
	end

	return item.amount > 0 and item or true
end

-------------------------
--        INIT         --
-------------------------

return Container