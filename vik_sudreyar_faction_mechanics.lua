-------------------------------------------------------------------------------
-------------------------- SUDREYAR FACTION MECHANICS -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Joy: 02/10/2017 --------------------------
------------------------- Last Updated: 20/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Unique faction mechanics for Sudreyar
S_SACK_MISSION = 0
S_BLOCKADE_MISSION = 0
S_RAID_ENEMY = false
S_FIGHT_ENEMY = false
S_MISSION_ACTIVE = false
S_MISSION_TURN = 5

SK_TRIBUTE_SUD = 5
SK_TRIBUTE_LAST_TURN_SUD = 5
SK_TRIBUTE_LEVEL_SUD = 1
SK_TRIBUTE_SUD_DIPLOMACY = 0
SK_TRIBUTE_SUD_BATTLE = 5
SK_TRIBUTE_EVENT_SUD = 0
SK_TRIBUTE_DECAY_SUD = 0
SK_TRIBUTE_EXPEDITION_SUD = 0
SK_TRIBUTE_SACK_SUD = 0
SK_TRIBUTE_RAID_SUD = 0
SK_TRIBUTE_DECREES_SUD = 0

SK_TRIBUTE_TECH_SUD = 0

SK_RELIGION = {
["vik_fact_dyflin"] = { false, false, false, false, false, false, false, true}, -- first one is the intro incident, last one is true while staying pagan
["vik_fact_sudreyar"] = { false, false, false, false, false, false, false, true}
}

SUD_TECH_TRADE = false

