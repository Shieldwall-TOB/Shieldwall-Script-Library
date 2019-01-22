local units_to_effects = {
    est_marauders = "shield_unitsbonus_sailors",
    dan_ceorl_axemen = "shield_unitsbonus_sailors",
    est_scouts = "shield_unitsbonus_scouts",
    dan_scout_horsemen = "shield_unitsbonus_scouts",
    eng_scout_horsemen = "shield_unitsbonus_scouts",
    wel_scout_horsemen = "shield_unitsbonus_scouts",
    iri_kern_raiders = "shield_unitsbonus_scouts",
    sco_lowland_raiders = "shield_unitsbonus_scouts",
    vik_scouts = "shield_unitsbonus_scouts",
    nor_scout_cavalry = "shield_unitsbonus_scouts",
    est_hunters = "shield_unitsbonus_hunters",
    wel_helwyr = "shield_unitsbonus_hunters",
    iri_wolf_hounds = "shield_unitsbonus_captives",
}--:map<string, string>

for unit, effect in pairs(units_to_effects) do
    local uem = _G.uem
    uem.add_effect_to_unit(unit, effect)
end

