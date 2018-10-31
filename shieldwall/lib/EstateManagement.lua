
estate_tracker = {} --# assume estate_tracker:ET
estate_object = {} --# assume estate_object: ESTATE

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


--v function(model: ET, faction: string, region: string, estate_type: string, owner: CA_CQI?) --> ESTATE
function estate_object.new(model, faction, region, estate_type, owner)
    local self = {}
    setmetatable(self, {
        __index = estate_tracker
    })  --# assume self: ESTATE

    self._model = model
    self._owner = owner or dev.get_faction(faction):faction_leader():cqi()
    self._isRoyal = not not owner
    if dev.get_character(owner):is_heir() then
        self.isRoyal = true
    end
    self._faction = faction
    self._region = region
    self._turnGranted = cm:model():turn_number() --:number
    self._type = estate_type
    self._lastBundle = nil --:string

    return self
end

--v function(self: ESTATE, faction_key: string)
function estate_object.change_faction(self, faction_key)
    self._faction = faction_key
    self._isRoyal = true
    self._owner = dev.get_faction(faction_key):faction_leader():cqi()
end

--v function(self: ESTATE) --> string
function estate_object.type(self)
    return self._type
end

--v function(self: ESTATE) --> boolean
function estate_object.is_royal(self)
    return self._isRoyal
end

--v function(self: ESTATE) --> string
function estate_object.get_last_bundle(self)
    return self._lastBundle
end

--v function(self: ESTATE, new_bundle: string?)
function estate_object.update_bundle(self, new_bundle)
    local last_bundle = self:get_last_bundle()
    if last_bundle then
        cm:remove_effect_bundle_from_region(last_bundle, self._region)
    end
    if new_bundle then
        --# assume new_bundle: string
        cm:apply_effect_bundle_to_region(new_bundle, self._region, 0)
    end
end

--v function(self: ET, region: string) --> ESTATE
function estate_tracker.get_region_estate(self, region)
    if not not self._estateData[region] then
        return self._estateData[region]
    else
        local region_obj = cm:model():world():region_manager():region_by_key(region)
        local faction_key = region_obj:owning_faction():name()
        local estate_type = CONST.default_estate_type
        for building, estate_key in pairs(self._buildingsToEstates) do
            if region_obj:building_exists(building) then
                estate_type = estate_key
                break
            end
        end
        local new_estate = estate_object.new(self, faction_key, region, estate_type)
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
end

--v function(self: ET, character: CA_CQI, region: string)
function estate_tracker.strip_estate_from_character(self, character, region)
    local region_obj = cm:model():world():region_manager():region_by_key(region)
    local faction_key = region_obj:owning_faction():name() 
    local estate = self:get_region_estate(region)
    estate._faction = faction_key
    estate._owner = dev.get_faction(faction_key):faction_leader():cqi()
    estate._isOwned = true
end

--v function(self: ET, estate: CA_ESTATE) --> ESTATE
function estate_tracker.check_estate(self, estate)
    if self._estateData[estate:region():name()] then
        return self._estateData[estate:region():name()]
    else
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
        return self._estateData[estate_region]
    end
end

--v function (self: ET, region: string) --> boolean
function estate_tracker.has_estate(self, region)
    return not not self._estateData[region]
end



estate_tracker.init()