local building_storage_effects = {
    vik_granary_1 = 50,
    vik_granary_2 = 75,
    vik_granary_3 = 100,
    vik_souterrain_1 = 50,
    vik_souterrain_2 = 75,
    vik_souterrain_3 = 100,
    vik_warehouse_1 = 50,
    vik_warehouse_2 = 75,
    vik_warehouse_3 = 100
}--: map<string, number>

local fm = _G.fm

for building, quantity in pairs(building_storage_effects) do
    fm.add_food_storage_cap_effect_to_building(building, quantity)
end


