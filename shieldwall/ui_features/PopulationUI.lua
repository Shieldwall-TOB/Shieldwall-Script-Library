local pkm = _G.pkm

--v function(ca_uic: CA_UIC, child_name: string) --> CA_UIC
function find_single_direct_child_uic(ca_uic, child_name)
    for i = 0, ca_uic:ChildCount() - 1 do
        local potential_uic = UIComponent(ca_uic:Find(i))
        if potential_uic:Id() == child_name then
            return potential_uic
        end
    end
    return nil
end

--v function(province: string, faction: string) --> CA_UIC
function display_population_ui(province, faction)
    dev.log("Displaying pop UI", "CUI")
    --grab necessary objects
    local faction_detail = pkm:get_faction(faction)
    local serf_value = faction_detail:pop_manager_by_key("serf"):display_value_in_province(province)
    local lord_value = faction_detail:pop_manager_by_key("lord"):display_value_in_province(province)
    local monk_value = faction_detail:pop_manager_by_key("monk"):display_value_in_province(province)
    local foreign_value = faction_detail:pop_manager_by_key("foreign"):display_value_in_province(province)
    --create the frame, but first check if it exists.
    local frame = dev.get_uic(cm:ui_root(), "PopulationFrame")
    if not frame then
        frame = dev.ui_module:new_mini_frame("PopulationFrame")
        local subframe = dev.get_uic(frame, "subpanel_character")
        local background = dev.get_uic(frame, "info_panel_background")
        --use the borders of the settlement panel and details panel to position our element.
        --local SettlementPanel = dev.get_uic(cm:ui_root(),  "settlement_panel")
        local settlePanelPosX, settlePanelPosY = 418, 837
        frame:Resize(158, frame:Height()+3)
        subframe:Resize(158, frame:Height()+3)
        background:Resize(158, background:Height()+3)
        frame:MoveTo(255, settlePanelPosY+4)
        local sfPosX, sfPosY = subframe:Position()
        subframe:MoveTo(256, sfPosY)
        --fix the bars
        dev.get_uic(subframe, "dy_name", "hbar"):Resize(150, dev.get_uic(subframe, "dy_name", "hbar"):Height())
        dev.get_uic(subframe, "dy_name", "hbar"):MoveTo(268, 884)
        local ok, err = pcall(function() 
            for i = 0, subframe:ChildCount() - 1 do
                local potential_uic = UIComponent(subframe:Find(i))
                if potential_uic:Id() == "hbar" then
                    potential_uic:SetVisible(false)
                end
            end
        end)
        if not ok then
            dev.log(tostring(err))
        end

        --name it.
        local subframe = dev.get_uic(frame, "subpanel_character") 
        dev.get_uic(subframe, "dy_type"):SetVisible(false)
        dev.get_uic(subframe, "dy_name"):SetVisible(false)
        --now, we want to grab four elements for our use.
        local LordPop = dev.get_uic(subframe, "dy_command")
        local SerfPop = dev.get_uic(subframe, "dy_zeal")
        local MonkPop = dev.get_uic(subframe, "dy_rank")
        local ForeignPop = dev.get_uic(subframe, "dy_subterfuge")

        --this element doesn't show anymore, but it is the top corner of the sub panel we are using!
        local startX, startY = dev.get_uic(subframe, "3D_window"):Position()
        local iconGaps = 10
        --make them all visible
        LordPop:SetVisible(true)
        SerfPop:SetVisible(true)
        MonkPop:SetVisible(true)
        ForeignPop:SetVisible(true)


        LordPop:MoveTo(startX, startY); startY = startY + LordPop:Height() + iconGaps
        SerfPop:MoveTo(startX, startY); startY = startY + SerfPop:Height() + iconGaps
        MonkPop:MoveTo(startX, startY); startY = startY + MonkPop:Height() + iconGaps; 
        local vX, vY = dev.get_uic(MonkPop, "dy_rank_value"):Position(); dev.get_uic(MonkPop, "dy_rank_value"):MoveTo(vX+5, vY)
        ForeignPop:MoveTo(startX, startY); startY = startY + ForeignPop:Height() + iconGaps
        LordPop:SetStateText(tostring(lord_value))
        SerfPop:SetStateText(tostring(serf_value))
        dev.get_uic(MonkPop, "dy_rank_value"):SetStateText(tostring(foreign_value))
        ForeignPop:SetStateText(tostring(monk_value))

        LordPop:SetTooltipText("[[rgba:135:189:233:1]] Noblemen Population [[/rgba]]", true)
        SerfPop:SetTooltipText("[[rgba:135:189:233:1]] Serf Population [[/rgba]]", true)
        MonkPop:SetTooltipText("[[rgba:135:189:233:1]] Monk Population [[/rgba]]", true)
        dev.get_uic(MonkPop, "dy_rank_value"):SetTooltipText("[[rgba:135:189:233:1]] Monk Population [[/rgba]]", true)
        ForeignPop:SetTooltipText("[[rgba:135:189:233:1]] Foreign Mercenary Population [[/rgba]]", true)
    else
        local subframe = dev.get_uic(frame, "subpanel_character") 
        local LordPop = dev.get_uic(subframe, "dy_command")
        local SerfPop = dev.get_uic(subframe, "dy_zeal")
        local MonkPop = dev.get_uic(subframe, "dy_rank")
        local ForeignPop = dev.get_uic(subframe, "dy_subterfuge")
        LordPop:SetStateText(tostring(lord_value))
        SerfPop:SetStateText(tostring(serf_value))
        dev.get_uic(MonkPop, "dy_rank_value"):SetStateText(tostring(foreign_value))
        ForeignPop:SetStateText(tostring(monk_value))

        LordPop:SetTooltipText("[[rgba:135:189:233:1]] Noblemen Population [[/rgba]]", true)
        SerfPop:SetTooltipText("[[rgba:135:189:233:1]] Serf Population [[/rgba]]", true)
        MonkPop:SetTooltipText("[[rgba:135:189:233:1]] Monk Population [[/rgba]]", true)
        dev.get_uic(MonkPop, "dy_rank_value"):SetTooltipText("[[rgba:135:189:233:1]] Monk Population [[/rgba]]", true)
        ForeignPop:SetTooltipText("[[rgba:135:189:233:1]] Foreign Mercenary Population [[/rgba]]", true)
    end
    frame:SetVisible(true)
    return frame
