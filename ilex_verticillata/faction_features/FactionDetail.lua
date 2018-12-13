-- this is the general purpose faction object in shieldwall, responsible for containing faction scope and lower scripts. 
local faction_detail = {} --# assume faction_detail: FACTION_DETAIL
--v method(text: any)
function faction_detail:log(text)
    dev.log(tostring(text), "FCT")
end



-------------------------
-----STATIC CONTENT------
-------------------------

faction_detail._majorFactions = {} --:map<string, boolean>
--v function(key: string)
function faction_detail.make_faction_major(key)
    faction_detail._majorFactions[key] = true
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(model: PKM, key: string) --> FACTION_DETAIL
function faction_detail.new(model, key)
    local self = {} 
    setmetatable(self, {
        __index = faction_detail
    }) --# assume self: FACTION_DETAIL

    self._model = model

    --v method() --> FACTION_DETAIL
    function self:prototype()
        return faction_detail
    end
    self._name = key
    self._characters = {} --:map<CA_CQI, CHARACTER_DETAIL>
    self._provinces = {} --:map<string, PROVINCE_DETAIL>
    self._factionFoodManager = nil --:FOOD_MANAGER
    self._personalityManager = nil --:PERSONALITY_MANAGER 

    self._kingdomLevel = 0 
    self._isMajor = not not faction_detail._majorFactions[key]
    self._isVassal = false --:boolean
    self._master = nil --:string

    self._effectBundles = {} --:map<string, boolean>
    self._bundlesClear = true --:boolean

    return self
end

---------------------------
------NIL SAFE QUERIES-----
---------------------------

----------------------------
-----SUBCLASS LIBARIES------
----------------------------

local food_manager = require("ilex_verticillata/faction_features/FoodStorageManager")
local province_detail = require("ilex_verticillata/province_features/ProvinceDetail")
local character_detail = require("ilex_verticillata/character_features/CharacterDetail")



------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: FACTION_DETAIL) --> table
function faction_detail.save(self)
    local sv_tab = dev.save(self, "_effectBundles", "_bundlesClear", "_kingdomLevel", "_isVassal", "_master")
    return sv_tab
end

--v function(model: PKM, key: string, sv_tab: table) --> FACTION_DETAIL
function faction_detail.load(model, key, sv_tab)
    local self = faction_detail.new(model, key)
    dev.load(sv_tab, self, "_effectBundles", "_bundlesClear", "_kingdomLevel", "_isVassal", "_master")
    return self
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




return {
    --creation
    new = faction_detail.new,
    load = faction_detail.load,
    --content API
    make_faction_major = faction_detail.make_faction_major
}