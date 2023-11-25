local Container = class()

function Container:constructor()
    self.slots = {}
end

function Container:itemCount(id)
	local amount, items = 0, {}

	for _, item in ipairs(self.slots) do
		if item.id == id then
			amount = amount + item:count()
			table.insert(items, item)
		end
	end

	return amount, items
end

function Container:removeItem(id, amount, tell)
	if not tibia.config.items[id] or id == 0 then 
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