 
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
REBELLION_REBELS = {} --:map<string, number>
REBELLION_BANDITS = {} --:map<string, number>

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

	for key,value in pairs(REBELLION_REBELS) do
		if tonumber(value) <= 1 then
			REBELLION_REBELS[key] = nil
		else 
			REBELLION_REBELS[key] = tonumber(value) - 1
		end
	end

	for key,value in pairs(REBELLION_BANDITS) do
		if tonumber(value) <= 1 then
			REBELLION_BANDITS[key] = nil
		else 
			REBELLION_BANDITS[key] = tonumber(value) - 1
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

-- Check for bandits/rebellions at the end of the turn
--v function(context: WHATEVER)
function RebellionCheck(context)

	local region = context:region() --:CA_REGION
	local region_name = region:name()
	local public_order = region:squalor() - region:sanitation()
	local faction_name = region:owning_faction():name()
	if REBELLION_REBELS[region_name] == nil then
		if public_order > 0 then
			if public_order > cm:random_number(100) then	
				if REBELLION_BANDITS[region_name] ~= nil and region:is_province_capital() and region:owning_faction():is_human() then				
					--cm:set_public_order_of_province_for_region(region, -500);
					--cm:remove_effect_bundle_from_region("vik_rebels_bandits", context:region():name());
					--cm:apply_effect_bundle_to_region("vik_rebels_rebels", region, 6);	
					--REBELLION_BANDITS[region_name] = nil
					REBELLION_REBELS[region_name] = 2
					dev.log("Secondary riot event in ["..region_name.."] ", "RIOT");
					if region:has_governor() and cm:random_number(100) > 50 then
						local incident = "shield_rebellion_stoning_"..region_name
						respond_to_incident(incident, function(context)
							local region = dev.get_region(region_name)
							local gov = region:governor():command_queue_index()
							cm:kill_character("character_cqi:"..tostring(gov), false, true)
						end)
						cm:trigger_incident(faction_name, incident, true)
					elseif region:owning_faction():total_food() < 50 and
					(pkm:get_faction(faction_name):get_food_manager():get_food_storage_cap_contrib_from_region(region_name) > 0) and
					(pkm:get_faction(faction_name):get_food_manager():food_in_storage() > 0) then
						local incident = "shield_rebellion_food_storage_"..region_name
						respond_to_incident(incident, function(context)
							local region = dev.get_region(region_name)
							pkm:get_faction(faction_name):get_food_manager():mod_food_storage(pkm:get_faction(faction_name):get_food_manager():food_in_storage() * (-0.25))
						end)
						cm:trigger_incident(faction_name, incident, true)
					elseif pkm:get_faction(faction_name):get_province(region:province_name()):get_population_manager():get_pop_of_caste("lord") > 40 then
						local incident = "shield_rebellion_nobles_"..region_name
						respond_to_incident(incident, function(context)
							local region = dev.get_region(region_name)
							pkm:get_faction(faction_name):get_province(region:province_name()):get_population_manager():modify_population("lord", -40, "Riots")
						end)
						cm:trigger_incident(faction_name, incident, true)
					end
				else
					--cm:apply_effect_bundle_to_region("vik_rebels_bandits", region, 6);
					REBELLION_BANDITS[region_name] = 10
					dev.log("riot begins in ["..region_name.."]!!!!", "RIOT");
					if region:is_province_capital() and region:owning_faction():is_human() then
						cm:trigger_incident(faction_name, "shield_rebellion_rioting_"..region_name , true)
					else
						cm:apply_effect_bundle_to_region("shield_unrest_bundle", region_name, 10)
					end
				end
			end
		end
	end
	if region:owning_faction():is_human() then
		if region:has_governor() and REBELLION_BANDITS[region_name] ~= nil then
			if not region:governor():has_trait("shield_tyrant_opressor") then
				apply_trait_dilemma_for_character(region:governor(), "shield_tyrant_oppressor")
			end
		elseif region:has_governor() then
			if region:governor():has_trait("shield_tyrant_opressor_flag") then
				cm:force_remove_trait(dev.lookup(region:governor()), "shield_tyrant_opressor_flag")
			end
		end
	end
end

-- Removes bandits/rebels bundles from a region when it is occupied
--v function(context: CA_CONTEXT)
function RebellionResetRegion(context)
	cm:remove_effect_bundle_from_region("shield_unrest_bundle", context:region():name());
	cm:remove_effect_bundle_from_region("shield_rioting", context:region():name());
	--cm:remove_effect_bundle_from_region("vik_rebels_bandits", context:region():name());
	REBELLION_REBELS[context:region():name()] = nil;
	REBELLION_BANDITS[context:region():name()] = nil;

end



function Add_Rebellion_Listeners()
	output("#### Adding Rebellion Events Listeners ####");
		cm:add_listener(
			"RegionTurnStart_Rebellion",
			"RegionTurnStart",
			function(context) return cm:model():turn_number() >= 2 end,
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
		REBELLION_REBELS = LoadKeyPairTable(context, "REBELLION_REBELS");
		REBELLION_BANDITS = LoadKeyPairTable(context, "REBELLION_BANDITS");
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("REBELLION_TURN_NUMBER", REBELLION_TURN_NUMBER, context);
		SaveKeyPairTable(context, REBELLION_REBELS, "REBELLION_REBELS");
		SaveKeyPairTable(context, REBELLION_BANDITS, "REBELLION_BANDITS");
	end
);

