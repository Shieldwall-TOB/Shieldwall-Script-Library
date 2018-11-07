local uem = _G.uem

cm:add_listener(
    "CharacterTurnStartEUM",
    "CharacterTurnStart",
    function(context)
        return context:character():has_military_force() 
    end,
    function(context)
        uem:evaluate_force(context:character():military_force())
    end,
    true
)

cm:register_saving_game_callback(function(context)
    local svtable = uem:save()
    cm:save_value("uem_savedata", svtable, context)
end)

cm:register_loading_game_callback(function(context) 
    local svtable = cm:load_value("uem_savedata", {}, context)
    uem:load(svtable)
end)