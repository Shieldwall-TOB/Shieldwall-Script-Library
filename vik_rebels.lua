 
 -------------------------------------------------------------------------------
----------------------------------- REBELLIONS --------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 06/03/2017 ------------------------
------------------------- Last Updated: 20/03/2018 by Craig -------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Rebellions is hijacking the squalor system and repurposing it as levels of unrest. This replaces public order for determining unrest/rebellions.
-- The core idea behind this system is that if 'squalor' is greater than 'sanitation' there is a % chance of rebellions occurring.
-- The first time the % passes true this spawns bandits for 10 turns. 
-- If it passes true again during this window there will be a rebellion.

-- Tables used to store regions that are rebelling or have bandits
RIOT_COOLDOWNS = {} --:map<string, number>
RIOTING_REGIONS = {} --:map<string, number>
REPRESSING_ARMIES = {} --:map<string, number>

-- Variable to store the turn number so we can check if it's a new turn
REBELLION_TURN_NUMBER = 1 --:number


-- Checks to see if this is a new turn
function RebellionNewTurnCheck()

	local turn = cm:model():turn_number();
	if turn > REBELLION_TURN_NUMBER then
		REBELLION_TURN_NUMBER = turn;
		return true;
	end
	
end

-- Decreases timers by 1 and resets regions at 0
function RebellionNewTurn()

	for key,value in pairs(RIOT_COOLDOWNS) do
		if tonumber(value) <= 1 then
			RIOT_COOLDOWNS[key] = nil
		else 
			RIOT_COOLDOWNS[key] = tonumber(value) - 1
		end
	end

	for key,value in pairs(RIOTING_REGIONS) do
		if tonumber(value) <= 1 then
			RIOTING_REGIONS[key] = nil
		else 
			RIOTING_REGIONS[key] = tonumber(value) - 1
		end
	end
	
end
--v function(incident_key:string, call: function(context: WHATEVER))
local function respond_to_incident(incident_key, call)
	cm:add_listener(
		incident_key,
		"IncidentOccuredEvent",
		function(context)
			return context:dilemma() == incident_key
		end,
		function(context)
			call(context)
		end,
		false
	)
end

--v function(dilemma: string, call: function(context: WHATEVER))
local function respond_to_dilemma(dilemma, call)
	cm:add_listener(
		dilemma,
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == dilemma
		end,
		function(context)
			call(context)
		end,
		false
	)
end

--v function(faction: CA_FACTION, region_name: string, public_order:number) --> boolean
local function can_region_rebel(faction, region_name, public_order)
	local roll = cm:random_number(100)
	dev.log("Checking if ["..region_name.."] can rebel with a PO ["..public_order.."]. They rolled ["..roll.."] ", "RIOT")
	if public_order > roll then -- public order / 100 chance
		dev.log("Chance check passed", "RIOT")
		local character_list = faction:character_list()
		for i = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			if dev.is_char_normal_general(character) and (not character:region():is_null_interface()) and character:region():name() == region_name then
				local size = 0 --:number
				local army = character:military_force()
				for j = 0, army:unit_list():num_items() - 1 do
					size = size + army:unit_list():item_at(j):percentage_proportion_of_full_strength()
				end
				dev.log("Character with army ["..size.."] found in region", "RIOT")
				if size > 500 then
					return false --cannot rebel if an army of 6 or more units is around.
				end
			end
		end
		dev.log("Checks passed, region can rebel", "RIOT")
		return true
	end
	return false
end

--v function(character: CA_CHAR) --> boolean
local function has_household_guard(character)
	local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_champion_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_champion_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_champion_mierce",
		["vik_fact_mide"]  = "vik_follower_champion_mide",
		["vik_fact_east_engle"]  = "vik_follower_champion_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_champion_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_champion_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_champion_gwined",
		["vik_fact_dyflin"]  = "vik_follower_champion_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_champion_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_champion",
		["vik_fact_caisil"]  = "vik_follower_champion",
		["nil"] = "vik_follower_champion"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	if character:has_skill(skill_key.."_2") then
		return true
	end
	return false
end

