local pkm = _G.pkm
--v function(region: CA_REGION, character: CA_CHAR)
local function onRegionOccupied(region, character)
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    local new_province = pkm:get_faction(character:faction():name()):get_province(region:province_name())
    reg_detail:get_ownership_tracker():transfer_region(character:faction():name())
    old_province:remove_region(region:name(), new_province)

    --population transfer
    local castes = {"lord", "serf", "monk", "foreign"} --:vector<string>
    local old_popm = old_province:get_population_manager()
    --cache the existing populations of the province that just recieved a region
    local transfer_cache_new_existing = {} --:map<string, number>
    if new_province:has_population() then
        for caste, cap in pairs(new_province:get_population_manager()._popCaps) do
            transfer_cache_new_existing[caste] = cap
        end
    else --no pop manager exists in the province.
        for i = 1, #castes do
            transfer_cache_new_existing[castes[i]] = 0
        end
    end
    --this will define a pop manager if one didn't exist above.
    local new_popm = new_province:get_population_manager()
    --get the capacity available on the new province.
    new_popm:evaluate_pop_cap() 
    for caste, capacity in pairs(old_popm._popCaps) do
        local captured_province_new_pop = new_popm._popCaps[caste] - transfer_cache_new_existing[caste]
        local new_cap = capacity - captured_province_new_pop
        local change_mult = 1 - new_cap/capacity
        --the capacity has decreased by change_mult in the old province.
        local old_province_current_pop = old_popm:get_pop_of_caste(caste)
        local pop_lost = old_province_current_pop - math.floor((old_province_current_pop * change_mult)+0.5)
        old_popm:modify_population(caste, pop_lost*-1, "Lost Settlements", false)
        --only gain 80% of the old pop, some are presumably lost in conquest.
        new_popm:modify_population(caste, math.floor(pop_lost*0.80), "Conquered Subjects", false)
    end
    --tell the old province to update its capacity.
    old_popm:evaluate_pop_cap()
end




cm:add_listener(
    "EBSRegionOccupiedEvent",
    "GarrisonOccupiedEvent",
    function(context)
        return (not string.find(context:character():faction():name(), "rebels"))
    end,
    function(context)
        onRegionOccupied(context:garrison_residence():region(), context:character())
    end,
    true
)


--v function(region: CA_REGION)
local function onRegionOccupiedByRebels(region)
    --[[
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    reg_detail:get_ownership_tracker():transfer_region("rebels")
    old_province:remove_region(region:name())
    --]]
end



cm:add_listener(
    "EBSRegionOccupiedEventRebels",
    "GarrisonOccupiedEvent",
    function(context)
        return (context:character():faction():name() == "rebels")
    end,
    function(context)
        --onRegionOccupiedByRebels(context:garrison_residence():region())
    end,
    true
)