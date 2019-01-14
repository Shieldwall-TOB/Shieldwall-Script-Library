local pkm = _G.pkm

cm:add_listener(
    "EBSEstateDestroyed",
    "EstateDestroyed",
    function(context)
        return true
    end,
    function(context)
        local region = context:region()
        local chain_key = context.string
        local reg_det = pkm:get_region(region:name())
        if reg_det:has_estate_with_chain(chain_key) then
            local estate = reg_det:get_estate_detail(chain_key)
            if estate:has_owner() then
                local owner = estate:owner()
                owner:remove_estate(region:name(), chain_key)
            end
            reg_det:disconnect_estate(chain_key)
        end
    end,
    true
)

