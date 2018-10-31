local et = _G.et
--v function(estate: ESTATE) --> string
local function get_estate_bundle(estate)
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
    if estate:is_royal() then
        bundle_suffix = "_crown"
    end
    return "shield_"..bundle_prefix.."_estate"..bundle_suffix
end

cm:add_listener(
    "ETCharacterAssignedEstate",
    "CharacterAssignedEstate",
    true,
    function(context)
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
        local estate = et:check_estate(context:estate())
        et:strip_estate_from_character(context:character():cqi(), context:estate():region():name())
        estate:update_bundle(get_estate_bundle(estate))
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