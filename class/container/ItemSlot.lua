local ItemSlot = class()

function ItemSlot:constructor(data, type)
    self.data = data or {
        id = 0,
        attributes = {}
    }

    if data and data.id ~= 0 then
        self.item = tibia.Item.create(data.id, data.attributes)
        self.item.slot = self
    end

    self.type = type
end

function ItemSlot:isOccupied()
    return self.item ~= nil
end

function ItemSlot:reset()
    self.data.id = 0
    self.data.attributes = {}
    self.item = nil
end

-------------------------
--        INIT         --
-------------------------

return ItemSlot