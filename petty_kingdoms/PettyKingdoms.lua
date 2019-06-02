-- The Petty Kingdoms Manager is a suite of campaign features designed for shieldwall. 
-- It is the script side data tracking archetecture behind all campaign features.
-- if you're trying to read this script for educational purposes, the best place to start is probably the faction object. 
-- This one might be confusing because it basically initializes and stores the rest of the stuff, but it doesn't represent anything itself,
-- It also might be confusing because PKM isn't one script that does one feature. It is essentially a data structure.
-- The actually script is done largely in feature files and the event handlers. 




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
    --storage of province rgions
    self._provinceToContainedRegions = {} --:map<string, vector<string>>
    self._provinceToCapitalRegion = {} --:map<string, string>
    --storage of selections:
    self._selectedProvince = nil
    self._selectedCharacter = nil
    self._selectedRegion = nil


    _G.pkm = self
    return self
end


--v function(self: PKM, region: CA_REGION) 
function petty_kingdoms_manager.register_region_province(self, region)
    self._provinceToContainedRegions[region:province_name()] = self._provinceToContainedRegions[region:province_name()] or {}
    table.insert(self._provinceToContainedRegions[region:province_name()], region:name())
end

----------------------------
-----REGION DETAIL LIB------
----------------------------

region_detail = require("petty_kingdoms/region_features/RegionDetail")
_G.rd = region_detail
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

faction_detail = require("petty_kingdoms/faction_features/FactionDetail")
_G.fd = faction_detail

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
                --TODO associate regions with factions
                --is that actually necessary?
            end
            --nor their characters
            local char_list = dev.get_faction(faction_key):character_list()
            for i = 0, char_list:num_items() - 1 do
                local character = char_list:item_at(i)
                if character:character_type("general") and character:has_military_force() and character:military_force():is_army() and (not character:military_force():is_armed_citizenry()) then
                    local current_char_detail = faction_detail:get_character(character:command_queue_index())
                end
            end
        end
    end
    return self._factions[faction_key]
end

--v function(self: PKM, character_cqi: CA_CQI) --> CHARACTER_DETAIL
function petty_kingdoms_manager.get_character(self, character_cqi)
    local char = dev.get_character(character_cqi)
    if char:faction():name() == "rebels" then
        return nil
    end
    local faction = self:get_faction(char:faction():name())
    return faction:get_character(character_cqi)
end


---vassal management
--v function(self: PKM, faction: string, vassal: string?)
function petty_kingdoms_manager.grant_faction_vassal(self, faction, vassal)
    local faction_det = self:get_faction(faction)
    if vassal then
        --# assume vassal: string
        local vassal_det = self:get_faction(vassal)
        vassal_det:subjugate(vassal)
        faction_det._numVassals = faction_det._numVassals + 1
        faction_det._vassals[vassal] = vassal_det
        faction_det:log("["..faction_det:name().."] vassalized ["..vassal_det:name().."]")
    else
        local faction_obj = cm:model():world():faction_by_key(faction_det:name())
        local faction_list = cm:model():world():faction_list()
        for j = 0, faction_list:num_items() - 1 do
            local potential_vassal = faction_list:item_at(j)
            if potential_vassal:is_vassal_of(faction_obj) then
                local vassal_fd = self:get_faction(vassal)
                vassal_fd:subjugate(faction)
            end
        end
    end
end


--v function(self: PKM, faction_name: string) --> boolean
function petty_kingdoms_manager.is_faction_vassal(self, faction_name)
    if faction_name == "rebels" then
        return false
    end
    return self:get_faction(faction_name):is_faction_vassal()
end

--v function(self: PKM, faction_name: string) --> boolean
function petty_kingdoms_manager.is_faction_kingdom(self, faction_name)
    if faction_name == "rebels" then
        return false
    end
    return self:get_faction(faction_name):is_major()
end

--v function(self: PKM, vassal: string)
function petty_kingdoms_manager.faction_became_vassal(self, vassal)
    if vassal == "rebels" then
        return 
    end
    local vassal_det = self:get_faction(vassal)
    local faction_obj = cm:model():world():faction_by_key(vassal_det:name())
    local faction_list = cm:model():world():faction_list()
    vassal_det:log("["..vassal_det:name().."] became a vassal! attempting to find a master!")
    for j = 0, faction_list:num_items() - 1 do
        local potential_master = faction_list:item_at(j)
        if faction_obj:is_vassal_of(potential_master) then
            self:grant_faction_vassal(potential_master:name(), vassal)
            vassal_det:log("["..vassal_det:name().."] is vassal to ["..potential_master:name().."] !")
            break
        end
    end
end

