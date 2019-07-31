local BATTLE_SIZE = -1 --:number
--[[
    every non human major faction king involved is worth a point, another point if more than 24 units are involved, another point if more than 32 are involved.
--]]













--caching


cm:add_listener(
    "pending_battle_cache",
    "PendingBattle",
    true,
    function(context) 
        local pb = context:pending_battle() --:CA_PENDING_BATTLE
        local size = 0 --:number
        -- primary attackers
        if pb:has_attacker() then
            local army = pb:attacker():military_force()
            for k = 0, army:unit_list():num_items() - 1 do
                local unit = army:unit_list():item_at(k)
                if not string.find(unit:unit_key(), "_garrison") then
                    size = size + unit:percentage_proportion_of_full_strength()
                end
            end
        end
        -- secondary attackers
        local secondary_attacker_list = pb:secondary_attackers() 
        for i = 0, secondary_attacker_list:num_items() - 1 do
            local army = secondary_attacker_list:item_at(i):military_force()
            for k = 0, army:unit_list():num_items() - 1 do
                local unit = army:unit_list():item_at(k)
                if not string.find(unit:unit_key(), "_garrison") then
                    size = size + unit:percentage_proportion_of_full_strength()
                end
            end
        end
        -- primary defenders
        if pb:has_defender() then
            local army = pb:defender():military_force()
            for k = 0, army:unit_list():num_items() - 1 do
                local unit = army:unit_list():item_at(k)
                if not string.find(unit:unit_key(), "_garrison") then
                    size = size + unit:percentage_proportion_of_full_strength()
                end
            end
        end
        -- secondary defenders
        local secondary_defenders_list = pb:secondary_defenders();
        for i = 0, secondary_defenders_list:num_items() - 1 do
            local army = secondary_defenders_list:item_at(i):military_force()
            for k = 0, army:unit_list():num_items() - 1 do
                local unit = army:unit_list():item_at(k)
                if not string.find(unit:unit_key(), "_garrison") then
                    size = size + unit:percentage_proportion_of_full_strength()
                end
            end
        end
        BATTLE_SIZE = size/100
    end,
    true
);

cm:register_loading_game_callback(
	function(context)
        BATTLE_SIZE = cm:load_value("BATTLE_SIZE", -1, context);
	end
);

cm:register_saving_game_callback(
	function(context)
        cm:save_value("BATTLE_SIZE", BATTLE_SIZE, context);
	end
);
