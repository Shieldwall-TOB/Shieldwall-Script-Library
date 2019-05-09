local pkm = _G.pkm
--v function(t: any)
local function log(t)
    dev.log(tostring(t), "TRT")
end

--v function(char: CA_CHAR, trait_name: string)
local function apply_trait_dilemma_for_character(char, trait_name)
    if not char:faction():is_human() then
        return 
    end
    if (not char:has_trait(trait_name)) and (not char:has_trait(trait_name.."_flag")) then
        cm:force_add_trait(dev.lookup(char) ,trait_name.."_flag", false)
        dev.log("Added trait trigger ["..trait_name.."] to character ["..tostring(char:command_queue_index()).."] from faction ["..char:faction():name().."] ")
        if cm:model():world():whose_turn_is_it() == char:faction():name() and (not cm:get_saved_value("trait_trigger_last_turn") == cm:model():turn_number()) then
            cm:trigger_dilemma(char:faction():name(), trait_name.."_choice", true)
            cm:set_saved_value("trait_trigger_last_turn", cm:model():turn_number())
        end
    end
end

--v function (trait_name: string, event: string, conditional_function: function(context: WHATEVER) --> (boolean, CA_CHAR))
local function trait_listener(trait_name, event, conditional_function)
    cm:add_listener(
        "TraitTrigger"..trait_name,
        event,
        true,
        function(context)
            log("Evaluating trait validity ".. trait_name)
            local valid, char = conditional_function(context)
            if valid then
                log("Trait dilemma trigger is valid!")
                apply_trait_dilemma_for_character(char, trait_name)
            else
                log("invalid trigger")
                if char:has_trait(trait_name.."_flag") then
                    cm:force_remove_trait(dev.lookup(char), trait_name.."_flag")
                end
            end
        end,
        true
        
    )

end


--Does this character have a brutish or tyranical trait?
--v function(char: CA_CHAR) --> boolean
function is_char_brute_or_tyrant(char)
    local sinful_traits = {
        "shield_brute_bloodythirsty",
        "shield_brute_corrupt",
        "shield_brute_legendary_brute",
        "shield_brute_violent",
        "shield_tyrant_legendary_tyrant",
        "shield_tyrant_oppressor",
        "shield_tyrant_subjugator",
        "shield_tyrant_treasonous"
    } --:vector<string>
    for i = 1, #sinful_traits do
        if char:has_trait(sinful_traits[i]) then
            return true
        end
    end
    return false
end

--is the character a pagan?
--v function(char: CA_CHAR) --> boolean
function is_char_or_char_king_pagan(char)
    if char:faction():name() == "rebels" then
        return false
    end
    local faction_leader = char:faction():faction_leader()
    return char:has_trait("shield_heathen_pagan") or faction_leader:has_trait("shield_heathen_pagan")
end


dev.first_tick(function(context)
--removes flags after a trait choice so that you don't get spammed with the same one.
    cm:add_listener(
    "DilemmaChoiceMadeEventRemoveFlags",
    "DilemmaChoiceMadeEvent",
    function(context)
        return ( not not context:dilemma():find("_choice"))
    end,
    function(context)
        local trait = context:dilemma():gsub("_choice", "_flag")
        for i = 0, context:faction():character_list():num_items() - 1 do
            local char = context:faction():character_list():item_at(i)
            if char:has_trait(trait) then
                cm:force_remove_trait(dev.lookup(char), trait) --ensures we don't repeat the same event over and over
            end
        end
    end,
    true
    )


trait_listener(
    "shield_faithful_repentent",
    "CharacterTurnStart",
    function(context)
        --must be in a religious settlement.
        local region = context:character():region()
        if region:is_null_interface() or region:owning_faction():name() ~= context:character():faction():name() then
            return false, nil
        end
        local pop_manager = pkm:get_region(region:name()):province_detail():get_population_manager()
        local is_in_religious_settlement =  (pop_manager:get_pop_of_caste("monk") > 30)
        --must have at least one bad trait
        local has_bad_trait = is_char_brute_or_tyrant(context:character())
        --must not be a pagan
        local not_pagan = not is_char_or_char_king_pagan(context:character())
        return (is_in_religious_settlement and has_bad_trait and not_pagan), context:character()
    end)


trait_listener(
    "shield_scholar_educated",
    "CharacterTurnStart",
    function(context)
        --needs to have a dad
        local has_daddy_to_pay_tuition_money = context:character():family_member():has_father()
        --needs to be the right age
        local is_correct_age = (context:character():age() > 10) and  (context:character():age() < 20)
        --needs to be a potential general/governor
        local period_accurate_sexism = context:character():is_male()
        return (is_correct_age and period_accurate_sexism), context:character()
        --return has_daddy_to_pay_tuition_money and is_correct_age and period_accurate_sexism--]]
    end)


---doubled up one
    trait_listener(
    "shield_scholar_wiseTrigger",
    "ResearchCompleted",
    function(context)
        return (context:faction():faction_leader():has_trait("shield_scholar_educated") and context:faction():faction_leader():age() > 40), context:faction():faction_leader()
    end)

--ends

--[[
cm:add_listener(
    "shield_faithful_repententTrigger",
    "CharacterTurnStart",
    function(context)
        return true
    end,
    function(context)
        apply_trait_dilemma_for_character(context:character(), "shield_faithful_repentent")
    end,
    true
)--]]


cm:add_listener(
    "shieldwallTitles",
    "CharacterTurnStart",
    function(context)
        return not ((context:character():faction():name() == "rebels") or pkm:get_character(context:character():command_queue_index()):landless())
    end,
    function(context)
        local character =  pkm:get_character(context:character():command_queue_index())
        character:update_title()
    end,
    true)





end)