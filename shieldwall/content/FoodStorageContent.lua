local building_storage_effects = {
    vik_granary_1 = 50,
    vik_granary_2 = 75,
    vik_granary_3 = 100,
    vik_souterrain_1 = 50,
    vik_souterrain_2 = 75,
    vik_souterrain_3 = 100,
    vik_warehouse_1 = 50,
    vik_warehouse_2 = 75,
    vik_warehouse_3 = 100,
    vik_warehouse_b_2 = 65,
    vik_warehouse_b_3 = 90
}--: map<string, number>

local fkm = _G.fkm

for building, quantity in pairs(building_storage_effects) do
    fkm:add_food_storage_cap_effect_to_building(building, quantity)
end