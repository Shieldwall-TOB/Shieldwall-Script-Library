local charm = _G.charm



cm:register_loading_game_callback(function(context) 
    local sv_table = cm:load_value("character_manager_save", {}, context)
    for key, value in pairs(sv_table) do
        charm:load_character(value)
    end
end)


cm:register_saving_game_callback(function(context)
    local sv_table = {} --:map<string, CHAR_SAVE>
    for cqi, char in pairs(charm._characterData) do
        local char_save = char:save()
        sv_table[char_save._cqi] = char_save
    end
    cm:save_value("character_manager_save", sv_table, context)
end)


cm:add_listener(
    "CharManagerEstateGained",
    "CharacterGainedEstate",
    true,
    function(context)
        local char = context:character():cqi()
        local estate = context:shield_estate()
        charm:get_character(char):add_estate(estate)
    end,
    true
)

cm:add_listener(
    "CharManagerEstateLost",
    "CharacterLostEstate",
    true,
    function(context)
        local char = context:character():cqi()
        local estate = context:shield_estate()
        charm:get_character(char):remove_estate(estate)
    end,
    true
)

cm:add_listener(
    "CharManagerEstateProcessor",
    "FactionTurnStart",
    true,
    function(context)
        local char_list = context:faction():character_list()
        for i = 0, char_list:num_items() - 1 do
            local character = char_list:item_at(i)
            if not character:is_faction_leader() then
                charm:update_title_for_character(character:cqi())
            end
        end
    end,
    true
)

