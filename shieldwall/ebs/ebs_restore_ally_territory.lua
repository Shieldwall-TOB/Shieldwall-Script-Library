local rot = _G.rot
local dilemma_prefix = "shield_ally_region_"

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
        local new_regions = rot:get_player_new_regions(context:faction():name())
        for i = 1, #new_regions do
            local region = new_regions[i]
            for owner, _ in pairs(rot:get_past_owners(region)) do
                if context:faction():allied_with(cm:model():world():faction_by_key(owner)) then
                    region_transfer_dilemma(i, owner,context:faction():name(), new_regions)
                    return
                end
            end
        end
    end,
    true
)

