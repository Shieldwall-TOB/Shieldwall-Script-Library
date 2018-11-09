local fkm = _G.fkm
local rot = _G.rot --not directly used here but the event from the model is necessary

cm:add_listener(
    "FoodStorageFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():has_home_region() and (not (cm:model():turn_number() == 1))
    end,
    function(context)
        local faction = context:faction() --:CA_FACTION
        local food_value = faction:total_food()
        local food_after_storage = food_value - fkm:get_food_in_storage_for_faction(faction:name())
        if food_after_storage > 0 then
            food_after_storage = math.ceil(food_after_storage*CONST.food_storage_percentage)
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
        fkm:log("faction ["..faction_name.."] lost region ["..region:name().."]")
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
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local faction = dev.get_faction(humans[i])
        local region_list = faction:region_list()
        for j = 0, region_list:num_items() - 1 do
            fkm:calc_food_storage_cap(region_list:item_at(j))
        end
        local food_value = faction:total_food()
        local food_after_storage = food_value - fkm:get_food_in_storage_for_faction(faction:name())
        food_after_storage = math.ceil(food_after_storage/4)
        fkm:mod_food_storage(faction:name(), food_after_storage)
    end

end)



cm:register_saving_game_callback(function(context)
    local svtable = fkm:save_food_storage()
    cm:save_value("fkm_food_storage", svtable, context)
end)

cm:register_loading_game_callback(function(context)
    local svtable = cm:load_value("fkm_food_storage", {}, context)
    fkm:load_food_storage(svtable)
end)

cm:add_listener(
    "FoodStorageDisplay",
    "ComponentMouseOn",
    function(context)
        local HoverComponent = UIComponent(context.component)
        return uicomponent_descended_from(HoverComponent, "food") or context.string == "food"
    end,
    function(context)
        
        dev.callback(function()
            local TooltipComponent = dev.get_uic(cm:ui_root(), "FoodBreakdownTooltip")
            if not not TooltipComponent then
                local DescriptionWindow = dev.get_uic(TooltipComponent, "description_window")
                local BuildingTitle = dev.get_uic(TooltipComponent, "title_frame", "dy_building_title")
                if (not not BuildingTitle) and (not not DescriptionWindow) then
                    local faction = dev.get_faction(cm:get_local_faction(true))
                    local stores = fkm:get_food_in_storage_for_faction(faction:name())
                    local before_stores = faction:total_food() - stores
                    --storesDetail = "Your stores will increase by "..tostring(CONST.food_storage_percentage*100).." percent of your surplus food each turn"
                    local col = "green"
                    if before_stores < 0 then
                        col = "red"
                    end
                    BuildingTitle:SetStateText("[[col:"..col.."]]"..before_stores.."[[/col]] Net Food This Turn")
                    --oldText = DescriptionWindow:GetStateText()

                    if before_stores >= 0 then
                        local raw_change = (before_stores*CONST.food_storage_percentage)
                        local cap = fkm:get_food_storage_cap_for_faction(faction:name())
                        local increase_val = fkm:calculate_potential_food_change(stores, cap, raw_change)
                        DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your stores will increase by [[col:green]]"..increase_val.."[[/col]] next turn.")
                    else
                        local cap = fkm:get_food_storage_cap_for_faction(faction:name())
                        local decrease_val = fkm:calculate_potential_food_change(stores, cap, before_stores)
                        DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your Stores will decrease by [[col:red]]"..decrease_val.."[[/col]] next turn.")
                    end
                end
            end
        end, 0.1)
    end,
    true
)