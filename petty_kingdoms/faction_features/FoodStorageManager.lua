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
    self._savename = "food_storage_"..faction:name() .. "_"
    return self
end


--v function(self: FOOD_MANAGER, region: CA_REGION) --> boolean
function food_manager.does_region_have_food_storage(self, region)
    if region:owning_faction():name() ~= self._factionName then
        return false
    end
    for building, quantity in pairs(food_manager._buildingFoodStorageCap) do
        if region:building_exists(building) then
            return true
        end
    end
    return false
end



--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_being_drawn(self)
    return cm:get_saved_value(self._savename.."_current_draw") or 0
end

--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_in_storage(self)
    return cm:get_saved_value(self._savename.."_current_stores") or 0
end

--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_store_cap(self)
    return cm:get_saved_value(self._savename.."_storage_cap") or CONST.food_storage_cap_base
end

--v function(self: FOOD_MANAGER, draw: number)
function food_manager.set_food_draw(self, draw)
    local old_draw = self:food_being_drawn()
    draw = dev.mround(dev.clamp(draw, 0, self:food_in_storage()), 5)
    if draw == old_draw then
        return
    end
    self:log("Changing the current food draw for ["..self._factionName.."] from ["..old_draw.."] to ["..draw.."]")
    if old_draw > 0 then
        cm:remove_effect_bundle(CONST.food_storage_bundle..tostring(old_draw), self._factionName)
    end
    if draw > 0 then
        cm:apply_effect_bundle(CONST.food_storage_bundle..tostring(draw), self._factionName, 0)
    end
    cm:set_saved_value(self._savename.."_current_draw", draw)
end

--v function(self: FOOD_MANAGER, stores: number)
function food_manager.set_food_in_storage(self, stores)
    local stores = dev.clamp(stores, 0, self:food_store_cap())
    cm:set_saved_value(self._savename.."_current_stores", stores)
end

--v function(self: FOOD_MANAGER, storage_cap: number)
function food_manager.set_storage_cap(self, storage_cap)
    local storage_cap = dev.mround(dev.clamp(storage_cap, 0, 2000), 5)
    cm:set_saved_value(self._savename.."_storage_cap", storage_cap)
end

--v function(self: FOOD_MANAGER, old_stores: number, cap: number, quantity: number) --> number
function food_manager.calculate_potential_food_change(self, old_stores, cap, quantity)
    local old_val = old_stores
    local new_val = old_val + quantity
    --clamp the value to the current cap
    new_val = dev.clamp(new_val)
    return (new_val - old_val)
end



--v function(self: FOOD_MANAGER)
function food_manager.update_food_storage(self)
    local faction = dev.get_faction(self._factionName)
    self:log("Updating food storage for ["..self._factionName.."] ")
    --first update our cap
    local cap = CONST.food_storage_cap_base --:number
    for i = 0, faction:region_list():num_items() - 1 do
        local region = faction:region_list():item_at(i)
        for building, quantity in pairs(food_manager._buildingFoodStorageCap) do
            if region:building_exists(building) then
                cap = cap + quantity
            end
        end
    end
    --now calculate our change
    local drawn = self:food_being_drawn()
    local stored = self:food_in_storage()
    local total_food = faction:total_food()
    if not is_number(total_food) then
        dev.log("WARNING: total food returned a non-number type! This usually ends badly", "ERR")
        return
    end
    local food_actual = total_food - drawn -- drawn is 0 when nothing is drawn
    local new_stored = stored - drawn
    if food_actual > 0 then
        new_stored = new_stored + food_actual --only factor this if its positive.
    end
    local new_stored = dev.clamp(new_stored, 0, cap)
    local new_draw =  -1*food_actual
    self:set_storage_cap(cap)
    self:set_food_in_storage(new_stored)
    self:set_food_draw(new_draw)
end

--v function(self: FOOD_MANAGER, quantity: number)
function food_manager.mod_food_storage(self, quantity)
    local drawn = self:food_being_drawn()
    local stored = self:food_in_storage()
    local cap = self:food_store_cap()
    local new_stored = dev.clamp((stored+quantity), 0, cap)
    self:set_food_in_storage(new_stored)
    if drawn > new_stored then
        self:set_food_draw(drawn) --will autoclamp down to a value within range
    end
end

return {
    --creation
    new = food_manager.new,
    --content API
    add_food_storage_cap_effect_to_building =  food_manager.add_food_storage_cap_effect_to_building
}