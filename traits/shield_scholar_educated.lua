local tm = traits_manager.new("shield_scholar_educated")

tm:add_dilemma_flag_listener("CharacterTurnStart",
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

tm:set_loyalty_event_condition("BuildingCompleted",
function(context)
    local building = context:building()
    if building:superchain() == "vik_library" or building:superchain() == "vik_court_school" then
        return true, context:building():faction()
    end
    return false, nil
end)


tm:set_cross_loyalty("shield_scholar_wise", 1)

tm:set_start_pos_characters(
    "faction:vik_fact_west_seaxe,forename:2147363229",
    "faction:vik_fact_west_seaxe,forename:2147363108",
    "faction:vik_fact_gwined,forename:2147367296"
)