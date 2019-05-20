local pkm = _G.pkm
ALREADY_TRIGGERED_TRAITS = {} --:map<string, map<string, boolean>>
TRAITS_OUT_FOR_TRIGGER = {} --:map<string, boolean>

--v function(t: any)
local function log(t)
    dev.log(tostring(t), "TRT")
end

--sets up a character to recieve a trait dilemma or incident.
--v function(char: CA_CHAR, trait_name: string)
local function apply_trait_dilemma_for_character(char, trait_name)
    if not char:faction():is_human() then
        return 
    end
    if (not char:has_trait(trait_name)) and (not char:has_trait(trait_name.."_flag")) then
        cm:force_add_trait(dev.lookup(char) ,trait_name.."_flag", false)
        dev.log("Added trait trigger ["..trait_name.."] to character ["..tostring(char:command_queue_index()).."] from faction ["..char:faction():name().."] ")
        TRAITS_OUT_FOR_TRIGGER[trait_name] = true
    end
end

--v function (trait_name: string, event: string, conditional_function: function(context: WHATEVER) --> (boolean, CA_CHAR!), on_trigger: (function(cqi: CA_CQI,context: WHATEVER))?)
local function trait_listener(trait_name, event, conditional_function, on_trigger)
    local flag = trait_name.."_flag"
    ALREADY_TRIGGERED_TRAITS[flag] = ALREADY_TRIGGERED_TRAITS[flag] or {}
    cm:add_listener(
        "TraitTrigger"..trait_name,
        event,
        function(context)
            return TRAITS_OUT_FOR_TRIGGER[trait_name] ~= true
        end,
        function(context)
            log("Evaluating trait validity ".. trait_name)
            local valid, char = conditional_function(context)
            if char:faction():is_human() then
                if ALREADY_TRIGGERED_TRAITS[flag][tostring(char:command_queue_index())] then
                    log("already occured for character")
                    if char:has_trait(flag) then
                        cm:force_remove_trait(dev.lookup(char), flag)
                    end
                    return
                end
                if valid then
                    log("Trait dilemma trigger is valid!")
                    apply_trait_dilemma_for_character(char, trait_name)
                else
                    log("invalid trigger")
                    if char:has_trait(flag) then
                        cm:force_remove_trait(dev.lookup(char), flag)
                    end
                end
            elseif valid and cm:random_number(25) > 20 then
                log("ai chance passed")
                cm:force_add_trait(dev.lookup(char),trait_name, false)
            elseif valid then
                log("ai chance failed")
            else
                log("invalid trigger")
            end
        end,
        true
        
    )
    --removes flags after a trait choice so that you don't get spammed with the same one.
    cm:add_listener(
        "DilemmaChoiceMadeEventRemoveFlagsTraitName",
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:dilemma() == trait_name.."_choice"
        end,
        function(context)
            for i = 0, context:faction():character_list():num_items() - 1 do
                local char = context:faction():character_list():item_at(i)
                if char:has_trait(flag) then
                    if on_trigger then
                        --# assume on_trigger: function(cqi: CA_CQI,context: WHATEVER)
                        on_trigger(char:command_queue_index(), context)
                    end
                    cm:force_remove_trait(dev.lookup(char), flag) --ensures we don't repeat the same event over and over
                    ALREADY_TRIGGERED_TRAITS[flag][tostring(char:command_queue_index())] = true --saves the fact its happened for this character
                    TRAITS_OUT_FOR_TRIGGER[trait_name] = false -- lets the event happen to other characters again
                end
            end
        end, true)
    cm:add_listener(
        "IncidentOccuredEventRemoveFlags",
        "IncidentOccuredEvent",
        function(context)
            return context:dilemma() == trait_name.."_event"
        end,
        function(context)
            for i = 0, context:faction():character_list():num_items() - 1 do
                local char = context:faction():character_list():item_at(i)
                if char:has_trait(flag) then
                    if on_trigger then
                        --# assume on_trigger: function(cqi: CA_CQI,context: WHATEVER)
                        on_trigger(char:command_queue_index(), context)
                    end
                    cm:force_remove_trait(dev.lookup(char), flag) --ensures we don't repeat the same event over and over
                    ALREADY_TRIGGERED_TRAITS[flag][tostring(char:command_queue_index())] = true --saves the fact its happened for this character
                    TRAITS_OUT_FOR_TRIGGER[trait_name] = false -- lets the event happen to other characters again
                end
            end
        end, true)

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

