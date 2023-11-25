local Equipment = class(tibia.Container)

function Equipment:constructor()
    local slots = {}
    for _, slotName in pairs(tibia.config.slots) do
        slots[slotName] = true
    end

    self:super(slots)
end

-------------------------
--        INIT         --
-------------------------

return Equipment