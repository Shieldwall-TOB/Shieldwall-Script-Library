local pop_manager = {} --# assume pop_manager: POP_MANAGER
--v method(t: any)
function pop_manager:log(t)
    dev.log(tostring(t), "POP")
end


--//castes
pop_manager.available_castes = {
    "lord",
    "serf",
    "monk",
    "foreign"
}--:vector<POP_CASTE>


--// Building Pop Contributions add pop growth via a building effect
pop_manager._buildingPopGrowth = {} --:map<string, map<POP_CASTE, number>>
--v function(building: string, pop_caste: string, quantity: number)
function pop_manager.add_building_pop_growth(building, pop_caste, quantity)
    if pop_manager._buildingPopGrowth[building] == nil then
        pop_manager._buildingPopGrowth[building] = {}
    end
    --# assume pop_caste: POP_CASTE
    pop_manager._buildingPopGrowth[building][pop_caste] = quantity
end

--// Population absolute caps
pop_manager._absolutePopCaps = {} --:map<POP_CASTE, number>
--v function(pop_caste: POP_CASTE, max_pop:number)
function pop_manager.set_absolute_pop_cap_for_caste(pop_caste, max_pop)
    pop_manager._absolutePopCaps[pop_caste] = max_pop
end
    
--// Exclude populations from "natural" factors like births and deaths
pop_manager._popCastesNaturalGrowthExclusions = {} --:map<POP_CASTE, boolean>
--v function(pop_caste: POP_CASTE)
function pop_manager.exclude_pop_caste_from_natural_factors(pop_caste)
    pop_manager._popCastesNaturalGrowthExclusions[pop_caste] = true
end

--// Set the "base" value of each population. This impacts how quickly recruiting units drains it. 
pop_manager._popBaseValues = {}--:map<POP_CASTE, number>
--v function(pop_caste: POP_CASTE, base: number)
function pop_manager.set_base_value_for_pop(pop_caste, base)
    pop_manager._popBaseValues[pop_caste] = base
end

--// sets the size of each unit according to their unit key
pop_manager._unitPopSizes = {} --:map<string, number>
pop_manager._unitCastes = {} --:map<string, POP_CASTE>
--v function(unit: string, caste: POP_CASTE, num_men: number)
function pop_manager.set_unit_man_count_and_caste_for_population(unit, caste, num_men)
    pop_manager._unitPopSizes[unit] = num_men
    pop_manager._unitCastes[unit] = caste
end



--v function(faction_detail: FACTION_DETAIL, caste_key: POP_CASTE) --> POP_MANAGER
function pop_manager.new(faction_detail, caste_key)
    local self = {}
    setmetatable(self, {
        __index = pop_manager,
        __tostring = function() return "POP_MANAGER" end
    })--# assume self: POP_MANAGER
    self._canModify = false --:boolean
    self._factionDetail = faction_detail
    self._caste = caste_key
    self._saveName = "pop_manager_"..faction_detail:name() .. caste_key
    self._populations = {} --:map<string, number>
    self._bundleLocations = {} --:map<string, string>
    self._bundlesOut = {} --:map<string, string>
    --maps the province name to the percentage of cap present there.
    self._regionsForBaseValue = {} --:vector<string>
    self._UIGrowthFactors = {} --:map<string, map<string, number>>
    self._armyCache = {} --:map<string, map<string, number>>

    return self
end

------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: POP_MANAGER)
function pop_manager.save(self)
    for cqi_as_string, army_cache in pairs(self._armyCache) do
        local savestring = "" --:string
            
        for key,value in pairs(army_cache) do
            savestring = savestring..key..","..value..",;"
        end
        cm:set_saved_value(self._saveName.."_army_"..cqi_as_string, savestring)
    end
    for province, pop in pairs(self._populations) do
        cm:set_saved_value(self._saveName..province, pop)
    end
end


--v function(self: POP_MANAGER, province: string, size: number?)
function pop_manager.apply_unrest(self, province, size)
    if not size then
        size = 10
    end--# assume size: number
    if self._populations[province] < size then
        self._populations[province] = 0
        return
    end
    self._populations[province] = self._populations[province] - size
end

--v function(self: POP_MANAGER) --> string
function pop_manager.caste_key(self)
    return self._caste
end

--v function(self: POP_MANAGER, province: string) --> number
function pop_manager.display_value_in_province(self, province)
    if self._populations[province] == nil then
        local load = cm:get_saved_value(self._saveName..province)
        if load then
            --# assume load: number
            self._populations[province] = load
        end
    end
    return math.ceil(((self._populations[province] or 0)*(pop_manager._popBaseValues[self._caste]))/100)
end

