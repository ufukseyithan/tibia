local Inventory = class(tibia.Container)

function Inventory:constructor(data)
	local slots = {}
	for i = 1, self.capacity do
		slots[i] = tibia.ItemSlot.new(data and data[i])

		if data then
			data[i] = slots[i].data
		end
	end

    self:super(slots)
end

function Inventory:getMenu()
    local menu = sea.Menu.new("Inventory")

	for _, slot in pairs(self.slots) do
		if slot:isOccupied() then
			local item = slot.item
			local config = item.config
	
			menu:addButton(config.name, function(player)
				return item:getActionMenu()
			end, config.stackable and item.amount or "")
		else
			menu:addButton("Empty")
		end
	end

    return menu
end

-------------------------
--        CONST        --
-------------------------

Inventory.capacity = tibia.config.inventoryCapacity

-------------------------
--        INIT         --
-------------------------

return Inventory