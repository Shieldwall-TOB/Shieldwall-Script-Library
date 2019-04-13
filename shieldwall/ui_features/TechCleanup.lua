local function remove_vertical_divider_from_tech()
    local vertical_divider = dev.get_uic(cm:ui_root(), "technology_panel", "vertical_divider")
    if not not vertical_divider then
        vertical_divider:Resize(1, 1)
    end
end

local function remove_horizontal_dividers_from_tech()
    local m_side_chain_line = dev.get_uic(cm:ui_root(), "technology_panel", "TabGroup", "military_technologies", "tab_child", "tech_template", "tree_parent", "slot_parent", "chain_line")
    if not not m_side_chain_line then
        m_side_chain_line:SetVisible(false)
    end
end


cm:add_listener(
    "PanelOpenedCampaignTech",
    "PanelOpenedCampaign",
    function(context)
        return context.string == "technology_panel"
    end,
    function(context)
        dev.callback(function()
        --remove_vertical_divider_from_tech()
        remove_horizontal_dividers_from_tech()
        end, 0.1)
    end,
    true
)