--v function(self: POP_MANAGER, province_key: string) --> boolean
function pop_manager.has_province(self, province_key)
    return not not self._populations[province_key]
end


--v function(self: POP_MANAGER)
function pop_manager.apply_bundles(self)
    local faction = dev.get_faction(self._factionDetail:name())
    local interval = 25
    if not faction:is_human() then
        interval = 100
    end

    for province_key, population in pairs(self._populations) do
        local region_array = self._factionDetail._model._provinceToContainedRegions[province_key]
        --find the bundle key
        local prefix = "shield_pop_bundle_"
        local bundle_number = 0
        if population > 0 then
            local bundle_level = math.floor(population/interval)
            if bundle_level == 0 then
                bundle_level = 1
            end
            bundle_number = interval*bundle_level
        end
        local pop_bundle = prefix .. self._caste .. "_" .. bundle_number
        --find the capital and apply it
        local capital = self._factionDetail._model._provinceToCapitalRegion[province_key]
        if dev.get_region(capital):owning_faction():name() == faction:name() then
            --if we have an old bundle and we still own that region, remove it.
            local old_region = cm:get_saved_value(self._saveName..province_key.."_bundle_region")
            local old_bundle = cm:get_saved_value(self._saveName..province_key.."_bundle_number")
            if old_bundle and old_region then
                cm:remove_effect_bundle_from_region(prefix .. self._caste .. "_" .. old_bundle, old_region)
            end
            cm:apply_effect_bundle_to_region(pop_bundle, capital, 0)
            cm:set_saved_value(self._saveName..province_key.."_bundle_region", capital)
            cm:set_saved_value(self._saveName..province_key.."_bundle_number", bundle_number)
            --we own the capital
        else
            for j = 1, #region_array do
                local region = region_array[j]
                if dev.get_region(region):owning_faction():name() == faction:name() then
                    --if we have an old bundle and we still own that region, remove it.
                    local old_region = cm:get_saved_value(self._saveName..province_key.."_bundle_region")
                    local old_bundle = cm:get_saved_value(self._saveName..province_key.."_bundle_number")
                    if old_bundle and old_region then
                        cm:remove_effect_bundle_from_region(prefix .. self._caste .. "_" .. old_bundle, old_region)
                    end
                    cm:apply_effect_bundle_to_region(pop_bundle, region, 0)
                    cm:set_saved_value(self._saveName..province_key.."_bundle_region", region)
                    cm:set_saved_value(self._saveName..province_key.."_bundle_number", bundle_number)
                    break --only apply once
                end
            end
        end
    end
end




--v function(self: POP_MANAGER, province_key: string, quantity: number, UICause: string)
function pop_manager.modify_population(self, province_key, quantity, UICause)
    if not self:has_province(province_key) then
        self:log("Called modify population for unitialized province ["..province_key.."]")
        return
    end
    if not is_number(quantity) then
        self:log("Called modify population with quantity that is not a number; provided UICause was ["..tostring(UICause).."] !")
        self:log(debug.traceback())
        return
    end
    if not self._canModify then
        self:log("Called modify population for a province with canModify set to false!")
        return
    end
    local delta = math.floor(quantity+0.5) 
    self:log("Modifying population in province ["..province_key.."] by quantity ["..delta.."] for reason ["..tostring(UICause).."] ")
    --# assume delta: number
    -- i do not like how kailua treats "int"
    if delta > 0 and pop_manager._absolutePopCaps[self._caste] and self._populations[province_key] + delta > pop_manager._absolutePopCaps[self._caste] then
        --if the pop after change is going to be more than the absolute cap, the delta is the difference between the cap and the current pop.
        --if pop is maxed, this is 0.
        delta = pop_manager._absolutePopCaps[self._caste] - self._populations[province_key]
    elseif self._populations[province_key] + delta < 0 then
        --if the pop after change is going to be less than 0, the delta is the negative of current pop as you are losing it all!
        delta = -1* self._populations[province_key] 
    end
    if delta ~= 0 then --only apply changes if they change anything.
        if not is_string(UICause) then
            UICause = "Other"
        end
        self._UIGrowthFactors[province_key] = self._UIGrowthFactors[province_key] or {}
        self._UIGrowthFactors[province_key][UICause] = self._UIGrowthFactors[province_key][UICause] or 0
        self._UIGrowthFactors[province_key][UICause] = self._UIGrowthFactors[province_key][UICause] + delta
        self._populations[province_key] = self._populations[province_key] + delta
    end
end

