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