--v function(char: CA_CHAR) --> boolean
function does_char_have_anti_tyrant_or_brute_traits(char)
    local traits_hate_tyrants = {
        "shield_scholar_wise",
        "shield_faithful_charitable",
        "shield_faithful_repentent",
        "shield_scholar_legendary_thinker",
        "shield_faithful_legendary_saint",
        "shield_judge_just",
        "shield_judge_lawful",
        "shield_judge_honourable",
        "shield_elder_beloved",
    }--:vector<string>
    for i = 1, #traits_hate_tyrants do
        if char:has_trait(traits_hate_tyrants[i]) then
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

--remove the sinful traits of this character
--v function(char: CA_CHAR)
function remove_sinful_traits_for_repentence(char)
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
            cm:force_remove_trait(dev.lookup(char), sinful_traits[i])
        end
    end
end

--does this region have a court building?
--v function(region: CA_REGION) --> boolean
function does_region_have_court(region)
    local courts = {
        "vik_court_school_1",
        "vik_court_school_2",
        "vik_court_school_3",
        "vik_court_1",
        "vik_court_2",
        "vik_court_3"
    } --:vector<string>
    for i = 1, #courts do
        if region:building_exists(courts[i]) then
            return true
        end
    end
    return false
end

--how many scholarly traits does this character have?
--v function(char: CA_CHAR) --> number
function count_scholar_traits_on_character(char)
    local scholar_traits = {
        "shield_scholar_educated",
        "shield_scholar_wise",
        "shield_scholar_lawyer",
        "shield_scholar_legendary_thinker"
    } --:vector<string>
    local ret = 0 --:number
    for i = 1, #scholar_traits do
        if char:has_trait(scholar_traits[i]) then
            ret = ret + 1
        end
    end
    return ret
end

--how many brute traits does this character have?
--v function(char: CA_CHAR) --> number
function count_brute_traits_on_character(char)
    local brute_traits = {
        "shield_brute_violent",
        "shield_brute_bloodythirsty",
        "shield_brute_corrupt",
        "shield_brute_legendary_brute"
    } --:vector<string>
    local ret = 0 --:number
    for i = 1, #brute_traits do
        if char:has_trait(brute_traits[i]) then
            ret = ret + 1
        end
    end
    return ret
end

--how many tyrant traits does this character have?
--v function(char: CA_CHAR) --> number
function count_tyrant_traits_on_character(char)
    local tyrant_traits = {
        "shield_tyrant_subjugator",
        "shield_tyrant_oppressor",
        "shield_tyrant_treasonous",
        "shield_tyrant_legendary_tyrant"
    } --:vector<string>
    local ret = 0 --:number
    for i = 1, #tyrant_traits do
        if char:has_trait(tyrant_traits[i]) then
            ret = ret + 1
        end
    end
    return ret
end

--how many heathen traits does this character have?
--v function(char: CA_CHAR) --> number
function count_heathen_traits_on_character(char)
    local heathen_traits = {
        "shield_heathen_old_ways",
        "shield_heathen_sailor",
        "shield_heathen_legendary_bearskin",
        "shield_heathen_legendary_wolfskin",
        "shield_heathen_beast_slayer"
    } --:vector<string>
    local ret = 0 --:number
    for i = 1, #heathen_traits do
        if char:has_trait(heathen_traits[i]) then
            ret = ret + 1
        end
    end
    return ret
end

--how many heathen traits does this character have?
--v function(char: CA_CHAR) --> number
function count_saint_traits_on_character(char)
    local saint_traits = {
        "shield_faithful_charitable",
        "shield_faithful_repentent",
        "shield_faithful_friend_of_the_church",
        "shield_faithful_legendary_saint"
    } --:vector<string>
    local ret = 0 --:number
    for i = 1, #saint_traits do
        if char:has_trait(saint_traits[i]) then
            ret = ret + 1
        end
    end
    return ret
end

--what is the distance between two points?
--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;


