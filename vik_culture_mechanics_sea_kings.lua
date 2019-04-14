-------------------------------------------------------------------------------
------------------------- SEA KINGS CULTURE MECHANICS -------------------------
-------------------------------------------------------------------------------
------------------------- Created by Joy: 05/09/2017 --------------------------
------------------------- Last Updated: 17/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Expedition culture mechanic for Vikings Sea kings

SK_DILEMMAS_FACTION = {
["vik_fact_dyflin"] = {},
["vik_fact_sudreyar"] = {}
}
SK_DILEMMA_COUNTER_FACTION = {
["vik_fact_dyflin"] = 0,
["vik_fact_sudreyar"] = 0
}
SK_DILEMMA_BATTLE_FACTION = {--Have they been in a battle, Did they get win 2(a little loss), Are they battling while heading home
["vik_fact_dyflin"] = {false, false, false},
["vik_fact_sudreyar"] = {false, false, false}
}
SK_DILEMMA_TURN_FACTION = {
["vik_fact_dyflin"] = 0,
["vik_fact_sudreyar"] = 0
}
SK_DILEMMA_SAVE_FACTION = {
["vik_fact_dyflin"] = "",
["vik_fact_sudreyar"] = ""
}
SK_DILEMMA_EAST_RIVER = {
["vik_fact_dyflin"] = "",
["vik_fact_sudreyar"] = ""
}
SK_REWARD_FACTION = {
["vik_fact_dyflin"] = false,
["vik_fact_sudreyar"] = false
}
NORTH_TRIP_NUMBER_FACTION = {
["vik_fact_dyflin"] = 0,
["vik_fact_sudreyar"] = 0
}
EAST_RIVER_PATH_NUMBER_FACTION = {
["vik_fact_dyflin"] = 0,
["vik_fact_sudreyar"] = 0
}
SOUTH_RIVER_PATH_NUMBER_FACTION = {
["vik_fact_dyflin"] = 0,
["vik_fact_sudreyar"] = 0
}
FRISIAN_NUMBER = {
["vik_fact_dyflin"] = 3,
["vik_fact_sudreyar"] = 3
}
SAXLAND_NUMBER = {
["vik_fact_dyflin"] = 4,
["vik_fact_sudreyar"] = 4
}
FRANKISH_NUMBER = {
["vik_fact_dyflin"] = 3,
["vik_fact_sudreyar"] = 3
}
RIVER_NUMBER = {
["vik_fact_dyflin"] = 3,
["vik_fact_sudreyar"] = 3
}
SOUTH_NUMBER = {
["vik_fact_dyflin"] = 2,
["vik_fact_sudreyar"] = 2
}
MEDITERRANEAN_NUMBER = {
["vik_fact_dyflin"] = 2,
["vik_fact_sudreyar"] = 2
}
SK_BUTTONS_FACTION = {--Button1, Button2, Button3, Button4
["vik_fact_dyflin"] = {false, false, false, false},
["vik_fact_sudreyar"] = {false, false, false, false}
}

SK_TRIBUTE_EXPEDITION = 0
SK_TRIBUTE_EXPEDITION_SUD = 0

FRISIAN_EVENT_LIST = {
	"vik_sea_king_expedition_south_2",
	"vik_sea_king_expedition_south_4",
	"vik_sea_king_expedition_south_5",
};

SAXLAND_EVENT_LIST = {
	"vik_sea_king_expedition_south_3",
	"vik_sea_king_expedition_south_8",
	"vik_sea_king_expedition_south_9",
	"vik_sea_king_expedition_south_10",
};

FRANKISH_EVENT_LIST = {
	"vik_sea_king_expedition_west_2",
	"vik_sea_king_expedition_west_3",
	"vik_sea_king_expedition_west_4",
};

RIVER_EVENT_LIST = {
	"vik_sea_king_expedition_west_8",
	"vik_sea_king_expedition_west_9",
	"vik_sea_king_expedition_west_10",
};

SOUTH_EVENT_LIST = {
	"vik_sea_king_expedition_west_6",
	"vik_sea_king_expedition_west_7",
};

MEDITERRANEAN_EVENT_LIST = {
	"vik_sea_king_expedition_south_6",
	"vik_sea_king_expedition_south_7",
};
	
-- Listeners
function Add_Sea_Kings_Mechanics_Listeners()
output("#### Adding Sea Kings Mechanics Listeners ####")
	
	cm:add_listener( -- Dilemma Choice - Dyflin
		"DilemmaChoiceMadeEvent_SeaKingsDilemma_Dyflin",
		"DilemmaChoiceMadeEvent",
		function(context) return context:faction():name() == "vik_fact_dyflin" and cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == true end,
		function(context) DilemmaChoiceMadeEvent_SeaKings_Dilemma(context, "vik_fact_dyflin") end,
		true
	);
	cm:add_listener( -- Dilemma Choice - Sudreyar
		"DilemmaChoiceMadeEvent_SeaKingsDilemma_Sudreyar",
		"DilemmaChoiceMadeEvent",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) DilemmaChoiceMadeEvent_SeaKings_Dilemma(context, "vik_fact_sudreyar") end,
		true
	);
	cm:add_listener( -- Dilemma Choice - Dyflin
		"IncidentOccuredEvent_SeaKingsDilemma_Dyflin",
		"IncidentOccuredEvent",
		function(context) return context:faction():name() == "vik_fact_dyflin" and cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == true end,
		function(context) ExpeditionIncidentTriggered(context, "vik_fact_dyflin") end,
		true
	);
	cm:add_listener( -- Dilemma Choice - Sudreyar
		"IncidentOccuredEvent_SeaKingsDilemma_Sudreyar",
		"IncidentOccuredEvent",
		function(context) return context:faction():name() == "vik_fact_sudreyar" and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == true end,
		function(context) ExpeditionIncidentTriggered(context, "vik_fact_sudreyar") end,
		true
	);

end

--------------------------------------------------------------------------------
----------------------------------Functions-------------------------------------
--------------------------------------------------------------------------------

-- At the start of the turn 
function ExpeditionCheckTurnStart(faction)

	current_turn = cm:model():turn_number();

	if SK_DILEMMA_TURN_FACTION[faction] ~= 0 and SK_DILEMMA_TURN_FACTION[faction] == current_turn then
		if SK_REWARD_FACTION[faction] == false then
			for i = 1, 4 do
				if SK_BUTTONS_FACTION[faction][i] == true then
					ExpeditionDisableButtons("dilemma"..i);
					output("Button dilemma"..i.. " will be inactive!!!")
				else
					output("Button "..i.." will be active")
				end
			end
			cm:trigger_dilemma(faction, SK_DILEMMA_SAVE_FACTION[faction], true)
			ExpeditionEnableButtons(faction);
		else
			cm:trigger_incident(faction, SK_DILEMMA_SAVE_FACTION[faction], true)
			SK_REWARD_FACTION[faction] = false;
			SK_DILEMMA_TURN_FACTION[faction] = 0;
		end
	end

end

