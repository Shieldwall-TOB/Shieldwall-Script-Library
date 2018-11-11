local rwm = _G.rwm


cm:add_listener(
    "RegionWealthTurnStart",
    "FactionTurnStart",
    true,
    function(context)
        for i = 0, context:faction():region_list():num_items() - 1 do
            rwm:process_end_turn(context:faction():region_list():item_at(i):name())
        end
    end,
    true
)

cm:add_listener(
    "RegionWealthCharTurnEnd",
    "CharacterTurnEnd",
    function(context)
        if context:character():region():is_null_interface() then
            return false
        end
        return not ((context:character():region():owning_faction():name() == context:character():faction():name()) or (context:character():region():settlement():is_null_interface()))
    end,
    function(context)
        local character = context:character()
        if character:has_military_force() then
            if string.find(character:military_force():active_stance(), "RAID") then
                rwm:set_region_wealth(context:character():region():name(), 2)
            else
                rwm:set_region_wealth(context:character():region():name(), 1)
            end
        end
    end,
    true)

cm:add_listener(
    "RegionWealthSackedSettlements",
    "CharacterSackedSettlement",
    true,
    function(context)
        rwm:set_region_wealth(context:garrison_residence():region():name(), 3)
    end,
    true
)

cm:add_listener(
    "RegionWealthRegionRebels",
    "RegionRebels",
    true,
    function(context)
        rwm:set_region_wealth(context:region():name(), 1)
    end,
    true
)