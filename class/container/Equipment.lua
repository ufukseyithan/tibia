local Equipment = class(tibia.Container)

function Equipment:constructor()
    local slots = {}
    for k, v in pairs(tibia.config.slots) do
        slots[k] = true
    end

    self:super(slots)
end

-------------------------
--        INIT         --
-------------------------

return Equipment