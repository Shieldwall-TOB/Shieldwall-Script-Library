local ed = _G.ed

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
        local region_detail = pkm:get_region(context:region():name())
        if region_is_royal_estate(region_detail) then
            region_detail:apply_effect_bundle(CONST.estates_king_owner_bundle)
        else
            region_detail:remove_effect_bundle(CONST.estates_king_owner_bundle)
        end
    end,
    true
)

cm:add_listener(
    "ShieldCharacterAssignedEstate",
    "CharacterAssignedEstate",
    true,
    function(context)
        pkm:log("Character ["..tostring(context:character():cqi()).."] was just granted an estate at ["..context:estate():region():name().."]")
        local ca_estate = context:estate() --:CA_ESTATE
        local region = pkm:get_region(ca_estate:region():name())
        local character = context:character():cqi()
        for chain, estate in pairs(region:estates()) do
            if not estate:has_owner() then
                estate:appoint_owner(pkm:get_character(context:character():faction():faction_leader():cqi()))
            end
            if estate:owner():cqi() ~= character and estate:estate_type() == ca_estate:estate_record_key() then
                local new_char_det = pkm:get_character(character)
                estate:owner():remove_estate(region:name(), estate:chain(), new_char_det)
                pkm:log("\tSuccessfully found and granted the estate")
                new_char_det:update_title()
                region:remove_effect_bundle(CONST.estates_king_owner_bundle)
                return
            end
        end
    end,
    true
)

cm:add_listener(
    "ShieldCharacterStrippedOfEstate",
    "CharacterStrippedOfEstate",
    true,
    function(context)
        pkm:log("Character ["..tostring(context:character():cqi()).."] was just stripped of estate ["..context:estate():region():name().."]")
        local ca_estate = context:estate() --:CA_ESTATE
        local region = ca_estate:region():name()
        local character = context:character()
        local char_det = pkm:get_character(character:cqi())
        for chain, estate in pairs(char_det:estates()[region]) do
            if estate:has_owner() then
                if estate:estate_type() == ca_estate:estate_record_key() then
                    local new_char_det = pkm:get_character(context:character():faction():faction_leader():cqi())
                    char_det:remove_estate(region, estate:chain(), new_char_det)
                    pkm:log("\tSuccessfully found and stripped the estate")
                    char_det:update_title()
                    pkm:get_region(region):apply_effect_bundle(CONST.estates_king_owner_bundle)
                    return
                end
            end
        end
    end,
    true
)