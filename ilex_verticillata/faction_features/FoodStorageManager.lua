-- each faction object has a food storage manager object attached which handles their food exports, inports and storage

local food_manager = {} --# assume food_manager: FOOD_MANAGER


--content API--
food_manager._buildingFoodStorageCap = {} --:map<string, number>
--v function(building: string, cap_effect: number)
function food_manager.add_food_storage_cap_effect_to_building(building, cap_effect)
    food_manager._buildingFoodStorageCap[building] = cap_effect
end

--v function(faction: FACTION) --> FOOD_MANAGER
function food_manager.new(faction)
    local self = {}
    setmetatable(self, {
        __index = food_manager,
        __tostring = function() return "FACTION_FOOD_MANAGER" end
    })--# assume self: FOOD_MANAGER

    self._faction = faction
    self._storageCapRegionContributions = {} --:map<string, number>
    self._storageCap = CONST.food_storage_cap_base
    self._storedFood = 0
    self._foodTradeAllowed = false --:boolean

    return self
end

--v function(faction: FACTION, savetable: table) --> FOOD_MANAGER
function food_manager.load(faction, savetable)
    local self = {}
    setmetatable(self, {
        __index = food_manager,
        __tostring = function() return "FACTION_FOOD_MANAGER" end
    })--# assume self: FOOD_MANAGER

    dev.load(savetable, self, "_storageCapRegionContributions", "_storageCap", "_storedFood", "_foodTradeAllowed")
    return self
end

--v function(self: FOOD_MANAGER) --> table
function food_manager.save(self)
    return dev.save(self, "_storageCapRegionContributions", "_storageCap", "_storedFood", "_foodTradeAllowed")
end



return {
    add_food_storage_cap_effect_to_building =  food_manager.add_food_storage_cap_effect_to_building,
    new = food_manager.new
}