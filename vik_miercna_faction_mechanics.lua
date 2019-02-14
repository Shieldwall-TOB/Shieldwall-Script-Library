-------------------------------------------------------------------------------
--------------------------- MIERCE FACTION MECHANICS --------------------------
-------------------------------------------------------------------------------
------------------------- Created by Joy: 11/09/2017 --------------------------
------------------------- Last Updated: 10/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Unique faction mechanics for Miercna
-- 

EN_PEASANT_MAX_MIE = 0
TOTAL_PEASANTS_MIE = 0

PEASANT_UNIT_REMOVED_MIE = false

MIE_TECH_TRADE = false

-- Listeners
function Add_Miercna_Mechanics_Listeners()
output("#### Adding Miercna Mechanics Listeners ####")
	cm:add_listener( -- Start of the turn - player is Miercna
		"FactionTurnStart_Miercna",
		"FactionTurnStart",
		function(context) return context:faction():name() == "vik_fact_mierce" and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaStartMechanicsChecks(context) end,
		true
	);
	cm:add_listener( -- Miercna completed a battle
		"CharacterCompletedBattle_MiercnaBattleResult",
		"CharacterCompletedBattle",
		function(context) return cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaResultBattle(context) end,
		true
	);
	cm:add_listener( -- Region changes owner - Miercna
		"RegionChangesOwnership_Miercna_Culture",
		"RegionChangesOwnership",
		function(context) return cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaCheckPeasantsMechanic("vik_fact_mierce") end,
		true
	);
	cm:add_listener( -- Merge and destroy units - Miercna
		"UnitMergedAndDestroyed_Miercna",
		"UnitMergedAndDestroyed",
		function(context) return context:unit():faction():name() == "vik_fact_mierce" and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaDisbandOrMergeUnits(context, "vik_fact_mierce") end,
		true
	);
	cm:add_listener( -- Unit trained - Miercna
		"UnitTrained_Miercna_Culture",
		"UnitTrained",
		function(context) return context:unit():faction():name() == "vik_fact_mierce" and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaCheckPeasantsMechanic("vik_fact_mierce") end,
		true
	);
	cm:add_listener( -- Disbanding units - Miercna
		"UnitDisbanded_Miercna",
		"UnitDisbanded",
		function(context) return context:unit():faction():name() == "vik_fact_mierce" and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true end,
		function(context) MiercnaDisbandOrMergeUnits(context, "vik_fact_mierce") end,
		true
	);
	
	if cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == true then
		MiercnaCheckPeasantsMechanic("vik_fact_mierce");
	end

end



--------------------------------------------------------------------------------
----------------------------------Functions-------------------------------------
--------------------------------------------------------------------------------


function MiercnaStartMechanicsChecks(context)
	
	if context:faction():has_technology("vik_miercna_civ_market_5") == true and MIE_TECH_TRADE == false then 
		MIE_TECH_TRADE = true;
	end
		
	MiercnaCheckPeasantsMechanic("vik_fact_mierce");
end

--------------------------------------------------------------------------------
------------------------------Battle incidents----------------------------------
--------------------------------------------------------------------------------

function MiercnaResultBattle(context)
	-- Miercna completed a battle
	if context:character():faction():name() == "vik_fact_mierce" then
		--[[battle_result = CMBattleResult("vik_fact_mierce");

		if battle_result == "pyrrhic_victory" then
			-- give 100 amount of money
			cm:trigger_incident("vik_fact_mierce", "vik_miercna_battle_victory_1", true);
		elseif battle_result == "close_victory" then
			--give 250 amount of money
			cm:trigger_incident("vik_fact_mierce", "vik_miercna_battle_victory_2", true);
		elseif battle_result =="decisive_victory" then
			--give 500 amount of money
			cm:trigger_incident("vik_fact_mierce", "vik_miercna_battle_victory_3", true);
		elseif battle_result == "heroic_victory" then
			--give 1000 amount of money
			cm:trigger_incident("vik_fact_mierce", "vik_miercna_battle_victory_4", true);
		end]]--
		
		MiercnaCheckPeasantsMechanic("vik_fact_mierce");
	end
end

--------------------------------------------------------------------------------
------------------------------Peasant mechanic----------------------------------
--------------------------------------------------------------------------------

function MiercnaDisbandOrMergeUnits(context, faction)
	for k = 0, 17 do
		local peasant = PEASANT[k];
		if context:unit():unit_key() == peasant then
			PEASANT_UNIT_REMOVED_MIE = true;
		end
	end
	
	MiercnaCheckPeasantsMechanic(faction)