--v function(self: POP_MANAGER, character: CA_CHAR) --> map<string, number>
function pop_manager.generate_cache_entry_for_force(self, character)
    if not dev.is_char_normal_general(character) then
        return {}
    end
    local force = character:military_force()
    local cache_entry = {} --:map<string, number>
    for i=0,force:unit_list():num_items()-1 do
        local unit_key = force:unit_list():item_at(i):unit_key()
        if pop_manager._unitCastes[unit_key] == self._caste then
            cache_entry[unit_key] = cache_entry[unit_key] or 0
            cache_entry[unit_key] = cache_entry[unit_key] + force:unit_list():item_at(i):percentage_proportion_of_full_strength()
        end
    end
    return cache_entry
end

--v function(self: POP_MANAGER, faction_obj: CA_FACTION) --> (number, string)
function pop_manager.get_food_effect(self, faction_obj)
    local total_food = faction_obj:total_food()
    if not is_number(total_food) then
        self:log("WARNING: total food just returned a non-number type! This usually ends badly!")
        return 0, "Nothing"
    end
    local thresholds_to_returns = {
        [-150] = {-8, "Famine"}, --min food, famine
        [-50] = {-4, "Food Shortages"},
        [0] = {-2, "Food Shortages"},
        [100] = {1, "Food Surplus"}, --default level
        [250] = {3, "Food Surplus"}
    }--:map<number, {number, string}>
    local thresholds = {-150, -50, 0, 100, 250} --:vector<number>
    for n = 1, #thresholds do
        if total_food < thresholds_to_returns[thresholds[n]][1] then
            return thresholds_to_returns[thresholds[n]][1], thresholds_to_returns[thresholds[n]][2]
        end
    end
    --if we are above 250 food
    return 5, "Food Surplus"
end

--v function(self: POP_MANAGER, province_key: string)
function pop_manager.apply_growth_for_province(self, province_key)
    local model = self._factionDetail._model
    local current_pop = self._populations[province_key]
    local faction = dev.get_faction(self._factionDetail:name())

    --if our population respects stuff like food and births, then we should do those.
    if not pop_manager._popCastesNaturalGrowthExclusions[self._caste] then
        local faction_food_factor, food_factor_string = self:get_food_effect(faction)
        local nat_growth_factor = CONST.pop_natural_growth
        self:modify_population(province_key, faction_food_factor, food_factor_string)
        self:modify_population(province_key, nat_growth_factor, "Births and Immigration")
        local deaths_factor = -1 * (current_pop/15)
        self:modify_population(province_key, deaths_factor, "Deaths and Emigration")
    end
    --get all the regions in the province out of the model.
    local region_array = model._provinceToContainedRegions[province_key]
    for i = 1, #region_array do
        local current_region = dev.get_region(region_array[i])
        local slot_list = current_region:slot_list()
        for j = 0, slot_list:num_items() - 1 do
            local slot = slot_list:item_at(j)
            if slot:has_building() then
                local building = slot:building():name()
                if pop_manager._buildingPopGrowth[building] and is_number(pop_manager._buildingPopGrowth[building][self._caste]) then
                    self:modify_population(province_key, pop_manager._buildingPopGrowth[building][self._caste], "Buildings")
                end
            end
        end
    end
    --figure out if we need to reduce growth for overcrowding
    if not pop_manager._popCastesNaturalGrowthExclusions[self._caste] then
        local overcrowding_factor = 0 --:number
        if current_pop > 150 then 
            overcrowding_factor = (current_pop-150)/15
        end
        local total_growth = self._populations[province_key] - current_pop
        if total_growth > CONST.pop_max_growth_before_reduction and current_pop > 75 then
            local overage_factor = current_pop/200
            if overage_factor > 0.75 then
                overage_factor = 0.75
            end
            local overage = overage_factor*(total_growth - CONST.pop_max_growth_before_reduction)

            overcrowding_factor = -1*(overcrowding_factor + overage)
        end
        self:modify_population(province_key, overcrowding_factor, "Overcrowding")
    end
end

--v function(self: POP_MANAGER)
function pop_manager.ai_faction_pop_update(self)
   --[[ local faction = dev.get_faction(self._factionDetail:name())
    local region_list = faction:region_list()
    for i = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(i)
        local province_key = current_region:province_name()
        if self._populations[province_key] == nil then
            local load = cm:get_saved_value(self._saveName..province_key.."_bundle_number")
            if load then
                --# assume load: number
                self._populations[province_key] = load
            else
                self._populations[province_key] = 80
            end
        end
        self._populations[province_key] = self._populations[province_key] + 3
    end
    self:apply_bundles()--]]
end

