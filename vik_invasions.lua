-------------------------------------------------------------------------------
------------------------- VIKING INVASIONS ------------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 20/06/2017 ------------------------
------------------------- Last Updated: 14/05/2018 by Craig -------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- RANDOM INVASIONS
-- The Invasions script is used to spawn random Viking invasions, as well as any additional scripted invasions needed by the events.
-- Invading factions will never make peace, will have hyper-aggressive AI personalities, and will spawn with their armies in the sea. 
-- Armies created by the invasion will spawn at a random set of x/y coordinates as determined by the designated invasion location table.
-- If all spawn locations are unavailable then no invaders will spawn. 
-- If the AI is somehow occupying all hexes then something has probably gone wrong, or we are spawning too many simultaneous invasions.
-- Multiple invasions spawning at the same time won't register as occupying the spawn locations, so the script temporarily saves these locations as unavailable.

-- ENDGAME INVASIONS
-- The invasion script will begin after the player has completed one of 3 long victory objectives, and enable the ultimate victory.
-- When the invasion script begins, the player will get a series of events warning them about the upcoming invasion. The invasion will trigger after this short narrative event chain.
-- There are 3 potential endgame invasion factions, with more spawning on higher difficulties.
-- A maximum of 1 will spawn on easy, and all 3 will appear on Very Hard/Legendary
-- Endgame invaders will also by hyper-aggressive, but will focus on occupation and expansion instead of sheer chaos.
-- We turn off random viking raids once the final Viking has spawned.
-- Victory is achieved by killing all da remaining Vikings

-- Used to generate unique ids for each force spawned by the invasion.
INVASIONS_NUMBER = 0;

-- Safety feature to make sure no armies spawn in the same x/y coords if an invasion contains multiples forces
INVASIONS_LOCATION_BLOCKERS = {};

-- Difficulty modifiers for Viking Invasions. These are mod+turn% chance of being 2nd tier, and mod+turn-100% chance of being 3rd tier.
-- Can be modified manually.
INVASIONS_EASY_MOD = -50;
INVASIONS_NORMAL_MOD = 0;
INVASIONS_HARD_MOD = 50;
INVASIONS_VERY_HARD_MOD = 100;
INVASIONS_LEGENDARY_MOD = 100;

-- Tech checks for random invasions. These are turn * INVASIONS_TECH_MOD for mid-game units, and turn * INVASIONS_TECH_MOD - 100 for late-game units
-- Can be modified manually.
INVASIONS_TECH_MOD = 2;

-- Unique keys for each invasion are saved in this table so that they don't trigger more than once.
INVASIONS_SPAWNED_SCRIPTED_INVASIONS = {};

-- Temporary location to save invaders for declaring war, as this does not function when they are newly spawned
INVASIONS_PENDING_WARS = {};

-- Variable to store the turn number so we can check if it's a new turn
INVASIONS_TURN_NUMBER = 1;

-- Table for setting up and storing the various different endgame mechanics
INVASIONS_END = {};

-- Variable to make sure we don't trigger the endgame multiple times if the player gets multiple victory types
INVASIONS_END_INITALISED = false;

-- Variable stores whether or not we should be checking for ultimate victory
INVASIONS_END_ULTIMATE_ACTIVE = false;

-- Stops the victory message repeating after all the vikings are dead
INVASIONS_ULTIMATE_VICTORY_ACHIEVED = false;

-- Delays for the endgame invasions to arrive. This is added to the turn number to determine the turn range.
-- Can be modified manually. Script assumes the Normans are first and the Norse are last.
INVASIONS_NORMANS_MIN_DELAY = 1;
INVASIONS_NORMANS_MAX_DELAY = 2;
INVASIONS_DANES_MIN_DELAY = 3;
INVASIONS_DANES_MAX_DELAY = 4;
INVASIONS_NORSE_MIN_DELAY = 5;
INVASIONS_NORSE_MAX_DELAY = 6;

-- AI AUTORUN ONLY SETTINGS. Only checked when there are zero human players. Spawns the endgame invaders are any point between the EARLIEST and LATEST turn range.
-- Can be modified manually.
INVASIONS_END_AUTORUN_EARLIEST = 250;
INVASIONS_END_AUTORUN_LATEST = 255;

-- MPC ONLY SETTINGS. Spawns the endgame invaders are any point between the EARLIEST and LATEST turn range.
-- Can be modified manually.
INVASIONS_END_MPC_TURNS = 100;
INVASIONS_END_MPC_REGIONS = 70;

-- Table to store a counter of trespasses against a certain faction. This is to force wars and make the vikings a bit more treacherous.
INVASIONS_TRESPASS = {}

INVASIONS_ARMY_LISTS = {
	vik_fact_dubgaill = "raider_norse",
	vik_fact_finngaill = "raider_norse",
	vik_fact_wicing = "raider_norse",
	vik_fact_nordmann = "raider_norse",
	vik_fact_haeden = "raider_dane",
	vik_fact_dene = "invader_dane",
	vik_fact_norse = "invader_norse",
	vik_fact_normaunds = "invader_norman"	
}


-------------------------------------------------
------------------ INVASIONS SETUP --------------
-------------------------------------------------