end

function MiercnaCheckPeasantsMechanic(faction)
	local military_force_list = cm:model():world():faction_by_key(faction):military_force_list();
	local total_settlements = cm:model():world():faction_by_key(faction):region_list():num_items();
	local total_peasants_in_army = 0;
	
	-- Check how many peasants are in the army
	for i = 0, military_force_list:num_items() - 1 do
		if military_force_list:item_at(i):upkeep() > 0 then
			local unit_list = military_force_list:item_at(i):unit_list();
			for j = 0, unit_list:num_items() - 1 do
				local unit = unit_list:item_at(j):unit_key();
				for k = 0, 17 do
					local peasant = PEASANT[k];
					if unit == peasant then
						total_peasants_in_army = total_peasants_in_army + 1;
					end
				end
			end
		end
	end
	
	if PEASANT_UNIT_REMOVED_MIE == true then
		total_peasants_in_army = total_peasants_in_army - 1;
		PEASANT_UNIT_REMOVED_MIE = false;
	end
	
	TOTAL_PEASANTS_MIE = total_peasants_in_army;
	
	-- Check how many settlements the player has, including major settlements
	-- Minor settlements adds 1 peasant
	-- Major settlements adds 2 peasants
	
	local major_settlements = CMMajorSettlements(faction);
	total_settlements = total_settlements - major_settlements;
	local total_major = major_settlements * 2;
	output("Total peasants: "..total_peasants_in_army)
	output("Total major: "..total_major)
	EN_PEASANT_MAX_MIE = total_settlements + total_major;
	output("Max peasants: "..EN_PEASANT_MAX_MIE)
	
	if MIE_TECH_TRADE == true then
		EN_PEASANT_MAX_MIE = EN_PEASANT_MAX_MIE + 10;
	end
	
	--Update the Fyrd cap based on the Burghal system
	EN_PEASANT_MAX_MIE = EN_PEASANT_MAX_MIE * BURGHAL_FYRD_VALUES[BURGHAL_TAX_CURRENT_MIERCE + BURGHAL_LEVEL_CURRENT_MIERCE]
	
	MiercnaUpdateCultureBar(faction);
end

function MiercnaUpdateCultureBar(faction)
-- Update the Culture Bars
	local culture_mechanics_panel = find_uicomponent(cm:ui_root(), "culture_mechanics");
	
	MiercnaRemoveEffect(faction);
	
	if culture_mechanics_panel then
    -- send data to the panel
		if TOTAL_PEASANTS_MIE > EN_PEASANT_MAX_MIE then
			culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_negative", faction, TOTAL_PEASANTS_MIE, EN_PEASANT_MAX_MIE);
			cm:apply_effect_bundle("vik_english_peasant_negative", faction, 0);
		else
			culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_positive", faction, TOTAL_PEASANTS_MIE, EN_PEASANT_MAX_MIE);
			cm:apply_effect_bundle("vik_english_peasant_positive", faction, 0);
		end
	else
		output("[ERROR] Unable to find 'culture_mechanics_panel'")
	end
end

function MiercnaRemoveEffect(faction)
	cm:remove_effect_bundle("vik_english_peasant_positive", faction);
	cm:remove_effect_bundle("vik_english_peasant_negative", faction);
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		EN_PEASANT_MAX_MIE = cm:load_value("EN_PEASANT_MAX_MIE", 0, context);
		TOTAL_PEASANTS_MIE = cm:load_value("TOTAL_PEASANTS_MIE", 0, context);
		PEASANT_UNIT_REMOVED_MIE = cm:load_value("PEASANT_UNIT_REMOVED_MIE", false, context);
		MIE_TECH_TRADE = cm:load_value("MIE_TECH_TRADE", false, context);
	end
);

cm:register_saving_game_callback(
	function(context)	
		cm:save_value("EN_PEASANT_MAX_MIE", EN_PEASANT_MAX_MIE, context);	
		cm:save_value("TOTAL_PEASANTS_MIE", TOTAL_PEASANTS_MIE, context);	
		cm:save_value("PEASANT_UNIT_REMOVED_MIE", PEASANT_UNIT_REMOVED_MIE, context);
		cm:save_value("MIE_TECH_TRADE", MIE_TECH_TRADE, context);
	end
);
