local Inventory = class(tibia.Container)

function Inventory:constructor()
    local slots = {}
    for i = 1, self.capacity do
        slots[i] = true
    end

    self:super(slots)
end

function Inventory:getMenu()
    local menu = sea.Menu.new("Inventory")

	for k, slot in pairs(self.slots) do
		local name

		if slot:isOccupied() then
			local item = slot.item
			local config = item.config
	
			menu:addButton(config.name, function(player)
				return item:getActionMenu()
			end, k)
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