-- Create the Viking Invasions Army Templates and setup the listener for random invasions
function SetupVikingInvasions()
	-- Create the templates for random invasions
	InvasionsCreateRandomForces()
	
	-- Setup the endgame invasions
	output("#### Adding Endgame Invasions Listeners ####");
	cm:add_listener(
		"MissionSucceeded_Victory",
		"MissionSucceeded",
		function(context) return context:mission():mission_record_key() == "vik_vc_fame_2" or context:mission():mission_record_key() == "vik_vc_conquest_2" or context:mission():mission_record_key() == "vik_vc_kingdom_2" end,
		function() InvasionsInitialiseEndgame() end,
		true
	);
	
	-- Setup the random invasions
	output("#### Adding Random Invasions Listeners ####")
	cm:add_listener(
		"FactionTurnStart_Invasions",
		"FactionTurnStart",
		function() return InvasionsNewTurnCheck() == true end,
		function() InvasionsNewTurn() end,
		true
	);
	cm:add_listener(
		"FactionTurnStart_Invasions",
		"FactionTurnStart",
		function(context) return INVASIONS_PENDING_WARS[context:faction():name()] ~= nil end,
		function(context) InvasionsSetInvadersHostile(context) end,
		true
	);
	cm:add_listener(
		"FactionTurnStart_InvasionsMinorWarDeclarations",
		"FactionTurnStart",
		function(context) return context:faction():subculture() == "vik_sub_cult_viking" and context:faction():name() ~= "vik_fact_dene" and context:faction():name() ~= "vik_fact_normaunds" and context:faction():name() ~= "vik_fact_norse" end,
		function(context) InvasionsMinorWarDeclarations(context) end,
		true
	);
	cm:add_listener(
		"FactionTurnStart_InvasionsMinorWarDeclarations",
		"FactionTurnStart",
		function(context) return context:faction():subculture() == "vik_sub_cult_viking" and (context:faction():name() == "vik_fact_dene" or context:faction():name() == "vik_fact_normaunds" or context:faction():name() == "vik_fact_norse") end,
		function(context) InvasionsMajorWarDeclarations(context) end,
		true
	);
	cm:add_listener(
		"FactionDestroyed_Invasions",
		"FactionDestroyed",
		function() return INVASIONS_END_ULTIMATE_ACTIVE == true and INVASIONS_ULTIMATE_VICTORY_ACHIEVED == false end,
		function() InvasionsCheckUltimateVictory() end,
		true
	);
	
	-- Sets the number of invading armies based upon difficulty settings
	END_INVADERS_COUNT = 5;
	local difficulty = cm:model():difficulty_level();
	if  difficulty == -1 then -- Hard
		END_INVADERS_COUNT = 6;
	elseif difficulty == -2 then -- Very Hard
		END_INVADERS_COUNT = 7;
	elseif difficulty == -3 then -- Legendary
		END_INVADERS_COUNT = 8;
	end

end

-----------------------------------------------------
------------------ Invasions Functions --------------
-----------------------------------------------------

-- Checks to see if this is a normal campaign or an autorun
function InvasionsEndHumanCheck()
	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		if faction:is_human() == true then
			return true;
		end;
	end;
	return false;
end;

-- Trigger big ol' invasion baddies in multiplayer campaign
function InvasionsEndMPC()
	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		if faction:is_human() == true and faction:region_list():num_items() >= INVASIONS_END_MPC_REGIONS then
			return true;
		end;
	end;
	return false;
end

-- Checks for random invasions each turn and spawns them if we want one
		-- Each invasion requires a unique invasion key to spawn, e.g. "INVASIONS_1"
		-- Format to create new invasions:
		-- InvasionsInvasionCheck(invader, spawn_location, unique_key, min_armies, max_armies, earliest_turn, latest_turn, min_units, max_units)
