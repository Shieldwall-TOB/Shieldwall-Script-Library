local ownership_tracker = {} --# assume ownership_tracker: OWNERSHIP_TRACKER
--v method(text: any) 
function ownership_tracker:log(text)
    dev.log(tostring(text), "ROT")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
ownership_tracker._instances = {} --:map<string, OWNERSHIP_TRACKER>
--v function(key: string, object: OWNERSHIP_TRACKER)
local function register_to_prototype(key, object)
    ownership_tracker._instances[key] = object
end

ownership_tracker._aiNewRegions = {} --:map<string, vector<string>>
ownership_tracker._playerNewRegions = {} --:map<string, vector<string>>

--v function() --> map<string, vector<string>>
function ownership_tracker.get_ai_new_regions()
    return ownership_tracker._aiNewRegions
end

--v function() --> map<string, vector<string>>
function ownership_tracker.get_player_new_regions()
    return ownership_tracker._playerNewRegions
end


--v function(region_detail: REGION_DETAIL, faction_name: string?) --> OWNERSHIP_TRACKER
function ownership_tracker.new(region_detail, faction_name)
    local self = {}
    setmetatable(self, {
        __index = ownership_tracker,
        __tostring = function() return "SHIELDWALL_REGION_OWNER_TRACKER" end
    }) --# assume self: OWNERSHIP_TRACKER
    self._regionDetail = region_detail
    self._regionName = region_detail:name()
    self._pastRegionOwners = {} --:map<string, number>
    self._currentOwner = nil --:string
    register_to_prototype(self._regionName, self)
    return self
end

--v function(self: OWNERSHIP_TRACKER) --> string
function ownership_tracker.current_owner(self)
    if self._currentOwner == nil then
        self._CurrentOwner = dev.get_region(self._regionName):owning_faction():name()
    end
    return self._currentOwner
end


--v function(region: string, player: string)
function ownership_tracker.player_captures_region(region, player)
    if ownership_tracker._playerNewRegions[player] == nil then
        ownership_tracker._playerNewRegions[player] = {}
    end
    table.insert(ownership_tracker._playerNewRegions[player], region)
end

--v function(region: string, ai: string)
function ownership_tracker.ai_captures_region(region, ai)
    if ownership_tracker._aiNewRegions[ai] == nil then
        ownership_tracker._aiNewRegions[ai] = {}
    end
    table.insert(ownership_tracker._aiNewRegions[ai], region)
end



--v function(self: OWNERSHIP_TRACKER, new_owner: string)
function ownership_tracker.transfer_region(self, new_owner)
    local region = self._regionName
    local old_owner = self:current_owner()
    if new_owner == old_owner then
        return
    end
    self._pastRegionOwners[old_owner] = cm:model():turn_number()
    self._currentOwner = new_owner
    if dev.get_faction(new_owner):is_human() then
        ownership_tracker.player_captures_region(region, new_owner)
    else
        ownership_tracker.ai_captures_region(region, new_owner)
    end

    dev.eh:trigger_event("FactionLostRegion", dev.get_faction(old_owner), dev.get_region(region))
end


------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------
--v function(self: OWNERSHIP_TRACKER) --> table
function ownership_tracker.save(self)
    local sv_tab = dev.save(self, "_currentOwner", "_pastRegionOwners")
    return sv_tab
end

--v function(region_detail: REGION_DETAIL, sv_tab: table) --> OWNERSHIP_TRACKER
function ownership_tracker.load(region_detail, sv_tab)
    local self = ownership_tracker.new(region_detail)
    dev.load(sv_tab, self, "_currentOwner", "_pastRegionOwners")
    return self
end




return {
    --Creation
    new = ownership_tracker.new,
    load = ownership_tracker.load,
    --Functional Prototype
    get_ai_new_regions = ownership_tracker.get_ai_new_regions,
    get_player_new_regions = ownership_tracker.get_player_new_regions
}