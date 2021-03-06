local region_detail = {} --# assume region_detail: REGION_DETAIL
--v method(text: any) 
function region_detail:log(text)
    dev.log(tostring(text), "RGN")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
region_detail._instances = {} --:map<string, REGION_DETAIL>
--v function(key: string, object: REGION_DETAIL)
local function register_to_prototype(key, object)
    region_detail._instances[key] = object
end
--v function() --> map<string, REGION_DETAIL>
function region_detail.get_instances()
    return region_detail._instances
end

-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(model: PKM, region_key: string) --> REGION_DETAIL
function region_detail.new(model, region_key)
    local self = {} 
    setmetatable(self, {
        __index = region_detail
    })
    --# assume self: REGION_DETAIL

    --v method() --> REGION_DETAIL
    function self:prototype()
        return region_detail
    end
    self._model = model
    self._name = region_key
    self._factionProvince = nil --:PROVINCE_DETAIL
    self._buildings = nil --:map<string, boolean>
    self._activeEffects = {} --:map<string, boolean>    
    self._effectCount = 0 --:number


    self._ownershipTracker = nil --:OWNERSHIP_TRACKER


    register_to_prototype(self._name, self)
    return self
end

--v function(self: REGION_DETAIL) --> string
function region_detail.name(self)
    return self._name
end

--v function(self: REGION_DETAIL) --> PKM
function region_detail.model(self)
    return self._model
end




-------------------
------EFFECTS------
-------------------

--clear all effects from the region
--v function(self: REGION_DETAIL)
function region_detail.clear_effects(self)
    if self._effectCount > 0 then
        for bundle, _ in pairs(self._activeEffects) do
            cm:remove_effect_bundle_from_region(bundle, self._name)
        end
        self._activeEffects = {}
        self._effectsClear = true
    end
end

--apply a bundle to the region
--v function(self: REGION_DETAIL, bundle_key: string)
function region_detail.apply_effect_bundle(self, bundle_key)
    if self._activeEffects[bundle_key] == true then
        return -- we already have the bundle we want, return.
    end
    self._activeEffects[bundle_key] = true
    cm:apply_effect_bundle_to_region(bundle_key, self._name, 0)
    self._effectCount = self._effectCount + 1
end

--v function(self: REGION_DETAIL, bundle_key: string)
function region_detail.remove_effect_bundle(self, bundle_key)
    if self._activeEffects[bundle_key] == nil then
        return -- we are removing a bundle which doesn't exist! return.
    end
    self._activeEffects[bundle_key] = false
    cm:remove_effect_bundle_from_region(bundle_key, self._name)
    self._effectCount = self._effectCount - 1 
end


----------------------------------
-----OWNERSHIP TRACKER OBJECT-----
----------------------------------
ownership_tracker = require("petty_kingdoms/region_features/OwnershipTracker")
_G.rot = ownership_tracker

--v function(self: REGION_DETAIL) --> OWNERSHIP_TRACKER
function region_detail.get_ownership_tracker(self)
    if self._ownershipTracker == nil then
        self._ownershipTracker = ownership_tracker.new(self)
    end
    return self._ownershipTracker
end

--v function(self: REGION_DETAIL, sv_tab: table) 
function region_detail.load_ownership_tracker(self, sv_tab)
    self._ownershipTracker = ownership_tracker.load(self, sv_tab)
end

--v function(self: REGION_DETAIL) --> boolean
function region_detail.has_ownership_tracker(self)
    return not not self._ownershipTracker
end
------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------
--v function(self: REGION_DETAIL) --> table
function region_detail.save(self)
    local sv_tab = dev.save(self, "_activeEffects", "_effectsClear")
    return sv_tab
end

--v function(model: PKM, region_key: string, sv_tab: table) --> REGION_DETAIL
function region_detail.load(model, region_key, sv_tab)
    local self = region_detail.new(model, region_key)
    dev.load(sv_tab, self, "_activeEffects", "_effectsClear")
    return self
end


return {
    --creation
    new = region_detail.new,
    load = region_detail.load,
    --Existance
    get_instances = region_detail.get_instances
}