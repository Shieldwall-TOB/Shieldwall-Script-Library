local pm = _G.pm
local pkm = _G.pkm
--caste change intervals
pm.set_caste_change_interval("serf", 80)
pm.set_caste_change_interval("monk", 3)
pm.set_caste_change_interval("lord", 40)
pm.set_caste_change_interval("foreign",60)

--caste maximum bundles
pm.set_caste_bundle_maximum("serf", 1040)
pm.set_caste_bundle_maximum("monk", 39)
pm.set_caste_bundle_maximum("lord", 520)
pm.set_caste_bundle_maximum("foreign", 780)


--immigration strengths // keep in mind these are capped to 10% of your pop cap per turn so if this number is higher it will go down. 
pm.set_immigration_strength_for_caste("serf", 35)
pm.set_immigration_strength_for_caste("monk", 1)
pm.set_immigration_strength_for_caste("lord", 10)
pm.set_immigration_strength_for_caste("foreign", 20)
--immigration limits
pm.set_immigration_activity_limit_for_caste("serf", 0.7)
pm.set_immigration_activity_limit_for_caste("monk", 0.99)
pm.set_immigration_activity_limit_for_caste("lord", 0.5)
pm.set_immigration_activity_limit_for_caste("foreign", 0.99)
--minimum positive growths
pm.set_mimimum_pos_growth_for_caste("serf", 5)
--natural rates of growth
pm.set_natural_growth_for_caste("serf", 0.05) 
pm.set_natural_growth_for_caste("lord", 0.07) 
--overcrowding values.
pm.set_overcrowding_lower_limit_for_caste("serf", 0.65)
pm.set_overcrowding_strength_for_caste("serf", 0.45) 
--growth reduction thresholds
pm.set_growth_reduction_threshold_for_caste("serf", 625)
--set the home region cap bonus
pm.set_home_region_pop_cap_for_caste("serf", 160)
pm.set_home_region_pop_cap_for_caste("lord", 80)

--returns what tier, how much pop growth bonus to apply, or how much pop to decay due to famine.
--v function(total_food: number) --> (number, number, number)
local function get_food_level(total_food)
    if total_food < (0-150) then
        return 0, -30, 5
    elseif total_food < (0-50) then
        return 1, -30, 0
    elseif total_food < (0) then
        return 2, -15, 0
    elseif total_food < 100 then
        return 3, 10, 0
    elseif total_food < 250 then
        return 4, 20, 0
    else
        return 5, 30, 0
    end
end


pm.add_food_effect_function("serf", function(q_in, food_manager, is_end_turn) 
    if not food_manager then
        pkm:log("Called Food Function without a food manager!")
        return q_in
    elseif is_end_turn then
        --# assume food_manager: FOOD_MANAGER
        local tier, _, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if decay > 0 then
            return q_in * (1 + (decay/100))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return (q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return (q_in * (1 - (math.abs(growth)/100)))
        elseif  (q_in < 0 and growth > 0) or (q_in < 0 and growth < 0) then --but we use this for costs, 
            --so we don't want to make conscription take a different number of men based on food
            return q_in
        else
            return q_in
        end
    end
end)


pm.add_food_effect_function("lord", function(q_in, food_manager, is_end_turn) 
    if not food_manager then
        pkm:log("Called Food Function without a food manager!")
        return q_in
    elseif is_end_turn then
        --# assume food_manager: FOOD_MANAGER
        local tier, _, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if decay > 0 then
            return q_in * (1 + (decay/100))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return (q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return (q_in * (1 - (math.abs(growth)/100)))
        elseif  (q_in < 0 and growth > 0) or (q_in < 0 and growth < 0) then --but we use this for costs, 
            --so we don't want to make conscription take a different number of men based on food
            return q_in
        else
            return q_in
        end
    end
end)


pm.add_food_effect_function("monk", function(q_in, food_manager, is_end_turn) 
    if not food_manager then
        pkm:log("Called Food Function without a food manager!")
        return q_in
    elseif is_end_turn then
        --# assume food_manager: FOOD_MANAGER
        local tier, _, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if decay > 0 then
            return q_in * (1 + (decay/100))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return (q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return (q_in * (1 - (math.abs(growth)/100)))
        elseif  (q_in < 0 and growth > 0) or (q_in < 0 and growth < 0) then --but we use this for costs, 
            --so we don't want to make conscription take a different number of men based on food
            return q_in
        else
            return q_in
        end
    end
end)


--settlement cop caps
local building_pop_cap_settlements = {
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 320, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 400, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 560, ["value_damaged"] = 560, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 800, ["value_damaged"] = 800, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 420, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 180, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 380, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 180, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 380, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 200, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 280, ["value_damaged"] = 280, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 200, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 280, ["value_damaged"] = 280, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 180, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 380, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 180, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 380, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 240, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 300, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 360, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 25, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 110, ["value_damaged"] = 110, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 200, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 90, ["value_damaged"] = 90, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 130, ["value_damaged"] = 130, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 140, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 0, ["value_damaged"] = 0, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 0, ["value_damaged"] = 0, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 0, ["value_damaged"] = 0, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 0, ["value_damaged"] = 0, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 24, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 42, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 24, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 42, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 24, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 42, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 24, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 42, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 10, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 24, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 42, ["value_damaged"] = 42, ["value_ruined"] = 0 }

} --:vector<{building: string, effect: string, effect_scope: string, value: number, value_damaged: number, value_ruined: number}>

for i = 1, #building_pop_cap_settlements do
    local item = building_pop_cap_settlements[i]
    pm.add_building_pop_cap_contribution(item.building, item.effect:gsub("shield_scripted_pop_cap_", ""), item.value)
end
