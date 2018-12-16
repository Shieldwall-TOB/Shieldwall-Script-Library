--this subobject handles the population conerns of it's parent object. 
local pop_manager = {} --# assume pop_manager: POP_MANAGER
--v method(text: any)
function pop_manager:log(text)
    dev.log(tostring(text), "POP")
end

-------------------------
-----STATIC CONTENT------
-------------------------

--// Building Cap Contributions essentially help set how large the settlement is supposed to be.
pop_manager._buildingPopCapContributions = {} --:map<string, map<POP_CASTE, number>>
--v function(building: string, pop_caste: POP_CASTE, quantity: number)
function pop_manager.add_building_pop_cap_contribution(building, pop_caste, quantity)
    if pop_manager._buildingPopCapContributions[building] == nil then
        pop_manager._buildingPopCapContributions[building] = {}
    end
    pop_manager._buildingPopCapContributions[building][pop_caste] = quantity
end

--// The Food Effect function impacts population growth numbers based upon the faction's values. 
pop_manager._foodEffectFunctions = {} --:map<POP_CASTE, (function(quantity_in: number, food_manager: FOOD_MANAGER?) --> number)>
--v function(caste: POP_CASTE, food_func: (function(quantity_in: number, food_manager: FOOD_MANAGER?) --> number))
function pop_manager.add_food_effect_function(caste, food_func)
    pop_manager._foodEffectFunctions[caste] = food_func
end

--// Bundle change intervals impact how often the bundle for a population group requires changing. 
pop_manager._popCasteBundleChangeIntervals = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, interval: number)
function pop_manager.set_caste_change_interval(caste, interval)
    pop_manager._popCasteBundleChangeIntervals[caste] = interval
end

--// Immigration scalar impacts how much immigration can occur to fill empty capacity
pop_manager._immigrationEffectStrengths = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, strength: number)
function pop_manager.set_immigration_strength_for_caste(caste, strength)
    pop_manager._immigrationEffectStrengths[caste] = strength
end

--// Immigration activity limit impacts the portion of your pop that has to be full before immigration will stop
pop_manager._immigrationActivityLimit = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, limit: number)
function pop_manager.set_immigration_activity_limit_for_caste(caste, limit)
    pop_manager._immigrationEffectStrengths[caste] = limit
end


--// Overcrowding Scalar impacts how harsh the overcrowding penalty. 
pop_manager.overcrowdingEffectStrength = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, strength: number)
function pop_manager.set_overcrowding_strength_for_caste(caste, strength)
    pop_manager.overcrowdingEffectStrength[caste] = strength
end

--// Overcrowding activity limit sets the percentage of pop you have to overstep before overcrowding begins.
pop_manager._overcrowdingStartPercentage = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, limit: number)
function pop_manager.set_overcrowding_lower_limit_for_caste(caste, limit)
    pop_manager._overcrowdingStartPercentage[caste] = limit
end

-- // Sets the minimum positive pop growth for a population type
pop_manager._minimumPosGrowthValues = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, minimum: number)
function pop_manager.set_mimimum_pos_growth_for_caste(caste, minimum)
    pop_manager._minimumPosGrowthValues[caste] = minimum
end

--// Sets the natural percentage based growth rate for a population per SEASON (NOTE: ONLY TRIGGERS ON SEASON START!)
pop_manager._naturalGrowthRates = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, rate: number)
function pop_manager.set_natural_growth_for_caste(caste, rate)
    pop_manager._naturalGrowthRates[caste] = rate
end

--// Sets the population cost of a unit to create
pop_manager._unitPopulationCosts = {} --:map<string, number>
pop_manager._unitPopulationCastes = {} --:map<string, POP_CASTE>
--v function(unit: string, caste: POP_CASTE, size: number)
function pop_manager.set_population_cost_for_unit(unit, caste, size)
    pop_manager._unitPopulationCosts[unit] = size
    pop_manager._unitPopulationCastes[unit] = caste
end


----------------------------
----OBJECT CONSTRUCTOR------
----------------------------
--v function(province: PROVINCE_DETAIL) --> POP_MANAGER
function pop_manager.new(province)
    local self = {}
    setmetatable(self, {
        __index = pop_manager,
        __tostring = function() return "SHIELDWALL_POPULATION_MANAGER" end
    })--# assume self: POP_MANAGER

    --v method() --> POP_MANAGER
    function self:prototype()
        return pop_manager
    end

    self._provinceDetail = province
    self._provinceName = province:name()
    self._populations = {} --:map<POP_CASTE, number>
    self._currentPopBundles = {} --:map<POP_CASTE, number>
    self._popCaps = {} --:map<POP_CASTE, number>
    self._UIPopulationChanges = {} --:map<POP_CASTE, map<string, number>>

    return self
end

---------------------------
------NIL SAFE QUERIES-----
--------------------------- 
--v function(self: POP_MANAGER) --> PROVINCE_DETAIL
function pop_manager.province_detail(self)
    return self._provinceDetail
end

--v function(self: POP_MANAGER, caste: POP_CASTE) --> number
function pop_manager.get_pop_of_caste(self, caste)
    if self._populations[caste] == nil then
        self._populations[caste] = 0
    end
    return self._populations[caste]
