return {
    __write_output_to_logfile = true,
    __should_output_ui = false,
    __log_game_objects = false,
    __no_fog = true,
    __log_settlements = true,
    __log_characters = true,
    enable_great_kingdom_bonus = true,
    default_estate_type = "vik_estate_agricultural",
    noble_estate_type = "vik_estate_estate_building",
    minor_estate_type = "vik_estate_agricultural",
    grand_estate_type = "vik_estate_religious",
    food_storage_cap_absolute = 2000,
    food_storage_cap_base = 175,
    food_storage_bundle = "shield_food_storage_bundle_",
    food_storage_percentage = 0.5,
    region_wealth_bundle = "shield_wealth_bundle_",
    region_wealth_cap = 3,
    region_wealth_floor = 0,
    season_bundle_prefix = "shield_season_",
    charm_minor_noble_threshold = 1,
    charm_middle_noble_threshold = 5,
    charm_great_noble_threshold = 10,
    charm_title_prefix = "shield_title_",
    charm_leader_title_prefix = "shield_leader_titles_",
    titles_localisation = function()
        if _G.traits_localized_content == nil then
            return {}
        else return _G.traits_localized_content end 
    end
}