--v function(self: POP_MANAGER)
function pop_manager.update_population(self)
    local faction = dev.get_faction(self._factionDetail:name())
    self:log("Updating ["..self._caste.."] populations for faction ["..faction:name().."]")
    self._canModify = true
    if not faction:is_human() then
        self:ai_faction_pop_update()
        self._canModify = false
        return
    end
    self._UIGrowthFactors = {}
    --first, loop through all regions this faction owns.
    local region_list = faction:region_list()
    for i = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(i)
        local province_key = current_region:province_name()
        --if we don't have that province, add it to our base growth list.
        if not self:has_province(province_key) then
            --first check if we can load it
            local load = cm:get_saved_value(self._saveName..province_key)
            if load then
                --# assume load: number
                self._populations[province_key] = load
            else
                table.insert(self._regionsForBaseValue, current_region:name())
            end
        end
    end
    for i = 1, #self._regionsForBaseValue do
        local current_region = dev.get_region(self._regionsForBaseValue[i])
        local province_key = current_region:province_name()
        local slot_list = current_region:slot_list()
        local base = 90 + cm:random_number(20)
        local growth_mult = 1
        if pop_manager._popCastesNaturalGrowthExclusions[self._caste] then
            base = 0
            growth_mult = 24
        end
        self._populations[province_key] = self._populations[province_key] or base
        for j = 0, slot_list:num_items() - 1 do
            local slot = slot_list:item_at(j)
            if slot:has_building() then
                local building = slot:building():name()
                if pop_manager._buildingPopGrowth[building] and pop_manager._buildingPopGrowth[building][self._caste] then
                    self._populations[province_key] = self._populations[province_key] + (pop_manager._buildingPopGrowth[building][self._caste]*growth_mult)
                end
            end
        end
    end
    self._regionsForBaseValue = {}
    for province_key, population_quantity in pairs(self._populations) do
        self:apply_growth_for_province(province_key)
    end
    --costs come last, otherwise the player could use them to offset growth reductions.
    for i = 0, faction:character_list():num_items() - 1 do
        local character = faction:character_list():item_at(i)
        local cqi_as_string = tostring(character:command_queue_index())
        local should_check = not not self._armyCache[cqi_as_string] --:boolean
        if not should_check then
            local load = cm:get_saved_value(self._saveName.."_army_"..cqi_as_string)
            if load then
                --v [NO_CHECK] function(savestring: string) --> map<string, number>
                local function get_saved_pairs(savestring)
                    local tab = {}
                    if savestring ~= "" then
                        local first_split = dev.split_string(savestring, ";");
                        for i = 1, #first_split do
                            local second_split = dev.split_string(first_split[i], ",");
                            tab[second_split[1]] = second_split[2];
                        end
                    end
                    return tab
                end
                self._armyCache[cqi_as_string] = get_saved_pairs(load)
            end
        end
        if should_check and dev.is_char_normal_general(character) and (not character:region():is_null_interface()) then
            local fake_cache = self:generate_cache_entry_for_force(character)
            local cache_character = self._armyCache[cqi_as_string]
            for key, value in pairs(fake_cache) do
                if cache_character[key] then
                    local old_q = cache_character[key]
                    local new_q = fake_cache[key]
                    if new_q > old_q then
                        local replen_q = new_q - old_q --this is the percentage of a full unit of that type we've gained during the end turn.
                        local men_replen = -1* math.floor((pop_manager._unitPopSizes[key]*replen_q) / (pop_manager._popBaseValues[self._caste])+0.5)
                        --this converts it to a % of the cap
                        --example numbers, replen 100% of a 100 man peasant unit, -1*(100*100/400) = -25%
                        self:modify_population(character:region():province_name(), men_replen, "Recruitment")
                    end
                end
            end
        end
    end

    self:apply_bundles()
    self._canModify = false
    self:save()
end

--v function(self: POP_MANAGER)
function pop_manager.cache_replenishment(self)
    local faction = dev.get_faction(self._factionDetail:name())
    for i = 0, faction:character_list():num_items() - 1 do
        local character = faction:character_list():item_at(i)
        if dev.is_char_normal_general(character) then
            self._armyCache[tostring(character:command_queue_index())] = self:generate_cache_entry_for_force(character)
        end
    end
end





return {
    --castes
    available_castes = pop_manager.available_castes,
    --constructor
    new = pop_manager.new,
    --content
    add_building_pop_growth = pop_manager.add_building_pop_growth,
    set_absolute_pop_cap_for_caste = pop_manager.set_absolute_pop_cap_for_caste,
    set_base_value_for_pop = pop_manager.set_base_value_for_pop,
    exclude_pop_caste_from_natural_factors = pop_manager.exclude_pop_caste_from_natural_factors,
    set_unit_man_count_and_caste_for_population = pop_manager.set_unit_man_count_and_caste_for_population
}