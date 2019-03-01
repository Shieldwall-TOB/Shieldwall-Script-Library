
local FACTION_DECREES = {
    
}












cm:add_listener(
    "DegreePanelOpened",
    "PanelOpenedCampaign",
    function(context)
        return context.string == "decrees_panel"
    end,
    function(context)
        local panel = UIComponent(context.component)
        local decree_parent = dev.get_uic(panel, "main", "decrees")
        local existingCivilButton = dev.get_uic(panel, "SHIELDWALL_CIVIL_EDICTS")
        if existingCivilButton then
            existingCivilButton:SetVisible(true)
        else
            panel:CreateComponent("SHIELDWALL_CIVIL_EDICTS","ui/custom/civil_edicts_button")
            panel:CreateComponent("SHIELDWALL_WAR_EDICTS","ui/custom/war_edicts_button")
            local civil_button = dev.get_uic(panel, "SHIELDWALL_CIVIL_EDICTS")
            local war_button = dev.get_uic(panel, "SHIELDWALL_WAR_EDICTS")
            local close_button = dev.get_uic(panel, "main", "button_ok")
            civil_button:Resize(close_button:Width(), close_button:Height())
            local cbX, cbY = close_button:Position()
            civil_button:MoveTo(cbX - (close_button:Width()*3),cbY)
            war_button:Resize(close_button:Width(), close_button:Height())
            local cbX, cbY = close_button:Position()
            war_button:MoveTo(cbX + (close_button:Width()*3),cbY)

            
        end

    end,
    true)


