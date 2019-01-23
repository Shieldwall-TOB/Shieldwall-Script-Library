local pkm = _G.pkm
--v function(region: CA_REGION, character: CA_CHAR)
local function onRegionOccupied(region, character)
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    local new_province = pkm:get_faction(character:faction():name()):get_province(region:province_name())
    if not( reg_detail:has_no_estates()) then
        for chain_key, estate in pairs(reg_detail:estates()) do
            estate:owner():remove_estate(region:name(), estate:chain())
        end
        --wipe and reassign estates to the new faction leader
        local leader_detail = pkm:get_faction(character:faction():name()):get_character(character:faction():faction_leader():cqi())
        reg_detail:refresh_estates(leader_detail)
    end
    reg_detail:get_ownership_tracker():transfer_region(character:faction():name())
    old_province:remove_region(region:name(), new_province)
end




cm:add_listener(
    "EBSRegionOccupiedEvent",
    "GarrisonOccupiedEvent",
    function(context)
        return (not context:character():faction():name() == "rebels")
    end,
    function(context)
        onRegionOccupied(context:garrison_residence():region(), context:character())
    end,
    true
)


--v function(region: CA_REGION)
local function onRegionOccupiedByRebels(region)
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    if not( reg_detail:has_no_estates()) then
        --wipe and reassign estates to the new faction leader
        reg_detail:clear_estates_for_rebels()
    end
    reg_detail:get_ownership_tracker():transfer_region("rebels")
    old_province:remove_region(region:name())
end



cm:add_listener(
    "EBSRegionOccupiedEventRebels",
    "GarrisonOccupiedEvent",
    function(context)
        return (context:character():faction():name() == "rebels")
    end,
    function(context)
        onRegionOccupiedByRebels(context:garrison_residence():region())
    end,
    true
)