--v function(region: CA_REGION, faction_name: string, public_order: number)
function region_rioting_event(region, faction_name, public_order)
	local region_name = region:name()
	RIOT_COOLDOWNS[region_name] = 2
	dev.log("Secondary riot event in ["..region_name.."] ", "RIOT");
	--governor events
	if region:has_governor() then
		--if we pass a chance check, consider killing the governor
		if cm:random_number(100) > 66 then
			if has_household_guard(region:governor()) then
				local dilemma = "sw_rebellion_rioting_household_guard_"..region_name
				respond_to_dilemma(dilemma, function(context)
					if context:choice() == 1 then
						local pop_manager = pkm:get_faction(faction_name):pop_manager_by_key("serf")
						pop_manager:apply_unrest(region:province_name(), 25)
					end
				end)
				cm:trigger_dilemma(faction_name, dilemma, true)
				return
			end
			local incident = "shield_rebellion_stoning_"..region_name
			respond_to_incident(incident, function(context)
				local region = dev.get_region(region_name)
				local gov = region:governor():command_queue_index()
				cm:kill_character("character_cqi:"..tostring(gov), false, true)
			end)
			cm:trigger_incident(faction_name, incident, true)
			return
		end
	end
	if region:owning_faction():total_food() < 50 and
	pkm:get_faction(faction_name):get_food_manager():does_region_have_food_storage(region) and
	(pkm:get_faction(faction_name):get_food_manager():food_in_storage() > 0) then
		local incident = "shield_rebellion_food_storage_"..region_name
		respond_to_incident(incident, function(context)
			local region = dev.get_region(region_name)
			pkm:get_faction(faction_name):get_food_manager():mod_food_storage(pkm:get_faction(faction_name):get_food_manager():food_in_storage() * (-0.25))
		end)
		cm:trigger_incident(faction_name, incident, true)
	elseif pkm:get_faction(faction_name):pop_manager_by_key("lord"):display_value_in_province(region:province_name()) > 40 then
		local incident = "shield_rebellion_nobles_"..region_name
		respond_to_incident(incident, function(context)
			local region = dev.get_region(region_name) 
			pkm:get_faction(faction_name):pop_manager_by_key("lord"):apply_unrest(region:province_name())
		end)
		cm:trigger_incident(faction_name, incident, true)
	end
end


-- Check for bandits/rebellions at the end of the turn
--v function(context: WHATEVER)
function RebellionCheck(context)
	local region = context:region() --:CA_REGION
	local region_name = region:name()
	local public_order = region:squalor() - region:sanitation() --:number
	local faction_name = region:owning_faction():name()
	dev.log("Checking region ["..region_name.."] with public order ["..-1*public_order.."], which is rioting ["..tostring(not not RIOTING_REGIONS[region_name]).."] ", "RIOT")
	if public_order < 0 and RIOTING_REGIONS[region_name] ~= nil then --public order is restored!
		dev.log("Riot ends in this region")
		RIOTING_REGIONS[region_name] = nil
		RIOT_COOLDOWNS[region_name] = nil
		cm:trigger_incident(faction_name, "shield_rioting_ends_"..region_name, true)
		--remove the governor trait flag if it exists
		if region:has_governor() and region:governor():has_trait("shield_tyrant_opressor_flag") then
			cm:force_remove_trait(dev.lookup(region:governor()), "shield_tyrant_opressor_flag")
		end
	end
	--if they aren't currently on riot-event cooldown cooldown
	if RIOT_COOLDOWNS[region_name] == nil then
		--if they are rioting
		if RIOTING_REGIONS[region_name] ~= nil and region:owning_faction():is_human() then	
			region_rioting_event(region, faction_name, public_order)
		else --not currently rioting 
			if public_order > 0 then
				--chance to begin riots
				dev.log("Checking if region can riot")
				if can_region_rebel(dev.get_faction(faction_name), region_name, public_order) then	
					dev.log("Region can rebel", "RIOT")
					--riot duration
					RIOTING_REGIONS[region_name] = 10
					if region:owning_faction():is_human() then
						dev.log("riot begins in ["..region_name.."]!!!!", "RIOT");
						cm:trigger_incident(faction_name, "shield_rebellion_rioting_"..region_name , true)
					end
				end
			end
		end
	end
end

-- Removes bandits/rebels bundles from a region when it is occupied
--v function(context: CA_CONTEXT)
function RebellionResetRegion(context)
	--cm:remove_effect_bundle_from_region("shield_unrest_bundle", context:region():name());
	--cm:remove_effect_bundle_from_region("shield_rioting", context:region():name());
	--cm:remove_effect_bundle_from_region("vik_rebels_bandits", context:region():name());
	RIOT_COOLDOWNS[context:region():name()] = nil;
	RIOTING_REGIONS[context:region():name()] = nil;
end

--v function(context: CA_CONTEXT)
local function RebellionCharacterEnters(context)
	if not dev.is_char_normal_general(context:character()) then
		return
	end
	local character = context:character()
	local region = context:garrison_residence():region()
	local force = character:military_force()
	local size = 0 --:number
	local army = character:military_force()
	for i = 0, army:unit_list():num_items() - 1 do
		size = size + army:unit_list():item_at(i):percentage_proportion_of_full_strength()
	end
	if size <= 400 then
		--you cannot put down rebels without more men.
		cm:trigger_incident(character:faction():name(), "sw_army_too_small_rebellion", true)
		cm:apply_effect_bundle_to_characters_force("shield_force_harassed_1", character:command_queue_index(), 3, true)
	elseif size <= 1200 then
		RIOT_COOLDOWNS[region:name()] = nil;
		RIOTING_REGIONS[region:name()] = nil;
		--choice
		respond_to_dilemma("sw_rebels_soldiers_arrive_"..region:name(),
		function(context)
			if context:choice() == 0 then
				cm:apply_effect_bundle_to_characters_force("shield_force_rebellion_prevention", character:command_queue_index(), 3, true)
				cm:zero_action_points(dev.lookup(character:command_queue_index()))
				REPRESSING_ARMIES[tostring(character:command_queue_index())] = 2
			else
				local pop_manager = pkm:get_faction(character:faction():name()):pop_manager_by_key("serf")
				pop_manager:apply_unrest(region:province_name(), 25)
			end
		end)
		cm:trigger_dilemma(character:faction():name(), "sw_rebels_soldiers_arrive_"..region:name(), true)
	elseif size > 1200 then
		RIOT_COOLDOWNS[region:name()] = nil;
		RIOTING_REGIONS[region:name()] = nil;
		cm:trigger_incident(character:faction():name(), "sw_army_puts_down_rebellion", true)
		--riot ends.
	end
