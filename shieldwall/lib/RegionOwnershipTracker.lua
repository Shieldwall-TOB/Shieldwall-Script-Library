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
    dev.log(tostring(text), "ROT")
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
    region_obj = dev.get_region(region)
    if self._currentRegionOwners[region] == nil then
        --we don't have the region!
        --self:log("Starting to track the region ["..region.."] ")
        self._currentRegionOwners[region] = region_obj:owning_faction():name()
        self._pastRegionOwners[region] = {}
    else
        local old_owner = self._currentRegionOwners[region]
        local new_owner = region_obj:owning_faction()
        if old_owner == new_owner:name() then
            --this happens when loading an old save.
            return
        end
        if new_owner:is_human() then
            self:player_captures_region(region, new_owner:name())
        end
        self:log("Region ["..region.."] is being transfered from ["..old_owner.."] to ["..new_owner:name().."]")
        self._pastRegionOwners[region][old_owner] = cm:model():turn_number()
        self._currentRegionOwners[region] = new_owner:name()
        dev.eh:trigger_event("FactionLostRegion", dev.get_faction(old_owner), region_obj)
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

--v function(self: ROT, player: string) --> vector<string>
function region_owner_tracker.get_player_new_regions(self, player)
    if self._playerNewRegions[player] == nil then
        self._playerNewRegions[player] = {}
    end
    return self._playerNewRegions[player]
end

--v function(self: ROT, player: string)
function region_owner_tracker.clear_player_new_regions(self, player)
    self._playerNewRegions[player] = {}
end

--v function(self: ROT) --> ROT_SAVE
function region_owner_tracker.save(self)
    local svtable = {}
    svtable._owners = self._currentRegionOwners
    svtable._pastOwners = self._pastRegionOwners
    svtable._playerNewRegions = self._playerNewRegions
    return svtable
end

--v function(self: ROT, svtable: ROT_SAVE)
function region_owner_tracker.load(self, svtable)
    self._currentRegionOwners = svtable._owners or {}
    self._pastRegionOwners = svtable._pastOwners  or {}
    self._playerNewRegions = svtable._playerNewRegions or {}
end




region_owner_tracker.init()