function InvasionsRandomInvasionsCheck()
	
	-- Endgame invasions - The big bad evil guys of the campaign. Used for the ultimate victory condition
	-- The turn to spawn these is determined by a long campaign victory. 0-3 of these will spawn, based on difficulty.
	if InvasionsEndHumanCheck() == true then
		if INVASIONS_END["DANES"] ~= nil then
			InvasionsInvasionCheck("vik_fact_dene", VIK_INVASIONS_NORTH_EAST_ENGLAND, "INVASIONS_END_DANES", END_INVADERS_COUNT, END_INVADERS_COUNT, (INVASIONS_END["DANES"] + INVASIONS_DANES_MIN_DELAY), (INVASIONS_END["DANES"] + INVASIONS_DANES_MAX_DELAY), 14, 19)
		end
		if INVASIONS_END["NORSE"] ~= nil then
			InvasionsInvasionCheck("vik_fact_norse", VIK_INVASIONS_NORTH_WEST_SCOTLAND, "INVASIONS_END_NORSE", END_INVADERS_COUNT, END_INVADERS_COUNT, (INVASIONS_END["NORSE"] + INVASIONS_NORSE_MIN_DELAY), (INVASIONS_END["NORSE"] + INVASIONS_NORSE_MAX_DELAY), 14, 19)
		end
		if INVASIONS_END["NORMANS"] ~= nil then
			InvasionsInvasionCheck("vik_fact_normaunds", VIK_INVASIONS_SOUTH_ENGLAND, "INVASIONS_END_NORMANS", END_INVADERS_COUNT, END_INVADERS_COUNT, (INVASIONS_END["NORMANS"] + INVASIONS_NORMANS_MIN_DELAY), (INVASIONS_END["NORMANS"] + INVASIONS_NORMANS_MAX_DELAY), 14, 19)
		end
	else 
		-- End game invasions for AI-only autoruns
		InvasionsInvasionCheck("vik_fact_dene", VIK_INVASIONS_NORTH_EAST_ENGLAND, "INVASIONS_END_DANES", END_INVADERS_COUNT, END_INVADERS_COUNT, INVASIONS_END_AUTORUN_EARLIEST, INVASIONS_END_AUTORUN_LATEST, 14, 19);
		InvasionsInvasionCheck("vik_fact_norse", VIK_INVASIONS_NORTH_WEST_SCOTLAND, "INVASIONS_END_NORSE", END_INVADERS_COUNT, END_INVADERS_COUNT, INVASIONS_END_AUTORUN_EARLIEST, INVASIONS_END_AUTORUN_LATEST, 14, 19);
		InvasionsInvasionCheck("vik_fact_normaunds", VIK_INVASIONS_SOUTH_ENGLAND, "INVASIONS_END_NORMANS", END_INVADERS_COUNT, END_INVADERS_COUNT, INVASIONS_END_AUTORUN_EARLIEST, INVASIONS_END_AUTORUN_LATEST, 14, 19);
	end
	
	--Disable minor invasions once the ultimate victory is active
	if INVASIONS_END_ULTIMATE_ACTIVE == false then
		
		InvasionsInvasionCheck("vik_fact_wicing", VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_1", 1, 1, 5, 5, 12, 12)
		InvasionsInvasionCheck("vik_fact_finngaill", VIK_INVASIONS_SOUTH_IRELAND, "INVASIONS_2", 1, 1, 13, 13, 12, 12)
		InvasionsInvasionCheck("vik_fact_nordmann", VIK_INVASIONS_SOUTH_ENGLAND, "INVASIONS_3", 1, 1, 13, 13, 12, 12)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_4", 1, 1, 29, 49, 12, 14)
		InvasionsInvasionCheck("vik_fact_haeden", VIK_INVASIONS_NORTH_EAST_ANGLA, "INVASIONS_5", 1, 1, 29, 49, 12, 15)
		InvasionsInvasionCheck("vik_fact_dubgaill", VIK_INVASIONS_NORTH_WEST_IRELAND, "INVASIONS_6", 1, 1, 29, 49, 12, 14)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_7", 1, 1, 53, 69, 13, 15)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_8", 1, 1, 89, 109, 13, 15)
		InvasionsInvasionCheck("vik_fact_haeden", VIK_INVASIONS_EAST_SCOTLAND, "INVASIONS_9", 1, 1, 89, 109, 17, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_10", 1, 1, 129, 149, 13, 15)
		InvasionsInvasionCheck(FACTIONS_INVADERS_IRELAND, VIK_INVASIONS_SOUTH_IRELAND, "INVASIONS_11", 1, 1, 141, 153, 13, 15)
		InvasionsInvasionCheck("vik_fact_haeden", VIK_INVASIONS_EAST_SCOTLAND, "INVASIONS_12", 1, 1, 141, 153, 12, 13)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_13", 1, 1, 149, 169, 15, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_IRELAND, VIK_INVASIONS_SOUTH_IRELAND, "INVASIONS_14", 1, 1, 169, 189, 17, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_IRELAND, VIK_INVASIONS_NORTH_WEST_IRELAND, "INVASIONS_15", 1, 1, 181, 197, 19, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_16", 1, 1, 197, 205, 19, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_IRELAND, VIK_INVASIONS_NORTH_WEST_IRELAND, "INVASIONS_17", 1, 1, 209, 229, 19, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_18", 1, 1, 236, 262, 17, 19)
		InvasionsInvasionCheck("vik_fact_haeden", VIK_INVASIONS_EAST_SCOTLAND, "INVASIONS_19", 1, 1, 259, 281, 12, 15)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_ENGLAND, "INVASIONS_20", 1, 2, 281, 324, 19, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_21", 1, 2, 328, 361, 17, 19)
		InvasionsInvasionCheck("vik_fact_haeden", VIK_INVASIONS_EAST_SCOTLAND, "INVASIONS_22", 1, 2, 363, 406, 17, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_23", 1, 2, 404, 457, 12, 13)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_WEST_ENGLAND, "INVASIONS_24", 2, 2, 510, 560, 17, 19)
		InvasionsInvasionCheck(FACTIONS_INVADERS_SOUTH, VIK_INVASIONS_SOUTH_ENGLAND, "INVASIONS_25", 2, 2, 560, 600, 17, 19)
			
	end
	
	--1066 autumn :)
	InvasionsInvasionCheck("vik_fact_normaunds", VIK_INVASIONS_SOUTH_EAST_ENGLAND, "INVASIONS_26", END_INVADERS_COUNT, END_INVADERS_COUNT, 755, 755, 17, 19)
	
	--Now that invasions have spawned check and clear blockers for future turns
	InvasionsResetBlockers();
	
end

-- Checks to see if this is a new turn
function InvasionsNewTurnCheck()
	local turn = cm:model():turn_number();
	if turn > INVASIONS_TURN_NUMBER then
		INVASIONS_TURN_NUMBER = turn;
		return true;
	end
end

-- Checks if we should be firing end-game invader events, and then checks for random invasions
function InvasionsNewTurn()
	local turn = cm:model():turn_number();
	if cm:is_multiplayer() and (InvasionsEndMPC() == true or turn >= INVASIONS_END_MPC_TURNS) then
		InvasionsInitialiseEndgame()
	end
	if INVASIONS_END[tostring(turn)] ~= nil then
		output("INVASIONS_END[turn] isn't nil!")
		if INVASIONS_END[tostring(turn)] == 5 and cm:is_multiplayer() == false then
			INVASIONS_END_ULTIMATE_ACTIVE = true;
			if get_faction("vik_fact_dene"):is_dead() == true and get_faction("vik_fact_normaunds"):is_dead() == true and get_faction("vik_fact_norse"):is_dead() == true then
				INVASIONS_ULTIMATE_VICTORY_ACHIEVED = true;
				output("vikings are dead yo")
				cm:complete_scripted_mission_objective("vik_vc_invasion", "vik_vc_ultimate_scripted", true)
				TriggerIncidentMPSafe("vik_incident_invasion_end_victory_b");
			else
				local incident = "vik_incident_invasion_end_invaders_"..INVASIONS_END["total_invaders"]
				output("vikings are alive yay")
				TriggerIncidentMPSafe(incident);
			end
		else
			local incident_number = INVASIONS_END[tostring(turn)];
			local incident = "vik_incident_invasion_end_"..incident_number;
			output("############### triggering incident "..incident)
			TriggerIncidentMPSafe(incident);
		end
	end
	InvasionsRandomInvasionsCheck()
end

-- Checks for random invasions and spawns them if the conditions have been met
function InvasionsInvasionCheck(invader_faction, spawn_location, invasion_key, lower_strength, upper_strength, lower_turn, upper_turn, min_units, max_units)
	local turn = cm:model():turn_number();
	if INVASIONS_SPAWNED_SCRIPTED_INVASIONS[invasion_key] ~= "spawned" and turn >= lower_turn then
		local chance1 = turn - lower_turn + 1;
		local chance2 = upper_turn - lower_turn + 1;
		if chance1 > chance2 then
			chance1 = chance2;
		end
		if cm:model():random_percent(chance1 / chance2 * 100) == true then
			local invader = "";
			if not is_string(invader_faction) then
				invader = invader_faction[cm:random_number(#invader_faction, 1)];
			else
				invader = invader_faction
			end
			if INVASIONS_PENDING_WARS[invader] ~= nil then
				return
			else
				local strength = cm:random_number(upper_strength, lower_strength);
				InvasionsTriggerInvasion(invader, spawn_location, strength, min_units, max_units);
				INVASIONS_SPAWNED_SCRIPTED_INVASIONS[invasion_key] = "spawned";
			end
		end
	end
end

-- Spawns a specific Viking army chosen from the force lists
function InvasionsSpawnSpecificForce(faction_key, force_key, location_key)
	local real_force_key = INVASIONS_ARMY_LISTS[faction_key]
	if not real_force_key then
		return
	end
	local SpawnLocation = InvasionsCreateSpawnLocation(location_key);
	output("SpawnLocation = "..tostring(SpawnLocation))
	if SpawnLocation == 0 then
		output("#### INVASIONS IS NOT SPAWNING DUE TO LACK OF VIABLE SPAWN LOCATIONS!! ####")
		return
	else
		local force = Random_Army_Manager:generate_force(real_force_key, 20, false);
		local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
		INVASIONS_NUMBER = INVASIONS_NUMBER + 1;
		local invasion_id = "viking_invasion_"..INVASIONS_NUMBER;
		cm:create_force(faction_key, force, temp_region, location_key["x"..SpawnLocation], location_key["y"..SpawnLocation], invasion_id, true)
		INVASIONS_LOCATION_BLOCKERS[tostring(location_key)..tostring(SpawnLocation)] = "blocked";
	end
end

-- Spawns a random Viking army with tech/unit tiers determined by difficulty and time.
function InvasionsSpawnRandomForce(faction_key, location_key, units, incident, incident_fired)
	local SpawnLocation = InvasionsCreateSpawnLocation(location_key);
	if SpawnLocation == 0 then
		output("#### INVASIONS IS NOT SPAWNING DUE TO LACK OF VIABLE SPAWN LOCATIONS!! ####")
		return
	else
		local difficulty = InvasionsDifficultyCheck()
		local tech = InvasionsTechCheck()
		local force_key = INVASIONS_ARMY_LISTS[faction_key]
		output("#### SPAWNING RANDOM INVASIONS. THE CHOSEN force_key = "..force_key.." ####");
		local force = Random_Army_Manager:generate_force(force_key, units, false);
		local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
		INVASIONS_NUMBER = INVASIONS_NUMBER + 1;
		local invasion_id = "viking_invasion_"..INVASIONS_NUMBER;
		cm:create_force(faction_key, force, temp_region, location_key["x"..SpawnLocation], location_key["y"..SpawnLocation], invasion_id, true)
		INVASIONS_LOCATION_BLOCKERS[tostring(location_key)..tostring(SpawnLocation)] = "blocked";
		--Inform the player that the invasion has occured if this is the first army from this invasion
		if incident_fired == false then
			output("Vikings are coming! Fire the incident: "..incident);
			TriggerIncidentLocationMPSafe(incident, location_key["x"..SpawnLocation], location_key["y"..SpawnLocation]);
		end
	end
end

-- Choose one of the random spawn locations at the designated location_key
function InvasionsCreateSpawnLocation(location_key)
	local spawn_locations = 0;
	local t = {};
	for i = 1, 8 do
		if INVASIONS_LOCATION_BLOCKERS[tostring(location_key)..tostring(i)] ~= "blocked" then
			local x = location_key["x"..i];
			local y = location_key["y"..i];
			if InvasionsIsValidPosition(x, y) == true then
				spawn_locations = spawn_locations + 1;
				t[spawn_locations] = i;
			end
		end
	end
	if spawn_locations == 0 then
		return 0
	else
		local SpawnLocationNumber = t[cm:random_number(spawn_locations, 1)];
		return SpawnLocationNumber;
	end
end

-- Make sure nobody is currently standing at the chosen x/y coordinates
function InvasionsIsValidPosition(x, y)
	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		local char_list = faction:character_list();
		for i = 0, char_list:num_items() - 1 do
			local character = char_list:item_at(i);
			if character:logical_position_x() == x and character:logical_position_y() == y then
				return false;
			end;
		end;
	end;
	return true;
end;

-- Clear temporarily blocked invasion locations.
function InvasionsResetBlockers()
	INVASIONS_LOCATION_BLOCKERS = {};
end

-- Check which tier of units to use for spawned units in the Invasions force
function InvasionsDifficultyCheck()
	local difficulty = cm:model():difficulty_level();
	local difficulty_mod = 0;
	if difficulty == 1 then -- Easy
		difficulty_mod = INVASIONS_EASY_MOD
	elseif difficulty == 0 then -- Normal
		difficulty_mod = INVASIONS_NORMAL_MOD
	elseif difficulty == -1 then -- Hard
		difficulty_mod = INVASIONS_HARD_MOD
	elseif difficulty == -2 then -- Very Hard
		difficulty_mod = INVASIONS_VERY_HARD_MOD
	elseif difficulty == -3 then -- Legendary
		difficulty_mod = INVASIONS_LEGENDARY_MOD
	end
	local turn = cm:model():turn_number();
	local force_difficulty = difficulty_mod + turn;
	force_difficulty = math.max(force_difficulty, 0);
	force_difficulty = math.min(force_difficulty, 100);
	if cm:model():random_percent(force_difficulty) then
		force_difficulty = difficulty_mod + turn - 100;
		force_difficulty = math.max(force_difficulty, 0);
		force_difficulty = math.min(force_difficulty, 100);
		if cm:model():random_percent(force_difficulty) then
			return "hard";
		else
			return "medium";
		end
	else
		return "easy";
	end
end

-- Check which level of tech to use for spawned units in the Invasions force
function InvasionsTechCheck()
	local turn = cm:model():turn_number();
	local force_tech = INVASIONS_TECH_MOD * turn;
	force_difficulty = math.max(force_tech, 0);
	force_difficulty = math.min(force_tech, 100);
	if cm:model():random_percent(force_tech) then
		force_tech = INVASIONS_TECH_MOD * turn - 100;
		force_tech = math.max(force_tech, 0);
		force_tech = math.min(force_tech, 100);
		if cm:model():random_percent(force_tech) then
			return "late";
		else
			return "middle";
		end
	else
		return "early";
	end
end

-- Makes sure the invaders hate the owner of the target settlement, then declares war on them if they are not already at war
function InvasionsSetInvadersHostile(context)
	local turn = cm:model():turn_number();
	local invader_key = context:faction():name();
	local target_key = "";
	if turn == 5 and context:faction():name() == "vik_fact_wicing" and cm:model():world():faction_by_key("vik_fact_east_engle"):is_dead() == false then
		target_key = "vik_fact_east_engle";
	else
		local region_list = cm:model():world():region_manager():region_list();
		local target_distance = 0;
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			local lx = region:settlement():logical_position_x() - INVASIONS_PENDING_WARS[invader_key]["x"]
			local ly = region:settlement():logical_position_y() - INVASIONS_PENDING_WARS[invader_key]["y"]
			local region_distance = ((lx * lx) + (ly * ly))
			if (target_key == "" or region_distance < target_distance) and region:owning_faction():is_null_interface() == false and region:owning_faction():name() ~= "rebels" and invader_key ~= region:owning_faction():name() then
				target_key = region:owning_faction():name();
				target_distance = region_distance;
			end
		end
	end
	output("target_key = "..target_key.." and invader_key = "..invader_key);
	SetFactionsHostile(invader_key, target_key);
	local invaders_by_key = cm:model():world():faction_by_key(invader_key);
	local target_by_key = cm:model():world():faction_by_key(target_key);
	if invaders_by_key:at_war_with(target_by_key) == false then
		cm:force_declare_war(invader_key, target_key);
	end
	INVASIONS_PENDING_WARS[invader_key] = nil;
end

-- Spawns the designated number of forces for the faction at the location, sets them to go hostile with their target on their turn, and gives a cash injection if they are a major
function InvasionsTriggerInvasion(faction_key, spawn_location, number, min_units, max_units)
	local faction = string.gsub(faction_key, "vik_fact_", "")
	local direction = spawn_location["direction"];
	local incident_number = number;
	if faction_key == "vik_fact_dene" or faction_key == "vik_fact_normaunds" or faction_key == "vik_fact_norse" then
		incident_number = 5;
	end
	local incident = "vik_incident_invasion_"..faction.."_"..direction.."_"..incident_number;
	local incident_fired = false
	for i = 1,number do
		local units = cm:random_number(max_units, min_units); 
		InvasionsSpawnRandomForce(faction_key, spawn_location, units, incident, incident_fired)
		incident_fired = true
	end
	INVASIONS_PENDING_WARS[faction_key] = INVASIONS_PENDING_WARS[faction_key] or {};
	INVASIONS_PENDING_WARS[faction_key]["x"] = spawn_location["x1"]
	INVASIONS_PENDING_WARS[faction_key]["y"] = spawn_location["y1"]
	if faction_key == "vik_fact_dene" or faction_key == "vik_fact_normaunds" or faction_key == "vik_fact_norse" then
		cm:treasury_mod(faction_key, 20000);
		cm:remove_effect_bundle("vik_faction_trait_vikings", faction_key)
		cm:apply_effect_bundle("vik_faction_trait_vikings_major", faction_key, 0)
	end
end

-- Forces the minor Vikings to declare war on people if they have been trespassing for a while in their terrain
function InvasionsMinorWarDeclarations(context)
	local faction_by_key = context:faction()
	if faction_by_key:is_human() == false then
		local force_list = faction_by_key:military_force_list()
		for i = 0, force_list:num_items() - 1 do
			if force_list:item_at(i):has_general() and force_list:item_at(i):general_character():has_region() then
				if force_list:item_at(i):general_character():region():owning_faction():is_null_interface() == false and force_list:item_at(i):general_character():region():owning_faction():name() ~= "rebels" then
					local region_owner_by_key = force_list:item_at(i):general_character():region():owning_faction()
					if faction_by_key:name() ~= region_owner_by_key:name() and faction_by_key:at_war_with(region_owner_by_key) == false then
						if INVASIONS_TRESPASS[faction_by_key:name()] ~= nil and INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] ~= nil then
							if INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] >= 5 then
								if cm:model():random_percent(INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] / 10 * 100) == true then
									cm:force_declare_war(faction_by_key:name(), region_owner_by_key:name());
									INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] = nil
								else
									INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] = INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] + 1
								end
							else
								INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] = INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] + 1
							end
						else
							INVASIONS_TRESPASS[faction_by_key:name()] = INVASIONS_TRESPASS[faction_by_key:name()] or {}
							INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] = 1
						end
					else
						if INVASIONS_TRESPASS[faction_by_key:name()] ~= nil then
							if INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] ~= nil then
								INVASIONS_TRESPASS[faction_by_key:name()][region_owner_by_key:name()] = nil
							end
						end
					end
				end
			end
		end
	end
