local cd = _G.cd

local x_loyalty_effect_to_trait = {
    shield_xloyalty_berserker = "shield_heathen_legendary_bearskin",
    shield_xloyalty_bloodthirsty = "shield_brute_bloodythirsty",
    shield_xloyalty_educated = "shield_scholar_educated",
    shield_xloyalty_friend_of_the_church = "shield_faithful_friend_of_the_church",
    shield_xloyalty_greedy = "shield_magnate_greedy",
    shield_xloyalty_high_born = "shield_scholar_educated",
    shield_xloyalty_just = "shield_judge_just",
    shield_xloyalty_lawful = "shield_judge_lawful",
    shield_xloyalty_oppressor = "shield_tyrant_oppressor",
    shield_xloyalty_pagan = "shield_heathen_pagan",
    shield_xloyalty_sailor = "shield_heathen_sailor",
    shield_xloyalty_subjugator = "shield_tyrant_subjugator",
    shield_xloyalty_violent = "shield_brute_violent",
    shield_xloyalty_wise = "shield_scholar_wise",
    shield_xloyalty_legendary_king = "shield_noble_legendary_king",
    shield_xloyalty_charitable = "shield_faithful_charitable",
    shield_xloyalty_legendary_saint = "shield_faithful_legendary_saint",
    shield_xloyalty_legendary_brute = "shield_brute_legendary_brute",
    shield_xloyalty_legendary_tyrant = "shield_tyrant_legendary_tyrant",
    shield_xloyalty_honourable = "shield_judge_honourable",
    shield_xloyalty_legendary_judge = "shield_judge_legendary_judge",
    shield_xloyalty_seneschal = "shield_magnate_seneschal",
    shield_xloyalty_legendary_magnate = "shield_magnate_legendary_magnate",
    shield_xloyalty_champion = "shield_warrior_champion",
    shield_xloyalty_legendary_warrior = "shield_warrior_legendary_warrior",
    shield_xloyalty_princely = "shield_noble_princely",
    shield_xloyalty_hunter = "shield_noble_hunter",
    shield_xloyalty_proud = "shield_noble_proud",
    shield_xloyalty_repentent = "shield_faithful_repentent",
    shield_xloyalty_dutifull = "shield_elder_dutifull",
    shield_xloyalty_husbandman = "shield_elder_husbandman",
    shield_xloyalty_beloved = "shield_elder_beloved"
}--:map<string, string>

