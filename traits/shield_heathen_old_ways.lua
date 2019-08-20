local tm = traits_manager.new("shield_heathen_old_ways")
local FLAG_CHANCE = 20
local KING_TRAIT_CHANCE = 20

tm:add_dilemma_flag_listener("CharacterTurnStart",
function(context)
    local char = context:character()
    --cannot be a friend of the church
    if char:has_trait("shield_faithful_friend_of_the_church") then
        return false, char
    end
    --cannot trigger for viking
    if Check.is_char_from_viking_faction(char) then
        return false, char
    end
    --needs a valid region for check
    if char:region():is_null_interface() then
        return false, char
    end
    --for each region adjacent to the one the character is in.
    for i = 0, char:region():adjacent_region_list():num_items() - 1 do
        local current = char:region():adjacent_region_list():item_at(i)
        --is the region owned by a viking we are *not* are war with?
        if (not char:faction():at_war_with(current:owning_faction())) and Check.is_faction_viking_faction(current:owning_faction()) then
            return cm:random_number(100) < FLAG_CHANCE, char
        end
    end
    return false, char
end)


tm:add_faction_leader_dilemma("PositiveDiplomaticEvent",
function(context)
    local proposer = context:proposer()
    local recipient = context:recipient()
    --the proposer is a human faction who isn't viking and just made a deal with vikings.
    if proposer:is_human() and Check.is_faction_viking_faction(recipient) and not Check.is_faction_viking_faction(proposer) then
        --cannot be a friend of the church
        if proposer:faction_leader():has_trait("shield_faithful_friend_of_the_church") then
            return false, nil
        end
        return cm:random_number(100) < (KING_TRAIT_CHANCE/2), proposer 
        --we divide the chance by two because diplomacy events trigger twice every time they fire. 

    --the recpient is a human faction who isn't viking and just made a deal with vikings.
    elseif recipient:is_human() and Check.is_faction_viking_faction(proposer) and not Check.is_faction_viking_faction(recipient) then
        --cannot be a friend of the church
        if recipient:faction_leader():has_trait("shield_faithful_friend_of_the_church") then
            return false, nil
        end
        return cm:random_number(100) < (KING_TRAIT_CHANCE/2), recipient 
        --we divide the chance by two because diplomacy events trigger twice every time they fire.
    end
    return false, nil
end, {[0] = true, [1] = false})







tm:set_loyalty_event_condition("NegativeDiplomaticEvent",
function(context)
    local faction = context:proposer()
    --if the event is a war and the human faction declared it.
    if faction:is_human() and context:is_war() then
        local faction_detail = pkm:get_faction(faction:name())
        --don't trigger if the faction is a vassal.
        local faction_list = dev.faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local master = faction_list:item_at(i)
            if faction:is_vassal_of(master) then
                return false, nil
                --if the faction has just declared war on their master, they won't be a vassal anymore when this check happens.
            end
        end
        --the recipient of the war declaration must be a viking faction.
      return Check.is_faction_viking_faction(context:recipient()), faction
    end
    --otherwise, false
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