end

function InvasionsMajorWarDeclarations(context)
	local invader_by_key = context:faction();
	local check = false
	if invader_by_key:is_human() == false then
		for i = 0, cm:model():world():faction_list():num_items() - 1 do
			local faction = cm:model():world():faction_list():item_at(i)
			if faction:is_dead() == false and faction:at_war_with(invader_by_key) == true then
				check = true;
			end
		end
		if check == false then
			local force_list = invader_by_key:military_force_list()
			local invader_key = context:faction():name();
			local target_key = "";
			local region_list = cm:model():world():region_manager():region_list();
			local target_distance = 0;
			for i = 0, force_list:num_items() - 1 do
				if force_list:item_at(i):has_general() and force_list:item_at(i):general_character():has_region() then
					for j = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(j);
						local lx = region:settlement():logical_position_x() - force_list:item_at(i):general_character():logical_position_x()
						local ly = region:settlement():logical_position_y() - force_list:item_at(i):general_character():logical_position_y()
						local region_distance = ((lx * lx) + (ly * ly))
						if (target_key == "" or region_distance < target_distance) and region:owning_faction():is_null_interface() == false and region:owning_faction():name() ~= "rebels" and invader_key ~= region:owning_faction():name() and region:owning_faction():is_vassal_of(cm:model():world():faction_by_key(invader_key)) == false then
							target_key = region:owning_faction():name();
							target_distance = region_distance;
						end
					end
				end
			end
			output(invader_key.." is not at war, so declaring war on the nearest neighbour. Sorry "..target_key.."!");
			SetFactionsHostile(invader_key, target_key);
			cm:treasury_mod(invader_key, 5000);
			cm:force_declare_war(invader_key, target_key);
		end
	end
