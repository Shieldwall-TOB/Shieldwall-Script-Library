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
--v function(estate_region: string, estate_owner_name: string, estate_building: string, estate_chain: string, faction_key: string )
function character_detail.register_startpos_estate(estate_region, estate_owner_name, estate_building, estate_chain, faction_key)
    if character_detail._startPosEstates[faction_key] == nil then
        character_detail._startPosEstates[faction_key] = {}
    end
    local holder = {}
    holder._region = estate_region
    holder._ownerName = estate_owner_name
    holder._estateBuilding = estate_building
    holder._estateChain = estate_chain
    holder._faction = faction_key
    character_detail._startPosEstates[faction_key][estate_region..estate_building] = holder
end

character_detail._subcultureTitleKeys = {} --:map<string, string>
--v function(subculture: string, title_key: string)
function character_detail.set_title_key_for_sc(subculture, title_key)
    character_detail._subcultureTitleKeys[subculture] = title_key
end

--v function(subculture: string) --> string
function character_detail.get_title_key_for_sc(subculture)
    return character_detail._subcultureTitleKeys[subculture] 
end

--v function(subculture: string) --> boolean
function character_detail.sc_has_titles(subculture)
    return not not character_detail._subcultureTitleKeys[subculture] 
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

    self._lastEXPTotal = 0 --:number
    self._title = "no_title"
    self._homeEstate = {"no_estate", 0, false} --:{string, number, boolean}
    self._estates = {} --:map<string, map<string, ESTATE_DETAIL>>
    self._numEstates = 0 --:number

    self._forceEffectsManager = nil --:UNIT_EFFECTS_MANAGER
    self._recruiterCharacter = nil --:RECRUITER

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

--v function(self: CHARACTER_DETAIL, region_key: string, chain_key: string)
function character_detail.add_estate(self, region_key, chain_key)
    if self._estates[region_key] == nil then
        self._estates[region_key] = {}
    end
    self._estates[region_key][chain_key] = self._factionDetail._model:get_region(region_key):get_estate_detail(chain_key)
end

--v function(self: CHARACTER_DETAIL, detail: ESTATE_DETAIL)
function character_detail.add_estate_with_detail(self, detail)
    if self._estates[detail._regionName] == nil then
        self._estates[detail._regionName] = {}
    end
    self._estates[detail._regionName][detail._building] = detail
end


--v function(self: CHARACTER_DETAIL, region_key: string, chain_key: string, new_owner: CHARACTER_DETAIL?)
function character_detail.remove_estate(self, region_key, chain_key, new_owner)
    if self._estates[region_key] == nil or self._estates[region_key][chain_key] == nil then
        self:log("WARNING: Asked character ["..self._cqi.."] to remove an estate at ["..region_key.."] and ["..chain_key.."] but this character doesn't own an estate there!")
        return
    end
    local removed_estate = self._estates[region_key][chain_key]
    self._estates[region_key][chain_key] = nil
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
    if faction_pairs then
        for composite_key, start_pos_estate in pairs(faction_pairs) do
            local reg_det = self:faction_detail():model():get_region(start_pos_estate._region)
            if reg_det and reg_det:has_estate_with_chain(start_pos_estate._estateChain) then
                local estate_det = reg_det:get_estate_detail(start_pos_estate._estateChain)
                self:add_estate_with_detail(estate_det)
                estate_det:appoint_owner(self)
            end
        end
    end
end

------------------------
-----ESTATE EFFECTS-----
------------------------

--v function(self: CHARACTER_DETAIL)
function character_detail.title_for_faction_leader(self)
    local k_level = self._factionDetail:kingdom_level()
    self:log("Updating title for character ["..self._cqi.."] who is a king")
end

--v function(self: CHARACTER_DETAIL, log: boolean?) --> string
function character_detail.get_home_estate(self, log)
    if (self._homeEstate[3] == false) then
        local chosen_estate --:string
        local chosen_estate_level = 0 --:number
        for regions, building_pairs in pairs(self._estates) do
            for chain_key, estate_object in pairs(building_pairs) do
                local building_key = estate_object:building()
                local build_level = string.find(building_key, "_%d")
                local build_level_num = tonumber(string.sub(building_key, build_level+1))
                if build_level and (build_level_num > chosen_estate_level) then
                    chosen_estate = chain_key
                    chosen_estate_level = build_level_num
                end
            end
        end
        if chosen_estate  then
            if log then
                self:log("Set the home estate for character ["..self._cqi.."] as ["..self._homeEstate[1].."] ")
            end
            self._homeEstate[3] = true
            self._homeEstate[1] = chosen_estate
            self._homeEstate[2] = chosen_estate_level
        end
    end
    return self._homeEstate[1]
end

--v function(self: CHARACTER_DETAIL)
function character_detail.update_title(self)
    local char_obj = dev.get_character(self:cqi())
    if char_obj:is_faction_leader() then
        self:title_for_faction_leader()
        return
    end
    local human = dev.get_character(self:cqi()):faction():is_human()
    if human then
        self:log("Updating title for character ["..self._cqi.."] who is NOT a king")
    end
    local home_estate = self:get_home_estate(human)
    if not (home_estate == "no_estate") then
        local wealth = 0 --:number
        for estate_region, estate_pair in pairs(self._estates) do
            for estate_building, estate_object in pairs(estate_pair) do
                wealth = wealth + estate_detail.household_growth_for_estate_building_level(estate_building)
            end
        end
        if human then
            self:log("\tResolved wealth level to ["..wealth.."]")
        end
        local level --:number
        if wealth > CONST.charm_level_three_trait_threshold then
            level = 2
        elseif wealth > CONST.charm_level_two_trait_threshold then
            level = 1
        elseif wealth > CONST.charm_level_one_trait_threshold then
            level = 0
        end
        local subculture = dev.get_character(self:cqi()):faction():subculture()
        if level and character_detail.sc_has_titles(subculture) then
            local title = CONST.charm_title_prefix .. home_estate .. "_" .. character_detail.get_title_key_for_sc(subculture) .. "_" .. tostring(level)
            if human then
                self:log("\t Resolved title as ["..title.."]")
            end
            if self._title == title then
                return
            else
                cm:force_remove_trait(dev.lookup(self:cqi()), self._title)
                cm:force_add_trait(dev.lookup(self:cqi()), title, true)
                self._title = title
            end
        else
            if human then
                self:log("\t Failed to find a title level, or this character's sub doesn't have titles!")
            end
        end
    else
        if human then
            self:log("This character holds no home estate!")
        end
    end
end

--v function(self: CHARACTER_DETAIL, trigger: string, num: number, context: CA_CONTEXT)
function character_detail.grow_household(self, trigger, num, context)
    effect.add_agent_experience(trigger, num, 0, context)
    self._lastEXPTotal = self._lastEXPTotal + num
end


-----------------------------
-----RECRUITMENT MANAGER-----
-----------------------------
recruiter_character = require("ilex_verticillata/character_features/Recruiter")
_G.rc = recruiter_character
--v function(self: CHARACTER_DETAIL) --> RECRUITER
function character_detail.recruiter(self)
    if self._recruiterCharacter == nil then
        self._recruiterCharacter = recruiter_character.new(self)
    end
    return self._recruiterCharacter
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
    register_startpos_estate = character_detail.register_startpos_estate,
    set_title_key_for_sc = character_detail.set_title_key_for_sc
}