estate_object = {} --# assume estate_object: ESTATE

--v function(model: ET, faction: string, region: string, estate_type: string, owner: CA_CQI?) --> ESTATE
function estate_object.new(model, faction, region, estate_type, owner)
    local self = {}
    setmetatable(self, {
        __index = estate_object,
        __tostring = function() return "SHIELDWALL_ESTATE" end
    })  --# assume self: ESTATE

    self._model = model
    self._owner = owner or dev.get_faction(faction):faction_leader():cqi()
    self._isRoyal = not not not owner
    if owner then
        if dev.get_character(owner):is_heir() or dev.get_character(owner):is_faction_leader() then
            self.isRoyal = true
        end
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
    local faction = dev.get_faction(faction_key)
    if faction and (not faction:faction_leader():is_null_interface()) then
        self._owner = faction:faction_leader():cqi()
    else

    end
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
    self._model:log("Updating bundles for estate ["..self._region.."] ")
    local last_bundle = self:get_last_bundle()
    if last_bundle then
        self._model:log("Removing bundle ["..last_bundle.."] for estate ["..self._region.."] ")
        cm:remove_effect_bundle_from_region(last_bundle, self._region)
    end
    if new_bundle then
        --# assume new_bundle: string
        self._lastBundle = new_bundle
        self._model:log("Applying bundle ["..new_bundle.."] for estate ["..self._region.."]   ")
        cm:apply_effect_bundle_to_region(new_bundle, self._region, 0)
    end
end

--v function(self: ESTATE) --> ESTATE_SAVE
function estate_object.save(self)
    self._model:log("Saving data for estate ["..self._region.."] ")
    local savetable = {}
    savetable._faction = self._faction
    savetable._region = self._region
    savetable._isRoyal = self._isRoyal
    savetable._type = self._type
    savetable._cqi = tostring(self._owner)
    savetable._turnGranted = tostring(self._turnGranted)
    savetable._lastBundle = self._lastBundle

    return savetable
end

--v function(model: ET, savetable: ESTATE_SAVE) --> ESTATE
function estate_object.load(model, savetable)
    local self = {}
    setmetatable(self, {
        __index = estate_object
    })  --# assume self: ESTATE
    self._model = model
    self._faction = savetable._faction
    self._region = savetable._region
    self._isRoyal = savetable._isRoyal
    self._type = savetable._type
    local loaded_owner = tonumber(savetable._cqi) 
    --# assume loaded_owner: CA_CQI
    self._owner = loaded_owner
    self._turnGranted = tonumber(savetable._turnGranted)
    self._lastBundle = savetable._lastBundle
    return self
end



return {
    new = estate_object.new,
    load = estate_object.load
}