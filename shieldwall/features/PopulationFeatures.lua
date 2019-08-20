local pkm = _G.pkm
POP_CACHE = {}
POP_CACHE.current_mercenary_event_region = {} --:map<string, string>
POP_CACHE.mercenary_event_failsafe_turn = {} --:map<string, number>
POP_CACHE.characters = {} --:map<string, map<string, number>>





dev.first_tick(function(context)
cm:add_listener(
    "PopulationFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() ~= "rebels" and (context:faction():region_list():num_items() > 0)
    end,
    function(context)
        local faction = context:faction()
        pkm:get_faction(faction:name()):update_population()
    end,
    true
)

cm:add_listener(
    "PopulationFactionTurnEnd",
    "FactionTurnEnd",
    function(context)
        return context:faction():is_human() 
    end,
    function(context)
        local faction = context:faction()
        pkm:get_faction(faction:name()):cache_replenishment()
    end,
    true
)

cm:add_listener(
    "PopulationBeingRaided",
    "CharacterTurnEnd",
    function(context)
        local character = context:character()
        return (not character:region():is_null_interface()) and character:region():owning_faction():is_human() 
        and character:has_military_force() and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID"
    end,
    function(context)
        local region = context:character():region()
        local faction_name = region:owning_faction():name()
        local pop_manager = pkm:get_faction(faction_name):pop_manager_by_key("serf")
        pop_manager:apply_unrest(region:province_name())
    end,
    true
)




end)






--AI recruits a unit.



--mercenaries dilemmas
--[[
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

--]]