end

---------------------------------------------------
--------- Endgame Invasions Functions -------------
---------------------------------------------------

-- Work out what endgame factions are invading, where they are invading, and when
function InvasionsInitialiseEndgame()
	if INVASIONS_END_INITALISED == false then
		INVASIONS_END_INITALISED = true
		local difficulty = cm:model():difficulty_level();
		-- Default: Easy values
		local minimum_invaders = 1;
		local maximum_invaders = 1
		if difficulty == 0 then -- Normal
			minimum_invaders = 2;
			maximum_invaders = 2;
		elseif difficulty == -1 then -- Hard
			minimum_invaders = 2;
			maximum_invaders = 3;
		elseif difficulty == -2 then -- Very Hard
			minimum_invaders = 3;
			maximum_invaders = 3;
		elseif difficulty == -3 then -- Legendary
			minimum_invaders = 3;
			maximum_invaders = 3;
		end
		INVASIONS_END["total_invaders"] = cm:random_number(maximum_invaders, minimum_invaders);
		local invaders = INVASIONS_END["total_invaders"];
		InvasionsDetermineEndgameInvaders(invaders)
	end
end

-- Setup the factions that are going to be end game invaders, and time the event chain
function InvasionsDetermineEndgameInvaders(invaders)
	output("invaders is "..tostring(invaders)..", and I'm running through InvasionsDetermineEndgameInvaders");
	local delay = cm:model():turn_number() + cm:random_number(3, 1); 
	INVASIONS_END[tostring(delay)] = 2;
	delay = delay + cm:random_number(3, 1);
	INVASIONS_END[tostring(delay)] = 3;
	delay = delay + cm:random_number(3, 1);
	INVASIONS_END[tostring(delay)] = 4;
	local t = {
		"NORMANS",
		"DANES",
		"NORSE";
	};
	if invaders ~= 0 then
		for i = 1, invaders do
			local j = cm:random_number(#t, 1);
			local invader = t[j];
			output("invader = "..t[j]);
			INVASIONS_END[invader] = delay;
			table.remove(t, j);
		end
	end
	if INVASIONS_END["NORSE"] ~= nil then
		delay = delay + INVASIONS_NORSE_MAX_DELAY;
	elseif INVASIONS_END["DANES"] ~= nil then
		delay = delay + INVASIONS_DANES_MAX_DELAY;
	elseif INVASIONS_END["NORMANS"] ~= nil then
		delay = delay + INVASIONS_NORMANS_MAX_DELAY;
	end
	delay = delay + 1;
	INVASIONS_END[tostring(delay)] = 5;
end

-- Check to see if the player has won the game after the endgame invasions are active
function InvasionsCheckUltimateVictory()
	if get_faction("vik_fact_dene"):is_dead() == true and get_faction("vik_fact_normaunds"):is_dead() == true and get_faction("vik_fact_norse"):is_dead() == true then
		INVASIONS_ULTIMATE_VICTORY_ACHIEVED = true;
		output("vikings are dead yo")
		cm:complete_scripted_mission_objective("vik_vc_invasion", "vik_vc_ultimate_scripted", true)
		TriggerIncidentMPSafe("vik_incident_invasion_end_victory_a");
	end
end

-------------------------------------------
--------- Invasions Army Setup ------------
-------------------------------------------

-- Creates the forces for the Random Army Manager to use for Viking Invasionss
function InvasionsCreateRandomForces()
	Random_Army_Manager:new_force("raider_norse");
	Random_Army_Manager:add_mandatory_unit("raider_norse", "est_marauders", 2);
	Random_Army_Manager:add_mandatory_unit("raider_norse", "est_spear_hirdmen", 1);
	Random_Army_Manager:add_unit("raider_norse", "est_shield_biters", 1);
	Random_Army_Manager:add_unit("raider_norse", "est_marauders", 1);
	Random_Army_Manager:add_unit("raider_norse", "est_spear_hirdmen", 3);

	Random_Army_Manager:new_force("raider_dane");
	Random_Army_Manager:add_mandatory_unit("raider_norse", "dan_ceorl_axemen", 2);
	Random_Army_Manager:add_mandatory_unit("raider_norse", "dan_anglian_raiders", 1);
	Random_Army_Manager:add_unit("raider_norse", "dan_berserkers", 1);
	Random_Army_Manager:add_unit("raider_norse", "dan_ceorl_axemen", 1);
	Random_Army_Manager:add_unit("raider_norse", "dan_anglian_raiders", 3);

	Random_Army_Manager:new_force("invader_dane");
	Random_Army_Manager:add_mandatory_unit("invader_dane", "dan_ceorl_spearmen", 3);
	Random_Army_Manager:add_mandatory_unit("invader_dane", "dan_sword_hirdmen", 2);
	Random_Army_Manager:add_mandatory_unit("invader_dane", "dan_anglian_raiders", 4);
	Random_Army_Manager:add_mandatory_unit("invader_dane", "dan_archers", 2);
	Random_Army_Manager:add_unit("invader_dane", "dan_ceorl_spearmen", 1);
	Random_Army_Manager:add_unit("invader_dane", "dan_sword_hirdmen", 1);
	Random_Army_Manager:add_unit("invader_dane", "dan_anglian_raiders", 1);
	Random_Army_Manager:add_unit("invader_dane", "dan_jarls_horsemen", 1);
	Random_Army_Manager:add_unit("invader_dane", "dan_mailed_swordsmen", 1);
	Random_Army_Manager:add_unit("invader_dane", "dan_huscarls", 2);
	Random_Army_Manager:add_unit("invader_dane", "dan_berserkers", 1);

	Random_Army_Manager:new_force("invader_norse");
	Random_Army_Manager:add_mandatory_unit("invader_norse", "est_spearband", 3);
	Random_Army_Manager:add_mandatory_unit("invader_norse", "est_spear_guard", 2);
	Random_Army_Manager:add_mandatory_unit("invader_norse", "est_spear_hirdmen", 4);
	Random_Army_Manager:add_mandatory_unit("invader_norse", "est_hunters", 2);
	Random_Army_Manager:add_mandatory_unit("invader_norse", "est_archers", 2);
	Random_Army_Manager:add_unit("invader_norse", "est_marauders", 1);
	Random_Army_Manager:add_unit("invader_norse", "est_mailed_axemen", 1);
	Random_Army_Manager:add_unit("invader_norse", "est_long_axes", 1);
	Random_Army_Manager:add_unit("invader_norse", "est_scouts", 1);
	Random_Army_Manager:add_unit("invader_norse", "dan_mailed_swordsmen", 1);
	Random_Army_Manager:add_unit("invader_norse", "vik_mailed_archers", 2);
	Random_Army_Manager:add_unit("invader_norse", "est_shield_biters", 1);

	Random_Army_Manager:new_force("invader_norman");
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_spearmen", 3);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_levy_spearmen", 2);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_mailed_spearmen", 1);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_levy_archers", 2);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_cavalry", 1);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_levy_archers", 2);
	Random_Army_Manager:add_mandatory_unit("invader_norman", "nor_archers", 2);
	Random_Army_Manager:add_unit("nor_levy_spearmen", "nor_axemen", 1);
	Random_Army_Manager:add_unit("invader_norman", "nor_maine_warriors", 1);
	Random_Army_Manager:add_unit("invader_norman", "nor_shield_wall", 1);
	Random_Army_Manager:add_unit("invader_norman", "nor_knights", 3);
	Random_Army_Manager:add_unit("invader_norman", "nor_horsemen", 1);
	Random_Army_Manager:add_unit("invader_norman", "nor_flemish_crossbowmen", 1);
	Random_Army_Manager:add_unit("invader_norman", "nor_swordsmen", 3);
	Random_Army_Manager:add_unit("invader_norman", "nor_foot_soldiers", 1);