end

--v function(self: POP_MANAGER, caste: POP_CASTE) --> number
function pop_manager.get_pop_cap_for_caste(self, caste)
    if self._popCaps[caste] == nil then
        self._popCaps[caste] = 0
    end
    return self._popCaps[caste]
end

--v function(self: POP_MANAGER, caste: POP_CASTE) --> number
function pop_manager.get_pop_cap_for_caste(self, caste)
    if self._popCaps[caste] == nil then
        self._popCaps[caste] = 0
    end
    return self._popCaps[caste]
end

--v function(self: POP_MANAGER, caste: POP_CASTE) --> number
function pop_manager.get_pop_bundle_for_caste(self, caste)
    if self._currentPopBundles[caste] == nil then
        self._currentPopBundles[caste] = 0
    end
    return self._currentPopBundles[caste]
end


------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(province: PROVINCE_DETAIL, savetable: table) --> POP_MANAGER
function pop_manager.load(province, savetable)
    local self = pop_manager.new(province)
    dev.load(savetable, self, "_populations", "_currentPopBundles", "_popCaps", "_UIPopulationChanges")
    return self
end

--v function(self: POP_MANAGER) --> table
function pop_manager.save(self)
    return dev.save(self, "_populations", "_currentPopBundles", "_popCaps", "_UIPopulationChanges")
end
    

-----------------------------------
----STATE CHANGING FUNCTIONS-------
-----------------------------------

--v function(self: POP_MANAGER, caste: POP_CASTE, quantity: number, UICause: string)
function pop_manager.modify_population(self, caste, quantity, UICause)
    --get cap, old pop value, and change value on vars
    local old_value = self:get_pop_of_caste(caste)
    local cap_value = self:get_pop_cap_for_caste(caste)
    local change_value = quantity
    self:log("Processing a population change in ["..self._provinceName.."] for caste ["..tostring(caste).."] of quantity ["..quantity.."] with UI Cause ["..UICause.."]")
    --add the new value
    local new_value = old_value + change_value
    --clamp the new value to the cap value, changing the difference to be accurate. 
    if new_value > cap_value then
        local diff = new_value - cap_value
        change_value = change_value - diff
        new_value = cap_value
    elseif new_value < 0 then
        change_value = old_value*(-1)
        new_value = 0
    end
    --register the change in the UI Hash for display. 
    if self._UIPopulationChanges[caste] == nil then
        self._UIPopulationChanges[caste] = {}
    end
    if self._UIPopulationChanges[caste][UICause] == nil then
        self._UIPopulationChanges[caste][UICause] = 0
    end
    self._UIPopulationChanges[caste][UICause] = self._UIPopulationChanges[caste][UICause] + change_value
    --make the change.
    self._populations[caste] = new_value
    --check where our current bundle is
    local bundle_thresholds --:number
    if self:prototype()._popCasteBundleChangeIntervals[caste] then
        bundle_thresholds = self:prototype()._popCasteBundleChangeIntervals[caste]
    else
        self:log("WARNING: Could not calculate the bundle effects of a change in population!")
        self:log("\tNo caste bundle change interval is set for this caste")
        return
    end
    local old_bundle = self:get_pop_bundle_for_caste(caste)
    if old_bundle == 0 and (quantity <= 0) then
        --no change in the bundle because we are at 0 and the change is negative!
        self:log("Completed population change with no change in the bundle!")
        return
    end
    local cap_difference = (old_value - old_bundle) + change_value
    if (cap_difference >= bundle_thresholds) then
        --we have increased our bundle!
        local new_bundle = old_bundle + bundle_thresholds
    elseif (cap_difference < 0) then
        --we have decreased our bundle!
        local new_bundle = old_bundle - bundle_thresholds
        -- >>>>>>remove old bundle
        -- >>>>>apply new bundle
        self._currentPopBundles[caste] = new_bundle
    else
        --we haven't sufficiently increased or decreased to change anything!
        self:log("Completed population change with no change in the bundle!")
    end
end




return {
    --Creation
    new = pop_manager.new,
    load = pop_manager.load,
    --Content API
    add_building_pop_cap_contribution = pop_manager.add_building_pop_cap_contribution,
    add_food_effect_function = pop_manager.add_food_effect_function,
    set_caste_change_interval = pop_manager.set_caste_change_interval,
    set_immigration_strength_for_caste = pop_manager.set_immigration_strength_for_caste,
    set_immigration_activity_limit_for_caste = pop_manager.set_immigration_activity_limit_for_caste,
    set_mimimum_pos_growth_for_caste = pop_manager.set_mimimum_pos_growth_for_caste,
    set_natural_growth_for_caste = pop_manager.set_natural_growth_for_caste,
    set_population_cost_for_unit = pop_manager.set_population_cost_for_unit,
    set_overcrowding_strength_for_caste = pop_manager.set_overcrowding_strength_for_caste,
    set_overcrowding_lower_limit_for_caste = pop_manager.set_overcrowding_lower_limit_for_caste
}