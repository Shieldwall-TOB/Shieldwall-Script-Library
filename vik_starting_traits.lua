-------------------------------------------------------------------------------
-------------------------------- SCRIPTED TRAITS ------------------------
-------------------------------------------------------------------------------
------------------------- Created by Laura: 23/11/2017 -----------------
------------------------- Last Updated: 03/07/2018 by Laura ------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Add the starting Personality and Starting traits for new characters

function Add_Starting_Traits_Listeners()
output("#### Adding Starting trait Listeners ####")
	--[[
	cm:add_listener(
		"StartingTraits",
		"CharacterCreated",
		true,
		function(context) StartingTraits(context) end,
		true
	);
	
	cm: add_listener(
		"AITraits",
		"CharacterTurnStart",
		function(context) return context:character():faction():is_human() == false end,
		function(context) StartingTraits(context) end,
		true
	);
	
	cm: add_listener(
		"TraitBackup",
		"CharacterTurnStart",
		true,
		function(context) TraitBackup(context) end, -- In case the character didn't get their traits on creation...
		true
	);
	
	--]]
end



function TraitBackup (context)
	--output ("##########################---- backup traits triggered -----")
	if ((context:character():number_of_traits() <3) and context:character():is_male() == true and context:character():age() > 14) then 
		-- output ("##########################---- backup traits triggered -----")
		-- output (context:character():get_forename())
		StartingTraits(context)
	end
	
	if context:character():faction():is_human() == true then
		EstateTraits(context)
	end
end



