-------------------------------------------------------------------------------
------------------------- FACTION EVENTS --------------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 23/11/2017 ------------------------
------------------------- Last Updated: 21/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Used for initialising the bundle replacements. This lets us have long descriptions in the front end, and short ones in game.
EVENTS_BUNDLES_UPDATED = false;
ALLEGIANCE_UPDATE2 = false;

-- Used to track settlements that have been sacked. Stops an exploit from sacking settlements repeatedly for culture points.
SACKED_SETTLEMENTS = {}

function Add_Faction_Events_Listeners()

	if cm:model():is_multiplayer() == false then 
		output("#### Adding Events Listeners ####")
		cm:add_listener(
			"FactionTurnStart_Events",
			"FactionTurnStart",
			true,
			function(context) EventsCurrentFaction(context) end,
			true
		);
		cm:add_listener(
			"FactionDestroyed_Events",
			"FactionDestroyed",
			true,
			function() EventsFactionCheck(false) end,
			true
		);
		cm:add_listener(
			"RegionChangesOwnership_Events",
			"RegionChangesOwnership",
			true,
			function(context) EventsRegionChangesOwnership(context) end,
			true
		);
		cm:add_listener(
			"DilemmaChoiceMadeEvent_Events",
			"DilemmaChoiceMadeEvent",
			true,
			function(context) EventsDilemmas(context) end,
			true
		);
		cm:add_listener(
			"FactionSubjugatesOtherFaction_Events",
			"FactionSubjugatesOtherFaction",
			true,
			function() EventsFactionCheck(false) end,
			true
		);
		cm:add_listener(
			"MissionSucceeded_Events",
			"MissionSucceeded",
			true,
			function(context) EventsMissions(context) end,
			true
		);
		cm:add_listener(
			"MissionFailed_Events",
			"MissionFailed",
			true,
			function(context) EventsMissions(context) end,
			true
		);
		cm:add_listener(
			"MissionCancelled_Events",
			"MissionCancelled",
			true,
			function(context) EventsMissions(context) end,
			true
		);
		if cm:model():world():faction_by_key("vik_fact_gwined"):is_human() == true and EVENTS_GWINED_SEA_KINGS < 4 then
			cm:add_listener(
				"LandTradeRouteRaided_Gwined",
				"LandTradeRouteRaided",
				function(context) return context:character():faction():name() == "vik_fact_dyflin" or context:character():faction():name() == "vik_fact_sudreyar" end,
				function(context) GwinedSeaKingRaidCheck() end,
				true
			);
			cm:add_listener(
				"SeaTradeRouteRaidedGwined",
				"SeaTradeRouteRaided",
				function(context) return context:character():faction():name() == "vik_fact_dyflin" or context:character():faction():name() == "vik_fact_sudreyar" end,
				function(context) GwinedSeaKingRaidCheck() end,
				true
			);
		end
		if cm:model():turn_number() < 21 then
			cm:add_listener(
				"FactionTurnEndTreaty",
				"FactionTurnEnd",
				function(context) return cm:model():turn_number() < 21 and (context:faction():name() == "vik_fact_west_seaxe" or context:faction():name() == "vik_fact_east_engle") end,
				function(context) TreatyOfAlfredAndGuthrumTurnEnd(context) end,
				true
			);
		end
	end
	
	if EVENTS_BUNDLES_UPDATED == false then
		ALLEGIANCE_UPDATE2 = true
		EVENTS_BUNDLES_UPDATED = true
		TreatyOfAlfredAndGuthrum("vik_fact_west_seaxe", false)
		TreatyOfAlfredAndGuthrum("vik_fact_east_engle", false)
		if cm:model():world():faction_by_key("vik_fact_circenn"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_circenn", cm:model():world():faction_by_key("vik_fact_circenn"):name())
			cm:remove_effect_bundle("vik_faction_trait_gael", cm:model():world():faction_by_key("vik_fact_circenn"):name())
			cm:apply_effect_bundle("vik_faction_trait_circenn_campaign", cm:model():world():faction_by_key("vik_fact_circenn"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_dyflin", cm:model():world():faction_by_key("vik_fact_dyflin"):name())
			cm:remove_effect_bundle("vik_faction_trait_viking_sea_kings", cm:model():world():faction_by_key("vik_fact_dyflin"):name())
			cm:apply_effect_bundle("vik_faction_trait_dyflin_campaign", cm:model():world():faction_by_key("vik_fact_dyflin"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_east_engle", cm:model():world():faction_by_key("vik_fact_east_engle"):name())
			cm:remove_effect_bundle("vik_faction_trait_great_viking_army", cm:model():world():faction_by_key("vik_fact_east_engle"):name())
			cm:apply_effect_bundle("vik_faction_trait_east_engle_campaign", cm:model():world():faction_by_key("vik_fact_east_engle"):name(), 0)

		end
		if cm:model():world():faction_by_key("vik_fact_gwined"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_gwined", cm:model():world():faction_by_key("vik_fact_gwined"):name())
			cm:remove_effect_bundle("vik_faction_trait_welsh", cm:model():world():faction_by_key("vik_fact_gwined"):name())
			cm:apply_effect_bundle("vik_faction_trait_gwined_campaign", cm:model():world():faction_by_key("vik_fact_gwined"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_mide"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_mide", cm:model():world():faction_by_key("vik_fact_mide"):name())
			cm:remove_effect_bundle("vik_faction_trait_gael", cm:model():world():faction_by_key("vik_fact_mide"):name())
			cm:apply_effect_bundle("vik_faction_trait_mide_campaign", cm:model():world():faction_by_key("vik_fact_mide"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_mierce", cm:model():world():faction_by_key("vik_fact_mierce"):name())
			cm:remove_effect_bundle("vik_faction_trait_english", cm:model():world():faction_by_key("vik_fact_mierce"):name())
			cm:apply_effect_bundle("vik_faction_trait_mierce_campaign", cm:model():world():faction_by_key("vik_fact_mierce"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_northymbre", cm:model():world():faction_by_key("vik_fact_northymbre"):name())
			cm:remove_effect_bundle("vik_faction_trait_great_viking_army", cm:model():world():faction_by_key("vik_fact_northymbre"):name())
			cm:apply_effect_bundle("vik_faction_trait_northymbre_campaign", cm:model():world():faction_by_key("vik_fact_northymbre"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_strat_clut", cm:model():world():faction_by_key("vik_fact_strat_clut"):name())
			cm:remove_effect_bundle("vik_faction_trait_welsh", cm:model():world():faction_by_key("vik_fact_strat_clut"):name())
			cm:apply_effect_bundle("vik_faction_trait_strat_clut_campaign", cm:model():world():faction_by_key("vik_fact_strat_clut"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_sudreyar", cm:model():world():faction_by_key("vik_fact_sudreyar"):name())
			cm:remove_effect_bundle("vik_faction_trait_viking_sea_kings", cm:model():world():faction_by_key("vik_fact_sudreyar"):name())
			cm:apply_effect_bundle("vik_faction_trait_sudreyar_campaign", cm:model():world():faction_by_key("vik_fact_sudreyar"):name(), 0)
		end
		if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true then
			cm:remove_effect_bundle("vik_faction_trait_west_seaxe", cm:model():world():faction_by_key("vik_fact_west_seaxe"):name())
			cm:remove_effect_bundle("vik_faction_trait_english", cm:model():world():faction_by_key("vik_fact_west_seaxe"):name())
			cm:apply_effect_bundle("vik_faction_trait_west_seaxe_campaign", cm:model():world():faction_by_key("vik_fact_west_seaxe"):name(), 0)
		end
		cm:apply_effect_bundle("vik_treaty_alfred_guthrum_west_seaxe", cm:model():world():faction_by_key("vik_fact_west_seaxe"):name(), 20)
		cm:apply_effect_bundle("vik_treaty_alfred_guthrum_east_engle", cm:model():world():faction_by_key("vik_fact_east_engle"):name(), 20)	
	end

	if ALLEGIANCE_UPDATE2 ~= true then
		for i = 0, cm:model():world():faction_list():num_items() - 1 do
			local faction = cm:model():world():faction_list():item_at(i):name();
			for j = 1, #OLDBUNDLES do
				cm:remove_effect_bundle(OLDBUNDLES[j], faction);
			end
		end
		TriggerIncidentMPSafe("vik_allegiance_update");
		ALLEGIANCE_UPDATE2 = true
	end

end

function TreatyOfAlfredAndGuthrumTurnEnd(context)

	if cm:model():world():faction_by_key("vik_fact_east_engle"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
		TreatyOfAlfredAndGuthrum("vik_fact_east_engle", true)
		TreatyOfAlfredAndGuthrum("vik_fact_west_seaxe", true)
		return;	
	else
		local faction2 = "";
		if context:faction():name() == "vik_fact_west_seaxe" then
			faction2 = "vik_fact_east_engle";
		else
			faction2 = "vik_fact_west_seaxe";
		end
		local military_list = context:faction():military_force_list();
		for i = 0, military_list:num_items() - 1 do
			if military_list:item_at(i):upkeep() > 0 then
				local region = military_list:item_at(i):general_character():region();
				if region ~= nil and region:is_null_interface() == false and (region:owning_faction():name() == faction2 or region:owning_faction():is_vassal_of(get_faction(faction2))) then
					TreatyOfAlfredAndGuthrum(faction2, true)
					return;
				end
			end
		end
	end
	
end

function TreatyOfAlfredAndGuthrum(faction, enable)

	if faction == "vik_fact_west_seaxe" then
		cm:force_diplomacy("vik_fact_west_seaxe", "vik_fact_east_engle", "war", enable, enable);
		cm:force_diplomacy("vik_fact_west_seaxe", "vik_fact_grantebru", "war", enable, enable);
		if enable then
			cm:remove_effect_bundle("vik_treaty_alfred_guthrum_west_seaxe", cm:model():world():faction_by_key("vik_fact_west_seaxe"):name());
		end
	end
	if faction == "vik_fact_east_engle" then
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_west_seaxe", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_cerneu", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_defena", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_suth_seaxe", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_cent", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_gliwissig", "war", enable, enable);
		cm:force_diplomacy("vik_fact_east_engle", "vik_fact_gwent", "war", enable, enable);
		if enable then
			cm:remove_effect_bundle("vik_treaty_alfred_guthrum_east_engle", cm:model():world():faction_by_key("vik_fact_east_engle"):name());
		end
	end	

end


function EventsCurrentFaction(context)

	SACKED_SETTLEMENTS = {}
	EventsFactionCheck(true)

end

function EventsFactionCheck(newturn)

	local turn = cm:model():turn_number();
	
	if turn == 21 then
		TreatyOfAlfredAndGuthrum("vik_fact_west_seaxe", true)
		TreatyOfAlfredAndGuthrum("vik_fact_east_engle", true)
	end
	
	if cm:model():world():whose_turn_is_it():name() == "vik_fact_west_seaxe" and cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
		EventsWestSeaxe(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_mierce" and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
		EventsMierce(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_dyflin" and cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
		EventsDyflin(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
		EventsSudreyar(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_east_engle" and cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() then
		EventsEastEngle(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_northymbre" and cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() then
		EventsNorthymbre(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_gwined" and cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
		EventsGwined(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_strat_clut" and cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
		EventsStratClut(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_mide" and cm:model():world():faction_by_key("vik_fact_mide"):is_human() then
		EventsMide(turn, newturn)
	elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_circenn" and cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
		EventsCircenn(turn, newturn)
    elseif cm:model():world():whose_turn_is_it():name() == "vik_fact_northleode" and cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
		EventsNorthleode(turn, newturn)
	end
end

function EventsDilemmas(context)

	local turn = cm:model():turn_number();
	
	if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
		EventsDilemmasWestSeaxe(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
		EventsDilemmasMierce(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
		EventsDilemmasDyflin(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
		EventsDilemmasSudreyar(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
		EventsDilemmasGwined(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
		EventsDilemmasStratClut(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_mide"):is_human() then
		EventsDilemmasMide(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
		EventsDilemmasCircenn(context, turn)
    elseif cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
		EventsDilemmasNorthleode(context, turn)
	end
	
end

function EventsMissions(context) 

	local turn = cm:model():turn_number();
	
	if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
		EventsMissionsWestSeaxe(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
		EventsMissionsMierce(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
		EventsMissionsDyflin(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
		EventsMissionsSudreyar(context)
	elseif cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() then
		EventsMissionsEastEngle(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() then
		EventsMissionsNorthymbre(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
		EventsMissionsGwined(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
		EventsMissionsStratClut(context, turn)
	elseif cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
		EventsMissionsCircenn(context, turn)
    elseif cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
		EventsMissionsNorthleode(context, turn)
	end
	
end

function EventsRegionChangesOwnership(context)
	
	if cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() and EVENTS_DYFLIN_LONGPHORTS == 0 then
		EventsDyflinLongphorts(context)
	end
	
	EventsFactionCheck(false)
	
end


-----------------------
-- West Seaxe Events --
-----------------------

EVENTS_WEST_SEAXE_MIERCE = 0;
EVENTS_WEST_SEAXE_MIERCE_VASSAL = 0
EVENTS_WEST_SEAXE_EAST_ENGLE = 0;
EVENTS_WEST_SEAXE_CERNEU = 0;
EVENTS_WEST_SEAXE_GWENT = 0;
EVENTS_WEST_SEAXE_GLIWISSIG = 0;

function EventsWestSeaxe(turn, newturn) 

	--Conquer East Engle. Triggers on turn 3 or after da rebels
	if EVENTS_WEST_SEAXE_EAST_ENGLE == 0 and (turn >= 21 or get_faction("vik_fact_west_seaxe"):at_war_with(get_faction("vik_fact_east_engle"))) and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_east_engle"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == false then
			EVENTS_WEST_SEAXE_EAST_ENGLE = 20;
			SetFactionsHostile("vik_fact_east_engle", "vik_fact_west_seaxe");
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_east_engle", true);
		else
			EVENTS_WEST_SEAXE_EAST_ENGLE = 30;
		end
	elseif EVENTS_WEST_SEAXE_EAST_ENGLE == 20 then
		if cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_east_engle"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_EAST_ENGLE = 30;
			SetFactionsNeutral("vik_fact_east_engle", "vik_fact_west_seaxe");
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_east_engle", true);
		end
	end
	
	--The King of Mierce is dead! Long live our King!
	if EVENTS_WEST_SEAXE_MIERCE == 0 and newturn == true and turn >= 11 and cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == false then 
		if cm:model():random_percent(turn / 5) == true then
			local mierce = cm:model():world():faction_by_key("vik_fact_mierce")
			cm:kill_character("character_cqi:"..mierce:faction_leader():command_queue_index(), false, true);
			cm:trigger_dilemma("vik_fact_west_seaxe", "vik_fact_west_seaxe_mierce_king_dead", false);
		end
	elseif EVENTS_WEST_SEAXE_MIERCE < 20 and cm:model():world():faction_by_key("vik_fact_mierce"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
		EVENTS_WEST_SEAXE_MIERCE = 20
	elseif EVENTS_WEST_SEAXE_MIERCE == 20 then
		if cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_MIERCE = 30
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_mierce", true);
		elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true then
			EVENTS_WEST_SEAXE_MIERCE = 40
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_mierce", true);
		end		
	elseif EVENTS_WEST_SEAXE_MIERCE < 30 and cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
		-- Mierce is a vassal and the rest of the script missed it, set the event flag
		EVENTS_WEST_SEAXE_MIERCE = 30
	end
	
	-- Option to annex Mierce after having them as a vassal for 50 turns
	if EVENTS_WEST_SEAXE_MIERCE < 40 and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_MIERCE_VASSAL = EVENTS_WEST_SEAXE_MIERCE_VASSAL + 1
			if EVENTS_WEST_SEAXE_MIERCE_VASSAL >= 50 then
				cm:trigger_dilemma("vik_fact_west_seaxe", "vik_fact_west_seaxe_mierce_annex", false);
			end
		elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true then
			EVENTS_WEST_SEAXE_MIERCE = 40
			EVENTS_WEST_SEAXE_MIERCE_VASSAL = 0
		else
			EVENTS_WEST_SEAXE_MIERCE_VASSAL = 0
		end
	end
	
	-- Welsh vassal rebellions - Cerneu
	if EVENTS_WEST_SEAXE_CERNEU == 0 and newturn == true then 
		if cm:model():world():faction_by_key("vik_fact_cerneu"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true and cm:model():random_percent(turn/10) == true then
			EVENTS_WEST_SEAXE_CERNEU = 10;
			SetFactionsHostile("vik_fact_cerneu", "vik_fact_west_seaxe");
			cm:force_declare_war("vik_fact_cerneu", "vik_fact_west_seaxe");
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_cerneu", true);
		elseif cm:model():world():faction_by_key("vik_fact_cerneu"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_CERNEU = 10;
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_cerneu", true);
		end
	elseif EVENTS_WEST_SEAXE_CERNEU == 10 then
		if cm:model():world():faction_by_key("vik_fact_cerneu"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_cerneu"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then 
			EVENTS_WEST_SEAXE_CERNEU = 20;
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_cerneu", true);
		end
	end
	
	-- Welsh vassal rebellions - Gwent
	if EVENTS_WEST_SEAXE_GWENT == 0 and newturn == true then 
		if cm:model():world():faction_by_key("vik_fact_gwent"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true and cm:model():random_percent(turn/10) == true then
			EVENTS_WEST_SEAXE_GWENT = 10;
			SetFactionsHostile("vik_fact_gwent", "vik_fact_west_seaxe");
			cm:force_declare_war("vik_fact_gwent", "vik_fact_west_seaxe");
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_gwent", true);
		elseif cm:model():world():faction_by_key("vik_fact_gwent"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_GWENT = 10;
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_gwent", true);
		end
	elseif EVENTS_WEST_SEAXE_GWENT == 10 then
		if cm:model():world():faction_by_key("vik_fact_gwent"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_gwent"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then 
			EVENTS_WEST_SEAXE_GWENT = 20;
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_gwent", true);
		end
	end
	
	-- Welsh vassal rebellions - Gliwissig
	if EVENTS_WEST_SEAXE_GLIWISSIG == 0 and newturn == true then 
		if cm:model():world():faction_by_key("vik_fact_gliwissig"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true and cm:model():random_percent(turn/10) == true then
			EVENTS_WEST_SEAXE_GLIWISSIG = 10;
			SetFactionsHostile("vik_fact_gliwissig", "vik_fact_west_seaxe");
			cm:force_declare_war("vik_fact_gliwissig", "vik_fact_west_seaxe");
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_gliwissig", true);
		elseif cm:model():world():faction_by_key("vik_fact_gliwissig"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_WEST_SEAXE_GLIWISSIG = 10;
			cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_gliwissig", true);
		end
	elseif EVENTS_WEST_SEAXE_GLIWISSIG == 10 then
		if cm:model():world():faction_by_key("vik_fact_gliwissig"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_gliwissig"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then 
			EVENTS_WEST_SEAXE_GLIWISSIG = 20;
			cm:override_mission_succeeded_status("vik_fact_west_seaxe", "vik_mission_west_seaxe_gliwissig", true);
		end
	end

end

function EventsMissionsWestSeaxe(context, turn)

end

function EventsDilemmasWestSeaxe(context, turn)

	-- Annex Mierce if they have been a vassal for 50+ turns
	if context:dilemma() == "vik_fact_west_seaxe_mierce_annex" then
		EVENTS_WEST_SEAXE_MIERCE = 40
		if context:choice() == 0 then
			cm:grant_faction_handover("vik_fact_west_seaxe", "vik_fact_mierce", turn-1, turn-1, context);
		end
	end
	
	if context:dilemma() == "vik_fact_west_seaxe_mierce_king_dead" then
		if context:choice() == 0 then
			local west_seaxe_influence = cm:model():world():faction_by_key("vik_fact_west_seaxe"):faction_leader():gravitas()
			local mierce_influence = cm:model():world():faction_by_key("vik_fact_mierce"):faction_leader():gravitas()
			if difficulty == 1 then -- Easy
				west_seaxe_influence = west_seaxe_influence + 2
			elseif difficulty == 0 then -- Normal
				west_seaxe_influence = west_seaxe_influence
			elseif difficulty == -1 then -- Hard
				west_seaxe_influence = west_seaxe_influence - 2
			elseif difficulty == -2 then -- Very Hard
				west_seaxe_influence = west_seaxe_influence - 4
			elseif difficulty == -3 then -- Legendary
				west_seaxe_influence = west_seaxe_influence - 6
			end
			local chancemod = (cm:model():world():faction_by_key("vik_fact_west_seaxe"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_mierce"):region_list():num_items() + west_seaxe_influence - mierce_influence) * 5
			chancemod = math.max(chancemod, -25);
			chancemod = math.min(chancemod, 75);
			if cm:model():random_percent(25 + chancemod) == true then
				EVENTS_WEST_SEAXE_MIERCE = 30
				cm:trigger_incident("vik_fact_west_seaxe", "vik_incident_mierce_accepts_vassal", true);
				cm:force_make_vassal("vik_fact_west_seaxe", "vik_fact_mierce");
				SetFactionsFriendly("vik_fact_west_seaxe", "vik_fact_mierce");
			else
				EVENTS_WEST_SEAXE_MIERCE = 20
				SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_mierce");
				cm:force_declare_war("vik_fact_mierce", "vik_fact_west_seaxe");
				cm:trigger_mission("vik_fact_west_seaxe", "vik_mission_west_seaxe_mierce", true);
			end
		elseif context:choice() == 1 then
			EVENTS_WEST_SEAXE_MIERCE = 10
		end
	end
	
end

-------------------
-- Mierce Events --
-------------------

EVENTS_MIERCE_WEST_SEAXE = 0;
EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER = 0;
EVENTS_MIERCE_KING_DEAD_TURN = 0;
EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER = 0;
EVENTS_MIERCE_WALES = 0;
EVENTS_MIERCE_WALES_ANGRY_TIMER = 0;
EVENTS_MIERCE_NORTHYMBRE = 0;
EVENTS_MIERCE_EAST = 0;

function EventsMierce(turn, newturn) 

	-- Eliminate Powis
	if EVENTS_MIERCE_WALES == 0 then
		if cm:model():world():faction_by_key("vik_fact_mierce"):at_war_with(cm:model():world():faction_by_key("vik_fact_powis")) == true then
			EVENTS_MIERCE_WALES = 10;
			SetFactionsHostile("vik_fact_powis", "vik_fact_mierce");
			cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_wales_1", true);
		elseif turn > 10 and newturn == true then
			EVENTS_MIERCE_WALES_ANGRY_TIMER = EVENTS_MIERCE_WALES_ANGRY_TIMER + cm:random_number(3, 1)
			if EVENTS_MIERCE_WALES_ANGRY_TIMER >= 10 then
				if IndependentAIFaction("vik_fact_powis") == true then
					EVENTS_MIERCE_WALES = 10;
					SetFactionsHostile("vik_fact_powis", "vik_fact_mierce");
					cm:force_declare_war("vik_fact_powis", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_wales_1", true);
				else
					EVENTS_MIERCE_WALES = 20;
				end
			end
		end
	elseif EVENTS_MIERCE_WALES == 10 and cm:model():world():faction_by_key("vik_fact_powis"):is_dead() == true and Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) then
		EVENTS_MIERCE_WALES = 20;
		cm:override_mission_succeeded_status("vik_fact_mierce", "vik_fact_miercna_mission_wales_1", true);
	end
	
	-- Eliminate Northymbre
	if EVENTS_MIERCE_NORTHYMBRE == 10 and cm:model():world():faction_by_key("vik_fact_northymbre"):is_dead() == true then
		EVENTS_MIERCE_NORTHYMBRE = 20;
		cm:override_mission_succeeded_status("vik_fact_mierce", "vik_fact_miercna_mission_north_all", true);
	end
	
	-- Fitey fite the East Vikings
	if EVENTS_MIERCE_EAST == 0 and newturn == true and turn >= 20 and (cm:model():random_percent(5) or cm:model():world():region_manager():region_by_key("vik_reg_northhamtun"):owning_faction():name() == "vik_fact_mierce" or cm:model():world():region_manager():region_by_key("vik_reg_snotingaham"):owning_faction():name() == "vik_fact_mierce") then
		EVENTS_MIERCE_EAST = 10;
		cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_east_war", true);
	elseif EVENTS_MIERCE_EAST == 10 and cm:model():world():region_manager():region_by_key("vik_reg_northhamtun"):owning_faction():name() == "vik_fact_mierce" and cm:model():world():region_manager():region_by_key("vik_reg_snotingaham"):owning_faction():name() == "vik_fact_mierce" then
		EVENTS_MIERCE_EAST = 20;
		cm:override_mission_succeeded_status("vik_fact_mierce", "vik_fact_miercna_mission_east_war", true);	
	elseif EVENTS_MIERCE_EAST == 20 and cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == true then
		EVENTS_MIERCE_EAST = 30;
		cm:override_mission_succeeded_status("vik_fact_mierce", "vik_fact_miercna_mission_east_war_2", true);
	end
		
	-- War breaks out between West Seaxe and Mierce
	if EVENTS_MIERCE_WEST_SEAXE == 19 and newturn == true then
		EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER = EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER + cm:random_number(2, 1)
		if EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER >= 10 then
			EVENTS_MIERCE_WEST_SEAXE = 20;
			SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_mierce");
			cm:force_declare_war("vik_fact_west_seaxe", "vik_fact_mierce");
		end
	end
	
	if EVENTS_MIERCE_WEST_SEAXE < 21 and cm:model():world():faction_by_key("vik_fact_mierce"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true and newturn == true then
		EVENTS_MIERCE_WEST_SEAXE = 21;
		cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_westsexa", true);
	elseif EVENTS_MIERCE_WEST_SEAXE == 21 or EVENTS_MIERCE_WEST_SEAXE == 22 then
		if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_mierce")) == true then 
			EVENTS_MIERCE_WEST_SEAXE = 40;
			cm:override_mission_succeeded_status("vik_fact_mierce", "vik_fact_miercna_mission_westsexa", true);
			SetFactionsNeutral("vik_fact_mierce", "vik_fact_west_seaxe");
		elseif cm:model():world():faction_by_key("vik_fact_west_seaxe"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == false then 
			EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER = 0
		elseif EVENTS_MIERCE_WEST_SEAXE == 21 and newturn == true then
			EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER = EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER + 1;
			if EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER > 20 == true then
				local west_seaxe_influence = get_faction("vik_fact_west_seaxe"):faction_leader():gravitas();
				local mierce_influence = get_faction("vik_fact_mierce"):faction_leader():gravitas();
				local strength = (cm:model():world():faction_by_key("vik_fact_mierce"):region_list():num_items() + mierce_influence - cm:model():world():faction_by_key("vik_fact_west_seaxe"):region_list():num_items() - west_seaxe_influence);
				if strength >= 5 then
					EVENTS_MIERCE_WEST_SEAXE = 22;
					cm:trigger_dilemma("vik_fact_mierce", "vik_fact_mierce_dilemma_westsexa_capitulates", false);
				elseif strength <= -5 then
					EVENTS_MIERCE_WEST_SEAXE = 22;
					cm:trigger_dilemma("vik_fact_mierce", "vik_fact_mierce_dilemma_westsexa_demands_surrender", false);
				end
			end
		end
	end		

	--The King of Mierce is dead! Long live our King!
	if EVENTS_MIERCE_KING_DEAD_TURN == 0 and newturn == true then
		if get_faction("vik_fact_mierce"):faction_leader():has_trait("vik_scripted_trait_ceolwulf") == false then
		EVENTS_MIERCE_KING_DEAD_TURN = turn;
		elseif turn > 10 and cm:model():random_percent(5 - (get_faction("vik_fact_mierce"):faction_leader():gravitas() - 5)) then
			cm:kill_character("character_cqi:"..get_faction("vik_fact_mierce"):faction_leader():command_queue_index(), false, true);
		end
	elseif newturn == true and (turn + 2) >= EVENTS_MIERCE_KING_DEAD_TURN and EVENTS_MIERCE_WEST_SEAXE == 0 then
		if IndependentAIFaction("vik_fact_west_seaxe") then
			EVENTS_MIERCE_WEST_SEAXE = 10;
			cm:trigger_dilemma("vik_fact_mierce", "vik_fact_mierce_dilemma_king_dies", false);
		else
			EVENTS_MIERCE_WEST_SEAXE = 21;
		end
	end
	
end

function EventsMissionsMierce(context, turn)

	-- East Mierce > East Engle
	if context:mission():mission_record_key() == "vik_fact_miercna_mission_east_war" then
		if IndependentAIFaction("vik_fact_east_engle") then
			cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_east_war_2", true);
			EVENTS_MIERCE_EAST = 20;
		else
			EVENTS_MIERCE_EAST = 30;
		end
	end
	
	-- Mameceaster > Northymbre
	if context:mission():mission_record_key() == "vik_fact_miercna_mission_north_mameceaster" then
		if IndependentAIFaction("vik_fact_northymbre") then
			cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_north_all", true);
			EVENTS_MIERCE_NORTHYMBRE = 10;
		else
			EVENTS_MIERCE_NORTHYMBRE = 20;
		end
	end
	
	-- Defeat Rebels > Mameceaster or Northymbre
	if context:mission():mission_record_key() == "vik_starting_rebels" then
		if cm:model():world():region_manager():region_by_key("vik_reg_mameceaster"):owning_faction():name() ~= "vik_fact_mierce" then
			cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_north_mameceaster", true);
		elseif IndependentAIFaction("vik_fact_northymbre") then
			EVENTS_MIERCE_NORTHYMBRE = 10;
			cm:trigger_mission("vik_fact_mierce", "vik_fact_miercna_mission_north_all", true);
		else 
			EVENTS_MIERCE_NORTHYMBRE = 20;
		end		
	end

end

function EventsDilemmasMierce(context, turn)

	-- Annex West Seaxe if they have been a vassal for 50+ turns
	if context:dilemma() == "vik_fact_mierce_annex_west_seaxe" then
		EVENTS_MIERCE_WEST_SEAXE = 40;
		if context:choice() == 0 then
			cm:grant_faction_handover("vik_fact_mierce", "vik_fact_west_seaxe", turn-1, turn-1, context);
		end
	end
	
	-- West Seaxe capitulates
	if context:dilemma() == "vik_fact_mierce_dilemma_westsexa_capitulates" then
		if context:choice() == 0 then
			EVENTS_MIERCE_WEST_SEAXE = 40;
			cm:trigger_incident("vik_fact_mierce", "vik_incident_west_seaxe_accepts_vassal", true);
			cm:force_make_vassal("vik_fact_mierce", "vik_fact_west_seaxe");
			SetFactionsFriendly("vik_fact_mierce", "vik_fact_west_seaxe");
		end
	end
	
	-- West Seaxe demands surrender
	if context:dilemma() == "vik_fact_mierce_dilemma_westsexa_demands_surrender" then
		if context:choice() == 0 then
			EVENTS_MIERCE_WEST_SEAXE = 22;
		end
	end
	
	-- Ceolwulf be deaded ;_;
	if context:dilemma() == "vik_fact_mierce_dilemma_king_dies" then
		if context:choice() == 0 then
			EVENTS_MIERCE_WEST_SEAXE = 13;
			cm:force_make_vassal("vik_fact_west_seaxe", "vik_fact_mierce");
		elseif context:choice() == 1 then
			EVENTS_MIERCE_WEST_SEAXE = 19;
			SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_mierce");
			local x = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_x();
			local y = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_y();
			cm:trigger_incident_with_location("vik_fact_mierce", "vik_fact_mierce_incident_king_dies_westsexa_angry", true, x, y);
		elseif context:choice() == 2 then
			local west_seaxe_influence = get_faction("vik_fact_west_seaxe"):faction_leader():gravitas();
			local mierce_influence = get_faction("vik_fact_mierce"):faction_leader():gravitas();
			if difficulty == 1 then -- Easy
				mierce_influence = king_influence + 2;
			elseif difficulty == 0 then -- Normal
				mierce_influence = king_influence;
			elseif difficulty == -1 then -- Hard
				mierce_influence = king_influence - 2;
			elseif difficulty == -2 then -- Very Hard
				mierce_influence = king_influence - 4;
			elseif difficulty == -3 then -- Legendary
				mierce_influence = king_influence - 6;
			end
			local strength = (cm:model():world():faction_by_key("vik_fact_mierce"):region_list():num_items() + mierce_influence - cm:model():world():faction_by_key("vik_fact_west_seaxe"):region_list():num_items() - west_seaxe_influence);
			strength = math.max(strength, 0);
			strength = math.min(strength, 20);	
			if cm:model():random_percent(0 + (strength * 5)) then
				EVENTS_MIERCE_WEST_SEAXE = 40;
				cm:force_make_vassal("vik_fact_mierce", "vik_fact_west_seaxe");
				SetFactionsFriendly("vik_fact_west_seaxe", "vik_fact_mierce");
				local x = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_x();
				local y = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_y();
				cm:trigger_incident_with_location("vik_fact_mierce", "vik_fact_mierce_incident_king_dies_westsexa_accepts", true, x, y);
			else
				EVENTS_MIERCE_WEST_SEAXE = 19;
				EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER = 10;
				SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_mierce");
				local x = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_x();
				local y = cm:model():world():faction_by_key("vik_fact_west_seaxe"):home_region():settlement():logical_position_y();
				cm:trigger_incident_with_location("vik_fact_mierce", "vik_fact_mierce_incident_king_dies_westsexa_angry", true, x, y);
			end
		end
	end
	
end

-------------------
-- Dyflin Events --
-------------------

EVENTS_DYFLIN_BREGA = 0;
EVENTS_DYFLIN_LONGPHORTS = 0;
EVENTS_DYFLIN_MIDE = 0;
EVENTS_DYFLIN_IRISH_PORTS = 0;
EVENTS_DYFLIN_MAINLAND_PORTS = 0;


function EventsDyflin(turn, newturn) 

	-- Conquer Brega
	if EVENTS_DYFLIN_BREGA == 1 and Has_Required_Regions("vik_fact_dyflin", REGIONS_BREGA) == true then
		EVENTS_DYFLIN_BREGA = 2;
		cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_brega", true);
	end
	
	-- Conquer Mide
	if EVENTS_DYFLIN_MIDE == 0 and (cm:model():world():faction_by_key("vik_fact_mide"):region_list():num_items() >= 20 or cm:model():world():faction_by_key("vik_fact_mide"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == true or TotalVassals("vik_fact_mide") >= 5) then
		EVENTS_DYFLIN_MIDE = 10;
		SetFactionsHostile("vik_fact_dyflin", "vik_fact_mide");
		cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_conquer_midhe", false);
	elseif EVENTS_DYFLIN_MIDE == 10 and (cm:model():world():faction_by_key("vik_fact_mide"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_mide"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_dyflin")) == true) then
		EVENTS_DYFLIN_MIDE = 20;
		cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_conquer_midhe", true);
	end
	
	-- Get some mainland ports
	if EVENTS_DYFLIN_MAINLAND_PORTS == 0 and newturn == true and turn > 40 then
		if Has_Any_Required_Regions("vik_fact_dyflin", REGIONS_MAINLAND_PORTS, 3) == false then
			EVENTS_DYFLIN_MAINLAND_PORTS = 10;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_mainland_ports", false);
		else 
			EVENTS_DYFLIN_MAINLAND_PORTS = 20
		end
	elseif EVENTS_DYFLIN_MAINLAND_PORTS == 10 and Has_Any_Required_Regions("vik_fact_dyflin", REGIONS_MAINLAND_PORTS, 3) == true then
		EVENTS_DYFLIN_MIDE = 20;
		cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_mainland_ports", true);
	end
	
	-- Longphorts missions
	if EVENTS_DYFLIN_LONGPHORTS == 1 then
		if Has_Required_Regions_Vassals("vik_fact_dyflin", REGIONS_IRISH_LONGPHORTS) then
			EVENTS_DYFLIN_LONGPHORTS = 3;
			cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_longphorts_vassals", true);
		end
	elseif EVENTS_DYFLIN_LONGPHORTS == 2 then
		if Has_Required_Regions_Vassals("vik_fact_dyflin", REGIONS_IRISH_LONGPHORTS) then
			EVENTS_DYFLIN_LONGPHORTS = 3;
			cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_longphorts_conquest", true);
		end
	end
	
	-- Get all the irish ports
	-- Trigger 6/15 irish ports REGIONS_IRISH_PORTS
	if EVENTS_DYFLIN_IRISH_PORTS == 0 and newturn == true and Has_Any_Required_Regions("vik_fact_dyflin", REGIONS_IRISH_PORTS, 6) then
		if Has_Required_Regions("vik_fact_dyflin", REGIONS_IRISH_PORTS) == false then
			EVENTS_DYFLIN_IRISH_PORTS = 10;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_irish_coast", false);
		else 
			EVENTS_DYFLIN_IRISH_PORTS = 20
		end
	elseif EVENTS_DYFLIN_IRISH_PORTS == 10 and Has_Required_Regions("vik_fact_dyflin", REGIONS_IRISH_PORTS) == true then
		EVENTS_DYFLIN_MIDE = 20;
		cm:override_mission_succeeded_status("vik_fact_dyflin", "vik_fact_dyflin_mission_irish_coast", true);
	end
		
end

function EventsDyflinLongphorts(context)

	-- Attacked longphorts rally behind Dyflin... or you destroy them yourself!
	local check = false
	if (context:region():name() == "vik_reg_dyflin" or context:region():name() == "vik_reg_vedrafjordr" or context:region():name() == "vik_reg_veisafjordr" or context:region():name() == "vik_reg_casteltoun") and context:region():owning_faction():subculture() ~= "vik_sub_cult_viking_gael" then
		check = true
	end
	if check == true and cm:model():world():region_manager():region_by_key("vik_reg_dyflin"):owning_faction():name() == "vik_fact_dyflin" then
		local check2 = 0;
		if IndependentAIFaction("vik_fact_veisafjordr") == true and cm:model():world():faction_by_key("vik_fact_veisafjordr"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == false then
			check2 = check2 + 1;
		end
		if IndependentAIFaction("vik_fact_vedrafjordr") == true and cm:model():world():faction_by_key("vik_fact_vedrafjordr"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == false then
			check2 = check2 + 1;
		end
		if check2 > 0 then
			cm:trigger_dilemma("vik_fact_dyflin", "vik_fact_dyflin_dilemma_longphorts", false);
		else
			EVENTS_DYFLIN_LONGPHORTS = 2;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_longphorts_conquest", false);		
		end
	end
	
end

function EventsMissionsDyflin(context, turn)

	-- Defeat rebels > Conquer Brega
	if context:mission():mission_record_key() == "vik_starting_rebels" then
		if cm:model():world():faction_by_key("vik_fact_brega"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_brega"):is_dead() == false then
			cm:trigger_dilemma("vik_fact_dyflin", "vik_fact_dyflin_dilemma_brega", false);
		else
			EVENTS_DYFLIN_BREGA = 1;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_brega", true);
		end
	end
	
	-- Mainland ports
	if context:mission():mission_record_key() == "vik_fact_dyflin_mission_mainland_ports" then
		SK_TRIBUTE = SK_TRIBUTE + 10;
		SK_TRIBUTE_EVENT = SK_TRIBUTE_EVENT + 10;
		SeaKingTributeCheck("vik_fact_dyflin");
	end

	-- Irish ports
	if context:mission():mission_record_key() == "vik_fact_dyflin_mission_irish_coast" then
		DYFLIN_SLAVES = DYFLIN_SLAVES + 2000;
		SK_TRIBUTE = SK_TRIBUTE + 10;
		SK_TRIBUTE_EVENT = SK_TRIBUTE_EVENT + 10;
		SeaKingTributeCheck("vik_fact_dyflin");
	end	

	-- Conquer longphorts
	if context:mission():mission_record_key() == "vik_fact_dyflin_mission_longphorts_conquest" then
		DYFLIN_SLAVES = DYFLIN_SLAVES + 2000;
		SK_TRIBUTE = SK_TRIBUTE + 10;
		SK_TRIBUTE_EVENT = SK_TRIBUTE_EVENT + 10;
		SeaKingTributeCheck("vik_fact_dyflin");
	end	
	
end

function EventsDilemmasDyflin(context, turn)

	-- Fate of Brega
	if context:dilemma() == "vik_fact_dyflin_dilemma_brega" then
		if context:choice() == 0 then
			EVENTS_DYFLIN_BREGA = 2;
			cm:grant_faction_handover("vik_fact_dyflin", "vik_fact_brega", turn-1, turn-1, context);
		elseif context:choice() == 1 then
			EVENTS_DYFLIN_BREGA = 1;
			SetFactionsHostile("vik_fact_brega", "vik_fact_dyflin");
			cm:force_declare_war("vik_fact_brega", "vik_fact_dyflin");	
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_brega", true);
		end
	end
	
	-- Longphorts > Conquer/vassal
	if context:dilemma() == "vik_fact_dyflin_dilemma_longphorts" then
		if context:choice() == 0 then
			if IndependentAIFaction("vik_fact_veisafjordr") then
				SetFactionsFriendly("vik_fact_dyflin", "vik_fact_veisafjordr");
				if cm:model():world():faction_by_key("vik_fact_veisafjordr"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == false then
					cm:force_make_vassal("vik_fact_dyflin", "vik_fact_veisafjordr");
				end
			end
			if IndependentAIFaction("vik_fact_vedrafjordr") then
				SetFactionsFriendly("vik_fact_dyflin", "vik_fact_vedrafjordr");
				if cm:model():world():faction_by_key("vik_fact_vedrafjordr"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == false then
					cm:force_make_vassal("vik_fact_dyflin", "vik_fact_vedrafjordr");
				end
			end
			EVENTS_DYFLIN_LONGPHORTS = 1;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_longphorts_vassals", true);
		elseif context:choice() == 1 then
			if cm:model():world():faction_by_key("vik_fact_veisafjordr"):is_dead() == false then
				SetFactionsHostile("vik_fact_dyflin", "vik_fact_veisafjordr");
			end
			if cm:model():world():faction_by_key("vik_fact_vedrafjordr"):is_dead() == false then
				SetFactionsHostile("vik_fact_dyflin", "vik_fact_vedrafjordr");
			end
			EVENTS_DYFLIN_LONGPHORTS = 2;
			cm:trigger_mission("vik_fact_dyflin", "vik_fact_dyflin_mission_longphorts_conquest", true);
		end
	end
		
end

---------------------
-- Sudreyar Events --
---------------------

EVENTS_SUDREYAR_CIRCENN = 0;
EVENTS_SUDREYAR_DYFLIN = 0;

function EventsSudreyar(turn, newturn) 

	-- Conquer Circenn
	if EVENTS_SUDREYAR_CIRCENN == 0 then
		if cm:model():world():faction_by_key("vik_fact_sudreyar"):at_war_with(cm:model():world():faction_by_key("vik_fact_circenn")) == true then
			EVENTS_SUDREYAR_CIRCENN = 10;
			SetFactionsHostile("vik_fact_circenn", "vik_fact_sudreyar");
			cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_circenn", true);
		elseif turn > 20 and newturn == true then
			if IndependentAIFaction("vik_fact_circenn") == true then
				EVENTS_SUDREYAR_CIRCENN = 10;
				SetFactionsHostile("vik_fact_circenn", "vik_fact_sudreyar");
				cm:force_declare_war("vik_fact_circenn", "vik_fact_sudreyar");	
				cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_circenn", true);
			else
				EVENTS_SUDREYAR_CIRCENN = 20;
			end
		end
	elseif EVENTS_SUDREYAR_CIRCENN == 10 and (cm:model():world():faction_by_key("vik_fact_circenn"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_circenn"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_sudreyar")) == true) then
		EVENTS_SUDREYAR_CIRCENN = 20;
		SetFactionsNeutral("vik_fact_circenn", "vik_fact_sudreyar");
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_circenn", true);
	end

	-- Dyflin chain
	if EVENTS_SUDREYAR_DYFLIN < 21 and cm:model():world():faction_by_key("vik_fact_sudreyar"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == true then
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_alliance", false);
		cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_conquest", true);
		EVENTS_SUDREYAR_DYFLIN = 21;
	elseif cm:model():world():faction_by_key("vik_fact_dyflin"):is_dead() == true and EVENTS_SUDREYAR_DYFLIN <= 10 then
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_alliance", false);
		local dyflin_region = cm:model():world():region_manager():region_by_key("vik_reg_dyflin");
		if dyflin_region:owning_faction():name() == "vik_fact_sudreyar" then 
			EVENTS_SUDREYAR_DYFLIN = 30;
		else
			EVENTS_SUDREYAR_DYFLIN = 22;
			cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_bregh_conquest", true);
		end
	elseif EVENTS_SUDREYAR_DYFLIN == 0 and newturn == true and (turn >= 50 or cm:model():world():faction_by_key("vik_fact_sudreyar"):region_list():num_items() >= 20 or cm:model():world():faction_by_key("vik_fact_dyflin"):region_list():num_items() >= 20 or Has_Any_Required_Regions("vik_fact_sudreyar", REGIONS_IRELAND, 1)) then
		if cm:model():world():faction_by_key("vik_fact_sudreyar"):allied_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == false then 
			cm:trigger_dilemma("vik_fact_sudreyar", "vik_fact_sudreyar_dilemma_dyflin_alive", true);
		else
			EVENTS_SUDREYAR_DYFLIN = 20
		end
	elseif EVENTS_SUDREYAR_DYFLIN == 10 and cm:model():world():faction_by_key("vik_fact_sudreyar"):allied_with(cm:model():world():faction_by_key("vik_fact_dyflin")) then
		EVENTS_SUDREYAR_DYFLIN = 20;
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_alliance", true);
	elseif EVENTS_SUDREYAR_DYFLIN == 21 and cm:model():world():faction_by_key("vik_fact_dyflin"):is_dead() == true and Has_Required_Regions("vik_fact_sudreyar", REGIONS_DYFLINN_AND_CASTELTOUN) == true then
		EVENTS_SUDREYAR_DYFLIN = 30;
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_conquest", true);
	elseif EVENTS_SUDREYAR_DYFLIN == 22 and Has_Required_Regions("vik_fact_sudreyar", REGIONS_BREGA) then
		EVENTS_SUDREYAR_DYFLIN = 30;
		cm:override_mission_succeeded_status("vik_fact_sudreyar", "vik_fact_sudreyar_mission_bregh_conquest", true);
	end

end

function EventsMissionsSudreyar(context)

	-- Conquer Brega/Dyflin
	if context:mission():mission_record_key() == "vik_fact_sudreyar_mission_dyflin_conquest" or context:mission():mission_record_key() == "vik_fact_sudreyar_mission_bregh_conquest" then
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 10;
		SK_TRIBUTE_EVENT_SUD = SK_TRIBUTE_EVENT_SUD + 10;
	end
	
	if context:mission():mission_record_key() == "vik_fact_sudreyar_mission_circenn" then
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 10;
		SK_TRIBUTE_EVENT_SUD = SK_TRIBUTE_EVENT_SUD + 10;	
	end

	-- Ally Dyflin
	if context:mission():mission_record_key() == "vik_fact_sudreyar_mission_dyflin_alliance" then
		SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 5;
		SK_TRIBUTE_EVENT_SUD = SK_TRIBUTE_EVENT_SUD + 5;
	end

end

function EventsDilemmasSudreyar(context, turn)

	--Dyflin dilemma stuffs
	if context:dilemma() == "vik_fact_sudreyar_dilemma_dyflin_alive" then
		if context:choice() == 0 then
			EVENTS_SUDREYAR_DYFLIN = 10;
			cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_alliance", true);
		elseif context:choice() == 1 then
			EVENTS_SUDREYAR_DYFLIN = 21;
			cm:trigger_mission("vik_fact_sudreyar", "vik_fact_sudreyar_mission_dyflin_conquest", true);
		elseif context:choice() == 2 then
			EVENTS_SUDREYAR_DYFLIN = 20;
			SK_EXPEDITION_SUD = SK_EXPEDITION_SUD + 25;
			SK_EXPEDITION_SUD_EVENT = SK_EXPEDITION_SUD_EVENT + 25;
		end
	end
	
end

-----------------------
-- East Engle Events --
-----------------------

EVENTS_EAST_ENGLE_WICING = 0;
EVENTS_EAST_ENGLE_EAST_DANELAW = 0;
EVENTS_EAST_ENGLE_NORTHYMBRE = 0;

function EventsEastEngle(turn, newturn) 

	-- Beat up/reclaim Northymbre
	if EVENTS_EAST_ENGLE_NORTHYMBRE == 1 and cm:model():world():faction_by_key("vik_fact_northymbre"):is_dead() == true and Has_Required_Regions("vik_fact_east_engle", REGIONS_NORTHYMBRE_ALIVE) then
		EVENTS_EAST_ENGLE_NORTHYMBRE = 3;
		cm:override_mission_succeeded_status("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_alive", true);
	elseif EVENTS_EAST_ENGLE_NORTHYMBRE == 2 and Has_Required_Regions("vik_fact_east_engle", REGIONS_NORTHYMBRE_DEAD) then
		EVENTS_EAST_ENGLE_NORTHYMBRE = 3;
		cm:override_mission_succeeded_status("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_dead", true);
	end
	
	-- Conquer the East Danelaw region
	if EVENTS_EAST_ENGLE_EAST_DANELAW == 1 and Has_Required_Regions("vik_fact_east_engle", REGIONS_EAST_DANELAW_MINORS) == true then
		EVENTS_EAST_ENGLE_EAST_DANELAW = 2;
		cm:override_mission_succeeded_status("vik_fact_east_engle", "vik_fact_east_engle_mission_east_danelaw", true);
	end

	-- Beat up Wicing, annex Grantabrycg
	if EVENTS_EAST_ENGLE_WICING == 0 and cm:model():world():faction_by_key("vik_fact_wicing"):at_war_with(cm:model():world():faction_by_key("vik_fact_east_engle")) == true then
		if cm:model():world():faction_by_key("vik_fact_grantebru"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_grantebru"):is_dead() == false then
			EVENTS_EAST_ENGLE_WICING = 1
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_wicing", true);
		end
	elseif EVENTS_EAST_ENGLE_WICING == 1 and (cm:model():world():faction_by_key("vik_fact_wicing"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_wicing"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_east_engle")) == true) then
		EVENTS_EAST_ENGLE_WICING = 2;
		cm:override_mission_succeeded_status("vik_fact_east_engle", "vik_fact_east_engle_mission_wicing", true);
	end

end

function EventsMissionsEastEngle(context, turn)

	-- Defeat Wicing
	if context:mission():mission_record_key() == "vik_fact_east_engle_mission_wicing" then
		if cm:model():world():faction_by_key("vik_fact_grantebru"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_grantebru"):is_dead() == false then
			cm:grant_faction_handover("vik_fact_east_engle", "vik_fact_grantebru", turn-1, turn-1, context);
		end
		-- Choose a followup mission > East Danelaw if relevant, Northymbre if not.
		if Has_Required_Regions_Vassals("vik_fact_east_engle", REGIONS_EAST_DANELAW_MINORS) == false then
			EVENTS_EAST_ENGLE_EAST_DANELAW = 1;
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_east_danelaw", true);
		elseif cm:model():world():faction_by_key("vik_fact_northymbre"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_northymbre"):is_dead() == false then
			EVENTS_EAST_ENGLE_NORTHYMBRE = 1
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_alive", true);
		else
			EVENTS_EAST_ENGLE_NORTHYMBRE = 2
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_dead", true);
		end
		
	end
	
	-- Conquer the Danelaw > Northymbre
	if context:mission():mission_record_key() == "vik_fact_east_engle_mission_east_danelaw" then
		-- Choose a followup mission based on if Northymbre is alive or not.
		if cm:model():world():faction_by_key("vik_fact_northymbre"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_northymbre"):is_dead() == false then
			EVENTS_EAST_ENGLE_NORTHYMBRE = 1
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_alive", true);
		else
			EVENTS_EAST_ENGLE_NORTHYMBRE = 2
			cm:trigger_mission("vik_fact_east_engle", "vik_fact_east_engle_mission_northymbre_dead", true);
		end
	end
	
end

-----------------------
-- Northymbre Events --
-----------------------

EVENTS_NORTHYMBRE_WESTMORINGAS = 0;
EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER = 0;
EVENTS_NORTHYMBRE_NORTHLEODE = 0;
EVENTS_NORTHYMBRE_EAST_ENGLE = 0;
EVENTS_NORTHYMBRE_MIERCE = 0;

function EventsNorthymbre(turn, newturn) 

	-- Beat up Westmoringas > Add Northleode to the fray after 10 turns if they aren't already in it
	if EVENTS_NORTHYMBRE_WESTMORINGAS == 0 and turn >= 3 then
		EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER = turn
		if cm:model():world():faction_by_key("vik_fact_westmoringas"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_westmoringas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == false then
			EVENTS_NORTHYMBRE_WESTMORINGAS = 10;
			cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_westmoringas", true);
		else
			EVENTS_NORTHYMBRE_WESTMORINGAS = 20;
		end
	elseif EVENTS_NORTHYMBRE_WESTMORINGAS == 10 then
		if cm:model():world():faction_by_key("vik_fact_westmoringas"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_westmoringas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
			EVENTS_NORTHYMBRE_WESTMORINGAS = 20;
			cm:override_mission_succeeded_status("vik_fact_northymbre", "vik_mission_northymbre_westmoringas", true);
			--cm:grant_faction_handover("vik_fact_northymbre", "vik_fact_holdrness", turn - 1, turn - 1, context);
		elseif EVENTS_NORTHYMBRE_NORTHLEODE == 0 and turn >= EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER + 10 then
			if cm:model():world():faction_by_key("vik_fact_northleode"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_northleode"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
				EVENTS_NORTHYMBRE_NORTHLEODE = 20;
			else
				EVENTS_NORTHYMBRE_NORTHLEODE = 10
				SetFactionsHostile("vik_fact_westmoringas", "vik_fact_northymbre");
				SetFactionsHostile("vik_fact_northleode", "vik_fact_northymbre");
				SetFactionsFriendly("vik_fact_northleode", "vik_fact_westmoringas");
				cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre");
				cm:force_make_vassal("vik_fact_northleode", "vik_fact_westmoringas");
				cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_northleode_a", true);
			end	
		end
	end
	
	-- Beat up Northleode
	if EVENTS_NORTHYMBRE_NORTHLEODE == 0 then
		if cm:model():world():faction_by_key("vik_fact_northleode"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_northleode"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == false then
			if turn >= EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER + 10 then
				EVENTS_NORTHYMBRE_NORTHLEODE = 10;
				SetFactionsHostile("vik_fact_northleode", "vik_fact_northymbre");
				cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre");	
				cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_northleode_b", true);
			elseif cm:model():world():faction_by_key("vik_fact_northymbre"):at_war_with(cm:model():world():faction_by_key("vik_fact_northleode")) == true then
				if cm:model():world():faction_by_key("vik_fact_westmoringas"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_westmoringas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == false then
					EVENTS_NORTHYMBRE_NORTHLEODE = 10
					SetFactionsHostile("vik_fact_westmoringas", "vik_fact_northymbre");
					SetFactionsHostile("vik_fact_northleode", "vik_fact_northymbre");
					SetFactionsFriendly("vik_fact_northleode", "vik_fact_westmoringas");
					cm:force_make_vassal("vik_fact_northleode", "vik_fact_westmoringas");
					cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_northleode_a", true);
				else
					EVENTS_NORTHYMBRE_NORTHLEODE = 10;
					SetFactionsHostile("vik_fact_northleode", "vik_fact_northymbre");
					cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_northleode_b", true);
				end
			end
		else
			EVENTS_NORTHYMBRE_NORTHLEODE = 20;
			SetFactionsNeutral("vik_fact_northleode", "vik_fact_northymbre");
		end
	elseif EVENTS_NORTHYMBRE_NORTHLEODE == 10 then
		if cm:model():world():faction_by_key("vik_fact_northleode"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_northleode"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
			EVENTS_NORTHYMBRE_NORTHLEODE = 20;
			SetFactionsNeutral("vik_fact_northleode", "vik_fact_northymbre");
			cm:override_mission_succeeded_status("vik_fact_northymbre", "vik_mission_northymbre_northleode_a", true);
			cm:override_mission_succeeded_status("vik_fact_northymbre", "vik_mission_northymbre_northleode_b", true);
			--cm:grant_faction_handover("vik_fact_northymbre", "vik_fact_hylrborg", turn - 1, turn - 1, context);
		end
	end
	
	-- Beat up East Engle. Trigger after Northleode + Westmoringas + 20 settlements or war with east engle
	if EVENTS_NORTHYMBRE_EAST_ENGLE == 0 then
		if (EVENTS_NORTHYMBRE_NORTHLEODE == 20 and EVENTS_NORTHYMBRE_WESTMORINGAS == 20 and cm:model():world():faction_by_key("vik_fact_northymbre"):region_list():num_items() >= 20) or cm:model():world():faction_by_key("vik_fact_northymbre"):at_war_with(cm:model():world():faction_by_key("vik_fact_east_engle")) == true then
			if cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_east_engle"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
				EVENTS_NORTHYMBRE_EAST_ENGLE = 20;
				SetFactionsNeutral("vik_fact_east_engle", "vik_fact_northymbre");
			else
				EVENTS_NORTHYMBRE_EAST_ENGLE = 10;
				SetFactionsHostile("vik_fact_east_engle", "vik_fact_northymbre");
				cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_east_engle", true);
			end
		end
	elseif EVENTS_NORTHYMBRE_EAST_ENGLE == 10 then
		if cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_east_engle"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
			EVENTS_NORTHYMBRE_EAST_ENGLE = 20;
			SetFactionsNeutral("vik_fact_east_engle", "vik_fact_northymbre");
			cm:override_mission_succeeded_status("vik_fact_northymbre", "vik_mission_northymbre_east_engle", true);
		end		
	end
	
	-- Beat up Mierce. Triggers after East Engle mission, or if war breaks out
	if EVENTS_NORTHYMBRE_MIERCE == 0 then
		if cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
			EVENTS_NORTHYMBRE_MIERCE = 20;
			SetFactionsNeutral("vik_fact_mierce", "vik_fact_northymbre");
		elseif EVENTS_NORTHYMBRE_EAST_ENGLE == 20 or cm:model():world():faction_by_key("vik_fact_northymbre"):at_war_with(cm:model():world():faction_by_key("vik_fact_mierce")) == true then
			EVENTS_NORTHYMBRE_MIERCE = 10
			SetFactionsHostile("vik_fact_mierce", "vik_fact_northymbre");
			cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_mierce", true);
		end
	elseif EVENTS_NORTHYMBRE_MIERCE == 10 then
		if cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
			EVENTS_NORTHYMBRE_MIERCE = 20;
			SetFactionsNeutral("vik_fact_mierce", "vik_fact_northymbre");
			cm:override_mission_succeeded_status("vik_fact_northymbre", "vik_mission_northymbre_mierce", true);
		end		
	end
	
end

function EventsMissionsNorthymbre(context, turn)

	-- Defeat Rebels > Conquer Westmoringas issued
	if context:mission():mission_record_key() == "vik_starting_rebels" and EVENTS_NORTHYMBRE_WESTMORINGAS == 0 then
		EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER = turn
		if cm:model():world():faction_by_key("vik_fact_westmoringas"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_westmoringas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == false then
			EVENTS_NORTHYMBRE_WESTMORINGAS = 10;
			SetFactionsHostile("vik_fact_westmoringas", "vik_fact_northymbre");
			cm:trigger_mission("vik_fact_northymbre", "vik_mission_northymbre_westmoringas", true);
		end
	end

	if context:mission():mission_record_key() == "vik_mission_northymbre_northleode_a" or context:mission():mission_record_key() == "vik_mission_northymbre_northleode_b" or context:mission():mission_record_key() == "vik_mission_northymbre_east_engle" or context:mission():mission_record_key() == "vik_mission_northymbre_mierce" then
		HERE_KING["vik_fact_northymbre"]["level"] = HERE_KING["vik_fact_northymbre"]["level"] + 1;
		HERE_KING["vik_fact_northymbre"]["breakdown"]["decrees"] = HERE_KING["vik_fact_northymbre"]["breakdown"]["events"] + 1;
		HereKingChecks();
	end
	
end

-----------------------
-- Gwined Events --
-----------------------

EVENTS_GWINED_DEWET = 0;
EVENTS_GWINED_MIERCE = 0;
EVENTS_GWINED_SEA_KING_RAIDS = 0;
EVENTS_GWINED_SEA_KINGS = 0;
EVENTS_GWINED_CERNEU = 0;
EVENTS_GWINED_WEST_SEAXE = 0;

function EventsGwined(turn, newturn) 

	-- Conquer Dewet
	if EVENTS_GWINED_DEWET == 1 then
		if Has_Required_Regions("vik_fact_gwined", REGIONS_DEWET) == true then
			EVENTS_GWINED_DEWET = 2;
			cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_dewet", true);
		end
	end
	
	-- Miercna event chain	
	if EVENTS_GWINED_MIERCE < 30 then
		if EVENTS_GWINED_MIERCE == 0 then
			if cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_mierce")) == true then
				if Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == true then
					EVENTS_GWINED_MIERCE = 20;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
				else
					EVENTS_GWINED_MIERCE = 21;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_3", true);
				end
			elseif Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == true and newturn == true then
				if Shared_Required_Regions("vik_fact_gwined", "vik_fact_mierce", REGIONS_WALES) == true then
					cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_mierce_3", true);
				else
					cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_mierce_1", true);
				end
			end
		elseif EVENTS_GWINED_MIERCE == 10 then
			if cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_mierce")) == true then
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_mierce_1", false);
				if Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == true then
					EVENTS_GWINED_MIERCE = 20;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
				else
					EVENTS_GWINED_MIERCE = 21;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_3", true);
				end
			elseif Shared_Required_Regions("vik_fact_gwined", "vik_fact_mierce", REGIONS_WALES) == true then
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_mierce_1", true);
				if Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == true then
					cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_mierce_3", true);	
				else 
					EVENTS_GWINED_MIERCE = 11;
				end
			end
		elseif EVENTS_GWINED_MIERCE == 11 then
			if cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_mierce")) == true then
				if Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == true then
					EVENTS_GWINED_MIERCE = 20;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
				else
					EVENTS_GWINED_MIERCE = 21;
					SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_3", true);
				end
			end
		elseif EVENTS_GWINED_MIERCE == 20 then
			if Has_Any_Required_Regions("vik_fact_mierce", REGIONS_WALES, 1) == false then
				EVENTS_GWINED_MIERCE = 21;
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2b", true);
				if cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true then
					EVENTS_GWINED_MIERCE = 30;
				else
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_3", true);
				end
			end
		elseif EVENTS_GWINED_MIERCE == 21 then
			if cm:model():world():faction_by_key("vik_fact_mierce"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_mierce"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_gwined")) == true then
				EVENTS_GWINED_MIERCE = 30;
				SetFactionsNeutral("vik_fact_gwined", "vik_fact_mierce");
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_mierce_3", true);
			end
		end
	end

	-- Sea Kings event chain 
	
	if EVENTS_GWINED_SEA_KINGS < 40 then
		if EVENTS_GWINED_SEA_KINGS < 20 then
			if cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_dyflin")) == true or cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_sudreyar")) == true then
				EVENTS_GWINED_SEA_KINGS = 20;
				SetFactionsHostile("vik_fact_gwined", "vik_fact_sudreyar");
				SetFactionsHostile("vik_fact_gwined", "vik_fact_dyflin");
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_2", true);
			end
		elseif EVENTS_GWINED_SEA_KINGS == 20 or EVENTS_GWINED_SEA_KINGS == 31 then
			if cm:model():world():faction_by_key("vik_fact_dyflin"):is_dead() == true and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_dead() == true then
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_2", true);
				if EVENTS_GWINED_SEA_KINGS == 20 then
					if Has_Required_Regions("vik_fact_gwined", REGIONS_IRISH_SEA_PORTS) == false then 
						EVENTS_GWINED_SEA_KINGS = 21;
						cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_1", true);
					else 
						EVENTS_GWINED_SEA_KINGS = 40
					end
				end
			end
		elseif EVENTS_GWINED_SEA_KINGS == 21 or EVENTS_GWINED_SEA_KINGS == 30 then
			if Has_Required_Regions("vik_fact_gwined", REGIONS_IRISH_SEA_PORTS) == true then
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_1", true);
				if EVENTS_GWINED_SEA_KINGS == 30 then
					if cm:model():world():faction_by_key("vik_fact_dyflin"):is_dead() == true and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_dead() == true then
						EVENTS_GWINED_SEA_KINGS = 40;				
					else
						EVENTS_GWINED_SEA_KINGS = 31;
						SetFactionsHostile("vik_fact_gwined", "vik_fact_sudreyar");
						SetFactionsHostile("vik_fact_gwined", "vik_fact_dyflin");
						cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_2", true);
					end
				else
					EVENTS_GWINED_SEA_KINGS = 40;
				end
			end
		end
	end

	-- Cerneu event chain

	if EVENTS_GWINED_CERNEU < 30 then
		if EVENTS_GWINED_CERNEU == 0 and newturn == true then
			if cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_cerneu")) == true then
				EVENTS_GWINED_CERNEU = 20;
				SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
			elseif turn >= 25 and cm:model():random_percent(turn/2) == true then
				if cm:model():world():faction_by_key("vik_fact_cerneu"):is_dead() == true then
					EVENTS_GWINED_CERNEU = 20;
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
				elseif cm:model():world():faction_by_key("vik_fact_cerneu"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
					cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_cerneu_1", true);	
				else
					cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_cerneu_2", true);	
				end
			end
		elseif EVENTS_GWINED_CERNEU == 10 then
			if cm:model():world():faction_by_key("vik_fact_cerneu"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_gwined")) == true then
				EVENTS_GWINED_CERNEU = 30;
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_2", true);
			elseif cm:model():world():faction_by_key("vik_fact_cerneu"):is_dead() == true then
				EVENTS_GWINED_CERNEU = 20;
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_2", false);
				if Has_Required_Regions_Vassals("vik_fact_gwined", REGIONS_CORNWALAS) == true then
					EVENTS_GWINED_CERNEU = 30;
				else
					cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
				end
			end
		elseif EVENTS_GWINED_CERNEU == 20 then
			if Has_Required_Regions_Vassals("vik_fact_gwined", REGIONS_CORNWALAS) == true then
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1b", true);
				EVENTS_GWINED_CERNEU = 30;
			end
		end
	end
	
	if EVENTS_GWINED_WEST_SEAXE < 20 then
		if EVENTS_GWINED_WEST_SEAXE == 0 and cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == true then
			EVENTS_GWINED_WEST_SEAXE = 10;
			SetFactionsHostile("vik_fact_gwined", "vik_fact_west_seaxe");	
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_west_seaxe", true);
		elseif EVENTS_GWINED_WEST_SEAXE == 10 and cm:model():world():faction_by_key("vik_fact_gwined"):at_war_with(cm:model():world():faction_by_key("vik_fact_west_seaxe")) == false then
			if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_gwined"))== true then
				EVENTS_GWINED_WEST_SEAXE = 20;
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_west_seaxe", true);
			elseif cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_dead() == true then					
				EVENTS_GWINED_WEST_SEAXE = 20;
				cm:override_mission_succeeded_status("vik_fact_gwined", "vik_fact_gwined_mission_west_seaxe", true);
			end
		end
	end
	
end

function EventsMissionsGwined(context, turn)

	-- Defeat Rebels > Conquer Dewet issued
	if context:mission():mission_record_key() == "vik_starting_rebels" then
		if cm:model():world():faction_by_key("vik_fact_dyfet"):is_null_interface() == false and cm:model():world():faction_by_key("vik_fact_dyfet"):is_dead() == false then
			EVENTS_GWINED_DEWET = 1;
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_dewet", true);
		end
	end
	
	-- Heroism mission rewards
	if context:mission():mission_record_key() == "vik_fact_gwined_mission_west_seaxe" or context:mission():mission_record_key() == "vik_fact_gwined_mission_cerneu_1" or context:mission():mission_record_key() == "vik_fact_gwined_mission_mierce_1" or context:mission():mission_record_key() == "vik_fact_gwined_mission_mierce_2" or context:mission():mission_record_key() == "vik_fact_gwined_mission_sea_kings_1" or context:mission():mission_record_key() == "vik_fact_gwined_mission_sea_kings_2" or context:mission():mission_record_key() == "vik_fact_gwined_mission_mierce_3" or context:mission():mission_record_key() == "vik_fact_gwined_mission_mierce_2b" or context:mission():mission_record_key() == "vik_fact_gwined_mission_cerneu_1b" then
		W_HEROISM = W_HEROISM + 10;
		W_HEROISM_EVENT = W_HEROISM_EVENT + 10;
		WelshHeroismCheck("vik_fact_gwined");
	end

end

function EventsDilemmasGwined(context, turn)

	if context:dilemma() == "vik_fact_gwined_dilemma_mierce_1" then
		if context:choice() == 0 then
			EVENTS_GWINED_MIERCE = 20;
			SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
			cm:force_declare_war("vik_fact_mierce", "vik_fact_gwined");
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
		elseif context:choice() == 1 then
			if cm:model():random_percent(80) == true then
				cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_mierce_2", true);
			else
				EVENTS_GWINED_MIERCE = 20;	
				SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
				cm:force_declare_war("vik_fact_mierce", "vik_fact_gwined");
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2b", true);
			end
		elseif context:choice() == 2 then
			EVENTS_GWINED_MIERCE = 11;
		end
	end
		
	if context:dilemma() == "vik_fact_gwined_dilemma_mierce_2" then
		if context:choice() == 0 then
			EVENTS_GWINED_MIERCE = 10;
			SetFactionsFriendly("vik_fact_gwined", "vik_fact_mierce");
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_1", true);
		elseif context:choice() == 1 then
			EVENTS_GWINED_MIERCE = 20;	
			SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
			cm:force_declare_war("vik_fact_mierce", "vik_fact_gwined");
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2", true);
		end
	end
	
	if context:dilemma() == "vik_fact_gwined_dilemma_mierce_3" then
		local chancemod = 50;
		if context:choice() == 0 then
			for i = 1, #REGIONS_WALES do
				local region = cm:model():world():region_manager():region_by_key(REGIONS_WALES[i]);
				if region:owning_faction():name() == "vik_fact_gwined" then
					chancemod = chancemod + 5;
				elseif region:owning_faction():name() == "vik_fact_gwined" == false then
					chancemod = chancemod - 5;
				end
			end
			chancemod = math.max(chancemod, -50);
			chancemod = math.min(chancemod, 50);
			if cm:model():random_percent(50 + chancemod) == true then
				EVENTS_GWINED_MIERCE = 11;
				Transfer_Regions_Vassals("vik_fact_gwined", "vik_fact_mierce", REGIONS_WALES);
				SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
			else
				EVENTS_GWINED_MIERCE = 20;
				SetFactionsHostile("vik_fact_gwined", "vik_fact_mierce");
				cm:force_declare_war("vik_fact_mierce", "vik_fact_gwined");
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_mierce_2b", true);
			end			
		elseif context:choice() == 1 then
			EVENTS_GWINED_MIERCE = 11;
		end
	end

	if context:dilemma() == "vik_fact_gwined_dilemma_sea_kings_1" then
		if context:choice() == 0 then
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_2", true);
			SetFactionsHostile("vik_fact_gwined", "vik_fact_sudreyar");
			SetFactionsHostile("vik_fact_gwined", "vik_fact_dyflin");
			EVENTS_GWINED_SEA_KINGS = 20;
		elseif context:choice() == 1 then
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_1", true);
			SetFactionsHostile("vik_fact_gwined", "vik_fact_sudreyar");
			SetFactionsHostile("vik_fact_gwined", "vik_fact_dyflin");			
			EVENTS_GWINED_SEA_KINGS = 30;
		elseif context:choice() == 2 then
			--economic penalty bundle
			EVENTS_GWINED_SEA_KINGS = 10
		elseif context:choice() == 3 then
			-- no major effect
			EVENTS_GWINED_SEA_KINGS = 40
		end
	end
	
	if context:dilemma() == "vik_fact_gwined_dilemma_sea_kings_2" then
		if context:choice() == 0 then
			--economic penalty bundle
		elseif context:choice() == 1 then
			--remove economic penalty effect bundle
			EVENTS_GWINED_SEA_KINGS = 20;
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_sea_kings_2", true);
			SetFactionsHostile("vik_fact_gwined", "vik_fact_sudreyar");
			SetFactionsHostile("vik_fact_gwined", "vik_fact_dyflin");			
		end
	end
	
	if context:dilemma() == "vik_fact_gwined_dilemma_cerneu_1" then
		if context:choice() == 0 then
			SetFactionsHostile("vik_fact_gwined", "vik_fact_west_seaxe");		
			local chancemod = (cm:model():world():faction_by_key("vik_fact_gwined"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_cerneu"):region_list():num_items()) * 5
			chancemod = math.max(chancemod, -25);
			chancemod = math.min(chancemod, 75);
			if cm:model():random_percent(25 + chancemod) == true then
				EVENTS_GWINED_CERNEU = 30;
				cm:trigger_incident("vik_fact_gwined", "vik_incident_cerneu_accepts_annex", true);
				cm:grant_faction_handover("vik_fact_gwined", "vik_fact_cerneu", turn - 1, turn - 1, context);
				SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_gwined");
				cm:force_declare_war("vik_fact_west_seaxe", "vik_fact_gwined");
			else 
				EVENTS_GWINED_CERNEU = 20;
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1b", true);
				SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
			end
		elseif context:choice() == 1 then
			SetFactionsHostile("vik_fact_gwined", "vik_fact_west_seaxe");
			local chancemod = (cm:model():world():faction_by_key("vik_fact_gwined"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_cerneu"):region_list():num_items()) * 5
			chancemod = math.max(chancemod, -50);
			chancemod = math.min(chancemod, 50);
			if cm:model():random_percent(50 + chancemod) == true then
				EVENTS_GWINED_CERNEU = 30;
				SetFactionsFriendly("vik_fact_gwined", "vik_fact_cerneu");
				SetFactionsHostile("vik_fact_west_seaxe", "vik_fact_cerneu");
				cm:force_declare_war("vik_fact_west_seaxe", "vik_fact_cerneu");
				cm:force_declare_war("vik_fact_west_seaxe", "vik_fact_gwined");
				cm:force_make_vassal("vik_fact_gwined", "vik_fact_cerneu");
				cm:trigger_incident("vik_fact_gwined", "vik_incident_cerneu_accepts_vassal", true);
			else
				EVENTS_GWINED_CERNEU = 20;
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1b", true);
				SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
			end
		elseif context:choice() == 2 then
			EVENTS_GWINED_CERNEU = 20;
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
			SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
		elseif context:choice() == 3 then
			-- diplomatic penalty with welsh factions -- 
			EVENTS_GWINED_CERNEU = 30;
		end
	end
	
	if context:dilemma() == "vik_fact_gwined_dilemma_cerneu_2" then
		if context:choice() == 0 then
			local chancemod = (cm:model():world():faction_by_key("vik_fact_gwined"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_cerneu"):region_list():num_items()) * 5
			chancemod = math.max(chancemod, -25);
			chancemod = math.min(chancemod, 75);
			if cm:model():random_percent(25 + chancemod) == true then
				EVENTS_GWINED_CERNEU = 30;
				cm:grant_faction_handover("vik_fact_gwined", "vik_fact_cerneu", turn - 1, turn - 1, context);
				cm:trigger_incident("vik_fact_gwined", "vik_incident_cerneu_accepts_annex", true);
			else 
				EVENTS_GWINED_CERNEU = 20;
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1b", true);
				SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
			end
		elseif context:choice() == 1 then
			local chancemod = (cm:model():world():faction_by_key("vik_fact_gwined"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_cerneu"):region_list():num_items()) * 5
			chancemod = math.max(chancemod, -50);
			chancemod = math.min(chancemod, 50);
			if cm:model():random_percent(50 + chancemod) == true then
				EVENTS_GWINED_CERNEU = 30;
				SetFactionsFriendly("vik_fact_gwined", "vik_fact_cerneu");
				cm:force_make_vassal("vik_fact_gwined", "vik_fact_cerneu");
				cm:trigger_incident("vik_fact_gwined", "vik_incident_cerneu_accepts_vassal", true);
			else
				EVENTS_GWINED_CERNEU = 20;
				cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1b", true);
				SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
			end
		elseif context:choice() == 2 then
			EVENTS_GWINED_CERNEU = 20;
			cm:trigger_mission("vik_fact_gwined", "vik_fact_gwined_mission_cerneu_1", true);
			SetFactionsHostile("vik_fact_gwined", "vik_fact_cerneu");		
		elseif context:choice() == 3 then
			-- diplomatic penalty with welsh factions -- 
			EVENTS_GWINED_CERNEU = 30;
		end
	end
	
end

function GwinedSeaKingRaidCheck()

	if EVENTS_GWINED_SEA_KINGS <= 10 then
		EVENTS_GWINED_SEA_KING_RAIDS = EVENTS_GWINED_SEA_KING_RAIDS + 1;
		if EVENTS_GWINED_SEA_KING_RAIDS >= 3 then
			EVENTS_GWINED_SEA_KING_RAIDS = 0
			if EVENTS_GWINED_SEA_KINGS == 10 then
				cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_sea_kings_2", false);	
			elseif EVENTS_GWINED_SEA_KINGS == 0 then
				cm:trigger_dilemma("vik_fact_gwined", "vik_fact_gwined_dilemma_sea_kings_1", false);
			end
		end
	end
end


-----------------------
-- Strat Clut Events --
-----------------------

EVENTS_STRAT_CLUT_WESTERNAS = 0;
EVENTS_STRAT_CLUT_NORTHLEODE = 0;
EVENTS_STRAT_CLUT_CIRCENN = 0;

function EventsStratClut(turn, newturn) 

	-- Circenn king event chain. Kill the king and fight Circenn or kill the king and fight Athfochla
	if EVENTS_STRAT_CLUT_CIRCENN == 0 then
		if turn >= 20 and cm:model():random_percent(5) == true then
			if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_athfochla"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false and cm:model():world():faction_by_key("vik_fact_circenn"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_circenn"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false then
				EVENTS_STRAT_CLUT_CIRCENN = 10;
				cm:trigger_dilemma("vik_fact_strat_clut", "vik_fact_strat_clut_circenn_king", false);
			else
				EVENTS_STRAT_CLUT_CIRCENN = 30;
			end
		end
	elseif EVENTS_STRAT_CLUT_CIRCENN == 20 then
		if cm:model():world():faction_by_key("vik_fact_circenn"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_circenn"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true then
			EVENTS_STRAT_CLUT_CIRCENN = 40;
			SetFactionsNeutral("vik_fact_circenn", "vik_fact_strat_clut");
			cm:override_mission_succeeded_status("vik_fact_strat_clut", "vik_mission_strat_clut_circenn", true);
		end
	elseif EVENTS_STRAT_CLUT_CIRCENN == 30 then
		if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_athfochla"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true then
			EVENTS_STRAT_CLUT_CIRCENN = 40;
			SetFactionsNeutral("vik_fact_athfochla", "vik_fact_strat_clut");
			cm:override_mission_succeeded_status("vik_fact_strat_clut", "vik_mission_strat_clut_athfochla", true);
		end
	end
	
	-- Conquer Westernas. Triggers on turn 3 or after da rebels
	if EVENTS_STRAT_CLUT_WESTERNAS == 0 and (turn >= 3 or cm:model():world():faction_by_key("vik_fact_westernas"):at_war_with(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true) then
		if cm:model():world():faction_by_key("vik_fact_westernas"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_westernas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false then
			EVENTS_STRAT_CLUT_WESTERNAS = 10;
			SetFactionsHostile("vik_fact_westernas", "vik_fact_strat_clut");
			cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_westernas", true);
		else
			EVENTS_STRAT_CLUT_WESTERNAS = 20;
		end
	elseif EVENTS_STRAT_CLUT_WESTERNAS == 10 then
		if cm:model():world():faction_by_key("vik_fact_westernas"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_westernas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true then
			EVENTS_STRAT_CLUT_WESTERNAS = 20;
			SetFactionsNeutral("vik_fact_westernas", "vik_fact_strat_clut");
			cm:override_mission_succeeded_status("vik_fact_strat_clut", "vik_mission_strat_clut_westernas", true);
			if EVENTS_STRAT_CLUT_NORTHLEODE == 0 then
				if cm:model():world():faction_by_key("vik_fact_northleode"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_northleode"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_northymbre")) == true then
					EVENTS_STRAT_CLUT_NORTHLEODE = 10;
					SetFactionsHostile("northleode", "vik_fact_strat_clut");
					cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_northleode", true);
				else 
					EVENTS_STRAT_CLUT_NORTHLEODE = 20;
				end
			end	
		end
	end
	
	-- Conquer Northleode. Triggers after Westernas	
	if EVENTS_STRAT_CLUT_NORTHLEODE == 0 then
		if cm:model():world():faction_by_key("vik_fact_northleode"):at_war_with(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true then
			EVENTS_STRAT_CLUT_NORTHLEODE = 10;
			SetFactionsHostile("northleode", "vik_fact_strat_clut");
			cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_northleode", true);
		end
	elseif EVENTS_STRAT_CLUT_NORTHLEODE == 10 then
		if cm:model():world():faction_by_key("vik_fact_northleode"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_northleode"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == true then
			EVENTS_STRAT_CLUT_NORTHLEODE = 20;
			SetFactionsNeutral("vik_fact_northleode", "vik_fact_strat_clut");
			cm:override_mission_succeeded_status("vik_fact_strat_clut", "vik_mission_strat_clut_northleode", true);
		end
	end

end

function EventsMissionsStratClut(context, turn)

	-- Defeat Rebels > Conquer Westmoringas issued
	if context:mission():mission_record_key() == "vik_starting_rebels" and EVENTS_STRAT_CLUT_WESTERNAS == 0 then
		if cm:model():world():faction_by_key("vik_fact_westernas"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_westernas"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false then
			EVENTS_STRAT_CLUT_WESTERNAS = 10;
			SetFactionsHostile("vik_fact_westernas", "vik_fact_strat_clut");
			cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_westernas", true);
		else
			EVENTS_STRAT_CLUT_WESTERNAS = 20;
		end
	end

	-- Heroism rewarding events
	if context:mission():mission_record_key() == "vik_mission_strat_clut_northleode" or context:mission():mission_record_key() == "vik_mission_strat_clut_westernas" then
		W_HEROISM_STR = W_HEROISM_STR + 10;
		W_HEROISM_EVENT_STR = W_HEROISM_EVENT_STR + 10;
		StratClutHeroismCheck("vik_fact_strat_clut");
	end
	
end

function EventsDilemmasStratClut(context, turn)

	if context:dilemma() == "vik_fact_strat_clut_circenn_king" then
		if context:choice() == 0 then
			EVENTS_STRAT_CLUT_CIRCENN = 20;
			SetFactionsFriendly("vik_fact_athfochla", "vik_fact_strat_clut");		
			SetFactionsHostile("vik_fact_circenn", "vik_fact_strat_clut");	
			SetFactionsHostile("vik_fact_circenn", "vik_fact_athfochla");	
			local circenn = cm:model():world():faction_by_key("vik_fact_circenn")
			cm:kill_character("character_cqi:"..circenn:faction_leader():command_queue_index(), false, true);
			cm:force_declare_war("vik_fact_athfochla", "vik_fact_circenn");
			cm:force_declare_war("vik_fact_circenn", "vik_fact_strat_clut");
			cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_circenn", true);
		elseif context:choice() == 1 then
			EVENTS_STRAT_CLUT_CIRCENN = 30;
			SetFactionsFriendly("vik_fact_circenn", "vik_fact_strat_clut");
			SetFactionsHostile("vik_fact_athfochla", "vik_fact_strat_clut");				
			SetFactionsHostile("vik_fact_circenn", "vik_fact_athfochla");
			local circenn = cm:model():world():faction_by_key("vik_fact_circenn")
			cm:kill_character("character_cqi:"..circenn:faction_leader():command_queue_index(), false, true);
			cm:force_declare_war("vik_fact_athfochla", "vik_fact_circenn");
			cm:force_declare_war("vik_fact_athfochla", "vik_fact_strat_clut");
			cm:trigger_mission("vik_fact_strat_clut", "vik_mission_strat_clut_athfochla", true);
		end
	end
end

-----------------
-- Mide Events --
-----------------

EVENTS_MIDE_BREGA = 0;
EVENTS_MIDE_AILEACH = 0;

function EventsMide(turn, newturn) 

	if EVENTS_MIDE_BREGA == 0 and turn == 3 then
		if cm:model():world():faction_by_key("vik_fact_dyflin"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == false and cm:model():world():faction_by_key("vik_fact_brega"):is_dead() == false then
			if cm:model():world():faction_by_key("vik_fact_dyflin"):at_war_with(cm:model():world():faction_by_key("vik_fact_mide")) == true then
				--already at war! fire retaliate event?
			elseif cm:model():world():faction_by_key("vik_fact_brega"):at_war_with(cm:model():world():faction_by_key("vik_fact_mide")) == true then
				cm:trigger_incident("vik_fact_mide", "vik_incident_mide_dyflin_attacks_brega", true);
				SetFactionsHostile("vik_fact_dyflin", "vik_fact_brega");
				cm:force_declare_war("vik_fact_dyflin", "vik_fact_brega");
			else
				cm:trigger_dilemma("vik_fact_mide", "vik_dilemma_mide_dyflin_brega", true);
			end
		end
		EVENTS_MIDE_BREGA = 10
	end
	
	if EVENTS_MIDE_AILEACH == 0 and newturn == true and turn >= 10 and cm:model():random_percent(turn/10) then
		EVENTS_MIDE_AILEACH = 10;
		local aileach = cm:model():world():faction_by_key("vik_fact_aileach")
		cm:kill_character("character_cqi:"..aileach:faction_leader():command_queue_index(), false, true);
		cm:trigger_incident("vik_fact_mide", "vik_incident_mide_aileach", true);
		G_LEGITIMACY = G_LEGITIMACY + 5;
		G_LEGITIMACY_EVENT = G_LEGITIMACY_EVENT + 5;
	end
	
end

function EventsDilemmasMide(context, turn)

	if context:dilemma() == "vik_dilemma_mide_dyflin_brega" then
		if context:choice() == 0 then
			SetFactionsHostile("vik_fact_brega", "vik_fact_mide");
			cm:force_declare_war("vik_fact_brega", "vik_fact_mide");
			cm:force_declare_war("vik_fact_dyflin", "vik_fact_brega");
			cm:trigger_incident("vik_fact_mide", "vik_incident_mide_brega_attack_brega", true);
		elseif context:choice() == 1 then
			SetFactionsFriendly("vik_fact_brega", "vik_fact_mide");
			SetFactionsHostile("vik_fact_dyflin", "vik_fact_brega");
			SetFactionsHostile("vik_fact_dyflin", "vik_fact_mide");
			cm:force_declare_war("vik_fact_dyflin", "vik_fact_brega");
			cm:force_declare_war("vik_fact_dyflin", "vik_fact_mide");
			cm:trigger_incident("vik_fact_mide", "vik_incident_mide_brega_attack_dyflin", true);
		elseif context:choice() == 2 then
			AI_DYFLIN_BREGA = true;
			cm:grant_faction_handover("vik_fact_dyflin", "vik_fact_brega", turn-1, turn-1, context);
			cm:treasury_mod("vik_fact_dyflin", 5000);
			if cm:model():random_percent(50) == true then
				TriggerIncidentMPSafe("vik_incident_ai_dyflin_brega_1")
			else
				TriggerIncidentMPSafe("vik_incident_ai_dyflin_brega_2")
			end
		end
	end
	
end		

--------------------
-- Circenn Events --
--------------------

EVENTS_CIRCENN_ORKNEYAR = 0;
EVENTS_CIRCENN_ORKNEYAR_TIMER = 0;
EVENTS_CIRCENN_KING = false;
EVENTS_CIRCENN_KING_INVESTIGATION = 0;
EVENTS_CIRCENN_KING_ATHFOCHLA = 0;
EVENTS_CIRCENN_KING_STRAT_CLUT = 0;

function EventsCircenn(turn, newturn) 

	--Circenn king event chain. Kill the king and fight Circenn or kill the king and fight Athfochla
	if EVENTS_CIRCENN_KING == false and newturn == true then
		if turn >= 20 and cm:model():random_percent(5) == true then
			EVENTS_CIRCENN_KING = true;
			if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_athfochla"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false and cm:model():world():faction_by_key("vik_fact_circenn"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_circenn"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_strat_clut")) == false then
				local circenn = cm:model():world():faction_by_key("vik_fact_circenn")
				local king_influence = circenn:faction_leader():gravitas()
				if difficulty == 1 then -- Easy
					king_influence = king_influence + 2
				elseif difficulty == 0 then -- Normal
					king_influence = king_influence
				elseif difficulty == -1 then -- Hard
					king_influence = king_influence - 2
				elseif difficulty == -2 then -- Very Hard
					king_influence = king_influence - 4
				elseif difficulty == -3 then -- Legendary
					king_influence = king_influence - 6
				end
				king_influence = math.max(king_influence, -10);
				king_influence = math.min(king_influence, 10);
				if cm:model():random_percent(50 + (king_influence * 5)) then
					cm:trigger_dilemma("vik_fact_circenn", "vik_fact_circenn_king_lives", false);
				else
					cm:treasury_mod("vik_fact_athfochla", 10000);
					cm:kill_character("character_cqi:"..circenn:faction_leader():command_queue_index(), false, true);
					cm:trigger_dilemma("vik_fact_circenn", "vik_fact_circenn_king_dead", false);
				end				
			end
		end
	elseif EVENTS_CIRCENN_KING == true and turn == EVENTS_CIRCENN_KING_INVESTIGATION and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == false then
			cm:force_declare_war("vik_fact_athfochla", "vik_fact_circenn");
			if cm:model():world():faction_by_key("vik_fact_strat_clut"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_strat_clut"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
				local chancemod = (cm:model():world():faction_by_key("vik_fact_strat_clut"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_circenn"):region_list():num_items()) * 5
				chancemod = math.max(chancemod, -50);
				chancemod = math.min(chancemod, 50);
				if cm:model():random_percent(50 + chancemod) == true then
					cm:treasury_mod("vik_fact_strat_clut", 5000);
					cm:force_declare_war("vik_fact_strat_clut", "vik_fact_circenn");
				else 
					local chancemod2 = (cm:model():world():faction_by_key("vik_fact_strat_clut"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_athfochla"):region_list():num_items()) * 5
					chancemod2 = math.max(chancemod2, -50);
					chancemod2 = math.min(chancemod2, 50);
					if cm:model():random_percent(25 + chancemod2) == true then
						cm:treasury_mod("vik_fact_strat_clut", 5000);
						cm:force_declare_war("vik_fact_strat_clut", "vik_fact_athfochla");
					end 
				end
			end
		end
	elseif EVENTS_CIRCENN_KING == true and (turn == EVENTS_CIRCENN_KING_INVESTIGATION + 2) and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_athfochla"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
			local circenn_athfochla = 0
			if EVENTS_CIRCENN_KING_ATHFOCHLA == 10 then
				circenn_athfochla = 100;
			elseif EVENTS_CIRCENN_KING_ATHFOCHLA == 11 then
				circenn_athfochla = 75
			elseif EVENTS_CIRCENN_KING_ATHFOCHLA == 12 then
				circenn_athfochla = 25
			end
			if cm:model():random_percent(circenn_athfochla) then
				EVENTS_CIRCENN_KING_ATHFOCHLA = 20;
				cm:trigger_mission("vik_fact_circenn", "vik_mission_circenn_athfochla", true);
			else 
				EVENTS_CIRCENN_KING_ATHFOCHLA = 40;
			end
		else 
			EVENTS_CIRCENN_KING_ATHFOCHLA = 40;
		end
	elseif EVENTS_CIRCENN_KING == true and turn == EVENTS_CIRCENN_KING_INVESTIGATION + 3 and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_strat_clut"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_strat_clut"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
			local circenn_strat_clut = 0
			if EVENTS_CIRCENN_KING_STRAT_CLUT == 10 then
				circenn_strat_clut = 100;
			elseif EVENTS_CIRCENN_KING_STRAT_CLUT == 11 then
				circenn_strat_clut = 75
			elseif EVENTS_CIRCENN_KING_STRAT_CLUT == 12 then
				circenn_strat_clut = 25
			end
			if cm:model():random_percent(circenn_strat_clut) then
				EVENTS_CIRCENN_KING_STRAT_CLUT = 20;
				cm:trigger_mission("vik_fact_circenn", "vik_mission_circenn_strat_clut", true);
			else 
				EVENTS_CIRCENN_KING_STRAT_CLUT = 40;
			end
		else 
			EVENTS_CIRCENN_KING_ATHFOCHLA = 40;
		end
		if EVENTS_CIRCENN_KING_ATHFOCHLA == 40 and EVENTS_CIRCENN_KING_STRAT_CLUT == 40 then
			-- NO SUSPECTS? welp
			output("No suspects for king assassination :(")
		end
	end

	-- Subjugate Athfochla mission	
	if EVENTS_CIRCENN_KING_ATHFOCHLA == 20 then
		if cm:model():world():faction_by_key("vik_fact_athfochla"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_athfochla"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == true then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 30;
			SetFactionsNeutral("vik_fact_athfochla", "vik_fact_circenn");
			cm:override_mission_succeeded_status("vik_fact_circenn", "vik_mission_circenn_athfochla", true);
		end
	end
	
	-- Subjugate Strat Clut mission
	if EVENTS_CIRCENN_KING_STRAT_CLUT == 20 then
		if cm:model():world():faction_by_key("vik_fact_strat_clut"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_strat_clut"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == true then
			EVENTS_CIRCENN_KING_STRAT_CLUT = 30;
			SetFactionsNeutral("vik_fact_strat_clut", "vik_fact_circenn");
			cm:override_mission_succeeded_status("vik_fact_circenn", "vik_mission_circenn_strat_clut", true);
		end
	end

	
	--Conquer Orkneyar. Triggers on turn 3 or after da rebels
	if ((EVENTS_CIRCENN_ORKNEYAR == 0 and turn >= 3) or EVENTS_CIRCENN_ORKNEYAR == 10) and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_fortriu"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_orkneyar"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_orkneyar"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
			EVENTS_CIRCENN_ORKNEYAR = 20;
			EVENTS_CIRCENN_ORKNEYAR_TIMER = turn + 10;
			SetFactionsHostile("vik_fact_orkneyar", "vik_fact_fortriu");
			cm:force_declare_war("vik_fact_orkneyar", "vik_fact_fortriu");
		else
			EVENTS_CIRCENN_ORKNEYAR = 40;
		end
	elseif EVENTS_CIRCENN_ORKNEYAR == 20 and turn == EVENTS_CIRCENN_ORKNEYAR_TIMER and newturn == true then
		if cm:model():world():faction_by_key("vik_fact_orkneyar"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_orkneyar"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
			EVENTS_CIRCENN_ORKNEYAR = 30;
			SetFactionsHostile("vik_fact_orkneyar", "vik_fact_circenn");
			if cm:model():world():faction_by_key("vik_fact_fortriu"):is_dead() == false and cm:model():world():faction_by_key("vik_fact_fortriu"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == false then
				local chancemod = (cm:model():world():faction_by_key("vik_fact_orkneyar"):region_list():num_items() - cm:model():world():faction_by_key("vik_fact_fortriu"):region_list():num_items()) * 5
				chancemod = math.max(chancemod, -50);
				chancemod = math.min(chancemod, 50);
				if cm:model():random_percent(50 + chancemod) == true then
					cm:grant_faction_handover("vik_fact_orkneyar", "vik_fact_fortriu", turn - 1, turn - 1, context);
					cm:trigger_mission("vik_fact_circenn", "vik_mission_circenn_orkneyar_a", true);
				else 
					cm:trigger_mission("vik_fact_circenn", "vik_mission_circenn_orkneyar_b", true);
				end
			else
				cm:trigger_mission("vik_fact_circenn", "vik_mission_circenn_orkneyar_b", true);
			end
		else 
			EVENTS_CIRCENN_ORKNEYAR = 40;
			SetFactionsNeutral("vik_fact_orkneyar", "vik_fact_fortriu");
		end
	elseif EVENTS_CIRCENN_ORKNEYAR == 30 then
		if cm:model():world():faction_by_key("vik_fact_orkneyar"):is_dead() == true or cm:model():world():faction_by_key("vik_fact_orkneyar"):is_vassal_of(cm:model():world():faction_by_key("vik_fact_circenn")) == true then
			EVENTS_CIRCENN_ORKNEYAR = 40;
			SetFactionsNeutral("vik_fact_orkneyar", "vik_fact_fortriu");
			SetFactionsNeutral("vik_fact_orkneyar", "vik_fact_circenn");
			cm:override_mission_succeeded_status("vik_fact_circenn", "vik_mission_circenn_orkneyar_a", true);
			cm:override_mission_succeeded_status("vik_fact_circenn", "vik_mission_circenn_orkneyar_b", true);
		end
	end
end


function EventsMissionsCircenn(context, turn)

	-- Defeat Rebels > Orkneyar go fitey fite da Scots
	if context:mission():mission_record_key() == "vik_starting_rebels" and EVENTS_CIRCENN_ORKNEYAR == 0 then
		EVENTS_CIRCENN_ORKNEYAR = 10;
	end
	
	-- Conquer Athfochla
	if context:mission():mission_record_key() == "vik_mission_circenn_strat_clut" then
		SCOT_LEGITIMACY = SCOT_LEGITIMACY + 20
		SCOT_LEGITIMACY_EVENT = SCOT_LEGITIMACY_EVENT + 20
		ScotsLegitimacyCheck("vik_fact_circenn")
	end
	
	-- Conquer Strat Clut
	if context:mission():mission_record_key() == "vik_mission_circenn_athfochla" then
		SCOT_LEGITIMACY = SCOT_LEGITIMACY + 10
		SCOT_LEGITIMACY_EVENT = SCOT_LEGITIMACY_EVENT + 10
		ScotsLegitimacyCheck("vik_fact_circenn")
	end

		-- Conquer Strat Clut
	if context:mission():mission_record_key() == "vik_mission_circenn_orkneyar_a" or context:mission():mission_record_key() == "vik_mission_circenn_orkneyar_b" then
		SCOT_LEGITIMACY = SCOT_LEGITIMACY + 5
		SCOT_LEGITIMACY_EVENT = SCOT_LEGITIMACY_EVENT + 5
		ScotsLegitimacyCheck("vik_fact_circenn")
	end	
	
end

function EventsDilemmasCircenn(context, turn)

	if context:dilemma() == "vik_fact_circenn_king_dead" then
		SetFactionsFriendly("vik_fact_athfochla", "vik_fact_strat_clut");
		SetFactionsHostile("vik_fact_athfochla", "vik_fact_circenn");				
		SetFactionsHostile("vik_fact_strat_clut", "vik_fact_circenn");
		EVENTS_CIRCENN_KING_INVESTIGATION = turn + 1;
		if context:choice() == 0 then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 11;
			EVENTS_CIRCENN_KING_STRAT_CLUT = 11;
		elseif context:choice() == 1 then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 12;
			EVENTS_CIRCENN_KING_STRAT_CLUT = 12;
		elseif context:choice() == 2 then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 30;
			EVENTS_CIRCENN_KING_STRAT_CLUT = 30;
		end
	end
	
	if context:dilemma() == "vik_fact_circenn_king_lives" then
		SetFactionsHostile("vik_fact_athfochla", "vik_fact_strat_clut");
		SetFactionsHostile("vik_fact_athfochla", "vik_fact_circenn");
		EVENTS_CIRCENN_KING_INVESTIGATION = turn + 1;
		if context:choice() == 0 then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 10;
			EVENTS_CIRCENN_KING_STRAT_CLUT = 10;
		elseif context:choice() == 1 then
			EVENTS_CIRCENN_KING_ATHFOCHLA = 30;
			EVENTS_CIRCENN_KING_STRAT_CLUT = 30;
		end
	end
	
end

-------------------------------------------
----------Events: Northleode!--------------
-------------------------------------------
EVENTS_NORTHLEODE_STRAT_CLUT = false;
EVENTS_NORTHLEODE_WESTMORINGAS = false;
EVENTS_NORTHLEODE_BETRAYAL = false;
EVENTS_NORTHLEODE_BOOKS = false;
EVENTS_NORTHLEODE_KING_OF_NOTHING = false;




function EventsNorthleode(turn, new_turn)
	local northleode = get_faction("vik_fact_northleode")
	if not get_faction("vik_fact_northymbre"):is_dead() then
		dev.log("Checking northleode faction events!")
		local is_still_vassal = northleode:is_vassal_of(get_faction("vik_fact_northymbre"))
		dev.log("vassal status: ["..tostring(is_still_vassal).."]")
		if is_still_vassal and not northleode:has_effect_bundle("sw_northleode_king_of_nothing") then
			cm:apply_effect_bundle("sw_northleode_king_of_nothing", "vik_fact_northleode", 0)
		elseif not is_still_vassal and northleode:has_effect_bundle("sw_northleode_king_of_nothing") then
			cm:remove_effect_bundle("sw_northleode_king_of_nothing", "vik_fact_northleode")
		end
		if turn == 2 then
			cm:force_diplomacy("vik_fact_westmoringas", "vik_fact_northymbre", "war", false, false)
			cm:force_diplomacy("vik_fact_northymbre", "vik_fact_westmoringas", "war", false, false)
		end
		if is_still_vassal and new_turn and (not EVENTS_NORTHLEODE_STRAT_CLUT) and get_faction("vik_fact_strat_clut"):at_war_with(get_faction("vik_fact_westernas")) then
			dev.log("triggering northleode strat clut dilemma")
			cm:trigger_dilemma("vik_fact_northleode", "sw_northleode_help_against_strat_clut", true)
			EVENTS_NORTHLEODE_STRAT_CLUT = true
		elseif turn >= 3 and (not EVENTS_NORTHLEODE_STRAT_CLUT) then
			dev.log("forcing war between strat clut and westernas")
			cm:force_declare_war("vik_fact_strat_clut", "vik_fact_westernas")
		end
		if turn > 14 and is_still_vassal and (not EVENTS_NORTHLEODE_WESTMORINGAS) then
			dev.log("triggering northleode westmoringas dilemma")
			cm:force_diplomacy("vik_fact_westmoringas", "vik_fact_northymbre", "war", true, true)
			cm:force_diplomacy("vik_fact_northymbre", "vik_fact_westmoringas", "war", true, true)
			EVENTS_NORTHLEODE_WESTMORINGAS = true
			cm:trigger_dilemma("vik_fact_northleode", "sw_northleode_help_against_jorvik", true)
		end
		if turn > 25 and is_still_vassal and (not EVENTS_NORTHLEODE_BETRAYAL) then
			dev.log("checking northleode betrayal dilemma")
			if (not get_faction("vik_fact_east_engle"):is_dead()) and (not get_faction("vik_fact_northleode"):at_war_with(get_faction("vik_fact_east_engle"))) then
				dev.log("rolling for northleode east engle dilemma")
				if cm:random_number(25) > 15 then
					dev.log("triggering northleode mierce dilemma")
					cm:trigger_dilemma("vik_fact_northleode", "sw_northleode_betrayal_east_engle", true)
					EVENTS_NORTHLEODE_BETRAYAL = true
				end
			elseif (not get_faction("vik_fact_mierce"):is_dead()) and (not get_faction("vik_fact_northleode"):at_war_with(get_faction("vik_fact_mierce"))) then
				dev.log("rolling for northleode mierce dilemma")
				if cm:random_number(25) > 15 then
					dev.log("triggering northleode mierce dilemma")
					cm:trigger_dilemma("vik_fact_northleode", "sw_northleode_betrayal_mierce", true)
					EVENTS_NORTHLEODE_BETRAYAL = true
				end
			end
		end
	end
end


function EventsMissionsNorthleode(context, turn)


end

function EventsDilemmasNorthleode(context, turn)
	local dilemma = context:dilemma()
	local choice = context:choice()
	if dilemma == "sw_northleode_help_against_strat_clut" then
		if choice == 0 then
			cm:force_declare_war("vik_fact_northymbre", "vik_fact_strat_clut")
		end
	end
	if dilemma == "sw_northleode_help_against_jorvik" then
		if choice == 0 then
			cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
		else
			cm:force_declare_war("vik_fact_northymbre", "vik_fact_westmoringas")
		end
	end
	if dilemma == "sw_northleode_betrayal_east_engle" then
		if choice == 0 then
			cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
			if (not get_faction("vik_fact_east_engle"):at_war_with(get_faction("vik_fact_northymbre"))) then
				cm:force_declare_war("vik_fact_east_engle", "vik_fact_northymbre")
			end
		end
	end
	if dilemma == "sw_northleode_betrayal_mierce" then
		if choice == 0 then
			cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
			if (not get_faction("vik_fact_mierce"):at_war_with(get_faction("vik_fact_northymbre"))) then
				cm:force_declare_war("vik_fact_mierce", "vik_fact_northymbre")
			end
		end
	end
end










------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		EVENTS_BUNDLES_UPDATED = cm:load_value("EVENTS_BUNDLES_UPDATED", false, context);
		ALLEGIANCE_UPDATE2 = cm:load_value("ALLEGIANCE_UPDATE2", false, context);
		EVENTS_WEST_SEAXE_MIERCE = cm:load_value("EVENTS_WEST_SEAXE_MIERCE", 0, context);
		EVENTS_WEST_SEAXE_MIERCE_VASSAL = cm:load_value("EVENTS_WEST_SEAXE_MIERCE_VASSAL", 0, context);
		EVENTS_WEST_SEAXE_EAST_ENGLE = cm:load_value("EVENTS_WEST_SEAXE_EAST_ENGLE", 0, context);
		EVENTS_WEST_SEAXE_CERNEU = cm:load_value("EVENTS_WEST_SEAXE_CERNEU", 0, context);
		EVENTS_WEST_SEAXE_GWENT = cm:load_value("EVENTS_WEST_SEAXE_GWENT", 0, context);
		EVENTS_WEST_SEAXE_GLIWISSIG = cm:load_value("EVENTS_WEST_SEAXE_GLIWISSIG", 0, context);
		EVENTS_MIERCE_WEST_SEAXE = cm:load_value("EVENTS_MIERCE_WEST_SEAXE", 0, context);
		EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER = cm:load_value("EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER", 0, context);
		EVENTS_MIERCE_KING_DEAD_TURN = cm:load_value("EVENTS_MIERCE_KING_DEAD_TURN", 0, context);
		EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER = cm:load_value("EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER", 0, context);
		EVENTS_MIERCE_WALES = cm:load_value("EVENTS_MIERCE_WALES", 0, context);
		EVENTS_MIERCE_WALES_ANGRY_TIMER = cm:load_value("EVENTS_MIERCE_WALES_ANGRY_TIMER", 0, context);
		EVENTS_MIERCE_NORTHYMBRE = cm:load_value("EVENTS_MIERCE_NORTHYMBRE", 0, context);
		EVENTS_MIERCE_EAST = cm:load_value("EVENTS_MIERCE_EAST", 0, context);
		EVENTS_DYFLIN_BREGA = cm:load_value("EVENTS_DYFLIN_BREGA", 0, context);
		EVENTS_DYFLIN_LONGPHORTS = cm:load_value("EVENTS_DYFLIN_LONGPHORTS", 0, context);
		EVENTS_DYFLIN_MIDE = cm:load_value("EVENTS_DYFLIN_MIDE", 0, context);
		EVENTS_DYFLIN_MAINLAND_PORTS = cm:load_value("EVENTS_DYFLIN_MAINLAND_PORTS", 0, context);
		EVENTS_DYFLIN_IRISH_PORTS = cm:load_value("EVENTS_DYFLIN_IRISH_PORTS", 0, context);
		EVENTS_SUDREYAR_CIRCENN = cm:load_value("EVENTS_SUDREYAR_CIRCENN", 0, context);
		EVENTS_SUDREYAR_DYFLIN = cm:load_value("EVENTS_SUDREYAR_DYFLIN", 0, context);
		EVENTS_EAST_ENGLE_WICING = cm:load_value("EVENTS_EAST_ENGLE_WICING", 0, context);
		EVENTS_EAST_ENGLE_EAST_DANELAW = cm:load_value("EVENTS_EAST_ENGLE_EAST_DANELAW", 0, context);
		EVENTS_EAST_ENGLE_NORTHYMBRE = cm:load_value("EVENTS_EAST_ENGLE_NORTHYMBRE", 0, context);
		EVENTS_GWINED_DEWET = cm:load_value("EVENTS_GWINED_DEWET", 0, context);
		EVENTS_GWINED_MIERCE = cm:load_value("EVENTS_GWINED_MIERCE", 0, context);
		EVENTS_GWINED_SEA_KING_RAIDS = cm:load_value("EVENTS_GWINED_SEA_KING_RAIDS", 0, context);
		EVENTS_GWINED_SEA_KINGS = cm:load_value("EVENTS_GWINED_SEA_KINGS", 0, context);
		EVENTS_GWINED_CERNEU = cm:load_value("EVENTS_GWINED_CERNEU", 0, context);
		EVENTS_GWINED_WEST_SEAXE = cm:load_value("EVENTS_GWINED_WEST_SEAXE", 0, context);
		EVENTS_MIDE_BREGA = cm:load_value("EVENTS_MIDE_BREGA", 0, context);
		EVENTS_MIDE_AILEACH = cm:load_value("EVENTS_MIDE_AILEACH", 0, context);
		EVENTS_NORTHYMBRE_WESTMORINGAS = cm:load_value("EVENTS_NORTHYMBRE_WESTMORINGAS", 0, context);
		EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER = cm:load_value("EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER", 0, context);
		EVENTS_NORTHYMBRE_NORTHLEODE = cm:load_value("EVENTS_NORTHYMBRE_NORTHLEODE", 0, context);
		EVENTS_NORTHYMBRE_EAST_ENGLE = cm:load_value("EVENTS_NORTHYMBRE_EAST_ENGLE", 0, context);
		EVENTS_NORTHYMBRE_MIERCE = cm:load_value("EVENTS_NORTHYMBRE_MIERCE", 0, context);
		EVENTS_STRAT_CLUT_WESTERNAS = cm:load_value("EVENTS_STRAT_CLUT_WESTERNAS", 0, context);
		EVENTS_STRAT_CLUT_NORTHLEODE = cm:load_value("EVENTS_STRAT_CLUT_NORTHLEODE", 0, context);
		EVENTS_STRAT_CLUT_CIRCENN = cm:load_value("EVENTS_STRAT_CLUT_CIRCENN", 0, context);
		EVENTS_CIRCENN_ORKNEYAR = cm:load_value("EVENTS_CIRCENN_ORKNEYAR", 0, context);
		EVENTS_CIRCENN_ORKNEYAR_TIMER = cm:load_value("EVENTS_CIRCENN_ORKNEYAR_TIMER", 0, context);
		EVENTS_CIRCENN_KING = cm:load_value("EVENTS_CIRCENN_KING", false, context);
		EVENTS_CIRCENN_KING_INVESTIGATION = cm:load_value("EVENTS_CIRCENN_KING_INVESTIGATION", 0, context);
		EVENTS_CIRCENN_KING_ATHFOCHLA = cm:load_value("EVENTS_CIRCENN_KING_ATHFOCHLA", 0, context);
		EVENTS_CIRCENN_KING_STRAT_CLUT = cm:load_value("EVENTS_CIRCENN_KING_STRAT_CLUT", 0, context);
		SACKED_SETTLEMENTS = cm:load_value("SACKED_SETTLEMENTS", SACKED_SETTLEMENTS, context);
		EVENTS_NORTHLEODE_WESTMORINGAS = cm:load_value("EVENTS_NORTHLEODE_WESTMORINGAS", false, context);
		EVENTS_NORTHLEODE_BETRAYAL = cm:load_value("EVENTS_NORTHLEODE_BETRAYAL", false, context);
		EVENTS_NORTHLEODE_BOOKS = cm:load_value("EVENTS_NORTHLEODE_BOOKS", false, context);
		EVENTS_NORTHLEODE_KING_OF_NOTHING = cm:load_value("EVENTS_NORTHLEODE_KING_OF_NOTHING", false, context);
		EVENTS_NORTHLEODE_STRAT_CLUT = cm:load_value("EVENTS_NORTHLEODE_STRAT_CLUT", false, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("EVENTS_BUNDLES_UPDATED", EVENTS_BUNDLES_UPDATED, context);
		cm:save_value("ALLEGIANCE_UPDATE2", ALLEGIANCE_UPDATE2, context);
		cm:save_value("EVENTS_WEST_SEAXE_MIERCE", EVENTS_WEST_SEAXE_MIERCE, context);
		cm:save_value("EVENTS_WEST_SEAXE_MIERCE_VASSAL", EVENTS_WEST_SEAXE_MIERCE_VASSAL, context);
		cm:save_value("EVENTS_WEST_SEAXE_EAST_ENGLE", EVENTS_WEST_SEAXE_EAST_ENGLE, context);
		cm:save_value("EVENTS_WEST_SEAXE_CERNEU", EVENTS_WEST_SEAXE_CERNEU, context);
		cm:save_value("EVENTS_WEST_SEAXE_GWENT", EVENTS_WEST_SEAXE_GWENT, context);
		cm:save_value("EVENTS_WEST_SEAXE_GLIWISSIG", EVENTS_WEST_SEAXE_GLIWISSIG, context);
		cm:save_value("EVENTS_MIERCE_WEST_SEAXE", EVENTS_MIERCE_WEST_SEAXE, context);
		cm:save_value("EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER", EVENTS_MIERCE_WEST_SEAXE_ANGRY_TIMER, context);
		cm:save_value("EVENTS_MIERCE_KING_DEAD_TURN", EVENTS_MIERCE_KING_DEAD_TURN, context);
		cm:save_value("EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER", EVENTS_MIERCE_WEST_SEAXE_WAR_TIMER, context);
		cm:save_value("EVENTS_MIERCE_WALES", EVENTS_MIERCE_WALES, context);
		cm:save_value("EVENTS_MIERCE_WALES_ANGRY_TIMER", EVENTS_MIERCE_WALES_ANGRY_TIMER, context);
		cm:save_value("EVENTS_MIERCE_NORTHYMBRE", EVENTS_MIERCE_NORTHYMBRE, context);
		cm:save_value("EVENTS_MIERCE_EAST", EVENTS_MIERCE_EAST, context);
		cm:save_value("EVENTS_DYFLIN_BREGA", EVENTS_DYFLIN_BREGA, context);
		cm:save_value("EVENTS_DYFLIN_LONGPHORTS", EVENTS_DYFLIN_LONGPHORTS, context);
		cm:save_value("EVENTS_DYFLIN_MIDE", EVENTS_DYFLIN_MIDE, context);
		cm:save_value("EVENTS_DYFLIN_MAINLAND_PORTS", EVENTS_DYFLIN_MAINLAND_PORTS, context);
		cm:save_value("EVENTS_DYFLIN_IRISH_PORTS", EVENTS_DYFLIN_IRISH_PORTS, context);
		cm:save_value("EVENTS_SUDREYAR_CIRCENN", EVENTS_SUDREYAR_CIRCENN, context);
		cm:save_value("EVENTS_SUDREYAR_DYFLIN", EVENTS_SUDREYAR_DYFLIN, context);
		cm:save_value("EVENTS_EAST_ENGLE_WICING", EVENTS_EAST_ENGLE_WICING, context);
		cm:save_value("EVENTS_EAST_ENGLE_EAST_DANELAW", EVENTS_EAST_ENGLE_EAST_DANELAW, context);
		cm:save_value("EVENTS_EAST_ENGLE_NORTHYMBRE", EVENTS_EAST_ENGLE_NORTHYMBRE, context);
		cm:save_value("EVENTS_GWINED_DEWET", EVENTS_GWINED_DEWET, context);
		cm:save_value("EVENTS_GWINED_MIERCE", EVENTS_GWINED_MIERCE, context);
		cm:save_value("EVENTS_GWINED_SEA_KING_RAIDS", EVENTS_GWINED_SEA_KING_RAIDS, context);
		cm:save_value("EVENTS_GWINED_SEA_KINGS", EVENTS_GWINED_SEA_KINGS, context);
		cm:save_value("EVENTS_GWINED_CERNEU", EVENTS_GWINED_CERNEU, context);
		cm:save_value("EVENTS_GWINED_WEST_SEAXE", EVENTS_GWINED_WEST_SEAXE, context);
		cm:save_value("EVENTS_MIDE_BREGA", EVENTS_MIDE_BREGA, context);
		cm:save_value("EVENTS_MIDE_AILEACH", EVENTS_MIDE_AILEACH, context);
		cm:save_value("EVENTS_NORTHYMBRE_WESTMORINGAS", EVENTS_NORTHYMBRE_WESTMORINGAS, context);
		cm:save_value("EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER", EVENTS_NORTHYMBRE_WESTMORINGAS_TIMER, context);
		cm:save_value("EVENTS_NORTHYMBRE_NORTHLEODE", EVENTS_NORTHYMBRE_NORTHLEODE, context);
		cm:save_value("EVENTS_NORTHYMBRE_EAST_ENGLE", EVENTS_NORTHYMBRE_EAST_ENGLE, context);
		cm:save_value("EVENTS_NORTHYMBRE_MIERCE", EVENTS_NORTHYMBRE_MIERCE, context);
		cm:save_value("EVENTS_STRAT_CLUT_WESTERNAS", EVENTS_STRAT_CLUT_WESTERNAS, context);
		cm:save_value("EVENTS_STRAT_CLUT_NORTHLEODE", EVENTS_STRAT_CLUT_NORTHLEODE, context);
		cm:save_value("EVENTS_STRAT_CLUT_CIRCENN", EVENTS_STRAT_CLUT_CIRCENN, context);
		cm:save_value("EVENTS_CIRCENN_ORKNEYAR", EVENTS_CIRCENN_ORKNEYAR, context);
		cm:save_value("EVENTS_CIRCENN_ORKNEYAR_TIMER", EVENTS_CIRCENN_ORKNEYAR_TIMER, context);
		cm:save_value("EVENTS_CIRCENN_KING", EVENTS_CIRCENN_KING, context);
		cm:save_value("EVENTS_CIRCENN_KING_INVESTIGATION", EVENTS_CIRCENN_KING_INVESTIGATION, context);
		cm:save_value("EVENTS_CIRCENN_KING_ATHFOCHLA", EVENTS_CIRCENN_KING_ATHFOCHLA, context);
		cm:save_value("EVENTS_CIRCENN_KING_STRAT_CLUT", EVENTS_CIRCENN_KING_STRAT_CLUT, context);
		cm:save_value("SACKED_SETTLEMENTS", SACKED_SETTLEMENTS, context);

		cm:save_value("EVENTS_NORTHLEODE_WESTMORINGAS", EVENTS_NORTHLEODE_WESTMORINGAS, context);
		cm:save_value("EVENTS_NORTHLEODE_BETRAYAL", EVENTS_NORTHLEODE_BETRAYAL, context);
		cm:save_value("EVENTS_NORTHLEODE_BOOKS", EVENTS_NORTHLEODE_BOOKS, context);
		cm:save_value("EVENTS_NORTHLEODE_KING_OF_NOTHING", EVENTS_NORTHLEODE_KING_OF_NOTHING, context);
		cm:save_value("EVENTS_NORTHLEODE_STRAT_CLUT", EVENTS_NORTHLEODE_STRAT_CLUT, context);
	end
);