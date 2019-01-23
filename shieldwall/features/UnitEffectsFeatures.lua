local pkm = _G.pkm

cm:add_listener(
    "CharacterTurnStartEUM",
    "CharacterTurnStart",
    function(context)
        return context:character():has_military_force() and context:character():faction():name() ~= "rebels"
    end,
    function(context)
        local char_detail = pkm:get_character(context:character():cqi())
        local char_eum --:UNIT_EFFECTS_MANAGER
        if char_detail:has_unit_effects_manager() then
            char_eum = char_detail:get_unit_effects_manager()
        else
            char_eum = char_detail:create_unit_effects_manager()
        end
        char_eum:evaluate_force()
    end,
    true
)