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
--v function(building: string, pop_caste: string, quantity: number)
function pop_manager.add_building_pop_cap_contribution(building, pop_caste, quantity)
    if pop_manager._buildingPopCapContributions[building] == nil then
        pop_manager._buildingPopCapContributions[building] = {}
    end
    --# assume pop_caste: POP_CASTE
    pop_manager._buildingPopCapContributions[building][pop_caste] = quantity
end

--// The Food Effect function impacts population growth numbers based upon the faction's values. 
pop_manager._foodEffectFunctions = {} --:map<POP_CASTE, (function(quantity_in: number, food_manager: FOOD_MANAGER?, is_end_turn: boolean?) --> number)>
--v function(caste: POP_CASTE, food_func: (function(quantity_in: number, food_manager: FOOD_MANAGER?, is_end_turn: boolean?) --> number))
function pop_manager.add_food_effect_function(caste, food_func)
    pop_manager._foodEffectFunctions[caste] = food_func
end

--// Bundle change intervals impact how often the bundle for a population group requires changing. 
pop_manager._popCasteBundleChangeIntervals = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, interval: number)
function pop_manager.set_caste_change_interval(caste, interval)
    pop_manager._popCasteBundleChangeIntervals[caste] = interval
end

--// bundle maximum is the maximum quantity of population which gives a bundle for a given faction
pop_manager._popCasteBundleMaximums = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, max_bundle_quantity: number)
function pop_manager.set_caste_bundle_maximum(caste, max_bundle_quantity)
    pop_manager._popCasteBundleMaximums[caste] = max_bundle_quantity
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
pop_manager._overcrowdingEffectStrength = {} --:map<POP_CASTE, number>
--v function(caste: POP_CASTE, strength: number)
function pop_manager.set_overcrowding_strength_for_caste(caste, strength)
    pop_manager._overcrowdingEffectStrength[caste] = strength
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



-- // sets the threshold of population raw number for a caste before overcrowding is increased 
pop_manager._growthReductionThresholds = {} --:map<string, number>
--v function(caste: POP_CASTE, threshold: number)
function pop_manager.set_growth_reduction_threshold_for_caste(caste, threshold)
    pop_manager._growthReductionThresholds[caste] = threshold
end

--// sets the bonus to pop cap that factions get in their home province
pop_manager._homeRegionPopCaps = {} --:map<string, number>
--v function(caste: POP_CASTE, pop_cap: number)
function pop_manager.set_home_region_pop_cap_for_caste(caste, pop_cap)
    pop_manager._homeRegionPopCaps[caste] = pop_cap
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
------GENERIC METHODS------
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

--v function(self: POP_MANAGER, caste: POP_CASTE)
function pop_manager.update_population_bundle(self, caste)
    local bundle_threshold --:number
    local bundle_maximum --:number
    if pop_manager._popCasteBundleChangeIntervals[caste] and pop_manager._popCasteBundleMaximums[caste] then
        bundle_threshold = pop_manager._popCasteBundleChangeIntervals[caste]
        bundle_maximum = pop_manager._popCasteBundleMaximums[caste]
    else
        self:log("WARNING: Could not calculate the bundle effects of a change in population!")
        self:log("\t A caste bundle change interval or bundle maximum is missing for this caste")
        return
    end
    local old_bundle = self:get_pop_bundle_for_caste(caste) --get the old bundle
    local new_pop = self:get_pop_of_caste(caste) --get the new pop
    --see how many intervals they have exceeded, then multiple that by the interval quantity
    local new_bundle = (math.floor(new_pop/bundle_threshold)+1)*bundle_threshold 
    --clamp the value to the maximum bundle for this caste
    if new_bundle > bundle_maximum then
        new_bundle = bundle_maximum
    elseif (new_bundle < 0) or (new_pop == 0) then
        new_bundle = 0
    end
    if (new_bundle > old_bundle) then 
        --we have increased our bundle!
    elseif (new_bundle < old_bundle) then
        --we have decreased our bundle!
    else
        --our bundle has stayed the same
        if not self:province_detail():has_effect_bundle(CONST.pop_bundle_prefix .. caste .. "_".. tostring(old_bundle)) then
            self:province_detail():apply_effect_bundle(CONST.pop_bundle_prefix .. caste .. "_".. tostring(old_bundle))
        end
        return
    end
    -- >>>>>>remove old bundle
    if self:province_detail():has_effect_bundle(CONST.pop_bundle_prefix .. caste .. "_".. tostring(old_bundle)) then
        self:province_detail():remove_effect_bundle(CONST.pop_bundle_prefix .. caste .. "_".. tostring(old_bundle))
    end
    -- >>>>>apply new bundle
    self:province_detail():apply_effect_bundle(CONST.pop_bundle_prefix .. caste .. "_".. tostring(new_bundle))
    self._currentPopBundles[caste] = new_bundle