function StartingTraits (context)
--output ("### Starting trait script ###")

	local just_created = false

	local pers_traits_any = {
		"vik_pers_aggressive", 
		"vik_pers_assertive",
		"vik_pers_brave",
		"vik_pers_calm",
		"vik_pers_coward",
		"vik_pers_crooked",
		"vik_pers_cruel",
		"vik_pers_decisive",
		"vik_pers_determined",
		"vik_pers_devoted",
		"vik_pers_discreet",
		"vik_pers_eager",
		"vik_pers_forgiving",
		"vik_pers_generous",
		"vik_pers_greedy",
		"vik_pers_heartless",
		"vik_pers_high_spirited",
		"vik_pers_honourable",
		"vik_pers_ignorant",
		"vik_pers_impulsive",
		"vik_pers_indifferent",
		"vik_pers_iron_fist",
		"vik_pers_lazy",
		"vik_pers_level_headed",
		"vik_pers_liar",
		"vik_pers_listless",
		"vik_pers_loyal",
		"vik_pers_passionate",
		"vik_pers_patient",
		"vik_pers_peaceful",
		"vik_pers_persistent",
		"vik_pers_prodigious",
		"vik_pers_proud",
		"vik_pers_prudent",
		"vik_pers_reckless",
		"vik_pers_ruthless",
		"vik_pers_sanguine",
		"vik_pers_stupid",
		"vik_pers_tactical",
		"vik_pers_temperamental",
		"vik_pers_vigorous",
		"vik_pers_wise",
		"vik_pers_zealous"
		}
		
		local pers_traits_general = {
		"vik_pers_high_spirited",
		"vik_pers_prodigious",
		"vik_pers_eager",
		"vik_pers_passionate",
		"vik_pers_persistent",
		"vik_pers_temperamental",
		"vik_pers_ignorant",
		"vik_pers_heartless",
		"vik_pers_zealous",
		"vik_pers_impulsive",
		"vik_pers_reckless",
		"vik_pers_crooked",
		"vik_pers_stupid",
		"vik_pers_lazy",
		"vik_pers_indifferent",
		"vik_pers_brave",
		"vik_pers_decisive",
		"vik_pers_assertive",
		"vik_pers_honourable",
		"vik_pers_iron_fist",
		"vik_pers_ruthless",
		"vik_pers_vigorous",
		"vik_pers_prudent",
		"vik_pers_cruel",
		"vik_pers_tactical",
		"vik_pers_aggressive",
		"vik_pers_level_headed",
		"vik_pers_listless",
		"vik_pers_coward"
		}
		
		local pers_traits_governor = {
		"vik_pers_discreet",
		"vik_pers_loyal",
		"vik_pers_devoted",
		"vik_pers_forgiving",
		"vik_pers_peaceful",
		"vik_pers_patient",
		"vik_pers_determined",
		"vik_pers_sanguine",
		"vik_pers_wise",
		"vik_pers_generous",
		"vik_pers_liar",
		"vik_pers_calm",
		"vik_pers_proud",
		"vik_pers_greedy"
		}
		
		local start_traits_any = {
		"vik_start_admired",
		"vik_start_afraid_in_the_dark",
		"vik_start_arrogant",
		"vik_start_believer",
		"vik_start_bloodthirsty",
		"vik_start_boring",
		"vik_start_cheapskate",
		"vik_start_chivalrous",
		"vik_start_curious",
		"vik_start_energetic",
		"vik_start_enthusiastic",
		"vik_start_famed",
		"vik_start_fighter",
		"vik_start_forward_thinker",
		"vik_start_friendly",
		"vik_start_funny",
		"vik_start_gambler",
		"vik_start_good_leader",
		"vik_start_good_to_his_men",
		"vik_start_handsome",
		"vik_start_has_principles",
		"vik_start_honest_man",
		"vik_start_hydrophil",
		"vik_start_illustrious",
		"vik_start_intelligent",
		"vik_start_just",
		"vik_start_knack_for_architecture",
		"vik_start_land_lover",
		"vik_start_mad",
		"vik_start_negotiator",
		"vik_start_night_owl",
		"vik_start_nurturer",
		"vik_start_pacifist",
		"vik_start_pious",
		"vik_start_politician",
		"vik_start_prepared",
		"vik_start_producer",
		"vik_start_prolific",
		"vik_start_public_speaker",
		"vik_start_renowned",
		"vik_start_rider",
		"vik_start_seasoned",
		"vik_start_shabby",
		"vik_start_skillful",
		"vik_start_strategist",
		"vik_start_strict",
		"vik_start_survivor",
		"vik_start_technical",
		"vik_start_trader",
		"vik_start_trustworthy",
		"vik_start_zealot"
	}
	
	local start_traits_general = {
		"vik_start_handsome",
		"vik_start_shabby",
		"vik_start_boring",
		"vik_start_funny",
		"vik_start_good_leader",
		"vik_start_bloodthirsty",
		"vik_start_prepared",
		"vik_start_night_owl",
		"vik_start_energetic",
		"vik_start_rider",
		"vik_start_mad",
		"vik_start_enthusiastic",
		"vik_start_fighter",
		"vik_start_hydrophil",
		"vik_start_land_lover",
		"vik_start_afraid_in_the_dark",
		"vik_start_negotiator",
		"vik_start_famed",
		"vik_start_zealot",
		"vik_start_survivor",
		"vik_start_renowned",
		"vik_start_illustrious",
		"vik_start_skillful",
		"vik_start_seasoned",
		"vik_start_good_to_his_men",
		"vik_start_admired",
		"vik_start_friendly"
	}
	
	local start_traits_governor = {
		"vik_start_handsome",
		"vik_start_shabby",
		"vik_start_boring",
		"vik_start_pious",
		"vik_start_gambler",
		"vik_start_honest_man",
		"vik_start_trustworthy",
		"vik_start_has_principles",
		"vik_start_politician",
		"vik_start_arrogant",
		"vik_start_prolific",
		"vik_start_nurturer",
		"vik_start_technical",
		"vik_start_cheapskate",
		"vik_start_chivalrous",
		"vik_start_just",
		"vik_start_pacifist",
		"vik_start_strict",
		"vik_start_knack_for_architecture",
		"vik_start_believer",
		"vik_start_public_speaker",
		"vik_start_producer",
		"vik_start_trader",
		"vik_start_curious",
		"vik_start_intelligent",
		"vik_start_forward_thinker",
		"vik_start_strategist"
	}
	
	local bg_general = {
		"vik_general_back_melee_skill",
		"vik_general_back_cavalry_recruitment",
		"vik_general_back_spearmen_recruitment",
		"vik_general_back_missile_recruitment",
		"vik_general_back_spearmen_skill",
		"vik_general_back_missile_damage",
		"vik_general_back_melee_upkeep",
		"vik_general_back_cavalry_upkeep",
		"vik_general_back_missile_upkeep",
		"vik_general_back_spearmen_upkeep",
		"vik_general_back_born_commander",
		"vik_general_back_seafarer",
		"vik_general_back_fearless",
		"vik_general_back_defender",
		"vik_general_back_warrior",
		"vik_general_back_champion_rider",
		"vik_general_back_melee_skill_gwined",
		"vik_general_back_cavalry_recruitment_gwined",
		"vik_general_back_spearmen_recruitment_gwined",
		"vik_general_back_missile_recruitment_gwined",
		"vik_general_back_spearmen_skill_gwined",
		"vik_general_back_missile_damage_gwined",
		"vik_general_back_melee_upkeep_gwined",
		"vik_general_back_cavalry_upkeep_gwined",
		"vik_general_back_missile_upkeep_gwined",
		"vik_general_back_spearmen_upkeep_gwined",
		"vik_general_back_born_commander_gwined",
		"vik_general_back_seafarer_gwined",
		"vik_general_back_fearless_gwined",
		"vik_general_back_defender_gwined",
		"vik_general_back_warrior_gwined",
		"vik_general_back_champion_rider_gwined",
		"vik_general_back_born_commander_circenn",
		"vik_general_back_born_commander_dyflin",
		"vik_general_back_born_commander_east_engle",
		"vik_general_back_born_commander_mide",
		"vik_general_back_born_commander_mierce",
		"vik_general_back_born_commander_northymbre",
		"vik_general_back_born_commander_strat_clut",
		"vik_general_back_born_commander_sudreyar",
		"vik_general_back_born_commander_west_seaxe",
		"vik_general_back_cavalry_recruitment_circenn",
		"vik_general_back_cavalry_recruitment_dyflin",
		"vik_general_back_cavalry_recruitment_east_engle",
		"vik_general_back_cavalry_recruitment_mide",
		"vik_general_back_cavalry_recruitment_mierce",
		"vik_general_back_cavalry_recruitment_northymbre",
		"vik_general_back_cavalry_recruitment_strat_clut",
		"vik_general_back_cavalry_recruitment_sudreyar",
		"vik_general_back_cavalry_recruitment_west_seaxe",
		"vik_general_back_cavalry_upkeep_circenn",
		"vik_general_back_cavalry_upkeep_dyflin",
		"vik_general_back_cavalry_upkeep_east_engle",
		"vik_general_back_cavalry_upkeep_mide",
		"vik_general_back_cavalry_upkeep_mierce",
		"vik_general_back_cavalry_upkeep_northymbre",
		"vik_general_back_cavalry_upkeep_strat_clut",
		"vik_general_back_cavalry_upkeep_sudreyar",
		"vik_general_back_cavalry_upkeep_west_seaxe",
		"vik_general_back_champion_rider_circenn",
		"vik_general_back_champion_rider_dyflin",
		"vik_general_back_champion_rider_east_engle",
		"vik_general_back_champion_rider_mide",
		"vik_general_back_champion_rider_mierce",
		"vik_general_back_champion_rider_northymbre",
		"vik_general_back_champion_rider_strat_clut",
		"vik_general_back_champion_rider_sudreyar",
		"vik_general_back_champion_rider_west_seaxe",
		"vik_general_back_defender_circenn",
		"vik_general_back_defender_dyflin",
		"vik_general_back_defender_east_engle",
		"vik_general_back_defender_mide",
		"vik_general_back_defender_mierce",
		"vik_general_back_defender_northymbre",
		"vik_general_back_defender_strat_clut",
		"vik_general_back_defender_sudreyar",
		"vik_general_back_defender_west_seaxe",
		"vik_general_back_fearless_circenn",
		"vik_general_back_fearless_dyflin",
		"vik_general_back_fearless_east_engle",
		"vik_general_back_fearless_mide",
		"vik_general_back_fearless_mierce",
		"vik_general_back_fearless_northymbre",
		"vik_general_back_fearless_strat_clut",
		"vik_general_back_fearless_sudreyar",
		"vik_general_back_fearless_west_seaxe",
		"vik_general_back_melee_skill_circenn",
		"vik_general_back_melee_skill_dyflin",
		"vik_general_back_melee_skill_east_engle",
		"vik_general_back_melee_skill_mide",
		"vik_general_back_melee_skill_mierce",
		"vik_general_back_melee_skill_northymbre",
		"vik_general_back_melee_skill_strat_clut",
		"vik_general_back_melee_skill_sudreyar",
		"vik_general_back_melee_skill_west_seaxe",
		"vik_general_back_melee_upkeep_circenn",
		"vik_general_back_melee_upkeep_dyflin",
		"vik_general_back_melee_upkeep_east_engle",
		"vik_general_back_melee_upkeep_mide",
		"vik_general_back_melee_upkeep_mierce",
		"vik_general_back_melee_upkeep_northymbre",
		"vik_general_back_melee_upkeep_strat_clut",
		"vik_general_back_melee_upkeep_sudreyar",
		"vik_general_back_melee_upkeep_west_seaxe",
		"vik_general_back_missile_damage_circenn",
		"vik_general_back_missile_damage_dyflin",
		"vik_general_back_missile_damage_east_engle",
		"vik_general_back_missile_damage_mide",
		"vik_general_back_missile_damage_mierce",
		"vik_general_back_missile_damage_northymbre",
		"vik_general_back_missile_damage_strat_clut",
		"vik_general_back_missile_damage_sudreyar",
		"vik_general_back_missile_damage_west_seaxe",
		"vik_general_back_missile_recruitment_circenn",
		"vik_general_back_missile_recruitment_dyflin",
		"vik_general_back_missile_recruitment_east_engle",
		"vik_general_back_missile_recruitment_mide",
		"vik_general_back_missile_recruitment_mierce",
		"vik_general_back_missile_recruitment_northymbre",
		"vik_general_back_missile_recruitment_strat_clut",
		"vik_general_back_missile_recruitment_sudreyar",
		"vik_general_back_missile_recruitment_west_seaxe",
		"vik_general_back_missile_upkeep_circenn",
		"vik_general_back_missile_upkeep_dyflin",
		"vik_general_back_missile_upkeep_east_engle",
		"vik_general_back_missile_upkeep_mide",
		"vik_general_back_missile_upkeep_mierce",
		"vik_general_back_missile_upkeep_northymbre",
		"vik_general_back_missile_upkeep_strat_clut",
		"vik_general_back_missile_upkeep_sudreyar",
		"vik_general_back_missile_upkeep_west_seaxe",
		"vik_general_back_seafarer_circenn",
		"vik_general_back_seafarer_dyflin",
		"vik_general_back_seafarer_east_engle",
		"vik_general_back_seafarer_mide",
		"vik_general_back_seafarer_mierce",
		"vik_general_back_seafarer_northymbre",
		"vik_general_back_seafarer_strat_clut",
		"vik_general_back_seafarer_sudreyar",
		"vik_general_back_seafarer_west_seaxe",
		"vik_general_back_spearmen_recruitment_circenn",
		"vik_general_back_spearmen_recruitment_dyflin",
		"vik_general_back_spearmen_recruitment_east_engle",
		"vik_general_back_spearmen_recruitment_mide",
		"vik_general_back_spearmen_recruitment_mierce",
		"vik_general_back_spearmen_recruitment_northymbre",
		"vik_general_back_spearmen_recruitment_strat_clut",
		"vik_general_back_spearmen_recruitment_sudreyar",
		"vik_general_back_spearmen_recruitment_west_seaxe",
		"vik_general_back_spearmen_skill_circenn",
		"vik_general_back_spearmen_skill_dyflin",
		"vik_general_back_spearmen_skill_east_engle",
		"vik_general_back_spearmen_skill_mide",
		"vik_general_back_spearmen_skill_mierce",
		"vik_general_back_spearmen_skill_northymbre",
		"vik_general_back_spearmen_skill_strat_clut",
		"vik_general_back_spearmen_skill_sudreyar",
		"vik_general_back_spearmen_skill_west_seaxe",
		"vik_general_back_spearmen_upkeep_circenn",
		"vik_general_back_spearmen_upkeep_dyflin",
		"vik_general_back_spearmen_upkeep_east_engle",
		"vik_general_back_spearmen_upkeep_mide",
		"vik_general_back_spearmen_upkeep_mierce",
		"vik_general_back_spearmen_upkeep_northymbre",
		"vik_general_back_spearmen_upkeep_strat_clut",
		"vik_general_back_spearmen_upkeep_sudreyar",
		"vik_general_back_spearmen_upkeep_west_seaxe",
		"vik_general_back_warrior_circenn",
		"vik_general_back_warrior_dyflin",
		"vik_general_back_warrior_east_engle",
		"vik_general_back_warrior_mide",
		"vik_general_back_warrior_mierce",
		"vik_general_back_warrior_northymbre",
		"vik_general_back_warrior_strat_clut",
		"vik_general_back_warrior_sudreyar",
		"vik_general_back_warrior_west_seaxe"

	}
	
	local bg_governor = {
		"vik_general_back_farmer",
		"vik_general_back_miner",
		"vik_general_back_landowner",
		"vik_general_back_merchant",
		"vik_general_back_pastor",
		"vik_general_back_negotiator",
		"vik_general_back_born_governor",
		"vik_general_back_farmer_gwined",
		"vik_general_back_miner_gwined",
		"vik_general_back_landowner_gwined",
		"vik_general_back_merchant_gwined",
		"vik_general_back_pastor_gwined",
		"vik_general_back_negotiator_gwined",
		"vik_general_back_born_governor_gwined",
		"vik_general_back_born_governor_circenn",
		"vik_general_back_born_governor_dyflin",
		"vik_general_back_born_governor_east_engle",
		"vik_general_back_born_governor_mide",
		"vik_general_back_born_governor_mierce",
		"vik_general_back_born_governor_northymbre",
		"vik_general_back_born_governor_strat_clut",
		"vik_general_back_born_governor_sudreyar",
		"vik_general_back_born_governor_west_seaxe",
		"vik_general_back_landowner_circenn",
		"vik_general_back_landowner_dyflin",
		"vik_general_back_landowner_east_engle",
		"vik_general_back_landowner_mide",
		"vik_general_back_landowner_mierce",
		"vik_general_back_landowner_northymbre",
		"vik_general_back_landowner_strat_clut",
		"vik_general_back_landowner_sudreyar",
		"vik_general_back_landowner_west_seaxe",
		"vik_general_back_merchant_circenn",
		"vik_general_back_merchant_dyflin",
		"vik_general_back_merchant_east_engle",
		"vik_general_back_merchant_mide",
		"vik_general_back_merchant_mierce",
		"vik_general_back_merchant_northymbre",
		"vik_general_back_merchant_strat_clut",
		"vik_general_back_merchant_sudreyar",
		"vik_general_back_merchant_west_seaxe",
		"vik_general_back_miner_circenn",
		"vik_general_back_miner_dyflin",
		"vik_general_back_miner_east_engle",
		"vik_general_back_miner_mide",
		"vik_general_back_miner_mierce",
		"vik_general_back_miner_northymbre",
		"vik_general_back_miner_strat_clut",
		"vik_general_back_miner_sudreyar",
		"vik_general_back_miner_west_seaxe",
		"vik_general_back_negotiator_circenn",
		"vik_general_back_negotiator_dyflin",
		"vik_general_back_negotiator_east_engle",
		"vik_general_back_negotiator_mide",
		"vik_general_back_negotiator_mierce",
		"vik_general_back_negotiator_northymbre",
		"vik_general_back_negotiator_strat_clut",
		"vik_general_back_negotiator_sudreyar",
		"vik_general_back_negotiator_west_seaxe",
		"vik_general_back_pastor_circenn",
		"vik_general_back_pastor_dyflin",
		"vik_general_back_pastor_east_engle",
		"vik_general_back_pastor_mide",
		"vik_general_back_pastor_mierce",
		"vik_general_back_pastor_northymbre",
		"vik_general_back_pastor_strat_clut",
		"vik_general_back_pastor_sudreyar",
		"vik_general_back_pastor_west_seaxe",
		"vik_general_back_farmer_circenn",
		"vik_general_back_farmer_dyflin",
		"vik_general_back_farmer_east_engle",
		"vik_general_back_farmer_mide",
		"vik_general_back_farmer_mierce",
		"vik_general_back_farmer_northymbre",
		"vik_general_back_farmer_strat_clut",
		"vik_general_back_farmer_sudreyar",
		"vik_general_back_farmer_west_seaxe"

	}
	
	local bg_any = {"vik_general_back_passionate",
		"vik_general_back_passionate_gwined",
		"vik_general_back_passionate_circenn",
		"vik_general_back_passionate_dyflin",
		"vik_general_back_passionate_east_engle",
		"vik_general_back_passionate_mide",
		"vik_general_back_passionate_mierce",
		"vik_general_back_passionate_northymbre",
		"vik_general_back_passionate_strat_clut",
		"vik_general_back_passionate_sudreyar",
		"vik_general_back_passionate_west_seaxe"
	}
	-- output (" starting trait script")
	-- output (bg_any[1])
	-- output (context:character():is_null_interface())
	-- output (context:character():get_forename())
	
	
	--output ("------ starting traits function -----")
	
	-------------- Character bg skill test -------------
	-- if context:character():get_forename() == "names_name_2147364072" then
		-- for i=1, #bg_general do
			-- local skill_gen = bg_general[i]
			-- if context:character():has_skill(skill_gen) then
				-- output ("----- bg skill:"..skill_gen)
			-- end
		-- end
		
		-- for i=1, #bg_governor do
			-- local skill_gov = bg_governor[i]
			-- if context:character():has_skill(skill_gov) then
				-- output ("----- bg skill:"..skill_gov)
			-- end
		-- end
	-- end
	
	
	
	if (not context:character():is_null_interface()) then
		if (context:character():is_male() == true) then
			if (context:character():number_of_traits() <3) then -- if they have don't have a full starting trait set, add new ones
			just_created = true
				-- GENERAL BG SKILL
				for i=1, #bg_general do
					local skill_gen = bg_general[i]
					if context:character():has_skill(skill_gen) then
					-- output (skill_gen)
					-- output ("----general----")
						local pers_gen = pers_traits_general[cm:random_number(#pers_traits_general, 1)]
						local start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						local start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						local start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						
						
						
						if ((pers_gen == "vik_pers_aggressive" and start1_gen == "vik_start_pacifist") or (pers_gen == "vik_pers_crooked" and start1_gen == "vik_start_honest_man") or (pers_gen == "vik_pers_crooked" and start1_gen == "vik_start_trustworthy") 
						or (pers_gen == "vik_pers_honourable" and start1_gen == "vik_start_gambler") or (pers_gen == "vik_pers_calm" and start1_gen == "vik_start_bloodthirsty") or (pers_gen == "vik_pers_liar" and start1_gen == "vik_start_honest_man") 
						or (pers_gen == "vik_pers_stupid" and start1_gen == "vik_start_forward_thinker") or (pers_gen == "vik_pers_zealous" and start1_gen == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start1_gen == "vik_start_enthusiastic")) then
							--output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((pers_gen == "vik_pers_aggressive" and start2_gen == "vik_start_pacifist") or (pers_gen == "vik_pers_crooked" and start2_gen == "vik_start_honest_man") or (pers_gen == "vik_pers_crooked" and start2_gen == "vik_start_trustworthy") 
						or (pers_gen == "vik_pers_honourable" and start2_gen == "vik_start_gambler") or (pers_gen == "vik_pers_calm" and start2_gen == "vik_start_bloodthirsty") or (pers_gen == "vik_pers_liar" and start2_gen == "vik_start_honest_man") 
						or (pers_gen == "vik_pers_stupid" and start2_gen == "vik_start_forward_thinker") or (pers_gen == "vik_pers_zealous" and start2_gen == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start2_gen == "vik_start_enthusiastic")) then
							--output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((pers_gen == "vik_pers_aggressive" and start3_gen == "vik_start_pacifist") or (pers_gen == "vik_pers_crooked" and start3_gen == "vik_start_honest_man") or (pers_gen == "vik_pers_crooked" and start3_gen == "vik_start_trustworthy") 
						or (pers_gen == "vik_pers_honourable" and start3_gen == "vik_start_gambler") or (pers_gen == "vik_pers_calm" and start3_gen == "vik_start_bloodthirsty") or (pers_gen == "vik_pers_liar" and start3_gen == "vik_start_honest_man") 
						or (pers_gen == "vik_pers_stupid" and start3_gen == "vik_start_forward_thinker") or (pers_gen == "vik_pers_zealous" and start3_gen == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start3_gen == "vik_start_enthusiastic")) then
							--output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Contradicting name traits -- 
						if ((start1_gen == "vik_start_hydrophil" and (start2_gen == "vik_start_land_lover" or start3_gen == "vik_start_land_lover")) or (start1_gen == "vik_start_afraid_in_the_dark" and (start2_gen == "vik_start_night_owl" or start3_gen == "vik_start_night_owl"))
						or (start1_gen == "vik_start_shabby" and (start2_gen == "vik_start_handsome" or start3_gen == "vik_start_handsome"))) then
							--output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_hydrophil" and (start1_gen == "vik_start_land_lover" or start3_gen == "vik_start_land_lover")) or (start2_gen == "vik_start_afraid_in_the_dark" and (start1_gen == "vik_start_night_owl" or start3_gen == "vik_start_night_owl"))
						or (start2_gen == "vik_start_shabby" and (start1_gen == "vik_start_handsome" or start3_gen == "vik_start_handsome"))) then
							--output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_hydrophil" and (start2_gen == "vik_start_land_lover" or start1_gen == "vik_start_land_lover")) or (start3_gen == "vik_start_afraid_in_the_dark" and (start2_gen == "vik_start_night_owl" or start1_gen == "vik_start_night_owl"))
						or (start3_gen == "vik_start_shabby" and (start2_gen == "vik_start_handsome" or start1_gen == "vik_start_handsome"))) then
							--output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Upkeep traits --
						if ((start1_gen == "vik_start_admired" and (start2_gen == "vik_start_friendly" or start3_gen == "vik_start_friendly")) or (start1_gen == "vik_start_admired" and (start2_gen == "vik_start_good_to_his_men" or start3_gen == "vik_start_good_to_his_men"))
						or (start1_gen == "vik_start_friendly" and (start2_gen == "vik_start_admired" or start3_gen == "vik_start_admired")) or (start1_gen == "vik_start_friendly" and (start2_gen == "vik_start_good_to_his_men" or start3_gen == "vik_start_good_to_his_men"))
						or (start1_gen == "vik_start_good_to_his_men" and (start2_gen == "vik_start_admired" or start3_gen == "vik_start_admired")) or (start1_gen == "vik_start_good_to_his_men" and (start2_gen == "vik_start_friendly" or start3_gen == "vik_start_friendly"))) then
							--output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_admired" and (start1_gen == "vik_start_friendly" or start3_gen == "vik_start_friendly")) or (start2_gen == "vik_start_admired" and (start1_gen == "vik_start_good_to_his_men" or start3_gen == "vik_start_good_to_his_men"))
						or (start2_gen == "vik_start_friendly" and (start1_gen == "vik_start_admired" or start3_gen == "vik_start_admired")) or (start2_gen == "vik_start_friendly" and (start1_gen == "vik_start_good_to_his_men" or start3_gen == "vik_start_good_to_his_men"))
						or (start2_gen == "vik_start_good_to_his_men" and (start1_gen == "vik_start_admired" or start3_gen == "vik_start_admired")) or (start2_gen == "vik_start_good_to_his_men" and (start1_gen == "vik_start_friendly" or start3_gen == "vik_start_friendly"))) then
							--output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_admired" and (start2_gen == "vik_start_friendly" or start1_gen == "vik_start_friendly")) or (start3_gen == "vik_start_admired" and (start2_gen == "vik_start_good_to_his_men" or start1_gen == "vik_start_good_to_his_men"))
						or (start3_gen == "vik_start_friendly" and (start2_gen == "vik_start_admired" or start1_gen == "vik_start_admired")) or (start3_gen == "vik_start_friendly" and (start2_gen == "vik_start_good_to_his_men" or start1_gen == "vik_start_good_to_his_men"))
						or (start3_gen == "vik_start_good_to_his_men" and (start2_gen == "vik_start_admired" or start1_gen == "vik_start_admired")) or (start3_gen == "vik_start_good_to_his_men" and (start2_gen == "vik_start_friendly" or start1_gen == "vik_start_friendly"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						-- Research traits --
						if ((start1_gen == "vik_start_curious" and (start2_gen == "vik_start_intelligent" or start3_gen == "vik_start_intelligent")) or (start1_gen == "vik_start_intelligent" and (start2_gen == "vik_start_curious" or start3_gen == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_curious" and (start1_gen == "vik_start_intelligent" or start3_gen == "vik_start_intelligent")) or (start2_gen == "vik_start_intelligent" and (start1_gen == "vik_start_curious" or start3_gen == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_curious" and (start2_gen == "vik_start_intelligent" or start1_gen == "vik_start_intelligent")) or (start3_gen == "vik_start_intelligent" and (start2_gen == "vik_start_curious" or start1_gen == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- PO traits --
						if ((start1_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_just" or start3_gen == "vik_start_just")) or (start1_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer"))
						or (start1_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start1_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start1_gen == "vik_start_just" and (start2_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start1_gen == "vik_start_just" and (start2_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer"))
						or (start1_gen == "vik_start_just" and (start2_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start1_gen == "vik_start_just" and (start2_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start1_gen == "vik_start_nurturer" and (start2_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start1_gen == "vik_start_nurturer" and (start2_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start1_gen == "vik_start_nurturer" and (start2_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start1_gen == "vik_start_nurturer" and (start2_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start1_gen == "vik_start_pacifist" and (start2_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start1_gen == "vik_start_pacifist" and (start2_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start1_gen == "vik_start_pacifist" and (start2_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer")) or (start1_gen == "vik_start_pacifist" and (start2_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start1_gen == "vik_start_strict" and (start2_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start1_gen == "vik_start_strict" and (start2_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start1_gen == "vik_start_strict" and (start2_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer")) or (start1_gen == "vik_start_strict" and (start2_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_chivalrous" and (start1_gen == "vik_start_just" or start3_gen == "vik_start_just")) or (start2_gen == "vik_start_chivalrous" and (start1_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer"))
						or (start2_gen == "vik_start_chivalrous" and (start1_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start2_gen == "vik_start_chivalrous" and (start1_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start2_gen == "vik_start_just" and (start1_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start2_gen == "vik_start_just" and (start1_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer"))
						or (start2_gen == "vik_start_just" and (start1_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start2_gen == "vik_start_just" and (start1_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start2_gen == "vik_start_nurturer" and (start1_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start2_gen == "vik_start_nurturer" and (start1_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start2_gen == "vik_start_nurturer" and (start1_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist")) or (start2_gen == "vik_start_nurturer" and (start1_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start2_gen == "vik_start_pacifist" and (start1_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start2_gen == "vik_start_pacifist" and (start1_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start2_gen == "vik_start_pacifist" and (start1_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer")) or (start2_gen == "vik_start_pacifist" and (start1_gen == "vik_start_strict" or start3_gen == "vik_start_strict"))
						or (start2_gen == "vik_start_strict" and (start1_gen == "vik_start_chivalrous" or start3_gen == "vik_start_chivalrous")) or (start2_gen == "vik_start_strict" and (start1_gen == "vik_start_just" or start3_gen == "vik_start_just"))
						or (start2_gen == "vik_start_strict" and (start1_gen == "vik_start_nurturer" or start3_gen == "vik_start_nurturer")) or (start2_gen == "vik_start_strict" and (start1_gen == "vik_start_pacifist" or start3_gen == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_just" or start1_gen == "vik_start_just")) or (start3_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_nurturer" or start1_gen == "vik_start_nurturer"))
						or (start3_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_pacifist" or start1_gen == "vik_start_pacifist")) or (start3_gen == "vik_start_chivalrous" and (start2_gen == "vik_start_strict" or start1_gen == "vik_start_strict"))
						or (start3_gen == "vik_start_just" and (start2_gen == "vik_start_chivalrous" or start1_gen == "vik_start_chivalrous")) or (start3_gen == "vik_start_just" and (start2_gen == "vik_start_nurturer" or start1_gen == "vik_start_nurturer"))
						or (start3_gen == "vik_start_just" and (start2_gen == "vik_start_pacifist" or start1_gen == "vik_start_pacifist")) or (start3_gen == "vik_start_just" and (start2_gen == "vik_start_strict" or start1_gen == "vik_start_strict"))
						or (start3_gen == "vik_start_nurturer" and (start2_gen == "vik_start_chivalrous" or start1_gen == "vik_start_chivalrous")) or (start3_gen == "vik_start_nurturer" and (start2_gen == "vik_start_just" or start1_gen == "vik_start_just"))
						or (start3_gen == "vik_start_nurturer" and (start2_gen == "vik_start_pacifist" or start1_gen == "vik_start_pacifist")) or (start3_gen == "vik_start_nurturer" and (start2_gen == "vik_start_strict" or start1_gen == "vik_start_strict"))
						or (start3_gen == "vik_start_pacifist" and (start2_gen == "vik_start_chivalrous" or start1_gen == "vik_start_chivalrous")) or (start3_gen == "vik_start_pacifist" and (start2_gen == "vik_start_just" or start1_gen == "vik_start_just"))
						or (start3_gen == "vik_start_pacifist" and (start2_gen == "vik_start_nurturer" or start1_gen == "vik_start_nurturer")) or (start3_gen == "vik_start_pacifist" and (start2_gen == "vik_start_strict" or start1_gen == "vik_start_strict"))
						or (start3_gen == "vik_start_strict" and (start2_gen == "vik_start_chivalrous" or start1_gen == "vik_start_chivalrous")) or (start3_gen == "vik_start_strict" and (start2_gen == "vik_start_just" or start1_gen == "vik_start_just"))
						or (start3_gen == "vik_start_strict" and (start2_gen == "vik_start_nurturer" or start1_gen == "vik_start_nurturer")) or (start3_gen == "vik_start_strict" and (start2_gen == "vik_start_pacifist" or start1_gen == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Siege traits --
						if ((start1_gen == "vik_start_forward_thinker" and (start2_gen == "vik_start_strategist" or start3_gen == "vik_start_strategist")) or (start1_gen == "vik_start_strategist" and (start2_gen == "vik_start_forward_thinker" or start3_gen == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_forward_thinker" and (start1_gen == "vik_start_strategist" or start3_gen == "vik_start_strategist")) or (start2_gen == "vik_start_strategist" and (start1_gen == "vik_start_forward_thinker" or start3_gen == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_forward_thinker" and (start2_gen == "vik_start_strategist" or start1_gen == "vik_start_strategist")) or (start3_gen == "vik_start_strategist" and (start2_gen == "vik_start_forward_thinker" or start1_gen == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						-- Corruption traits --
						if ((start1_gen == "vik_start_gambler" and (start2_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start1_gen == "vik_start_gambler" and (start2_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start1_gen == "vik_start_gambler" and (start2_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start1_gen == "vik_start_has_principles" and (start2_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler")) or (start1_gen == "vik_start_has_principles" and (start2_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start1_gen == "vik_start_has_principles" and (start2_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start1_gen == "vik_start_honest_man" and (start2_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start1_gen == "vik_start_honest_man" and (start2_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler"))
						or (start1_gen == "vik_start_honest_man" and (start2_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start1_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start1_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start1_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_gambler" and (start1_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start2_gen == "vik_start_gambler" and (start1_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start2_gen == "vik_start_gambler" and (start1_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start2_gen == "vik_start_has_principles" and (start1_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler")) or (start2_gen == "vik_start_has_principles" and (start1_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start2_gen == "vik_start_has_principles" and (start1_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start2_gen == "vik_start_honest_man" and (start1_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start2_gen == "vik_start_honest_man" and (start1_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler"))
						or (start2_gen == "vik_start_honest_man" and (start1_gen == "vik_start_trustworthy" or start3_gen == "vik_start_trustworthy"))
						or (start2_gen == "vik_start_trustworthy" and (start1_gen == "vik_start_has_principles" or start3_gen == "vik_start_has_principles")) or (start2_gen == "vik_start_trustworthy" and (start1_gen == "vik_start_honest_man" or start3_gen == "vik_start_honest_man"))
						or (start2_gen == "vik_start_trustworthy" and (start1_gen == "vik_start_gambler" or start3_gen == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_gambler" and (start2_gen == "vik_start_has_principles" or start1_gen == "vik_start_has_principles")) or (start3_gen == "vik_start_gambler" and (start2_gen == "vik_start_honest_man" or start1_gen == "vik_start_honest_man"))
						or (start3_gen == "vik_start_gambler" and (start2_gen == "vik_start_trustworthy" or start1_gen == "vik_start_trustworthy"))
						or (start3_gen == "vik_start_has_principles" and (start2_gen == "vik_start_gambler" or start1_gen == "vik_start_gambler")) or (start3_gen == "vik_start_has_principles" and (start2_gen == "vik_start_honest_man" or start1_gen == "vik_start_honest_man"))
						or (start3_gen == "vik_start_has_principles" and (start2_gen == "vik_start_trustworthy" or start1_gen == "vik_start_trustworthy"))
						or (start3_gen == "vik_start_honest_man" and (start2_gen == "vik_start_has_principles" or start1_gen == "vik_start_has_principles")) or (start3_gen == "vik_start_honest_man" and (start2_gen == "vik_start_gambler" or start1_gen == "vik_start_gambler"))
						or (start3_gen == "vik_start_honest_man" and (start2_gen == "vik_start_trustworthy" or start1_gen == "vik_start_trustworthy"))
						or (start3_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_has_principles" or start1_gen == "vik_start_has_principles")) or (start3_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_honest_man" or start1_gen == "vik_start_honest_man"))
						or (start3_gen == "vik_start_trustworthy" and (start2_gen == "vik_start_gambler" or start1_gen == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Replenishment traits --
						if ((start1_gen == "vik_start_illustrious" and (start2_gen == "vik_start_renowned" or start3_gen == "vik_start_renowned")) or (start1_gen == "vik_start_illustrious" and (start2_gen == "vik_start_survivor" or start3_gen == "vik_start_survivor"))
						or (start1_gen == "vik_start_renowned" and (start2_gen == "vik_start_illustrious" or start3_gen == "vik_start_illustrious")) or (start1_gen == "vik_start_renowned" and (start2_gen == "vik_start_survivor" or start3_gen == "vik_start_survivor"))
						or (start1_gen == "vik_start_survivor" and (start2_gen == "vik_start_renowned" or start3_gen == "vik_start_renowned")) or (start1_gen == "vik_start_survivor" and (start2_gen == "vik_start_illustrious" or start3_gen == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start1_gen)
							start1_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gen == "vik_start_illustrious" and (start1_gen == "vik_start_renowned" or start3_gen == "vik_start_renowned")) or (start2_gen == "vik_start_illustrious" and (start1_gen == "vik_start_survivor" or start3_gen == "vik_start_survivor"))
						or (start2_gen == "vik_start_renowned" and (start1_gen == "vik_start_illustrious" or start3_gen == "vik_start_illustrious")) or (start2_gen == "vik_start_renowned" and (start1_gen == "vik_start_survivor" or start3_gen == "vik_start_survivor"))
						or (start2_gen == "vik_start_survivor" and (start1_gen == "vik_start_renowned" or start3_gen == "vik_start_renowned")) or (start2_gen == "vik_start_survivor" and (start1_gen == "vik_start_illustrious" or start3_gen == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start2_gen)
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gen == "vik_start_illustrious" and (start2_gen == "vik_start_renowned" or start1_gen == "vik_start_renowned")) or (start3_gen == "vik_start_illustrious" and (start2_gen == "vik_start_survivor" or start1_gen == "vik_start_survivor"))
						or (start3_gen == "vik_start_renowned" and (start2_gen == "vik_start_illustrious" or start1_gen == "vik_start_illustrious")) or (start3_gen == "vik_start_renowned" and (start2_gen == "vik_start_survivor" or start1_gen == "vik_start_survivor"))
						or (start3_gen == "vik_start_survivor" and (start2_gen == "vik_start_renowned" or start1_gen == "vik_start_renowned")) or (start3_gen == "vik_start_survivor" and (start2_gen == "vik_start_illustrious" or start1_gen == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start3_gen)
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- end of specific dupe check --
						
						if (start2_gen == start1_gen) then
							start2_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						if (start3_gen == start2_gen or start3_gen == start1_gen) then
							start3_gen = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if (context:character():is_male() == true) then
						-- output (context:character():get_forename())
							effect.trait(pers_gen, "agent", 1, 100, context)
								-- output (pers_gen)
								-- output ("----general----")
							effect.trait(start1_gen, "agent", 1, 100, context)
								-- output (start1_gen)
								-- output ("----general----")
							effect.trait(start2_gen, "agent", 1, 100, context)
								-- output (start2_gen)
								-- output ("----general----")
							effect.trait(start3_gen, "agent", 1, 100, context)
								-- output (start3_gen)
								-- output ("----general----")
						end
						
					end
				end
					
				-- output ("not general")
				
				-- GOVERNOR BG SKILL
				for i=1, #bg_governor do
					local skill_gov = bg_governor[i]
					if context:character():has_skill(skill_gov) then
					-- output (skill_gov)
					-- output ("----governor----")
						local pers_gov = pers_traits_governor[cm:random_number(#pers_traits_governor, 1)]
						local start1_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						local start2_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						local start3_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						
						
						if ((pers_gov == "vik_pers_aggressive" and start1_gov == "vik_start_pacifist") or (pers_gov == "vik_pers_crooked" and start1_gov == "vik_start_honest_man") or (pers_gov == "vik_pers_crooked" and start1_gov == "vik_start_trustworthy") 
						or (pers_gov == "vik_pers_honourable" and start1_gov == "vik_start_gambler") or (pers_gov == "vik_pers_calm" and start1_gov == "vik_start_bloodthirsty") or (pers_gov == "vik_pers_liar" and start1_gov == "vik_start_honest_man") 
						or (pers_gov == "vik_pers_stupid" and start1_gov == "vik_start_forward_thinker") or (pers_gov == "vik_pers_zealous" and start1_gov == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start1_gov == "vik_start_enthusiastic")) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if ((pers_gov == "vik_pers_aggressive" and start2_gov == "vik_start_pacifist") or (pers_gov == "vik_pers_crooked" and start2_gov == "vik_start_honest_man") or (pers_gov == "vik_pers_crooked" and start2_gov == "vik_start_trustworthy") 
						or (pers_gov == "vik_pers_honourable" and start2_gov == "vik_start_gambler") or (pers_gov == "vik_pers_calm" and start2_gov == "vik_start_bloodthirsty") or (pers_gov == "vik_pers_liar" and start2_gov == "vik_start_honest_man") 
						or (pers_gov == "vik_pers_stupid" and start2_gov == "vik_start_forward_thinker") or (pers_gov == "vik_pers_zealous" and start2_gov == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start2_gov == "vik_start_enthusiastic")) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if ((pers_gov == "vik_pers_aggressive" and start3_gov == "vik_start_pacifist") or (pers_gov == "vik_pers_crooked" and start3_gov == "vik_start_honest_man") or (pers_gov == "vik_pers_crooked" and start3_gov == "vik_start_trustworthy") 
						or (pers_gov == "vik_pers_honourable" and start3_gov == "vik_start_gambler") or (pers_gov == "vik_pers_calm" and start3_gov == "vik_start_bloodthirsty") or (pers_gov == "vik_pers_liar" and start3_gov == "vik_start_honest_man") 
						or (pers_gov == "vik_pers_stupid" and start3_gov == "vik_start_forward_thinker") or (pers_gov == "vik_pers_zealous" and start3_gov == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start3_gov == "vik_start_enthusiastic")) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if ((start1_gov == "vik_start_hydrophil" and (start2_gov == "vik_start_land_lover" or start3_gov == "vik_start_land_lover")) or (start1_gov == "vik_start_afraid_in_the_dark" and (start2_gov == "vik_start_night_owl" or start3_gov == "vik_start_night_owl"))
						or (start1_gov == "vik_start_shabby" and (start2_gov == "vik_start_handsome" or start3_gov == "vik_start_handsome"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if ((start2_gov == "vik_start_hydrophil" and (start1_gov == "vik_start_land_lover" or start3_gov == "vik_start_land_lover")) or (start2_gov == "vik_start_afraid_in_the_dark" and (start1_gov == "vik_start_night_owl" or start3_gov == "vik_start_night_owl"))
						or (start2_gov == "vik_start_shabby" and (start1_gov == "vik_start_handsome" or start3_gov == "vik_start_handsome"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if ((start3_gov == "vik_start_hydrophil" and (start2_gov == "vik_start_land_lover" or start1_gov == "vik_start_land_lover")) or (start3_gov == "vik_start_afraid_in_the_dark" and (start2_gov == "vik_start_night_owl" or start1_gov == "vik_start_night_owl"))
						or (start3_gov == "vik_start_shabby" and (start2_gov == "vik_start_handsome" or start1_gov == "vik_start_handsome"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						
						
						
						-- Upkeep traits --
						if ((start1_gov == "vik_start_admired" and (start2_gov == "vik_start_friendly" or start3_gov == "vik_start_friendly")) or (start1_gov == "vik_start_admired" and (start2_gov == "vik_start_good_to_his_men" or start3_gov == "vik_start_good_to_his_men"))
						or (start1_gov == "vik_start_friendly" and (start2_gov == "vik_start_admired" or start3_gov == "vik_start_admired")) or (start1_gov == "vik_start_friendly" and (start2_gov == "vik_start_good_to_his_men" or start3_gov == "vik_start_good_to_his_men"))
						or (start1_gov == "vik_start_good_to_his_men" and (start2_gov == "vik_start_admired" or start3_gov == "vik_start_admired")) or (start1_gov == "vik_start_good_to_his_men" and (start2_gov == "vik_start_friendly" or start3_gov == "vik_start_friendly"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_admired" and (start1_gov == "vik_start_friendly" or start3_gov == "vik_start_friendly")) or (start2_gov == "vik_start_admired" and (start1_gov == "vik_start_good_to_his_men" or start3_gov == "vik_start_good_to_his_men"))
						or (start2_gov == "vik_start_friendly" and (start1_gov == "vik_start_admired" or start3_gov == "vik_start_admired")) or (start2_gov == "vik_start_friendly" and (start1_gov == "vik_start_good_to_his_men" or start3_gov == "vik_start_good_to_his_men"))
						or (start2_gov == "vik_start_good_to_his_men" and (start1_gov == "vik_start_admired" or start3_gov == "vik_start_admired")) or (start2_gov == "vik_start_good_to_his_men" and (start1_gov == "vik_start_friendly" or start3_gov == "vik_start_friendly"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_admired" and (start2_gov == "vik_start_friendly" or start1_gov == "vik_start_friendly")) or (start3_gov == "vik_start_admired" and (start2_gov == "vik_start_good_to_his_men" or start1_gov == "vik_start_good_to_his_men"))
						or (start3_gov == "vik_start_friendly" and (start2_gov == "vik_start_admired" or start1_gov == "vik_start_admired")) or (start3_gov == "vik_start_friendly" and (start2_gov == "vik_start_good_to_his_men" or start1_gov == "vik_start_good_to_his_men"))
						or (start3_gov == "vik_start_good_to_his_men" and (start2_gov == "vik_start_admired" or start1_gov == "vik_start_admired")) or (start3_gov == "vik_start_good_to_his_men" and (start2_gov == "vik_start_friendly" or start1_gov == "vik_start_friendly"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						-- Research traits --
						if ((start1_gov == "vik_start_curious" and (start2_gov == "vik_start_intelligent" or start3_gov == "vik_start_intelligent")) or (start1_gov == "vik_start_intelligent" and (start2_gov == "vik_start_curious" or start3_gov == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_curious" and (start1_gov == "vik_start_intelligent" or start3_gov == "vik_start_intelligent")) or (start2_gov == "vik_start_intelligent" and (start1_gov == "vik_start_curious" or start3_gov == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_curious" and (start2_gov == "vik_start_intelligent" or start1_gov == "vik_start_intelligent")) or (start3_gov == "vik_start_intelligent" and (start2_gov == "vik_start_curious" or start1_gov == "vik_start_curious"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- PO traits --
						if ((start1_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_just" or start3_gov == "vik_start_just")) or (start1_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer"))
						or (start1_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start1_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start1_gov == "vik_start_just" and (start2_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start1_gov == "vik_start_just" and (start2_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer"))
						or (start1_gov == "vik_start_just" and (start2_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start1_gov == "vik_start_just" and (start2_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start1_gov == "vik_start_nurturer" and (start2_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start1_gov == "vik_start_nurturer" and (start2_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start1_gov == "vik_start_nurturer" and (start2_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start1_gov == "vik_start_nurturer" and (start2_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start1_gov == "vik_start_pacifist" and (start2_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start1_gov == "vik_start_pacifist" and (start2_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start1_gov == "vik_start_pacifist" and (start2_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer")) or (start1_gov == "vik_start_pacifist" and (start2_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start1_gov == "vik_start_strict" and (start2_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start1_gov == "vik_start_strict" and (start2_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start1_gov == "vik_start_strict" and (start2_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer")) or (start1_gov == "vik_start_strict" and (start2_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_chivalrous" and (start1_gov == "vik_start_just" or start3_gov == "vik_start_just")) or (start2_gov == "vik_start_chivalrous" and (start1_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer"))
						or (start2_gov == "vik_start_chivalrous" and (start1_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start2_gov == "vik_start_chivalrous" and (start1_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start2_gov == "vik_start_just" and (start1_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start2_gov == "vik_start_just" and (start1_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer"))
						or (start2_gov == "vik_start_just" and (start1_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start2_gov == "vik_start_just" and (start1_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start2_gov == "vik_start_nurturer" and (start1_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start2_gov == "vik_start_nurturer" and (start1_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start2_gov == "vik_start_nurturer" and (start1_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist")) or (start2_gov == "vik_start_nurturer" and (start1_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start2_gov == "vik_start_pacifist" and (start1_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start2_gov == "vik_start_pacifist" and (start1_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start2_gov == "vik_start_pacifist" and (start1_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer")) or (start2_gov == "vik_start_pacifist" and (start1_gov == "vik_start_strict" or start3_gov == "vik_start_strict"))
						or (start2_gov == "vik_start_strict" and (start1_gov == "vik_start_chivalrous" or start3_gov == "vik_start_chivalrous")) or (start2_gov == "vik_start_strict" and (start1_gov == "vik_start_just" or start3_gov == "vik_start_just"))
						or (start2_gov == "vik_start_strict" and (start1_gov == "vik_start_nurturer" or start3_gov == "vik_start_nurturer")) or (start2_gov == "vik_start_strict" and (start1_gov == "vik_start_pacifist" or start3_gov == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_just" or start1_gov == "vik_start_just")) or (start3_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_nurturer" or start1_gov == "vik_start_nurturer"))
						or (start3_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_pacifist" or start1_gov == "vik_start_pacifist")) or (start3_gov == "vik_start_chivalrous" and (start2_gov == "vik_start_strict" or start1_gov == "vik_start_strict"))
						or (start3_gov == "vik_start_just" and (start2_gov == "vik_start_chivalrous" or start1_gov == "vik_start_chivalrous")) or (start3_gov == "vik_start_just" and (start2_gov == "vik_start_nurturer" or start1_gov == "vik_start_nurturer"))
						or (start3_gov == "vik_start_just" and (start2_gov == "vik_start_pacifist" or start1_gov == "vik_start_pacifist")) or (start3_gov == "vik_start_just" and (start2_gov == "vik_start_strict" or start1_gov == "vik_start_strict"))
						or (start3_gov == "vik_start_nurturer" and (start2_gov == "vik_start_chivalrous" or start1_gov == "vik_start_chivalrous")) or (start3_gov == "vik_start_nurturer" and (start2_gov == "vik_start_just" or start1_gov == "vik_start_just"))
						or (start3_gov == "vik_start_nurturer" and (start2_gov == "vik_start_pacifist" or start1_gov == "vik_start_pacifist")) or (start3_gov == "vik_start_nurturer" and (start2_gov == "vik_start_strict" or start1_gov == "vik_start_strict"))
						or (start3_gov == "vik_start_pacifist" and (start2_gov == "vik_start_chivalrous" or start1_gov == "vik_start_chivalrous")) or (start3_gov == "vik_start_pacifist" and (start2_gov == "vik_start_just" or start1_gov == "vik_start_just"))
						or (start3_gov == "vik_start_pacifist" and (start2_gov == "vik_start_nurturer" or start1_gov == "vik_start_nurturer")) or (start3_gov == "vik_start_pacifist" and (start2_gov == "vik_start_strict" or start1_gov == "vik_start_strict"))
						or (start3_gov == "vik_start_strict" and (start2_gov == "vik_start_chivalrous" or start1_gov == "vik_start_chivalrous")) or (start3_gov == "vik_start_strict" and (start2_gov == "vik_start_just" or start1_gov == "vik_start_just"))
						or (start3_gov == "vik_start_strict" and (start2_gov == "vik_start_nurturer" or start1_gov == "vik_start_nurturer")) or (start3_gov == "vik_start_strict" and (start2_gov == "vik_start_pacifist" or start1_gov == "vik_start_pacifist"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Siege traits --
						if ((start1_gov == "vik_start_forward_thinker" and (start2_gov == "vik_start_strategist" or start3_gov == "vik_start_strategist")) or (start1_gov == "vik_start_strategist" and (start2_gov == "vik_start_forward_thinker" or start3_gov == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_forward_thinker" and (start1_gov == "vik_start_strategist" or start3_gov == "vik_start_strategist")) or (start2_gov == "vik_start_strategist" and (start1_gov == "vik_start_forward_thinker" or start3_gov == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_forward_thinker" and (start2_gov == "vik_start_strategist" or start1_gov == "vik_start_strategist")) or (start3_gov == "vik_start_strategist" and (start2_gov == "vik_start_forward_thinker" or start1_gov == "vik_start_forward_thinker"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						-- Corruption traits --
						if ((start1_gov == "vik_start_gambler" and (start2_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start1_gov == "vik_start_gambler" and (start2_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start1_gov == "vik_start_gambler" and (start2_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start1_gov == "vik_start_has_principles" and (start2_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler")) or (start1_gov == "vik_start_has_principles" and (start2_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start1_gov == "vik_start_has_principles" and (start2_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start1_gov == "vik_start_honest_man" and (start2_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start1_gov == "vik_start_honest_man" and (start2_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler"))
						or (start1_gov == "vik_start_honest_man" and (start2_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start1_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start1_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start1_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_gambler" and (start1_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start2_gov == "vik_start_gambler" and (start1_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start2_gov == "vik_start_gambler" and (start1_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start2_gov == "vik_start_has_principles" and (start1_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler")) or (start2_gov == "vik_start_has_principles" and (start1_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start2_gov == "vik_start_has_principles" and (start1_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start2_gov == "vik_start_honest_man" and (start1_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start2_gov == "vik_start_honest_man" and (start1_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler"))
						or (start2_gov == "vik_start_honest_man" and (start1_gov == "vik_start_trustworthy" or start3_gov == "vik_start_trustworthy"))
						or (start2_gov == "vik_start_trustworthy" and (start1_gov == "vik_start_has_principles" or start3_gov == "vik_start_has_principles")) or (start2_gov == "vik_start_trustworthy" and (start1_gov == "vik_start_honest_man" or start3_gov == "vik_start_honest_man"))
						or (start2_gov == "vik_start_trustworthy" and (start1_gov == "vik_start_gambler" or start3_gov == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_gambler" and (start2_gov == "vik_start_has_principles" or start1_gov == "vik_start_has_principles")) or (start3_gov == "vik_start_gambler" and (start2_gov == "vik_start_honest_man" or start1_gov == "vik_start_honest_man"))
						or (start3_gov == "vik_start_gambler" and (start2_gov == "vik_start_trustworthy" or start1_gov == "vik_start_trustworthy"))
						or (start3_gov == "vik_start_has_principles" and (start2_gov == "vik_start_gambler" or start1_gov == "vik_start_gambler")) or (start3_gov == "vik_start_has_principles" and (start2_gov == "vik_start_honest_man" or start1_gov == "vik_start_honest_man"))
						or (start3_gov == "vik_start_has_principles" and (start2_gov == "vik_start_trustworthy" or start1_gov == "vik_start_trustworthy"))
						or (start3_gov == "vik_start_honest_man" and (start2_gov == "vik_start_has_principles" or start1_gov == "vik_start_has_principles")) or (start3_gov == "vik_start_honest_man" and (start2_gov == "vik_start_gambler" or start1_gov == "vik_start_gambler"))
						or (start3_gov == "vik_start_honest_man" and (start2_gov == "vik_start_trustworthy" or start1_gov == "vik_start_trustworthy"))
						or (start3_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_has_principles" or start1_gov == "vik_start_has_principles")) or (start3_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_honest_man" or start1_gov == "vik_start_honest_man"))
						or (start3_gov == "vik_start_trustworthy" and (start2_gov == "vik_start_gambler" or start1_gov == "vik_start_gambler"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- Replenishment traits --
						if ((start1_gov == "vik_start_illustrious" and (start2_gov == "vik_start_renowned" or start3_gov == "vik_start_renowned")) or (start1_gov == "vik_start_illustrious" and (start2_gov == "vik_start_survivor" or start3_gov == "vik_start_survivor"))
						or (start1_gov == "vik_start_renowned" and (start2_gov == "vik_start_illustrious" or start3_gov == "vik_start_illustrious")) or (start1_gov == "vik_start_renowned" and (start2_gov == "vik_start_survivor" or start3_gov == "vik_start_survivor"))
						or (start1_gov == "vik_start_survivor" and (start2_gov == "vik_start_renowned" or start3_gov == "vik_start_renowned")) or (start1_gov == "vik_start_survivor" and (start2_gov == "vik_start_illustrious" or start3_gov == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start1_gov)
							start1_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start2_gov == "vik_start_illustrious" and (start1_gov == "vik_start_renowned" or start3_gov == "vik_start_renowned")) or (start2_gov == "vik_start_illustrious" and (start1_gov == "vik_start_survivor" or start3_gov == "vik_start_survivor"))
						or (start2_gov == "vik_start_renowned" and (start1_gov == "vik_start_illustrious" or start3_gov == "vik_start_illustrious")) or (start2_gov == "vik_start_renowned" and (start1_gov == "vik_start_survivor" or start3_gov == "vik_start_survivor"))
						or (start2_gov == "vik_start_survivor" and (start1_gov == "vik_start_renowned" or start3_gov == "vik_start_renowned")) or (start2_gov == "vik_start_survivor" and (start1_gov == "vik_start_illustrious" or start3_gov == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start2_gov)
							start2_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						if ((start3_gov == "vik_start_illustrious" and (start2_gov == "vik_start_renowned" or start1_gov == "vik_start_renowned")) or (start3_gov == "vik_start_illustrious" and (start2_gov == "vik_start_survivor" or start1_gov == "vik_start_survivor"))
						or (start3_gov == "vik_start_renowned" and (start2_gov == "vik_start_illustrious" or start1_gov == "vik_start_illustrious")) or (start3_gov == "vik_start_renowned" and (start2_gov == "vik_start_survivor" or start1_gov == "vik_start_survivor"))
						or (start3_gov == "vik_start_survivor" and (start2_gov == "vik_start_renowned" or start1_gov == "vik_start_renowned")) or (start3_gov == "vik_start_survivor" and (start2_gov == "vik_start_illustrious" or start1_gov == "vik_start_illustrious"))) then
							-- output ("---- repicking trait "..start3_gov)
							start3_gov = start_traits_general[cm:random_number(#start_traits_general, 1)]
						end
						
						
						-- end of specific dupe check --
						
						
						if (start2_gov == start1_gov) then
							start2_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						if (start3_gov == start2_gov or start3_gov == start1_gov) then
							start3_gov = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
						end
						
						if (context:character():is_male() == true) then
						-- output (context:character():get_forename())
							effect.trait(pers_gov, "agent", 1, 100, context)
								-- output (pers_gov)
								-- output ("----governor----")
							effect.trait(start1_gov, "agent", 1, 100, context)
								-- output (start1_gov)
								-- output ("----governor----")
							effect.trait(start2_gov, "agent", 1, 100, context)
								-- output (start2_gov)
								-- output ("----governor----")
							effect.trait(start3_gov, "agent", 1, 100, context)
								-- output (start3_gov)
								-- output ("----governor----")
						end
						
					end
				end
				
				-- output ("not governor")
				
				-- ANY BG SKILL
				for i=1, #bg_any do
				local skill_any = bg_any[i]
					if context:character():has_skill(skill_any) then
					-- output (skill_any)
					-- output ("----ANY----")
						local pers_any = pers_traits_any[cm:random_number(#pers_traits_any, 1)]
						local start1_any
						local start2_any
						local start3_any
						
						for i=1, #pers_traits_general do
							local pers_check_gen = pers_traits_general[i]
							if pers_check_gen == pers_any then -- GENERAL
								start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								
									
								if ((pers_any == "vik_pers_aggressive" and start1_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start1_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start1_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start1_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start1_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start1_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start1_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start1_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start1_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((pers_any == "vik_pers_aggressive" and start2_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start2_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start2_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start2_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start2_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start2_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start2_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start2_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start2_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((pers_any == "vik_pers_aggressive" and start3_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start3_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start3_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start3_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start3_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start3_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start3_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start3_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start3_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start1_any == "vik_start_hydrophil" and (start2_any == "vik_start_land_lover" or start3_any == "vik_start_land_lover")) or (start1_any == "vik_start_afraid_in_the_dark" and (start2_any == "vik_start_night_owl" or start3_any == "vik_start_night_owl"))
								or (start1_any == "vik_start_shabby" and (start2_any == "vik_start_handsome" or start3_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_hydrophil" and (start1_any == "vik_start_land_lover" or start3_any == "vik_start_land_lover")) or (start2_any == "vik_start_afraid_in_the_dark" and (start1_any == "vik_start_night_owl" or start3_any == "vik_start_night_owl"))
								or (start2_any == "vik_start_shabby" and (start1_any == "vik_start_handsome" or start3_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_hydrophil" and (start2_any == "vik_start_land_lover" or start1_any == "vik_start_land_lover")) or (start3_any == "vik_start_afraid_in_the_dark" and (start2_any == "vik_start_night_owl" or start1_any == "vik_start_night_owl"))
								or (start3_any == "vik_start_shabby" and (start2_any == "vik_start_handsome" or start1_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
							
								
								if (start2_any == start1_any) then
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								if (start3_any == start2_any or start3_any == start1_any) then
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if (context:character():is_male() == true) then
								-- output (context:character():get_forename())
									effect.trait(pers_any, "agent", 1, 100, context)
										-- output (pers_any)
										-- output ("----general----")
									effect.trait(start1_any, "agent", 1, 100, context)
										-- output (start1_any)
										-- output ("----general----")
									effect.trait(start2_any, "agent", 1, 100, context)
										-- output (start2_any)
										-- output ("----general----")
									effect.trait(start3_any, "agent", 1, 100, context)
										-- output (start3_any)
										-- output ("----general----")
								end
							end
						end
						
						for i=1, #pers_traits_governor do
							local pers_check_gov = pers_traits_governor[i]
							if pers_check_gov == pers_any then -- GOVERNOR
								start1_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								start2_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								start3_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								
									
								if ((pers_any == "vik_pers_aggressive" and start1_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start1_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start1_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start1_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start1_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start1_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start1_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start1_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start1_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if ((pers_any == "vik_pers_aggressive" and start2_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start2_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start2_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start2_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start2_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start2_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start2_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start2_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start2_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if ((pers_any == "vik_pers_aggressive" and start3_any == "vik_start_pacifist") or (pers_any == "vik_pers_crooked" and start3_any == "vik_start_honest_man") or (pers_any == "vik_pers_crooked" and start3_any == "vik_start_trustworthy") 
								or (pers_any == "vik_pers_honourable" and start3_any == "vik_start_gambler") or (pers_any == "vik_pers_calm" and start3_any == "vik_start_bloodthirsty") or (pers_any == "vik_pers_liar" and start3_any == "vik_start_honest_man") 
								or (pers_any == "vik_pers_stupid" and start3_any == "vik_start_forward_thinker") or (pers_any == "vik_pers_zealous" and start3_any == "vik_start_zealot") or (pers_any == "vik_pers_indifferent" and start3_any == "vik_start_enthusiastic")) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if ((start1_any == "vik_start_hydrophil" and (start2_any == "vik_start_land_lover" or start3_any == "vik_start_land_lover")) or (start1_any == "vik_start_afraid_in_the_dark" and (start2_any == "vik_start_night_owl" or start3_any == "vik_start_night_owl"))
								or (start1_any == "vik_start_shabby" and (start2_any == "vik_start_handsome" or start3_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if ((start2_any == "vik_start_hydrophil" and (start1_any == "vik_start_land_lover" or start3_any == "vik_start_land_lover")) or (start2_any == "vik_start_afraid_in_the_dark" and (start1_any == "vik_start_night_owl" or start3_any == "vik_start_night_owl"))
								or (start2_any == "vik_start_shabby" and (start1_any == "vik_start_handsome" or start3_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if ((start3_any == "vik_start_hydrophil" and (start2_any == "vik_start_land_lover" or start1_any == "vik_start_land_lover")) or (start3_any == "vik_start_afraid_in_the_dark" and (start2_any == "vik_start_night_owl" or start1_any == "vik_start_night_owl"))
								or (start3_any == "vik_start_shabby" and (start2_any == "vik_start_handsome" or start1_any == "vik_start_handsome"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								
								
								
								
								-- Upkeep traits --
								if ((start1_any == "vik_start_admired" and (start2_any == "vik_start_friendly" or start3_any == "vik_start_friendly")) or (start1_any == "vik_start_admired" and (start2_any == "vik_start_good_to_his_men" or start3_any == "vik_start_good_to_his_men"))
								or (start1_any == "vik_start_friendly" and (start2_any == "vik_start_admired" or start3_any == "vik_start_admired")) or (start1_any == "vik_start_friendly" and (start2_any == "vik_start_good_to_his_men" or start3_any == "vik_start_good_to_his_men"))
								or (start1_any == "vik_start_good_to_his_men" and (start2_any == "vik_start_admired" or start3_any == "vik_start_admired")) or (start1_any == "vik_start_good_to_his_men" and (start2_any == "vik_start_friendly" or start3_any == "vik_start_friendly"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_admired" and (start1_any == "vik_start_friendly" or start3_any == "vik_start_friendly")) or (start2_any == "vik_start_admired" and (start1_any == "vik_start_good_to_his_men" or start3_any == "vik_start_good_to_his_men"))
								or (start2_any == "vik_start_friendly" and (start1_any == "vik_start_admired" or start3_any == "vik_start_admired")) or (start2_any == "vik_start_friendly" and (start1_any == "vik_start_good_to_his_men" or start3_any == "vik_start_good_to_his_men"))
								or (start2_any == "vik_start_good_to_his_men" and (start1_any == "vik_start_admired" or start3_any == "vik_start_admired")) or (start2_any == "vik_start_good_to_his_men" and (start1_any == "vik_start_friendly" or start3_any == "vik_start_friendly"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_admired" and (start2_any == "vik_start_friendly" or start1_any == "vik_start_friendly")) or (start3_any == "vik_start_admired" and (start2_any == "vik_start_good_to_his_men" or start1_any == "vik_start_good_to_his_men"))
								or (start3_any == "vik_start_friendly" and (start2_any == "vik_start_admired" or start1_any == "vik_start_admired")) or (start3_any == "vik_start_friendly" and (start2_any == "vik_start_good_to_his_men" or start1_any == "vik_start_good_to_his_men"))
								or (start3_any == "vik_start_good_to_his_men" and (start2_any == "vik_start_admired" or start1_any == "vik_start_admired")) or (start3_any == "vik_start_good_to_his_men" and (start2_any == "vik_start_friendly" or start1_any == "vik_start_friendly"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								-- Research traits --
								if ((start1_any == "vik_start_curious" and (start2_any == "vik_start_intelligent" or start3_any == "vik_start_intelligent")) or (start1_any == "vik_start_intelligent" and (start2_any == "vik_start_curious" or start3_any == "vik_start_curious"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_curious" and (start1_any == "vik_start_intelligent" or start3_any == "vik_start_intelligent")) or (start2_any == "vik_start_intelligent" and (start1_any == "vik_start_curious" or start3_any == "vik_start_curious"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_curious" and (start2_any == "vik_start_intelligent" or start1_any == "vik_start_intelligent")) or (start3_any == "vik_start_intelligent" and (start2_any == "vik_start_curious" or start1_any == "vik_start_curious"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								
								-- PO traits --
								if ((start1_any == "vik_start_chivalrous" and (start2_any == "vik_start_just" or start3_any == "vik_start_just")) or (start1_any == "vik_start_chivalrous" and (start2_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer"))
								or (start1_any == "vik_start_chivalrous" and (start2_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start1_any == "vik_start_chivalrous" and (start2_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start1_any == "vik_start_just" and (start2_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start1_any == "vik_start_just" and (start2_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer"))
								or (start1_any == "vik_start_just" and (start2_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start1_any == "vik_start_just" and (start2_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start1_any == "vik_start_nurturer" and (start2_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start1_any == "vik_start_nurturer" and (start2_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start1_any == "vik_start_nurturer" and (start2_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start1_any == "vik_start_nurturer" and (start2_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start1_any == "vik_start_pacifist" and (start2_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start1_any == "vik_start_pacifist" and (start2_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start1_any == "vik_start_pacifist" and (start2_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer")) or (start1_any == "vik_start_pacifist" and (start2_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start1_any == "vik_start_strict" and (start2_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start1_any == "vik_start_strict" and (start2_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start1_any == "vik_start_strict" and (start2_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer")) or (start1_any == "vik_start_strict" and (start2_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_chivalrous" and (start1_any == "vik_start_just" or start3_any == "vik_start_just")) or (start2_any == "vik_start_chivalrous" and (start1_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer"))
								or (start2_any == "vik_start_chivalrous" and (start1_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start2_any == "vik_start_chivalrous" and (start1_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start2_any == "vik_start_just" and (start1_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start2_any == "vik_start_just" and (start1_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer"))
								or (start2_any == "vik_start_just" and (start1_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start2_any == "vik_start_just" and (start1_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start2_any == "vik_start_nurturer" and (start1_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start2_any == "vik_start_nurturer" and (start1_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start2_any == "vik_start_nurturer" and (start1_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist")) or (start2_any == "vik_start_nurturer" and (start1_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start2_any == "vik_start_pacifist" and (start1_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start2_any == "vik_start_pacifist" and (start1_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start2_any == "vik_start_pacifist" and (start1_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer")) or (start2_any == "vik_start_pacifist" and (start1_any == "vik_start_strict" or start3_any == "vik_start_strict"))
								or (start2_any == "vik_start_strict" and (start1_any == "vik_start_chivalrous" or start3_any == "vik_start_chivalrous")) or (start2_any == "vik_start_strict" and (start1_any == "vik_start_just" or start3_any == "vik_start_just"))
								or (start2_any == "vik_start_strict" and (start1_any == "vik_start_nurturer" or start3_any == "vik_start_nurturer")) or (start2_any == "vik_start_strict" and (start1_any == "vik_start_pacifist" or start3_any == "vik_start_pacifist"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_chivalrous" and (start2_any == "vik_start_just" or start1_any == "vik_start_just")) or (start3_any == "vik_start_chivalrous" and (start2_any == "vik_start_nurturer" or start1_any == "vik_start_nurturer"))
								or (start3_any == "vik_start_chivalrous" and (start2_any == "vik_start_pacifist" or start1_any == "vik_start_pacifist")) or (start3_any == "vik_start_chivalrous" and (start2_any == "vik_start_strict" or start1_any == "vik_start_strict"))
								or (start3_any == "vik_start_just" and (start2_any == "vik_start_chivalrous" or start1_any == "vik_start_chivalrous")) or (start3_any == "vik_start_just" and (start2_any == "vik_start_nurturer" or start1_any == "vik_start_nurturer"))
								or (start3_any == "vik_start_just" and (start2_any == "vik_start_pacifist" or start1_any == "vik_start_pacifist")) or (start3_any == "vik_start_just" and (start2_any == "vik_start_strict" or start1_any == "vik_start_strict"))
								or (start3_any == "vik_start_nurturer" and (start2_any == "vik_start_chivalrous" or start1_any == "vik_start_chivalrous")) or (start3_any == "vik_start_nurturer" and (start2_any == "vik_start_just" or start1_any == "vik_start_just"))
								or (start3_any == "vik_start_nurturer" and (start2_any == "vik_start_pacifist" or start1_any == "vik_start_pacifist")) or (start3_any == "vik_start_nurturer" and (start2_any == "vik_start_strict" or start1_any == "vik_start_strict"))
								or (start3_any == "vik_start_pacifist" and (start2_any == "vik_start_chivalrous" or start1_any == "vik_start_chivalrous")) or (start3_any == "vik_start_pacifist" and (start2_any == "vik_start_just" or start1_any == "vik_start_just"))
								or (start3_any == "vik_start_pacifist" and (start2_any == "vik_start_nurturer" or start1_any == "vik_start_nurturer")) or (start3_any == "vik_start_pacifist" and (start2_any == "vik_start_strict" or start1_any == "vik_start_strict"))
								or (start3_any == "vik_start_strict" and (start2_any == "vik_start_chivalrous" or start1_any == "vik_start_chivalrous")) or (start3_any == "vik_start_strict" and (start2_any == "vik_start_just" or start1_any == "vik_start_just"))
								or (start3_any == "vik_start_strict" and (start2_any == "vik_start_nurturer" or start1_any == "vik_start_nurturer")) or (start3_any == "vik_start_strict" and (start2_any == "vik_start_pacifist" or start1_any == "vik_start_pacifist"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								
								-- Siege traits --
								if ((start1_any == "vik_start_forward_thinker" and (start2_any == "vik_start_strategist" or start3_any == "vik_start_strategist")) or (start1_any == "vik_start_strategist" and (start2_any == "vik_start_forward_thinker" or start3_any == "vik_start_forward_thinker"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_forward_thinker" and (start1_any == "vik_start_strategist" or start3_any == "vik_start_strategist")) or (start2_any == "vik_start_strategist" and (start1_any == "vik_start_forward_thinker" or start3_any == "vik_start_forward_thinker"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_forward_thinker" and (start2_any == "vik_start_strategist" or start1_any == "vik_start_strategist")) or (start3_any == "vik_start_strategist" and (start2_any == "vik_start_forward_thinker" or start1_any == "vik_start_forward_thinker"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								-- Corruption traits --
								if ((start1_any == "vik_start_gambler" and (start2_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start1_any == "vik_start_gambler" and (start2_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start1_any == "vik_start_gambler" and (start2_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start1_any == "vik_start_has_principles" and (start2_any == "vik_start_gambler" or start3_any == "vik_start_gambler")) or (start1_any == "vik_start_has_principles" and (start2_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start1_any == "vik_start_has_principles" and (start2_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start1_any == "vik_start_honest_man" and (start2_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start1_any == "vik_start_honest_man" and (start2_any == "vik_start_gambler" or start3_any == "vik_start_gambler"))
								or (start1_any == "vik_start_honest_man" and (start2_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start1_any == "vik_start_trustworthy" and (start2_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start1_any == "vik_start_trustworthy" and (start2_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start1_any == "vik_start_trustworthy" and (start2_any == "vik_start_gambler" or start3_any == "vik_start_gambler"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_gambler" and (start1_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start2_any == "vik_start_gambler" and (start1_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start2_any == "vik_start_gambler" and (start1_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start2_any == "vik_start_has_principles" and (start1_any == "vik_start_gambler" or start3_any == "vik_start_gambler")) or (start2_any == "vik_start_has_principles" and (start1_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start2_any == "vik_start_has_principles" and (start1_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start2_any == "vik_start_honest_man" and (start1_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start2_any == "vik_start_honest_man" and (start1_any == "vik_start_gambler" or start3_any == "vik_start_gambler"))
								or (start2_any == "vik_start_honest_man" and (start1_any == "vik_start_trustworthy" or start3_any == "vik_start_trustworthy"))
								or (start2_any == "vik_start_trustworthy" and (start1_any == "vik_start_has_principles" or start3_any == "vik_start_has_principles")) or (start2_any == "vik_start_trustworthy" and (start1_any == "vik_start_honest_man" or start3_any == "vik_start_honest_man"))
								or (start2_any == "vik_start_trustworthy" and (start1_any == "vik_start_gambler" or start3_any == "vik_start_gambler"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_gambler" and (start2_any == "vik_start_has_principles" or start1_any == "vik_start_has_principles")) or (start3_any == "vik_start_gambler" and (start2_any == "vik_start_honest_man" or start1_any == "vik_start_honest_man"))
								or (start3_any == "vik_start_gambler" and (start2_any == "vik_start_trustworthy" or start1_any == "vik_start_trustworthy"))
								or (start3_any == "vik_start_has_principles" and (start2_any == "vik_start_gambler" or start1_any == "vik_start_gambler")) or (start3_any == "vik_start_has_principles" and (start2_any == "vik_start_honest_man" or start1_any == "vik_start_honest_man"))
								or (start3_any == "vik_start_has_principles" and (start2_any == "vik_start_trustworthy" or start1_any == "vik_start_trustworthy"))
								or (start3_any == "vik_start_honest_man" and (start2_any == "vik_start_has_principles" or start1_any == "vik_start_has_principles")) or (start3_any == "vik_start_honest_man" and (start2_any == "vik_start_gambler" or start1_any == "vik_start_gambler"))
								or (start3_any == "vik_start_honest_man" and (start2_any == "vik_start_trustworthy" or start1_any == "vik_start_trustworthy"))
								or (start3_any == "vik_start_trustworthy" and (start2_any == "vik_start_has_principles" or start1_any == "vik_start_has_principles")) or (start3_any == "vik_start_trustworthy" and (start2_any == "vik_start_honest_man" or start1_any == "vik_start_honest_man"))
								or (start3_any == "vik_start_trustworthy" and (start2_any == "vik_start_gambler" or start1_any == "vik_start_gambler"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								
								-- Replenishment traits --
								if ((start1_any == "vik_start_illustrious" and (start2_any == "vik_start_renowned" or start3_any == "vik_start_renowned")) or (start1_any == "vik_start_illustrious" and (start2_any == "vik_start_survivor" or start3_any == "vik_start_survivor"))
								or (start1_any == "vik_start_renowned" and (start2_any == "vik_start_illustrious" or start3_any == "vik_start_illustrious")) or (start1_any == "vik_start_renowned" and (start2_any == "vik_start_survivor" or start3_any == "vik_start_survivor"))
								or (start1_any == "vik_start_survivor" and (start2_any == "vik_start_renowned" or start3_any == "vik_start_renowned")) or (start1_any == "vik_start_survivor" and (start2_any == "vik_start_illustrious" or start3_any == "vik_start_illustrious"))) then
									output ("---- repicking trait "..start1_any)
									start1_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start2_any == "vik_start_illustrious" and (start1_any == "vik_start_renowned" or start3_any == "vik_start_renowned")) or (start2_any == "vik_start_illustrious" and (start1_any == "vik_start_survivor" or start3_any == "vik_start_survivor"))
								or (start2_any == "vik_start_renowned" and (start1_any == "vik_start_illustrious" or start3_any == "vik_start_illustrious")) or (start2_any == "vik_start_renowned" and (start1_any == "vik_start_survivor" or start3_any == "vik_start_survivor"))
								or (start2_any == "vik_start_survivor" and (start1_any == "vik_start_renowned" or start3_any == "vik_start_renowned")) or (start2_any == "vik_start_survivor" and (start1_any == "vik_start_illustrious" or start3_any == "vik_start_illustrious"))) then
									output ("---- repicking trait "..start2_any)
									start2_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								if ((start3_any == "vik_start_illustrious" and (start2_any == "vik_start_renowned" or start1_any == "vik_start_renowned")) or (start3_any == "vik_start_illustrious" and (start2_any == "vik_start_survivor" or start1_any == "vik_start_survivor"))
								or (start3_any == "vik_start_renowned" and (start2_any == "vik_start_illustrious" or start1_any == "vik_start_illustrious")) or (start3_any == "vik_start_renowned" and (start2_any == "vik_start_survivor" or start1_any == "vik_start_survivor"))
								or (start3_any == "vik_start_survivor" and (start2_any == "vik_start_renowned" or start1_any == "vik_start_renowned")) or (start3_any == "vik_start_survivor" and (start2_any == "vik_start_illustrious" or start1_any == "vik_start_illustrious"))) then
									output ("---- repicking trait "..start3_any)
									start3_any = start_traits_general[cm:random_number(#start_traits_general, 1)]
								end
								
								
								-- end of specific dupe check --
									
								
								if (start2_any == start1_any) then
									start2_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								if (start3_any == start2_any or start3_any == start1_any) then
									start3_any = start_traits_governor[cm:random_number(#start_traits_governor, 1)]
								end
								
								if (context:character():is_male() == true) then
								-- output (context:character():get_forename())
									effect.trait(pers_any, "agent", 1, 100, context)
										-- output (pers_any)
										-- output ("----governor----")
									effect.trait(start1_any, "agent", 1, 100, context)
										-- output (start1_any)
										-- output ("----governor----")
									effect.trait(start2_any, "agent", 1, 100, context)
										-- output (start2_any)
										-- output ("----governor----")
									effect.trait(start3_any, "agent", 1, 100, context)
										-- output (start3_any)
										-- output ("----governor----")
								end
							end
						end
						
							
					-- else output ("skill not found")
					end
				end -- end of "any"
					
				-- output ("end any")
				-- else output ("character null")
			end -- close third "if" condition
		end-- close second "if" condition
	end -- close first "if" condition
	
	EstateTraits(context)
	
end -- close function


function EstateTraits (context)

	local estate_traits = {"vik_estate_doesnt_care",
		"vik_estate_min_estates",
		"vik_estate_more_than_king",
		"vik_estate_more_than_others",
		"vik_estate_more_than_lower",
		"vik_estate_more_than_younger",
		"vik_estate_none",
		"vik_estate_type_estate",
		"vik_estate_type_religion",
		"vik_estate_type_agriculture",
		"vik_estate_less_than_king",
		"vik_estate_more_than_lower_command",
		"vik_estate_more_than_lower_governance",
		"vik_estate_not_type_agriculture",
		"vik_estate_not_type_estate",
		"vik_estate_not_type_religion"

	}
	
		local estate_traits_all = {"vik_estate_doesnt_care",
		"vik_estate_min_estates",
		"vik_estate_more_than_king",
		"vik_estate_more_than_others",
		"vik_estate_more_than_lower",
		"vik_estate_more_than_younger",
		"vik_estate_none",
		"vik_estate_type_estate",
		"vik_estate_type_religion",
		"vik_estate_type_agriculture",
		"vik_estate_loyalty_low",
		"vik_estate_loyalty_med",
		"vik_estate_loyalty_high",
		"vik_estate_influence_low",
		"vik_estate_influence_med",
		"vik_estate_influence_high",
		"vik_estate_less_than_king",
		"vik_estate_more_than_lower_command",
		"vik_estate_more_than_lower_governance",
		"vik_estate_not_type_estate",
		"vik_estate_not_type_religion",
		"vik_estate_not_type_agriculture",
		"vik_estate_more_than_generals_and_governors",
		"vik_estate_more_than_lower_influence"

	}

	local can_get_estate_trait = true
	local gets_estate_trait = false
	
	if not context:character():is_null_interface()
	and context:character():is_male() == true
	and context:character():age() > 16
	and context:character():is_faction_leader() == false
	and context:character():faction():is_human() == true then -- chance to add Estate desire traits
		for i=1, #estate_traits_all do -- don't give a new one if they have one already
			if context:character():has_trait(estate_traits_all[i]) then
				can_get_estate_trait = false
			end
		end
		
		local chance
		local fame = context:character():faction():imperium_level()
		
		if fame == 3 then -- low chance
			chance = 1
			elseif fame == 4 then -- some chance
			chance = 3
			elseif fame == 5 then -- high chance
			chance = 5
			elseif fame > 5 then -- pretty much certain
			chance = 10
		end
		
		if cm:model():random_percent(chance) == true then
			gets_estate_trait = true
		end
		
		if can_get_estate_trait == true and gets_estate_trait == true then
			local random_estate_trait = estate_traits[cm:random_number(#estate_traits,1)]
			--effect.trait(random_estate_trait, "agent", 1, 100, context)
		end
	end -- close Estate trait function

end

