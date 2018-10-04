local rot = _G.rot

cm:add_listener(
    "RegionOwnerTrackerGarrisonOccupied",
    "GarrisonOccupiedEvent",
    true,
    function(context)
        rot:transfer_or_add_region(context:garrison_residence():region():name())
    end,
    true
)

