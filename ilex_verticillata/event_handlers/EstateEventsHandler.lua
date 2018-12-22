local pkm = _G.pkm

cm:add_listener(
    "EBSEstateDestroyed",
    "EstateDestroyed",
    function(context)
        return true
    end,
    function(context)
        local region = context:region()
        local building = context.string
        local reg_det = pkm:get_region(region:name())
        if reg_det:has_estate_with_building(building) then
            local estate = reg_det:get_estate_detail(building)
            if estate:has_owner() then
                local owner = estate:owner()
                owner:remove_estate(region:name(), building)
            end
            reg_det:disconnect_estate(building)
        end
    end,
    true
)