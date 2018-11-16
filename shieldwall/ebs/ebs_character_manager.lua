local charm = _G.charm



cm:register_loading_game_callback(function(context) 
    local sv_table = cm:load_value("character_manager_save", {}, context)
    for key, value in pairs(sv_table) do
        charm:load_character(value)
    end
end)


cm:register_saving_game_callback(function(context)
    local sv_table = {} --:map<string, CHAR_SAVE>
    for cqi, char in pairs(charm._characterData) do
        local char_save = char:save()
        sv_table[char_save._cqi] = char_save
    end
    cm:save_value("character_manager_save", sv_table, context)
end)


cm:add_listener(
    "CharManagerEstateGained",
    "CharacterGainedEstate",
    true,
    function(context)
        local char = context:character():cqi()
        local estate = context:shield_estate()
        charm:get_character(char):add_estate(estate)
    end,
    true
)

cm:add_listener(
    "CharManagerEstateLost",
    "CharacterLostEstate",
    true,
    function(context)
        local char = context:character():cqi()
        local estate = context:shield_estate()
        charm:get_character(char):remove_estate(estate)
    end,
    true
)

cm:add_listener(
    "CharManagerEstateProcessor",
    "FactionTurnStart",
    true,
    function(context)
        local char_list = context:faction():character_list()
        for i = 0, char_list:num_items() - 1 do
            local character = char_list:item_at(i)
            --if not character:is_faction_leader() then
                charm:update_title_for_character(character:cqi())
            --end
        end
    end,
    true
)


dev.post_first_tick(function(context) 
    local humans = cm:get_human_factions()
    for j = 1, #humans do
        local char_list = dev.get_faction(humans[j]):character_list()
        for i = 0, char_list:num_items() - 1 do
            local character = char_list:item_at(i)
            charm:update_title_for_character(character:cqi())
        end
    end
end)

local cancel_order = false --:boolean

cm:add_listener(
    "RegionSelectedTitlesUI",
    "SettlementSelected",
    function(context)
        return context:garrison_residence():faction():is_human() and context:garrison_residence():region():has_governor() and (not cancel_order)
    end,
    function(context)
        local cqi = context:garrison_residence():region():governor():cqi()
        dev.callback(
            function()
                local panel = dev.get_uic(cm:ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "subpanel_character")
                if not not panel then
                    cancel_order = true
                    local title = dev.get_uic(panel, "dy_title")
                    local name = dev.get_uic(panel, "dy_name")
                    local old_title = title:GetStateText()
                    local old_name = name:GetStateText()
                    if old_title and old_name then 
                        name:SetStateText(old_name.."; " ..old_title)
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end
                    local title_trait = charm:get_character(cqi):current_title()
                    if not (CONST.titles_localisation()[title_trait] == nil) then
                        title:SetStateText(CONST.titles_localisation()[title_trait])
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end
                    cancel_order = false 
                end
            end, 0.1
        )
    end,
    true
)


cm:add_listener(
    "CharacterSelectedTitlesUI",
    "CharacterSelected",
    function(context)
        return context:character():faction():is_human() and context:character():has_military_force() and (not cancel_order)
    end,
    function(context)
        local cqi = context:character():cqi()
        dev.callback(
            function()
                cancel_order = true
                local panel = dev.get_uic(cm:ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "subpanel_character")
                if not not panel then
                    local title = dev.get_uic(panel, "dy_type")
                    local name = dev.get_uic(panel, "dy_name")
                    local old_title = title:GetStateText()
                    local old_name = name:GetStateText()
                    if old_title and old_name then 
                        name:SetStateText(old_name.."; " ..old_title)
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end
                    local title_trait = charm:get_character(cqi):current_title()
                    if not (CONST.titles_localisation()[title_trait] == nil) then
                        title:SetStateText(CONST.titles_localisation()[title_trait])
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end
                    cancel_order = false 
                end
            end, 0.1
        )
        
    end,
    true
)


cm:add_listener(
    "EstateEXPCharTurnStart",
    "CharacterTurnStart",
    function(context)
        return context:character():faction():name() ~= "rebels"
    end,
    function(context)
        charm:apply_estate_exp_for_character(context:character():cqi(), context)
    end,
    true
)

