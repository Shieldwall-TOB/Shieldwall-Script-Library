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
--v function(faction_detail: FACTION_DETAIL, province_key: string) --> PROVINCE_DETAIL
function province_detail.new(faction_detail, province_key)
    local self = {}
    setmetatable(self, {
        __index = province_detail
    }) --# assume self: PROVINCE_DETAIL

    --v method() --> PROVINCE_DETAIL
    function self:prototype()
        return province_detail
    end

    self._name = province_key
    self._factionDetail = faction_detail
    self._factionName = faction_detail:name()
    self._regions = {} --:map<string, REGION_DETAIL>
    self._numRegions = 0 --:number
    self._activeEffects = {} --:map<string, boolean>
    self._effectsClear = true --:boolean
    self._lastCapital = nil --:string
    self._populationManager = nil --:POP_MANAGER
    register_to_prototype(self._factionName, province_key, self)
    return self
end

---------------------------
------NIL SAFE QUERIES-----
---------------------------

--v function(self: PROVINCE_DETAIL) --> string
function province_detail.name(self)
    return self._name
end

----------------------------
-----SUBCLASS LIBARIES------
----------------------------

pop_manager = require("ilex_verticillata/province_features/PopManager")

------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: PROVINCE_DETAIL) --> table
function province_detail.save(self)
    local sv_tab = dev.save(self,  "_activeEffects", "_effectsClear", "_lastCapital")
    return sv_tab
end

--v function(faction_detail: FACTION_DETAIL, key: string, sv_tab: table) --> PROVINCE_DETAIL
function province_detail.load(faction_detail, key, sv_tab)
    local self = province_detail.new(faction_detail, key)
    dev.load(sv_tab, self, "_activeEffects", "_effectsClear", "_lastCapital")
    return self
end


-------------------------------
-------REGION SUBOBJECTS-------
-------------------------------

--v function(self: PROVINCE_DETAIL) --> number
function province_detail.num_regions(self)
    return self._numRegions
end

--v function(self: PROVINCE_DETAIL, region_key: string) --> REGION_DETAIL
function province_detail.get_region_detail(self, region_key)
    if self._regions[region_key] == nil then
        self:log("WARNING: Asked province ["..self._name.."] for the region ["..region_key.."] but this province does not have ownership of this region!")
    end
    return self._regions[region_key]
end

--v function(self: PROVINCE_DETAIL) --> map<string, REGION_DETAIL>
function province_detail.regions(self) 
    return self._regions 
end

--v function(self: PROVINCE_DETAIL) --> boolean
function province_detail.is_empty(self)
    return (self._numRegions == 0)
end

--v function(self: PROVINCE_DETAIL, region_key: string)
function province_detail.add_region(self, region_key)
    local region = self._factionDetail._model:get_region(region_key)
    self._regions[region_key] = region
    region:add_province(self)
    self._numRegions = self._numRegions + 1
end

--v function(self: PROVINCE_DETAIL, region_key: string, new_province: PROVINCE_DETAIL?)
function province_detail.remove_region(self, region_key, new_province)
    if self._numRegions == 0 then
        self:log("WARNING: Asked province ["..self._name.."] to remove a region, but this province has no regions!")
        return
    end
    if self._regions[region_key] == nil then
        self:log("WARNING: Asked province ["..self._name.."] to remove a region with key ["..region_key.."] , but this region doesn't exist in this province! Listing regions")
        for key, _ in pairs(self._regions) do
            self:log("\tHas Region: ["..key.."]")
        end
        return
    end
    self._regions[region_key] = nil
    self._numRegions = self._numRegions - 1 
    if new_province then
        --# assume new_province: PROVINCE_DETAIL
        new_province:add_region(region_key)
    end
end


return {
    --Existence
    has_province_for_faction = province_detail.has_province_for_faction,
    --Creation
    new = province_detail.new,
    load = province_detail.load
    --Content API
}