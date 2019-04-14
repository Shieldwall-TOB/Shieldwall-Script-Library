-------------------------------------------------------------------------------
--------------------------- ENGLISH CULTURE MECHANICS --------------------------
-------------------------------------------------------------------------------
------------------------- Created by Joy: 20/09/2017 --------------------------
------------------------- Last Updated: 10/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Unique culture mechanics for English
-- 

EN_PEASANT_MAX = 0
TOTAL_PEASANTS = 0
W_TECH_TRADE = false
W_TECH_LEADER = false

W_BONUS = ""
PEASANT_BONUS_TURN = 0
PEASANT_POSITIVE_BONUS_ACTIVE = false
PEASANT_NEGATIVE_BONUS_ACTIVE = false
PEASANT_UNIT_REMOVED = false

W_LOST_BATTLES = 0

PEASANT = {
"eng_ceorl_axemen", 
"eng_fyrd_axemen", 
"eng_long_axemen", 
"eng_mailed_long_axemen", 
"eng_ceorl_spearmen", 
"eng_fyrd_spearmen", 
"eng_militia_fyrd_spearmen", 
"eng_select_fyrd_spearmen",
"eng_select_militia_spearmen",
"eng_ceorl_archers",
"eng_fyrd_archers",
"eng_militia_fyrd_archers",
"eng_select_fyrd_archers",
"eng_ceorl_javelinmen",
"eng_fyrd_javelinmen",
"eng_scout_horsemen",
"eng_catapult" }
	
-- Listeners
function Add_English_Mechanics_Listeners()
output("#### Adding English Mechanics Listeners ####")
	cm:add_listener( -- Start of the turn - player is Westsexa
		"FactionTurnStart_EnglishMechanics_Westsexa",
		"FactionTurnStart",
		function(context) return context:faction():name() == "vik_fact_west_seaxe" and cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) EnglishStartMechanicsChecks(context, "vik_fact_west_seaxe") end,
		true
	);
	cm:add_listener( -- Region changes owner - West Seaxe
		"RegionChangesOwnership_Westsexa_Culture",
		"RegionChangesOwnership",
		function(context) return cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) CheckPeasantsMechanic("vik_fact_west_seaxe") end,
		true
	);
	cm:add_listener( -- Completed a battle - West Seaxe
		"CharacterCompletedBattle_Westsexa_Culture",
		"BattleCompleted",
		function(context) return cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) WestCompleteBattle("vik_fact_west_seaxe") end,
		true
	);
	cm:add_listener( -- Unit trained - West Seaxe
		"UnitTrained_Westsexa_Culture",
		"UnitTrained",
		function(context) return context:unit():faction():name() == "vik_fact_west_seaxe"  and cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) CheckPeasantsMechanic("vik_fact_west_seaxe") end,
		true
	);
	cm:add_listener( -- Unit merged and destroyed - West Seaxe
		"UnitMergedAndDestroyed_Westsexa",
		"UnitMergedAndDestroyed",
		function(context) return context:unit():faction():name() == "vik_fact_west_seaxe"  and cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) DisbandOrMergeUnits(context, "vik_fact_west_seaxe") end,
		true
	);
	cm:add_listener( -- Unit disbanded - West Seaxe
		"UnitDisbanded_Westsexa",
		"UnitDisbanded",
		function(context) return context:unit():faction():name() == "vik_fact_west_seaxe"  and cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true end,
		function(context) DisbandOrMergeUnits(context, "vik_fact_west_seaxe") end,
		true
	);
	
	if cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == true then
		CheckPeasantsMechanic("vik_fact_west_seaxe");
	end
	
end



--------------------------------------------------------------------------------
----------------------------------Functions-------------------------------------
--------------------------------------------------------------------------------


-- At the start of the turn 
function EnglishStartMechanicsChecks(context, faction)

	local turn_number = cm:model():turn_number();
	-- Check the amount of settlements and set the max on the peasant counter
	if PEASANT_BONUS_TURN == turn_number then
		PEASANT_POSITIVE_BONUS_ACTIVE = false;
		PEASANT_NEGATIVE_BONUS_ACTIVE = false;
	end


	if context:faction():has_technology("vik_westsexa_civ_market_5") == true and W_TECH_TRADE == false then 
		W_TECH_TRADE = true;
	elseif context:faction():has_technology("vik_westsexa_civ_leader_6") == true and W_TECH_LEADER == false then
		W_TECH_LEADER = true;
	end

	
	CheckPeasantsMechanic(faction);
end

--------------------------------------------------------------------------------
------------------------------Peasant mechanic----------------------------------
--------------------------------------------------------------------------------

function DisbandOrMergeUnits(context, faction)
	for k = 0, 17 do
		local peasant = PEASANT[k];
		if context:unit():unit_key() == peasant then
			PEASANT_UNIT_REMOVED = true;
		end
	end
	
	CheckPeasantsMechanic(faction);
end