function ExpeditionDisableButtons(dilemma)

	local delay = 0;

	local function disable_button(dilemma)
		output("Button variable is: "..dilemma)
		local uic_button = find_uicomponent(cm:ui_root(), "panel_manager", "events", "event_dilemma", dilemma.."_window", dilemma.."_template", "choice_button");
		print_all_uicomponent_children(cm:ui_root());
		if uic_button then
			uic_button:SetState("inactive");
			output("Button has been set to inactive - delay is " .. delay)
		else
			output("Couldn't find the button, trying again in 0.1 seconds")
			delay = delay + 0.1
			add_callback(function() disable_button(dilemma) end, 0.1)
		end
	end;

	cm:add_listener("test", 
		"PanelOpenedCampaign", 
		function(context) return context.string == "events" end, 
		function(context) 
			--dilemma1_window, dilemma1_template
			--print_all_uicomponent_children(uic_button);
			disable_button(dilemma)
		end,
		false 
	);
end

function ExpeditionEnableButtons(faction)
	for i = 1, 4 do
		SK_BUTTONS_FACTION[faction][i] = false;
	end
end
--------------------------------------------------------------------------------
-------------------------------Dilemma Choices----------------------------------
--------------------------------------------------------------------------------

function DilemmaChoiceMadeEvent_SeaKings_Dilemma(context, faction)
		
	--Your warriors and sailors are eager take the longships to sea. The fleet is ready to set sail and explore the world beyond your shores in search of trade and plunder. If the gods are willing, perhaps they may even find new lands to settle or conquer. Which direction would you have the ships sail in?
	if context:dilemma() == "vik_sea_king_expedition_1" then
		
		if context:choice() == 0 then --North
			ExpeditionNorthStart(faction);
		end
		if context:choice() == 1 then --East
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_1");
		end
		if context:choice() == 2 then --Southeast
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_south_1");
		end
		if context:choice() == 3 then --South
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_west_1");
		end
	end

	-- North trip variations
	if context:dilemma() == "vik_sea_king_expedition_north_3" and NORTH_TRIP_NUMBER_FACTION[faction] == 1 then -- second trip, on to Greenland
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_4");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_north_3" and NORTH_TRIP_NUMBER_FACTION[faction] == 2 then -- third trip, on to Vinland
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_6");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_north_6" then -- settle Vinland
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_5");
		end
	end
	
	-- North rewards
	if context:dilemma() == "vik_sea_king_expedition_north_2" then -- Iceland settled trigger
		NORTH_TRIP_NUMBER_FACTION[faction] = 1
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_north_4" then -- Greenland settled trigger
		NORTH_TRIP_NUMBER_FACTION[faction] = 2
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_2");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_north_5" then -- Vinland settled trigger
		NORTH_TRIP_NUMBER_FACTION[faction] = 1
		if context:choice() == 0 then --Resupply
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_3");
		end
	end
	
	-- EAST TRIP DILEMMAS --
	
	-- East starting dilemma
	if context:dilemma() == "vik_sea_king_expedition_east_1" then
		if context:choice() == 0 then --Trade Rus
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_1");
		end
		if context:choice() == 1 then --East River
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_5");
		end
		if context:choice() == 2 then --South River
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_8");
		end
	end
	
	-- East River dilemmas
	if context:dilemma() == "vik_sea_king_expedition_east_5" and EAST_RIVER_PATH_NUMBER_FACTION == 0 then -- First time going East, get reward!
		if context:choice() == 0 then --Continue
			EAST_RIVER_PATH_NUMBER_FACTION = 1
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_2");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_5" and EAST_RIVER_PATH_NUMBER_FACTION == 1 then  -- Second time, next destionation
		if context:choice() == 0 then --Continue
			EAST_RIVER_PATH_NUMBER_FACTION = 2
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_6");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_5" and EAST_RIVER_PATH_NUMBER_FACTION == 2 then -- Third time
		if context:choice() == 0 then --Continue
			EAST_RIVER_PATH_NUMBER_FACTION = 3
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_6");
		end
	end
	
	-- East River dilemmas pt 2
	if context:dilemma() == "vik_sea_king_expedition_east_6" and EAST_RIVER_PATH_NUMBER_FACTION == 2 then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_3");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_6" and EAST_RIVER_PATH_NUMBER_FACTION == 3 then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_7");
		end	
	end
	
	-- East River dilemmas pt 3
	if context:dilemma() == "vik_sea_king_expedition_east_7" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_4");
		end
	end
	
	-- South River dilemmas
	if context:dilemma() == "vik_sea_king_expedition_east_8" and SOUTH_RIVER_PATH_NUMBER_FACTION == 0 then -- First time going South, get reward!
		if context:choice() == 0 then --Continue
			SOUTH_RIVER_PATH_NUMBER_FACTION = 1
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_5");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_8" and SOUTH_RIVER_PATH_NUMBER_FACTION == 1 then
		if context:choice() == 0 then --Continue
			SOUTH_RIVER_PATH_NUMBER_FACTION = 2
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_9");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_8" and SOUTH_RIVER_PATH_NUMBER_FACTION == 2 then
		if context:choice() == 0 then --Continue
			SOUTH_RIVER_PATH_NUMBER_FACTION = 3
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_9");
		end
	end
	
	-- South River dilemmas pt 2
	if context:dilemma() == "vik_sea_king_expedition_east_9" and SOUTH_RIVER_PATH_NUMBER_FACTION == 2 then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_6");
		end
	elseif context:dilemma() == "vik_sea_king_expedition_east_9" and SOUTH_RIVER_PATH_NUMBER_FACTION == 3 then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_10");
		end	
	end
	
	-- South River dilemmas pt 3
	if context:dilemma() == "vik_sea_king_expedition_east_10" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_east_trade_7");
		end
	end
	
	-- SOUTHEAST DILEMMAS --
	
	-- Southeast starting dilemma
	if context:dilemma() == "vik_sea_king_expedition_south_1" then
		if context:choice() == 0 then --Frisian Coast
			ExpeditionSoutheastFrisian(faction);
		end
		if context:choice() == 1 then --Saxland
			ExpeditionSoutheastSaxland(faction);
		end
		if context:choice() == 2 then --Frankish Coast
			ExpeditionSoutheastFrankish(faction);
		end
	end
	
	-- Frisian dilemmas
	if context:dilemma() == "vik_sea_king_expedition_south_2" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_1_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_4" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_6_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_5" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_7_1");
		end
	end
	
	-- Saxland dilemmas
	if context:dilemma() == "vik_sea_king_expedition_south_3" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_2_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_8" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_3_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_9" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_4_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_10" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_5_1");
		end
	end
	
	-- Frankish dilemmas
	if context:dilemma() == "vik_sea_king_expedition_west_2" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_conquer_1_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_west_3" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_conquer_2_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_west_4" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_conquer_3_1");
		end
	end
	
	-- SOUTH DILEMMAS --
	
	-- South starting dilemma
	if context:dilemma() == "vik_sea_king_expedition_west_1" then
		if context:choice() == 0 then --River
			ExpeditionSouthRiver(faction);
		end
		if context:choice() == 1 then --Iberia
			ExpeditionSouthIberia(faction);
		end
		if context:choice() == 2 then --Mediterranean
			ExpeditionSouthMed(faction);
		end
	end
	
	-- River dilemmas
	if context:dilemma() == "vik_sea_king_expedition_west_8" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_raid_7_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_west_9" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_raid_8_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_west_10" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_raid_9_1");
		end
	end
	
	-- South dilemmas
	if context:dilemma() == "vik_sea_king_expedition_west_6" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_raid_5_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_west_7" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_west_raid_6_1");
		end
	end
	
	-- Mediterranean dilemmas
	if context:dilemma() == "vik_sea_king_expedition_south_6" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_8_1");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_7" then
		if context:choice() == 0 then --Continue
			ExpeditionSaveNextReward (faction, "vik_sea_king_expedition_south_conquer_9_1");
		end
	end
	
