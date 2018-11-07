faction_kingdom_manager = {} --# assume faction_kingdom_manager: FKM


--v function()
function faction_kingdom_manager.init()
    local self = {}
    setmetatable(self, {
        __index = faction_kingdom_manager,
        __tostring = function() return "FACTION_KINGDOM_MANAGER" end
    }) --# assume self: FKM

    self._kingdoms = {} --:map<string, FKM_KINGDOM>
    self._vassals = {} --:map<string, FKM_VASSAL>
    self._factionFoodStorageQuantity = {} --:map<string, number>
    self._factionFoodStorageCaps = {} --:map<string, number>
    self._foodStorageRegionContribution = {} --:map<string, number>
    self._buildingFoodStorageCap = {} --:map<string, number>
    
    --major faction autoresolve bonus toggles
    self._influenceAutoresolve = CONST.enable_great_kingdom_bonus
    _G.fkm = self
end

--v method(text: any)
function faction_kingdom_manager:log(text)
    dev.log(tostring(text), "FKM")
end



local fkm_vassal = require("shieldwall/lib/faction_features/Vassal")
local fkm_kingdom = require("shieldwall/lib/faction_features/Kingdom")



--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_kingdom(self, faction_key)
    if self._kingdoms[faction_key] == nil then
        return false
    else
        return true
    end
end

--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_vassal(self, faction_key)
    if self._vassals[faction_key] == nil then
        return false
    else 
        return true
    end
end

--v function(self: FKM, faction_key: string) --> FKM_KINGDOM
function faction_kingdom_manager.add_kingdom(self, faction_key)

    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction already has a kingdom entry, returning it.")
        return self._kingdoms[faction_key]
    end

    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction is a vassal!, deleting the vassal!")
        self._vassals[faction_key] = nil
    end

    local faction_obj = cm:model():world():faction_by_key(faction_key)
    local kingdom = fkm_kingdom.new(self, faction_key, faction_obj:is_human())
    self._kingdoms[faction_key] = kingdom
    self:log("added the faction ["..faction_key.."] as a kingdom! ")
    return kingdom
end

--v function(self: FKM, faction_key: string, known_liege: string?) --> FKM_VASSAL
function faction_kingdom_manager.add_vassal(self, faction_key, known_liege)
    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction already has a vassal entry, returning it.")
        return self._vassals[faction_key]
    end
    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction is a kingdom!, deleting the Kingdom!")
        self._kingdoms[faction_key] = nil
    end
    local faction_obj = cm:model():world():faction_by_key(faction_key)
    
    local liege_key --:string
    if not not known_liege then
        --# assume known_liege: string
        liege_key = known_liege
    else
        local list = cm:model():world():faction_list()
        for i = 0, list:num_items() - 1 do
            local target = list:item_at(i)
            if faction_obj:is_vassal_of(target) then
                liege_key = target:name()
                break
            end
        end
    end
    if liege_key == nil then
        self:log("ERROR: Could not find the liege for faction ["..faction_key.."], aborting their creation as a vassal!")
        return fkm_vassal.null_interface()
    end
    local vassal = fkm_vassal.new(self, faction_key, liege_key)
    self._vassals[faction_key] = vassal
    self:log("Added faction ["..faction_key.."] as a vassal with liege ["..liege_key.."]")
    return vassal
end

--v function(self: FKM, vassal: string)
function faction_kingdom_manager.remove_vassal(self, vassal)
    if not self:is_faction_vassal(vassal) then
        self:log("the faction ["..vassal.."] is being called for removal from the vassals list, they already is not a vassal!")
        return 
    end
    self:log("removing the faction ["..vassal.."] from the vassal list!")
    self._vassals[vassal] = nil
end

--v function(self: FKM, faction: string) --> number
function faction_kingdom_manager.get_food_in_storage_for_faction(self, faction)
    if self._factionFoodStorageQuantity[faction] == nil then
        self._factionFoodStorageQuantity[faction] = 0
    end
    return self._factionFoodStorageQuantity[faction]
end

--v function(self: FKM, faction: string) --> number
function faction_kingdom_manager.get_food_storage_cap_for_faction(self, faction)
    if self._factionFoodStorageCaps[faction] == nil then
        self._factionFoodStorageCaps[faction] = CONST.food_storage_cap_base
    end
    return self._factionFoodStorageCaps[faction]
end

--v function(self: FKM, region: string) --> number
function faction_kingdom_manager.get_food_storage_cap_contrib_from_region(self, region)
    if self._foodStorageRegionContribution[region] == nil then
        self._foodStorageRegionContribution[region] = 0
    end
    return self._foodStorageRegionContribution[region]
end

