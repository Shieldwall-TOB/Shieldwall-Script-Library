local pkm = _G.pkm
cm:add_listener(
    "FoodStorageFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() and context:faction():has_home_region() and (not (cm:model():turn_number() == 1)) 
    end,
    function(context)
        local faction = context:faction() --:CA_FACTION
        local fm = pkm:get_faction(faction:name()):get_food_manager()
        fm:update_food_storage()
    end,
    true
)
--[[ --TODO make food storage react to losing regions
cm:add_listener(
    "FoodStorageFactionLostRegion",
    "FactionLostRegion",
    true,
    function(context)
        local region = context:region()
        local faction_name = context:faction():name()
        local fm = pkm:get_faction(faction_name):get_food_manager()
        fm:log("faction ["..faction_name.."] lost region ["..region:name().."]")
        fm:remove_region_contribution(region:name())
        fm:calc_food_storage_cap(region)
    end,
    true)


cm:add_listener(
    "FoodStorageBuildingCompleted",
    "BuildingCompleted",
    function(context)
        local fm = pkm:get_faction(context:building():region():owning_faction():name()):get_food_manager()
        return fm:has_food_storage_cap_effect(context:building():name())
    end,
    function(context)
        local fm = pkm:get_faction(context:building():region():owning_faction():name()):get_food_manager()
        fm:calc_food_storage_cap(context:building():region())
    end,
    true
)--]]


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
                local faction = dev.get_faction(cm:get_local_faction(true))
                local fm = pkm:get_faction(faction:name()):get_food_manager()
                local stores = fm:food_in_storage()
                local stores_drawn = fm:food_being_drawn()
                local before_stores = faction:total_food() - stores_drawn
                --storesDetail = "Your stores will increase by "..tostring(CONST.food_storage_percentage*100).." percent of your surplus food each turn"
                local col = "green"
                if before_stores < 0 then
                    col = "red"
                end
                BuildingTitle:SetStateText("[[col:"..col.."]]"..before_stores.."[[/col]] Net Food This Turn")
                --oldText = DescriptionWindow:GetStateText()

                if before_stores >= stores_drawn then
                    local raw_change = (before_stores*CONST.food_storage_percentage)
                    local cap = fm:food_store_cap()
                    local increase_val = fm:calculate_potential_food_change(stores, cap, raw_change)
                    DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your stores will increase by [[col:green]]"..increase_val.."[[/col]] next turn.")
                else
                    local cap = fm:food_store_cap()
                    local decrease_val = stores_drawn
                    DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your Stores will decrease by [[col:red]]"..decrease_val.."[[/col]] next turn.")
                end
            end
        end, 0.1)
    end,
    true
)