function sea.Tile:zoneProperty()
    return function(self)
        return tibia.tileZone[self.y] and tibia.tileZone[self.y][self.x]
    end
end