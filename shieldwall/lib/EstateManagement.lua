
estate_tracker = {} --# assume estate_tracker:ET
estate_object = {} --# assume estate_object: ESTATE

--v function() --> ET
function estate_tracker.init()
    local self = {} 
    setmetatable(self, {
        __index = estate_tracker
    }) --# assume self: ET
    self._estateData = {} --:map<string, ESTATE>

    _G.et = self
    return self
end


--v function(model: ET, character: CA_CQI, faction: string, region: string) --> ESTATE
function estate_object.new(model, character, faction, region)
    local self = {}
    setmetatable(self, {
        __index = estate_tracker
    })  --# assume self: ESTATE

    self._model = model
    self._owner = character
    self._faction = faction
    self._region = region
    self._turnGranted = cm:model():turn_number()

    return self
end

--v function(self: ET,  character: CA_CQI, faction: string, region: string) --> ESTATE
function estate_tracker.get_region_estate(self, character, faction, region)
    if not not self._estateData[region] then
        return self._estateData[region]
    else
        self._estateData[region] = estate_object.new(self, character, faction, region)
        return self._estateData[region]
    end
end

estate_tracker.init()