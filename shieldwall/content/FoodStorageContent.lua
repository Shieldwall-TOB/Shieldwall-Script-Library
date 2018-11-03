local building_storage_effects = {
    vik_granary_1 = 25,
    vik_granary_2 = 50,
    vik_granary_3 = 75

}--: map<string, number>

local fkm = _G.fkm

for building, quantity in pairs(building_storage_effects) do
    fkm:add_food_storage_cap_effect_to_building(building, quantity)
end