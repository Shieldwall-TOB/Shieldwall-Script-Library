function StartGameNorthleode()
    local difficulty = cm:model():difficulty_level();
    local force = "est_marauders,est_spear_hirdmen,est_spear_hirdmen,est_shield_biters,est_marauders"
    if difficulty < -1 then
        force = force .. ",est_spear_hirdmen"
    end
    cm:apply_effect_bundle("sw_northleode_king_of_nothing", "vik_fact_northleode", 0)
    cm:create_force("vik_fact_wicing", force, "vik_reg_coldingaham", 541, 542, "northleode_start_army", true)
    dev.callback(function()
    cm:force_declare_war("vik_fact_wicing", "vik_fact_northymbre")
    cm:force_declare_war("vik_fact_wicing", "vik_fact_northleode")
    end, 0.1)
    local burt = get_faction("vik_fact_northleode"):faction_leader()
    cm:add_unit_to_force("eng_north_hunters", burt:military_force():command_queue_index())
    cm:add_unit_to_force("eng_ceorl_spearmen", burt:military_force():command_queue_index())
    cm:add_unit_to_force("eng_thegn_spearmen", burt:military_force():command_queue_index())
    dev.callback(function()
        local zoom = dev.get_uic(cm:ui_root(), "panel_manager", "events", "button_set", "accept", "button_zoom")
        if zoom then
            zoom:SimulateLClick()
        end
        local tab = dev.get_uic(cm:ui_root(), "campaign_tactical_map", "button_holder", "button_tactical_map")
        if tab then
            tab:SimulateLClick()
        end
    end, 0.2)
end



-------------------------------------------------------------------------------
------------------------- STARTING REBELLIONS ---------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Jack: 27/07/2017 -------------------------
------------------------- Last Updated: 02/03/2018 by Joy ---------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Starting rebels. Spawns a small rebel army in the players faction territory at
-- the start of the campaign. Gives an easy first win, and makes it only for the 
-- player to not hamper the AI

STARTING_REBELS = false;
NUM_REBEL_ARMIES_LOCKED = 0;

