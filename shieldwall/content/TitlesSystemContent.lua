local charm = _G.charm

local subcultures_to_title_sets = {
    vik_sub_cult_anglo_viking = "norse",
    vik_sub_cult_english = "saxon",
    vik_sub_cult_irish = "irish",
    vik_sub_cult_scots = "scotish",
    vik_sub_cult_viking = "norse",
    vik_sub_cult_viking_gael = "norse",
    vik_sub_cult_welsh = "welsh"
} --:map<string, string>
for sc, key in pairs(subcultures_to_title_sets) do
    charm:set_title_key_for_sc(sc, key)
end

local estate_types_to_points = {
    [CONST.grand_estate_type] = 10,
    [CONST.noble_estate_type] = 2,
    [CONST.minor_estate_type] = 1
} --:map<string, number>

for type, points in pairs(estate_types_to_points) do
    charm:register_estate_type(type, points)
end

local factions_with_trait_overrides = {
        "vik_fact_gwined",
        "vik_fact_strat_clut",
        "vik_fact_dyflin",
        "vik_fact_sudreyar",
        "vik_fact_circenn",
        "vik_fact_mide",
        "vik_fact_mierce",
        "vik_fact_west_seaxe",
        "vik_fact_east_engle",
        "vik_fact_northymbre",
} --:vector<string>

for i = 1, #factions_with_trait_overrides do
    charm._leaderTitleOverrideFactions[factions_with_trait_overrides[i]] = true
end