-------------------------------------------------------------------------------
------------------------------- SEASONAL EVENTS -------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 02/08/2017 ------------------------
------------------------- Last Updated: 06/02/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Random seasonal effects that can occur during the campaign
-- These are currently designed to start on turn 20, then each 40 turns after.
-- No event can repeat twice in a row, but otherwise events can occur multiple times in a campaign.

--The duration for each seasonal event to be applied for
SEASONAL_EVENT_DURATION = 8;

-- Turn delay between each seasonal event
SEASONAL_EVENT_TIMER = 21; -- Starts at 21 so we get the first event on turn 20
SEASONAL_EVENT_DELAY = 40;

-- Variable to store the turn number so we can check if it's a new turn
SEASONAL_EVENTS_TURN_NUMBER = 1;

-- Table to store event order so we don't duplicate events.
SEASONAL_EVENT_LIST = {
	"vik_incident_seasonal_global_rain_of_blood",
	"vik_incident_seasonal_global_storm_year",
	"vik_incident_seasonal_global_murrain_of_cattle",
	"vik_incident_seasonal_global_mortality_of_bees",
	"vik_incident_seasonal_global_ice_and_snow",
	"vik_incident_seasonal_global_dark_year",
	"vik_incident_seasonal_global_abundunt_harvest",
	"vik_incident_seasonal_global_st_vitus_dance",
	"vik_incident_seasonal_global_famine",
};

function Add_Seasonal_Event_Listeners()
	output("#### Adding Seasonal Event Listeners ####");
	cm:add_listener(
		"FactionTurnStart_Seasonal_Events",
		"FactionTurnStart",
		true,
		function() SeasonalEventsNewTurn() end,
		true
	);
end

function SeasonalEventsNewTurn()

	local turn = cm:model():turn_number();
	if turn > SEASONAL_EVENTS_TURN_NUMBER then
		SEASONAL_EVENTS_TURN_NUMBER = turn;
		SeasonalEvents(turn);
	end
	
end

function SeasonalEvents(turn)
	
	SEASONAL_EVENT_TIMER = SEASONAL_EVENT_TIMER + 1;
	if SEASONAL_EVENT_TIMER >= SEASONAL_EVENT_DELAY then 
		SEASONAL_EVENT_TIMER = 0;
		local x = cm:random_number(8, 1)
		if turn < 30 then 
			x = cm:random_number(9, 1)
		end
		local new_event = SEASONAL_EVENT_LIST[x];
		table.insert(SEASONAL_EVENT_LIST, 9, table.remove(SEASONAL_EVENT_LIST,x))
		local faction_list = cm:model():world():faction_list();
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			if current_faction:is_null_interface() == false and current_faction:is_dead() == false then
				if current_faction:is_human() == true then
					cm:trigger_incident(current_faction:name(), new_event, true);
				else
					cm:apply_effect_bundle(new_event, current_faction:name(), (SEASONAL_EVENT_DURATION + 1));
				end
			end
		end
	end

end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		SEASONAL_EVENT_TIMER = cm:load_value("SEASONAL_EVENT_TIMER", 21, context);
		SEASONAL_EVENTS_TURN_NUMBER = cm:load_value("SEASONAL_EVENTS_TURN_NUMBER", 1, context);
		SEASONAL_EVENT_LIST = cm:load_value("SEASONAL_EVENT_LIST", SEASONAL_EVENT_LIST, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("SEASONAL_EVENT_TIMER", SEASONAL_EVENT_TIMER, context);
		cm:save_value("SEASONAL_EVENTS_TURN_NUMBER", SEASONAL_EVENTS_TURN_NUMBER, context);
		cm:save_value("SEASONAL_EVENT_LIST", SEASONAL_EVENT_LIST, context);
	end
);