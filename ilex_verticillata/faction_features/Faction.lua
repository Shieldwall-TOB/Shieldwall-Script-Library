local food_manager = require("ilex_verticillata/faction_features/FoodStorageManager")
local Faction = {} --# assume Faction: FACTION

--v function(key: string) --> FACTION
function Faction.new(key)
    local self = {} 
    setmetatable(self, {
        __index = Faction
    }) --# assume self: FACTION



    return self


end