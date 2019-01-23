local dilemma_prefix = "shield_ally_region_"
local rot = _G.rot
local pkm = _G.pkm

--v function(i: int, ally: string, player:string, new_regions: vector<string>)
local function region_transfer_dilemma(i, ally, player, new_regions)
    local region = new_regions[i]
    cm:trigger_dilemma(player, dilemma_prefix..region, true)
    table.remove(new_regions, i)
    cm:add_listener(
        "AllyRestoreDilemmaChoices",
        "DilemmaChoiceMadeEvent",
        function(context)
            return not not string.find(context:dilemma(), dilemma_prefix)
        end,
        function(context)
            if context:choice() == 0 then
                local prov_name = cm:model():world():region_manager():region_by_key(region):province_name()
                cm:transfer_region_to_faction(region, ally)
                for j = 1, #new_regions do
                    if cm:model():world():region_manager():region_by_key(new_regions[j]):province_name() == prov_name then
                        cm:transfer_region_to_faction(new_regions[j], ally)
                    end
                end
            end
        end,
        true)
end


cm:add_listener(
    "AllyRestoreDilemmas",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() 
    end,
    function(context)
        local new_regions = rot.get_player_new_regions()[context:faction():name()]
        if new_regions then
            dev.log("Checking human faction ["..context:faction():name().."] for new regions", "RAR")
            for i = 1, #new_regions do
                local region = new_regions[i]
                for owner, _ in pairs(pkm:get_region(region):get_ownership_tracker():owner_history()) do
                    if context:faction():allied_with(cm:model():world():faction_by_key(owner)) then
                        region_transfer_dilemma(i, owner,context:faction():name(), new_regions)
                        return
                    end
                end
            end
        end
        local ai_new_regions = rot.get_ai_new_regions()
        local humans = cm:get_human_factions()
        for k = 1, #humans do
            local human = dev.get_faction(humans[k])
            for faction_name, regions in pairs(ai_new_regions) do
                local faction = dev.get_faction(faction_name)
                if human:allied_with(faction) or faction:is_vassal_of(human) then
                    for i = 1, #regions do
                        region_name = regions[i]
                        local tracker = pkm:get_region(region_name):get_ownership_tracker()
                        if tracker:has_previous_owner(human:name()) then
                            dev.log("AI faction ["..faction_name.."] is returning region ["..region_name.."] to human faction ["..human:name().."] who is player ["..k.."]", "RAR")
                            cm:transfer_region_to_faction(region_name, human:name())
                        end
                    end
                end
            end
        end
    end,
    true
)
