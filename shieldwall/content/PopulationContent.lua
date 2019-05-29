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
pm.set_immigration_activity_limit_for_caste("monk", 1)
pm.set_immigration_activity_limit_for_caste("lord", 0.4)
pm.set_immigration_activity_limit_for_caste("foreign", 1)
--minimum positive growths
pm.set_mimimum_pos_growth_for_caste("serf", 5)
pm.set_mimimum_pos_growth_for_caste("lord", 5)
pm.set_mimimum_pos_growth_for_caste("foreign", 4)
pm.set_mimimum_pos_growth_for_caste("monk", 1)
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
	if not is_number(total_food) then
		dev.log("Get Food level recieved a non_number argument!", "BUG")
		dev.log(debug.traceback(), "BUG")
		return 3, 0, 0
	end
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
            return math.ceil(q_in * (1 - (decay/100)))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return math.ceil(q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return math.ceil(q_in * (1 - (math.abs(growth)/100)))
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
            return math.ceil(q_in * (1 - (decay/100)))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return math.ceil(q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return math.ceil(q_in * (1 - (math.abs(growth)/100)))
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
            return math.ceil(q_in * (1 - (decay/100)))
        else
            return q_in
        end
    else
        --# assume food_manager: FOOD_MANAGER
        local tier, growth, decay = get_food_level(dev.get_faction(food_manager._factionName):total_food())
        if (q_in > 0 and growth > 0)  then --if the quantity and growth have the same sign
            return math.ceil(q_in * (1 + (math.abs(growth)/100)))
        elseif (q_in > 0 and growth < 0)   then --if the quantity is positive, but we are reducing growth
            return math.ceil(q_in * (1 - (math.abs(growth)/100)))
        elseif  (q_in < 0 and growth > 0) or (q_in < 0 and growth < 0) then --but we use this for costs, 
            --so we don't want to make conscription take a different number of men based on food
            return q_in
        else
            return q_in
        end
    end
end)


--unit size Scalar
--if you're trying to make the game playable with larger units, this is what you're looking for.
local unit_size_mode_scalar = 0.5 --0.5 is shieldwall's default sizes.








--settlement cop caps
local building_pop_cap_settlements = {
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 335, ["value_damaged"] = 320, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 415, ["value_damaged"] = 400, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 575, ["value_damaged"] = 560, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 815, ["value_damaged"] = 800, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 435, ["value_damaged"] = 420, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 195, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_mountain_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 395, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 195, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_grianan_ailech_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 395, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 215, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 295, ["value_damaged"] = 280, ["value_ruined"] = 0 },
{ ["building"] = "vik_great_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 215, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 295, ["value_damaged"] = 280, ["value_ruined"] = 0 },
{ ["building"] = "vik_market_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 195, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_offas_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 395, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 195, ["value_damaged"] = 180, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 395, ["value_damaged"] = 380, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 255, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_4", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 315, ["value_damaged"] = 300, ["value_ruined"] = 0 },
{ ["building"] = "vik_longphort_5", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_achad_bo_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ciaran_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_columbe_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_patraic_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_monastery_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_cloth_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_pottery_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 175, ["value_damaged"] = 160, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 25, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_salt_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 215, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 135, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 155, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 65, ["value_damaged"] = 50, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 115, ["value_damaged"] = 100, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_tin_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_silver_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_iron_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_gold_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_copper_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_farm_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 95, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_hunting_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 75, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_orchard_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 35, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_pasture_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 33, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 39, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_ringan_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 57, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 33, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 39, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_cuthbert_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 57, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 33, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 39, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_dewi_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 57, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 33, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 39, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_edmund_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 57, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 33, ["value_damaged"] = 18, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 39, ["value_damaged"] = 24, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_4", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_school_ros_5", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 57, ["value_damaged"] = 42, ["value_ruined"] = 0 },
{ ["building"] = "vik_estate_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_estate_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_estate_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_arena_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_arena_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 85, ["value_damaged"] = 75, ["value_ruined"] = 0 },
{ ["building"] = "vik_arena_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 90, ["value_ruined"] = 0 },
{ ["building"] = "vik_court_school_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_court_school_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 26, ["value_damaged"] = 16, ["value_ruined"] = 0 },
{ ["building"] = "vik_court_school_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 32, ["value_damaged"] = 22, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_fish_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_military_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_military_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 130, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_military_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_fish_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_port_fish_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_trade_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 100, ["value_damaged"] = 90, ["value_ruined"] = 0 },
{ ["building"] = "vik_trade_2", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 150, ["value_damaged"] = 140, ["value_ruined"] = 0 },
{ ["building"] = "vik_trade_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 210, ["value_damaged"] = 200, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_3", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_4", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 55, ["value_damaged"] = 45, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_5", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_b_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_b_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_b_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_fishing_b_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 90, ["value_damaged"] = 80, ["value_ruined"] = 0 },
{ ["building"] = "vik_alehouse_1", ["effect"] = "shield_scripted_pop_cap_foreign", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_benedictine_abbey_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 8, ["value_ruined"] = 0 },
{ ["building"] = "vik_benedictine_abbey_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_benedictine_abbey_b_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_celi_de_abbey_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 8, ["value_ruined"] = 0 },
{ ["building"] = "vik_celi_de_abbey_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_ceil_de_abbey_b_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_abbey_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 18, ["value_damaged"] = 8, ["value_ruined"] = 0 },
{ ["building"] = "vik_abbey_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 45, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_abbey_b_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 25, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_guildhall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 130, ["value_damaged"] = 120, ["value_ruined"] = 0 },
{ ["building"] = "vik_guildhall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 250, ["value_damaged"] = 240, ["value_ruined"] = 0 },
{ ["building"] = "vik_guildhall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 370, ["value_damaged"] = 360, ["value_ruined"] = 0 },
{ ["building"] = "vik_scoan_abbey_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_scoan_abbey_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_scoan_abbey_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_brigit_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_brigit_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_brigit_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 60, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_swithun_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 10, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_swithun_2", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_st_swithun_3", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 30, ["value_ruined"] = 0 },
{ ["building"] = "vik_konungsgurtha_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_konungsgurtha_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_konungsgurtha_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 40, ["value_ruined"] = 0 },
{ ["building"] = "vik_nunnaminster_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_nunnaminster_1", ["effect"] = "shield_scripted_pop_cap_monk", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 5, ["value_ruined"] = 0 },
{ ["building"] = "vik_thing_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 30, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_thing_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 50, ["value_damaged"] = 20, ["value_ruined"] = 0 },
{ ["building"] = "vik_thing_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 70, ["value_damaged"] = 20, ["value_ruined"] = 0 }

} --:vector<{building: string, effect: string, effect_scope: string, value: number, value_damaged: number, value_ruined: number}>

for i = 1, #building_pop_cap_settlements do
    local item = building_pop_cap_settlements[i]
    pm.add_building_pop_cap_contribution(item.building, item.effect:gsub("shield_scripted_pop_cap_", ""), item.value)
end



local main_unit_size_caste_info = {
	["dan_anglian_champions"] = { ["unit_key"] = "dan_anglian_champions", ["caste"] = "medium", ["num_men"] = 160 },
	["dan_anglian_marauders"] = { ["unit_key"] = "dan_anglian_marauders", ["caste"] = "super_heavy", ["num_men"] = 80 },
	["dan_anglian_raiders"] = { ["unit_key"] = "dan_anglian_raiders", ["caste"] = "medium", ["num_men"] = 120 },
	["dan_archers"] = { ["unit_key"] = "dan_archers", ["caste"] = "light", ["num_men"] = 60 },
	["dan_armoured_archers"] = { ["unit_key"] = "dan_armoured_archers", ["caste"] = "medium", ["num_men"] = 80 },
	["dan_axemen"] = { ["unit_key"] = "dan_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_berserkers"] = { ["unit_key"] = "dan_berserkers", ["caste"] = "very_heavy", ["num_men"] = 24 },
	["dan_catapult"] = { ["unit_key"] = "dan_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["dan_ceorl_archers"] = { ["unit_key"] = "dan_ceorl_archers", ["caste"] = "light", ["num_men"] = 60 },
	["dan_ceorl_axemen"] = { ["unit_key"] = "dan_ceorl_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_ceorl_javelinmen"] = { ["unit_key"] = "dan_ceorl_javelinmen", ["caste"] = "very_light", ["num_men"] = 60 },
	["dan_ceorl_spearmen"] = { ["unit_key"] = "dan_ceorl_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_danelaw_huscarls"] = { ["unit_key"] = "dan_danelaw_huscarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["dan_fyrd_archers"] = { ["unit_key"] = "dan_fyrd_archers", ["caste"] = "very_light", ["num_men"] = 60 },
	["dan_fyrd_spearmen"] = { ["unit_key"] = "dan_fyrd_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_great_axemen"] = { ["unit_key"] = "dan_great_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_huscarls"] = { ["unit_key"] = "dan_huscarls", ["caste"] = "heavy", ["num_men"] = 120 },
	["dan_jarls_horsemen"] = { ["unit_key"] = "dan_jarls_horsemen", ["caste"] = "heavy", ["num_men"] = 48 },
	["dan_jarls_huscarls"] = { ["unit_key"] = "dan_jarls_huscarls", ["caste"] = "super_heavy", ["num_men"] = 48 },
	["dan_javelinmen"] = { ["unit_key"] = "dan_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["dan_long_axemen"] = { ["unit_key"] = "dan_long_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_mailed_archers"] = { ["unit_key"] = "dan_mailed_archers", ["caste"] = "medium", ["num_men"] = 80 },
	["dan_mailed_horsemen"] = { ["unit_key"] = "dan_mailed_horsemen", ["caste"] = "super_heavy", ["num_men"] = 48 },
	["dan_mailed_swordsmen"] = { ["unit_key"] = "dan_mailed_swordsmen", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["dan_northumbrian_mailed_thegns"] = { ["unit_key"] = "dan_northumbrian_mailed_thegns", ["caste"] = "super_heavy", ["num_men"] = 80 },
	["dan_northumbrian_thegns"] = { ["unit_key"] = "dan_northumbrian_thegns", ["caste"] = "heavy", ["num_men"] = 120 },
	["dan_royal_huscarls"] = { ["unit_key"] = "dan_royal_huscarls", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["dan_scout_horsemen"] = { ["unit_key"] = "dan_scout_horsemen", ["caste"] = "light", ["num_men"] = 24 },
	["dan_shield_biters"] = { ["unit_key"] = "dan_shield_biters", ["caste"] = "heavy", ["num_men"] = 40 },
	["dan_spearmen"] = { ["unit_key"] = "dan_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["dan_sword_hersir"] = { ["unit_key"] = "dan_sword_hersir", ["caste"] = "heavy", ["num_men"] = 80 },
	["dan_sword_hirdmen"] = { ["unit_key"] = "dan_sword_hirdmen", ["caste"] = "heavy", ["num_men"] = 120 },
	["dan_thegn_horsemen"] = { ["unit_key"] = "dan_thegn_horsemen", ["caste"] = "medium", ["num_men"] = 60 },
	["dan_warlords_companions"] = { ["unit_key"] = "dan_warlords_companions", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["eng_catapult"] = { ["unit_key"] = "eng_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["eng_ceorl_archers"] = { ["unit_key"] = "eng_ceorl_archers", ["caste"] = "light", ["num_men"] = 60 },
	["eng_ceorl_axemen"] = { ["unit_key"] = "eng_ceorl_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_ceorl_javelinmen"] = { ["unit_key"] = "eng_ceorl_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["eng_ceorl_spearmen"] = { ["unit_key"] = "eng_ceorl_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_earls_horsemen"] = { ["unit_key"] = "eng_earls_horsemen", ["caste"] = "heavy", ["num_men"] = 48 },
	["eng_earls_spearmen"] = { ["unit_key"] = "eng_earls_spearmen", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["eng_earls_thegns"] = { ["unit_key"] = "eng_earls_thegns", ["caste"] = "medium", ["num_men"] = 80 },
	["eng_fyrd_archers"] = { ["unit_key"] = "eng_fyrd_archers", ["caste"] = "light", ["num_men"] = 60 },
	["eng_fyrd_axemen"] = { ["unit_key"] = "eng_fyrd_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_fyrd_javelinmen"] = { ["unit_key"] = "eng_fyrd_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["eng_fyrd_spearmen"] = { ["unit_key"] = "eng_fyrd_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_long_axemen"] = { ["unit_key"] = "eng_long_axemen", ["caste"] = "medium", ["num_men"] = 80 },
	["eng_mailed_horsemen"] = { ["unit_key"] = "eng_mailed_horsemen", ["caste"] = "medium", ["num_men"] = 48 },
	["eng_mailed_long_axemen"] = { ["unit_key"] = "eng_mailed_long_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_mailed_seaxs"] = { ["unit_key"] = "eng_mailed_seaxs", ["caste"] = "medium", ["num_men"] = 160 },
	["eng_mailed_spearmen"] = { ["unit_key"] = "eng_mailed_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["eng_mailed_thegns"] = { ["unit_key"] = "eng_mailed_thegns", ["caste"] = "super_heavy", ["num_men"] = 40 },
	["eng_marcher_armoured_spearmen"] = { ["unit_key"] = "eng_marcher_armoured_spearmen", ["caste"] = "medium", ["num_men"] = 80 },
	["eng_marcher_mailed_spearmen"] = { ["unit_key"] = "eng_marcher_mailed_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["eng_marcher_spearmen"] = { ["unit_key"] = "eng_marcher_spearmen", ["caste"] = "medium", ["num_men"] = 120 },
	["eng_militia_fyrd_archers"] = { ["unit_key"] = "eng_militia_fyrd_archers", ["caste"] = "medium", ["num_men"] = 60 },
	["eng_militia_fyrd_spearmen"] = { ["unit_key"] = "eng_militia_fyrd_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_royal_bodyguard"] = { ["unit_key"] = "eng_royal_bodyguard", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["eng_royal_companions"] = { ["unit_key"] = "eng_royal_companions", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["eng_royal_huscarls"] = { ["unit_key"] = "eng_royal_huscarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["eng_royal_thegns"] = { ["unit_key"] = "eng_royal_thegns", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["eng_scout_horsemen"] = { ["unit_key"] = "eng_scout_horsemen", ["caste"] = "light", ["num_men"] = 24 },
	["eng_seax_warriors"] = { ["unit_key"] = "eng_seax_warriors", ["caste"] = "medium", ["num_men"] = 120 },
	["eng_select_fyrd_archers"] = { ["unit_key"] = "eng_select_fyrd_archers", ["caste"] = "medium", ["num_men"] = 60 },
	["eng_select_fyrd_spearmen"] = { ["unit_key"] = "eng_select_fyrd_spearmen", ["caste"] = "medium", ["num_men"] = 120 },
	["eng_select_militia_spearmen"] = { ["unit_key"] = "eng_select_militia_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["eng_thegn_horsemen"] = { ["unit_key"] = "eng_thegn_horsemen", ["caste"] = "medium", ["num_men"] = 48 },
	["eng_thegn_spearmen"] = { ["unit_key"] = "eng_thegn_spearmen", ["caste"] = "heavy", ["num_men"] = 80 },
	["eng_thegns"] = { ["unit_key"] = "eng_thegns", ["caste"] = "heavy", ["num_men"] = 80 },
	["est_archers"] = { ["unit_key"] = "est_archers", ["caste"] = "light", ["num_men"] = 60 },
	["est_axe_warriors"] = { ["unit_key"] = "est_axe_warriors", ["caste"] = "medium", ["num_men"] = 120 },
	["est_axemen"] = { ["unit_key"] = "est_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["est_berserkers"] = { ["unit_key"] = "est_berserkers", ["caste"] = "heavy", ["num_men"] = 40 },
	["est_catapult"] = { ["unit_key"] = "est_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["est_champions"] = { ["unit_key"] = "est_champions", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["est_fighters"] = { ["unit_key"] = "est_fighters", ["caste"] = "very_light", ["num_men"] = 120 },
	["est_great_axes"] = { ["unit_key"] = "est_great_axes", ["caste"] = "light", ["num_men"] = 160 },
	["est_hearthguard"] = { ["unit_key"] = "est_hearthguard", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["est_hirdmen"] = { ["unit_key"] = "est_hirdmen", ["caste"] = "heavy", ["num_men"] = 120 },
	["est_horsemen"] = { ["unit_key"] = "est_horsemen", ["caste"] = "medium", ["num_men"] = 60 },
	["est_hunters"] = { ["unit_key"] = "est_hunters", ["caste"] = "light", ["num_men"] = 24 },
	["est_huskarls"] = { ["unit_key"] = "est_huskarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["est_javelinmen"] = { ["unit_key"] = "est_javelinmen", ["caste"] = "light", ["num_men"] = 80 },
	["est_kerns"] = { ["unit_key"] = "est_kerns", ["caste"] = "light", ["num_men"] = 60 },
	["est_levy_javelinmen"] = { ["unit_key"] = "est_levy_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["est_long_axes"] = { ["unit_key"] = "est_long_axes", ["caste"] = "medium", ["num_men"] = 120 },
	["est_mailed_axemen"] = { ["unit_key"] = "est_mailed_axemen", ["caste"] = "heavy", ["num_men"] = 120 },
	["est_mailed_horsemen"] = { ["unit_key"] = "est_mailed_horsemen", ["caste"] = "very_light", ["num_men"] = 48 },
	["est_marauders"] = { ["unit_key"] = "est_marauders", ["caste"] = "light", ["num_men"] = 160 },
	["est_norse_hersir"] = { ["unit_key"] = "est_norse_hersir", ["caste"] = "medium", ["num_men"] = 80 },
	["est_norse_mailed_hersir"] = { ["unit_key"] = "est_norse_mailed_hersir", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["est_norse_warriors"] = { ["unit_key"] = "est_norse_warriors", ["caste"] = "light", ["num_men"] = 120 },
	["est_raiders"] = { ["unit_key"] = "est_raiders", ["caste"] = "light", ["num_men"] = 48 },
	["est_royal_huskarls"] = { ["unit_key"] = "est_royal_huskarls", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["est_scouts"] = { ["unit_key"] = "est_scouts", ["caste"] = "light", ["num_men"] = 24 },
	["est_shield_biters"] = { ["unit_key"] = "est_shield_biters", ["caste"] = "very_heavy", ["num_men"] = 40 },
	["est_spear_guard"] = { ["unit_key"] = "est_spear_guard", ["caste"] = "heavy", ["num_men"] = 120 },
	["est_spear_hirdmen"] = { ["unit_key"] = "est_spear_hirdmen", ["caste"] = "medium", ["num_men"] = 120 },
	["est_spearband"] = { ["unit_key"] = "est_spearband", ["caste"] = "light", ["num_men"] = 160 },
	["est_spearmen"] = { ["unit_key"] = "est_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["est_warband"] = { ["unit_key"] = "est_warband", ["caste"] = "light", ["num_men"] = 200 },
	["est_wood_kerns"] = { ["unit_key"] = "est_wood_kerns", ["caste"] = "light", ["num_men"] = 80 },
	["iri_airig_horsemen"] = { ["unit_key"] = "iri_airig_horsemen", ["caste"] = "heavy", ["num_men"] = 60 },
	["iri_airig_mailed_horsemen"] = { ["unit_key"] = "iri_airig_mailed_horsemen", ["caste"] = "heavy", ["num_men"] = 48 },
	["iri_airig_swordsmen"] = { ["unit_key"] = "iri_airig_swordsmen", ["caste"] = "heavy", ["num_men"] = 40 },
	["iri_airig_warband"] = { ["unit_key"] = "iri_airig_warband", ["caste"] = "heavy", ["num_men"] = 80 },
	["iri_catapult"] = { ["unit_key"] = "iri_catapult", ["caste"] = "light", ["num_men"] = 24 },
	["iri_fianna_band"] = { ["unit_key"] = "iri_fianna_band", ["caste"] = "medium", ["num_men"] = 120 },
	["iri_fianna_swordsmen"] = { ["unit_key"] = "iri_fianna_swordsmen", ["caste"] = "medium", ["num_men"] = 160 },
	["iri_foreign_warriors"] = { ["unit_key"] = "iri_foreign_warriors", ["caste"] = "medium", ["num_men"] = 80 },
	["iri_freemen_archers"] = { ["unit_key"] = "iri_freemen_archers", ["caste"] = "light", ["num_men"] = 80 },
	["iri_freemen_axemen"] = { ["unit_key"] = "iri_freemen_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["iri_freemen_javelinmen"] = { ["unit_key"] = "iri_freemen_javelinmen", ["caste"] = "light", ["num_men"] = 80 },
	["iri_freemen_spearmen"] = { ["unit_key"] = "iri_freemen_spearmen", ["caste"] = "light", ["num_men"] = 200 },
	["iri_gallowglasses"] = { ["unit_key"] = "iri_gallowglasses", ["caste"] = "medium", ["num_men"] = 160 },
	["iri_horse_boys"] = { ["unit_key"] = "iri_horse_boys", ["caste"] = "light", ["num_men"] = 64 },
	["iri_household_horsemen"] = { ["unit_key"] = "iri_household_horsemen", ["caste"] = "heavy", ["num_men"] = 40 },
	["iri_household_riders"] = { ["unit_key"] = "iri_household_riders", ["caste"] = "heavy", ["num_men"] = 32 },
	["iri_kern_axemen"] = { ["unit_key"] = "iri_kern_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["iri_kern_raiders"] = { ["unit_key"] = "iri_kern_raiders", ["caste"] = "light", ["num_men"] = 24 },
	["iri_kern_spearmen"] = { ["unit_key"] = "iri_kern_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["iri_kern_swordsmen"] = { ["unit_key"] = "iri_kern_swordsmen", ["caste"] = "light", ["num_men"] = 160 },
	["iri_kerns"] = { ["unit_key"] = "iri_kerns", ["caste"] = "light", ["num_men"] = 80 },
	["iri_mailed_fianna"] = { ["unit_key"] = "iri_mailed_fianna", ["caste"] = "medium", ["num_men"] = 40 },
	["iri_mounted_kerns"] = { ["unit_key"] = "iri_mounted_kerns", ["caste"] = "light", ["num_men"] = 60 },
	["iri_raider_swordsmen"] = { ["unit_key"] = "iri_raider_swordsmen", ["caste"] = "light", ["num_men"] = 160 },
	["iri_serf_archers"] = { ["unit_key"] = "iri_serf_archers", ["caste"] = "light", ["num_men"] = 60 },
	["iri_spear_raiders"] = { ["unit_key"] = "iri_spear_raiders", ["caste"] = "medium", ["num_men"] = 120 },
	["iri_wolf_hounds"] = { ["unit_key"] = "iri_wolf_hounds", ["caste"] = "light", ["num_men"] = 24 },
	["iri_wood_kerns"] = { ["unit_key"] = "iri_wood_kerns", ["caste"] = "light", ["num_men"] = 48 },
	["iri_wood_spears"] = { ["unit_key"] = "iri_wood_spears", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_archers"] = { ["unit_key"] = "nor_archers", ["caste"] = "light", ["num_men"] = 80 },
	["nor_axe_levy"] = { ["unit_key"] = "nor_axe_levy", ["caste"] = "light", ["num_men"] = 160 },
	["nor_axemen"] = { ["unit_key"] = "nor_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["nor_catapult"] = { ["unit_key"] = "nor_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["nor_cavalry"] = { ["unit_key"] = "nor_cavalry", ["caste"] = "medium", ["num_men"] = 60 },
	["nor_flemish_crossbowmen"] = { ["unit_key"] = "nor_flemish_crossbowmen", ["caste"] = "medium", ["num_men"] = 80 },
	["nor_foot_soldiers"] = { ["unit_key"] = "nor_foot_soldiers", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_horsemen"] = { ["unit_key"] = "nor_horsemen", ["caste"] = "medium", ["num_men"] = 60 },
	["nor_huskarls"] = { ["unit_key"] = "nor_huskarls", ["caste"] = "heavy", ["num_men"] = 100 },
	["nor_knights"] = { ["unit_key"] = "nor_knights", ["caste"] = "medium", ["num_men"] = 60 },
	["nor_levy_archers"] = { ["unit_key"] = "nor_levy_archers", ["caste"] = "light", ["num_men"] = 80 },
	["nor_levy_spearmen"] = { ["unit_key"] = "nor_levy_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["nor_mailed_spearmen"] = { ["unit_key"] = "nor_mailed_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_maine_infantry"] = { ["unit_key"] = "nor_maine_infantry", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_maine_warriors"] = { ["unit_key"] = "nor_maine_warriors", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_miles"] = { ["unit_key"] = "nor_miles", ["caste"] = "heavy", ["num_men"] = 32 },
	["nor_scout_cavalry"] = { ["unit_key"] = "nor_scout_cavalry", ["caste"] = "light", ["num_men"] = 60 },
	["nor_shield_wall"] = { ["unit_key"] = "nor_shield_wall", ["caste"] = "medium", ["num_men"] = 160 },
	["nor_spearmen"] = { ["unit_key"] = "nor_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["nor_swordsmen"] = { ["unit_key"] = "nor_swordsmen", ["caste"] = "medium", ["num_men"] = 160 },
	["sco_alban_axe_warriors"] = { ["unit_key"] = "sco_alban_axe_warriors", ["caste"] = "medium", ["num_men"] = 160 },
	["sco_alban_axemen"] = { ["unit_key"] = "sco_alban_axemen", ["caste"] = "medium", ["num_men"] = 160 },
	["sco_alban_crossbowmen"] = { ["unit_key"] = "sco_alban_crossbowmen", ["caste"] = "medium", ["num_men"] = 48 },
	["sco_alban_horsemen"] = { ["unit_key"] = "sco_alban_horsemen", ["caste"] = "medium", ["num_men"] = 60 },
	["sco_alban_javelinmen"] = { ["unit_key"] = "sco_alban_javelinmen", ["caste"] = "light", ["num_men"] = 80 },
	["sco_alban_levy_javelinmen"] = { ["unit_key"] = "sco_alban_levy_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["sco_alban_levy_spearmen"] = { ["unit_key"] = "sco_alban_levy_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["sco_alban_raiders"] = { ["unit_key"] = "sco_alban_raiders", ["caste"] = "light", ["num_men"] = 60 },
	["sco_alban_spearmen"] = { ["unit_key"] = "sco_alban_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["sco_alban_warriors"] = { ["unit_key"] = "sco_alban_warriors", ["caste"] = "medium", ["num_men"] = 40 },
	["sco_black_blades"] = { ["unit_key"] = "sco_black_blades", ["caste"] = "heavy", ["num_men"] = 160 },
	["sco_catapult"] = { ["unit_key"] = "sco_catapult", ["caste"] = "light", ["num_men"] = 24 },
	["sco_cateran_axemen"] = { ["unit_key"] = "sco_cateran_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["sco_cateran_levy"] = { ["unit_key"] = "sco_cateran_levy", ["caste"] = "light", ["num_men"] = 160 },
	["sco_highland_archers"] = { ["unit_key"] = "sco_highland_archers", ["caste"] = "light", ["num_men"] = 60 },
	["sco_highland_levy_archers"] = { ["unit_key"] = "sco_highland_levy_archers", ["caste"] = "light", ["num_men"] = 80 },
	["sco_highland_sharpshooters"] = { ["unit_key"] = "sco_highland_sharpshooters", ["caste"] = "light", ["num_men"] = 80 },
	["sco_kings_blades"] = { ["unit_key"] = "sco_kings_blades", ["caste"] = "heavy", ["num_men"] = 40 },
	["sco_lowland_crossbowmen"] = { ["unit_key"] = "sco_lowland_crossbowmen", ["caste"] = "medium", ["num_men"] = 36 },
	["sco_lowland_raiders"] = { ["unit_key"] = "sco_lowland_raiders", ["caste"] = "light", ["num_men"] = 24 },
	["sco_mormaer_horsemen"] = { ["unit_key"] = "sco_mormaer_horsemen", ["caste"] = "medium", ["num_men"] = 56 },
	["sco_royal_bodyguard"] = { ["unit_key"] = "sco_royal_bodyguard", ["caste"] = "heavy", ["num_men"] = 32 },
	["sco_royal_cavalry"] = { ["unit_key"] = "sco_royal_cavalry", ["caste"] = "heavy", ["num_men"] = 48 },
	["sco_royal_followers"] = { ["unit_key"] = "sco_royal_followers", ["caste"] = "heavy", ["num_men"] = 40 },
	["sco_royal_horsemen"] = { ["unit_key"] = "sco_royal_horsemen", ["caste"] = "heavy", ["num_men"] = 60 },
	["sco_schiltron"] = { ["unit_key"] = "sco_schiltron", ["caste"] = "light", ["num_men"] = 160 },
	["sco_sword_band"] = { ["unit_key"] = "sco_sword_band", ["caste"] = "medium", ["num_men"] = 80 },
	["sco_sword_warriors"] = { ["unit_key"] = "sco_sword_warriors", ["caste"] = "medium", ["num_men"] = 80 },
	["sco_wolf_hounds"] = { ["unit_key"] = "sco_wolf_hounds", ["caste"] = "light", ["num_men"] = 24 },
	["vik_archers"] = { ["unit_key"] = "vik_archers", ["caste"] = "light", ["num_men"] = 80 },
	["vik_armoured_archers"] = { ["unit_key"] = "vik_armoured_archers", ["caste"] = "medium", ["num_men"] = 80 },
	["vik_axe_freemen"] = { ["unit_key"] = "vik_axe_freemen", ["caste"] = "light", ["num_men"] = 160 },
	["vik_axe_hersir"] = { ["unit_key"] = "vik_axe_hersir", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_axe_hirdmen"] = { ["unit_key"] = "vik_axe_hirdmen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_berserkers"] = { ["unit_key"] = "vik_berserkers", ["caste"] = "heavy", ["num_men"] = 80 },
	["vik_catapult"] = { ["unit_key"] = "vik_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["vik_freemen"] = { ["unit_key"] = "vik_freemen", ["caste"] = "light", ["num_men"] = 160 },
	["vik_great_axes"] = { ["unit_key"] = "vik_great_axes", ["caste"] = "light", ["num_men"] = 160 },
	["vik_hearthguard"] = { ["unit_key"] = "vik_hearthguard", ["caste"] = "heavy", ["num_men"] = 40 },
	["vik_hunters"] = { ["unit_key"] = "vik_hunters", ["caste"] = "light", ["num_men"] = 80 },
	["vik_huskarls"] = { ["unit_key"] = "vik_huskarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["vik_jarls_huskarls"] = { ["unit_key"] = "vik_jarls_huskarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["vik_javelinmen"] = { ["unit_key"] = "vik_javelinmen", ["caste"] = "light", ["num_men"] = 80 },
	["vik_jomsvikings"] = { ["unit_key"] = "vik_jomsvikings", ["caste"] = "super_heavy", ["num_men"] = 80 },
	["vik_long_axes"] = { ["unit_key"] = "vik_long_axes", ["caste"] = "light", ["num_men"] = 160 },
	["vik_mailed_archers"] = { ["unit_key"] = "vik_mailed_archers", ["caste"] = "heavy", ["num_men"] = 60 },
	["vik_mailed_hersir_axemen"] = { ["unit_key"] = "vik_mailed_hersir_axemen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_mailed_hersir_spearmen"] = { ["unit_key"] = "vik_mailed_hersir_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_mailed_hersir_swordsmen"] = { ["unit_key"] = "vik_mailed_hersir_swordsmen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_mailed_huskarls"] = { ["unit_key"] = "vik_mailed_huskarls", ["caste"] = "heavy", ["num_men"] = 160 },
	["vik_marauders"] = { ["unit_key"] = "vik_marauders", ["caste"] = "light", ["num_men"] = 160 },
	["vik_raiders"] = { ["unit_key"] = "vik_raiders", ["caste"] = "light", ["num_men"] = 160 },
	["vik_royal_huskarls"] = { ["unit_key"] = "vik_royal_huskarls", ["caste"] = "heavy", ["num_men"] = 40 },
	["vik_scouts"] = { ["unit_key"] = "vik_scouts", ["caste"] = "light", ["num_men"] = 60 },
	["vik_shield_biters"] = { ["unit_key"] = "vik_shield_biters", ["caste"] = "heavy", ["num_men"] = 80 },
	["vik_skirmishers"] = { ["unit_key"] = "vik_skirmishers", ["caste"] = "light", ["num_men"] = 80 },
	["vik_spear_hersir"] = { ["unit_key"] = "vik_spear_hersir", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_spear_hirdmen"] = { ["unit_key"] = "vik_spear_hirdmen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_sword_hersir"] = { ["unit_key"] = "vik_sword_hersir", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_sword_hirdmen"] = { ["unit_key"] = "vik_sword_hirdmen", ["caste"] = "medium", ["num_men"] = 160 },
	["vik_thrall_axemen"] = { ["unit_key"] = "vik_thrall_axemen", ["caste"] = "medium", ["num_men"] = 60 },
	["vik_thrall_spearmen"] = { ["unit_key"] = "vik_thrall_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_archers"] = { ["unit_key"] = "wel_archers", ["caste"] = "light", ["num_men"] = 60 },
	["wel_armoured_axemen"] = { ["unit_key"] = "wel_armoured_axemen", ["caste"] = "very_light", ["num_men"] = 40 },
	["wel_armoured_swordsmen"] = { ["unit_key"] = "wel_armoured_swordsmen", ["caste"] = "medium", ["num_men"] = 80 },
	["wel_axemen"] = { ["unit_key"] = "wel_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_cantref_spearmen"] = { ["unit_key"] = "wel_cantref_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_catapult"] = { ["unit_key"] = "wel_catapult", ["caste"] = "light", ["num_men"] = 40 },
	["wel_helwyr"] = { ["unit_key"] = "wel_helwyr", ["caste"] = "light", ["num_men"] = 32 },
	["wel_horse_raiders"] = { ["unit_key"] = "wel_horse_raiders", ["caste"] = "light", ["num_men"] = 60 },
	["wel_horsemen"] = { ["unit_key"] = "wel_horsemen", ["caste"] = "medium", ["num_men"] = 64 },
	["wel_hunters"] = { ["unit_key"] = "wel_hunters", ["caste"] = "very_heavy", ["num_men"] = 48 },
	["wel_javelinmen"] = { ["unit_key"] = "wel_javelinmen", ["caste"] = "light", ["num_men"] = 80 },
	["wel_levy_axemen"] = { ["unit_key"] = "wel_levy_axemen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_levy_javelinmen"] = { ["unit_key"] = "wel_levy_javelinmen", ["caste"] = "light", ["num_men"] = 60 },
	["wel_levy_spearmen"] = { ["unit_key"] = "wel_levy_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_longbowmen"] = { ["unit_key"] = "wel_longbowmen", ["caste"] = "light", ["num_men"] = 48 },
	["wel_mailed_axemen"] = { ["unit_key"] = "wel_mailed_axemen", ["caste"] = "medium", ["num_men"] = 120 },
	["wel_mailed_swordsmen"] = { ["unit_key"] = "wel_mailed_swordsmen", ["caste"] = "very_heavy", ["num_men"] = 80 },
	["wel_old_north_horsemen"] = { ["unit_key"] = "wel_old_north_horsemen", ["caste"] = "medium", ["num_men"] = 60 },
	["wel_old_north_riders"] = { ["unit_key"] = "wel_old_north_riders", ["caste"] = "medium", ["num_men"] = 60 },
	["wel_old_north_uchelwr"] = { ["unit_key"] = "wel_old_north_uchelwr", ["caste"] = "very_heavy", ["num_men"] = 48 },
	["wel_royal_spearmen"] = { ["unit_key"] = "wel_royal_spearmen", ["caste"] = "heavy", ["num_men"] = 120 },
	["wel_royal_teulu"] = { ["unit_key"] = "wel_royal_teulu", ["caste"] = "very_heavy", ["num_men"] = 32 },
	["wel_royal_uchelwr"] = { ["unit_key"] = "wel_royal_uchelwr", ["caste"] = "very_heavy", ["num_men"] = 36 },
	["wel_scout_horsemen"] = { ["unit_key"] = "wel_scout_horsemen", ["caste"] = "light", ["num_men"] = 24 },
	["wel_spearmen"] = { ["unit_key"] = "wel_spearmen", ["caste"] = "light", ["num_men"] = 160 },
	["wel_swordsmen"] = { ["unit_key"] = "wel_swordsmen", ["caste"] = "medium", ["num_men"] = 120 },
	["wel_teulu"] = { ["unit_key"] = "wel_teulu", ["caste"] = "very_heavy", ["num_men"] = 32 },
	["wel_teulu_spear_guard"] = { ["unit_key"] = "wel_teulu_spear_guard", ["caste"] = "very_heavy", ["num_men"] = 80 },
	["wel_uchelwr"] = { ["unit_key"] = "wel_uchelwr", ["caste"] = "heavy", ["num_men"] = 48 },
	["wel_valley_armoured_spearmen"] = { ["unit_key"] = "wel_valley_armoured_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["wel_valley_mailed_spearmen"] = { ["unit_key"] = "wel_valley_mailed_spearmen", ["caste"] = "medium", ["num_men"] = 160 },
	["wel_valley_spearmen"] = { ["unit_key"] = "wel_valley_spearmen", ["caste"] = "very_light", ["num_men"] = 160 },
	["wel_war_hounds"] = { ["unit_key"] = "wel_war_hounds", ["caste"] = "heavy", ["num_men"] = 24 }
} --:map<string, {unit_key: string, caste: string, num_men: number}>

local peasant_castes = {
    very_light = true,
    medium = true,
    light = true
}--:map<string, boolean>


local noble_castes = {
    very_heavy = true,
    heavy = true
}--:map<string, boolean>

local mercenary_units = {
        ["eng_long_axemen"] = true, --this is fine because only anglo saxons will ever have this tech!
        ["dan_mailed_horsemen"] = true,
        ["dan_anglian_marauders"] = true,
        ["dan_northumbrian_mailed_thegns"] = true,
        ["eng_mailed_thegns"] = true,
        ["vik_jomsvikings"] = true,
        ["dan_jarls_huscarls"] = true,
        ["wel_mailed_axemen"] = true,
        ["vik_thrall_axemen"] = true
}--:map<string, boolean>



for _, entry in pairs(main_unit_size_caste_info) do
    if mercenary_units[entry.unit_key] then
        pm.set_unit_man_count_and_caste_for_population(entry.unit_key, "foreign", entry.num_men*unit_size_mode_scalar)
    elseif peasant_castes[entry.caste] then
        pm.set_unit_man_count_and_caste_for_population(entry.unit_key, "serf", entry.num_men*unit_size_mode_scalar)
    elseif noble_castes[entry.caste] then
        pm.set_unit_man_count_and_caste_for_population(entry.unit_key, "lord", entry.num_men*unit_size_mode_scalar)
    else
        dev.log("While loading unit sizes for population, unit ["..entry.unit_key.."] has no caste")
    end
end

