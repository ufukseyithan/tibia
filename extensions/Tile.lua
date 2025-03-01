function sea.Tile:isWaterTile()
    return table.contains(tibia.config.waterTiles, self.frame)
end

-------------------------
--     PROPERTIES      --
-------------------------

function sea.Tile:zoneProperty()
    return function(self)
        return tibia.tileZone[self.y] and tibia.tileZone[self.y][self.x]
    end
end

function sea.Tile:houseEntranceProperty()
    return function(self)
        return self.zone.HOUSEENT
    end
end

function sea.Tile:houseProperty()
    return function(self)
        return self.zone.HOUSE
    end
end