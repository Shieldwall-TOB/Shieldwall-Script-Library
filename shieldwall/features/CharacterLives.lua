cm:add_listener(
    "CharacterExtraLife",
    "PendingBattle",
    function(context)
        return true
    end,
    function(context)
        local att_char = context:pending_battle():attacker()--:CA_CHAR
        local def_char = context:pending_battle():defender() --:CA_CHAR
        
        if not att_char:faction():is_human() then
            if att_char:is_heir() or att_char:is_faction_leader() then
                if cm:random_number(10) >= 5 then
                    cm:set_character_immortality(dev.lookup(att_char:cqi()), true)
                else
                    cm:set_character_immortality(dev.lookup(att_char:cqi()), false)
                end
            else
                cm:set_character_immortality(dev.lookup(att_char:cqi()), false)
            end
        end
        if not def_char:faction():is_human() then
            if att_char:is_heir() or att_char:is_faction_leader() then
                if cm:random_number(10) >= 5 then
                    cm:set_character_immortality(dev.lookup(att_char:cqi()), true)
                else
                    cm:set_character_immortality(dev.lookup(att_char:cqi()), false)
                end
            else
                cm:set_character_immortality(dev.lookup(att_char:cqi()), false)
            end
        end
    end,
    true
)