end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		INVASIONS_ULTIMATE_VICTORY_ACHIEVED = cm:load_value("INVASIONS_ULTIMATE_VICTORY_ACHIEVED", false, context);
		INVASIONS_END_INITALISED = cm:load_value("INVASIONS_END_INITALISED", false, context);
		INVASIONS_NUMBER = cm:load_value("INVASIONS_NUMBER", 0, context);
		INVASIONS_TURN_NUMBER = cm:load_value("INVASIONS_TURN_NUMBER", 1, context);
		INVASIONS_TRESPASS = cm:load_value("INVASIONS_TRESPASS", {}, context);
		INVASIONS_END_ULTIMATE_ACTIVE = cm:load_value("INVASIONS_END_ULTIMATE_ACTIVE", INVASIONS_END_ULTIMATE_ACTIVE, context);
		INVASIONS_END = cm:load_value("INVASIONS_END", INVASIONS_END, context);
		INVASIONS_SPAWNED_SCRIPTED_INVASIONS = cm:load_value("INVASIONS_SPAWNED_SCRIPTED_INVASIONS", INVASIONS_SPAWNED_SCRIPTED_INVASIONS, context);
		INVASIONS_PENDING_WARS = cm:load_value("INVASIONS_PENDING_WARS", INVASIONS_PENDING_WARS, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("INVASIONS_ULTIMATE_VICTORY_ACHIEVED", INVASIONS_ULTIMATE_VICTORY_ACHIEVED, context);
		cm:save_value("INVASIONS_END_INITALISED", INVASIONS_END_INITALISED, context);
		cm:save_value("INVASIONS_NUMBER", INVASIONS_NUMBER, context);
		cm:save_value("INVASIONS_TURN_NUMBER", INVASIONS_TURN_NUMBER, context);
		cm:save_value("INVASIONS_TRESPASS", INVASIONS_TRESPASS, context);
		cm:save_value("INVASIONS_END_ULTIMATE_ACTIVE", INVASIONS_END_ULTIMATE_ACTIVE, context);
		cm:save_value("INVASIONS_END", INVASIONS_END, context);
		cm:save_value("INVASIONS_SPAWNED_SCRIPTED_INVASIONS", INVASIONS_SPAWNED_SCRIPTED_INVASIONS, context);
		cm:save_value("INVASIONS_PENDING_WARS", INVASIONS_PENDING_WARS, context);
	end
);

function SaveKeyPairTable(context, tab, savename)
	output("Saving Key Pair Table: "..savename);
	local savestring = "";
	
	for key,value in pairs(tab) do
		savestring = savestring..key..","..value..",;";
	end
	cm:save_value(savename, savestring, context);
end

function LoadKeyPairTable(context, savename)
	output("Loading Key Pair Table: "..savename);
	local savestring = cm:load_value(savename, "", context);
	local tab = {};
	
	if savestring ~= "" then
		local first_split = SplitString(savestring, ";");
		for i = 1, #first_split do
			output("\t\t"..first_split[i]);
			local second_split = SplitString(first_split[i], ",");
			tab[second_split[1]] = second_split[2];
			output("\t\t\t"..savename.."[\""..second_split[1].."\"] = "..second_split[2]);
		end
	end
	return tab;
end

function SplitString(str, delim)
	local res = { };
	local pattern = string.format("([^%s]+)%s()", delim, delim);
	while (true) do
		line, pos = str:match(pattern, pos);
		if line == nil then break end;
		table.insert(res, line);
	end
	return res;
end