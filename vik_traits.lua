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
--[[
	cm:add_listener(
		"AdditionalTraits",
		"CharacterTurnStart",
		function(context) return context:character():faction():is_human() == true end,
		function(context) TraitsCheck(context) end,
		true
	);
	
	cm:add_listener(
		"EstateGiven",
		"CharacterAssignedEstate",
		function(context) return context:character():faction():is_human() == true end,
		function(context) EstateGivenTraits(context) end,
		true
	);--]]
	--[[
	cm:add_listener(
		"RemoveTraits",
		"CharacterTurnStart",
		function(context) return context:character():faction():is_human() == true end,
		function(context) RemoveEventTraits(context) end,
		true
	);
	
	cm:add_listener(
		"GiveDilemmaTraits",
		"CharacterTurnStart",
		function(context) return context:character():faction():is_human() == true end,
		function(context) GiveEventTraits(context) end,
		true
	);]]
	
	cm:add_listener(
		"GovernorGeneralTraits",
		"CharacterTurnStart",
		true,
		function(context) GovernorGeneralTraits(context) end,
		true
	);
	
end


function TraitsCheck (context)
	
		----------------------------------------------------------------------------
		------------------------------ HEIR TRAITS -----------------------------
		----------------------------------------------------------------------------
	
	local stuckup = false
	local gets_heir_trait = false
	
	-- if heir, chance to get a related trait
	if context:character():is_heir() == true and context:character():age() > 16 then
		if not (context:character():has_trait("vik_politics_heir_stuckup") 
		or  context:character():has_trait("vik_politics_heir_destined") 
		or  context:character():has_trait("vik_politics_lost_heir")) 
		and context:character():faction():is_human() == true then
			if cm:model():random_percent(3) == true then -- does he get a trait
			-- output ("he gets a trait")
			gets_heir_trait = true
				if cm:model():random_percent(50) == true then --which trait does he get
				-- output ("he gets stuckup")
					stuckup = true
				end
			else
				-- output ("he doesnt get a trait")
				gets_heir_trait = false
			end
			
			if stuckup == true and gets_heir_trait == true then
				effect.trait("vik_politics_heir_stuckup", "agent", 5, 100, context)
				elseif stuckup == false and gets_heir_trait == true then
					effect.trait("vik_politics_heir_destined", "agent", 5, 100, context)
			end
			
		end
	end
	
	-- if heir trait but not heir anymore, lose the heir trait, possibly gain new
	if (context:character():has_trait("vik_politics_heir_stuckup") 
		or  context:character():has_trait("vik_politics_heir_destined")) 
		and context:character():is_heir() == false then 
	
		if context:character():has_trait("vik_politics_heir_stuckup") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_politics_heir_stuckup")
			if cm:model():random_percent(25) == true and context:character():is_faction_leader() == false then
				effect.trait("vik_politics_lost_heir", "agent", 5, 100, context)
			end
		end
		if context:character():has_trait("vik_politics_heir_destined") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_politics_heir_destined")
			if cm:model():random_percent(25) == true and context:character():is_faction_leader() == false then
				effect.trait("vik_politics_lost_heir", "agent", 5, 100, context)
			end
		end
	end
	
		----------------------------------------------------------------------------
		----------------- INFLUENCE/LOYALTY TRAITS ------------------------
		----------------------------------------------------------------------------
		
		-- IF CHARACTER HAS AN INFLUENCE TRAIT ALREADY
	if not context:character():is_null_interface()
	and context:character():is_male() == true
	and context:character():is_faction_leader() == false
	and char_is_general_with_army(context:character()) then
	
		------------------------------------------------------------------------------------------------------------------------
	
		if context:character():has_trait("vik_estate_influence_high") then -- TRAIT - HIGH INFLUENCE

			-- output ("high influence"..context:character():gravitas())
			
			if not (context:character():gravitas() > 7) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_influence_high")
				if (context:character():gravitas() == 6 or context:character():gravitas() == 7) then
					effect.trait("vik_estate_influence_med", "agent", 5, 100, context)
				elseif context:character():gravitas() < 6 then
					effect.trait("vik_estate_influence_low","agent", 5, 100, context)
				end
			end
			
		end
	
		if context:character():has_trait("vik_estate_influence_med") then -- TRAIT - MED INFLUENCE

			-- output ("med influence"..context:character():gravitas())
			
			if (not (context:character():gravitas() == 6) and not (context:character():gravitas() == 7)) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_influence_med")
				if (context:character():gravitas() > 7) then
					effect.trait("vik_estate_influence_high", "agent", 5, 100, context)
				elseif (context:character():gravitas() < 6) then
					effect.trait("vik_estate_influence_low","agent", 5, 100, context)
				end
			end
			
		end
		
		if context:character():has_trait("vik_estate_influence_low") then -- TRAIT - LOW INFLUENCE

			-- output ("low influence"..context:character():gravitas())
			
			if not (context:character():gravitas() < 6) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_influence_low")
				if (context:character():gravitas() == 6 or context:character():gravitas() == 7) then
					effect.trait("vik_estate_influence_med", "agent", 5, 100, context)
				elseif context:character():gravitas() > 7 then
					effect.trait("vik_estate_influence_high","agent", 5, 100, context)
				end
			end
			
		end
		
		------------------------------------------------------------------------------------------------------------------------
		
		if context:character():has_trait("vik_estate_loyalty_high") then -- TRAIT - HIGH LOYALTY

			-- output ("high loyalty"..context:character():loyalty())
			
			if not (context:character():loyalty() > 7) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_loyalty_high")
				if (context:character():loyalty() == 6 or context:character():loyalty() == 7) then
					effect.trait("vik_estate_loyalty_med", "agent", 5, 100, context)
				elseif context:character():loyalty() < 6 then
					effect.trait("vik_estate_loyalty_low","agent", 5, 100, context)
				end
			end
			
		end
	
		if context:character():has_trait("vik_estate_loyalty_med") then -- TRAIT - MED LOYALTY

			-- output ("med loyalty"..context:character():loyalty())
			
			if (not (context:character():loyalty() == 6) and not (context:character():loyalty() == 7)) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_loyalty_med")
				if (context:character():loyalty() > 7) then
					effect.trait("vik_estate_loyalty_high", "agent", 5, 100, context)
				elseif (context:character():loyalty() < 6) then
					effect.trait("vik_estate_loyalty_low","agent", 5, 100, context)
				end
			end
			
		end
		
		if context:character():has_trait("vik_estate_loyalty_low") then -- TRAIT - LOW LOYALTY

			-- output ("low loyalty"..context:character():loyalty())
			
			if not (context:character():loyalty() < 6) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_estate_loyalty_low")
				if (context:character():loyalty() == 6 or context:character():loyalty() == 7) then
					effect.trait("vik_estate_loyalty_med", "agent", 5, 100, context)
				elseif context:character():loyalty() > 7 then
					effect.trait("vik_estate_loyalty_high","agent", 5, 100, context)
				end
			end
			
		end
		
		
	end
	
	
		---------------- NEW TRAITS ----------------
		
	local estate_traits = {--"vik_estate_doesnt_care",
		--"vik_estate_min_estates",
		--"vik_estate_more_than_king",
		--"vik_estate_more_than_others",
		--"vik_estate_more_than_lower",
		--"vik_estate_more_than_younger",
		--"vik_estate_none",
		--"vik_estate_type_estate",
		--"vik_estate_type_religion",
		--"vik_estate_type_agriculture",
		--"vik_estate_loyalty_low",
		--"vik_estate_loyalty_med",
		--"vik_estate_loyalty_high",
		--"vik_estate_influence_low",
		--"vik_estate_influence_med",
		--"vik_estate_influence_high",
		--"vik_estate_less_than_king",
		--"vik_estate_more_than_lower_command",
		--"vik_estate_more_than_lower_governance",
		--"vik_estate_not_type_estate",
		--"vik_estate_not_type_religion",
		--"vik_estate_not_type_agriculture",
		--"vik_estate_more_than_generals_and_governors",
		--"vik_estate_more_than_lower_influence"
	}
		
	local loyalty_or_influence_traits = {--"vik_estate_loyalty_low",
	--"vik_estate_loyalty_med",
	--"vik_estate_loyalty_high",
	--"vik_estate_influence_low",
	--"vik_estate_influence_med",
	--"vik_estate_influence_high"
	}
	
	if not context:character():is_null_interface()
	and context:character():is_faction_leader() == false
	and context:character():is_male() == true
	and context:character():age() > 16 == true
	and char_is_general_with_army(context:character()) then
	
		local has_loyalty_or_influence_trait = false
		
		for i=1, #loyalty_or_influence_traits do -- do they have one of these traits already
			if context:character():has_trait(loyalty_or_influence_traits[i]) then
				has_loyalty_or_influence_trait = true
			end
		end
		
	
			local gets_influence_trait = false
			local gets_loyalty_trait = false
			local chance = 0
			local fame = context:character():faction():imperium_level()
			-- output (context:character():faction():imperium_level())
			
		if has_loyalty_or_influence_trait == false then -- only continue if they don't have any of these traits
			
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
				if cm:model():random_percent(50) == true then
					gets_influence_trait = true
				else
					gets_loyalty_trait = true
				end
			end
		end
		
		if gets_influence_trait == true or gets_loyalty_trait == true then
			for i=1, #estate_traits do
					if context:character():has_trait(estate_traits[i]) then
						cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(),estate_traits[i])
					end
			end
		end
		
		---------------- NEW INFLUENCE TRAITS ----------------
	
		if gets_influence_trait == true then -- only continue if they can get new traits
			if (context:character():gravitas() == 8
			or context:character():gravitas() == 9
			or context:character():gravitas() == 10) then
				--effect.trait("vik_estate_influence_high", "agent", 3, 100, context)
				-- output ("has high influence trait "..tostring (context:character():has_trait("vik_estate_influence_high")))
			end
			
			if (context:character():gravitas() == 6
			or context:character():gravitas() == 7) then
				--effect.trait("vik_estate_influence_med", "agent", 3, 100, context)
				-- output ("has med influence trait "..tostring (context:character():has_trait("vik_estate_influence_med")))
			end
			
			if (context:character():gravitas() == 3
			or context:character():gravitas() == 4
			or context:character():gravitas() == 5) then
				--effect.trait("vik_estate_influence_low", "agent", 3, 100, context)
				-- output ("has low influence trait "..tostring (context:character():has_trait("vik_estate_influence_low")))
			end
		end
		
		---------------- NEW LOYALTY TRAITS ----------------
		
		if gets_loyalty_trait == true then
			if (context:character():loyalty() == 8
			or context:character():loyalty() == 9
			or context:character():loyalty() == 10) then
				--effect.trait("vik_estate_loyalty_high", "agent", 3, 100, context)
				-- output ("has high loyalty trait "..tostring (context:character():has_trait("vik_estate_loyalty_high")))
			end
			
			if (context:character():loyalty() == 6
			or context:character():loyalty() == 7) then
				--effect.trait("vik_estate_loyalty_med", "agent", 3, 100, context)
				-- output ("has med loyalty trait "..tostring (context:character():has_trait("vik_estate_loyalty_med")))
			end
			
			if (context:character():loyalty() == 3
			or context:character():loyalty() == 4
			or context:character():loyalty() == 5) then
				--effect.trait("vik_estate_loyalty_low", "agent", 3, 100, context)
				--output ("has low loyalty trait "..tostring (context:character():has_trait("vik_estate_loyalty_low")))
			end
		end
		
		
	end
	
		
		----------------------------------------------------------------------------
		----------------------- KING ESTATE TRAITS --------------------------
		----------------------------------------------------------------------------
		-- if the character is a King and has Estate trait this should a) be removed b) possibly replaced with something else
		
	local estate_other_received_traits = {--"vik_estate_lower_rank_received",
		--"vik_estate_younger_received",
		--"vik_estate_other_received"
	}
	
	local king_estate_traits = {--"vik_king_estate_min_estates",
		--"vik_king_esate_more_than_others",
		--"vik_king_estate_more_than_lower",
		--"vik_king_estate_more_than_younger",
		--"vik_king_estate_type_agriculture",
		--"vik_king_estate_type_estate",
		--"vik_king_estate_type_religion",
		--"vik_king_estate_not_type_agriculture",
		--"vik_king_estate_not_type_estate",
		--"vik_king_estate_not_type_religion",
		--"vik_king_estate_more_than_generals_and_governors",
		--"vik_king_estate_more_than_lower_command",
		--"vik_king_estate_more_than_lower_governance",
		--"vik_king_estate_more_than_lower_influence"
	}
	
	local king_no_estate_traits = {"vik_king_estate_none"
		}
	
	local king_trait_removed = false
	local king_wants_none = false
	local king_random_trait
	local king_trait_random_chance = 50
	
	if context:character():is_faction_leader() == true then -- is it the king
		for i=1, #estate_traits do -- do they have a trait already
			 -- output(estate_traits[i]) -- which trait is being checked
			if context:character():has_trait(estate_traits[i]) then
				-- output ("has this trait: "..estate_traits[i])
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), estate_traits[i])
				king_trait_removed = true -- did we remove any traits
				if (estate_traits[i] == "vik_estate_doesnt_care") or (estate_traits[i] == "vik_estate_none") then
					king_wants_none = true -- if the king never used to care about Estates, they shouldn't care when they become a king
				end
			end
		end
		
		for i=1, #estate_other_received_traits do -- do they have a trait already
			-- output(estate_other_received_traits[i]) -- which trait is being checked
			if context:character():has_trait(estate_other_received_traits[i]) then
				-- output ("has this trait: "..estate_other_received_traits[i])
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), estate_traits[i])
			end
		end
			
		if king_trait_removed == true then
			if cm:model():random_percent(king_trait_random_chance) == true then -- does the king get a new trait
				if king_wants_none == true then
					king_random_trait = king_no_estate_traits[cm:random_number(#king_no_estate_traits,1)]-- Doesn't care - King version
				else
					king_random_trait = king_estate_traits[cm:random_number(#king_estate_traits,1)] -- pick from King's estate traits
				end
				output ("gains this trait: "..king_random_trait)
				effect.trait(king_random_trait, "agent", 5, 100, context) -- give the king the new trait
			end
		end
	end
		
end

				
	-------------------------------------------------------------------------------
	------------------------- ESTATE GIVEN TRAIT ----------------------------
	-------------------------------------------------------------------------------

function EstateGivenTraits (context)
	-------------------------------------------------------------------------------
	------------------------- DECLARE VARIABLES ----------------------------
	-------------------------------------------------------------------------------
	local lower_rank_received, younger_received, other_received, dedicated_received, agricultural_received, religious_received
	local received_rank, received_age, received_character, received_character_cqi
	local give_trait_chance = 100
	local should_give_trait = false
	local trait_given = false
	local character_to_give, trait_to_give
	local character_count, character_cqi, character_age, character_rank
	
	received_character = context:estate():owner()
	received_age = context:estate():owner():age()
	received_rank = context:estate():owner():rank()
	received_character_cqi = received_character:command_queue_index()
	
	local character_list = {}
	local valid_trait_list = {}
	
	local fame = context:character():faction():imperium_level()
		
		if fame == 3 then -- low chance
			give_trait_chance = 5
			elseif fame == 4 then -- some chance
			give_trait_chance = 10
			elseif fame == 5 then -- high chance
			give_trait_chance = 15
			elseif fame > 5 then -- pretty much certain
			give_trait_chance = 25
		end
	
	-------------------------------------------------------------------------------
	------------------------- DO WE GET ANY TRAITS ------------------------
	-------------------------------------------------------------------------------
	
	if cm:model():random_percent(give_trait_chance) == true then
		should_give_trait = true
	end
	
	-------------------------------------------------------------------------------
	------------------------- WHO GETS TRAIT --------------------------------
	-------------------------------------------------------------------------------
	if should_give_trait == true then
		character_count = context:estate():owner():faction():character_list():num_items()
		
		for i=1, character_count-1 do
			local current_character = context:estate():owner():faction():character_list():item_at(i)
			
			if not current_character:is_null_interface() -- only continue if the character can get a trait
			and current_character:is_faction_leader() == false
			and current_character:is_male() == true
			and current_character:age() > 16 == true
			and char_is_general_with_army(current_character) 
			and trait_given == false 
			and not current_character:has_trait("vik_estate_none") 
			and not current_character:has_trait("vik_estate_doesnt_care") then
				table.insert (character_list, current_character)
			end
		end
		
		if #character_list > 0 then
			character_to_give = character_list[cm:random_number(#character_list,1)]
		end
	end
	-------------------------------------------------------------------------------
	------------------------- WHAT TRAIT TO GIVE ---------------------------
	-------------------------------------------------------------------------------
	
	
	if character_to_give ~= nil and should_give_trait == true then
		character_age = character_to_give:age()
		character_rank = character_to_give:rank()
		character_cqi = character_to_give:command_queue_index()
				
		if character_cqi ~= received_character_cqi and trait_given == false then -- when others received estate
			-- output ("2 - someone else received an estate")
			other_received = true -- someone else received the estate
			--table.insert (valid_trait_list,"vik_estate_other_received")
			
			if received_age < character_age then
				younger_received = true -- younger char received estate
				--table.insert (valid_trait_list,"vik_estate_younger_received")
			end
			
			if received_rank < character_rank then
				lower_rank_received = true -- lower rank character received the estate
				--table.insert (valid_trait_list,"vik_estate_lower_rank_received")
			end
		end
	
		if character_to_give == received_character and trait_given == false then -- when they received estate
			-- output ("4 - this character received an estate")
			if context:estate():estate_record_key() == "vik_estate_agricultural" then
				agricultural_received = true
				--table.insert (valid_trait_list,"vik_estate_agricultural_received")
			end
			
			if context:estate():estate_record_key() == "vik_estate_estate_building" then
				dedicated_received = true
				--table.insert (valid_trait_list,"vik_estate_estate_building_received")
			end
			
			if context:estate():estate_record_key() == "vik_estate_religious" then
				religious_received = true
				--table.insert (valid_trait_list,"vik_estate_religious_received")
			end
			
		end
	
		output("number of valid traits: "..#valid_trait_list)
	
	end
	
	if #valid_trait_list > 0 then
		trait_to_give = valid_trait_list[cm:random_number(#valid_trait_list,1)]
		
		-------------------------------------------------------------------------------
		------------------------- GIVE TRAIT TO CHARACTER --------------------
		-------------------------------------------------------------------------------
		
		cm:force_add_trait("character_cqi:"..character_to_give:command_queue_index(), trait_to_give, true)
	end

	
end


	-------------------------------------------------------------------------------
	--------------------------- GIVE  EVENT TRAITS --------------------------
	-------------------------------------------------------------------------------

function GiveEventTraits (context)


	----------------------------------------------------------------------------
	------------------------- POLITICS TRAITS -----------------------------
	----------------------------------------------------------------------------
		
		-- DIVORCED - remove chuffed trait
	if context:character():has_trait("vik_politics_cowardly_marry_chuffed") then
		if not context:character():has_spouse() then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_politics_cowardly_marry_chuffed")
		end
	end
	
	
	--------- USURPERS ---------
	
------ THESE ARE DISABLED FOR THE TIME BEING AS THE INCIDENTS CANNOT SHOW THE CHARACTERS INVOLVED
	
	-- local male_usurpers = {"vik_bg_general_passionate",
		-- "vik_estate_loyalty_low",
		-- "vik_governor_greedy_influence_low_1",
		-- "vik_governor_greedy_influence_low_2",
		-- "vik_governor_greedy_influence_low_3",
		-- "vik_governor_greedy_loyalty_low_1",
		-- "vik_governor_greedy_loyalty_low_2",
		-- "vik_governor_greedy_loyalty_low_3",
		-- "vik_pers_greedy",
		-- "vik_politics_divorce_upset",
		-- "vik_politics_loyalty_fakes",
		-- "vik_politics_plotting",
		-- "vik_politics_torture_2",
		-- "vik_start_public_speaker"
	-- }

	-- local female_usurpers = {"vik_back_wife_ambitious",
		-- "vik_back_wife_ambitious_circenn",
		-- "vik_back_wife_ambitious_dyflin",
		-- "vik_back_wife_ambitious_east_engle",
		-- "vik_back_wife_ambitious_gwined",
		-- "vik_back_wife_ambitious_mide",
		-- "vik_back_wife_ambitious_mierce",
		-- "vik_back_wife_ambitious_northymbre",
		-- "vik_back_wife_ambitious_strat_clut",
		-- "vik_back_wife_ambitious_sudreyar",
		-- "vik_back_wife_ambitious_west_seaxe",
		-- "vik_back_wife_gossip",
		-- "vik_back_wife_gossip_circenn",
		-- "vik_back_wife_gossip_dyflin",
		-- "vik_back_wife_gossip_east_engle",
		-- "vik_back_wife_gossip_gwined",
		-- "vik_back_wife_gossip_mide",
		-- "vik_back_wife_gossip_mierce",
		-- "vik_back_wife_gossip_northymbre",
		-- "vik_back_wife_gossip_strat_clut",
		-- "vik_back_wife_gossip_sudreyar",
		-- "vik_back_wife_gossip_west_seaxe"
	-- }
	
	-- if cm:model():turn_number() > 5 then -- don't trigger for the first 5 turn to avoid same-seed input to the chance below
		-- if cm:model():random_percent(3) == true then -- 3% chance per character per turn to kick off the usurper incident trail
			
			-- if not context:character():is_null_interface()
			-- and context:character():is_faction_leader() == false
			-- and context:character():is_male() == true
			-- and context:character():age() > 16 == true then
				-- for i=1, #male_usurpers do
					-- if context:character():has_trait(male_usurpers[i]) then
						-- if not context:character():has_trait("vik_usurper_trait")
						-- and not context:character():has_trait("vik_usurper_trait_2") then
							-- if cm:model():random_percent(50) == true then
								-- cm:force_add_trait("character_cqi:"..context:character():command_queue_index(),"vik_usurper_trait", true)
							-- else 
								-- cm:force_add_trait("character_cqi:"..context:character():command_queue_index(),"vik_usurper_trait_2", true)
							-- end
						-- end
					-- end
				-- end
			-- end
		
			-- if context:character():is_male() == false
			-- and context:character():age() > 16 == true then
				-- for i=1, #female_usurpers do
					-- if context:character():has_skill(female_usurpers[i]) then
						-- if cm:model():random_percent(50) == true then
							-- cm:trigger_incident(context:character():faction():name(), "vik_traits_usurper_wife_1", true)
						-- else 
							-- cm:trigger_incident(context:character():faction():name(), "vik_traits_usurper_wife_2", true)
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
	
	if context:character():is_faction_leader() then
		if context:character():has_trait("vik_usurper_trait") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_usurper_trait")
		end
		if context:character():has_trait("vik_usurper_trait_2") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_usurper_trait_2")
		end
	end

	local plotting_traits = {
	"vik_politics_malicious_plotting",
	"vik_political_brutish_vengeful_var_1",
	"vik_political_malicious_vengeful_var_2",
	"vik_political_malicious_vengeful_var_3",
	"vik_political_malicious_vengeful_var_4",
	"vik_political_malicious_vengeful_var_5"
	}
	
	for i=1, #plotting_traits do
		if context:character():has_trait(plotting_traits[i]) and not context:character():has_trait("vik_dilemma_plotting_hidden") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_plotting_hidden", true)
		end
	end
	
	if context:character():is_faction_leader() then
		for i=1, #plotting_traits do
			if context:character():has_trait(plotting_traits[i]) then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), plotting_traits[i])
			end
			if context:character():has_trait("vik_dilemma_plotting_hidden") then
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_plotting_hidden")
			end
		end
	end
	
	local aesthetic_traits = {
	"vik_general_noble_assembly",
	"vik_general_noble_bard",
	"vik_general_noble_cloth",
	"vik_general_noble_embroiders",
	"vik_general_noble_estate",
	"vik_general_noble_gold",
	"vik_general_noble_great_hall",
	"vik_general_noble_iron",
	"vik_general_noble_konungsgurtha",
	"vik_general_noble_orchard",
	"vik_general_noble_pottery",
	"vik_general_noble_silver",
	"vik_governor_noble_guildhall",
	"vik_governor_noble_income_pos",
	"vik_governor_noble_influence_high",
	"vik_governor_noble_metropolitan",
	"vik_governor_noble_runestone",
	"vik_governor_noble_sculptors",
	"vik_politics_noble_heir_destined"
	}
	
	local has_a_trait = false
	
	if context:character():has_trait("vik_dilemma_aesthetic_hidden") then
		for i=1, #aesthetic_traits do
			if context:character():trait_points(aesthetic_traits[i]) > 2 then
				has_a_trait = true
			end
		end
		if has_a_trait == false then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_aesthetic_hidden")
		end
	end
	
	for i=1, #aesthetic_traits do
		if context:character():trait_points(aesthetic_traits[i]) > 2 and not context:character():has_trait("vik_dilemma_aesthetic_hidden") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_aesthetic_hidden", true)
		end
	end
	
	local court_traits = {
	"vik_governor_wise_court_school",
	"vik_general_wise_court"
	}
	
	local has_c_trait = false
	
	if context:character():has_trait("vik_dilemma_court_hidden") then
		for i=1, #court_traits do
			if context:character():trait_points(court_traits[i]) > 2 then
				has_c_trait = true
			end
		end
		if has_c_trait == false then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_court_hidden")
		end
	end
	
	for i=1, #court_traits do
		if context:character():trait_points(court_traits[i]) > 2 and not context:character():has_trait("vik_dilemma_court_hidden") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_court_hidden", true)
		end
	end
	
	local legendary_traits = {
	"vik_legendary_attacker",
	"vik_legendary_defender",
	"vik_legendary_general",
	"vik_legendary_governor",
	"vik_legendary_military_leader"
	}
	
	local has_l_trait = false
	
	if context:character():has_trait("vik_dilemma_legendary_hidden") then
		for i=1, #legendary_traits do
			if context:character():trait_points(legendary_traits[i]) > 2 then
				has_l_trait = true
			end
		end
		if has_l_trait == false then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_legendary_hidden")
		end
	end
	
	for i=1, #legendary_traits do
		if context:character():trait_points(legendary_traits[i]) > 2 and not context:character():has_trait("vik_dilemma_legendary_hidden") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_legendary_hidden", true)
		end
	end
	
	local church_traits = {
	"vik_general_virtuous_church",
	"vik_governor_virtuous_church"
	}
	
	local has_ch_trait = false
	
	if context:character():has_trait("vik_dilemma_church_hidden") then
		for i=1, #church_traits do
			if context:character():trait_points(church_traits[i]) > 2 then
				has_ch_trait = true
			end
		end
		if has_ch_trait == false then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_church_hidden")
		end
	end
	
	for i=1, #church_traits do
		if context:character():trait_points(church_traits[i]) > 2 and not context:character():has_trait("vik_dilemma_church_hidden") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "vik_dilemma_church_hidden", true)
		end
	end
	
	-- local character = context:character()
	-- output ("trait points... "..character:trait_points("vik_dilemma_aesthetic_hidden")..character:trait_points("vik_dilemma_court_hidden")..character:trait_points("vik_dilemma_legendary_hidden")..character:trait_points("vik_dilemma_church_hidden"))
	
	
end

-------------------------------------------------------------------------------
------------------------- REMOVE  EVENT TRAITS ------------------------
-------------------------------------------------------------------------------

function RemoveEventTraits (context) 
	
	local political_traits = {
		"vik_political_brutish_vengeful_var_1",
		"vik_political_malicious_vengeful_var_2",
		"vik_political_malicious_vengeful_var_3",
		"vik_political_malicious_vengeful_var_4",
		"vik_political_malicious_vengeful_var_5",
		"vik_politics_virtuous_adopt_grateful",
		"vik_politics_sinful_adopt_spiteful",
		"vik_politics_sinful_bribed",
		"vik_politics_brutish_divorce_upset",
		"vik_politics_noble_heir_destined",
		"vik_politics_foolish_heir_stuckup",
		"vik_politics_malicious_lost_heir",
		"vik_politics_malicious_lower_influence",
		"vik_politics_cowardly_loyalty_fakes",
		"vik_politics_virtuous_loyalty_truly",
		"vik_politics_cowardly_marry_chuffed",
		"vik_politics_malicious_plotting",
		"vik_politics_cowardly_strip_estate",
		"vik_politics_cowardly_tortured"
	}

	for i=1, #political_traits do
		if context:character():has_trait(political_traits[i]) then
			if cm:model():random_percent(5) == true then 
				if cm:model():random_percent(10) == true then
					cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), political_traits[i])
				end
			end
		end
	end
	
end

-------------------------------------------------------------------------------
-------------------- GOVERNOR/GENERAL TRAITS -----------------------
-------------------------------------------------------------------------------

function GovernorGeneralTraits (context)
	
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
	
	if context:character():faction():name() == "vik_fact_west_seaxe" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_mierce" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_gwined" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_strat_clut" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_circenn" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_mide" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_east_engle" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_northymbre" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_dyflin" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end
	
	if context:character():faction():name() == "vik_fact_sudreyar" then
		governor_lost_trait = "vik_gov_province_lost_west_seaxe"
		general_lost_trait = "vik_gen_force_lost_west_seaxe"
	end

	-- remove governor trait, add new or lost trait
	for i=1, #province_trait_list do
		if context:character():has_trait(province_trait_list[i]) 
		and not (context:character():has_region() and char_is_governor(context:character()) and context:character():region():province_name() == province_list[i]) then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), province_trait_list[i])
			-- output ("not governor of last province anymore - "..province_list[i])
			-- if still governor but somewhere else give that trait instead
			if (context:character():has_region() and char_is_governor(context:character())) then
				for i=1, #province_list do
					if context:character():region():province_name() == province_list[i] then
						-- output (province_list[i])
						cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), province_trait_list[i], true)
					end
				end
			else
				cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), governor_lost_trait, true)
			end
		end
	end
	
	-- remove hidden general trait, add lost trait
	for i = 0,1 do
		if context:character():has_trait("vik_general_hidden") and (not char_is_governor(context:character())) then
			if (not char_is_general_with_army(context:character())) then  --not a general anymore.
				if character:has_trait("shield_trait_general_"..i) then
					cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_general_"..i)
				end
				cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), general_lost_trait, true)
			elseif (context:character():military_force():unit_list():num_items() < (12*i)) --if we have less than 12 units and i is 1, we should remove a trait.
			or (context:character():military_force():unit_list():num_items() >= 12 and (i == 0)) then --if we have more than 12 units and i is 0, we should remove a trait.
				if character:has_trait("shield_trait_general_"..trait_num) then
					cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_general_"..trait_num)
				end
			end
		end
	end
	
	-- add governor trait
	if context:character():has_region() and char_is_governor(context:character()) then
		if context:character():has_trait(governor_lost_trait) then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), governor_lost_trait)
		end			
		for i=1, #province_list do
			if context:character():region():province_name() == province_list[i] and not context:character():has_trait(province_trait_list[i]) then
				-- output (province_list[i])
				cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), province_trait_list[i], true)
				return
			end
		end
	end
	
	-- add hidden general trait
	if char_is_general_with_army(context:character()) and not char_is_governor(context:character()) then
		if context:character():has_trait(general_lost_trait) then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), general_lost_trait)
		end
		local num_men = context:character():military_force():unit_list():num_items()
		local trait_num = 0
		if num_men >= 12 then
			trait_num = 1
		end
		cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_general_"..trait_num, true)
	end

	if context:character():loyalty() >= 5 then
		if context:character():has_trait("shield_trait_disloyal") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_disloyal")
		end
		if not context:character():has_trait("shield_trait_loyal") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_loyal", false)
		end
	else
		if context:character():has_trait("shield_trait_loyal") then
			cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_loyal")
		end
		if not context:character():has_trait("shield_trait_disloyal") then
			cm:force_add_trait("character_cqi:"..context:character():command_queue_index(), "shield_trait_disloyal", false)
		end
	end

end














