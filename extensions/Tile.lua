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