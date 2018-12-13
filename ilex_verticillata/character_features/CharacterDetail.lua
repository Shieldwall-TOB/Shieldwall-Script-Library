-- character detail object
local character_detail = {} --# assume character_detail: CHARACTER_DETAIL
--v method(text: any)
function character_detail:log(text)
    dev.log(tostring(text), "CHA")
end

-------------------------
----INSTANCE REGISTER----
-------------------------
character_detail._instances = {} --:map<CA_CQI, CHARACTER_DETAIL>
--v function(cqi: CA_CQI) --> boolean
function character_detail.has_character(cqi) 
    return not not character_detail._instances[cqi]
end

--v function(cqi: CA_CQI, object: CHARACTER_DETAIL)
local function register_to_prototype(cqi, object)
    character_detail._instances[cqi] = object
end
-------------------------
-----STATIC CONTENT------
-------------------------
character_detail._startPosEstates = {} --:map<string, {_region: string, _ownerName: string, _estateType: string}>
--v function(self: CHARACTER_DETAIL, estate_region: string, estate_owner_name: string, estate_type_key: string)
function character_detail.register_startpos_estate(self, estate_region, estate_owner_name, estate_type_key)
    local holder = {}
    holder._region = estate_region
    holder._ownerName = estate_owner_name
    holder._estateType = estate_type_key
    self._startPosEstates[estate_region] = holder
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(cqi: CA_CQI) --> CHARACTER_DETAIL
function character_detail.new(cqi)
    local self = {}
    setmetatable(self, {
        __index = character_detail
    }) --# assume self: CHARACTER_DETAIL

    --access to prototype
    --v method() --> CHARACTER_DETAIL
    function self:prototype()
        return character_detail
    end

    self._cqi = cqi


    self._title = "no_title"
    self._homeEstate = "no_estate"
    self._estates = {} --:map<string, REGION_DETAIL>


    self._forceEffectsManager = nil --:UNIT_EFFECTS_MANAGER


    register_to_prototype(self._cqi, self)
    return self
end

---------------------------
------NIL SAFE QUERIES-----
---------------------------
--v function(self: CHARACTER_DETAIL) --> CA_CQI
function character_detail.cqi(self)
    return self._cqi
end

----------------------------
-----SUBCLASS LIBARIES------
----------------------------

local unit_effects_manager = require("ilex_verticillata/character_features/UnitEffectsManager")

return {
    --Creation
    new = character_detail.new,
    --Content API
    register_startpos_estate = character_detail.register_startpos_estate
}