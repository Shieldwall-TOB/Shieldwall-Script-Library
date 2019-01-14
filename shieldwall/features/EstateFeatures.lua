local ed = _G.ed
cm:add_listener(
    "shieldwallEstateEXP",
    "CharacterTurnStart",
    function(context)
        return not ((context:character():faction():name() == "rebels") or pkm:get_character(context:character():cqi()):landless())
    end,
    function(context)
        local character =  pkm:get_character(context:character():cqi())
        for region_key, estate_pair in pairs(character._estates) do
            for building_key, estate_object in pairs(character._estates) do
                character:grow_household(ed.household_growth_exp_trigger_for_estate_building_levels(building_key), ed.household_growth_for_estate_building_level(building_key), context)
            end
        end 
        character:update_title()
    end,
    true)