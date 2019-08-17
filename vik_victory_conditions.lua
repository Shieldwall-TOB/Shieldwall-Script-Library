-------------------------------------------------------------------------------
------------------------- VICTORY CONDITIONS ----------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 06/06/2017 ------------------------
------------------------- Last Updated: 14/02/2018 by Craig -------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Scripted triggers for the various different victory-related stuffs in singleplayer.
-- The player needs to complete at least 1 long objective to trigger the end game.
-- The victories are stacked in such a way that a short objective will also be completed before a long can be completed.
-- Victory conditions tie into the end invasion script.

VICTORIES_SHORT = false;
VICTORIES_LONG = false;

function Add_Victory_Condition_Listeners()
	if cm:is_multiplayer() == false then
		output("#### Adding Singleplayer Victory Condition Listeners ####");
		cm:add_listener(
			"MissionSucceeded_Victory",
			"MissionSucceeded",
			true,
			function(context) VictoryConditionChecks(context) end,
			true
		);
	end
end

function VictoryConditionChecks(context)
	if context:mission():mission_record_key() == "vik_vc_kingdom_1" then
		if cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_circenn"), "alba");
		elseif cm:model():world():faction_by_key("vik_fact_mide"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_mide"), "temhair");
		elseif cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_west_seaxe"), "anglo_saxon");
		elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
            KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_mierce"), "anglo_saxon");
        elseif cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
            KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_northleode"), "anglo_saxon");
		elseif cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_east_engle"), "danelaw");
		elseif cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_northymbre"), "danelaw");
		elseif cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_gwined"), "wales");
		elseif cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_strat_clut"), "old_north");
		elseif cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_dyflin"), "irish_vikings");
		elseif cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_sudreyar"), "lochlann");
		end
		if VICTORIES_SHORT == false then
			VICTORIES_SHORT = true
			cm:register_instant_movie("vik_victory_kingdom_short"); 
		end
	elseif context:mission():mission_record_key() == "vik_vc_kingdom_2" then
		local long_victory_message = true
		if VICTORIES_LONG == true then
			long_victory_message = false
		end
		if cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_circenn"), "scotland", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_mide"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_mide"), "ireland", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_west_seaxe"), "england", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
            KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_mierce"), "england", long_victory_message);
        elseif cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
            KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_northleode"), "england", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_east_engle"), "north_sea_empire", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_northymbre"), "north_sea_empire", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_gwined"), "prydein", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_strat_clut"), "prydein", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_dyflin"), "norse_gaelic_sea", long_victory_message);
		elseif cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
			KingdomSetFounderFaction(cm:model():world():faction_by_key("vik_fact_sudreyar"), "norse_gaelic_sea", long_victory_message);
		end
		if VICTORIES_LONG == false then
			VICTORIES_LONG = true
			cm:register_instant_movie("vik_victory_kingdom_long");
		end
	elseif context:mission():mission_record_key() == "vik_vc_conquest_1" then
		if VICTORIES_SHORT == false then
			VICTORIES_SHORT = true
			cm:register_instant_movie("vik_victory_domination_short");
		end
		cm:trigger_incident(local_faction, "vik_incident_short_victory_conquest", true);
	elseif context:mission():mission_record_key() == "vik_vc_conquest_2" then
		if VICTORIES_LONG == false then
			VICTORIES_LONG = true
			cm:register_instant_movie("vik_victory_domination_long"); 
			cm:trigger_incident(local_faction, "vik_incident_invasion_end_1_conquest", true);
		else
			cm:trigger_incident(local_faction, "vik_incident_long_victory_conquest", true);
		end
	elseif context:mission():mission_record_key() == "vik_vc_fame_1" then
		if VICTORIES_SHORT == false then
			VICTORIES_SHORT = true
			cm:register_instant_movie("vik_victory_fame_short"); 
		end
		cm:trigger_incident(local_faction, "vik_incident_short_victory_fame", true);
	elseif context:mission():mission_record_key() == "vik_vc_fame_2" then
		if VICTORIES_LONG == false then
			VICTORIES_LONG = true
			cm:register_instant_movie("vik_victory_fame_long");
			cm:trigger_incident(local_faction, "vik_incident_invasion_end_1_fame", true);
		else
			cm:trigger_incident(local_faction, "vik_incident_long_victory_fame", true);
		end
	elseif context:mission():mission_record_key() == "vik_vc_invasion" then
		cm:register_instant_movie("vik_victory_ultimate"); 
	end
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		VICTORIES_SHORT = cm:load_value("VICTORIES_SHORT", false, context);
		VICTORIES_LONG = cm:load_value("VICTORIES_LONG", false, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("VICTORIES_SHORT", VICTORIES_SHORT, context);
		cm:save_value("VICTORIES_LONG", VICTORIES_LONG, context);
	end
);