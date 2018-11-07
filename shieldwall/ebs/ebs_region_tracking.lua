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

cm:register_saving_game_callback(function(context)
    local svtable = rot:save()
    cm:save_value("rot_save", svtable, context)
    rot:log("ROT Saved Successfully")
end)

cm:register_loading_game_callback(function(context)
    local svtable = cm:load_value("rot_save", {}, context)
    rot:load(svtable)
    rot:log("ROT Loaded Successfully")
end)
