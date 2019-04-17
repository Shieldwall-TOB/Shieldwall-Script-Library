local pkm = _G.pkm

REGION_CONSCRIPT_LEVELS = {
    ["large"] = {},
    ["small"] = {},
    ["medium"] = {}
} --:map<string, vector<string>>

cm:add_listener(
    "ProvincialCapitalStartsConscriptsImpl",
    "ProvincialCapitalStartsConscripts",
    function(context)
        return context:region():owning_faction():is_human()
    end,
    function(context)
        local region = context:region() --:CA_REGION
        local pop_manager = pkm:get_region(region:name()):province_detail():get_population_manager()
        local nob_pop = pop_manager:get_pop_of_caste("lord")
        local pes_pop = pop_manager:get_pop_of_caste("serf")
        if nob_pop > 200 and pes_pop > 500 then
            cm:apply_effect_bundle_to_region("shieldwall_conscription_large", region:name(), 6)
            table.insert(REGION_CONSCRIPT_LEVELS["large"], region:name())
        elseif (nob_pop > 120) and (pes_pop > 220) then
            cm:apply_effect_bundle_to_region("shieldwall_conscription_medium", region:name(), 6)
            table.insert(REGION_CONSCRIPT_LEVELS["medium"], region:name())
        elseif (nob_pop > 60) and (pes_pop > 100) then
            cm:apply_effect_bundle_to_region("shieldwall_conscription_small", region:name(), 6)
            table.insert(REGION_CONSCRIPT_LEVELS["small"], region:name())
        end
    end,
    true
)

cm:add_listener(
    "IncidentOccuredConscripts",
    "IncidentOccuredEvent",
    function(context)
        return not not string.find(context:dilemma(), "_conscript_levy_")
    end,
    function(context)
        local incident_key = context:dilemma() --:string
        local find_key = "_conscript_levy_"
        local size = incident_key:sub(incident_key:find(find_key) + find_key:len())
        local regions = REGION_CONSCRIPT_LEVELS[incident_key:sub(incident_key:find(find_key) + find_key:len())]
        if regions then
            for i = 1, #regions do
                local c_region = dev.get_region(regions[i])
                if c_region:owning_faction():name() == context:faction():name() then
                    cm:remove_effect_bundle_from_region("shieldwall_conscription_"..size, c_region:name())
                    table.remove(regions, i)
                    local pop_manager = pkm:get_region(c_region:name()):province_detail():get_population_manager()
                    if size == "small" then
                        pop_manager:modify_population("serf", -80, "Conscription")
                        pop_manager:modify_population("lord", -40, "Military Service")
                    elseif size == "medium" then
                        pop_manager:modify_population("serf", -200, "Conscription")
                        pop_manager:modify_population("lord", -100, "Military Service")
                    elseif size == "large" then
                        pop_manager:modify_population("serf", -480, "Conscription")
                        pop_manager:modify_population("lord", -180, "Military Service")
                    end
                    break;
                end
            end
        end
    end,
    true
)



cm:register_loading_game_callback(
	function(context)
		REGION_CONSCRIPT_LEVELS = cm:load_value("REGION_CONSCRIPT_LEVELS", REGION_CONSCRIPT_LEVELS, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("REGION_CONSCRIPT_LEVELS", REGION_CONSCRIPT_LEVELS, context);
	end
);