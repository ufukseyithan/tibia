local Equipment = class(tibia.Container)

function Equipment:constructor(data)
    local slots = {}
    for _, slotName in pairs(tibia.config.slots) do
        slots[slotName] = tibia.ItemSlot.new(data and data[slotName])

		if data then
			data[slotName] = slots[slotName].data
		end
    end

    self:super(slots)
end

function Equipment:getMenu()
    local menu = sea.Menu.new("Equipment")

	local equipmentSlots = self.slots
	for _, slotName in ipairs(table.reverse(tibia.config.slots)) do
		local slot = equipmentSlots[slotName]

		if slot:isOccupied() then
			local item = slot.item
			local config = item.config

			menu:addButton(config.name, function(player)
				return item:getActionMenu(true)
			end, slotName)
		else
			menu:addButton("Empty", nil, slotName)
		end
	end

	return menu
end

-------------------------
--        INIT         --
-------------------------

return Equipment