-- Listeners
function Add_Sudreyar_Mechanics_Listeners()
output("#### Adding Sudreyar Mechanics Listeners ####")
	cm:add_listener( -- Start of the turn 
		"FactionTurnStart_SudreyarMechanics",
		"FactionTurnStart",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarStartMechanicsChecks(context) end,
		true
	);
	cm:add_listener( -- End of the turn
		"FactionTurnEnd_SudreyarMechanicsEnd",
		"FactionTurnEnd",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarEndMechanicsChecks(context) end,
		true
	);
	cm:add_listener( -- Player completed a mission - player is Sudreyar
		"MissionSucceeded_Assembly_Sudreyar",
		"MissionSucceeded",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarMissionComplete(context) end,
		true
	);
	cm:add_listener( -- Player cancelled a mission - player is Sudreyar
		"MissionCancelled_Sudreyar",
		"MissionCancelled",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarMissionComplete(context, "vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Player failed a mission - player is Sudreyar
		"MissionFailed_Sudreyar",
		"MissionFailed",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarMissionComplete(context, "vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Sacked a settlement - sudreyar
		"CharacterPerformsOccupationDecisionSack_Sudreyar_Sack",
		"CharacterPerformsOccupationDecisionSack",
		function(context) return context:character():faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarSack(context) end,
		true
	);
	cm:add_listener( -- Issued a mission - sudreyar
		"MissionIssued_Assembly_Sudreyar",
		"MissionIssued",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarMissionIssued(context) end,
		true
	);
	cm:add_listener( -- Blockading a port - Sudreyar
		"CharacterBlockadedPort_Sudreyar_Blockade",
		"CharacterBlockadedPort",
		function(context) return context:character():faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarBlockadePort(context) end,
		true
	);
	cm:add_listener( -- Completed a battle - sudreyar
		"CharacterCompletedBattle_SeaKingsBattleResult_Sudreyar",
		"BattleCompleted",
		function(context) return cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarAfterBattle("vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Accepted a diplomacy agreement - sudreyar
		"FactionDiplomacyPaymentReceived_SeaKingsDiplomacy_Sudreyar",
		"FactionDiplomacyPaymentReceived",
		function(context) return cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarTributeRecieved(context, "vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Dilemma Choice - Sudreyar
		"DilemmaChoiceMadeEvent_Choice_Sudreyar",
		"DilemmaChoiceMadeEvent",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) DilemmaChoiceMadeEvent_Sudreyar_Dilemma(context, "vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Sudreyar occupied a settlement
		"CharacterPerformsOccupationDecisionOccupy_Occupy_Sudreyar",
		"CharacterPerformsOccupationDecisionOccupy",
		function(context) return context:character():faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) SudreyarOccupySettlement(context, "vik_fact_sudreyar") end,
		true
	);

	if cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true then
		ApplyReligionBundle("vik_fact_sudreyar")
		SudreyarTributeCheck("vik_fact_sudreyar", false, false);
	end
end 

--------------------------------------------------------------------------------
----------------------------------Functions-------------------------------------
--------------------------------------------------------------------------------

function SudreyarStartMechanicsChecks(context)
	-- Start of the turn
	--local total_units = CMTotalUnitsInArmy(context);
	local turn_number = cm:model():turn_number();

	--Check if an Expedition event should be triggered
	ExpeditionCheckTurnStart("vik_fact_sudreyar");
	
	-- Check if a mission should be triggered
	if S_MISSION_TURN == turn_number then
		output("Time for a mission");
		-- Check if player is at war, if yes then check if the war missions should be triggered
		local is_at_war = context:faction():at_war();
		if S_MISSION_ACTIVE == false then
			if is_at_war == true then
				cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_6", true);
				if S_RAID_ENEMY == false then
					cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_fight_2", true);
				end
				if S_FIGHT_ENEMY == false and S_RAID_ENEMY == false then
					SudreyarWarMissions(context);
				end
			else 
				SudreyarAssemblyMissions(context);
			end
		end
	end
	
	-- Fail safe in case a mission failed to trigger
	local temp_number = turn_number - 11;
	if S_MISSION_ACTIVE == false then
		if S_MISSION_TURN < temp_number then
			S_MISSION_TURN = turn_number + 1;
		end
	end
	
	if context:faction():has_technology("vik_sudreyar_civ_market_5") == true and SUD_TECH_TRADE == false then
		SUD_TECH_TRADE = true;
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 20;
		SK_TRIBUTE_TECH_SUD = SK_TRIBUTE_TECH_SUD + 20;
	end
	
	--Reduce Tribute by 1 at the start of each turn
	if SK_TRIBUTE_LAST_TURN_SUD == SK_TRIBUTE_SUD then
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD - 1;
		SK_TRIBUTE_DECAY_SUD = SK_TRIBUTE_DECAY_SUD - 1;
	end
	
	SK_TRIBUTE_LAST_TURN_SUD = SK_TRIBUTE_SUD
	
	SudreyarTributeCheck("vik_fact_sudreyar", false, false);
	CheckConvertDilemma(context, "vik_fact_sudreyar")
end

function SudreyarEndMechanicsChecks(context)
	SK_TRIBUTE_SUD_DIPLOMACY = 0
	SK_TRIBUTE_SUD_BATTLE = 0
	SK_TRIBUTE_TECH_SUD = 0
	SK_TRIBUTE_EVENT_SUD = 0
	SK_TRIBUTE_DECAY_SUD = 0
	SK_TRIBUTE_EXPEDITION_SUD = 0
	SK_TRIBUTE_DECREES_SUD = 0
	SK_TRIBUTE_RAID_SUD = 0
	SK_TRIBUTE_SACK_SUD = 0

	--Adjust tribute by raiding.
	local military_list = context:faction():military_force_list();
	local raiding_units = 0
	for i = 0, military_list:num_items() - 1 do
		if military_list:item_at(i):upkeep() > 0 then
			if military_list:item_at(i):active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or military_stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SEA_RAID" then
				local region = military_list:item_at(i):general_character():region();
				if region ~= nil and region:owning_faction():is_null_interface() == false and region:owning_faction():name() == context:faction():name() then
					raiding_units = raiding_units - military_list:item_at(i):unit_list():num_items()
				else
					raiding_units = raiding_units + military_list:item_at(i):unit_list():num_items()
				end
			end
		end
	end
	if raiding_units > 0 then
		raiding_units = math.ceil(raiding_units/10)
	elseif raiding_units < 0 then
		raiding_units = math.floor(raiding_units/10)
	end

	SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + raiding_units;
	SK_TRIBUTE_RAID_SUD = SK_TRIBUTE_RAID_SUD + raiding_units;
	
end

--------------------------------------------------------------------------------
-----------------------------Assembly Missions----------------------------------
--------------------------------------------------------------------------------

function SudreyarWarMissions(context)
	-- Start one of the missions that are triggered when the player is at war
	local ran_number = cm:random_number(5);
	if ran_number == 1 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_1", true);
		output("Triggering Raid 1")
	elseif ran_number == 2 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_4", true);
		output("Triggering Raid 4")
	elseif ran_number == 3 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_fight_1", true);
		output("Triggering Fight 1")
	elseif ran_number == 4 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_blockade_1", true);
		output("Triggering Blockade 1")
	elseif ran_number == 5 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_sack_1", true);
		output("Triggering Sack 1")
	end
end

function SudreyarAssemblyMissions(context)
	-- Start one of the missions that are triggered when the player is not at war
	local ran_number = cm:random_number(8);
	
	if ran_number == 1 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_2", true);
		output("Triggering Raid 2")
	elseif ran_number == 2 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_3", true);
		output("Triggering Raid 3")
	elseif ran_number == 3 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_raid_5", true);
		output("Triggering Raid 5")
	elseif ran_number == 4 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_sack_2", true);
		output("Triggering Sack 5")
	elseif ran_number == 5 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_sack_3", true);
		output("Triggering Sack 3")
	elseif ran_number == 6 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_sack_4", true);
		output("Triggering Sack 4")
	elseif ran_number == 7 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_blockade_2", true);
		output("Triggering Blockade 2")
	elseif ran_number == 8 then
		cm:trigger_mission("vik_fact_sudreyar", "vik_sudreyar_assembly_blockade_3", true);
		output("Triggering Blockade 3")
	end
end

function SudreyarMissionIssued(context)
	-- A mission was issued - set variables if needed
	local mission = context:mission():mission_record_key();
	
	if mission == "vik_sudreyar_assembly_raid_6" then
		S_RAID_ENEMY = true;	
		output("Triggering Raid 6")
	end
	
	if mission == "vik_sudreyar_assembly_fight_2" then
		S_FIGHT_ENEMY = true;
		output("Triggering Fight 2")
	end
	
	if mission == "vik_sudreyar_assembly_blockade_1" then
		S_BLOCKADE_MISSION = 1;
	end
	
	if mission == "vik_sudreyar_assembly_blockade_2" then
		S_BLOCKADE_MISSION = 2;
		output("Blockade 2 is triggered and variable is set")
	end
	
	if mission == "vik_sudreyar_assembly_blockade_3" then
		S_BLOCKADE_MISSION = 3;
	end
	
	if mission == "vik_sudreyar_assembly_sack_1" then
		S_SACK_MISSION = 1;
	end
	
	if mission == "vik_sudreyar_assembly_sack_2" then
		S_SACK_MISSION = 2;
	end
	
	if mission == "vik_sudreyar_assembly_sack_3" then
		S_SACK_MISSION = 3;
	end
	
	if mission == "vik_sudreyar_assembly_sack_4" then
		S_SACK_MISSION = 4;
	end

	if mission == "vik_sudreyar_assembly_blockade_1" or mission == "vik_sudreyar_assembly_blockade_2" or mission == "vik_sudreyar_assembly_blockade_3" or 
	mission == "vik_sudreyar_assembly_fight_1" or mission == "vik_sudreyar_assembly_fight_2" or mission == "vik_sudreyar_assembly_raid_1" or 
	mission == "vik_sudreyar_assembly_raid_2" or mission == "vik_sudreyar_assembly_raid_3" or mission == "vik_sudreyar_assembly_raid_4" or 
	mission == "vik_sudreyar_assembly_raid_5"  or mission == "vik_sudreyar_assembly_raid_6" or mission == "vik_sudreyar_assembly_sack_1" or
	mission == "vik_sudreyar_assembly_sack_2" or mission == "vik_sudreyar_assembly_sack_3" or mission == "vik_sudreyar_assembly_sack_4" then
		S_MISSION_ACTIVE = true;
	end
	
end

function SudreyarMissionComplete(context)
	-- A mission was complete - set variables if needed
	local mission = context:mission():mission_record_key();
	local turn_number = cm:model():turn_number();
	
	if mission == "vik_sudreyar_assembly_raid_6" then
		S_RAID_ENEMY = false;
	end
	if mission == "vik_sudreyar_assembly_fight_2" then
		S_FIGHT_ENEMY = false;
	end

	if mission == "vik_sudreyar_assembly_blockade_1" or mission == "vik_sudreyar_assembly_blockade_2" or mission == "vik_sudreyar_assembly_blockade_3" or 
	mission == "vik_sudreyar_assembly_fight_1" or mission == "vik_sudreyar_assembly_fight_2" or mission == "vik_sudreyar_assembly_raid_1" or 
	mission == "vik_sudreyar_assembly_raid_2" or mission == "vik_sudreyar_assembly_raid_3" or mission == "vik_sudreyar_assembly_raid_4" or 
	mission == "vik_sudreyar_assembly_raid_5"  or mission == "vik_sudreyar_assembly_raid_6" or mission == "vik_sudreyar_assembly_sack_1" or
	mission == "vik_sudreyar_assembly_sack_2" or mission == "vik_sudreyar_assembly_sack_3" or mission == "vik_sudreyar_assembly_sack_4" then
		S_MISSION_TURN = turn_number + 10;
		S_MISSION_ACTIVE = false;
	end
end

-------------------------------------------------------------------
------------------------- Tribute ---------------------------------
-------------------------------------------------------------------

function SudreyarBlockadePort()
	--Check if one of the blockade missions is active
	if S_BLOCKADE_MISSION == 1 or S_BLOCKADE_MISSION == 2 or S_BLOCKADE_MISSION == 3 then
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_sudreyar_assembly_blockade_"..S_BLOCKADE_MISSION, true);
		output("Mission complete")
		S_BLOCKADE_MISSION = 0;
	end
	
end

function SudreyarSack(context) 
	-- Sudreyar sacked a settlement
	if S_SACK_MISSION == 1 or S_SACK_MISSION == 2 or S_SACK_MISSION == 3 or S_SACK_MISSION == 4 then
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_sudreyar_assembly_sack_"..S_SACK_MISSION, true);
		S_SACK_MISSION = 0;
	end
	if SackExploitCheck(GetClosestSettlement(context)) then
		local sacktribute = cm:random_number(5, 3)
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + sacktribute;
		SK_TRIBUTE_SACK_SUD = SK_TRIBUTE_SACK_SUD + sacktribute;
		SudreyarTributeCheck("vik_fact_sudreyar");
	end
	
end

function SudreyarAfterBattle(faction)
	-- After completing a battle
	local battle_result = CMBattleResult("vik_fact_sudreyar");
	
	if battle_result ~= "" then
		if battle_result == "pyrrhic_victory" then
			SudreyarIncreaseTribute(context);
		elseif battle_result == "close_victory" then
			SudreyarIncreaseTribute(context);
		elseif battle_result == "decisive_victory" then
			SudreyarIncreaseTribute(context);
		elseif battle_result == "heroic_victory" then
			SudreyarIncreaseTribute(context);
		-- If it was a defeat then lose heroism
		elseif battle_result == "crushing_defeat" then
			SudreyarDecreaseTribute(context);
		elseif battle_result == "decisive_defeat" then
			SudreyarDecreaseTribute(context);
		elseif battle_result == "close_defeat" then
			SudreyarDecreaseTribute(context);
		elseif battle_result == "valiant_defeat" then
			SudreyarDecreaseTribute(context);
		end
	end
end

function SudreyarIncreaseTribute(context)
	--increase tribute
	SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 5;
	SK_TRIBUTE_SUD_BATTLE = SK_TRIBUTE_SUD_BATTLE + 5;
	output("Tribute from battle")
	if cm:model():world():whose_turn_is_it():name() == "vik_fact_sudreyar" then	
		SudreyarTributeCheck("vik_fact_sudreyar", true, false);
	end
end

function SudreyarDecreaseTribute(context)
	--decrease tribute
	SK_TRIBUTE_SUD = SK_TRIBUTE_SUD - 5;
	SK_TRIBUTE_SUD_BATTLE = SK_TRIBUTE_SUD_BATTLE - 5;
	output("Tribute from battle")
	if cm:model():world():whose_turn_is_it():name() == "vik_fact_sudreyar" then	
		SudreyarTributeCheck("vik_fact_sudreyar", true, false);
	end
end

function SudreyarTributeRecieved(context, faction)
	-- Add Tribute when receiving payments through diplomacy
	if context:faction():name() == faction and context:proposer():is_human() == false then
		local tribute = math.floor(context:amount() / 100)
		tribute = math.max(tribute, 1)
		tribute = math.min(tribute, 10)
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + tribute;
		SK_TRIBUTE_SUD_DIPLOMACY = SK_TRIBUTE_SUD_DIPLOMACY + tribute;
		if cm:model():world():whose_turn_is_it():name() == faction then
			SudreyarTributeCheck(faction, true, false);
		end
	elseif context:proposer():name() == faction then
		local tribute = math.floor(context:amount() / 100)
		tribute = math.max(tribute, 1)
		tribute = math.min(tribute, 25)
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD - tribute;
		SK_TRIBUTE_SUD_DIPLOMACY = SK_TRIBUTE_SUD_DIPLOMACY - tribute;
		if cm:model():world():whose_turn_is_it():name() == faction then
			SudreyarTributeCheck(faction, true, false);
		end
	end
	
	--context::faction() -->  faction receiving payment
	--context::Proposer() -> faction giving the money
	--context::amount() -> payment amount
end

function DilemmaChoiceMadeEvent_Sudreyar_Dilemma(context, faction)
	if cm:model():world():whose_turn_is_it():name() == faction then

		if context:dilemma() == "vik_sea_king_convert_religion_1" or context:dilemma() == "vik_sea_king_convert_religion_2" or context:dilemma() == "vik_sea_king_convert_religion_3" or context:dilemma() == "vik_sea_king_convert_religion_4"
		or context:dilemma() == "vik_sea_king_convert_religion_5" or context:dilemma() == "vik_sea_king_convert_religion_6"	then
			RemoveReligionBundle(faction)
			if context:choice() == 0 then 
			end
			if context:choice() == 1 then 
				SK_RELIGION[faction][8] = false;
				cm:trigger_incident(faction, "vik_sea_king_convert_religion_converted", true)
			end
			if context:choice() == 2 then 
				SK_RELIGION[faction][8] = false;
			end
		end
	end
end

--------------------------------------------------------------------------------
-------------------------------Culture bars-------------------------------------
--------------------------------------------------------------------------------

function SudreyarTributeCheck(faction, display, spent)
	-- Check the Tribute counter and apply effects
	SudreyarMaxTribute();
	
	local culture_mechanics_panel_tribute = find_uicomponent(cm:ui_root(), "culture_mechanics");

	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_war_fervour_turn", 100000, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_payments", SK_TRIBUTE_SUD_DIPLOMACY, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_battle", SK_TRIBUTE_SUD_BATTLE, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_sack", SK_TRIBUTE_SACK_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_raid", SK_TRIBUTE_RAID_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_technology", SK_TRIBUTE_TECH_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_events", SK_TRIBUTE_EVENT_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_expedition", SK_TRIBUTE_EXPEDITION_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_decrees", SK_TRIBUTE_DECREES_SUD, "vik_tribute", faction);
	culture_mechanics_panel_tribute:InterfaceFunction("add_culture_mechanics_breakdown_factor", "culture_decay", SK_TRIBUTE_DECAY_SUD, "vik_tribute", faction);
		
	TributeUpdateBundle(faction);
	
end

function SudreyarMaxTribute()
	if SK_TRIBUTE_SUD > 100 then
		SK_TRIBUTE_SUD = 100;
	end
	
	if SK_TRIBUTE_SUD < -10 then
		SK_TRIBUTE_SUD = -10;
	end
end

function CheckConvertDilemma(context, faction)
	
	if SK_RELIGION[faction][8] == false then
		return;
	end
	
	local region_list = cm:model():world():faction_by_key(faction):region_list(); 
	local building = 0;
	local church_building_5 = {"vik_abbey", "vik_monastery", "vik_st_ciaran", "vik_st_columbe", "vik_st_cuthbert", "vik_st_dewi", "vik_st_edmund", "vik_st_patraic", "vik_school_ros"}
	local church_building_3 = {"vik_church", "vik_embroiders", "vik_round_tower", "vik_scoan_abbey", "vik_scribes", "vik_st_brigit", "vik_st_swithun", "vik_library"}
	
	for i = 0, region_list:num_items() - 1 do	
		local current_region = region_list:item_at(i);
		output("current region: "..current_region:name())
		--local current_faction = current_region:owning_faction():name();
		--output("Current region: "..current_region.." is owned by : "..current_faction)
		if current_region:is_null_interface() == false then
			for i = 1, #church_building_5 do
				if current_region:building_superchain_exists(church_building_5[i]) == true then
				--5
					if church_building_5[i] == "vik_abbey" then
						output("found 5 building")
						building = building + CheckChurchBuildings(current_region, "vik_abbey", 5);
						building = building + CheckChurchBuildings(current_region, "vik_benedictine_abbey", 5);
						building = building + CheckChurchBuildings(current_region, "vik_celi_de_abbey", 5);
					else
						output("found 5 building")
						building = building + CheckChurchBuildings(current_region, church_building_5[i], 5);
					end
				end
			end
			
			for j = 1, #church_building_3 do
				if current_region:building_superchain_exists(church_building_3[j]) == true then
					 --3
					 output("found 3 building")
					 building = building + CheckChurchBuildings(current_region, church_building_3[j], 3);
				end
			end
			if current_region:building_superchain_exists("vik_high_cross") == true then
				--2
				building = building + CheckChurchBuildings(current_region, "vik_high_cross", 2);
			end
			if current_region:building_superchain_exists("vik_nunnaminster") == true then
				--1
				building = building + CheckChurchBuildings(current_region, "vik_nunnaminster", 2);
			end
		end
	end
	
	-- Add a passive increase to the score over time as Christianity passively spreads
	local turn = cm:model():turn_number();
	building = building + math.floor(turn / 10)
	
	-- Decrease the score by a small random amount to decrease predictability, whilst making sure it isn't below zero
	building = math.max((building - cm:random_number(5)), 0)
	
	output("Religious buildings: "..building)
	if building >= 1 and SK_RELIGION[faction][1] == false then
		SK_RELIGION[faction][1] = true;
		cm:trigger_incident(faction, "vik_sea_king_convert_religion_intro", true)
	elseif building >= 5 and SK_RELIGION[faction][2] == false then
		SK_RELIGION[faction][2] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_1", true);
	elseif building >= 15 and SK_RELIGION[faction][3] == false then
		SK_RELIGION[faction][3] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_2", true);
	elseif building >= 30 and SK_RELIGION[faction][4] == false then
		SK_RELIGION[faction][4] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_3", true);
	elseif building >= 50 and SK_RELIGION[faction][5] == false then
		SK_RELIGION[faction][5] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_4", true);
	elseif building >= 75 and SK_RELIGION[faction][6] == false then	
		SK_RELIGION[faction][6] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_5", true);
	elseif building >= 105 and SK_RELIGION[faction][7] == false then
		SK_RELIGION[faction][7] = true;
		cm:trigger_dilemma(faction, "vik_sea_king_convert_religion_6", true);
	end
	
end

function CheckChurchBuildings(region, building, total)
	local amount_buildings = 0;
	
	for i = 1, total do 
		if region:building_exists(building.."_"..i) == true then
			amount_buildings = amount_buildings + i;
			output("found building")
		end
	end
	
	return amount_buildings;
end

function ApplyReligionBundle(faction)
	
	RemoveReligionBundle(faction);

	if SK_RELIGION[faction][8] == true then
		local i = 1;
		repeat
			i = i + 1;
			output("Applying bundles: "..i)
		until (SK_RELIGION[faction][i] ~= true or i == 8)
		i = i - 2;
		cm:apply_effect_bundle("vik_pagan_kings_"..i, faction, 0);
	end
end

function RemoveReligionBundle(faction)
	for i = 0, 6 do 
		cm:remove_effect_bundle("vik_pagan_kings_"..i, faction);
	end
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		S_SACK_MISSION = cm:load_value("S_SACK_MISSION", 0, context);
		S_MISSION_TURN = cm:load_value("S_MISSION_TURN", 5, context);
		S_BLOCKADE_MISSION = cm:load_value("S_BLOCKADE_MISSION", 0, context);
		SK_TRIBUTE_SUD = cm:load_value("SK_TRIBUTE_SUD", 5, context);
		SK_TRIBUTE_LAST_TURN_SUD = cm:load_value("SK_TRIBUTE_LAST_TURN_SUD", 5, context);
		SK_TRIBUTE_LEVEL_SUD = cm:load_value("SK_TRIBUTE_LEVEL_SUD", 5, context);
		SK_TRIBUTE_SUD_BATTLE = cm:load_value("SK_TRIBUTE_SUD_BATTLE", 5, context);
		SK_TRIBUTE_SUD_DIPLOMACY = cm:load_value("SK_TRIBUTE_SUD_DIPLOMACY", 0, context);
		S_MISSION_ACTIVE = cm:load_value("S_MISSION_ACTIVE", false, context);
		S_RAID_ENEMY = cm:load_value("S_RAID_ENEMY", false, context);
		S_FIGHT_ENEMY = cm:load_value("S_FIGHT_ENEMY", false, context);
		SK_TRIBUTE_TECH_SUD = cm:load_value("SK_TRIBUTE_TECH_SUD", 0, context);
		SUD_TECH_TRADE = cm:load_value("SUD_TECH_TRADE", false, context);
		SK_TRIBUTE_EVENT_SUD = cm:load_value("SK_TRIBUTE_EVENT_SUD", 0, context);
		SK_TRIBUTE_DECAY_SUD = cm:load_value("SK_TRIBUTE_DECAY_SUD", 0, context);
		SK_RELIGION = cm:load_value("SK_RELIGION", SK_RELIGION, context);
		SK_TRIBUTE_EXPEDITION_SUD = cm:load_value("SK_TRIBUTE_EXPEDITION_SUD", 0, context);
		SK_TRIBUTE_DECREES_SUD = cm:load_value("SK_TRIBUTE_DECREES_SUD", 0, context);
		SK_TRIBUTE_SACK_SUD = cm:load_value("SK_TRIBUTE_SACK_SUD", 0, context);
		SK_TRIBUTE_RAID_SUD = cm:load_value("SK_TRIBUTE_RAID_SUD", 0, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("S_SACK_MISSION", S_SACK_MISSION, context);
		cm:save_value("S_MISSION_TURN", S_MISSION_TURN, context);
		cm:save_value("S_BLOCKADE_MISSION", S_BLOCKADE_MISSION, context);
		cm:save_value("SK_TRIBUTE_SUD", SK_TRIBUTE_SUD, context);
		cm:save_value("SK_TRIBUTE_LAST_TURN_SUD", SK_TRIBUTE_LAST_TURN_SUD, context);
		cm:save_value("SK_TRIBUTE_LEVEL_SUD", SK_TRIBUTE_LEVEL_SUD, context);
		cm:save_value("SK_TRIBUTE_SUD_BATTLE", SK_TRIBUTE_SUD_BATTLE, context);
		cm:save_value("SK_TRIBUTE_SUD_DIPLOMACY", SK_TRIBUTE_SUD_DIPLOMACY, context);
		cm:save_value("S_MISSION_ACTIVE", S_MISSION_ACTIVE, context);
		cm:save_value("S_RAID_ENEMY", S_RAID_ENEMY, context);
		cm:save_value("S_FIGHT_ENEMY", S_FIGHT_ENEMY, context);
		cm:save_value("SK_TRIBUTE_TECH_SUD", SK_TRIBUTE_TECH_SUD, context);
		cm:save_value("SUD_TECH_TRADE", SUD_TECH_TRADE, context);
		cm:save_value("SK_TRIBUTE_EVENT_SUD", SK_TRIBUTE_EVENT_SUD, context);
		cm:save_value("SK_TRIBUTE_DECAY_SUD", SK_TRIBUTE_DECAY_SUD, context);
		cm:save_value("SK_RELIGION", SK_RELIGION, context);
		cm:save_value("SK_TRIBUTE_EXPEDITION_SUD", SK_TRIBUTE_EXPEDITION_SUD, context);
		cm:save_value("SK_TRIBUTE_DECREES_SUD", SK_TRIBUTE_DECREES_SUD, context);
		cm:save_value("SK_TRIBUTE_SACK_SUD", SK_TRIBUTE_SACK_SUD, context);
		cm:save_value("SK_TRIBUTE_RAID_SUD", SK_TRIBUTE_RAID_SUD, context);
	end
);