--[[	
--The chill seas of the North have lashed your ships, but your men are stalwart, and now the northern lands are within reach. Should they land here, carry on, or return home?
	if context:dilemma() == "vik_sea_king_expedition_north_1" then
		if context:choice() == 0 then --Land Here
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_1", faction) == false then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_2");
			else
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_3");
				if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_stay_1", faction) == true then
					SK_BUTTONS_FACTION[faction][2] = true;
					output("Disable button 2")
				end
			end
		end
		if context:choice() == 1 then --Continue North
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_2", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_1", faction) == true then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_6");
				if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_stay_2", faction) == true then
					SK_BUTTONS_FACTION[faction][2] = true;
					output("Disable button 2")
				end
			elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_2", faction) == false then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_4");
			else
				ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_out_of_supplies_1", 3);
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your fleet has found a new and unclaimed land in the North. It is a place of snow and ice, though it also has fire in its heart. Your men name it Iceland, as perhaps a name like that will discourage others who may want to settle here and claim what little farmland is available. Should the expedition found a colony here now or move on?
	if context:dilemma() == "vik_sea_king_expedition_north_2" then
		if context:choice() == 0 then --Settle Here
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_1", 1);
		end
		if context:choice() == 1 then --Continue North
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_out_of_supplies_1", 3);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--The expedition reaches your colony in Iceland. The settlers of 'Smoky Bay', with its hot springs and good fishing, have sufficient provisions to provide fresh supplies. Once they have done so should the expedition stay, carry on northwards or return home?
	if context:dilemma() == "vik_sea_king_expedition_north_3" then
		if context:choice() == 0 then --Continue North
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_2", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_1", faction) == true then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_6");
				if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_stay_2", faction) == true then
					SK_BUTTONS_FACTION[faction][2] = true;
					output("Disable button 2")
				end
			elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_2", faction) == false then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_4");
			end
		end
		if context:choice() == 1 then --Stay in Iceland
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_stay_1", 1);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--In the far, cold reaches of the North, you have discovered a new land. Although snow covers its heart all year there is some usable territory along the sheltered fjords of its western coast. Perhaps it may one day be farmed by your hardy folk. The expedition optimistically names it Greenland. Would you have your men land and settle or carry on?
	if context:dilemma() == "vik_sea_king_expedition_north_4" then
		if context:choice() == 0 then --Settle Here
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_2", 1);
		end
		if context:choice() == 1 then --Continue North
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_out_of_supplies_1", 3);
		end
		if context:choice() == 2 then --Go Back
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--Your explorers have surely travelled farther than any seafarer before them!  Beyond mist and high seas they come across a land of legend, where the rivers team with fish and the air is filled with the drone of happy bees. Grapes and corn grow to great size here. They name this rich country Vinland. Do you wish them to settle here, or to return to the civilised world?
	if context:dilemma() == "vik_sea_king_expedition_north_5" then
		if context:choice() == 0 then --Settle Here
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_settle_3", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your ships arrive in Greenland. What little the settlers have managed to eke from the land and sea will be shared, and they give your men fresh victuals and water. After they have re-provisioned, should the ships return home or carry on?
	if context:dilemma() == "vik_sea_king_expedition_north_6" then
		if context:choice() == 0 then --Continue North
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_settle_3", faction) == true then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_7");
			else
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_5");
			end
		end
		if context:choice() == 1 then --Stay in Greenland
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_stay_2", 1);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The fleet has reached your most distant colony, Vinland. Food is rich and plentiful here, and they are free to stock up on fish and meat and the local delectable fruits and grains. Having come this far and replenished their supplies, do you wish the expedition to stay or return home? 
	if context:dilemma() == "vik_sea_king_expedition_north_7" then
		if context:choice() == 0 then --Stay in Vinland
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_north_stay_3", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The crossing was hard, with high seas and bitter winds. But the promise of the riches of the East drew the expedition on. Now land is in sight, and a myriad of eastern territories are within reach. Will your men put ashore here, continue onwards by whatever route may be found or turn for home? 
	if context:dilemma() == "vik_sea_king_expedition_east_1" then
		if context:choice() == 0 then --Land Here
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_2");
		end
		if context:choice() == 1 then --Continue East
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_out_of_supplies_1", 3);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your fleet has reached the wooded coastline of the lands of the Rus. The people here, who may have been kin to your folk in the distant past, are taciturn but not openly hostile. They may be amenable to trade. Or do you wish the expedition to carry on to see what lies farther east?
	if context:dilemma() == "vik_sea_king_expedition_east_2" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_1", 1);
			SK_TRADE_RUS = true;
		end
		if context:choice() == 1 then --Continue East
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_out_of_supplies_1", 3);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The Rus traders are happy to do business with your people, and they greet the fleet's return with warm smiles and fiery tots of the local grain spirit. They are more than willing to re-supply the expedition. Once the fleet has taken on what it needs your men are free to carry on deeper inland, if that is what you wish. 
	if context:dilemma() == "vik_sea_king_expedition_east_3" then
		if context:choice() == 0 then --Continue East
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_4");
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_4", faction) == true then
				SK_BUTTONS_FACTION[faction][1] = true;
				output("Disable button 1")
			end
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_7", faction) == true then
				SK_BUTTONS_FACTION[faction][2] = true;
				output("Disable button 2")
			end
		end
		if context:choice() == 1 then --Stay in Rus Lands
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_stay_1", 1);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The rivers of the East are wide and slow. Your expedition can use these inland routes to travel deep into the heart of the eastern lands, though they soon face a choice of direction. Should they seek the waterways that will take them into the wide grasslands of the east or should they head down the great southern waterway the Rus call the 'Mother River'?  
	if context:dilemma() == "vik_sea_king_expedition_east_4" then
		local ran_number_2 = 0;
			
		if SK_DILEMMA_BATTLE_FACTION[faction][1] == true then
			ran_number_2 = 1;
		else
			ran_number_2 = cm:random_number(5);
		end
			
		if context:choice() == 0 then --Go East
			SK_DILEMMA_EAST_RIVER[faction] = "east";
			if ran_number_2 == 5 then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_river_battle_1");
			else
				ExpeditionEastRiverPaths(faction);
			end
		end
		if context:choice() == 1 then --Go South
			SK_DILEMMA_EAST_RIVER[faction] = "south";
			if ran_number_2 == 5 then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_river_battle_1");
			else
				ExpeditionEastRiverPaths(faction);
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Beyond the forests of the coast your expedition enters a land of endless grassy plains and open skies. Though the people who live here were once nomads some of them have now settled along the banks of the river. They are savage and warlike but also canny traders. Will your men trade with the Bulgari or continue farther east?
	if context:dilemma() == "vik_sea_king_expedition_east_5" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_2", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Beyond the lands of the Bulgari, the expedition comes to Khazaria. The Khazars are a confederation of several races, although they worship a single god. They are settled and civilised, with well-tilled fields and vineyards, and gardens which they cultivate for pleasure rather than utility. They have wide-reaching trade links in every direction. Will your expedition see what goods the Khazars have to offer or will they travel farther east still? 
	if context:dilemma() == "vik_sea_king_expedition_east_6" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_3", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Your expedition crosses a great inland sea that bounds Khazaria, and spends several days out of sight of land. On the far side the fleet finds Gorgan, the City of Towers. The climate is warm here and the fields are rich; as well as familiar crops like wheat and grapes the locals grow brightly coloured, astringent fruits. Artisans in the city craft colourful, intricately designed rugs and fine pottery. Should your expedition trade with them?
	if context:dilemma() == "vik_sea_king_expedition_east_7" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_4", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--The southern river path brings your expedition to a settlement on a small hill, at the meeting point of many trade routes. The fortified city of Kyjev holds riches from all four corners of the world. Will your men take the opportunity to trade with the people of Kyjev or bypass the city and press on southwards? 
	if context:dilemma() == "vik_sea_king_expedition_east_8" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_5", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Your expedition reaches the greatest city of them all - Constantinople.  Once the heart of the Byzantine Empire, this most populous and cosmopolitan of cities has been through many changes. Despite the tribulations it has faced its glory and reputation increase every year. Will the men stay and trade here, or is this but the path to lands even farther east? 
	if context:dilemma() == "vik_sea_king_expedition_east_9" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_6", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Farther still, in south-eastern lands where heat reigns and the dry, harsh terrain is strange to northern eyes, your intrepid explorers come across people whose ways are peculiar but whose riches are considerable. You have reached the heartlands of the Moorish peoples, the men of the desert. Will you trade with them, or return to more familiar lands?
	if context:dilemma() == "vik_sea_king_expedition_east_10" then
		if context:choice() == 0 then --Trade
			ExpeditionSaveNextReward(faction, "vik_sea_king_expedition_east_trade_7", 1);
		end
		if context:choice() == 1 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Your fleet reaches the warm lands of the South. The welcoming river mouths before your ships promise routes to the rich southern heartlands. Will the men disembark, continue up-river or go back? 
	if context:dilemma() == "vik_sea_king_expedition_south_1" then
		if context:choice() == 0 then --Land Here
			ExpeditionLandSouth(faction);
		end
		if context:choice() == 1 then --Southern River Path
			ExpeditionRiverSouth(faction);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The marshes and low islets of the coast of Saxland have been home to fisher-folk and farmers for as long as anyone remembers.  One particular settlement at the mouth of a river, a large village known as Lehe, looks promising enough to be worth further investigation. Do you wish to conquer this settlement to expand your reach, to trade with it or to have your men mount a raid?  
	if context:dilemma() == "vik_sea_king_expedition_south_2" then
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_1_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_1_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_1_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 6;
			end
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end

	--A little way up the wide estuary of the River Elfr your expedition comes across a new settlement near a bend in the river. Said to have been founded by Emperor Charlemagne to bring Christianity to the Saxons who live in these lowlands, Hammaburg is sure to grow and prosper. Although it is a young town, it is in a fine location, both strategically and for trade. Will you plunder the new town, trade with it or conquer it?
	if context:dilemma() == "vik_sea_king_expedition_south_3" then
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_2_"..ran_number, ran_number);

		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_2_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_2_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 5;
			end
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end

	--Your ships make landfall in the rich lowlands of Friesland. Though much of Friesland is marsh, the city of Groningen lies in good agricultural country, where they grow rye, oats and barley; the locals also make fine, pale beer. Do you wish to invade and conquer the Frisians of Groningen, to raid and take what they will or trade for wheat and beer?
	if context:dilemma() == "vik_sea_king_expedition_south_4" then
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_6_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_6_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_6_"..ran_number, ran_number);
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your fleet reaches Dorestad, a port on the sheltered coast of Friesland. Once a thriving market-place whose fame spread far and wide, Dorestad has gone into decline in recent years, and lies in land which is now disputed territory. It used to mint its own coins, and some of that ancient wealth may still remain. Would you have your men plunder what is left, conquer the town or trade with the Dorestaders?
	if context:dilemma() == "vik_sea_king_expedition_south_5" then
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_7_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_7_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_7_"..ran_number, ran_number);
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your ships have travelled many days to get here, passing through the Pillars of Hercules into the warm Middle Sea to reach the land of the Langobards. The great city here, Genua, has been a port and trade centre since the time of the Romans. Should your expedition trade with Genua, or should your men try sacking, or even conquering, the city? 
	if context:dilemma() == "vik_sea_king_expedition_south_6" then		
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_8_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_8_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_8_"..ran_number, ran_number);
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your expedition travelled far, circling the coast of Iberia to gain access to the warm waters of the Middle Sea, once the heartland of the Roman Empire. When they sight a coastal city with high walls of white marble they wonder if this could actually be Rome. Would you try and take the city through conquest, have the men raid the place, or enter into commerce?
	if context:dilemma() == "vik_sea_king_expedition_south_7" then	
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_9_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_9_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_9_"..ran_number, ran_number);
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Travelling up the River Elfr, your expedition finds a trading settlement on the edge of the Slavic lands. Magadoburg is one of the new, Christian towns founded by the Emperor Charlemagne, and has an impressive monastery. It is low-lying but fortified, with mountains and forests nearby. Should your ships raid, stop to trade, or simply conquer?
	if context:dilemma() == "vik_sea_king_expedition_south_8" then	
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_3_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_3_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_3_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 5;
			end
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--On the confluence of three rivers your expedition finds a settlement known as Leipsic, the town of the lime trees. This location is on the intersection of two ancient routes, the north-south Via Imperii, or Imperial Highway, and the east-west Via Regia, the King's Highway. The land around about is flat and marshy, though a little way out from the town are thick forests. What would you have the expedition do here?
	if context:dilemma() == "vik_sea_king_expedition_south_9" then	
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_4_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_4_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_4_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 6;
			end
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Deep in Saxland your ships approach a town on the edge of Slavic lands which may offer opportunities for trade, or perhaps a more aggressive exchange. Built on a flat river plain with heavy forest nearby, Dresdin is nevertheless near enough to the Ore Mountains to benefit from the mines there. Should your men pillage, conquer it or enter into a trading arrangement with its people?  
	if context:dilemma() == "vik_sea_king_expedition_south_10" then
		if context:choice() == 0 then --Conquer
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_conquer_5_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Trade
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_trade_5_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 6;
			end
		end
		if context:choice() == 2 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_south_raid_5_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 6;
			end
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--The crossing was rough, but your expedition has won through to the many and varied lands of the West. Will you have them land here or carry on farther west, either by sea or up-river? 
	if context:dilemma() == "vik_sea_king_expedition_west_1" then
		if context:choice() == 0 then --Land Here
			ExpeditionLandWest(faction);
		end
		if context:choice() == 1 then --Continue West
			ExpeditionFurtherWest(faction);
		end
		if context:choice() == 2 then --Western River Path
			ExpeditionRiverWest(faction);
		end
		if context:choice() == 3 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end

	--Your ships reach the north-west coast of the Frankish territories, the land of Neustria. The countryside is good and fertile, and is dotted with churches and abbeys whose walls conceal considerable wealth. Would you have the expedition make landfall here to force the people to become your vassals or else to raid their riches?
	if context:dilemma() == "vik_sea_king_expedition_west_2" then	
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_1_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_1_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 4;
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your expedition reaches the northern Frankish lands. Much of the coast here rises in great white cliffs, sisters to those on the coast of Britannia across the water. This is also the place where the great River Seine reaches the sea. Will you make those who live here your vassals, raid their lands or will you return home? 
	if context:dilemma() == "vik_sea_king_expedition_west_3" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_2_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_2_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--This land of mists and menhirs has much to offer, from lush pastures and orchards to seas rich with fish. Its people are as ancient as its stones, and have little time for their Frankish neighbours. Should you make the Bretons your vassals, raid them, or leave them be and return home?
	if context:dilemma() == "vik_sea_king_expedition_west_4" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_3_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_3_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--After crossing the stormy Basque Sea, your expedition sights the rocky northern coast of Iberia, the western peninsula that marks the end of the known world. The people here are proud and fierce, but could still serve as vassals if that is your command. Unless you would prefer your men to trade with them?
	if context:dilemma() == "vik_sea_king_expedition_west_5" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_4_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_4_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 8;
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--You ships reach the lands at the far western end of the Iberian peninsula. The coast shows a face of high cliffs cut into by flooded river valleys. One of the rockiest sections is protected by a towering lighthouse built by the Romans. The people of Gallaecia claim kinship with the original inhabitants of Britannia. Would you make them your vassals or have your men mount a raid?
	if context:dilemma() == "vik_sea_king_expedition_west_6" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_5_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_5_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 8;
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--The winds are with your ships, blowing them around the Iberian peninsula to its western coast, a land originally settled by the same people who live in Gallaecia. The Romans called them the Cales, and had trouble subduing them. More recently they have been living under the rule of Moorish invaders though they have now regained some autonomy. Their main settlement is a prosperous port on the mouth of a wide river. With the Moorish influence declining, you could make these people your vassals, or perhaps just raid their port.  
	if context:dilemma() == "vik_sea_king_expedition_west_7" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_6_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_6_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, false);
		end
	end
	
	--Your expedition reaches the greatest settlement of the Frankish territories. Named for the Parisii tribe who originally settled on an isle in the river Seine, the town was fortified by the Romans and has since grown into a populous city and spread out along the river's banks, though the heart of it remains the fortified isle. The Frankish folk might make good vassals, unless you wanted to mount a raid instead?
	if context:dilemma() == "vik_sea_king_expedition_west_8" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_7_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_7_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--The river takes your ships deep into Frankish territory, and they find a fortified city beside the river. Orlians lies in the heartland of the Franks, and is second only to Paris amongst their settlements. They make good wine, and items from many distant lands are traded here. Would you make the folk of Orlians your vassals, or raid them for their trade goods and the produce of their vineyards?
	if context:dilemma() == "vik_sea_king_expedition_west_9" then
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_8_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_8_"..ran_number, ran_number);
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--As the river approaches the Frankish highlands, your expedition comes across a large and prosperous town, built on a great promontory and defended by thick walls. It has an impressive Christian abbey, and is also at a crossroads for trade. Will your men make the inhabitants your vassals, will they raid the town, or will they head home?
	if context:dilemma() == "vik_sea_king_expedition_west_10" then	
		if context:choice() == 0 then --Make Vassal
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_conquer_9_"..ran_number, ran_number);
		end
		if context:choice() == 1 then --Raid
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_west_raid_9_"..ran_number, ran_number);
			if faction == "vik_fact_dyflin" and ran_number ~= 3 then
				SK_FOR_DYFLIN = 4;
			end
		end
		if context:choice() == 2 then --Return Home
			ExpeditionGoBack(faction, true);
		end
	end
	
	--Your expedition is under attack! Will you have the warriors rush for their weapons ready to defend the ships, or should the fleet flee from this threat?
	if context:dilemma() == "vik_sea_king_expedition_sea_battle_1" then
		if context:choice() == 0 then --Fight the Enemy
			ExpeditionSeaBattle(faction);
		end
		if context:choice() == 1 then --Flee from Battle
			ExpeditionFleeBattle(faction);
		end
	end
	
	--Your adversary was foolish to think he could stand against your warriors. They have sent the enemy packing! Now the threat has been dealt with, do you wish the men to go ashore or do you wish them to sail away?
	if context:dilemma() == "vik_sea_king_expedition_sea_battle_2" then
		if context:choice() == 0 then --Land Here
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "north" then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_1");
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionSouthStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "west" then
				ExpeditionWestStart(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--Your warriors fought hard, and their valour has saved the expedition. But too many will never return home. Should the remainder of your forces turn around or should they disembark here?
	if context:dilemma() == "vik_sea_king_expedition_sea_battle_3" then
	--add some negative stats
		if context:choice() == 0 then --Land Here
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "north" then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_1");
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionSouthStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "west" then
				ExpeditionWestStart(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--Your expedition cannot prevail against these odds! The men take the wiser course, and flee before they are overwhelmed. Better to retreat and live to fight another day than fall without making a mark on the enemy. But will you complete your retreat and leave this place or would you have the men put ashore once the danger has passed?
	if context:dilemma() == "vik_sea_king_expedition_flee_1" then
		if context:choice() == 0 then --Continue 
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "north" then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_1");
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionSouthStart(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "west" then
				ExpeditionWestStart(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--As your ships follow the course of the river they are set upon by enemies. Will your warriors flee these foes, or stay and engage them?
	if context:dilemma() == "vik_sea_king_expedition_river_battle_1" then
		if context:choice() == 0 then --Fight the Enemy
			ExpeditionRiverBattle(faction);
		end
		if context:choice() == 1 then --Flee from Battle
			ExpeditionRiverFleeBattle(faction);
		end
	end
	
	--Your enemies miscalculated when they attacked your expedition. Your warriors are at home on any water, be it at sea or on the river, and they vanquish the enemy. With this triumph under their belts, would you have the men land here, or press on?
	if context:dilemma() == "vik_sea_king_expedition_river_battle_2" then
		if context:choice() == 0 then --Land Here
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastRiverPaths(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionRiverSouth(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--Your expedition overcame the foes who attacked them on the river, but the victory was hard won. Many of your warriors were slain today. Will you take this as a sign from the gods to retreat or will you tell the remainder of your men to land?
	if context:dilemma() == "vik_sea_king_expedition_river_battle_3" then
	--add some negative stats
		if context:choice() == 0 then --Land Here
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastRiverPaths(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionRiverSouth(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	--Your men had no wish for a battle on the river, and have succeeded in disengaging from the foe. Would you have them continue their retreat, or do you wish your warriors to go ashore now?
	if context:dilemma() == "vik_sea_king_expedition_river_flee_1" then
		if context:choice() == 0 then --Land Here
			if SK_DILEMMA_DIRECTION_FACTION[faction] == "east" then
				ExpeditionEastRiverPaths(faction);
			elseif SK_DILEMMA_DIRECTION_FACTION[faction] == "south" then
				ExpeditionRiverSouth(faction);
			end
		end
		if context:choice() == 1 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_river_battle_return_home_1" or context:dilemma() == "vik_sea_king_expedition_river_battle_return_home_2" or context:dilemma() == "vik_sea_king_expedition_sea_battle_return_home_1" or
	context:dilemma() == "vik_sea_king_expedition_sea_battle_return_home_2" then
		if context:choice() == 0 then --Return Home
			ExpeditionSaveNextRewardSouthWest(faction, "vik_sea_king_expedition_retreat_empty_handed_1", 1);
		end
	end ]]--
end

--------------------------------------------------------------------------------
---------------------------------Expeditions------------------------------------
--------------------------------------------------------------------------------

--UPDATE WITH NEW ONES--

function ExpeditionTrigger(faction)
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_north_2", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_4", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_north_5", faction) == true then
		SK_BUTTONS_FACTION[faction][1] = true;
		output("Disable button 1")
	end
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_4", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_7", faction) == true then
		SK_BUTTONS_FACTION[faction][2] = true;
		output("Disable button 2")
	end
	
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_1_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_2_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_6_1", faction) == true and
	ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_7_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_3_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_4_1", faction) == true and 
	ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_5_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_conquer_1_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_conquer_2_1", faction) == true and 
	ExpeditionDilemmaUsed("vik_sea_king_expedition_west_conquer_3_1", faction) == true then
		SK_BUTTONS_FACTION[faction][3] = true;
		output("Disable button 3")
	end
	
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_raid_7_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_raid_8_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_raid_9_1", faction) == true 
	and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_raid_5_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_raid_6_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_7", faction) == true 
	and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_8_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_conquer_9_1", faction) == true then
		SK_BUTTONS_FACTION[faction][4] = true;
		output("Disable button 4")
	end
	
	local buttons = 0;
	for i = 1, 4 do
		if SK_BUTTONS_FACTION[faction][i] == true then
			ExpeditionDisableButtons("dilemma"..i);
			output("Button dilemma"..i.. " will be inactive!!!")
			buttons = buttons + 1;
		else
			output("Button "..i.." will be active")
		end
	end
	
	if buttons ~= 4 then
		cm:trigger_dilemma(faction, "vik_sea_king_expedition_1", true); --Your warriors and sailors are eager take the longships to sea. The fleet is ready to set sail and explore the world beyond your shores in search of trade and plunder. If the gods are willing, perhaps they may even find new lands to settle or conquer. Which direction would you have the ships sail in?
	end
	ExpeditionEnableButtons(faction);
end

--------------------------------------------------------------------------------
----------------------------- Expeditions - NORTH ------------------------------
--------------------------------------------------------------------------------

function ExpeditionNorthStart(faction) -- Going North
	
	if NORTH_TRIP_NUMBER_FACTION[faction] == 0 then
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_2");
		output("Iceland only")
	end
	
	if NORTH_TRIP_NUMBER_FACTION[faction] == 1 then
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_3");
		output("Iceland and Greenland")
	end
	
	if NORTH_TRIP_NUMBER_FACTION[faction] == 2 then
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_north_3");
		output("Iceland, Greenland, Vinland")
	end
end

--------------------------------------------------------------------------------
----------------------------- Expeditions - SOUTHEAST --------------------------
--------------------------------------------------------------------------------

function ExpeditionSoutheastFrisian(faction) -- Frisian conquests
	local x = cm:random_number(FRISIAN_NUMBER[faction], 1)
	local new_event = FRISIAN_EVENT_LIST[x]
	table.insert(FRISIAN_EVENT_LIST, 3, table.remove(FRISIAN_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	FRISIAN_NUMBER[faction] = FRISIAN_NUMBER[faction] -1
	
--	if FRISIAN_NUMBER = 0 LOCKING BUTTONS LATER
end

function ExpeditionSoutheastSaxland(faction) -- Saxland conquests
	local x = cm:random_number(SAXLAND_NUMBER[faction], 1)
	local new_event = SAXLAND_EVENT_LIST[x]
	table.insert(SAXLAND_EVENT_LIST, 3, table.remove(SAXLAND_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	SAXLAND_NUMBER[faction] = SAXLAND_NUMBER[faction] -1
end

function ExpeditionSoutheastFrankish(faction) -- Frankish conquests
	local x = cm:random_number(FRANKISH_NUMBER[faction], 1)
	local new_event = FRANKISH_EVENT_LIST[x]
	table.insert(FRANKISH_EVENT_LIST, 3, table.remove(FRANKISH_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	FRANKISH_NUMBER[faction] = FRANKISH_NUMBER[faction] -1
end

--------------------------------------------------------------------------------
----------------------------- Expeditions - SOUTH ------------------------------
--------------------------------------------------------------------------------

function ExpeditionSouthRiver(faction) -- Frisian conquests
	local x = cm:random_number(RIVER_NUMBER[faction], 1)
	local new_event = RIVER_EVENT_LIST[x]
	table.insert(RIVER_EVENT_LIST, 3, table.remove(RIVER_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	RIVER_NUMBER[faction] = RIVER_NUMBER[faction] -1
	
--	if FRISIAN_NUMBER = 0 LOCKING BUTTONS LATER
end

function ExpeditionSouthIberia(faction) -- Saxland conquests
	local x = cm:random_number(SOUTH_NUMBER[faction], 1)
	local new_event = SOUTH_EVENT_LIST[x]
	table.insert(SOUTH_EVENT_LIST, 3, table.remove(SOUTH_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	SOUTH_NUMBER[faction] = SOUTH_NUMBER[faction] -1
end

function ExpeditionSouthMed(faction) -- Frankish conquests
	local x = cm:random_number(MEDITERRANEAN_NUMBER[faction], 1)
	local new_event = MEDITERRANEAN_EVENT_LIST[x]
	table.insert(MEDITERRANEAN_EVENT_LIST, 3, table.remove(MEDITERRANEAN_EVENT_LIST,x))
	ExpeditionSaveNextDilemma(faction, new_event)
	MEDITERRANEAN_NUMBER[faction] = MEDITERRANEAN_NUMBER[faction] -1
end

--[[
--------------------------------------------------------------------------------
----------------------------- Expeditions - SOUTH ------------------------------
--------------------------------------------------------------------------------
function ExpeditionLandSouth(faction) -- Going South
	local ran_number = cm:random_number(6);

	for i = 0, 1 do
		if ran_number == 1 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_2", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_2");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 2 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_3", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_3");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 3 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_4", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_4");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 4 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_5", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_5");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 5 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_6", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_6");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 6 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_7", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_7");
			else
				ran_number = 1;
			end
		end
	end

end

function ExpeditionRiverSouth(faction) -- Continued down the river
	local ran_number = cm:random_number(4);
	for i = 0, 1 do
		if ran_number == 1 then
			if SK_DILEMMA_BATTLE_FACTION[faction][1] == false then
				ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_river_battle_1");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 2 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_8", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_8");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 3 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_9", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_9");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 4 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_10", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_south_10");
			else
				ran_number = 1;
			end
		end
	end
end


--------------------------------------------------------------------------------
----------------------------- Expeditions - WEST -------------------------------
--------------------------------------------------------------------------------
function ExpeditionLandWest(faction) -- Going West
	local ran_number = cm:random_number(3);
	for i = 0, 1 do
		if ran_number == 1 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_2", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_2");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 2 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_3", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_3");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 3 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_4", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_4");
			else
				ran_number = 1;
			end
		end
	end
end

function ExpeditionFurtherWest(faction) -- Going further West
	local ran_number = cm:random_number(3);
	for i = 0, 1 do
		if ran_number == 1 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_5", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_5");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 2 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_6", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_6");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 3 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_7", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_7");
			else
				ran_number = 1;
			end
		end
	end
end

function ExpeditionRiverWest(faction) -- Going down the river
	local ran_number = cm:random_number(3);
	for i = 0, 1 do
		if ran_number == 1 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_8", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_8");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 2 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_9", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_9");
			else
				ran_number = ran_number + 1;
			end
		end
		if ran_number == 3 then
			if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_10", faction) == false then
				ExpeditionSaveNextDilemmaSouthWest(faction, "vik_sea_king_expedition_west_10");
			else
				ran_number = 1;
			end
		end
	end
end
]]--

--------------------------------------------------------------------------------
---------------------------- Expeditions - Common ------------------------------
--------------------------------------------------------------------------------

function ExpeditionDilemmaUsed(dilemma, faction)
	--Check if a dilemma has been used
	output("Checking if the dilemma has been used")
	if SK_DILEMMA_COUNTER_FACTION[faction] ~= 0 then
		for i = 1, SK_DILEMMA_COUNTER_FACTION[faction] do
			local tableinfo = SK_DILEMMAS_FACTION[faction][i];
			output(tableinfo)
			if tableinfo == dilemma then
				output("Found the dilemma that has been used")
				return true;
			end
		end
	end
	output("The dilemma has not been used")
	return false;
end

--[[
function ExpeditionEastStart(faction)
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_stay_1", faction) == false then
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_3");
		if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_4", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_7", faction) == true then
			SK_BUTTONS_FACTION[faction][1] = true;
			output("Disable button 1")
		end
	elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_east_stay_1", faction) == true then
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_4");
		if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_4", faction) == true then
			SK_BUTTONS_FACTION[faction][1] = true;
			output("Disable button 1")
		end
		if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_7", faction) == true then
			SK_BUTTONS_FACTION[faction][2] = true;
			output("Disable button 2")
		end
	else
		ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_1");
	end
end

function ExpeditionEastRiverPaths(faction)
	if SK_DILEMMA_EAST_RIVER[faction] == "east" then
		if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_2", faction) == false and 
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_3", faction) == false then --If player is trading with Rus
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_5");
		elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_2", faction) == true and 
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_3", faction) == false then --If player is trading with Bulgars
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_6");
		elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_2", faction) == true and 
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_3", faction) == true then --If player is trading with Khazars
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_7");
		end
	elseif SK_DILEMMA_EAST_RIVER[faction] == "south" then
		if ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_5", faction) == false and
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_6", faction) == false then 
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_8"); --If player is trading with Rus
		elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_5", faction) == true and
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_6", faction) == false then --If player is trading with Kyjev
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_9");
		elseif ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_1", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_5", faction) == true and
		ExpeditionDilemmaUsed("vik_sea_king_expedition_east_trade_6", faction) == true then --If player is trading with Constantinople
			ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_east_10");
		end
	end
end

function ExpeditionSouthStart(faction)
	ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_south_1");
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_2", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_3", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_4", faction) == true and
	ExpeditionDilemmaUsed("vik_sea_king_expedition_south_5", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_6", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_7", faction) == true then
		SK_BUTTONS_FACTION[faction][1] = true;
		output("Disable button 1")
	end
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_south_8", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_9", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_south_10", faction) == true then
		SK_BUTTONS_FACTION[faction][2] = true;
		output("Disable button 2")
	end
end

function ExpeditionWestStart(faction)
	ExpeditionSaveNextDilemma(faction, "vik_sea_king_expedition_west_1");
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_2", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_3", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_4", faction) == true then
		SK_BUTTONS_FACTION[faction][1] = true;
		output("Disable button 1")
	end
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_5", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_6", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_7", faction) == true then
		SK_BUTTONS_FACTION[faction][2] = true;
		output("Disable button 2")
	end
	if ExpeditionDilemmaUsed("vik_sea_king_expedition_west_8", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_9", faction) == true and ExpeditionDilemmaUsed("vik_sea_king_expedition_west_10", faction) == true then
		SK_BUTTONS_FACTION[faction][3] = true;
		output("Disable button 3")
	end
end
]]--

