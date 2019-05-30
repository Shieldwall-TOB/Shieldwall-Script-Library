return {
    __write_output_to_logfile = true, -- write log files
    __allow_test_buttons = true, --allows the pressing of the F9-F12 key scripted test functions
    __should_output_ui = false, --outputs UI object details on click. Spams the log a bit so leave it off when not doing UI work.
    __log_game_objects = false, --Logs all game object types to a series of files. For use once per patch.
    __should_output_save_load = false, --Outputs the internals of the functions which save and load objects. Only necessary for debugging.
    __no_fog = false, --turn off fog of war.
    __log_settlements = true, -- log information about settlements when they are selected
    __log_characters = true, -- log information about characters when they are selected
    __ignore_pop_requirements_for_testing = true,
    commercial_estate_type = "vik_estate_estate_building", -- the estates_tables key of this type of estate.
    landed_estate_type = "vik_estate_agricultural", -- the estates_tables key of this type of estate.
    church_estate_type = "vik_estate_religious", -- the estates_tables key of this type of estate.
    food_storage_cap_absolute = 2000, --absolute limit any faction can store. 
    food_storage_cap_base = 175, -- base limit all factions have access to.
    food_storage_bundle = "shield_food_storage_bundle_", --bundle prefix from effect_bundles_tables
    food_storage_percentage = 0.5, -- percentage of food stored at the end of each turn
    season_bundle_prefix = "shield_season_", --bundle prefix from effect_bundles_tables
    charm_title_prefix = "shield_title_", --bundle prefix from effect_bundles_tables
    cross_loyalty_result_prefix = "shield_friendship_", --trait key prefix for friendship traits.
    charm_leader_title_prefix = "shield_leader_titles_", --bundle prefix from effect_bundles_tables
    titles_localisation = function() -- don't touch this. 
        if _G.traits_localized_content == nil then
            return {}
        else return _G.traits_localized_content end 
    end,
    charm_level_one_trait_threshold = 1,
    charm_level_two_trait_threshold = 15,
    charm_level_three_trait_threshold = 30,
    estates_king_owner_bundle = "shield_owned_estate",
    pop_bundle_prefix = "shield_pop_bundle_",
    pop_caste_enum = {"lord", "serf", "monk", "foreign"},
    pop_natural_growth = 4,
    pop_max_growth_before_reduction = 5
}























