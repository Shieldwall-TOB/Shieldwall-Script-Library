


--v function(trait_key: string, hidden_flag_trait: string, event: string, condition: (function(context:WHATEVER)--> boolean), character_ret: function(context: WHATEVER) --> CA_CHAR)
function add_trait_with_dilemma_event(trait_key, hidden_flag_trait, event, condition, character_ret)

    cm:add_listener(
        trait_key..event,
        event,
        function(context)
            local ok = condition(context)
            if (character_ret(context):has_trait(trait_key) or (not ok)) and character_ret(context):has_trait(hidden_flag_trait) then
                cm:force_remove_trait(dev.lookup(character_ret(context)), hidden_flag_trait)
                return false
            end
            return ok
        end,
        function(context)
            cm:force_add_trait(dev.lookup(character_ret(context)), hidden_flag_trait, true)
        end,
        true
    )
    cm:add_listener(
        hidden_flag_trait,
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:dilemma() == trait_key
        end,
        function(context)
            local faction = context:faction()
            for i = 0, faction:character_list():num_items() - 1 do
                local character = faction:character_list():item_at(i)
                if character:has_trait(hidden_flag_trait) then
                    cm:force_remove_trait(dev.lookup(character), hidden_flag_trait)
                end
            end
        end,
        true)
end