function ExpeditionSaveNextDilemma(faction, dilemma)
	local current_turn = cm:model():turn_number();
	SK_DILEMMA_SAVE_FACTION[faction] = dilemma;
	--output(SK_DILEMMA_SAVE_FACTION[faction])
	SK_DILEMMA_TURN_FACTION[faction] = current_turn + 2;
	--output(SK_DILEMMA_TURN_FACTION[faction])
end

function ExpeditionSaveNextReward(faction, dilemma, reward)
	local current_turn = cm:model():turn_number();
	SK_DILEMMA_SAVE_FACTION[faction] = dilemma;
	--output(SK_DILEMMA_SAVE_FACTION[faction])
	SK_DILEMMA_COUNTER_FACTION[faction] = SK_DILEMMA_COUNTER_FACTION[faction] + 1;
	table.insert(SK_DILEMMAS_FACTION[faction], SK_DILEMMA_COUNTER_FACTION[faction], dilemma); 
	--output(SK_DILEMMA_COUNTER_FACTION[faction])
	SK_DILEMMA_TURN_FACTION[faction] = current_turn + 2;
	SK_REWARD_FACTION[faction] = true;
	ExpeditionResetVariables(faction, reward);
end

function ExpeditionIncidentTriggered(context, faction)
--UPDATE
	if context:dilemma() == "vik_sea_king_expedition_south_conquer_1_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_2_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_3_1" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_4_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_5_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_6_1" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_7_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_8_1" or context:dilemma() == "vik_sea_king_expedition_south_conquer_9_1"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_1_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_2_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_3_1"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_4_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_5_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_6_1" 
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_7_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_8_1" or context:dilemma() == "vik_sea_king_expedition_west_conquer_9_1" then
		if faction == "vik_fact_dyflin" then
			SK_TRIBUTE = SK_TRIBUTE + 10;
			SK_TRIBUTE_EXPEDITION = SK_TRIBUTE_EXPEDITION + 10;
			SeaKingTributeCheck("vik_fact_dyflin");
		elseif faction == "vik_fact_sudreyar" then
			SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 10;
			SK_TRIBUTE_EXPEDITION_SUD = SK_TRIBUTE_EXPEDITION_SUD + 10;
			SudreyarTributeCheck("vik_fact_sudreyar");
		end
	end
	
	if context:dilemma() == "vik_sea_king_expedition_south_conquer_1_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_2_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_3_2" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_4_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_5_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_6_2" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_7_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_8_2" or context:dilemma() == "vik_sea_king_expedition_south_conquer_9_2"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_1_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_2_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_3_2"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_4_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_5_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_6_2" 
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_7_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_8_2" or context:dilemma() == "vik_sea_king_expedition_west_conquer_9_2" then
		if faction == "vik_fact_dyflin" then
			SK_TRIBUTE = SK_TRIBUTE + 5;
			SK_TRIBUTE_EXPEDITION = SK_TRIBUTE_EXPEDITION + 5;
			SeaKingTributeCheck("vik_fact_dyflin");
		elseif faction == "vik_fact_sudreyar" then
			SK_TRIBUTE_SUD = SK_TRIBUTE_SUD + 5;
			SK_TRIBUTE_EXPEDITION_SUD = SK_TRIBUTE_EXPEDITION_SUD + 5;
			SudreyarTributeCheck("vik_fact_sudreyar");
		end
	end	
	
	if context:dilemma() == "vik_sea_king_expedition_south_conquer_1_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_2_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_3_3" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_4_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_5_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_6_3" 
	or context:dilemma() == "vik_sea_king_expedition_south_conquer_7_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_8_3" or context:dilemma() == "vik_sea_king_expedition_south_conquer_9_3"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_1_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_2_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_3_3"
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_4_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_5_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_6_3" 
	or context:dilemma() == "vik_sea_king_expedition_west_conquer_7_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_8_3" or context:dilemma() == "vik_sea_king_expedition_west_conquer_9_3" then
		if faction == "vik_fact_dyflin" then
			SK_TRIBUTE = SK_TRIBUTE - 10;
			SK_TRIBUTE_EXPEDITION = SK_TRIBUTE_EXPEDITION - 10;
			SeaKingTributeCheck("vik_fact_dyflin");
		elseif faction == "vik_fact_sudreyar" then
			SK_TRIBUTE_SUD = SK_TRIBUTE_SUD - 10;
			SK_TRIBUTE_EXPEDITION_SUD = SK_TRIBUTE_EXPEDITION_SUD - 10;
			SudreyarTributeCheck("vik_fact_sudreyar");
		end
	end
	
