local pm = _G.pm

--caste change intervals
pm.set_caste_change_interval("serf", 20)
pm.set_caste_change_interval("monk", 5)
pm.set_caste_change_interval("lord", 40)
pm.set_caste_change_interval("foreign", 60)
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
pm.set_natural_growth_for_caste("lord", 0.09) 
--overcrowding values.
pm.set_overcrowding_lower_limit_for_caste("serf", 0.65)
pm.set_overcrowding_strength_for_caste("serf", 0.45) 
--growth reduction thresholds
pm.set_growth_reduction_threshold_for_caste("serf", 2000)