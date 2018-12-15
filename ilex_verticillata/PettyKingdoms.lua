-- The Pety Kingdoms Manager is a suite of campaign features designed for shieldwall. 
-- It is the script side data tracking archetecture behind all campaign features.
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

region_detail = require("ilex_verticillata/province_features/RegionDetail")

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






--Instantiate the model
local pkm = petty_kingdoms_manager.init()

--this function creates all the required game objects on new game

--v function()
local function FirstTickObjectModel()
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        pkm:get_faction(faction_list:item_at(i):name())
    end
end


--v function(context: CA_CONTEXT)
local function OnGameLoaded(context)
    local region_bank = cm:load_value("pkm_region_detail", {}, context)
    for region_key, region_save in pairs(region_bank) do
        pkm:load_region(region_key, region_save)
    end
    local faction_bank = cm:load_value("pkm_faction_detail", {}, context)
    local province_bank = cm:load_value("pkm_province_detail", {}, context)
    local food_manager_bank = cm:load_value("pkm_faction_food_manager", {}, context)
    local pop_manager_bank = cm:load_value("pkm_province_pop_manager", {}, context)
    local character_bank = cm:load_value("pkm_character_detail", {}, context)
    local unit_effects_manager_bank = cm:load_value("pkm_character_unit_effects_manager", {}, context)
    for faction_key, faction_save in pairs(faction_bank) do
        local detail = pkm:load_faction(faction_key, faction_save)
        local faction_province_bank = province_bank[faction_key]
        if faction_province_bank then
            for province_key, province_save in pairs(faction_province_bank) do
                detail:load_province(province_key, province_save)
            end
        end
    end
end

--v function(context: CA_CONTEXT)
local function OnGameSaved(context)

end