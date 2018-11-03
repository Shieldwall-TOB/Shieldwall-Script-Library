local fkm = _G.fkm


cm:add_listener(
    "FoodStorageFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():has_home_region()
    end,
    function(context)
        local faction = context:faction() --:CA_FACTION
        local food_value = faction:total_food()
        local food_after_storage = food_value - fkm:get_food_in_storage_for_faction(faction:name())
        if food_after_storage > 0 then
            food_after_storage = math.ceil(food_after_storage/2)
        end
        fkm:mod_food_storage(faction:name(), food_after_storage)
    end,
    true
)

cm:add_listener(
    "FoodStorageFactionLostRegion",
    "FactionLostRegion",
    true,
    function(context)
        local region = context:region()
        local faction_name = context:faction():name()
        fkm:remove_region_contribution_from_faction(region:name(), faction_name)
        fkm:calc_food_storage_cap(region)
    end,
    true)

cm:add_listener(
    "FoodStorageBuildingCompleted",
    "BuildingCompleted",
    function(context)
        return fkm:does_building_have_cap_effect(context:building():name())
    end,
    function(context)
        fkm:calc_food_storage_cap(context:building():region())
    end,
    true
)


cm:register_first_tick_callback(function() 
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        local region_list = faction:region_list()
        for j = 0, region_list:num_items() - 1 do
            fkm:calc_food_storage_cap(region_list:item_at(i))
        end
        local food_value = faction:total_food()
        local food_after_storage = food_value - fkm:get_food_in_storage_for_faction(faction:name())
        food_after_storage = math.ceil(food_after_storage/4)
        fkm:mod_food_storage(faction:name(), food_after_storage)
    end
end)




