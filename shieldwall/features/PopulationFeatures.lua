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