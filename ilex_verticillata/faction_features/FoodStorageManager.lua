-- each faction object has a food storage manager object attached which handles their food exports, inports and storage
local food_manager = {} --# assume food_manager: FOOD_MANAGER


-------------------------
-----STATIC CONTENT------
-------------------------

food_manager._buildingFoodStorageCap = {} --:map<string, number>
--v function(building: string, cap_effect: number)
function food_manager.add_food_storage_cap_effect_to_building(building, cap_effect)
    food_manager._buildingFoodStorageCap[building] = cap_effect
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(faction: FACTION_DETAIL) --> FOOD_MANAGER
function food_manager.new(faction)
    local self = {}
    setmetatable(self, {
        __index = food_manager,
        __tostring = function() return "FACTION_FOOD_MANAGER" end
    })--# assume self: FOOD_MANAGER

    --v method() --> FOOD_MANAGER
    function self:prototype()
        return food_manager
    end

    self._faction = faction
    self._storageCapRegionContributions = {} --:map<string, number>
    self._storageCap = CONST.food_storage_cap_base
    self._storedFood = 0
    self._foodTradeAllowed = false --:boolean

    return self
end


------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(faction: FACTION_DETAIL, savetable: table) --> FOOD_MANAGER
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
    --creation
    new = food_manager.new,
    load = food_manager.load,
    --content API
    add_food_storage_cap_effect_to_building =  food_manager.add_food_storage_cap_effect_to_building
}