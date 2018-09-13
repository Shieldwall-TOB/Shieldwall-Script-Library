fkm = _G.fkm


local kingdoms = {
"vik_fact_gwined",
"vik_fact_strat_clut",
"vik_fact_dyflin",
"vik_fact_norse",
"vik_fact_sudreyar",
"vik_fact_circenn",
"vik_fact_normaunds",
"vik_fact_mide",
"vik_fact_mierce",
"vik_fact_west_seaxe",
"vik_fact_east_engle",
"vik_fact_northymbre",
"vik_fact_aileach"
}--:vector<string>


cm:register_first_tick_callback( function()
    for i = 1, #kingdoms do
        local faction_name = kingdoms[i]
        fkm:add_kingdom(faction_name)
        local faction_obj = cm:model():world():faction_by_key(faction_name)
        local faction_list = cm:model():world():faction_list()
        for j = 0, faction_list:num_items() - 1 do
            local potential_vassal = faction_list:item_at(j)
            if potential_vassal:is_vassal_of(faction_obj) then
                fkm:add_vassal(potential_vassal:name(), faction_name)
            end
        end
    end
end)

fkm:log("KINGDOMS CONTENT INIT COMPLETE")