end

--v function(self: POP_MANAGER)
function pop_manager.reapply_all_pop_bundles(self)
    for caste_key, pop_bundle in pairs(self._currentPopBundles) do
        if not self:province_detail():has_effect_bundle(CONST.pop_bundle_prefix .. caste_key .. "_".. tostring(pop_bundle)) then
            self:province_detail():apply_effect_bundle(CONST.pop_bundle_prefix .. caste_key .. "_".. tostring(pop_bundle))
        end
    end
end

--v function(self: POP_MANAGER, caste: POP_CASTE, quantity: number, UICause: string, block_bundle_change: boolean?)
function pop_manager.modify_population(self, caste, quantity, UICause, block_bundle_change)
    local food_func = pop_manager._foodEffectFunctions[caste]
    if food_func then
        local food_manager = self:province_detail():faction_detail():get_food_manager()
        local food_func_result = food_func(quantity, food_manager)
        quantity = food_func_result
    end
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
    --skip the rest if we are told to.
    if block_bundle_change then
        self:log("Completed population change with no change in the bundle - change was blocked via arg")
        return
    end
    --check where our current bundle is
    local bundle_thresholds --:number
    if pop_manager._popCasteBundleChangeIntervals[caste] and pop_manager._popCasteBundleMaximums[caste] then
        bundle_thresholds = pop_manager._popCasteBundleChangeIntervals[caste]
    else
        self:log("WARNING: Could not calculate the bundle effects of a change in population!")
        self:log("\t A caste bundle change interval or bundle maximum is missing for this caste")
        return
    end
    local old_bundle = self:get_pop_bundle_for_caste(caste)
    if old_bundle == 0 and (quantity <= 0) then
        --no change in the bundle because we are at 0 and the change is negative!
        self:log("Completed population change with no change in the bundle!")
        return
    end
    if block_bundle_change then
        self:log("Completed population change with no change in the bundle - change was blocked via arg")
        return
    end
    self:update_population_bundle(caste)
end


--v function(self: POP_MANAGER)
function pop_manager.evaluate_pop_cap(self)
    for caste_key, pop_capacity in pairs(pop_manager._popCasteBundleChangeIntervals) do
        local regions = self:province_detail():regions()
        local cap = 0 --:number
        for region_key, region_detail in pairs(regions) do
            local buildings = region_detail:buildings()
            local is_capital = (dev.get_region(region_key) == region_key)
            if is_capital and pop_manager._homeRegionPopCaps[caste_key] then 
                cap = cap + pop_manager._homeRegionPopCaps[caste_key]
            end
            for building_key, _ in pairs(buildings) do
                local cap_contrib = pop_manager._buildingPopCapContributions[building_key]
                if cap_contrib and cap_contrib[caste_key] then
                    cap = cap + cap_contrib[caste_key]
                end
            end
        end
        local c_pop = self:get_pop_of_caste(caste_key)
        if (cap < c_pop) then
            self:modify_population(caste_key, c_pop - cap , "Lost Buildings")
        end
        self._popCaps[caste_key] = cap
    end
end


