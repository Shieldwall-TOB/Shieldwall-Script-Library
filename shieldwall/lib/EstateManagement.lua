
estate_tracker = {} --# assume estate_tracker:ET


--v function() --> ET
function estate_tracker.init()
    local self = {} 
    setmetatable(self, {
        __index = estate_tracker
    }) --# assume self: ET

    self._buildingsToEstates = {} --:map<string, string>
    self._estateData = {} --:map<string, ESTATE>

    _G.et = self
    return self
end

--v method(text: any)
function estate_tracker:log(text)
    dev.log(tostring(text), "ET ")
end

--v function(self: ET, building: string, estate_type: string)
function estate_tracker.add_estate_to_building(self, building, estate_type)
    self._buildingsToEstates[building] = estate_type
end


local estate_object = require("shieldwall/lib/region_features/Estate")



--v function(self: ET, region: string) --> ESTATE
function estate_tracker.get_region_estate(self, region)
    if not not self._estateData[region] then
        return self._estateData[region]
    else
        self:log("Asked for an estate at ["..region.."] which doesn't yet exist! inferring it ")
        local region_obj = cm:model():world():region_manager():region_by_key(region)
        local faction_key = region_obj:owning_faction():name()
        local estate_type = CONST.default_estate_type
        for building, estate_key in pairs(self._buildingsToEstates) do
            if region_obj:building_exists(building) then
                self:log("inferred type for new estate as ["..estate_key.."]")
                estate_type = estate_key
                break
            end
        end
        self._estateData[region]  = estate_object.new(self, faction_key, region, estate_type)
        dev.eh:trigger_event("CharacterGainedEstate", dev.get_faction(faction_key):faction_leader(), self._estateData[region])
        return self._estateData[region]
    end
end

--v function(self: ET, character: CA_CQI, region: string)
function estate_tracker.grant_estate_to_character(self, character, region)
    local region_obj = dev.get_region(region)
    local faction_key = region_obj:owning_faction():name() 
    local estate = self:get_region_estate(region)
    estate._faction = faction_key
    estate._owner = character
    estate._isRoyal = (dev.get_character(character):is_heir() or dev.get_character(character):is_faction_leader())
    dev.eh:trigger_event("CharacterGainedEstate", dev.get_character(character), self._estateData[region])
end

--v function(self: ET, character: CA_CQI, region: string)
function estate_tracker.strip_estate_from_character(self, character, region)
    local region_obj = cm:model():world():region_manager():region_by_key(region)
    local faction_key = region_obj:owning_faction():name() 
    local estate = self:get_region_estate(region)
    dev.eh:trigger_event("CharacterLostEstate", dev.get_character(estate._owner), estate)
    estate._faction = faction_key
    estate._owner = dev.get_faction(faction_key):faction_leader():cqi()
    estate._isRoyal = true
    dev.eh:trigger_event("CharacterGainedEstate", dev.get_faction(faction_key):faction_leader(), self._estateData[region])
end

--v function(self: ET, estate: CA_ESTATE) --> ESTATE
function estate_tracker.check_estate(self, estate)
    if self._estateData[estate:region():name()] then
        return self._estateData[estate:region():name()]
    else
        self:log("Checked estate for a region that doesn't have one!")
        local estate_region = estate:region():name()
        local estate_faction = estate:region():owning_faction():name()
        local estate_owner = estate:owner()
        local estate_cqi
        if estate_owner:is_null_interface() then
            estate_cqi = nil
        else
            estate_cqi = estate_owner:cqi()
        end
        local estate_type = estate:estate_record_key()
        self._estateData[estate_region] = estate_object.new(self, estate_faction, estate_region, estate_type, estate_cqi)
        dev.eh:trigger_event("CharacterGainedEstate", estate_owner, self._estateData[estate_region])
        return self._estateData[estate_region]
    end
end

--v function (self: ET, region: string) --> boolean
function estate_tracker.has_estate(self, region)
    return not not self._estateData[region]
end

--v function(self: ET, estate_table: ESTATE_SAVE)
function estate_tracker.load_estate(self, estate_table)
    self:log("Loading an estate for region ["..estate_table._region.."] ")
    self._estateData[estate_table._region] = estate_object.load(self, estate_table)
end




estate_tracker.init()