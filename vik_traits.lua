-------------------------------------------------------------------------------
-------------------------------- SCRIPTED TRAITS ------------------------
-------------------------------------------------------------------------------
------------------------- Created by Laura: 06/06/2017 -----------------
------------------------- Last Updated: 06/08/2018 by Laura -----------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- script to add/remove certain traits with more complex checks than those in the DB

function Add_Special_Traits_Listeners()
output("#### Adding Additional Traits Listeners ####")
	cm:add_listener(
		"GovernorGeneralTraits",
		"CharacterTurnStart",
		true,
		function(context) GovernorGeneralTraits(context:character()) end,
		true
	);
	if cm:is_new_game() then
		for i = 1, #cm:get_human_factions() do
			local fac = get_faction(cm:get_human_factions()[i])
			for j = 0, fac:character_list():num_items() - 1 do
				GovernorGeneralTraits(fac:character_list():item_at(j))
			end
		end
	end
end


-------------------------------------------------------------------------------
-------------------- GOVERNOR/GENERAL TRAITS -----------------------
-------------------------------------------------------------------------------

function GovernorGeneralTraits (character)
	
	local province_list = {
		"vik_prov_agmundrenesse",
		"vik_prov_aileach",
		"vik_prov_airer_goidel",
		"vik_prov_airgialla",
		"vik_prov_athfochla",
		"vik_prov_aurmoreb",
		"vik_prov_beornice",
		"vik_prov_brega",
		"vik_prov_breifne",
		"vik_prov_cait",
		"vik_prov_cent",
		"vik_prov_ceredigeaun",
		"vik_prov_circenn",
		"vik_prov_connacht",
		"vik_prov_corcaigh",
		"vik_prov_cumbraland",
		"vik_prov_dal_fiatach",
		"vik_prov_dal_naraidi",
		"vik_prov_defenascir",
		"vik_prov_dorsaete",
		"vik_prov_druim_alban",
		"vik_prov_dyfet",
		"vik_prov_east_seaxe",
		"vik_prov_east_suth_seaxe",
		"vik_prov_east_thryding",
		"vik_prov_fenns",
		"vik_prov_grantabrycgscir",
		"vik_prov_gwined",
		"vik_prov_hamtunscir",
		"vik_prov_hlymrekr",
		"vik_prov_hwicce",
		"vik_prov_iarmoreb",
		"vik_prov_iarmuma",
		"vik_prov_kerneu",
		"vik_prov_laigen",
		"vik_prov_lindesege",
		"vik_prov_loden",
		"vik_prov_mana",
		"vik_prov_middel_engle",
		"vik_prov_middel_seaxe",
		"vik_prov_mide",
		"vik_prov_monadh",
		"vik_prov_morcanhuc",
		"vik_prov_muma",
		"vik_prov_norfolc",
		"vik_prov_north_mierce",
		"vik_prov_north_thryding",
		"vik_prov_offas_dic",
		"vik_prov_osraige",
		"vik_prov_powis",
		"vik_prov_staeffordscir",
		"vik_prov_strat_clut",
		"vik_prov_sudreyar",
		"vik_prov_sumorsaete",
		"vik_prov_suth_mierce",
		"vik_prov_suthfolc",
		"vik_prov_tuadmuma",
		"vik_prov_vedrafjordr",
		"vik_prov_veisafjordr",
		"vik_prov_west_seaxe",
		"vik_prov_west_suth_seaxe",
		"vik_prov_west_thryding",
		"vik_prov_wiltscir"

	}
	
	local province_trait_list = {
		"vik_gov_province_agmundrenesse",
		"vik_gov_province_aileach",
		"vik_gov_province_airer_goidel",
		"vik_gov_province_airgialla",
		"vik_gov_province_athfochla",
		"vik_gov_province_aurmoreb",
		"vik_gov_province_beornice",
		"vik_gov_province_brega",
		"vik_gov_province_breifne",
		"vik_gov_province_cait",
		"vik_gov_province_cent",
		"vik_gov_province_ceredigeaun",
		"vik_gov_province_circenn",
		"vik_gov_province_connacht",
		"vik_gov_province_corcaigh",
		"vik_gov_province_cumbraland",
		"vik_gov_province_dal_fiatach",
		"vik_gov_province_dal_naraidi",
		"vik_gov_province_defenascir",
		"vik_gov_province_dorsaete",
		"vik_gov_province_druim_alban",
		"vik_gov_province_dyfet",
		"vik_gov_province_east_seaxe",
		"vik_gov_province_east_suth_seaxe",
		"vik_gov_province_east_thryding",
		"vik_gov_province_fenns",
		"vik_gov_province_grantabrycgscir",
		"vik_gov_province_gwined",
		"vik_gov_province_hamtunscir",
		"vik_gov_province_hlymrekr",
		"vik_gov_province_hwicce",
		"vik_gov_province_iarmoreb",
		"vik_gov_province_iarmuma",
		"vik_gov_province_kerneu",
		"vik_gov_province_laigen",
		"vik_gov_province_lindesege",
		"vik_gov_province_loden",
		"vik_gov_province_mana",
		"vik_gov_province_middel_engle",
		"vik_gov_province_middel_seaxe",
		"vik_gov_province_mide",
		"vik_gov_province_monadh",
		"vik_gov_province_morcanhuc",
		"vik_gov_province_muma",
		"vik_gov_province_norfolc",
		"vik_gov_province_north_mierce",
		"vik_gov_province_north_thryding",
		"vik_gov_province_offas_dic",
		"vik_gov_province_osraige",
		"vik_gov_province_powis",
		"vik_gov_province_staeffordscir",
		"vik_gov_province_strat_clut",
		"vik_gov_province_sudreyar",
		"vik_gov_province_sumorsaete",
		"vik_gov_province_suth_mierce",
		"vik_gov_province_suthfolc",
		"vik_gov_province_tuadmuma",
		"vik_gov_province_vedrafjordr",
		"vik_gov_province_veisafjordr",
		"vik_gov_province_west_seaxe",
		"vik_gov_province_west_suth_seaxe",
		"vik_gov_province_west_thryding",
		"vik_gov_province_wiltscir"

	}
	
	local governor_lost_trait = ""
	local general_lost_trait = ""
	
	if character:faction():name() == "vik_fact_west_seaxe" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_mierce" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_gwined" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_strat_clut" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_circenn" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_mide" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_east_engle" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_northymbre" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_dyflin" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if character:faction():name() == "vik_fact_sudreyar" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end

	-- remove governor trait, add new or lost trait
	for i=1, #province_trait_list do
		if character:has_trait(province_trait_list[i]) 
		and not (character:has_region() and char_is_governor(character) and character:region():province_name() == province_list[i]) then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), province_trait_list[i])
			-- output ("not governor of last province anymore - "..province_list[i])
			-- if still governor but somewhere else give that trait instead
			if (character:has_region() and char_is_governor(character)) then
				for i=1, #province_list do
					if character:region():province_name() == province_list[i] then
						-- output (province_list[i])
						cm:force_add_trait("character_cqi:"..character:command_queue_index(), province_trait_list[i], true)
					end
				end
			else
				cm:force_add_trait("character_cqi:"..character:command_queue_index(), governor_lost_trait, true)
			end
		end
	end
	
	-- remove hidden general trait, add lost trait
	for i = 0,1 do
		if character:has_trait("vik_general_hidden") and (not char_is_governor(character)) then
			if (not char_is_general_with_army(character)) then  --not a general anymore.
				if character:has_trait("shield_trait_general_"..i) then
					cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_trait_general_"..i)
				end
				cm:force_add_trait("character_cqi:"..character:command_queue_index(), general_lost_trait, true)
			elseif (character:military_force():unit_list():num_items() < (12*i)) --if we have less than 12 units and i is 1, we should remove a trait.
			or (character:military_force():unit_list():num_items() >= 12 and (i == 0)) then --if we have more than 12 units and i is 0, we should remove a trait.
				if character:has_trait("shield_trait_general_"..trait_num) then
					cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_trait_general_"..trait_num)
				end
			end
		end
	end
	
	-- add governor trait
	if character:has_region() and char_is_governor(character) then
		if character:has_trait(governor_lost_trait) then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), governor_lost_trait)
		end			
		for i=1, #province_list do
			if character:region():province_name() == province_list[i] and not character:has_trait(province_trait_list[i]) then
				-- output (province_list[i])
				cm:force_add_trait("character_cqi:"..character:command_queue_index(), province_trait_list[i], true)
				return
			end
		end
	end
	
	-- add general trait
	if char_is_general_with_army(character) and (not char_is_governor(character)) then
		if character:has_trait(general_lost_trait) then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), general_lost_trait)
		end
		local num_men = character:military_force():unit_list():num_items()
		if num_men >= 12 then
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_general_1", true)
			dev.log("adding general trait 1 to character ["..character:command_queue_index().."] ")
			if character:has_trait("shield_general_0") then
				cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_general_0")
			end
		else
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_general_0", true)
			dev.log("adding general trait 0 to character ["..character:command_queue_index().."] ")
			if character:has_trait("shield_general_1") then
				cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_general_1")
			end
		end
	end

	--do not continue if the character is the faction leader
	if character:is_faction_leader() then
		return
	end
	--flag governors
	if char_is_governor(character) then
		if not character:has_trait("shield_governor_flag") then
			dev.log("adding general trait governor_flag to character ["..character:command_queue_index().."] ")
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_governor_flag", false)
		end
	else
		if character:has_trait("shield_governor_flag") then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_governor_flag")
		end
	end
	--flag everyone if the King is a brute or a tyrant
	if character:faction():faction_leader():has_trait("shield_tyrant_legendary_tyrant") then
		if not character:has_trait("shield_tyrant_king_flag") then
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_tyrant_king_flag", false)
			dev.log("adding general trait shield_tyrant_king_flag to character ["..character:command_queue_index().."] ")
		end
	else
		if character:has_trait("shield_tyrant_king_flag") then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_tyrant_king_flag")
		end
	end
	if character:faction():faction_leader():has_trait("shield_brute_violent") then
		if not character:has_trait("shield_brute_king_flag") then
			dev.log("adding general trait shield_brute_king_flag to character ["..character:command_queue_index().."] ")
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_brute_king_flag", false)
		end
	else
		if character:has_trait("shield_brute_king_flag") then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_brute_king_flag")
		end
	end



	if character:loyalty() >= 5 then
		if character:has_trait("shield_trait_disloyal") then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_trait_disloyal")
		end
		if not character:has_trait("shield_trait_loyal") then
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_trait_loyal", false)
		end
	else
		if character:has_trait("shield_trait_loyal") then
			cm:force_remove_trait("character_cqi:"..character:command_queue_index(), "shield_trait_loyal")
		end
		if not character:has_trait("shield_trait_disloyal") then
			cm:force_add_trait("character_cqi:"..character:command_queue_index(), "shield_trait_disloyal", false)
			dev.log("Added disloyal trait to character ["..character:command_queue_index().."] ")
		end
	end

end














