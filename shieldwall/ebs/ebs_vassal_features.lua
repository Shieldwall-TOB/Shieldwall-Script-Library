fkm = _G.fkm;


cm:add_listener(
    "ClanBecomesVassalTracker",
    "ClanBecomesVassal",
    function(context)
        return true
    end,
    function(context)
        fkm:add_vassal(context:faction():name())
    end,
    true
)

cm:add_listener(
    "NegativeDiplomaticEventVassalTracker",
    "NegativeDiplomaticEvent",
    function(context)
        return (fkm:is_faction_vassal(context:proposer():name()) or fkm:is_faction_vassal(context:recipient():name()))
    end,
    function(context)
        local proposer = context:proposer() --:CA_FACTION
        local recipient = context:recipient() --:CA_FACTION
        if fkm:is_faction_vassal(proposer:name()) then
            local liege = fkm._vassals[proposer:name()]._liege
            if not proposer:is_vassal_of(cm:model():world():faction_by_key(liege)) then
                fkm:remove_vassal(proposer:name())
            end
        end
        if fkm:is_faction_vassal(recipient:name()) then
            local liege = fkm._vassals[recipient:name()]._liege
            if not recipient:is_vassal_of(cm:model():world():faction_by_key(liege)) then
                fkm:remove_vassal(recipient:name())
            end
        end
    end,
    true
)

fkm:log("VASSAL FEATURES EBS INIT COMPLETE")