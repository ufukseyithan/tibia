local Inventory = class(tibia.Container)

function Inventory:constructor()
    local slots = {}
    for i = 1, #self.capacity do
        slots[i] = true
    end

    self:super(slots)
end

-------------------------
--        CONST        --
-------------------------

Inventory.capacity = tibia.config.inventoryCapacity

-------------------------
--        INIT         --
-------------------------

return Inventory