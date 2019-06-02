-- each faction object has a food storage manager object attached which handles their food exports, inports and storage
local food_manager = {} --# assume food_manager: FOOD_MANAGER
--v method(text: any)
function food_manager:log(text)
    dev.log(tostring(text), "FFM")
end

-------------------------
-----STATIC CONTENT------
-------------------------

food_manager._buildingFoodStorageCap = {} --:map<string, number>
--v function(building: string, cap_effect: number)
function food_manager.add_food_storage_cap_effect_to_building(building, cap_effect)
    food_manager._buildingFoodStorageCap[building] = cap_effect
end


----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(faction: FACTION_DETAIL) --> FOOD_MANAGER
function food_manager.new(faction)
    local self = {}
    setmetatable(self, {
        __index = food_manager,
        __tostring = function() return "FACTION_FOOD_MANAGER" end
    })--# assume self: FOOD_MANAGER


    self._factionDetail = faction
    self._factionName = faction:name()
    self._storageCapRegionContributions = {} --:map<string, number>
    self._storageCap = CONST.food_storage_cap_base --:number
    self._storedFood = 0 --:number
    self._drawnFood = 0 --:number
    self._foodTradeAllowed = false --:boolean

    return self
end

--------------------------
------GENERIC METHODS-----
--------------------------

--v function(self: FOOD_MANAGER) --> FACTION_DETAIL
function food_manager.faction_detail(self)
    return self._factionDetail
end

--v function(self: FOOD_MANAGER) --> number
function food_manager.food_in_storage(self)
    return self._storedFood
end

--v function(self: FOOD_MANAGER) --> number
function food_manager.food_store_cap(self)
    return self._storageCap
end

--v function(self: FOOD_MANAGER) --> number
function food_manager.food_being_drawn(self)
    return self._drawnFood
end

--v function(self: FOOD_MANAGER, region: string) --> number
function food_manager.get_food_storage_cap_contrib_from_region(self, region)
    if self._storageCapRegionContributions[region] == nil then
        self._storageCapRegionContributions[region] = 0
    end
    return self._storageCapRegionContributions[region]
end

--v method(building: string) --> boolean
function food_manager:has_food_storage_cap_effect(building)
    return not not food_manager._buildingFoodStorageCap[building]
end


-----------------------------------
----STATE CHANGING FUNCTIONS-------
-----------------------------------
--v function(self: FOOD_MANAGER, quantity: number)
function food_manager.mod_food_storage(self, quantity)
    local faction = self._factionName
    self:log("Modifying the food storage for faction ["..tostring(faction).."] by quantity ["..tostring(quantity).."] ")
    local old_val = self:food_in_storage()
    local new_val = old_val + quantity
    --clamp the value to the nearest 5
    if not (new_val%5 == 0) then
        new_val = (math.ceil((new_val/5)-0.5))*5
        self:log("clamped new food storage value to ["..new_val.."] ")
    else
        self:log("new food storage is ["..new_val.."] ")
    end
    --clamp the value to the current cap
    local cap = self:food_store_cap()
    if new_val > cap then
        new_val = cap
    elseif new_val < 0 then
        new_val = 0
    end
    if not (old_val == 0) then
       -- cm:remove_effect_bundle(CONST.food_storage_bundle..(tostring(old_val)), faction)
    end
    self._storedFood = new_val
    if not (new_val == 0) then
        --cm:apply_effect_bundle(CONST.food_storage_bundle..(tostring(new_val)), faction, 0)
    end
end

--v function(self: FOOD_MANAGER, old_stores: number, cap: number, quantity: number) --> number
function food_manager.calculate_potential_food_change(self, old_stores, cap, quantity)
    local old_val = old_stores
    local new_val = old_val + quantity

    --clamp the value to the current cap
    if new_val > cap then
        new_val = cap
    elseif new_val < 0 then
        new_val = 0
    end
    return (new_val - old_val)
end