end

--v function(char: CA_CHAR)
function UpdateRepressingArmy(char)
	if not dev.is_char_normal_general(char) then
		REPRESSING_ARMIES[tostring(char:command_queue_index())] = nil
	end
	local entry = REPRESSING_ARMIES[tostring(char:command_queue_index())]
	if entry > 0 then
		REPRESSING_ARMIES[tostring(char:command_queue_index())] = entry-1
		cm:zero_action_points(dev.lookup(char:command_queue_index()))
	else
		REPRESSING_ARMIES[tostring(char:command_queue_index())] = nil
		if not char:region():is_null_interface() then
			cm:trigger_incident(char:faction():name(), "shield_rioting_ends_"..char:region():name(), true)
		end
	end
end


--v function(context:CA_CONTEXT)
local function RebellionCharacterLeaves(context)
	local char = context:character()
	cm:remove_effect_bundle_from_characters_force("shield_force_harassed_1", char:command_queue_index())
end


function Add_Rebellion_Listeners()
	output("#### Adding Rebellion Events Listeners ####");
		cm:add_listener(
			"RegionTurnStart_Rebellion",
			"RegionTurnStart",
			function(context) return cm:model():turn_number() >= 2 and context:region():is_province_capital() and context:region():owning_faction():is_human() end,
			function(context) RebellionCheck(context) end,
			true
		);
		cm:add_listener(
			"FactionTurnStart_Rebellion",
			"FactionTurnStart",
			function(context) return RebellionNewTurnCheck() == true end,
			function(context) RebellionNewTurn() end,
			true
		);
		cm:add_listener(
			"CharacterTurnStart_Rebellion",
			"CharacterTurnStart",
			function(context) return not not REPRESSING_ARMIES[tostring(context:character():command_queue_index())] end,
			function(context) UpdateRepressingArmy(context:character()) end,
			true
		);
		cm:add_listener(
			"RegionChangesOwnership_Rebellion",
			"RegionChangesOwnership",
			true,
			function(context) RebellionResetRegion(context) end,
			true
		);
		cm:add_listener(
			"RegionRiotRepressed_Rebellion",
			"RegionRiotRepressed",
			true,
			function(context) RebellionResetRegion(context) end,
			true
		)
		cm:add_listener(
			"CharacterEntersGarrison_Rebellion",
			"CharacterEntersGarrison",
			function(context)
				return RIOTING_REGIONS[context:garrison_residence():region():name()] ~= nil
			end,
			function(context)
				RebellionCharacterEnters(context)
			end,
			true
		)
		cm:add_listener(
			"CharacterLeavesGarrison_Rebellion",
			"CharacterLeavesGarrison",
			function(context)
				return RIOTING_REGIONS[context:garrison_residence():region():name()] ~= nil and dev.is_char_normal_general(context:character())
			end,
			function(context)
				RebellionCharacterLeaves(context)
			end,
			true
		)
		trait_listener(
			"shield_tyrant_opressor",
			"RegionTurnStart",
			function(context)
				local region = context:region() --:CA_REGION
				if not region:has_governor() then
					return false, nil
				end
				return RIOTING_REGIONS[region:name()] ~= nil, region:governor()
			end
		)
end

--v [NO_CHECK] function(context: WHATEVER, tab: table, savename: string)
function SaveKeyPairTable(context, tab, savename)
	output("Saving Key Pair Table: "..savename);
	local savestring = "";
	
	for key,value in pairs(tab) do
		savestring = savestring..key..","..value..",;";
	end
	cm:save_value(savename, savestring, context);
end
--v [NO_CHECK] function(context: WHATEVER, savename: string)
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
--v [NO_CHECK] function(str: string, delim:string) --> table
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
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		REBELLION_TURN_NUMBER = cm:load_value("REBELLION_TURN_NUMBER", 0, context);
		RIOT_COOLDOWNS = LoadKeyPairTable(context, "RIOT_COOLDOWNS");
		RIOTING_REGIONS = LoadKeyPairTable(context, "RIOTING_REGIONS");
		REPRESSING_ARMIES = LoadKeyPairTable(context, "REPRESSING_ARMIES")
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("REBELLION_TURN_NUMBER", REBELLION_TURN_NUMBER, context);
		SaveKeyPairTable(context, RIOT_COOLDOWNS, "RIOT_COOLDOWNS");
		SaveKeyPairTable(context, RIOTING_REGIONS, "RIOTING_REGIONS");
		SaveKeyPairTable(context, REPRESSING_ARMIES, "REPRESSING_ARMIES")
	end
);

