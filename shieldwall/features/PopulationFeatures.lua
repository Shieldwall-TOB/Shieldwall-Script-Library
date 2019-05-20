local pkm = _G.pkm
POP_CACHE = {}
POP_CACHE.current_mercenary_event_region = {} --:map<string, string>
POP_CACHE.mercenary_event_failsafe_turn = {} --:map<string, number>
POP_CACHE.characters = {} --:map<string, map<string, number>>
--
cm:add_listener(
    "WritingDownShit",
    "ShortcutTriggered",
    function(context) return context.string == "camera_bookmark_view0" and CONST.__allow_test_buttons end, --default F9
    function(context)
        for province_key, province_detail in pairs(pkm:get_faction(cm:get_local_faction()):provinces()) do
            province_detail:get_population_manager():modify_population("foreign", 60, "Scripted test values", false)
        end
    end,
    true
)






cm:add_listener(
    "PopulationFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() ~= "rebels" and (context:faction():region_list():num_items() > 0)
    end,
    function(context)
        for province_key, province_detail in pairs(pkm:get_faction(context:faction():name()):provinces()) do
            province_detail:get_population_manager():evaluate_pop_growth()
        end
    end,
    true
)

--AI recruits a unit.

cm:add_listener( -- Unit trained - West Seaxe
"UnitTrained_Westsexa_Culture",
"UnitTrained",
function(context) return context:unit():faction():is_human() == false and context:unit():has_force_commander() and dev.is_char_normal_general(context:unit():force_commander()) end,
function(context) 

end,
true
);


--mercenaries dilemmas

local mercs_to_req_tech = {
    ["eng_long_axemen"] = "sw_westsexa_mil_eighth_column_1", --this is fine because only anglo saxons will ever have this tech!
    ["dan_mailed_horsemen"] = "sw_westsexa_mil_mercenary",
    ["dan_anglian_marauders"] = "sw_westsexa_mil_mercenary",
    ["dan_northumbrian_mailed_thegns"] = "sw_westsexa_mil_mercenary",
    ["eng_mailed_thegns"] = "sw_westsexa_mil_mercenary",
    ["vik_jomsvikings"] = "sw_westsexa_mil_mercenary",
    ["dan_jarls_huscarls"] = "sw_westsexa_mil_mercenary"
}--:map<string, string>
local mercs_without_tech = {"wel_mailed_axemen", "vik_thrall_axemen"} --:vector<string>

cm:add_listener("merc_incident_region_turn", "FactionTurnStart", function(context)
    if POP_CACHE.mercenary_event_failsafe_turn[context:faction():name()] and (POP_CACHE.mercenary_event_failsafe_turn[context:faction():name()] >= cm:model():turn_number()) then
        POP_CACHE.current_mercenary_event_region[context:faction():name()] = nil --this prevents mercenaries from never happening again should one of these events fail.
    end
    return context:faction():is_human() and (not POP_CACHE.current_mercenary_event_region[context:faction():name()])
end, function(context)
    local validmercs = {} --:vector<string>
    for i=1,#mercs_without_tech do table.insert(validmercs, mercs_without_tech[i]) end
    for k,v in pairs(mercs_to_req_tech) do if context:faction():has_technology(v) then table.insert(validmercs, v) end end
    for province_key, province_detail in pairs(pkm:get_faction(context:faction():name()):provinces()) do
        local mercs = province_detail:get_population_manager():get_pop_of_caste("foreign")
        if mercs > 60  then
            cm:trigger_dilemma(context:faction():name(), "sw_mercs_available_"..validmercs[cm:random_number(#validmercs)], true)
            POP_CACHE.current_mercenary_event_region[context:faction():name()] = province_key
            POP_CACHE.mercenary_event_failsafe_turn[context:faction():name()] = cm:model():turn_number() + 6
            return
        end
    end
end, true)


cm:add_listener("merc_dilemma_responce", "DilemmaChoiceMadeEvent", function(context)
    return (not not context:dilemma():find("sw_mercs_available_"))
end, function(context)
    local faction = context:faction():name()
    local province_record = POP_CACHE.current_mercenary_event_region[faction]
    if not province_record then
        dev.log("A mercenary is being granted but we have no fucking clue where it came from!", "ERR")
        return
    end
    local reason = "Recruitment"
    if context:choice() == 1 then
        reason = "Lack of Work"
    end
    local pop_manager = pkm:get_faction(faction):get_province(province_record):get_population_manager():modify_population("foreign", -40, reason, false)
    POP_CACHE.current_mercenary_event_region[context:faction():name()] = nil
    POP_CACHE.mercenary_event_failsafe_turn[context:faction():name()] = nil
end, true)


cm:add_listener("ReplenCharacterTurnEnd", "CharacterTurnEnd", function(context) return context:character():faction():is_human() and dev.is_char_normal_general(context:character()) end,
function(context) 
    local force = context:character():military_force()
    POP_CACHE.characters[tostring(context:character():command_queue_index())] = {}
    local cache_character = POP_CACHE.characters[tostring(context:character():command_queue_index())]
    for i=0,force:unit_list():num_items()-1 do
        cache_character[force:unit_list():item_at(i):unit_key()] = cache_character[force:unit_list():item_at(i):unit_key()] or 0
        cache_character[force:unit_list():item_at(i):unit_key()] = cache_character[force:unit_list():item_at(i):unit_key()] + force:unit_list():item_at(i):percentage_proportion_of_full_strength()
    end
end,
true)

cm:add_listener("ReplenCharacterTurnEnd", "CharacterTurnStart", function(context) 
    return (context:character():faction():is_human() and 
    dev.is_char_normal_general(context:character()) and 
    (not not POP_CACHE.characters[tostring(context:character():command_queue_index())]) and
    (not context:character():region():is_null_interface()))
end,
function(context) 
    local force = context:character():military_force()
    local fake_cache = {} --:map<string, number>
    for i=0,force:unit_list():num_items()-1 do
        fake_cache[force:unit_list():item_at(i):unit_key()] = fake_cache[force:unit_list():item_at(i):unit_key()] or 0
        fake_cache[force:unit_list():item_at(i):unit_key()] = fake_cache[force:unit_list():item_at(i):unit_key()] + force:unit_list():item_at(i):percentage_proportion_of_full_strength()
    end
    local cache_character = POP_CACHE.characters[tostring(context:character():command_queue_index())]
    for key, value in pairs(fake_cache) do
        if cache_character[key] then
            local old_q = cache_character[key]
            local new_q = fake_cache[key]
            if new_q > old_q then
                local replen_q = new_q - old_q
                --this is the percentage of a full unit of that type we've gained during the end turn.
                local pm = pkm:get_faction(context:character():faction():name()):get_province(context:character():region():province_name()):get_population_manager()
                pm:apply_replenishment_cost(key, replen_q)
            end
        else
            
        end
    end
end,
true)


cm:register_loading_game_callback(
	function(context)
		MERC_CONSCRIPT_REGIONS = cm:load_value("POP_CACHE", POP_CACHE, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("POP_CACHE", POP_CACHE, context);
	end
);