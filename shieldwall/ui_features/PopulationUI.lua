--v function(province: string) --> string!
function get_province_loc(province)
    
    return "[province_name_not_found]"
end



--v function(province: string, faction: string)
function display_population_ui(province, faction)
    dev.log("Displaying pop UI", "CUI")
    local frame = dev.get_uic(cm:ui_root(), "PopulationFrame")
    if not frame then
        frame = dev.ui_module:new_mini_frame("PopulationFrame")
    end
    frame:SetVisible(true)
    local subframe = dev.get_uic(frame, "subpanel_character")
    dev.get_uic(subframe, "dy_type"):SetStateText("Population Details")
    dev.get_uic(subframe, "dy_name"):SetStateText(get_province_loc(province))

    --dev.ui_module.createComponent("PopFrameCasteHolder_serfs", frame, "ui/templates/icon_unit")

end



cm:add_listener(
    "ProvinceSelectedPopUI",
    "SettlementSelected",
    function(context)
        return context:garrison_residence():region():owning_faction():name() == cm:get_local_faction(true)
    end,
    function(context)
        display_population_ui("a", "b")
    end,
    true
)