--v function(self: FOOD_MANAGER, region: string)
function food_manager.remove_region_contribution(self, region)
    --possibly unsafe. All values here *should* be clamped by default down to the values they are supposed to be, but if problems arise then redo this function.
    local contribution = self:get_food_storage_cap_contrib_from_region(region)
    local cap = self:food_store_cap()
    local new_cap = cap - contribution
    self._storageCap = new_cap
    local in_storage = self:food_in_storage()
    if in_storage > new_cap then
        self:mod_food_storage(new_cap - in_storage)
    end
    self._storageCapRegionContributions[region] = 0
end



--v function(self: FOOD_MANAGER, region: CA_REGION)
function food_manager.calc_food_storage_cap(self, region)
    if region:owning_faction():is_null_interface() then
        return
    end
    if region:settlement():is_null_interface() then 
        return
    end
    local faction = region:owning_faction():name()
    self:log("calculating food storage for ["..faction.."] in region ["..region:name().."] ")
    local old_val = self:food_store_cap()
    local old_region_contrib = self:get_food_storage_cap_contrib_from_region(region:name())
    local real_val = old_val - old_region_contrib
    local new_region_contrib = 0 --:number
    for building, quantity in pairs(food_manager._buildingFoodStorageCap) do
        if region:building_exists(building) then
            new_region_contrib = new_region_contrib + quantity
        end
    end
    --clamp change to the max values
    if real_val + new_region_contrib > CONST.food_storage_cap_absolute then
        new_region_contrib = CONST.food_storage_cap_absolute - real_val
    end
    --clamp change to multiples of five, rounding up
    if not (new_region_contrib%5 == 0) then
        new_region_contrib = (math.ceil((new_region_contrib/5)-0.5))*5
        self:log("clamped new food storage capacity to ["..new_region_contrib.."] ")
    else
        self:log("new food storage capacity is is ["..new_region_contrib.."] ")
    end
    --set the values
    local new_val = real_val + new_region_contrib
    self._storageCap = new_val
    self._storageCapRegionContributions[region:name()] = new_region_contrib
   
    --make sure we are still under the storage cap
    local in_storage = self:food_store_cap()
    if in_storage > new_val then
        self:mod_food_storage(new_val - in_storage)
    end
end

--v function(self: FOOD_MANAGER)
function food_manager.calculate_draw_needs(self)
    if self._factionName == "rebels" then
        self:log("No food storage for rebels!")
        return
    end
    local faction = dev.get_faction(self._factionName)
    local current_draw = self:food_being_drawn()
    local total_food = faction:total_food()
    local before_stores = total_food - current_draw
    local stores = self:food_in_storage()
    if before_stores < 0 and stores > 0 then
        if current_draw > 0 then
            cm:remove_effect_bundle(CONST.food_storage_bundle..(tostring(current_draw)), faction:name())
        end
        local desired_new_draw = before_stores*-1 --:number
        
        if desired_new_draw > stores then
            desired_new_draw = stores
        end
        --clamp to a multiple of five, rounding up
        if not (desired_new_draw%5 == 0) then
            desired_new_draw = (math.ceil((desired_new_draw/5)-0.5))*5
        end
        cm:apply_effect_bundle(CONST.food_storage_bundle..(tostring(desired_new_draw)), faction:name(), 0)
        self._drawnFood = desired_new_draw
    else
        self._drawnFood = 0
        if current_draw > 0 then
            cm:remove_effect_bundle(CONST.food_storage_bundle..(tostring(current_draw)), faction:name())
        end
    end
end



------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(faction: FACTION_DETAIL, savetable: table) --> FOOD_MANAGER
function food_manager.load(faction, savetable)
    local self = food_manager.new(faction)
    dev.load(savetable, self, "_storageCapRegionContributions", "_storageCap", "_storedFood", "_foodTradeAllowed", "_drawnFood")
    return self
end

--v function(self: FOOD_MANAGER) --> table
function food_manager.save(self)
    return dev.save(self, "_storageCapRegionContributions", "_storageCap", "_storedFood", "_foodTradeAllowed", "_drawnFood")
end



return {
    --creation
    new = food_manager.new,
    load = food_manager.load,
    --content API
    add_food_storage_cap_effect_to_building =  food_manager.add_food_storage_cap_effect_to_building
}