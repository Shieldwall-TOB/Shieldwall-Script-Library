local pkm = _G.pkm
--v function(region: CA_REGION, character: CA_CHAR)
local function onRegionOccupied(region, character)
    dev.log("Faction: ["..character:faction():name().."] captured region ["..region:name().."] ","EH")
    local reg_detail = pkm:get_region(region:name())
    --TODO region transfer in object model
    --TODO population handler on conquest
end




cm:add_listener(
    "EBSRegionOccupiedEvent",
    "GarrisonOccupiedEvent",
    function(context)
        return (not string.find(context:character():faction():name(), "rebels"))
    end,
    function(context)
        onRegionOccupied(context:garrison_residence():region(), context:character())
    end,
    true
)


--v function(region: CA_REGION)
local function onRegionOccupiedByRebels(region)
    --[[
    local reg_detail = pkm:get_region(region:name())
    local old_province = reg_detail:province_detail()
    reg_detail:get_ownership_tracker():transfer_region("rebels")
    old_province:remove_region(region:name())
    --]]
end



cm:add_listener(
    "EBSRegionOccupiedEventRebels",
    "GarrisonOccupiedEvent",
    function(context)
        return (context:character():faction():name() == "rebels")
    end,
    function(context)
        --onRegionOccupiedByRebels(context:garrison_residence():region())
    end,
    true
)