--is there a church nearby?
--v function(char: CA_CHAR) --> boolean
function is_any_church_nearby(char)
    local church_superchains = {
        "vik_abbey",
        "vik_church",
        "vik_monastery",
        "vik_nunnaminster",
        "vik_school_ros",
        "vik_scoan_abbey"
       --[[ "vik_st_brigit",
        "vik_st_ciaran",
        "vik_st_columbe",
        "vik_st_cuthbert",
        "vik_st_dewi",
        "vik_st_edmund",
        "vik_st_patraic",
        "vik_st_ringan",
        "vik_st_swithun" 
        we check for these using string.find to save time--]] 
    }
    local char_faction_regions = char:faction():region_list()
    local x, y = char:logical_position_x(), char:logical_position_y()
    if char_faction_regions:is_empty() then
        return false
    else
        for i = 0, char_faction_regions:num_items() - 1 do
            local current_region = char_faction_regions:item_at(i)
            local superchain = current_region:settlement():slot_list():item_at(0):building():superchain()
            local xb, yb = current_region:settlement():logical_position_x(), current_region:settlement():logical_position_y()
            if string.find(superchain, "_st_") then
                return (distance_2D(x, y, xb, yb) < 200)
            else
                for j = 1, #church_superchains do
                    if church_superchains[j] == superchain then
                        return (distance_2D(x, y, xb, yb) < 200)
                    end
                end
            end
        end
    end
    return false
end

--v function(character: CA_CHAR) --> boolean
function does_char_region_have_saint_building(character)
    local saints = {"vik_nunnaminster",
    "vik_school_ros",
    "vik_scoan_abbey",
    "vik_st_brigit",
    "vik_st_ciaran",
    "vik_st_columbe",
    "vik_st_cuthbert",
    "vik_st_dewi",
    "vik_st_edmund",
    "vik_st_patraic",
    "vik_st_ringan",
    "vik_st_swithun" 
    }--:vector<string>
    local region = character:region()
    if region:is_null_interface() then
        return false
    else
        for i = 1, #saints do
            if region:building_superchain_exists(saints[i]) then
                return true
            end
        end
    end
    return false
end



--v function(char: CA_CHAR) --> boolean
function is_char_from_viking_faction(char)
    local viking_sc = {
        vik_sub_cult_viking_gael = true,
        vik_sub_cult_anglo_viking = true
    } --:map<string, boolean>
    return not not viking_sc[char:faction():subculture()]
