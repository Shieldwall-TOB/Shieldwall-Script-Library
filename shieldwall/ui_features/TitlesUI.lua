local pkm = _G.pkm

cancel_order = false --:boolean

cm:add_listener(
    "RegionSelectedTitlesUI",
    "SettlementSelected",
    function(context)
        return context:garrison_residence():faction():is_human() and context:garrison_residence():region():has_governor() and (not cancel_order)
    end,
    function(context)
        local cqi = context:garrison_residence():region():governor():command_queue_index()
        dev.callback(
            function()
                local panel = dev.get_uic(cm:ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "subpanel_character")
                if not not panel then
                    cancel_order = true
                    local title = dev.get_uic(panel, "dy_title")
                    local name = dev.get_uic(panel, "dy_name")
                    local old_title = title:GetStateText()
                    local old_name = name:GetStateText()
                    if string.find(old_name, ";") then
                        return
                    end
                    if old_title and old_name then 
                        name:SetStateText(old_name.."; " ..old_title)
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end
                    local char = dev.get_character(cqi)
                    local title_trait = pkm:get_character(cqi):current_title()
                    local loctext = CONST.titles_localisation()[title_trait]
                    if not (loctext == nil) then
                        if char:is_heir() then
                            title:SetStateText("Heir to the Throne")
                        else
                            title:SetStateText(loctext)
                        end
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
        local cqi = context:character():command_queue_index()
        dev.callback(
            function()
                cancel_order = true
                local panel = dev.get_uic(cm:ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "subpanel_character")
                if not not panel then
                    local title = dev.get_uic(panel, "dy_type")
                    local name = dev.get_uic(panel, "dy_name")
                    local old_title = title:GetStateText()
                    local old_name = name:GetStateText()
                    if string.find(old_name, ";") then
                        return
                    end
                    if old_title and old_name then 
                        name:SetStateText(old_name.."; " ..old_title)
                    else
                        dev.log(" Warn, nil arg passed to CA UIC ","CHM")
                    end                    
                    local char = dev.get_character(cqi)
                    local title_trait = pkm:get_character(cqi):current_title()
                    local loctext = CONST.titles_localisation()[title_trait]
                    if not (loctext == nil) then
                        if char:is_heir() then
                            title:SetStateText("Heir to the Throne")
                        else
                            title:SetStateText(loctext)
                        end
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

