pkm = _G.pkm;


cm:add_listener(
    "ClanBecomesVassalTracker",
    "ClanBecomesVassal",
    function(context)
        return true
    end,
    function(context)
        pkm:faction_became_vassal(context:faction():name())
    end,
    true
)

cm:add_listener(
    "NegativeDiplomaticEventVassalTracker",
    "NegativeDiplomaticEvent",
    function(context)
        return (pkm:get_faction(context:proposer():name()):is_faction_vassal() or pkm:get_faction(context:recipient():name()):is_faction_vassal())
    end,
    function(context)
        local proposer = context:proposer() --:CA_FACTION
        local recipient = context:recipient() --:CA_FACTION
        local prop_fd = pkm:get_faction(proposer:name())
        local recip_fd = pkm:get_faction(recipient:name())
        if prop_fd:is_faction_vassal() then
            local liege = prop_fd:liege():name()
            if not proposer:is_vassal_of(cm:model():world():faction_by_key(liege)) then
                prop_fd:remove_vassal(proposer:name())
            end
        end
        if recip_fd:is_faction_vassal() then
            local liege = recip_fd:liege():name()
            if not recipient:is_vassal_of(cm:model():world():faction_by_key(liege)) then
                recip_fd:remove_vassal(recipient:name())
            end
        end
    end,
    true
)