end



cm:add_listener(
    "ProvinceSelectedPopUI",
    "SettlementSelected",
    function(context)
        return context:garrison_residence():region():owning_faction():name() == cm:get_local_faction(true)
    end,
    function(context)
        display_population_ui(context:garrison_residence():region():province_name(), context:garrison_residence():region():owning_faction():name())
    end,
    true
)

cm:add_listener(
    "ProvinceSelectedPopUI",
    "SettlementSelected",
    function(context)
        return context:garrison_residence():region():owning_faction():name() == cm:get_local_faction(true)
    end,
    function(context)
        local province = context:garrison_residence():region():province_name()
        local faction = context:garrison_residence():region():owning_faction():name()
        dev.callback( function()
            display_population_ui(province,faction)
        end, 0.5)
    end,
    true
)

cm:add_listener(
    "ProvinceDeselectedPopUI",
    "SettlementDeselected",
    function(context)
        return true
    end,
    function(context)
        local frame = dev.get_uic(cm:ui_root(), "PopulationFrame")
        if frame then
            frame:SetVisible(false)
        end
    end,
    true
)

cm:add_listener(
    "CharacterSelectedPopUI",
    "CharacterSelected",
    function(context)
        return true
    end,
    function(context)
        local frame = dev.get_uic(cm:ui_root(), "PopulationFrame")
        if frame then
            frame:SetVisible(false)
        end
    end,
    true
)