--v function(self: FKM, faction: string, quantity: number)
function faction_kingdom_manager.mod_food_storage(self, faction, quantity)
    self:log("Modifying the food storage for faction ["..faction.."] by quantity ["..tostring(quantity).."] ")
    local old_val = self:get_food_in_storage_for_faction(faction)
    local new_val = old_val + quantity
    --clamp the value to the nearest 5
    if not (new_val%5 == 0) then
        new_val = (math.ceil((new_val/5)-0.5))*5
        self:log("clamped new food storage value to ["..new_val.."] ")
    else
        self:log("new food storage is ["..new_val.."] ")
    end
    --clamp the value to the current cap
    local cap = self:get_food_storage_cap_for_faction(faction)
    if new_val > cap then
        new_val = cap
    elseif new_val < 0 then
        new_val = 0
    end
    if not (old_val == 0) then
        cm:remove_effect_bundle(CONST.food_storage_bundle..(tostring(old_val)), faction)
    end
    self._factionFoodStorageQuantity[faction] = new_val
    if not (new_val == 0) then
        cm:apply_effect_bundle(CONST.food_storage_bundle..(tostring(new_val)), faction, 0)
    end
end

--v function(self: FKM, old_stores: number, cap: number, quantity: number) --> number
function faction_kingdom_manager.calculate_potential_food_change(self, old_stores, cap, quantity)
    local old_val = old_stores
    local new_val = old_val + quantity
    --clamp the value to the nearest 5
    if not (new_val%5 == 0) then
        new_val = (math.ceil((new_val/5)-0.5))*5
    else 

    end
    --clamp the value to the current cap
    if new_val > cap then
        new_val = cap
    elseif new_val < 0 then
        new_val = 0
    end
    return (new_val - old_val)
end

--v function(self: FKM, region: string, faction: string)
function faction_kingdom_manager.remove_region_contribution_from_faction(self, region, faction)
    --possibly unsafe. All values here *should* be clamped by default down to the values they are supposed to be, but if problems arise then redo this function.
    local contribution = self:get_food_storage_cap_contrib_from_region(region)
    local cap = self:get_food_storage_cap_for_faction(faction)
    local new_cap = cap - contribution
    self._factionFoodStorageCaps[faction] = new_cap
    local in_storage = self:get_food_in_storage_for_faction(faction)
    if in_storage > new_cap then
        self:mod_food_storage(faction, new_cap - in_storage)
    end
    self._foodStorageRegionContribution[region] = 0
end



--v function(self: FKM, region: CA_REGION)
function faction_kingdom_manager.calc_food_storage_cap(self, region)
    if region:owning_faction():is_null_interface() then
        return
    end
    if region:settlement():is_null_interface() then 
        return
    end
    local faction = region:owning_faction():name()
    self:log("calculating food storage for ["..faction.."] in region ["..region:name().."] ")
    local old_val = self:get_food_storage_cap_for_faction(faction)
    local old_region_contrib = self:get_food_storage_cap_contrib_from_region(region:name())
    local real_val = old_val - old_region_contrib
    local new_region_contrib = 0 --:number
    for building, quantity in pairs(self._buildingFoodStorageCap) do
        if region:building_exists(building) then
            new_region_contrib = new_region_contrib + quantity
        end
    end
    --clamp change to the max values
    if real_val + new_region_contrib > CONST.food_storage_cap_absolute then
        new_region_contrib = CONST.food_storage_cap_absolute - real_val
    end
    --clamp change to multiples of five, rounding down
    if not (new_region_contrib%5 == 0) then
        new_region_contrib = (math.ceil((new_region_contrib/5)-0.5))*5
        self:log("clamped new food storage capacity to ["..new_region_contrib.."] ")
    else
        self:log("new food storage capacity is is ["..new_region_contrib.."] ")
    end
    --set the values
    local new_val = real_val + new_region_contrib
    self._factionFoodStorageCaps[faction] = new_val
    self._foodStorageRegionContribution[region:name()] = new_region_contrib
    --make sure we are still under the storage cap
    local in_storage = self:get_food_in_storage_for_faction(faction)
    if in_storage > new_val then
        self:mod_food_storage(faction, new_val - in_storage)
    end
end

--v function(self: FKM, building: string, quantity: number)
function faction_kingdom_manager.add_food_storage_cap_effect_to_building(self, building, quantity)
    self._buildingFoodStorageCap[building] = quantity
end

--v function(self: FKM, building: string) --> boolean
function faction_kingdom_manager.does_building_have_cap_effect(self, building)
    return not not self._buildingFoodStorageCap[building]
end

--v function(self: FKM, svtable: {_regionValues: map<string, number>, _factionValues: map<string, number>, _factionCaps: map<string, number>})
function faction_kingdom_manager.load_food_storage(self, svtable)
    self._foodStorageRegionContribution = svtable._regionValues or {}
    self._factionFoodStorageQuantity = svtable._factionValues or {}
    self._factionFoodStorageCaps = svtable._factionCaps or {}
end

--v function(self: FKM) --> {_regionValues: map<string, number>, _factionValues: map<string, number>, _factionCaps: map<string, number>}
function faction_kingdom_manager.save_food_storage(self)
    local retval = {}
    retval._regionValues = self._foodStorageRegionContribution
    retval._factionValues = self._factionFoodStorageQuantity
    retval._factionCaps = self._factionFoodStorageCaps
    return retval
end

faction_kingdom_manager.init()
_G.fkm:log("Init complete")
