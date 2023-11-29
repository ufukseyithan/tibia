local Container = class()

function Container:constructor(slots)
    self.slots = slots
end

function Container:clear(slot)
	if slot then
		slot.item:destroy()
	else
		for _, slot in pairs(self.slots) do
			slot.item:destroy()
		end
	end

	return true
end

function Container:itemCount(id)
	local amount, items = 0, {}

	for _, slot in pairs(self.slots) do
		if slot:isOccupied() and slot.item.id == id then
			amount = amount + slot.item:count()
			table.insert(items, slot.item)
		end
	end

	return amount, items
end

function Container:removeItem(id, amount)
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
		if item:occupy(slot) == true then
			break
		end
	end

	return item.amount > 0 and item or true
end

-------------------------
--        INIT         --
-------------------------

return Container