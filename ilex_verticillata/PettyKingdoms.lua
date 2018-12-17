-- The Pety Kingdoms Manager is a suite of campaign features designed for shieldwall. 
-- It is the script side data tracking archetecture behind all campaign features.
-- if you're trying to read this script for educational purposes, the best place to start is probably the faction object. 
-- This one might be confusing because it basically initializes and stores the rest of the stuff, but it doesn't represent anything itself




local petty_kingdoms_manager = {} --# assume petty_kingdoms_manager: PKM
--v method(text: any)
function petty_kingdoms_manager:log(text)
    dev.log(tostring(text), "PKM")
end


-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function() --> PKM
function petty_kingdoms_manager.init()
    local self = {}
    setmetatable(self, {
        __index = petty_kingdoms_manager,
        __type = function() return "PETTY_KINGDOMS_MANAGER" end
    }) --# assume self: PKM

    --v method() --> PKM
    function self:prototype()
        return petty_kingdoms_manager
    end
    self._lastSeason = -1 --may move this to a season manager

    --core storage of objects:
    self._factions = {} --:map<string, FACTION_DETAIL>
    self._regions = {}  --:map<string, REGION_DETAIL>
    --storage of selections:
    self._selectedProvince = nil
    self._selectedCharacter = nil
    self._selectedRegion = nil


    _G.pkm = self
    return self
end

----------------------------
-----REGION DETAIL LIB------
----------------------------

region_detail = require("ilex_verticillata/region_features/RegionDetail")

--v function(self: PKM, region_key: string, savedata: table) --> REGION_DETAIL
function petty_kingdoms_manager.load_region(self, region_key, savedata)
    self._regions[region_key] = region_detail.load(self, region_key, savedata)
    return self._regions[region_key]
end

--v function(self: PKM, region_key: string) --> REGION_DETAIL
function petty_kingdoms_manager.get_region(self, region_key)
    if self._regions[region_key] == nil then
        --first, make sure we aren't handling a typo!
        if dev.get_region(region_key) then
            --create a new region detail to handle this region
            self._regions[region_key] = region_detail.new(self, region_key)
        end
    end
    return self._regions[region_key]
end

-----------------------------
-----FACTION DETAIL LIB------
-----------------------------

faction_detail = require("ilex_verticillata/faction_features/FactionDetail")

--v function(self: PKM, faction_key: string, savedata: table) --> FACTION_DETAIL
function petty_kingdoms_manager.load_faction(self, faction_key, savedata)
    self._factions[faction_key] = faction_detail.load(self, faction_key, savedata)
    return self._factions[faction_key] 
end

--v function(self: PKM, faction_key: string) --> FACTION_DETAIL
function petty_kingdoms_manager.get_faction(self, faction_key)
    if self._factions[faction_key] == nil then
        --first, make sure we aren't handling a typo!
        if dev.get_faction(faction_key) then
            --create a new instance for this faction key!
            self._factions[faction_key] = faction_detail.new(self, faction_key)
            local faction_detail = self._factions[faction_key]
            --if the faction didn't exist, that means neither will their regions nor their provinces.
            local region_list = dev.get_faction(faction_key):region_list()
            for i = 0, region_list:num_items() - 1 do
                local current_region = region_list:item_at(i)
                local current_prov = faction_detail:get_province(current_region:province_name())
                local current_region_detail = self:get_region(current_region:name())
                current_prov:add_region(current_region:name())
            end
        end
    end
    return self._factions[faction_key]
end

--v function(self: PKM, character_cqi: CA_CQI) --> CHARACTER_DETAIL
function petty_kingdoms_manager.get_character(self, character_cqi)
    local char = dev.get_character(character_cqi)
    local faction = self:get_faction(char:faction():name())
    return faction:get_character(character_cqi)
end




--Instantiate the model
local pkm = petty_kingdoms_manager.init()

--this function creates all the required game objects on new game

--v function()
local function FirstTickObjectModel()
    pkm:log("First Tick New Game starting")
    local region_list = dev.region_list()
    for i = 0, region_list:num_items() - 1 do
        local reg_det = pkm:get_region(region_list:item_at(i):name())
        reg_det:update_buildings()
        reg_det:get_ownership_tracker():set_current_owner()
        reg_det:create_start_pos_estates()
    end
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local fact_det = pkm:get_faction(faction_list:item_at(i):name())
        for province_key, prov_det in pairs(fact_det:provinces()) do
            prov_det:get_population_manager():set_start_pos_pops()
        end
        for cqi_as_string, char_det in pairs(fact_det:characters()) do
            char_det:check_start_pos_estates()
        end
    end
    pkm:log("Finished first tick function for new game!")
end