function CheckPeasantsMechanic(faction)
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
						--output(unit)
						total_peasants_in_army = total_peasants_in_army + 1;
					end
				end
			end
		end
	end
	
	if PEASANT_UNIT_REMOVED == true then
		total_peasants_in_army = total_peasants_in_army - 1;
		PEASANT_UNIT_REMOVED = false;
	end
	
	TOTAL_PEASANTS = total_peasants_in_army;
	
	-- Check how many settlements the player has, including major settlements
	-- Minor settlements adds 1 peasant
	-- Major settlements adds 2 peasants
	
	local major_settlements = CMMajorSettlements(faction);
	total_settlements = total_settlements - major_settlements;
	local total_major = major_settlements * 2;
	output("Total peasants: "..total_peasants_in_army)
	output("Total major: "..total_major)
	EN_PEASANT_MAX = total_settlements + total_major;
	output("Max peasants: "..EN_PEASANT_MAX)
	
	
	
	-- If the positive peasant bonus is active check if it needs to be deactivated otherwise add the bonus peasants
	if PEASANT_POSITIVE_BONUS_ACTIVE == true then
		EN_PEASANT_MAX = EN_PEASANT_MAX + 10;
	end
	
	if W_TECH_TRADE == true then
		EN_PEASANT_MAX = EN_PEASANT_MAX + 10;
	end
	
	-- If the negative peasant bonus is active check if it needs to be deactivated otherwise remove peasants
	if PEASANT_NEGATIVE_BONUS_ACTIVE == true then
		EN_PEASANT_MAX = EN_PEASANT_MAX - 10;
	end
	
	--Update the Fyrd cap based on the Burghal system
	EN_PEASANT_MAX = EN_PEASANT_MAX * BURGHAL_FYRD_VALUES[BURGHAL_TAX_CURRENT_WEST_SEAXE + BURGHAL_LEVEL_CURRENT_WEST_SEAXE]
	
	EnglishUpdateCultureBar(faction);

end

function EnglishUpdateCultureBar(faction)
-- Update the Culture Bars
	local culture_mechanics_panel = find_uicomponent(cm:ui_root(), "culture_mechanics");
	
	EnglishRemoveEffect(faction);
	
	if culture_mechanics_panel then
    -- send data to the panel
		if TOTAL_PEASANTS > EN_PEASANT_MAX then
			culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_negative", faction, TOTAL_PEASANTS, EN_PEASANT_MAX);
			cm:apply_effect_bundle("vik_english_peasant_negative", faction, 0);
		else
			culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_positive", faction, TOTAL_PEASANTS, EN_PEASANT_MAX);
			cm:apply_effect_bundle("vik_english_peasant_positive", faction, 0);
		end
	else
		output("[ERROR] Unable to find 'culture_mechanics_panel'")
	end
end

function EnglishRemoveEffect(faction)
	cm:remove_effect_bundle("vik_english_peasant_positive", faction);
	cm:remove_effect_bundle("vik_english_peasant_negative", faction);
end

function WestCompleteBattle(faction)
	local battle_result = CMBattleResult(faction);
	if battle_result ~= "" then
		if battle_result == "crushing_defeat" or battle_result == "decisive_defeat" or battle_result == "close_defeat" or battle_result == "valiant_defeat" then
			W_LOST_BATTLES = W_LOST_BATTLES + 1;
		else
			W_LOST_BATTLES = 0;
		end
		CheckPeasantsMechanic(faction);
	end	
end


------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		EN_PEASANT_MAX = cm:load_value("EN_PEASANT_MAX", 0, context);
		TOTAL_PEASANTS = cm:load_value("TOTAL_PEASANTS", 0, context);
		PEASANT_BONUS_TURN = cm:load_value("PEASANT_BONUS_TURN", 0, context);
		W_TECH_TRADE = cm:load_value("W_TECH_TRADE", false, context);
		W_TECH_LEADER = cm:load_value("W_TECH_LEADER", false, context);
		W_BONUS = cm:load_value("W_BONUS", "", context);
		PEASANT_POSITIVE_BONUS_ACTIVE = cm:load_value("PEASANT_POSITIVE_BONUS_ACTIVE", false, context);
		PEASANT_NEGATIVE_BONUS_ACTIVE = cm:load_value("PEASANT_NEGATIVE_BONUS_ACTIVE", false, context);
		PEASANT_UNIT_REMOVED = cm:load_value("PEASANT_UNIT_REMOVED", false, context);
		W_LOST_BATTLES = cm:load_value("W_LOST_BATTLES", 0, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("EN_PEASANT_MAX", EN_PEASANT_MAX, context);
		cm:save_value("TOTAL_PEASANTS", TOTAL_PEASANTS, context);
		cm:save_value("PEASANT_BONUS_TURN", PEASANT_BONUS_TURN, context);
		cm:save_value("W_TECH_TRADE", W_TECH_TRADE, context);
		cm:save_value("W_TECH_LEADER", W_TECH_LEADER, context);
		cm:save_value("W_BONUS", W_BONUS, context);
		cm:save_value("PEASANT_POSITIVE_BONUS_ACTIVE", PEASANT_POSITIVE_BONUS_ACTIVE, context);
		cm:save_value("PEASANT_NEGATIVE_BONUS_ACTIVE", PEASANT_NEGATIVE_BONUS_ACTIVE, context);
		cm:save_value("PEASANT_UNIT_REMOVED", PEASANT_UNIT_REMOVED, context);
		cm:save_value("W_LOST_BATTLES", W_LOST_BATTLES, context);
	end
);