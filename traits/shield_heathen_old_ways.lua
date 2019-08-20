
local tm = traits_manager.new("shield_heathen_old_ways")
local FLAG_CHANCE = 20

tm:add_dilemma_flag_listener("CharacterTurnStart",
function(context)
    local char = context:character()
    if Check.is_char_from_viking_faction(char) then
        return false, char
    end
    if char:region():is_null_interface() then
        return false, char
    end
    for i = 0, char:region():adjacent_region_list():num_items() - 1 do
        local current = char:region():adjacent_region_list():item_at(i)
        if current:owning_faction():has_faction_leader() and Check.is_char_from_viking_faction(current:owning_faction():faction_leader()) then
            return cm:random_number(100) < FLAG_CHANCE, char
        end
    end
    return false, char
end)

tm:set_loyalty_event_condition("NegativeDiplomaticEvent",
function(context)
    local faction = context:proposer()
    if faction:is_human() and context:is_war() then
        local faction_detail = pkm:get_faction(faction:name())
        --case, the faction declaring war is a vassal and they are not declaring war on their liege.
        local faction_list = dev.faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local master = faction_list:item_at(i)
            if faction:is_vassal_of(master) then
                return false, nil
            end
        end
      return Check.is_char_from_viking_faction(context:recipient():faction_leader()), faction
    end
    return false, nil
end)

tm:set_start_pos_characters(
    --northanhymbre viking sympathizer
    "faction:vik_fact_northleode,forename:2147363531",
    --dyflin and sudreyar pagans
    "faction:vik_fact_sudreyar,forename:2147365942",
    "faction:vik_fact_sudreyar,forename:2147366135",
    "faction:vik_fact_sudreyar,forename:2147365979",
    "faction:vik_fact_sudreyar,forename:2147365995",
    "faction:vik_fact_sudreyar,forename:2147366152",
    "faction:vik_fact_dyflin,forename:2147365881",
    "faction:vik_fact_dyflin,forename:2147366107",
    "faction:vik_fact_dyflin,forename:2147366232",
    "faction:vik_fact_dyflin,forename:2147366227"
)