dev.new_game(function(context)
    local ok, err = pcall(function()
        FirstTickObjectModel()
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)

--v function(context: CA_CONTEXT)
local function OnGameLoaded(context)
    --[[ pre load all regions ]]
    local region_bank = cm:load_value("pkm_region_detail", {}, context) 
    --# assume region_bank: map<string, table>
    local tracker_bank = cm:load_value("pkm_region_ownership_tracker", {}, context)
    --# assume tracker_bank: map<string, table>
    for region_key, region_save in pairs(region_bank) do
        local ld_region_detail = pkm:load_region(region_key, region_save)
        for chain_key, building_key in pairs(ld_region_detail:estate_chains()) do
            ld_region_detail:load_estate_detail(building_key)
        end
        if tracker_bank[region_key] then
            ld_region_detail:load_ownership_tracker(tracker_bank[region_key])
        end
    end
    --[[ Loaded tables ]]
    local faction_bank = cm:load_value("pkm_faction_detail", {}, context)
    --# assume faction_bank: map<string, table>
    local province_bank = cm:load_value("pkm_province_detail", {}, context)
    --# assume province_bank: map<string, map<string, table>>
    local food_manager_bank = cm:load_value("pkm_faction_food_manager", {}, context)
    --# assume food_manager_bank:map<string, table>
    local pop_manager_bank = cm:load_value("pkm_province_pop_manager", {}, context)
    --# assume pop_manager_bank:map<string, table>
    local character_bank = cm:load_value("pkm_character_detail", {}, context)
    --# assume character_bank: map<string, map<string, table>>
    local unit_effects_manager_bank = cm:load_value("pkm_character_unit_effects_manager", {}, context)
    --# assume unit_effects_manager_bank: map<string, map<string, table>>

    --load factions
    for faction_key, faction_save in pairs(faction_bank) do
        local ld_faction_detail = pkm:load_faction(faction_key, faction_save)
        local faction_province_bank = province_bank[faction_key]
        --load provinces
        if faction_province_bank then
            for province_key, province_save in pairs(faction_province_bank) do
                local ld_province_detail = ld_faction_detail:load_province(province_key, province_save)
                --load pop managers
                if pop_manager_bank[province_key.."_"..faction_key] then
                   ld_province_detail:load_population_manager(pop_manager_bank[province_key.."_"..faction_key]) 
                else
                    ld_province_detail:get_population_manager()
                end
            end
        end
        --load characters
        local faction_character_bank = character_bank[faction_key]
        if faction_character_bank then
            for character_cqi_as_string, character_save in pairs(faction_character_bank) do
                local ld_character_detail = ld_faction_detail:load_character(character_cqi_as_string, character_save) 
                --load unit effects managers
                if unit_effects_manager_bank[ld_character_detail._cqi] then
                    for force_cqi, save_table in pairs(unit_effects_manager_bank[ld_character_detail._cqi]) do
                        ld_character_detail:load_unit_effects_manager(force_cqi, save_table) 
                        break --will only ever have one item. 
                    end 
                end
            end
        end
        --load food manager
        if food_manager_bank[faction_key] then
            ld_faction_detail:load_food_manager(food_manager_bank[faction_key])
        end
    end
    --done
    pkm:log("Finished loading PKM")
end

--v function(context: CA_CONTEXT)
local function OnGameSaved(context)
    local region_bank = {} --:map<string, table>
    local tracker_bank = {} --:map<string, table>
    local faction_bank = {} --:map<string, table>
    local province_bank = {} --:map<string, map<string, table>>
    local food_manager_bank = {} --:map<string, table>
    local pop_manager_bank = {} --:map<string, table>
    local character_bank = {} --:map<string, map<string, table>>
    local unit_effects_manager_bank = {} --:map<string, map<string, table>>
    
    --save regions
    for region_key, region_detail_obj in pairs(region_detail.get_instances()) do
        region_bank[region_key] = region_detail_obj:save()
        --check for a tracker and save it.
        if region_detail_obj:has_ownership_tracker() then
           tracker_bank[region_key] = region_detail_obj:get_ownership_tracker():save()
        end
    end

    --save factions
    for faction_key, faction_detail_obj in pairs(faction_detail.get_instances()) do
        faction_bank[faction_key] = faction_detail_obj:save()
        --check for a food manager and save it
        if faction_detail_obj:has_food_manager() then
            food_manager_bank[faction_key] = faction_detail_obj:get_food_manager():save()
        end
        --set up blank save 
        province_bank[faction_key] = {}
        character_bank[faction_key] = {}
        local fact_prov_bank = province_bank[faction_key]
        local fact_char_bank = character_bank[faction_key]
        -- save provinces
        for province_key, province_detail_obj in pairs(faction_detail_obj:provinces()) do
            fact_prov_bank[province_key] = province_detail_obj:save()
            -- check for a pop manager and save it
            if province_detail_obj:has_population() then
                pop_manager_bank[province_key.."_"..faction_key] = province_detail_obj:get_population_manager():save()
            end
        end
        -- save characters
        for cqi_as_string, character_detail_obj in pairs(faction_detail_obj:characters()) do
            fact_char_bank[cqi_as_string] = character_detail_obj:save()
            if character_detail_obj:has_unit_effects_manager() then
                local uem = character_detail_obj:get_unit_effects_manager() 
                unit_effects_manager_bank[cqi_as_string] = {}
                unit_effects_manager_bank[cqi_as_string][uem._cqiAsString] = uem:save()
            end
        end
    end

    cm:save_value("pkm_region_detail", region_bank, context)
    cm:save_value("pkm_region_ownership_tracker", tracker_bank, context)
    cm:save_value("pkm_faction_detail", faction_bank, context)
    cm:save_value("pkm_province_detail", province_bank, context)
    cm:save_value("pkm_faction_food_manager", food_manager_bank, context)
    cm:save_value("pkm_province_pop_manager", pop_manager_bank, context)
    cm:save_value("pkm_character_detail", character_bank, context)
    cm:save_value("pkm_character_unit_effects_manager", unit_effects_manager_bank, context)
    pkm:log("Finished saving PKM")
end


cm:register_saving_game_callback(function(context)
    local ok, err = pcall(function()
        OnGameSaved(context)
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)

cm:register_loading_game_callback(function(context)
    local ok, err = pcall(function()
        OnGameLoaded(context)
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)