local pkm = _G.pkm
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

MERC_CONSCRIPT_REGIONS = {}--:vector<string>

cm:add_listener("merc_incident_region_turn", "RegionTurnStart", function(context)
    return context:region():is_province_capital() and context:region():has_governor() and context:region():owning_faction():is_human()
end, function(context)
        local region = context:region() --:CA_REGION
        if pkm:get_region(region:name()):province_detail():get_population_manager():get_pop_of_caste("foreign") > 40 and context:region():owning_faction():has_technology("sw_westsexa_mil_mercenary") then
            table.insert(MERC_CONSCRIPT_REGIONS, region:name())
            dev.log("mercenaries becoming available in region ["..region:name().."]", "MERCS")
            cm:apply_effect_bundle_to_region("shieldwall_mercenary_choice", region:name(), 5)
        end
    end, true)

cm:add_listener("merc_dilemma_responce", "DilemmaChoiceMadeEvent", function(context)
    return not not context:dilemma():find("sw_merc_recruitment_")
end, function(context)
    if context:choice() == 0 then
        --we need to remove some pop
        for i = 1, #MERC_CONSCRIPT_REGIONS do
            local c_region = dev.get_region(MERC_CONSCRIPT_REGIONS[i])
            if c_region:owning_faction():name() == context:faction():name() then
                cm:remove_effect_bundle_from_region("shieldwall_mercenary_choice", c_region:name())
                table.remove(MERC_CONSCRIPT_REGIONS, i)
                local pop_manager = pkm:get_region(c_region:name()):province_detail():get_population_manager()
                pop_manager:modify_population("foreign", -40, "Conscription")
                break
            end
        end
    elseif context:choice() == 1 then
        --do nothing
    end
end, true)



cm:register_loading_game_callback(
	function(context)
		MERC_CONSCRIPT_REGIONS = cm:load_value("MERC_CONSCRIPT_REGIONS", MERC_CONSCRIPT_REGIONS, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("MERC_CONSCRIPT_REGIONS", MERC_CONSCRIPT_REGIONS, context);
	end
);