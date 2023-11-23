local ItemSlot = class()

function ItemSlot:constructor(item, type)
    self.item = item
    self.type = type
end

-------------------------
--        INIT         --
-------------------------

return ItemSlot