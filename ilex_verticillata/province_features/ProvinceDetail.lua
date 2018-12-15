--this stores information for a faction's province, including population numbers and effects.
--these are stored by faction and do not link to characters.
local province_detail = {} --# assume province_detail: PROVINCE_DETAIL
--v method(text: any)
function province_detail:log(text)
    dev.log(tostring(text), "PRV")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
province_detail._instances = {} --:map<string, map<string, PROVINCE_DETAIL>>
--v function(faction_key: string, province_key: string) --> boolean
function province_detail.has_province_for_faction(faction_key, province_key) 
    if province_detail._instances[faction_key] == nil then
        province_detail._instances[faction_key] = {}
    end
    return not not province_detail._instances[faction_key][province_key]
end

--v function(faction_key: string, province_key: string, object: PROVINCE_DETAIL)
local function register_to_prototype(faction_key, province_key, object)
    if province_detail._instances[faction_key] == nil then
        province_detail._instances[faction_key] = {}
    end
    province_detail._instances[faction_key][province_key] = object
end


-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------
--v function(faction_detail: FACTION_DETAIL, key: string) --> PROVINCE_DETAIL
function province_detail.new(faction_detail, key)
    local self = {}
    setmetatable(self, {
        __index = province_detail
    }) --# assume self: PROVINCE_DETAIL

    --v method() --> PROVINCE_DETAIL
    function self:prototype()
        return province_detail
    end

    self._key = key
    self._factionDetail = faction_detail
    self._factionName = faction_detail:name()
    self._regions = {} --:map<string, REGION_DETAIL>
    self._activeEffects = {} --:map<string, boolean>
    self._effectsClear = true --:boolean
    self._lastCapital = nil --:string
    self._populationManager = nil --:POP_MANAGER
    register_to_prototype(self._factionName, self._key, self)
    return self
end

---------------------------
------NIL SAFE QUERIES-----
---------------------------

--v function(self: PROVINCE_DETAIL) --> string
function province_detail.name(self)
    return self._key
end

----------------------------
-----SUBCLASS LIBARIES------
----------------------------
region_detail = require("ilex_verticillata/province_features/RegionDetail")
pop_manager = require("ilex_verticillata/province_features/PopManager")

------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: FACTION_DETAIL) --> table
function province_detail.save(self)
    local sv_tab = dev.save(self, "_activeEffects", "_effectsClear", "_lastCapital", "_isVassal", "_master")
    return sv_tab
end

--v function(faction_detail: FACTION_DETAIL, key: string, sv_tab: table) --> PROVINCE_DETAIL
function province_detail.load(faction_detail, key, sv_tab)
    local self = province_detail.new(faction_detail, key)
    dev.load(sv_tab, self, "_effectBundles", "_bundlesClear", "_kingdomLevel", "_isVassal", "_master")
    return self
end






return {
    --Existence
    has_province_for_faction = province_detail.has_province_for_faction,
    --Creation
    new = province_detail.new,
    load = province_detail.load
    --Content API
}