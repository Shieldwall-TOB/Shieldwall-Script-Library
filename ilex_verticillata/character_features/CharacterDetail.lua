-- character detail object
local character_detail = {} --# assume character_detail: CHARACTER_DETAIL
--v method(text: any)
function character_detail:log(text)
    dev.log(tostring(text), "CHA")
end

-------------------------
----INSTANCE REGISTER----
-------------------------
character_detail._instances = {} --:map<string, CHARACTER_DETAIL>
--v function(cqi: string) --> boolean
function character_detail.has_character(cqi) 
    return not not character_detail._instances[cqi]
end

--v function(cqi: string, object: CHARACTER_DETAIL)
local function register_to_prototype(cqi, object)
    character_detail._instances[cqi] = object
end
-------------------------
-----STATIC CONTENT------
-------------------------
character_detail._startPosEstates = {} --:map<string, map<string, START_POS_ESTATE>>
--v function(self: CHARACTER_DETAIL, estate_region: string, estate_owner_name: string, estate_building: string, faction_key: string )
function character_detail.register_startpos_estate(self, estate_region, estate_owner_name, estate_building, faction_key)
    if character_detail._startPosEstates[faction_key] == nil then
        character_detail._startPosEstates[faction_key] = {}
    end
    local holder = {}
    holder._region = estate_region
    holder._ownerName = estate_owner_name
    holder._estateBuilding = estate_building
    holder._faction = faction_key
    character_detail._startPosEstates[faction_key][estate_region..estate_building] = holder
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(faction_detail: FACTION_DETAIL, cqi: string) --> CHARACTER_DETAIL
function character_detail.new(faction_detail, cqi)
    local self = {}
    setmetatable(self, {
        __index = character_detail
    }) --# assume self: CHARACTER_DETAIL

    --access to prototype
    --v method() --> CHARACTER_DETAIL
    function self:prototype()
        return character_detail
    end

    self._cqi = tostring(cqi) --:string
    self._factionDetail = faction_detail


    self._title = "no_title"
    self._homeEstate = {"", "", false} --:{string, string, boolean}
    self._estates = {} --:map<string, map<string, ESTATE_DETAIL>>
    self._numEstates = 0

    self._forceEffectsManager = nil --:UNIT_EFFECTS_MANAGER


    register_to_prototype(self._cqi, self)
    return self
end

--------------------------
------GENERIC METHODS-----
--------------------------
--v function(self: CHARACTER_DETAIL) --> CA_CQI
function character_detail.cqi(self)
    local cqi = tonumber(self._cqi) --# assume cqi: CA_CQI
    return cqi
end

--v function(self: CHARACTER_DETAIL) --> FACTION_DETAIL
function character_detail.faction_detail(self)
    return self._factionDetail
end

--------------------------------
-----UNIT EFFECT SUBOBJECTS-----
--------------------------------

unit_effects_manager = require("ilex_verticillata/character_features/UnitEffectsManager")
_G.uem = unit_effects_manager
--v function(self: CHARACTER_DETAIL) --> boolean
function character_detail.has_unit_effects_manager(self)
    return not not self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL) --> UNIT_EFFECTS_MANAGER
function character_detail.get_unit_effects_manager(self)
    if self._forceEffectsManager == nil then 
        return nil
    end
    return self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL, force_cqi: string, savetable: table) --> UNIT_EFFECTS_MANAGER
function character_detail.load_unit_effects_manager(self, force_cqi, savetable)
    self._forceEffectsManager = unit_effects_manager.load(self, force_cqi, savetable)
    return self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL) --> UNIT_EFFECTS_MANAGER
function character_detail.create_unit_effects_manager(self)
    local character_obj = dev.get_character(self:cqi())
    if not character_obj:has_military_force() then
        return nil
    end
    local force_cqi = character_obj:military_force():command_queue_index()
    self._forceEffectsManager = unit_effects_manager.new(self, tostring(force_cqi))
    return  self._forceEffectsManager
end

-------------------------------
-------ESTATE SUBOBJECTS-------
-------------------------------

--v function(self: CHARACTER_DETAIL) --> number
function character_detail.num_estates(self)
    return self._numEstates
end

--v function(self: CHARACTER_DETAIL, region_key: string) --> map<string, ESTATE_DETAIL>
function character_detail.get_estate_details(self, region_key)
    if self._estates[region_key] == nil then
        self:log("WARNING: Asked character ["..tostring(self._cqi).."] for the region ["..region_key.."] but this character does not have ownership of this region!")
    end
    return self._estates[region_key]
