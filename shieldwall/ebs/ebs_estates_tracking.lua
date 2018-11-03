local et = _G.et

cm:register_loading_game_callback(function(context)
    local ok, err = pcall(function()
        local savetable = cm:load_value("estate_tracker_save", {}, context)
        for region, estate_data in pairs(savetable) do
            et:load_estate(estate_data)
        end
    end)
    if not ok then 
        dev.log(tostring(err), "LDR")
    end
end)

cm:register_saving_game_callback(function(context)
    local ok, err = pcall(function()
        local savetable = {} --:map<string, ESTATE_SAVE>
        for region, estate in pairs(et._estateData) do
            savetable[region] = estate:save()
        end
        cm:save_value("estate_tracker_save", savetable, context)
    end)
    if not ok then
        dev.log(tostring(err), "SVR")
    end
    
end)



--v function(estate: ESTATE) --> string
local function get_estate_bundle(estate)
    if estate:is_royal() then
        return nil
    end
    local estate_type = estate:type()
    local bundle_prefix --:string
    if estate_type == CONST.town_estate_type then
        bundle_prefix = "town"
    elseif estate_type == CONST.agricultural_estate_type then
        bundle_prefix = "agricultural"
    elseif estate_type == CONST.resource_estate_type then
        bundle_prefix = "resource"
    end
    local bundle_suffix = "_other"
    return "shield_"..bundle_prefix.."_estate"..bundle_suffix
end

cm:add_listener(
    "ETCharacterAssignedEstate",
    "CharacterAssignedEstate",
    true,
    function(context)
        et:log("Character was assigned estate!")
        local estate = et:check_estate(context:estate())
        et:grant_estate_to_character(context:character():cqi(), context:estate():region():name())
        estate:update_bundle(get_estate_bundle(estate))
    end,
    true
)

cm:add_listener(
    "ETCharacterStrippedOfEstate",
    "CharacterStrippedOfEstate",
    true,
    function(context)
        et:log("Character was stripped of an estate!")
        local estate = et:check_estate(context:estate())
        et:strip_estate_from_character(context:character():cqi(), context:estate():region():name())
        estate:update_bundle()
    end,
    true
)

cm:add_listener(
    "ETGarrisonOccupiedEvent",
    "GarrisonOccupiedEvent",
    true,
    function(context)
        local estate = et:get_region_estate(context:garrison_residence():region():name())
        estate:change_faction(context:character():faction():name())
        estate:update_bundle()
    end,
    true
)


cm:add_listener(
    "ETBundlesRegionTurnStart",
    "RegionTurnStart",
    function(context)
        return not not et:has_estate(context:region():name())
    end,
    function(context)
        local estate = et:get_region_estate(context:region():name())
        estate:update_bundle(get_estate_bundle(estate))
    end,
    true
)


cm:register_first_tick_callback( function()
    if cm:is_new_game() then
        local humans = cm:get_human_factions()
        for i = 1, #humans do
            local region_list = dev.get_faction(humans[i]):region_list()
            for i = 0, region_list:num_items() - 1 do
                local current_region = region_list:item_at(i)
                if current_region:settlement():is_null_interface() then
                    --do nothing
                else
                    local estate = et:get_region_estate(current_region:name())
                    estate:update_bundle(get_estate_bundle(estate))
                end
            end
        end
    end
end)

dev.add_settlement_selected_log(function(region)
    local estate = et:get_region_estate(region:name())
    return "has estate: owner ["..tostring(estate._owner).."], type ["..estate:type().."], royalty: ["..tostring(estate:is_royal()).."] "

end)