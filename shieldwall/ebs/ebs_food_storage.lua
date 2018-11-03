local fkm = _G.fkm


cm:add_listener(
    "FoodStorageFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() ~= "rebels"
    end,
    function(context)
        local faction = context:faction() --:CA_FACTION
        local food_value = faction:total_food()
        local food_after_storage = food_value - fkm:get_food_in_storage_for_faction(faction:name())
        fkm:mod_food_storage(faction:name(), food_after_storage)
    end,
    true
)