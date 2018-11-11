local charm = _G.charm

local subcultures_to_title_sets = {
    vik_sub_cult_anglo_viking = "_norse",
    vik_sub_cult_english = "_saxon",
    vik_sub_cult_irish = "_irish",
    vik_sub_cult_scots = "_scotish",
    vik_sub_cult_viking = "_norse",
    vik_sub_cult_viking_gael = "_norse",
    vik_sub_cult_welsh = "_welsh"
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