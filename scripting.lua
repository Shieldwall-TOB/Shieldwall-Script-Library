-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--
--	First file that gets loaded by a scripted campaign.
--	This shouldn't need to be changed by per-campaign, except for the
--	require and callback commands at the bottom of the file
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- change this to false to not load the script
local load_script = true;

if not load_script then
	out.ting("*** WARNING: Not loading script for campaign " .. campaign_start_file .. " as load_script variable is set to false! Edit lua file at " .. debug.getinfo(1).source .. " to change this back ***");
	return;
end;

-- force reloading of the lua script library
package.loaded["lua_scripts.Campaign_Script_Header"] = nil;
require "lua_scripts.Campaign_Script_Header";

-- name of the campaign, sourced from the name of the containing folder
campaign_name = get_folder_name_and_shortform();

-- name of the local faction, to be filled in later
local_faction = "";

-- include path to other scripts associated with this campaign
package.path = package.path .. ";data/campaigns/" .. campaign_name .. "/?.lua";
package.path = package.path .. ";data/campaigns/" .. campaign_name .. "/factions/?.lua";

-- create campaign manager
cm = campaign_manager:new(campaign_name);

-- require a file in the factions subfolder that matches the name of our local faction
--[[
-- moved this code inside the first tick callback 
cm:register_ui_created_callback(
	function()
		if (cm:model():is_multiplayer() == true) then
			local_faction = cm:get_local_faction();
			
			if not (local_faction == "") then
				output("Loading faction script for faction " .. local_faction);
				inc_tab();
				_G.script_env = getfenv(1);
				
				-- faction scripts loaded here
				if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
					dec_tab();
					output("Faction scripts loaded");
				else
					dec_tab();
				end;
			end;
		end;
	end
);
]]-- 

cm:add_listener(
	"loading_screen_dismissed",
	"LoadingScreenDismissed",
	true,
	function()
		output("scripting.lua - LoadingScreenDismissed event has been received");
		local_faction = cm:get_local_faction();
		
		-- load up the faction file
		if not (local_faction == "") then
			output("Loading faction script for faction " .. local_faction);
			inc_tab();
			_G.script_env = getfenv(1);
			
			-- faction scripts loaded here
			if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
				dec_tab();
				output("Faction scripts loaded");
			else
				dec_tab();
			end;
		end
		
		-- once that is loaded we can start the game for the factions
		if is_function(start_game_for_faction) then
			start_game_for_faction(true);		-- set to false to not show cutscene
		else
			script_error("start_game_for_faction() function is being called but hasn't been loaded - the script has gone wrong somewhere else, investigate!");
		end;
		
		start_game_all_factions();
	end,
	false
);


-- try and load a faction script
function load_faction_script(scriptname)
	local success, err_code = pcall(function() require(scriptname) end);
			
	if success then
		output(scriptname .. ".lua loaded");
	else
		script_error("ERROR: Tried to load faction script " .. scriptname .. " without success - either the script is not present or it is not valid. See error below");
		output("*************");
		output("Returned lua error is:");
		output(err_code);
		output("*************");
	end;
	
	return success;
end;



-------------------------------------------------------
--	function to call when the first tick occurs
-------------------------------------------------------
cm:register_first_tick_callback(
	function()
		if (cm:model():is_multiplayer() == true) then
			local_faction = cm:get_local_faction();
			
			if not (local_faction == "") then
				output("Loading faction script for faction " .. local_faction);
				inc_tab();
				_G.script_env = getfenv(1);
				
				-- faction scripts loaded here
				if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
					dec_tab();
					output("Faction scripts loaded");
				else
					dec_tab();
				end;
			end;
			
			if is_function(start_game_for_faction) then
				start_game_for_faction(true);		-- set to false to not show cutscene
			else
				script_error("start_game_for_faction() function is being called but hasn't been loaded - the script has gone wrong somewhere else, investigate!");
			end;
			
			start_game_all_factions();
		end;
	end
);

-------------------------------------------------------
--	additional script files to load
-------------------------------------------------------

require("vik_start");
require("vik_burghal");
require("vik_war_fervour");
require("vik_rebels");
require("vik_lists");
require("vik_kingdom_events");
require("vik_ai_personalities");
require("vik_trade_and_shroud");
require("vik_common");
require("vik_victory_conditions");
require("vik_campaign_random_army");
require("vik_invasions");
require("vik_starting_rebellions");
require("vik_seasonal_events");
require("vik_ai_events");
require("vik_dyflin_factions_mechanics");
require("vik_miercna_faction_mechanics");
require("vik_sudreyar_faction_mechanics");
require("vik_strat_clut_faction_mechanics");
require("vik_northymbra_faction_mechanics");
require("vik_circenn_factions_mechanics");
require("laura_test");
require("vik_culture_mechanics_sea_kings");
require("vik_culture_mechanics_viking_army");
require("vik_culture_mechanics_gaelic");
require("vik_culture_mechanics_welsh");
require("vik_culture_mechanics_english");
require("vik_culture_mechanics_common");
require("vik_legendary_traits");
require("vik_starting_traits");
require("vik_tech_locks");
require("vik_tech_unlocks");
require("vik_faction_events");
require("vik_advice");
require("vik_traits");
require("vik_decrees");
require("vik_ai_wars");
require("vik_ai_peace");


-----------------------
--SHIELDWALL SCRIPTS---
-----------------------
--[[
    All shieldwall scripts are split into four sections
    1. The library defines all development aids and UI functionality.
    2. The object model tracks all necessary information in a regulated data structure.
    3. The feature scripts add event handlers to actually make the mod work.
    4. The CONST sections data drive script values.
--]]

--Load Constants
CONST = require("shieldwall/ShieldWallConstants")

--Load Libraries
local ok, err = pcall(function()
    --LIB MANIFEST:
    dev = require("shieldwall/dev")
    local ui_module = require("shieldwall/ui_script/ui_module")
    
    --UI Library Init
    dev.pre_first_tick(function(context)
        dev.ui_module = ui_module()
    end)
end)
if not not ok then
	dev.log("Successfully loaded shieldwall library!")
else
    dev.log("************************************************************")
	dev.log("Error loading shieldwall library!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end

--Load Model
local ok, err = pcall(function()
    --MODEL MANIFEST: 
    require("ilex_verticillata/PettyKingdoms") 
    --EVENT HANDLERS:
    require("ilex_verticillata/event_handlers/RegionOccupationHandler")
end)
if not not ok then
    dev.log("Succeessfully loaded the object model!")
else
    dev.log("************************************************************")
    dev.log("Error loading the object model!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end

--Load Features
local ok, err = pcall(function()
    --FEATURES MANIFEST: 
    require("shieldwall/standalone/CitiesLandmarks")

    require("shieldwall/content/UnitEffectsContent")
    require("shieldwall/features/UnitEffectsFeatures")

    require("shieldwall/features/PopulationFeatures")
    require("shieldwall/content/PopulationContent")
end)
if not not ok then
    dev.log("Succeessfully loaded shieldwall features!")
else
    dev.log("************************************************************")
    dev.log("Error loading shieldwall features!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end