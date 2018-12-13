-- this is the general purpose faction object in shieldwall, responsible for containing faction scope and lower scripts. 



local food_manager = require("ilex_verticillata/faction_features/FoodStorageManager")
local faction_detail = {} --# assume faction_detail: FACTION_DETAIL

-------------------------
-----STATIC CONTENT------
-------------------------

faction_detail._majorFactions = {} --:map<string, boolean>
--v function(key: string)
function faction_detail.make_faction_major(key)
    faction_detail._majorFactions[key] = true
end

--v function(model: PKM, key: string) --> FACTION_DETAIL
function faction_detail.new(model, key)
    local self = {} 
    setmetatable(self, {
        __index = faction_detail
    }) --# assume self: FACTION_DETAIL

    self._model = model
    self._name = key
    self._characters = {} --:map<CA_CQI, CHARACTER_DETAIL>
    self._provinces = {} --:map<string, PROVINCE_DETAIL>
    self._factionFoodManager = nil --:FOOD_MANAGER
    self._personalityManager = nil --:PERSONALITY_MANAGER 

    self._kingdomLevel = 0 
    self._isMajor = false --:boolean
    self._isVassal = false --:boolean

    self._effectBundles = {} --:map<string, boolean>
    self._bundlesClear = true --:boolean

    return self
end

--v method(text: any)
function faction_detail:log(text)
    dev.log(tostring(text), "FCT")
end


-----------------------------
----FACTION FOOD MANAGER-----
-----------------------------

--v function(self: FACTION_DETAIL) --> FOOD_MANAGER
function faction_detail.get_food_manager(self)
    if self._factionFoodManager == nil then
        self._factionFoodManager = food_manager.new(self)
    end
    return self._factionFoodManager
end

