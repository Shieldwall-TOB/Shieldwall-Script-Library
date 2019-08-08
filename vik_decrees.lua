-------------------------------------------------------------------------------
------------------------- DECREES ---------------------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 17/07/2018 ------------------------
------------------------- Last Updated: 22/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- The decrees are a selection of four choices for each faction, with each option giving a unique effect or event chain.
-- The majority of these are incidents with timed effect bundles, though the Expeditions are also tied into this mechanic.
-- Many decrees will have unique scripted conditions to unlock them, similar to the technology panel.
-- Script is going to handle the locking/unlocking of these, as well as triggering the events when the buttons are selected.

-- TO DO LIST
-- Scripted lock/unlock conditions
-- Customise costs based on each decree
-- Work how to script influence costs

-- This list is used to find and fire the events when buttons are clicked in the decrees panel
DECREE_LIST = {
	["vik_fact_west_seaxe"] = {
		[1] = {
			["event"] = "sw_decree_wessex_ad_hoc_levy",
			["duration"] = 10,
			["gold_cost"] = -2000,
			["currency"] = "influence",
			["currency_cost"] = -1,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "sw_decree_wessex_fyrd",
			["duration"] = 10,
			["gold_cost"] = -2000,
			["currency"] = "influence",
			["currency_cost"] = -1,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[3] = {
			["event"] = "sw_decree_wessex_scholarship",
			["duration"] = 10,
			["gold_cost"] = -2000,
			["currency"] = "influence",
			["currency_cost"] = -1,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[4] = {
			["event"] = "sw_decree_wessex_witan",
			["duration"] = 10,
			["gold_cost"] = 0,
			["currency"] = "influence",
			["currency_cost"] = -2,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		["global_cooldown"] = 0,
		["global_cooldown_current"] = 0,
		["zero_cost_timer_current"] = 0,
		["zero_cost_timer"] = 10,
		["cooldown_tech"] = "vik_westsexa_civ_leader_6"
	},
	["vik_fact_mierce"] = {
		[1] = {
			["event"] = "sw_decree_mierce_warriors",
			["duration"] = 10,
			["gold_cost"] = 0,
			["currency"] = "fyrd",
			["currency_cost"] = -1,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = false,
			["locked_counter"] = 0,
			["locked_target"] = 40
		},
		[2] = {
			["event"] = "sw_decree_mierce_lords",
			["duration"] = 10,
			["gold_cost"] = 0,
			["currency"] = "fyrd",
			["currency_cost"] = -1,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = false,
			["locked_counter"] = 0,
			["locked_target"] = 5
		},
		[3] = {
			["event"] = "sw_decree_mierce_church",
			["duration"] = 10,
			["gold_cost"] = 0,
			["currency"] = "fyrd",
			["currency_cost"] = -1,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[4] = {
			["event"] = "sw_decree_mierce_pay_hoards",
			["duration"] = 10,
			["gold_cost"] = -5000,
			["currency"] = "fyrd",
			["currency_cost"] = 1,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		["global_cooldown"] = 0,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_miercna_civ_leader_6",
		["current_hoards"] = 1,
		["max_hoards"] = 3
	},
	["vik_fact_northleode"] = {
		[1] = {
			["event"] = "sw_decree_northleode_eoferwic",
			["duration"] = 6,
			["gold_cost"] = -1000,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_region"] = "vik_reg_eoferwic"
		},
		[2] = {
			["event"] = "sw_decree_northleode_tamworthige",
			["duration"] = 6,
			["gold_cost"] = -1500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_region"] = "vik_reg_tamworthige"
		},
		[3] = {
			["event"] = "sw_decree_northleode_dun_foither",
			["duration"] = 6,
			["gold_cost"] = -1200,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_region"] = "vik_reg_dun_foither"
		},
		[4] = {
			["event"] = "sw_decree_northleode_bebbanburg",
			["duration"] = 6,
			["gold_cost"] = -750,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 10,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		["global_cooldown"] = 5,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_miercna_civ_leader_6",
		["confederation_enabled"] = false,
		["turn_disable_confed"] = 0
	},
	["vik_fact_dyflin"] = {
		[1] = {
			["event"] = "vik_sea_king_expedition_1",
			["duration"] = 0,
			["gold_cost"] = -2500,
			["currency"] = "slaves",
			["currency_cost"] = -2500,
			["cooldown"] = 24,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[2] = {
			["event"] = "vik_incident_decree_new_laws",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[3] = {
			["event"] = "vik_incident_decree_civic_support",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[4] = {
			["event"] = "vik_incident_decree_supplies_for_army",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 10
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_dyflin_civ_leader_6"
	},
	["vik_fact_sudreyar"] = {
		[1] = {
			["event"] = "vik_sea_king_expedition_1",
			["duration"] = 0,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 24,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[2] = {
			["event"] = "vik_incident_decree_new_laws",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[3] = {
			["event"] = "vik_incident_decree_civic_support",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[4] = {
			["event"] = "vik_incident_decree_supplies_for_army",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "tribute",
			["currency_cost"] = -20,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 10
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_sudreyar_civ_leader_6"
	},
	["vik_fact_east_engle"] = {
		[1] = {
			["event"] = "vik_incident_decree_new_laws",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_civic_support_here_king",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "english",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 35
		},
		[3] = {
			["event"] = "vik_incident_decree_supplies_for_army_here_king",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "army",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 10
		},
		[4] = {
			["event"] = "vik_incident_decree_support_church",
			["duration"] = 3,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_civ_leader_6_here_king"
	},
	["vik_fact_northymbre"] = {
		[1] = {
			["event"] = "vik_incident_decree_new_laws",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_civic_support_here_king",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "english",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 25
		},
		[3] = {
			["event"] = "vik_incident_decree_supplies_for_army_here_king",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "army",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 10
		},
		[4] = {
			["event"] = "vik_incident_decree_support_church",
			["duration"] = 3,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_civ_leader_6_here_king"
	},
	["vik_fact_gwined"] = {
		[1] = {
			["event"] = "vik_incident_decree_compose_poem",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_honour_church",
			["duration"] = 3,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[3] = {
			["event"] = "vik_incident_decree_infrastructure",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 20
		},
		[4] = {
			["event"] = "vik_incident_decree_supplies_for_army",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 40
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_gwined_civ_leader_6"
	},
	["vik_fact_strat_clut"] = {
		[1] = {
			["event"] = "vik_incident_decree_compose_poem",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_honour_church",
			["duration"] = 3,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[3] = {
			["event"] = "vik_incident_decree_infrastructure",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 20
		},
		[4] = {
			["event"] = "vik_incident_decree_supplies_for_army",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "influence",
			["currency_cost"] = 0,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 40
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_stratclut_civ_leader_6"
	},
	["vik_fact_mide"] = {
		[1] = {
			["event"] = "vik_incident_decree_honour_dead",
			["duration"] = 4,
			["gold_cost"] = -1250,
			["currency"] = "legitimacy",
			["currency_cost"] = -3,
			["cooldown"] = 8,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_new_laws_fair",
			["duration"] = 4,
			["gold_cost"] = -1250,
			["currency"] = "legitimacy",
			["currency_cost"] = -3,
			["cooldown"] = 8,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[3] = {
			["event"] = "vik_incident_decree_hold_games",
			["duration"] = 4,
			["gold_cost"] = -1250,
			["currency"] = "legitimacy",
			["currency_cost"] = -3,
			["cooldown"] = 8,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[4] = {
			["event"] = "vik_incident_decree_honour_troops",
			["duration"] = 4,
			["gold_cost"] = -1250,
			["currency"] = "legitimacy",
			["currency_cost"] = -3,
			["cooldown"] = 8,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 10
		},
		["global_cooldown"] = 4,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_irish_civ_leader_6"
	},
	["vik_fact_circenn"] = {
		[1] = {
			["event"] = "vik_incident_decree_new_laws",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "legitimacy",
			["currency_cost"] = -5,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = false
		},
		[2] = {
			["event"] = "vik_incident_decree_infrastructure",
			["duration"] = 5,
			["gold_cost"] = -2500,
			["currency"] = "legitimacy",
			["currency_cost"] = -5,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 25
		},
		[3] = {
			["event"] = "vik_incident_decree_supplies_for_army",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "legitimacy",
			["currency_cost"] = -5,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true
		},
		[4] = {
			["event"] = "vik_incident_decree_honour_nobles",
			["duration"] = 10,
			["gold_cost"] = -2500,
			["currency"] = "legitimacy",
			["currency_cost"] = -5,
			["cooldown"] = 20,
			["cooldown_current"] = 0,
			["locked"] = true,
			["locked_counter"] = 0,
			["locked_target"] = 5
		},
		["global_cooldown"] = 10,
		["global_cooldown_current"] = 0,
		["cooldown_tech"] = "vik_scots_civ_leader_6"
	}
};

-- Listeners~
function Add_Decrees_Listeners()
	cm:add_listener(
		"PanelOpenedCampaignDecrees",
		"PanelOpenedCampaign",
		function(context) return context.string == "decrees_panel" end,
		function(context) 
			DECREES_PANEL = context.component;
			DecreesUpdateDecreesPanel();
		end,
		true
	)
	cm:add_listener(
		"PanelClosedCampaignDecrees",
		"PanelClosedCampaign",
		function(context) return context.string == "diplomacy_dropdown" end,
		function() DecreesAlertIcon(cm:model():world():whose_turn_is_it():name()) end,
		true
	);
	cm:add_listener(
		"BuildingConstructionIssuedByPlayerDecrees",
		"BuildingConstructionIssuedByPlayer",
		true,
		function() DecreesAlertIcon(cm:model():world():whose_turn_is_it():name()) end,
		true
	)
	cm:add_listener(
		"ComponentLClickUpDecrees",
		"ComponentLClickUp", 
		function(context) return context.string == "button_enact" end,
		function(context) 
			local parent = UIComponent(context.component):Parent()
			DecreesTriggerEvent(parent)
		end, 
		true
	);
	cm:add_listener(
		"FactionTurnStartDecrees",
		"FactionTurnStart",
		function(context) return context:faction():is_human() end,
		function(context) DecreesDecreaseCooldown(context) end,
		true
	);
	cm:add_listener(
		"UnitTrainedDecrees",
		"UnitTrained",
		true,
		function(context) DecreesUnitRecruited(context:unit():faction():name()) end,
		true
	);
	cm:add_listener(
		"BattleCompletedDecrees",
		"BattleCompleted",
		true,
		function(context) DecreesBattleCompleted(context) end,
		true
	);
	cm:add_listener(
		"IncidentOccuredEventDecrees",
		"IncidentOccuredEvent",
		true,
		function(context) DecreesPayment(context:faction():name(), context:dilemma()) end,
		true
	);
	cm:add_listener(
		"DilemmaIssuedEventDecrees",
		"DilemmaIssuedEvent",
		true,
		function(context) DecreesPayment(context:faction():name(), context:dilemma()) end,
		true
	);
	
	DecreesAlertIcon(cm:model():world():whose_turn_is_it():name())
	if get_faction("vik_fact_mierce"):is_human() then
		update_hoards()
	end
	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do 
		local faction = faction_list:item_at(i)
		if faction:subculture() == "vik_sub_cult_english" and (not DECREE_LIST[faction:name()]["confederation_enabled"]) then
			enable_confed(faction:name(), false)
		end
	end
end

local function enable_confed(faction, enable)
	local faction_list = cm:model():world():faction_list();
	for j = 0, faction_list:num_items() - 1 do
		local temp_faction = faction_list:item_at(j)
		
		if temp_faction:name() ~= faction and temp_faction:subculture() == get_faction(faction):subculture() then
			cm:force_diplomacy(faction, temp_faction:name(), "form confederation", enable, enable);
			cm:force_diplomacy(temp_faction:name(), faction, "form confederation", enable, enable);
		end
	end
end

function update_hoards(new_value)
	local mierce = get_faction("vik_fact_mierce")
	local mierce_decrees = DECREE_LIST["vik_fact_mierce"]
	local current_hoards = mierce_decrees["current_hoards"]
	if new_value and new_value ~= current_hoards then
		if mierce:has_effect_bundle("sw_hoards_"..current_hoards) then
			cm:remove_effect_bundle("sw_hoards_"..current_hoards, "vik_fact_mierce")
		end
		DECREE_LIST["vik_fact_mierce"]["current_hoards"] = new_value
		cm:apply_effect_bundle("sw_hoards_"..new_value, "vik_fact_mierce", 0)
	else
		if not mierce:has_effect_bundle("sw_hoards_"..current_hoards) then
			cm:apply_effect_bundle("sw_hoards_"..current_hoards, "vik_fact_mierce", 0)
		end
	end
end


function apply_decrees_effect(faction, index, event)
	dev.log("scripted effect for faction ["..faction.."] from decree ["..index.."] and event ["..event.."] ")
	--TODO wessex scripted effects
	--TODO mierce scripted effects

	--northleode scripted effects
	if faction == "vik_fact_northleode" and event == "sw_decree_northleode_tamworthige" then
		DECREE_LIST[faction]["turn_disable_confed"] = cm:model():turn_number() + 6
		DECREE_LIST[faction]["confederation_enabled"] = true
		enable_confed(faction, true)
	end
end


-- Deduct the costs and update scripted currencies for enacting the decree
function DecreesPayment(faction, event)

	for i = 1,4 do
		if DECREE_LIST[faction][i]["event"] == event then
			if (not DECREE_LIST[faction]["zero_cost_timer_current"]) or DECREE_LIST[faction]["zero_cost_timer_current"] == 0 then
				cm:treasury_mod(faction, DECREE_LIST[faction][i]["gold_cost"]);
			end
			apply_decrees_effect(faction, i, event)
			if faction == "vik_fact_mierce" then
				update_hoards(DECREE_LIST[faction]["current_hoards"] + DECREE_LIST[faction][i]["currency_cost"])
			elseif faction == "vik_fact_dyflin" then
				if DECREE_LIST[faction][i]["currency"] == "slaves" then
					DYFLIN_SLAVES = DYFLIN_SLAVES + DECREE_LIST[faction][i]["currency_cost"]
					UpdateDyflinBar("vik_fact_dyflin");
				elseif DECREE_LIST[faction][i]["currency"] == "tribute" then
					SK_TRIBUTE = SK_TRIBUTE + DECREE_LIST[faction][i]["currency_cost"];
					SK_TRIBUTE_DECREES = SK_TRIBUTE_DECREES + DECREE_LIST[faction][i]["currency_cost"];
					SeaKingTributeCheck("vik_fact_dyflin");
				end
			elseif faction == "vik_fact_sudreyar" then
				SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + DECREE_LIST[faction][i]["currency_cost"];
				SK_TRIBUTE_DECREES_SUD = SK_TRIBUTE_DECREES_SUD + DECREE_LIST[faction][i]["currency_cost"];
				SudreyarTributeCheck("vik_fact_sudreyar");
			elseif faction == "vik_fact_east_engle" or faction == "vik_fact_northymbre" then
				if DECREE_LIST[faction][i]["currency"] == "english" then
					HERE_KING[faction]["level"] = HERE_KING[faction]["level"] - 1;
					HERE_KING[faction]["breakdown"]["decrees"] = HERE_KING[faction]["breakdown"]["decrees"] - 1;
					HereKingChecks();
				elseif DECREE_LIST[faction][i]["currency"] == "army" then
					HERE_KING[faction]["level"] = HERE_KING[faction]["level"] + 1;
					HERE_KING[faction]["breakdown"]["decrees"] = HERE_KING[faction]["breakdown"]["decrees"] + 1;
					HereKingChecks();
				end
			elseif faction == "vik_fact_mide" then
				G_LEGITIMACY = G_LEGITIMACY + DECREE_LIST[faction][i]["currency_cost"];
				G_LEGITIMACY_FAIR = G_LEGITIMACY_FAIR + DECREE_LIST[faction][i]["currency_cost"];
				GaelicLegitimacyCheck(faction);
			elseif faction == "vik_fact_circenn" then
				SCOT_LEGITIMACY = SCOT_LEGITIMACY + DECREE_LIST[faction][i]["currency_cost"];
				SCOT_LEGITIMACY_DECREES = SCOT_LEGITIMACY_DECREES + DECREE_LIST[faction][i]["currency_cost"];
				ScotsLegitimacyCheck(faction);
			elseif faction == "vik_fact_gwined" and event == "vik_incident_decree_compose_poem" then
				W_HEROISM = W_HEROISM + 10;
				W_HEROISM_DECREES = W_HEROISM_DECREES + 10;
				WelshHeroismCheck(faction);			
			elseif faction == "vik_fact_strat_clut" and event == "vik_incident_decree_compose_poem" then
				W_HEROISM_STR = W_HEROISM_STR + 10;
				W_HEROISM_DECREES_STR = W_HEROISM_DECREES_STR + 10;
				StratClutHeroismCheck(faction);	
			end
		end
	end
	
	--Call the icon function to disable the alert
	DecreesAlertIcon(faction)	
	
end

local function can_faction_afford_decree_number(faction, index)
	local decree = DECREE_LIST[faction][index]
	if DECREE_LIST[faction]["zero_cost_timer_current"] and DECREE_LIST[faction]["zero_cost_timer_current"] > 0 then
		--decree is free, it can always be afforded
		return true
	end
	--else, return if they have enough treasury.
	return (get_faction(faction):treasury() >= (0 - DECREE_LIST[faction][index]["gold_cost"]))
end


-- Decreases cooldown and global cooldown for decrees at the start of the faction's turn
function DecreesDecreaseCooldown(context)

	local faction = context:faction():name()
	
	--Halves the global cooldown if the relevant tech is unlocked
	if DECREE_LIST[faction]["cooldown_tech"] ~= nil and get_faction(faction):has_technology(DECREE_LIST[faction]["cooldown_tech"]) then
		for i = 1,4 do
			DECREE_LIST[faction][i]["cooldown"] = math.floor(DECREE_LIST[faction][i]["cooldown"] / 2);
			if DECREE_LIST[faction][i]["cooldown_current"] > 0 then
				DECREE_LIST[faction][i]["cooldown_current"] = DECREE_LIST[faction][i]["cooldown_current"] - DECREE_LIST[faction][i]["cooldown"];
				if DECREE_LIST[faction][i]["cooldown_current"] < 0 then
					DECREE_LIST[faction][i]["cooldown_current"] = 0;
				end
			end
		end
		DECREE_LIST[faction]["cooldown_tech"] = nil;
	end
	
	--Reduces the existing cooldown
	if DECREE_LIST[faction]["global_cooldown_current"] > 0 then
		DECREE_LIST[faction]["global_cooldown_current"] = DECREE_LIST[faction]["global_cooldown_current"] - 1
	end
	if DECREE_LIST[faction]["zero_cost_timer_current"] > 0 then
		DECREE_LIST[faction]["zero_cost_timer_current"] = DECREE_LIST[faction]["zero_cost_timer_current"] - 1
	end
	for i = 1,4 do
		if DECREE_LIST[faction][i]["cooldown_current"] > 0 then
			DECREE_LIST[faction][i]["cooldown_current"] = DECREE_LIST[faction][i]["cooldown_current"] - 1
		end
	end
	if DECREE_LIST[faction]["confederation_enabled"] and DECREE_LIST[faction]["turn_disable_confed"] and DECREE_LIST[faction]["turn_disable_confed"] <= cm:model():turn_number() then
		enable_confed(faction, false)
		DECREE_LIST[faction]["confederation_enabled"] = false
	end
	DecreesAlertIcon(faction)
end

-- Checks if any decrees are available, and updates the icon on the button
function DecreesAlertIcon(faction)
	
	DecreesUnlocks(faction)
	
	if find_uicomponent(cm:ui_root(), "button_decrees"):CurrentState() == "active" then
		local alert_icon = false;
		if DECREE_LIST[faction]["global_cooldown_current"] == 0 then
			for i=1,4 do
				if DECREE_LIST[faction][i]["locked"] == false and DECREE_LIST[faction][i]["cooldown_current"] == 0 and can_faction_afford_decree_number(faction, i) then
					if DECREE_LIST[faction][i]["currency"] == "influence" and get_faction(faction):faction_leader():gravitas() >= (0 - DECREE_LIST[faction][i]["currency_cost"]) then
						alert_icon = true;
						break;
					elseif faction == "vik_fact_dyflin" then
						if DECREE_LIST[faction][i]["currency"] == "slaves" and DYFLIN_SLAVES >= (0 - DECREE_LIST[faction][i]["currency_cost"]) then
							alert_icon = true;
							break;
						elseif DECREE_LIST[faction][i]["currency"] == "tribute" and SK_TRIBUTE >= (0 - DECREE_LIST[faction][i]["currency_cost"]) then
							alert_icon = true;
							break;
						end
					elseif faction == "vik_fact_sudreyar" then
						if DECREE_LIST[faction][i]["currency"] == "tribute" and SK_TRIBUTE_SUD >= (0 - DECREE_LIST[faction][i]["currency_cost"]) then
							alert_icon = true;
							break;
						end
					elseif faction == "vik_fact_mide" then
						if DECREE_LIST[faction][i]["currency"] == "legitimacy" and G_LEGITIMACY >= (0 - DECREE_LIST[faction][i]["currency_cost"]) and (cm:model():turn_number() - 2) % 4 == 0 then
							alert_icon = true;
							break;
						end
					elseif faction == "vik_fact_circenn" then
						if DECREE_LIST[faction][i]["currency"] == "legitimacy" and SCOT_LEGITIMACY >= (0 - DECREE_LIST[faction][i]["currency_cost"]) then
							alert_icon = true;
							break;
						end
					else
						alert_icon = true;
						break;
					end
				end
			end
		end
		if alert_icon == true then
			find_uicomponent(cm:ui_root(), "decrees_alert_icon"):SetVisible(true);
		else
			find_uicomponent(cm:ui_root(), "decrees_alert_icon"):SetVisible(false);
		end
	end
	
end

-- Triggers the correct events when the enact button is clicked, and sets the cooldown values
function DecreesTriggerEvent(parent)

	local id = tonumber(string.match(UIComponent(parent):Id(), "%d+"));
	output("decree id = "..id)
	local faction = cm:model():world():whose_turn_is_it():name();
	local event = DECREE_LIST[faction][id]["event"];
	if event == "vik_sea_king_expedition_1" then
		UIComponent(DECREES_PANEL):InterfaceFunction("TriggerDilemma", event);
	else
		UIComponent(DECREES_PANEL):InterfaceFunction("TriggerIncident", event);
	end		
	DECREE_LIST[faction]["global_cooldown_current"] = DECREE_LIST[faction]["global_cooldown"];
	DECREE_LIST[faction][id]["cooldown_current"] = DECREE_LIST[faction][id]["cooldown"];
	
end


--Sets all the values for the variables on the decrees panel using the scripted variables
function DecreesUpdateDecreesPanel()
	
	local faction = cm:model():world():whose_turn_is_it():name();
	
	--Check unlocks for the locked decrees
	DecreesUnlocks(faction)
	for i = 1,4 do
		local template = UIComponent(DECREES_PANEL):Find("vik_decree_"..string.sub(faction, 10).."_"..i);
		UIComponent(UIComponent(template):Find("button_enact")):SetState("inactive");
		if DECREE_LIST[faction]["global_cooldown_current"] > 0 and DECREE_LIST[faction]["global_cooldown_current"] > DECREE_LIST[faction][i]["cooldown_current"] then
			UIComponent(UIComponent(UIComponent(template):Find("button_enact")):Find("turns_corner")):SetVisible(true);
			UIComponent(UIComponent(UIComponent(template):Find("button_enact")):Find("turns_corner")):SetStateText(DECREE_LIST[faction]["global_cooldown_current"]);
		elseif DECREE_LIST[faction][i]["cooldown_current"] > 0 then
			UIComponent(UIComponent(UIComponent(template):Find("button_enact")):Find("turns_corner")):SetVisible(true);	
			UIComponent(UIComponent(UIComponent(template):Find("button_enact")):Find("turns_corner")):SetStateText(DECREE_LIST[faction][i]["cooldown_current"]);
		else
			UIComponent(UIComponent(UIComponent(template):Find("button_enact")):Find("turns_corner")):SetVisible(false)
		end
		UIComponent(UIComponent(template):Find("dy_value")):SetStateText(DECREE_LIST[faction][i]["gold_cost"]);
		if DECREE_LIST[faction]["zero_cost_timer_current"] and DECREE_LIST[faction]["zero_cost_timer_current"] > 0 then
			UIComponent(UIComponent(template):Find("dy_value")):SetStateText("0");
		end
		if DECREE_LIST[faction][i]["currency_cost"] == 0 then
			UIComponent(UIComponent(template):Find("other_cost")):SetVisible(false);
		else
			UIComponent(UIComponent(template):Find("other_cost")):SetVisible(true);
			UIComponent(UIComponent(template):Find("other_cost")):SetStateText(DECREE_LIST[faction][i]["currency_cost"]);
			UIComponent(UIComponent(template):Find("currency_icon")):SetState(DECREE_LIST[faction][i]["currency"]);			
		end
		if DECREE_LIST[faction][i]["duration"] == 0 then
			UIComponent(UIComponent(template):Find("duration")):SetVisible(false);
		else
			UIComponent(UIComponent(template):Find("duration")):SetVisible(true);
			UIComponent(UIComponent(UIComponent(template):Find("duration")):Find("turns_corner")):SetStateText(DECREE_LIST[faction][i]["duration"]);
		end
		UIComponent(UIComponent(UIComponent(template):Find("cooldown")):Find("turns_corner")):SetStateText(DECREE_LIST[faction][i]["cooldown"]);
		if DECREE_LIST[faction][i]["locked"] == true then
			UIComponent(UIComponent(template):Find("dy_condition")):SetState("active");
			local condition_string = UIComponent(UIComponent(template):Find("dy_condition")):GetStateText();
			if string.find(condition_string, "%d") ~= nil then
				condition_string = string.gsub(condition_string, "%%d1", DECREE_LIST[faction][i]["locked_target"]);
				condition_string = string.gsub(condition_string, "%%d2", DECREE_LIST[faction][i]["locked_counter"]);
				UIComponent(UIComponent(template):Find("dy_condition")):SetStateText(condition_string);
			end
		elseif DECREE_LIST[faction]["global_cooldown_current"] > DECREE_LIST[faction][i]["cooldown_current"] then
			UIComponent(UIComponent(template):Find("dy_condition")):SetState("global_cooldown");
		elseif DECREE_LIST[faction][i]["cooldown_current"] > 0 then
			UIComponent(UIComponent(template):Find("dy_condition")):SetState("cooldown");
		else
			local can_afford = false
			if not can_faction_afford_decree_number(faction, i) then
				UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
			elseif DECREE_LIST[faction][i]["currency"] == "influence" and get_faction(faction):faction_leader():gravitas() < (0 - DECREE_LIST[faction][i]["currency_cost"]) then
				UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
			elseif faction == "vik_fact_dyflin" then
				if DECREE_LIST[faction][i]["currency"] == "slaves" and DYFLIN_SLAVES < (0 - DECREE_LIST[faction][i]["currency_cost"]) then
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
				elseif DECREE_LIST[faction][i]["currency"] == "tribute" and SK_TRIBUTE < (-10 - DECREE_LIST[faction][i]["currency_cost"]) then
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
				else
					can_afford = true;
				end
			elseif faction == "vik_fact_sudreyar" then
				if DECREE_LIST[faction][i]["currency"] == "tribute" and SK_TRIBUTE_SUD < (-10 - DECREE_LIST[faction][i]["currency_cost"]) then
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
				else
					can_afford = true;
				end
			elseif faction == "vik_fact_mide" then
				if DECREE_LIST[faction][i]["currency"] == "legitimacy" and G_LEGITIMACY < (-60 - DECREE_LIST[faction][i]["currency_cost"]) then
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
				elseif (cm:model():turn_number() - 2) % 4 == 0 then
					can_afford = true;
				else
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("not_summer");
				end
			elseif faction == "vik_fact_circenn" then
				if DECREE_LIST[faction][i]["currency"] == "legitimacy" and SCOT_LEGITIMACY < (-60 - DECREE_LIST[faction][i]["currency_cost"]) then
					UIComponent(UIComponent(template):Find("dy_condition")):SetState("too_expensive");
				else
					can_afford = true;
				end
			else
				can_afford = true;
			end
			if can_afford == true then
				UIComponent(UIComponent(template):Find("dy_condition")):SetState("unlocked");
				UIComponent(UIComponent(template):Find("button_enact")):SetState("active");
			end
		end
	end
	
end

-----------------------------------------
---------------- UNLOCKS ----------------
-----------------------------------------

-- Checks all the scripted conditions for decrees and unlocks them if necessary.
function DecreesUnlocks(faction)

	if faction == "vik_fact_west_seaxe" then
		if DECREE_LIST[faction][3]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_great_hall_5") then
					DECREE_LIST[faction][3]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] then
			if faction == TECH_PLAYER_1["faction_name"] then
				if TECH_PLAYER_1["army_locked"] == false or TECH_PLAYER_1["farm_locked"] == false or TECH_PLAYER_1["industry_locked"] == false or TECH_PLAYER_1["leader_locked"] == false or TECH_PLAYER_1["market_locked"] == false or TECH_PLAYER_1["religion_locked"] == false or TECH_PLAYER_1["bodyguard_locked"] == false or TECH_PLAYER_1["cap_1_locked"] == false or TECH_PLAYER_1["cap_2_locked"] == false or TECH_PLAYER_1["cap_3_locked"] == false or TECH_PLAYER_1["cap_4_locked"] == false or TECH_PLAYER_1["cavalry_2_locked"] == false or TECH_PLAYER_1["land_locked"] == false or TECH_PLAYER_1["melee_locked"] == false or TECH_PLAYER_1["missile_1_locked"] == false or TECH_PLAYER_1["siege_locked"] == false or TECH_PLAYER_1["spearmen_1_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			elseif faction == TECH_PLAYER_2["faction_name"] then
				if TECH_PLAYER_2["army_locked"] == false or TECH_PLAYER_2["farm_locked"] == false or TECH_PLAYER_2["industry_locked"] == false or TECH_PLAYER_2["leader_locked"] == false or TECH_PLAYER_2["market_locked"] == false or TECH_PLAYER_2["religion_locked"] == false or TECH_PLAYER_2["bodyguard_locked"] == false or TECH_PLAYER_2["cap_1_locked"] == false or TECH_PLAYER_2["cap_2_locked"] == false or TECH_PLAYER_2["cap_3_locked"] == false or TECH_PLAYER_2["cap_4_locked"] == false or TECH_PLAYER_2["cavalry_2_locked"] == false or TECH_PLAYER_2["land_locked"] == false or TECH_PLAYER_2["melee_locked"] == false or TECH_PLAYER_2["missile_1_locked"] == false or TECH_PLAYER_2["siege_locked"] == false or TECH_PLAYER_2["spearmen_1_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			end
		end	
	elseif faction == "vik_fact_mierce" then
		if DECREE_LIST[faction][1]["locked"] and DECREE_LIST[faction][1]["locked_counter"] >= DECREE_LIST[faction][1]["locked_target"] then
			DECREE_LIST[faction][1]["locked"] = false;
		end
		if DECREE_LIST[faction][2]["locked"] then
			for i = 0, get_faction(faction):character_list():num_items() - 1 do
				if get_faction(faction):character_list():item_at(i):rank() >= DECREE_LIST[faction][2]["locked_target"] then
					DECREE_LIST[faction][2]["locked"] = false;
					break;
				elseif get_faction(faction):character_list():item_at(i):rank() > DECREE_LIST[faction][2]["locked_counter"] then
					DECREE_LIST[faction][2]["locked_counter"] = get_faction(faction):character_list():item_at(i):rank();
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_church_3") or get_faction(faction):region_list():item_at(i):building_exists("vik_benedictine_abbey_5") then
					DECREE_LIST[faction][4]["locked"] = false;
					break;
				end
			end
		end
	elseif faction == "vik_fact_dyflin" then
		if DECREE_LIST[faction][1]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_port_military_3") then
					DECREE_LIST[faction][1]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] and DECREE_LIST[faction][4]["locked_counter"] >= DECREE_LIST[faction][4]["locked_target"] then
			DECREE_LIST[faction][4]["locked"] = false;
		end
	elseif faction == "vik_fact_sudreyar" then
		if DECREE_LIST[faction][1]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_port_fish_3") or get_faction(faction):region_list():item_at(i):building_exists("vik_port_herring_3") then
					DECREE_LIST[faction][1]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] and DECREE_LIST[faction][4]["locked_counter"] >= DECREE_LIST[faction][4]["locked_target"] then
			DECREE_LIST[faction][4]["locked"] = false;
		end
	elseif faction == "vik_fact_east_engle" then
		if DECREE_LIST[faction][2]["locked"] and get_faction(faction):region_list():num_items() >= DECREE_LIST[faction][2]["locked_target"] then
			DECREE_LIST[faction][2]["locked"] = false;
		else
			DECREE_LIST[faction][2]["locked_counter"] = get_faction(faction):region_list():num_items();
		end
		if DECREE_LIST[faction][3]["locked"] and DECREE_LIST[faction][3]["locked_counter"] >= DECREE_LIST[faction][3]["locked_target"] then
			DECREE_LIST[faction][3]["locked"] = false;
		end
		if DECREE_LIST[faction][4]["locked"] then
			if faction == TECH_PLAYER_1["faction_name"] then
				if TECH_PLAYER_1["army_locked"] == false or TECH_PLAYER_1["farm_locked"] == false or TECH_PLAYER_1["industry_locked"] == false or TECH_PLAYER_1["leader_locked"] == false or TECH_PLAYER_1["market_locked"] == false or TECH_PLAYER_1["religion_locked"] == false or TECH_PLAYER_1["bodyguard_locked"] == false or TECH_PLAYER_1["cap_1_locked"] == false or TECH_PLAYER_1["cap_2_locked"] == false or TECH_PLAYER_1["cap_3_locked"] == false or TECH_PLAYER_1["cap_4_locked"] == false or TECH_PLAYER_1["cavalry_2_locked"] == false or TECH_PLAYER_1["land_locked"] == false or TECH_PLAYER_1["melee_locked"] == false or TECH_PLAYER_1["missile_1_locked"] == false or TECH_PLAYER_1["siege_locked"] == false or TECH_PLAYER_1["spearmen_2_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			elseif faction == TECH_PLAYER_2["faction_name"] then
				if TECH_PLAYER_2["army_locked"] == false or TECH_PLAYER_2["farm_locked"] == false or TECH_PLAYER_2["industry_locked"] == false or TECH_PLAYER_2["leader_locked"] == false or TECH_PLAYER_2["market_locked"] == false or TECH_PLAYER_2["religion_locked"] == false or TECH_PLAYER_2["bodyguard_locked"] == false or TECH_PLAYER_2["cap_1_locked"] == false or TECH_PLAYER_2["cap_2_locked"] == false or TECH_PLAYER_2["cap_3_locked"] == false or TECH_PLAYER_2["cap_4_locked"] == false or TECH_PLAYER_2["cavalry_2_locked"] == false or TECH_PLAYER_2["land_locked"] == false or TECH_PLAYER_2["melee_locked"] == false or TECH_PLAYER_2["missile_1_locked"] == false or TECH_PLAYER_2["siege_locked"] == false or TECH_PLAYER_2["spearmen_2_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			end
		end		
	elseif faction == "vik_fact_northymbre" then
		if DECREE_LIST[faction][2]["locked"] and get_faction(faction):region_list():num_items() >= DECREE_LIST[faction][2]["locked_target"] then
			DECREE_LIST[faction][2]["locked"] = false;
		else
			DECREE_LIST[faction][2]["locked_counter"] = get_faction(faction):region_list():num_items();
		end
		if DECREE_LIST[faction][3]["locked"] and DECREE_LIST[faction][3]["locked_counter"] >= DECREE_LIST[faction][3]["locked_target"] then
			DECREE_LIST[faction][3]["locked"] = false;
		end
		if DECREE_LIST[faction][4]["locked"] then
			if faction == TECH_PLAYER_1["faction_name"] then
				if TECH_PLAYER_1["army_locked"] == false or TECH_PLAYER_1["farm_locked"] == false or TECH_PLAYER_1["industry_locked"] == false or TECH_PLAYER_1["leader_locked"] == false or TECH_PLAYER_1["market_locked"] == false or TECH_PLAYER_1["religion_locked"] == false or TECH_PLAYER_1["bodyguard_locked"] == false or TECH_PLAYER_1["cap_1_locked"] == false or TECH_PLAYER_1["cap_2_locked"] == false or TECH_PLAYER_1["cap_3_locked"] == false or TECH_PLAYER_1["cap_4_locked"] == false or TECH_PLAYER_1["cavalry_2_locked"] == false or TECH_PLAYER_1["land_locked"] == false or TECH_PLAYER_1["melee_locked"] == false or TECH_PLAYER_1["missile_1_locked"] == false or TECH_PLAYER_1["siege_locked"] == false or TECH_PLAYER_1["spearmen_2_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			elseif faction == TECH_PLAYER_2["faction_name"] then
				if TECH_PLAYER_2["army_locked"] == false or TECH_PLAYER_2["farm_locked"] == false or TECH_PLAYER_2["industry_locked"] == false or TECH_PLAYER_2["leader_locked"] == false or TECH_PLAYER_2["market_locked"] == false or TECH_PLAYER_2["religion_locked"] == false or TECH_PLAYER_2["bodyguard_locked"] == false or TECH_PLAYER_2["cap_1_locked"] == false or TECH_PLAYER_2["cap_2_locked"] == false or TECH_PLAYER_2["cap_3_locked"] == false or TECH_PLAYER_2["cap_4_locked"] == false or TECH_PLAYER_2["cavalry_2_locked"] == false or TECH_PLAYER_2["land_locked"] == false or TECH_PLAYER_2["melee_locked"] == false or TECH_PLAYER_2["missile_1_locked"] == false or TECH_PLAYER_2["siege_locked"] == false or TECH_PLAYER_2["spearmen_2_locked"] == false then
					DECREE_LIST[faction][4]["locked"] = false;
				end
			end
		end		
	elseif faction == "vik_fact_gwined" then
		if DECREE_LIST[faction][2]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_church_3") or get_faction(faction):region_list():item_at(i):building_exists("vik_abbey_5") then
					DECREE_LIST[faction][2]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][3]["locked"] and get_faction(faction):region_list():num_items() >= DECREE_LIST[faction][3]["locked_target"] then
			DECREE_LIST[faction][3]["locked"] = false;
		else
			DECREE_LIST[faction][3]["locked_counter"] = get_faction(faction):region_list():num_items();
		end
		if DECREE_LIST[faction][4]["locked"] and DECREE_LIST[faction][4]["locked_counter"] >= DECREE_LIST[faction][4]["locked_target"] then
			DECREE_LIST[faction][4]["locked"] = false;
		end
	elseif faction == "vik_fact_strat_clut" then
		if DECREE_LIST[faction][2]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_church_3") or get_faction(faction):region_list():item_at(i):building_exists("vik_abbey_5") then
					DECREE_LIST[faction][2]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][3]["locked"] and get_faction(faction):region_list():num_items() >= DECREE_LIST[faction][3]["locked_target"] then
			DECREE_LIST[faction][3]["locked"] = false;
		else
			DECREE_LIST[faction][3]["locked_counter"] = get_faction(faction):region_list():num_items();
		end
		if DECREE_LIST[faction][4]["locked"] and DECREE_LIST[faction][4]["locked_counter"] >= DECREE_LIST[faction][4]["locked_target"] then
			DECREE_LIST[faction][4]["locked"] = false;
		end
	elseif faction == "vik_fact_mide" then
		if DECREE_LIST[faction][2]["locked"] == true then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_moot_hill_3") then
					DECREE_LIST[faction][2]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] and DECREE_LIST[faction][4]["locked_counter"] >= DECREE_LIST[faction][4]["locked_target"] then
			DECREE_LIST[faction][4]["locked"] = false;
		end
	elseif faction == "vik_fact_circenn" then
		if DECREE_LIST[faction][2]["locked"] and get_faction(faction):region_list():num_items() >= DECREE_LIST[faction][2]["locked_target"] then
			DECREE_LIST[faction][2]["locked"] = false;
		else
			DECREE_LIST[faction][2]["locked_counter"] = get_faction(faction):region_list():num_items();
		end
		if DECREE_LIST[faction][3]["locked"] then
			for i = 0, get_faction(faction):region_list():num_items() - 1 do
				if get_faction(faction):region_list():item_at(i):building_exists("vik_souterrain_3") then
					DECREE_LIST[faction][3]["locked"] = false;
					break;
				end
			end
		end
		if DECREE_LIST[faction][4]["locked"] then
			for i = 0, get_faction(faction):character_list():num_items() - 1 do
				if get_faction(faction):character_list():item_at(i):rank() >= DECREE_LIST[faction][4]["locked_target"] then
					DECREE_LIST[faction][4]["locked"] = false;
					break;
				elseif get_faction(faction):character_list():item_at(i):rank() > DECREE_LIST[faction][4]["locked_counter"] then
					DECREE_LIST[faction][4]["locked_counter"] = get_faction(faction):character_list():item_at(i):rank();
				end
			end
		end
	elseif faction == "vik_fact_northleode" then
		for i = 1, 4 do
			if (DECREE_LIST[faction][i]["locked"] == true) and DECREE_LIST[faction][i]["locked_region"] then
				if cm:model():world():region_manager():region_by_key(DECREE_LIST[faction][i]["locked_region"]):owning_faction() == faction then
					DECREE_LIST[faction][i]["locked"] = false;
				end
			end
		end
	end
end

-- Updates the scripted unlocks when the player recruits units
function DecreesUnitRecruited(faction)

	if faction == "vik_fact_mierce" and DECREE_LIST[faction][1]["locked"] then
		DECREE_LIST[faction][1]["locked_counter"] = DECREE_LIST[faction][1]["locked_counter"] + 1;
	elseif faction == "vik_fact_gwined" and DECREE_LIST[faction][4]["locked"] then
		DECREE_LIST[faction][4]["locked_counter"] = DECREE_LIST[faction][4]["locked_counter"] + 1;
	elseif faction == "vik_fact_strat_clut" and DECREE_LIST[faction][4]["locked"] then
		DECREE_LIST[faction][4]["locked_counter"] = DECREE_LIST[faction][4]["locked_counter"] + 1;
	end
	DecreesAlertIcon(faction)
end

-- Checks to see if a human fought in the last battle and if they won
function DecreesBattleCompleted(context)
	output("In decrees battle complete!")
	local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
	local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
	local attacker_result = cm:model():pending_battle():attacker_battle_result();
	local defender_result = cm:model():pending_battle():defender_battle_result();
	local attacker = cm:model():world():faction_by_key(attacker_name);
	local defender = cm:model():world():faction_by_key(defender_name);
	
	if attacker:is_null_interface() == false and attacker:is_human() and string.find(attacker_result, "victory") ~= nil then
		DecreesBattleWon(attacker_name);
	elseif defender:is_null_interface() == false and defender:is_human() and string.find(defender_result, "victory") ~= nil then
		DecreesBattleWon(defender_name);
	end	
	
end

-- Updates any win battles decree unlocks
function DecreesBattleWon(faction)
	output("In decrees battle won!")
	if faction == "vik_fact_dyflin" and DECREE_LIST[faction][4]["locked"] then
		DECREE_LIST[faction][4]["locked_counter"] = DECREE_LIST[faction][4]["locked_counter"] + 1;
	elseif faction == "vik_fact_sudreyar" and DECREE_LIST[faction][4]["locked"] then
		DECREE_LIST[faction][4]["locked_counter"] = DECREE_LIST[faction][4]["locked_counter"] + 1;
	elseif faction == "vik_fact_east_engle" and DECREE_LIST[faction][3]["locked"] then
		DECREE_LIST[faction][3]["locked_counter"] = DECREE_LIST[faction][3]["locked_counter"] + 1;
	elseif faction == "vik_fact_northymbre" and DECREE_LIST[faction][3]["locked"] then
		DECREE_LIST[faction][3]["locked_counter"] = DECREE_LIST[faction][3]["locked_counter"] + 1;
	elseif faction == "vik_fact_mide" and DECREE_LIST[faction][4]["locked"] then
		DECREE_LIST[faction][4]["locked_counter"] = DECREE_LIST[faction][4]["locked_counter"] + 1;
	end
	DecreesAlertIcon(faction)
end

---------------------------------------------------------
---------------- DECREES PANEL STRUCTURE ----------------
---------------------------------------------------------

--[[
decrees_panel
	main
		decrees_title
			title_plaque
			tx_decrees
		decrees
			1 (or 2/3/4)
				title_plaque
					dy_text
				duration
					turns_corner
				image
				effects_list
					effect_template
						effect_icon
					effect_template
						effect_icon
				unlock_condition
					dy_condition
				cost_table
					dy_value
					other_cost
						icon
				button_enact
					tx_enact
					turns_corner
				cooldown
					turns_corner
		button_ok
			holder
]]--

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		if cm:get_saved_value("DecreeFirstRun") then
			DECREE_LIST = cm:load_value("DECREE_LIST", DECREE_LIST, context);
		else
			cm:set_saved_value("DecreeFirstRun", true)
		end
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("DECREE_LIST", DECREE_LIST, context);
	end
);