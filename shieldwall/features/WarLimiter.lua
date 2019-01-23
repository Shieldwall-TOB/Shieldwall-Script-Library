local pkm = _G.pkm

cm:add_listener(
    "WarLimiter",
    "FactionTurnStart",
    function(context)
        return (not context:faction():is_human()) and (context:faction():name() ~= "rebels") and (context:faction():has_home_region())
    end,
    function(context)
        local wars = context:faction():factions_at_war_with()
        local counter = 0 --:number
        for i = 0, wars:num_items() - 1 do
            if not pkm:get_faction(wars:item_at(i):name()):is_faction_vassal() then
                counter = counter + 1
            end
        end
        if counter > 1 then
            dev.log("Limiting wars on faction ["..context:faction():name().."]", "WAR")
            local faction_list = dev.faction_list()
            for i = 0, faction_list:num_items() - 1 do
                local faction = faction_list:item_at(i):name() 
                if not faction == context:faction():name() then
                    cm:force_diplomacy(context:faction():name(), faction, "war", false, true)
                    cm:set_saved_value("war_restricted_"..context:faction():name(), true)
                end
            end
        else
            if cm:get_saved_value("war_restricted_"..context:faction():name()) == true then
                dev.log("removing limits for wars on faction ["..context:faction():name().."]", "WAR")
                local faction_list = dev.faction_list()
                for i = 0, faction_list:num_items() - 1 do
                    local faction = faction_list:item_at(i):name() 
                    if not faction == context:faction():name() then
                        cm:force_diplomacy(context:faction():name(), faction, "war", true, true)
                        cm:set_saved_value("war_restricted_"..context:faction():name(), false)
                    end
                end
            end
        end
    end,
    true
)