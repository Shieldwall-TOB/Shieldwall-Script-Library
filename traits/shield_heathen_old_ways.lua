
local tm = traits_manager.new("shield_heathen_old_ways")

--[[ suspected crash cause :c
tm:add_dilemma_flag_listener( "CharacterTurnStart",
function(context)
    local chance = 2 --:number
    local char = context:character() --:CA_CHAR
    if not char:faction():is_null_interface() and char:faction():is_human() and Check.is_char_from_viking_faction(char) then
        return false, char
    end
    if not char:faction():is_human() then
        return cm:random_number(100) > 10, char
    end
    local list = dev.faction_list()
    for i = 0, list:num_items() - 1 do
        local trade_faction = list:item_at(i)
        if trade_faction:has_faction_leader() then
            if char:faction():name() ~= trade_faction:name() and Check.is_char_from_viking_faction(trade_faction:faction_leader()) then
                if char:faction():is_trading_with(trade_faction) then
                    chance = chance + 6
                end
            end
        end
    end
    return cm:random_number(100) < chance, char
end)]]

tm:set_loyalty_event_condition("NegativeDiplomaticEvent",
function(context)
    local faction = context:proposer()
    if faction:is_human() and context:is_war() then
        local faction_detail = pkm:get_faction(faction:name())
        --case, the faction declaring war is a vassal and they are not declaring war on their liege.
        if faction_detail:is_vassal() and (not context:recipient():name() == faction_detail:liege():name()) then
            return false, nil
        end
      return Check.is_char_from_viking_faction(context:recipient():faction_leader()), faction
    end
    return false, nil
end)

tm:set_start_pos_characters(
    "faction:vik_fact_northleode,forename:2147363531"
)

