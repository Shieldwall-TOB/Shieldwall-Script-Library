local units_to_effects = {

}--:map<string, string>

for unit, effect in pairs(units_to_effects) do
    local uem = _G.uem
    uem.add_effect_to_unit(unit, effect)
end