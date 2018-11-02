
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

--v method(text: any)
function estate_tracker:log(text)
    MODLOG(tostring(text), "ET ")
end

--v function(model: ET, faction: string, region: string, estate_type: string, owner: CA_CQI?) --> ESTATE
function estate_object.new(model, faction, region, estate_type, owner)
    local self = {}
    setmetatable(self, {
        __index = estate_object
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

--v function(self: ESTATE) --> ESTATE_SAVE
function estate_object.save(self)
    local savetable = {}
    savetable._faction = self._faction
    savetable._region = self._region
    savetable._isRoyal = self._isRoyal
    savetable._type = self._type
    savetable._cqi = tostring(self._owner)
    savetable._turnGranted = tostring(self._turnGranted)

    return savetable
end

--v function(savetable: ESTATE_SAVE) --> ESTATE
function estate_object.load(savetable)
    local self = {}
    setmetatable(self, {
        __index = estate_tracker
    })  --# assume self: ESTATE

    self._faction = savetable._faction
    self._region = savetable._region
    self._isRoyal = savetable._isRoyal
    self._type = savetable._type
    local loaded_owner = tonumber(savetable._cqi) 
    --# assume loaded_owner: CA_CQI
    self._owner = loaded_owner
    self._turnGranted = tonumber(savetable._turnGranted)

    return self
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

--v function(self: ET, estate_table: ESTATE_SAVE)
function estate_tracker.load_estate(self, estate_table)
    self:log("Loading an estate for region ["..estate_table._region.."] ")
    self._estateData[estate_table._region] = estate_object.load(estate_table)
end

--v function(self: ET, estate_region: string, is_royal: boolean)
function estate_tracker.create_start_pos_estate(self, estate_region, is_royal)
    local region_obj = dev.get_region(estate_region)
    local faction = region_obj:owning_faction()
    local faction_name = faction:name()
    local estate_type = CONST.default_estate_type
    for building, estate_key in pairs(self._buildingsToEstates) do
        if region_obj:building_exists(building) then
            estate_type = estate_key
            break
        end
    end
    local estate_char --:CA_CQI
    if is_royal then
        estate_char = faction:faction_leader():cqi()
    else
        for i = 0, faction:character_list():num_items() - 1 do
            local current_char = faction:character_list():item_at(i)
            if not (current_char:is_heir() or current_char:is_faction_leader()) then
                estate_char = current_char:cqi()
                break
            end
        end
    end
    if estate_char == nil then
        self:log("ERROR: couldn't find a char to pin a startpos estate to!")
    end
    local estate = estate_object.new(self, estate_region, faction_name, estate_type, estate_char)
    self._estateData[estate_region] = estate
end


estate_tracker.init()