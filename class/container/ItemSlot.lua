local ItemSlot = class()

function ItemSlot:constructor(item, type)
    self.item = item
    self.type = type
end

function ItemSlot:isOccupied()
    return self.item and true or false
end

-------------------------
--        INIT         --
-------------------------

return ItemSlot