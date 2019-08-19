cm:add_listener(
    "KingsCourtTurnStart",
    "RegionTurnStart",
    function(context)
        return context:region():building_superchain_exists("vik_konungsgurtha")
    end,
    function(context)
        local owner = context:region():owning_faction()
        local faction_list = dev.faction_list()
        local vassal_count = 0 --:number
        for i = 0, faction_list:num_items() - 1 do
            local vassal = faction_list:item_at(i)
            if vassal:is_vassal_of(owner) then
                vassal_count = vassal_count + 1
            end
        end
        vassal_count = dev.clamp(vassal_count, 0, 5)
        local bundle = cm:get_saved_value("kings_court_bundle") or 0
        if bundle ~= vassal_count then
            if bundle > 0 then
                cm:remove_effect_bundle_from_region("vik_konungsgurtha_"..bundle, context:region():name())
            end
            if vassal_count > 0 then
                cm:apply_effect_bundle_to_region("vik_konungsgurtha_"..vassal_count, context:region():name(), 0)
            end
            cm:set_saved_value("kings_court_bundle", vassal_count)
        end
    end,
    true
)