fd = _G.fd
pkm = _G.pkm

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
"vik_fact_aileach",
"vik_fact_dene",
"vik_fact_northleode", 
"vik_fact_orkneyar",
"vik_fact_ulaid"
}--:vector<string>

for i = 1, #kingdoms do
    local faction_name = kingdoms[i]
    fd.make_faction_major(faction_name)
end
dev.pre_first_tick( function(context)
    for i = 1, #kingdoms do
        local faction_name = kingdoms[i]
        local faction_obj = cm:model():world():faction_by_key(faction_name)
        local faction_list = cm:model():world():faction_list()
        local faction_det = pkm:get_faction(faction_name)
        for j = 0, faction_list:num_items() - 1 do
            local potential_vassal = faction_list:item_at(j)
            if not (potential_vassal:name() == faction_name) then            
                if potential_vassal:is_vassal_of(faction_obj) then
                    pkm:grant_faction_vassal(faction_name,potential_vassal:name())
                end
            end
        end
    end
end)

