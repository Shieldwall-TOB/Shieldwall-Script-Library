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

cm:register_first_tick_callback(function()
    local region_list = dev.region_list()
    for i = 0, region_list:num_items() -1 do
        rot:transfer_or_add_region(region_list:item_at(i):name())
    end
end)