end
dev.first_tick(function(context)

    trait_listener(
        "shield_faithful_repentent",
        "CharacterTurnStart",
        function(context)
            --must be in a religious settlement.
            local region = context:character():region()
            if region:is_null_interface() or region:owning_faction():name() ~= context:character():faction():name() then
                return false, context:character()
            end
            local pop_manager = pkm:get_region(region:name()):province_detail():get_population_manager()
            local is_in_religious_settlement =  (pop_manager:get_pop_of_caste("monk") > 30)
            --must have at least one bad trait
            local has_bad_trait = is_char_brute_or_tyrant(context:character())
            --must not be a pagan
            local not_pagan = not is_char_or_char_king_pagan(context:character())
            return (is_in_religious_settlement and has_bad_trait and not_pagan), context:character()
        end,
        function(cqi, context)
            local char = dev.get_character(cqi)
            if context:choice() == 0 then
                remove_sinful_traits_for_repentence(char)   
            end
        end)

    trait_listener(
        "shield_faithful_charitable",
        "CharacterTurnStart",
        function(context)
            local char = context:character()
            return ((not is_char_brute_or_tyrant(char)) and (not is_char_or_char_king_pagan(char)) and char:faction():total_food() < 30 and is_any_church_nearby(char)), char
        end 
    )
    trait_listener(
        "shield_faithful_friend_of_the_church",
        "CharacterTurnStart",
        function(context)
            local char = context:character()
            return ((not char:has_trait("shield_heathen_pagan")) and is_any_church_nearby(char) and (char:is_faction_leader() or char:loyalty() < 7)), char 
        end
    )


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
        trait_listener(
            "shield_noble_princely",
            "CharacterTurnStart",
            function(context)
                local char = context:character() --:CA_CHAR
                if context:character():is_heir() and context:character():age() < 20 then
                    return true, char
                else
                    return false, char
                end
            end)
    trait_listener(
        "shield_scholar_lawyer",
        "CharacterTurnStart",
        function(context)
            local char = context:character() --:CA_CHAR
            if (not char:region():is_null_interface()) and char:age() > 30 and char:has_trait("shield_scholar_educated") and does_region_have_court(char:region()) then
                return true, char
            else
                return false, char
            end
        end
    )
    trait_listener(
        "shield_scholar_legendary_thinker",
        "CharacterTurnStart",
        function(context)
            return ((count_scholar_traits_on_character(context:character()) > 2) and context:character():rank() > 7), context:character()
        end
    )

    trait_listener(
    "shield_scholar_wise",
    "ResearchCompleted",
    function(context)
        return (context:faction():faction_leader():has_trait("shield_scholar_educated") and context:faction():faction_leader():age() > 40), context:faction():faction_leader()
    end)

    trait_listener(
        "shield_noble_proud",
        "GarrisonOccupiedEvent",
        function(context)
            local char = context:character() --:CA_CHAR
            return (context:garrison_residence():region():is_province_capital() and char:gravitas() > 7), char
        end)

    trait_listener(
        "shield_noble_high_born",
        "CharacterTurnStart",
        function(context)
            local char = context:character()
            if pkm:get_character(char:command_queue_index()):get_title_points() == 3 then
                return true, char
            elseif char:family_member():has_father() and char:family_member():father():has_trait("shield_noble_high_born") then
                return true, char
            end
            return false, char
        end
    )

    trait_listener(
        "shield_tyrant_subjugator",
        "GarrisonOccupiedEvent",
        function(context)
            local char = context:character() --:CA_CHAR
            local chance = cm:random_number(100) < 50 --50%
            local own_allegience_region = (context:region():majority_religion() == char:faction():state_religion())
            return chance and (not does_char_have_anti_tyrant_or_brute_traits(char)), char
        end
    )

    trait_listener(
        "shield_brute_violent",
        "SettlementSacked",
        function(context)
            local char = context:character() --:CA_CHAR
            local chance = cm:random_number(100) < 30 --30%
            return chance and (not does_char_have_anti_tyrant_or_brute_traits(char)), char
        end
    )

    trait_listener(
        "shield_brute_legendary_brute",
        "CharacterTurnStart",
        function(context)
            return count_brute_traits_on_character(context:character()) >= 2, context:character()
        end
    )

    trait_listener(
        "shield_heathen_sailor",
        "CharacterTurnStart",
        function(context)
            local chance = 3 --:number
            local char = context:character() --:CA_CHAR
            if dev.is_char_normal_general(char) and char:turns_at_sea() then
                chance = chance * char:turns_at_sea()
                if is_char_from_viking_faction(char) then
                    chance = chance*2
                end
                return cm:random_number(100) < chance, char
            else
                return false, char
            end
        end)

    trait_listener(
        "shield_heathen_old_ways",
        "CharacterTurnStart",
        function(context)
            local chance = 2 --:number
            local char = context:character() --:CA_CHAR
            if not is_char_from_viking_faction(char) then
                return false, char
            end
            if not char:faction():is_human() then
                return cm:random_number(100) > 10, char
            end
            local list = dev.faction_list()
            for i = 0, list:num_items() - 1 do
                if char:faction():name() ~= list:item_at(i):name() then
                    if char:faction():is_trading_with(list:item_at(i)) then
                        chance = chance + 4
                    end
                end
            end
            local list = char:faction():character_list()
            for i = 0, list:num_items() - 1 do 
                if not (list:item_at(i):command_queue_index() == char:command_queue_index()) then
                    chance = chance + count_heathen_traits_on_character(list:item_at(i))
                end
            end
            return cm:random_number(100) < chance, char
        end
    )

    trait_listener(
        "shield_faithful_legendary_saint",
        "CharacterTurnStart",
        function(context)
            local char = context:character() --:CA_CHAR
            local bad_trait_sum = count_brute_traits_on_character(char) + count_heathen_traits_on_character(char) + count_tyrant_traits_on_character(char)
            return does_char_region_have_saint_building(char) and count_saint_traits_on_character(char) > 2 and bad_trait_sum == 0, char
        end )


--ends



cm:add_listener(
    "shieldwallTitles",
    "CharacterTurnStart",
    function(context)
        return not ((context:character():faction():name() == "rebels") or pkm:get_character(context:character():command_queue_index()):landless())
    end,
    function(context)
        local character =  pkm:get_character(context:character():command_queue_index())
        character:update_title(false)
        character:update_character_friendship()
    end,
    true)


end)


cm:register_loading_game_callback(
    function(context)
        TRAITS_OUT_FOR_TRIGGER = cm:load_value("TRAITS_OUT_FOR_TRIGGER", {}, context);
		ALREADY_TRIGGERED_TRAITS = cm:load_value("ALREADY_TRIGGERED_TRAITS", {}, context);
	end
);

cm:register_saving_game_callback(
	function(context)
        cm:save_value("TRAITS_OUT_FOR_TRIGGER", TRAITS_OUT_FOR_TRIGGER, context);
        cm:save_value("ALREADY_TRIGGERED_TRAITS", ALREADY_TRIGGERED_TRAITS, context);
	end
);

