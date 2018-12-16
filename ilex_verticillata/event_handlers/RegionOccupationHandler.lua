local pkm = _G.pkm
--v function(region: CA_REGION, character: CA_CHAR)
local function onRegionOccupied(region, character)
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    local new_province = pkm:get_faction(character:faction():name()):get_province(region:province_name())
    if not( reg_detail:has_no_estates()) then
        --wipe and reassign estates to the new faction leader
        local leader_detail = pkm:get_faction(character:faction():name()):get_character(character:cqi())
        reg_detail:transition_estates_to_new_faction(leader_detail)
    end
    old_province:remove_region(region:name(), new_province)
end




cm:add_listener(
    "EBSRegionOccupiedEvent",
    "GarrisonOccupiedEvent",
    function(context)
        return true
    end,
    function(context)
        onRegionOccupied(context:garrison_residence():region(), context:character())
    end,
    true
)