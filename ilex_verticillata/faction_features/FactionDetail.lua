-- this is the general purpose faction object in shieldwall, responsible for containing faction scope and lower scripts. 
local faction_detail = {} --# assume faction_detail: FACTION_DETAIL
--v method(text: any)
function faction_detail:log(text)
    dev.log(tostring(text), "FCT")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
faction_detail._instances = {} --:map<string, FACTION_DETAIL>
--v function(key: string) --> boolean
function faction_detail.has_faction(key) 
    return not not faction_detail._instances[key]
end
--v function() --> map<string, FACTION_DETAIL>
function faction_detail.get_instances()
    return faction_detail._instances
end
    
--v function(key: string, object: FACTION_DETAIL)
local function register_to_prototype(key, object)
    faction_detail._instances[key] = object
end


-------------------------
-----STATIC CONTENT------
-------------------------

faction_detail._majorFactions = {} --:map<string, boolean>
--v function(key: string)
function faction_detail.make_faction_major(key)
    faction_detail:log("Made ["..key.."] a major faction.")
    faction_detail._majorFactions[key] = true
    if faction_detail._instances[key] then
        faction_detail._instances[key]._isMajor = true
    end
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
    self._characters = {} --:map<string, CHARACTER_DETAIL>
    self._provinces = {} --:map<string, PROVINCE_DETAIL>
    self._factionFoodManager = nil --:FOOD_MANAGER
    self._personalityManager = nil --:PERSONALITY_MANAGER 

    self._kingdomLevel = 0 
    self._isMajor = not not faction_detail._majorFactions[key]
    self._isVassal = false --:boolean
    self._liege = nil --:FACTION_DETAIL
    self._vassals = {} --:map<string, FACTION_DETAIL>
    self._numVassals = 0

    self._effectBundles = {} --:map<string, boolean>
    self._bundlesClear = true --:boolean
    register_to_prototype(self._name, self)
    return self
end

--------------------------
------GENERIC METHODS-----
--------------------------

--v function(self: FACTION_DETAIL) --> string
function faction_detail.name(self)
    return self._name
end

--v function(self: FACTION_DETAIL) --> map<string, PROVINCE_DETAIL>
function faction_detail.provinces(self)
    return self._provinces
end

--v function(self: FACTION_DETAIL) --> map<string, CHARACTER_DETAIL>
function faction_detail.characters(self)
    return self._characters
end

--v function(self: FACTION_DETAIL) --> PKM
function faction_detail.model(self)
    return self._model
end

--v function(self: FACTION_DETAIL) --> boolean
function faction_detail.is_major(self)
    return self._isMajor
end


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
food_manager = require("ilex_verticillata/faction_features/FoodStorageManager")
_G.fm = food_manager

--v function(self: FACTION_DETAIL) --> FOOD_MANAGER
function faction_detail.get_food_manager(self)
    if self._factionFoodManager == nil then
        self._factionFoodManager = food_manager.new(self)
    end
    return self._factionFoodManager
end

--v function(self: FACTION_DETAIL, sv_tab: table) 
function faction_detail.load_food_manager(self, sv_tab)
    self._factionFoodManager = food_manager.load(self, sv_tab)
end

--v function(self: FACTION_DETAIL) --> boolean
function faction_detail.has_food_manager(self)
    return not not self._factionFoodManager
end
--------------------------------
----PROVINCE DETAIL OBJECTS-----
--------------------------------
province_detail = require("ilex_verticillata/province_features/ProvinceDetail")
--v function(self: FACTION_DETAIL, province_key: string, save_data: table) --> PROVINCE_DETAIL
function faction_detail.load_province(self, province_key, save_data)
    self._provinces[province_key] = province_detail.load(self, province_key, save_data)
    return self._provinces[province_key]
end

--v function(self: FACTION_DETAIL, province_key: string) --> PROVINCE_DETAIL
function faction_detail.get_province(self, province_key)
    if self._provinces[province_key] == nil then
        self._provinces[province_key] = province_detail.new(self, province_key)
    end
    return self._provinces[province_key]
end

-----------------------------------
-----CHARACTER DETAIL OBJECTS------
-----------------------------------
character_detail = require("ilex_verticillata/character_features/CharacterDetail")
_G.cd = character_detail

--v function(faction_detail: FACTION_DETAIL, cqi: CA_CQI) --> CHARACTER_DETAIL
local function raw_get_faction_detail_character_by_cqi(faction_detail, cqi)
    return faction_detail._characters[tostring(cqi)]
end


--v function(self: FACTION_DETAIL, cqi: string, save_data: table) --> CHARACTER_DETAIL
function faction_detail.load_character(self, cqi, save_data)
    self._characters[cqi] = character_detail.load(self, cqi, save_data)
    return self._characters[cqi]
end

--v function(self: FACTION_DETAIL, cqi: CA_CQI) --> CHARACTER_DETAIL
function faction_detail.get_character(self, cqi)
    local cqi = tostring(cqi)
    if self._characters[cqi] == nil then
        self._characters[cqi] = character_detail.new(self, cqi)
    end
    return self._characters[cqi]
end

---------------------------
----VASSAL CONNECTIONS-----
---------------------------

--v function(self: FACTION_DETAIL, master: string)
function faction_detail.subjugate(self, master)
    local master_det = self._model._factions[master]
    self._isVassal = true
    self._liege = master_det
end

--v function(self: FACTION_DETAIL)
function faction_detail.liberate(self)
    self:log("["..self:name().."] is liberated from being a vassal to ["..self._liege:name().."]")
    self._isVassal = false
    self._liege._vassals[self:name()] = nil
    self._liege._numVassals = self._liege._numVassals - 1
    self._liege = nil
end

--v function(self: FACTION_DETAIL, vassal: string)
function faction_detail.remove_vassal(self, vassal)
    local vassal_det = self._model._factions[vassal]
    vassal_det._isVassal = false
    vassal_det._liege = nil
    self._numVassals = self._numVassals - 1 
    self._vassals[vassal] = nil
    self:log("["..self:name().."] no longer controls ["..vassal.."] as a vassal")
end


--v function(self: FACTION_DETAIL) --> boolean
function faction_detail.is_faction_vassal(self)
    return self._isVassal
end

--v function(self: FACTION_DETAIL) --> FACTION_DETAIL
function faction_detail.liege(self)
    return self._liege
end




return {
    --existence query
    has_faction = faction_detail.has_faction,
    get_instances = faction_detail.get_instances,
    --creation
    new = faction_detail.new,
    load = faction_detail.load,
    --content API
    make_faction_major = faction_detail.make_faction_major
}