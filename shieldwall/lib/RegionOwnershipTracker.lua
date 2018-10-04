local region_owner_tracker = {} --# assume region_owner_tracker: ROT

--v function()
function region_owner_tracker.init()
    local self = {} 
    setmetatable(self, {
        __index = region_owner_tracker
    }) --# assume self: ROT

    self._pastRegionOwners = {} --:map<string, map<string, number>>
    self._currentRegionOwners = {} --:map<string, string>
    --maps the region key to a map of owner and the turn they lost it.
    self._removalTimer = 15 --:number
    --how many turns until the thing deletes past owners.
    self._playerNewRegions = {} --:map<string, vector<string>>
    --stores regions aquired by the player between turns.
    _G.rot = self
    _G.region_tracker = self
end

--v method(text: any)
function region_owner_tracker:log(text)
    MODLOG(tostring(text), "ROT")
end

--v function(self: ROT, region: string, player: string)
function region_owner_tracker.player_captures_region(self, region, player)
    if self._playerNewRegions[player] == nil then
        self._playerNewRegions[player] = {}
    end
    table.insert(self._playerNewRegions[player], region)
end

--v function(self: ROT, region: string)
function region_owner_tracker.transfer_or_add_region(self, region)
    local region_obj = cm:model():world():region_manager():region_by_key(region)
    if self._currentRegionOwners[region] == nil then
        --we don't have the region!
        self:log("Starting to track the region ["..region.."] ")
        self._currentRegionOwners[region] = region_obj:owning_faction():name()
        self._pastRegionOwners[region] = {}
    else
        local old_owner = self._currentRegionOwners[region]
        local new_owner = region_obj:owning_faction()
        if new_owner:is_human() then
            self:player_captures_region(region, new_owner:name())
        end
        self:log("Region ["..region.."] is being transfered from ["..old_owner.."] to ["..new_owner:name().."]")
        self._pastRegionOwners[region][old_owner] = cm:model():turn_number()
        self._currentRegionOwners[region] = new_owner:name()
    end
end


--v function(self: ROT, region: string)
function region_owner_tracker.clean_region(self, region)
    self:log("Cleaning up region ["..region.."] ")
    if self._pastRegionOwners[region] == nil then
        self:transfer_or_add_region(region)
    end
    for owner, timer in pairs(self._pastRegionOwners[region]) do
        if timer + self._removalTimer < cm:model():turn_number() then
            self._pastRegionOwners[region][owner] = nil
        end
    end
end

--v function(self: ROT, region: string) --> map<string, number>
function region_owner_tracker.get_past_owners(self, region)
    if self._pastRegionOwners[region] == nil then
        self._pastRegionOwners[region] = {}
    end
    return self._pastRegionOwners[region]
end

--v function(self: ROT, player: string)
function region_owner_tracker.clear_player_new_regions(self, player)
    self._playerNewRegions[player] = {}
end