--v function(self: PKM, faction: string, castes: vector<POP_CASTE>) --> boolean
function petty_kingdoms_manager.does_faction_have_enough_population_to_levy(self, faction, castes)
    return false
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
        reg_det:get_ownership_tracker():set_current_owner()
    end
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local fact_det = pkm:get_faction(faction_list:item_at(i):name())
        fact_det:initialize_population()
        fact_det:update_population()
        for cqi_as_string, char_det in pairs(fact_det:characters()) do
            char_det:check_start_pos_estates()
            char_det:update_title(true)
            if char_det:create_unit_effects_manager() then
                char_det:get_unit_effects_manager():evaluate_force()
            end
        end
    end
    pkm:log("Finished first tick function for new game!")
end

dev.new_game(function(context)
    local ok, err = pcall(function()
        local clock = os.clock()
        FirstTickObjectModel()
        pkm:log("New Game Setup Completed: ".. string.format("elapsed time: %.2f", os.clock() - clock))
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)

--v function(context: CA_CONTEXT)
local function OnGameLoaded(context)
    --[[ pre load all regions 
        Object constructors should never include any game interface calls!
    --]]
    local region_bank = cm:load_value("pkm_region_detail", {}, context) 
    --# assume region_bank: map<string, table>
    local tracker_bank = cm:load_value("pkm_region_ownership_tracker", {}, context)
    --# assume tracker_bank: map<string, table>
    for region_key, region_save in pairs(region_bank) do
        local ld_region_detail = pkm:load_region(region_key, region_save)
        if tracker_bank[region_key] then
            ld_region_detail:load_ownership_tracker(tracker_bank[region_key])
        end
    end
    --[[ Loaded tables ]]
    local faction_bank = cm:load_value("pkm_faction_detail", {}, context)
    --# assume faction_bank: map<string, table>
    local food_manager_bank = cm:load_value("pkm_faction_food_manager", {}, context)
    --# assume food_manager_bank:map<string, table>
    local pop_manager_bank = cm:load_value("pkm_faction_pop_managers", {}, context)
    --# assume pop_manager_bank: map<string, map<string, table>>
    local pop_manager_bank = cm:load_value("pkm_province_pop_manager", {}, context)
    --# assume pop_manager_bank:map<string, table>
    local character_bank = cm:load_value("pkm_character_detail", {}, context)
    --# assume character_bank: map<string, map<string, table>>
    local unit_effects_manager_bank = cm:load_value("pkm_character_unit_effects_manager", {}, context)
    --# assume unit_effects_manager_bank: map<string, map<string, table>>

    --load factions
    for faction_key, faction_save in pairs(faction_bank) do
        local ld_faction_detail = pkm:load_faction(faction_key, faction_save)
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
        --load pop managers
        if pop_manager_bank[faction_key] then
            ld_faction_detail:load_pop_managers(pop_manager_bank[faction_key])
        end
    end
    dev.pre_first_tick(function(context)
        local region_list = dev.region_list()
        for i = 0, region_list:num_items() - 1 do
           pkm:register_region_province(region_list:item_at(i))
        end
    end)

    --done
    pkm:log("Finished loading PKM")
end

--v function(context: CA_CONTEXT)
local function OnGameSaved(context)
    local region_bank = {} --:map<string, table>
    local tracker_bank = {} --:map<string, table>
    local faction_bank = {} --:map<string, table>
    local food_manager_bank = {} --:map<string, table>
    local pop_manager_bank = {} --:map<string, map<string, table>>
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
        --set up a space to save the pop managers
        pop_manager_bank[faction_key] = {}
        local pop_manager_list = faction_detail_obj:pop_manager_list()
        for i = 1, #pop_manager_list do
            local pop_manager = pop_manager_list[i]
            pop_manager_bank[faction_key][pop_manager:caste_key()] = pop_manager:save()
        end
        --set up blank save 
        character_bank[faction_key] = {}
        local fact_char_bank = character_bank[faction_key]
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

    cm:save_value("pkm_faction_food_manager", food_manager_bank, context)
    cm:save_value("pkm_province_pop_manager", pop_manager_bank, context)
    cm:save_value("pkm_character_detail", character_bank, context)
    cm:save_value("pkm_character_unit_effects_manager", unit_effects_manager_bank, context)
    pkm:log("Finished saving PKM")
end


cm:register_saving_game_callback(function(context)
    local ok, err = pcall(function()
        local clock = os.clock()
        OnGameSaved(context)
        pkm:log("Game Saved: ".. string.format("elapsed time: %.2f", os.clock() - clock))
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)

cm:register_loading_game_callback(function(context)
    local ok, err = pcall(function()
        local clock = os.clock()
        OnGameLoaded(context)
        pkm:log("Game Loaded: ".. string.format("elapsed time: %.2f", os.clock() - clock))
    end)
    if not ok then
        pkm:log(tostring(err))
    end
end)