--v function(self: POP_MANAGER)
function pop_manager.evaluate_pop_growth(self)
    for caste_key, _ in pairs(self._popCaps) do
        self:evaluate_pop_cap()
        local pop = self:get_pop_of_caste(caste_key)
        local pop_cap = self:get_pop_cap_for_caste(caste_key)
        local growth = pop_manager._naturalGrowthRates[caste_key]
        local min_growth = pop_manager._minimumPosGrowthValues[caste_key]
        local growth_reducing_threshold = pop_manager._growthReductionThresholds[caste_key]
        local immigration = pop_manager._immigrationEffectStrengths[caste_key]
        local immigration_limit = pop_manager._immigrationActivityLimit[caste_key]
        local decay_strength = pop_manager._overcrowdingEffectStrength[caste_key]
        local decay_start_val = pop_manager._overcrowdingStartPercentage[caste_key]
        local food_func = pop_manager._foodEffectFunctions[caste_key]
        
        local pop_mods = {} --:map<string, number>
        local num_mods = 0
        --v function(ui_growth: string, growth_quantity: number)
        local function pop_mod(ui_growth, growth_quantity)
            pop_mods[ui_growth] = growth_quantity
            num_mods = num_mods + 1
        end

        --grows by growth% of pop
        if growth then
            if growth_reducing_threshold and pop > growth_reducing_threshold then
                growth = growth/2
            end
            local nat_growth = math.ceil(pop*growth) --:number
            if min_growth and nat_growth < min_growth then
                nat_growth = min_growth
            end
            pop_mod("Natural Growth", nat_growth)
        end

        --grows by the interger value of immigration bounded by 10% of pop cap. 
        if immigration and immigration_limit then
            if (pop/pop_cap) < immigration_limit then
                local immigration_quantity = math.ceil(pop_cap/10) --:number
                if immigration_quantity > immigration then
                    immigration_quantity = immigration
                end
                pop_mod("Immigration", immigration_quantity)
            end
        end

        --decays by the quantity of pop over the decay val * the decay strength
        if decay_strength and decay_start_val then
            if (pop/pop_cap) > decay_start_val then
                local decay_threshold = (pop_cap*decay_start_val)
                local decay_max = (pop - decay_threshold)
                local decay_val = math.ceil(-1*(decay_max * decay_strength))
                pop_mod("Squalor and Overcrowding", decay_val)
            end
        end
        --does whatever the food function does!
        if food_func then 
            local food_manager = self:province_detail():faction_detail():get_food_manager()
            local food_func_result = food_func(pop, food_manager, true)
            pop_mod("Food Supply", (-1*pop)+food_func_result) --this food func returns what it wants the overall pop to be. this converts that to a difference.
        end

        --runs all the stuff through the change function.
        for ui_cause, value in pairs(pop_mods) do
            self:modify_population(caste_key, math.ceil(value), ui_cause, (num_mods > 1))
            num_mods = num_mods - 1
        end
    end
end
    
--v function(self: POP_MANAGER)
function pop_manager.set_start_pos_pops(self)
    self:evaluate_pop_cap()
    for caste_key, pop_cap in pairs(self._popCaps) do
        local proportion = (54 + cm:random_number(18))/100
        local pop = math.ceil(pop_cap*proportion)
        self._populations[caste_key] = pop
        self:update_population_bundle(caste_key)
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
    set_caste_bundle_maximum = pop_manager.set_caste_bundle_maximum,
    set_immigration_strength_for_caste = pop_manager.set_immigration_strength_for_caste,
    set_immigration_activity_limit_for_caste = pop_manager.set_immigration_activity_limit_for_caste,
    set_mimimum_pos_growth_for_caste = pop_manager.set_mimimum_pos_growth_for_caste,
    set_natural_growth_for_caste = pop_manager.set_natural_growth_for_caste,
    set_overcrowding_strength_for_caste = pop_manager.set_overcrowding_strength_for_caste,
    set_overcrowding_lower_limit_for_caste = pop_manager.set_overcrowding_lower_limit_for_caste,
    set_growth_reduction_threshold_for_caste = pop_manager.set_growth_reduction_threshold_for_caste,
    set_home_region_pop_cap_for_caste = pop_manager.set_home_region_pop_cap_for_caste
}