end

--v function(self: CHARACTER_DETAIL) --> map<string, map<string, ESTATE_DETAIL>>
function character_detail.estates(self) 
    return self._estates 
end

--v function(self: CHARACTER_DETAIL) --> boolean
function character_detail.landless(self)
    return (self._numEstates == 0)
end

--v function(self: CHARACTER_DETAIL, region_key: string, building_key: string)
function character_detail.add_estate(self, region_key, building_key)
    if self._estates[region_key] == nil then
        self._estates[region_key] = {}
    end
    self._estates[region_key][building_key] = self._factionDetail._model:get_region(region_key):get_estate_detail(building_key)
end

--v function(self: CHARACTER_DETAIL, detail: ESTATE_DETAIL)
function character_detail.add_estate_with_detail(self, detail)
    if self._estates[detail._regionName] == nil then
        self._estates[detail._regionName] = {}
    end
    self._estates[detail._regionName][detail._building] = detail
end


--v function(self: CHARACTER_DETAIL, region_key: string, building_key: string, new_owner: CHARACTER_DETAIL?)
function character_detail.remove_estate(self, region_key, building_key, new_owner)
    if self._estates[region_key] == nil or self._estates[region_key][building_key] == nil then
        self:log("WARNING: Asked character ["..self._cqi.."] to remove an estate at ["..region_key.."] and ["..building_key.."] but this character doesn't own an estate there!")
        return
    end
    local removed_estate = self._estates[region_key][building_key]
    self._estates[region_key][building_key] = nil
    if new_owner then
        --# assume new_owner: CHARACTER_DETAIL
        new_owner:add_estate_with_detail(removed_estate)
    end
end

--v function(self: CHARACTER_DETAIL)
function character_detail.check_start_pos_estates(self)
    local char = dev.get_character(self:cqi())
    local name_key = char:get_forename()
    local faction_pairs = character_detail._startPosEstates[char:faction():name()]
    for composite_key, start_pos_estate in pairs(faction_pairs) do
        local reg_det = self:faction_detail():model():get_region(start_pos_estate._region)
        if reg_det and reg_det:has_estate_with_building(start_pos_estate._estateBuilding) then
            self:add_estate_with_detail(reg_det:get_estate_detail(start_pos_estate._estateBuilding))
        end
    end
end

------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: CHARACTER_DETAIL) --> table
function character_detail.save(self)
    local sv_tab = dev.save(self, "_homeEstate", "_title")
    -- Now, assembly an arbitrary field to store which regions we want this province to load. 
    --# assume sv_tab: map<string, map<string, map<string, string>>> 
    --^ this isn't actually true but its a local assumption for this code to pass.
    sv_tab._savedRegions = {}
    for region_key, building_estate_pair in pairs(self._estates) do
        sv_tab._savedRegions[region_key] = {}
        for building_key, estate_detail in pairs(building_estate_pair) do
            sv_tab._savedRegions[region_key][building_key] = estate_detail:estate_type()
        end
    end
    --# assume sv_tab: table
    --^ reset our assumption
    return sv_tab
end

--v function(faction_detail: FACTION_DETAIL, cqi: string, sv_tab: table) --> CHARACTER_DETAIL
function character_detail.load(faction_detail, cqi, sv_tab)
    local self = character_detail.new(faction_detail, tostring(cqi))
    --we assemble an arbitrary field in this object when we are saving it, so we should remove that from the save data first.
    --# assume sv_tab: map<string, map<string, map<string, string>>> 
    --^ this isn't actually true but its a local assumption for this code to pass.
    if sv_tab._savedRegions then
        for region_key, building_estate_type_pair in pairs(sv_tab._savedRegions) do
            for building_key, estate_type in pairs(building_estate_type_pair) do 
                self:add_estate(region_key, building_key)
            end
        end
    end
    sv_tab._savedRegions = nil -- remove the field
    --# assume sv_tab: table
    --^ reset our assumption then load as normal
    dev.load(sv_tab, self, "_homeEstate", "_title")
    return self
end
    






return {
    --Creation
    new = character_detail.new,
    load = character_detail.load,
    --Content API
    register_startpos_estate = character_detail.register_startpos_estate
}