local Container = class()

function Container:constructor()
    self.slots = {}
end

function Container:itemCount(itemID)
	local amount, items = 0, {}

	for _, item in ipairs(self.slots) do
		if item.id == itemID then
			amount = amount + item:count()
			table.insert(items, item)
		end
	end

	return amount, items
end

function Container:removeItem(itemID, amount, tell)
	if not tibia.config.items[itemID] or itemID == 0 then 
		return false 
	end

	amount = amount and math.floor(amount) or 1

	local removed = 0
	local has, toRemove = self:itemCount(itemID)
	if has >= amount then
		for slot, item in ipairs(toRemove) do
			if removed < amount then
				table.remove(self.inventory, slot)
				removed = removed + 1
			end

			if removed == amount then
				if tell then
					self:message("You have lost "..item.fullName..".")
				end
				return true
			end
		end
	end

	return false
end

-------------------------
--        INIT         --
-------------------------

return Container