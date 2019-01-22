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
            for building_chain, estate_object in pairs(estate_pair) do
                local level = estate_object:building()
                character:grow_household(ed.household_growth_exp_trigger_for_estate_building_levels(level), ed.household_growth_for_estate_building_level(level), context)
            end
        end 
        character:update_title()
    end,
    true)


cm:add_listener(
    "shieldwallEstateOwned",
    "RegionTurnStart",
    function(context)
        local region = context:region() --:CA_REGION 
        return (not region:settlement():is_null_interface()) and (not region:owning_faction():is_null_interface())
    end,
    function(context)
        --v function(region_detail: REGION_DETAIL) --> boolean
        local function region_is_royal_estate(region_detail)
            local estates = region_detail:estates()
            for building_chain, estate_object in pairs(estates) do
                local owner = dev.get_character(pkm:get_estate_owner(estate_object:region_name(), estate_object:chain()):cqi())
                if owner:is_heir() or owner:is_faction_leader() then
                    return true
                end
            end
            return false
        end

        local region_detail = pkm:get_region(context:region():name())
        if region_is_royal_estate(region_detail) then
            region_detail:apply_effect_bundle(CONST.estates_king_owner_bundle)
        else
            region_detail:remove_effect_bundle(CONST.estates_king_owner_bundle)
        end
    end,
    true
)