local cross_loyalty_junction = {
	["shield_heathen_legendary_wolfskin"] = { ["trait_level"] = "shield_heathen_legendary_wolfskin", ["effect"] = "shield_xloyalty_berserker", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_heathen_legendary_bearskin"] = { ["trait_level"] = "shield_heathen_legendary_bearskin", ["effect"] = "shield_xloyalty_berserker", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_brute_bloodythirsty"] = { ["trait_level"] = "shield_brute_bloodythirsty", ["effect"] = "shield_xloyalty_bloodthirsty", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_scholar_educated"] = { ["trait_level"] = "shield_scholar_educated", ["effect"] = "shield_xloyalty_educated", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_faithful_friend_of_the_church"] = { ["trait_level"] = "shield_faithful_friend_of_the_church", ["effect"] = "shield_xloyalty_friend_of_the_church", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_magnate_greedy"] = { ["trait_level"] = "shield_magnate_greedy", ["effect"] = "shield_xloyalty_greedy", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_noble_high_born"] = { ["trait_level"] = "shield_noble_high_born", ["effect"] = "shield_xloyalty_high_born", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_judge_just"] = { ["trait_level"] = "shield_judge_just", ["effect"] = "shield_xloyalty_just", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_judge_lawful"] = { ["trait_level"] = "shield_judge_lawful", ["effect"] = "shield_xloyalty_lawful", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_tyrant_oppressor"] = { ["trait_level"] = "shield_tyrant_oppressor", ["effect"] = "shield_xloyalty_oppressor", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_heathen_pagan"] = { ["trait_level"] = "shield_heathen_pagan", ["effect"] = "shield_xloyalty_pagan", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_heathen_sailor"] = { ["trait_level"] = "shield_heathen_sailor", ["effect"] = "shield_xloyalty_sailor", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_tyrant_subjugator"] = { ["trait_level"] = "shield_tyrant_subjugator", ["effect"] = "shield_xloyalty_subjugator", ["effect_scope"] = "character_to_character_own", ["value"] = -1 },
	["shield_brute_violent"] = { ["trait_level"] = "shield_brute_violent", ["effect"] = "shield_xloyalty_violent", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_scholar_wise"] = { ["trait_level"] = "shield_scholar_wise", ["effect"] = "shield_xloyalty_wise", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_noble_legendary_king"] = { ["trait_level"] = "shield_noble_legendary_king", ["effect"] = "shield_xloyalty_legendary_king", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_faithful_charitable"] = { ["trait_level"] = "shield_faithful_charitable", ["effect"] = "shield_xloyalty_charitable", ["effect_scope"] = "character_to_character_own", ["value"] = -1 },
	["shield_faithful_legendary_saint"] = { ["trait_level"] = "shield_faithful_legendary_saint", ["effect"] = "shield_xloyalty_legendary_saint", ["effect_scope"] = "character_to_character_own", ["value"] = -1 },
	["shield_brute_legendary_brute"] = { ["trait_level"] = "shield_brute_legendary_brute", ["effect"] = "shield_xloyalty_legendary_brute", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_tyrant_legendary_tyrant"] = { ["trait_level"] = "shield_tyrant_legendary_tyrant", ["effect"] = "shield_xloyalty_legendary_tyrant", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_judge_honourable"] = { ["trait_level"] = "shield_judge_honourable", ["effect"] = "shield_xloyalty_honourable", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_judge_legendary_judge"] = { ["trait_level"] = "shield_judge_legendary_judge", ["effect"] = "shield_xloyalty_legendary_judge", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_magnate_seneschal"] = { ["trait_level"] = "shield_magnate_seneschal", ["effect"] = "shield_xloyalty_seneschal", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_magnate_legendary_magnate"] = { ["trait_level"] = "shield_magnate_legendary_magnate", ["effect"] = "shield_xloyalty_legendary_magnate", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_warrior_champion"] = { ["trait_level"] = "shield_warrior_champion", ["effect"] = "shield_xloyalty_champion", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_warrior_legendary_warrior"] = { ["trait_level"] = "shield_warrior_legendary_warrior", ["effect"] = "shield_xloyalty_legendary_warrior", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_noble_princely"] = { ["trait_level"] = "shield_noble_princely", ["effect"] = "shield_xloyalty_princely", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_noble_hunter"] = { ["trait_level"] = "shield_noble_hunter", ["effect"] = "shield_xloyalty_hunter", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_noble_proud"] = { ["trait_level"] = "shield_noble_proud", ["effect"] = "shield_xloyalty_proud", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_faithful_repentent"] = { ["trait_level"] = "shield_faithful_repentent", ["effect"] = "shield_xloyalty_repentent", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_elder_dutifull"] = { ["trait_level"] = "shield_elder_dutifull", ["effect"] = "shield_xloyalty_dutifull", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_elder_husbandman"] = { ["trait_level"] = "shield_elder_husbandman", ["effect"] = "shield_xloyalty_husbandman", ["effect_scope"] = "character_to_character_own", ["value"] = 1 },
	["shield_elder_beloved"] = { ["trait_level"] = "shield_elder_beloved", ["effect"] = "shield_xloyalty_beloved", ["effect_scope"] = "character_to_character_own", ["value"] = 1 }
}--:map<string, {trait_level: string, effect: string, effect_scope: string, value: number}>

for key, record in pairs(cross_loyalty_junction) do
    if x_loyalty_effect_to_trait[record.effect] then
        cd.add_trait_cross_loyalty_to_trait(record.trait_level, x_loyalty_effect_to_trait[record.effect], record.value)
    else
        dev.log("Missing x loyalty effect info for ["..record.effect.."]", "XTraits")
    end
end