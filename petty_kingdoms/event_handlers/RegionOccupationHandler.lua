local pkm = _G.pkm
--v function(region: CA_REGION, character: CA_CHAR)
local function onRegionOccupied(region, character)
    dev.log("Faction: ["..character:faction():name().."] captured region ["..region:name().."] ","EH")
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    local new_province = pkm:get_faction(character:faction():name()):get_province(region:province_name())
    --reg_detail:get_ownership_tracker():transfer_region(character:faction():name())
    old_province:remove_region(region:name(), new_province)
    --population transfer
    local castes = {"lord", "serf", "monk", "foreign"} --:vector<POP_CASTE>
    local old_popm = old_province:get_population_manager()
    local new_popm = new_province:get_population_manager()

    --these gets will define any pop managers that don't exist.
    --don't code anything that drops this out of this func until they have capacity initialized.
    local region_pop_cap_cache = {} --:map<string, number>
    for i = 1, #castes do
        region_pop_cap_cache[castes[i]] = new_popm:get_pop_cap_of_region_for_caste(reg_detail, castes[i])
    end -- this caches the value of the region in terms of caps.
    --get the capacity available on the new province.
    new_popm:evaluate_pop_cap() 
    for caste, capacity in pairs(old_popm._popCaps) do
        local region_cap = region_pop_cap_cache[caste]
        local change_mult --:number
        if capacity > 0 and region_cap > 0 then
            change_mult = 1 - (capacity - region_cap)/capacity
        else
            change_mult = 1
        end
        --the capacity has decreased by change_mult in the old province.
        if change_mult ~= 0 then
            local old_province_current_pop = old_popm:get_pop_of_caste(caste)
            local pop_lost = old_province_current_pop - math.floor((old_province_current_pop * change_mult)+0.5) 
            old_popm:modify_population(caste, pop_lost*-1, "Lost Settlements", true)
            --only gain 80% of the old pop, some are presumably lost in conquest.
            new_popm:modify_population(caste, math.floor(pop_lost*0.80), "Conquered Subjects", true)
        end
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