function StartingRebelForces()

	Random_Army_Manager:new_force("english_force_small");
	Random_Army_Manager:add_mandatory_unit("english_force_small", "wel_valley_spearmen", 2)	
	--Random_Army_Manager:add_mandatory_unit("english_force_small", "est_fighters", 1)	
	Random_Army_Manager:add_mandatory_unit("english_force_small", "dan_fyrd_archers", 1)
	--Random_Army_Manager:add_mandatory_unit("english_force_small", "dan_ceorl_javelinmen", 1)
	
	Random_Army_Manager:new_force("english_force_medium");
	Random_Army_Manager:add_mandatory_unit("english_force_medium", "wel_valley_spearmen", 2)
	Random_Army_Manager:add_mandatory_unit("english_force_large", "est_fighters", 1)
	--Random_Army_Manager:add_mandatory_unit("english_force_medium", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("english_force_medium", "dan_ceorl_javelinmen", 1)	
	
	Random_Army_Manager:new_force("english_force_large");
	--Random_Army_Manager:add_mandatory_unit("english_force_medium", "wel_valley_spearmen", 2)
	Random_Army_Manager:add_mandatory_unit("english_force_large", "est_fighters", 2)
	Random_Army_Manager:add_mandatory_unit("english_force_medium", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("english_force_medium", "dan_ceorl_javelinmen", 1)	
	Random_Army_Manager:add_mandatory_unit("english_force_large", "est_mailed_horsemen", 1)

	
	Random_Army_Manager:new_force("welsh_force_small");
	Random_Army_Manager:add_mandatory_unit("welsh_force_small", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_small", "wel_archers", 2)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_small", "est_mailed_horsemen", 1)
	
	Random_Army_Manager:new_force("welsh_force_medium");
	Random_Army_Manager:add_mandatory_unit("welsh_force_medium", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_large", "est_fighters", 2)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_medium", "wel_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_medium", "est_mailed_horsemen", 1)	
	
	Random_Army_Manager:new_force("welsh_force_large");
	Random_Army_Manager:add_mandatory_unit("welsh_force_large", "wel_valley_spearmen", 3)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_large", "est_fighters", 1)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_large", "dan_fyrd_archers", 2)	
	Random_Army_Manager:add_mandatory_unit("welsh_force_large", "est_mailed_horsemen", 1)
	
	Random_Army_Manager:new_force("scottish_force_small");
	Random_Army_Manager:add_mandatory_unit("scottish_force_small", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_large", "est_fighters", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_small", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_small", "est_mailed_horsemen", 1)
	
	Random_Army_Manager:new_force("scottish_force_medium");
	Random_Army_Manager:add_mandatory_unit("scottish_force_medium", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_medium", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_medium", "est_mailed_horsemen", 1)	
	
	Random_Army_Manager:new_force("scottish_force_large");
	Random_Army_Manager:add_mandatory_unit("scottish_force_large", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_large", "est_fighters", 1)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_large", "dan_fyrd_archers", 2)	
	Random_Army_Manager:add_mandatory_unit("scottish_force_large", "est_mailed_horsemen", 1)
	
	Random_Army_Manager:new_force("irish_force_small");
	Random_Army_Manager:add_mandatory_unit("irish_force_small", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_small", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_small", "est_mailed_horsemen", 1)
	
	Random_Army_Manager:new_force("irish_force_medium");
	Random_Army_Manager:add_mandatory_unit("irish_force_medium", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_large", "est_fighters", 1)
	Random_Army_Manager:add_mandatory_unit("irish_force_medium", "dan_fyrd_archers", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_medium", "dan_ceorl_javelinmen", 1)	
	
	Random_Army_Manager:new_force("irish_force_large");
	Random_Army_Manager:add_mandatory_unit("irish_force_large", "wel_valley_spearmen", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_large", "est_fighters", 1)	
	Random_Army_Manager:add_mandatory_unit("irish_force_large", "dan_fyrd_archers", 2)	
	Random_Army_Manager:add_mandatory_unit("irish_force_large", "dan_ceorl_javelinmen", 1)
	
	if cm:is_new_game() then	
		cm:add_listener(
			"starting_rebels_character_creation",
			"CharacterCreated",
			function(context)
				local character = context:character();
				
				if not char_is_army_commander(character) then
					return false;
				end;
				
				-- see if this character is in our list of created rebels
				for i = 1, #REBEL_START_POS do
					if character:logical_position_x() == REBEL_START_POS[i].x and character:logical_position_y() == REBEL_START_POS[i].y then
						return true;
					end;
				end;
				
				return false;
			end,
			function(context)
				local char_cqi = context:character():cqi();
				
				output("Rebel character spawned, character cqi is " .. char_cqi);
				
				local first_human_faction = cm:get_first_human_faction();
				
				if first_human_faction then
					-- prevent this character from moving
					cm:disable_movement_for_character(char_lookup_str(char_cqi));
					
					-- send an event to allow this character to move in 2 turns
					cm:add_turn_countdown_event(first_human_faction, 2, "ScriptEventAllowStartupRebelMovement", tostring(char_cqi));
					
					NUM_REBEL_ARMIES_LOCKED = NUM_REBEL_ARMIES_LOCKED + 1;
					
					-- if the number of rebel armies we have locked is less than the number of human players then exit this function without cancelling the listener, as
					-- there will be more rebel armies created shortly that will also need locking
					if NUM_REBEL_ARMIES_LOCKED < #cm:get_human_factions() then
						return;
					end;
				else
					output("\tnot disabling its movement as there isn't a human faction");
				end;
				
				output("\tstopping rebel army creation listener");
				
				-- prevent this listener from triggering again
				cm:remove_listener("starting_rebels_character_creation");
		   end,
		   true
		);
	end;
	
	cm:add_listener(
		"starting_rebels_character_movement",
        "ScriptEventAllowStartupRebelMovement",
        true,
        function(context)
			local char_cqi = tonumber(context.string);
			
			if not is_number(char_cqi) then
				script_error("WARNING: ScriptEventAllowStartupRebelMovement event triggered but could not translate the supplied context string [" .. tostring(context.string) .. "] into a number");
                return false;
            end;
			
            if get_character_by_cqi(char_cqi) then
				output("::: ScriptEventAllowStartupRebelMovement triggered and character with cqi [" .. char_cqi .. "] found, allowing him to move");
                cm:enable_movement_for_character(char_lookup_str(char_cqi));
            else
				output("::: ScriptEventAllowStartupRebelMovement triggered but no character with cqi [" .. char_cqi .. "] was found, presumably he's already dead");
            end;
		end,
		true
	);
end


function SetupStartingRebels()

	StartingRebelForces()

	if STARTING_REBELS == false then
		
		-- TURN ONE EVENTS
		STARTING_REBELS = true;
		
		-- CHECK FOR HUMAN PLAYER SO WE KNOW IF WE SHOULD SPAWN REBELS / FIRE A MISSION
		local human_check = false
		local faction_list = cm:model():world():faction_list();
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			if faction:is_human() == true then
				human_check = true;
			end
		end
		
		if human_check == true then
		
			
			-- INITIAL ENEMY FORCES
			if cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() then
				CreateStartingRebels("vik_reg_dunholm", "english", 568, 448)
				cm:trigger_mission("vik_fact_northymbre", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_mierce"):is_human() then
				CreateStartingRebels("vik_reg_ceaster", "english", 495, 314)
				cm:trigger_mission("vik_fact_mierce", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() then
				CreateStartingRebels("vik_reg_sceaftesburg", "english", 536, 117)
				cm:trigger_mission("vik_fact_west_seaxe", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_gwined"):is_human() then
				CreateStartingRebels("vik_reg_aberffro", "english", 400, 339)
				cm:trigger_mission("vik_fact_gwined", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() then
				CreateStartingRebels("vik_reg_wigingamere", "english", 687, 213)
				cm:trigger_mission("vik_fact_east_engle", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() then
				CreateStartingRebels("vik_reg_guvan", "english", 410, 539)
				cm:trigger_mission("vik_fact_strat_clut", "vik_starting_rebels", true);
			end
				
			if cm:model():world():faction_by_key("vik_fact_circenn"):is_human() then
				CreateStartingRebels("vik_reg_abberdeon", "english", 528, 686)
				cm:trigger_mission("vik_fact_circenn", "vik_starting_rebels", true);
			end
	
			if cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() then
				CreateStartingRebels("vik_reg_aporcrosan", "english", 348, 707)
				cm:trigger_mission("vik_fact_sudreyar", "vik_starting_rebels", true);
			end
				
			if cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() then
				CreateStartingRebels("vik_reg_loch_gabhair", "english", 284, 357)
				cm:trigger_mission("vik_fact_dyflin", "vik_starting_rebels", true);
			end
			
			if cm:model():world():faction_by_key("vik_fact_mide"):is_human() then
				CreateStartingRebels("vik_reg_cenannas", "english", 265, 367)
				cm:trigger_mission("vik_fact_mide", "vik_starting_rebels", true);
			end
            if cm:model():world():faction_by_key("vik_fact_northleode"):is_human() then
                StartGameNorthleode()
            end
		end
	end
	
end

function CreateStartingRebels(region, culture, x, y)

	-- DIFFICULTY LEVEL DETECTION
	local difficulty = cm:model():difficulty_level();
	local force = false;
	
	if difficulty == 1 or difficulty == 0 then
		output("Spawned Easy Rebellion")
		force = Random_Army_Manager:generate_force(culture.."_force_small", 3, false);
	elseif difficulty == -1 then
		output("Spawned Normal Rebellion")
		force = Random_Army_Manager:generate_force(culture.."_force_medium", 4, false);
	elseif difficulty == -2 or difficulty == -3 then
		output("Spawned Hard Rebellion")
		force = Random_Army_Manager:generate_force(culture.."_force_large", 5, false);							
	end
	
	-- Record the starting position so script elsewhere in this file can pick up the creation of the character and prevent it from moving.
	-- This needs to be a list of positions as more than one rebel army may be created in multiplayer.
	if not REBEL_START_POS then
		REBEL_START_POS = {};
	end;
	
	local current_rebel_start_pos = {
		x = x,
		y = y
	};
	table.insert(REBEL_START_POS, current_rebel_start_pos);
	
	cm:force_rebellion_in_region(region, 0, force, x, y, true);
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		STARTING_REBELS = cm:load_value("STARTING_REBELS", false, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("STARTING_REBELS", STARTING_REBELS, context);
	end
);