end

function ExpeditionResetVariables(faction, reward)
	for i = 1, #SK_BUTTONS_FACTION[faction] do
		SK_BUTTONS_FACTION[faction][i] = false;
	end
	
	if reward ~= 3 then
		CMChanceToGainItem(low, faction);
	end
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		SK_DILEMMAS_FACTION = cm:load_value("SK_DILEMMAS_FACTION", SK_DILEMMAS_FACTION, context);
		SK_DILEMMA_COUNTER_FACTION = cm:load_value("SK_DILEMMA_COUNTER_FACTION", SK_DILEMMA_COUNTER_FACTION, context);
		SK_DILEMMA_TURN_FACTION = cm:load_value("SK_DILEMMA_TURN_FACTION", SK_DILEMMA_TURN_FACTION, context);
		SK_DILEMMA_SAVE_FACTION = cm:load_value("SK_DILEMMA_SAVE_FACTION", SK_DILEMMA_SAVE_FACTION, context);
		SK_REWARD_FACTION = cm:load_value("SK_REWARD_FACTION", SK_REWARD_FACTION, context);
		SK_BUTTONS_FACTION = cm:load_value("SK_BUTTONS_FACTION", SK_BUTTONS_FACTION, context);
		SK_TRIBUTE_EXPEDITION = cm:load_value("SK_TRIBUTE_EXPEDITION", 0, context);
		SK_TRIBUTE_EXPEDITION_SUD = cm:load_value("SK_TRIBUTE_EXPEDITION_SUD", 0, context);
		NORTH_TRIP_NUMBER_FACTION = cm:load_value("NORTH_TRIP_NUMBER_FACTION", NORTH_TRIP_NUMBER_FACTION, context);
		EAST_RIVER_PATH_NUMBER_FACTION = cm:load_value("EAST_RIVER_PATH_NUMBER_FACTION", EAST_RIVER_PATH_NUMBER_FACTION, context);
		SOUTH_RIVER_PATH_NUMBER_FACTION = cm:load_value("SOUTH_RIVER_PATH_NUMBER_FACTION", SOUTH_RIVER_PATH_NUMBER_FACTION, context);
		FRISIAN_NUMBER = cm:load_value("FRISIAN_NUMBER", FRISIAN_NUMBER, context);
		SAXLAND_NUMBER = cm:load_value("SAXLAND_NUMBER", SAXLAND_NUMBER, context);
		FRANKISH_NUMBER = cm:load_value("FRANKISH_NUMBER", FRANKISH_NUMBER, context);
		RIVER_NUMBER = cm:load_value("RIVER_NUMBER", RIVER_NUMBER, context);
		SOUTH_NUMBER = cm:load_value("SOUTH_NUMBER", SOUTH_NUMBER, context);
		MEDITERRANEAN_NUMBER = cm:load_value("MEDITERRANEAN_NUMBER", MEDITERRANEAN_NUMBER, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("SK_DILEMMAS_FACTION", SK_DILEMMAS_FACTION, context);
		cm:save_value("SK_DILEMMA_COUNTER_FACTION", SK_DILEMMA_COUNTER_FACTION, context);
		cm:save_value("SK_DILEMMA_TURN_FACTION", SK_DILEMMA_TURN_FACTION, context);
		cm:save_value("SK_DILEMMA_SAVE_FACTION", SK_DILEMMA_SAVE_FACTION, context);
		cm:save_value("SK_REWARD_FACTION", SK_REWARD_FACTION, context);
		cm:save_value("SK_BUTTONS_FACTION", SK_BUTTONS_FACTION, context);
		cm:save_value("SK_DILEMMA_EAST_RIVER", SK_DILEMMA_EAST_RIVER, context);
		cm:save_value("SK_TRIBUTE_EXPEDITION", SK_TRIBUTE_EXPEDITION, context);
		cm:save_value("SK_TRIBUTE_EXPEDITION_SUD", SK_TRIBUTE_EXPEDITION_SUD, context);
		cm:save_value("NORTH_TRIP_NUMBER_FACTION", NORTH_TRIP_NUMBER_FACTION, context);
		cm:save_value("EAST_RIVER_PATH_NUMBER_FACTION", EAST_RIVER_PATH_NUMBER_FACTION, context);
		cm:save_value("SOUTH_RIVER_PATH_NUMBER_FACTION", SOUTH_RIVER_PATH_NUMBER_FACTION, context);
		cm:save_value("FRISIAN_NUMBER", FRISIAN_NUMBER, context);
		cm:save_value("SAXLAND_NUMBER", SAXLAND_NUMBER, context);
		cm:save_value("FRANKISH_NUMBER", FRANKISH_NUMBER, context);
		cm:save_value("RIVER_NUMBER", RIVER_NUMBER, context);
		cm:save_value("SOUTH_NUMBER", SOUTH_NUMBER, context);
		cm:save_value("MEDITERRANEAN_NUMBER", MEDITERRANEAN_NUMBER, context);
	end
);
