-------------------------------------------------------------------------------
--------------------------- COMMON CULTURE MECHANICS --------------------------
-------------------------------------------------------------------------------
------------------------- Created by Joy: 13/09/2017 --------------------------
------------------------- Last Updated: 03/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Common functions for the culture/faction mechanics
-- 


-- Checks the outcome of a battle
-- Doesn't use an interface
-- Returns the result as a string ("pyrrhic_victory", "close_victory", "heroic_victory", "decisive_victory", and all the defeats) 
function CMBattleResult(faction)
	local battle_result = "";
	local main_attacker_faction = cm:pending_battle_cache_get_attacker_faction_name(1);
	local main_defender_faction = cm:pending_battle_cache_get_defender_faction_name(1);
	
	if cm:model():pending_battle():attacker_battle_result() == "close_defeat" and cm:model():pending_battle():defender_battle_result() == "close_defeat" then
		battle_result = "";
	elseif cm:model():world():faction_by_key(main_attacker_faction):is_null_interface() == false and cm:model():world():faction_by_key(main_attacker_faction):name() == faction then 
		battle_result = cm:model():pending_battle():attacker_battle_result();
	elseif cm:model():world():faction_by_key(main_defender_faction):is_null_interface() == false and cm:model():world():faction_by_key(main_defender_faction):name() == faction then
		battle_result = cm:model():pending_battle():defender_battle_result(); 
	end
	return battle_result;
end

-- Checks if a settlement is a major settlement
-- Uses CHARACTER_SCRIPT_INTERFACE
-- Returns true or false
function CMIsMajorSettlement(context)
	local settlement = context:character():region():name();
	for i = 1, #REGIONS_MAJOR_SETTLEMENTS do
		local major = cm:model():world():region_manager():region_by_key(REGIONS_MAJOR_SETTLEMENTS[i]):name();
		if settlement == major then
			return true;
		end
	end
	return false;
end

-- Checks how many major settlement the player owns
-- Returns the number of major settlements
function CMMajorSettlements(faction)
	local current_faction = cm:model():world():faction_by_key(faction);
	local major_settlements = 0;
	
	for i = 1, #REGIONS_MAJOR_SETTLEMENTS do
		local major = cm:model():world():region_manager():region_by_key(REGIONS_MAJOR_SETTLEMENTS[i]):owning_faction():name();
		if major == current_faction then
			major_settlements = major_settlements + 1;
		end
	end
	return major_settlements;
end

-- Checks the amount of vassals that belongs to a faction
-- Uses FACTION_SCRIPT_INTERFACE
-- Returns the number of vassals 
function CMVassalAmount(context, faction)
	local total_vassals = 0;
	local faction_list = cm:model():world():faction_list();
	local faction_amount = faction_list:num_items();
	
	for i = 0, faction_amount - 1 do
		local vassal = faction_list:item_at(i):is_vassal_of(cm:model():world():faction_by_key(faction));
		if vassal ~= nil and vassal == true then
			total_vassals = total_vassals + 1;
		end
	end
	return total_vassals;
end

-- Checks the amount of squalor
-- Uses FACTION_SCRIPT_INTERFACE
-- Returns the amount of squalor
function CMSqualorAmount(context)
	local region_list = context:faction():region_list();
	local total_squalor = 0;
	
	for i = 0, region_list:num_items() - 1 do
		amount_squalor = region_list:item_at(i):squalor();
		total_squalor = total_squalor + amount_squalor;
	end
	return total_squalor;
end

-- Checks if faction has reached High King
-- Uses
-- Returns true or false
function IsHighKing()
	-- probably needs to work with victory conditions script
	return true;
end

-- Checks how many settlements are owned by the player in a certain area
-- Uses 
-- Returns the number of settlements
function CMAreaCovered(region, faction)
	local settlements = 0;
	for i = 1, #region do
		local current_region = cm:model():world():region_manager():region_by_key(region[i]);
		local current_faction = current_region:owning_faction():name();
		if current_faction == faction then
			settlements = settlements + 1;
		end
	end
	--output(faction.." settlements: "..settlements);
	return settlements;
end

-- Checks if a settlement is in a certain area
-- Uses 
-- Returns true or false
function CMSettlementIsInArea(settlement, region)
	for i = 1, #region do
		local current_region = cm:model():world():region_manager():region_by_key(region[i]):name();
		
		if current_region == settlement then
			return true;
		end
	end
	--output(faction.." settlements: "..settlements);
	return false;
end

WESTSEXA_ITEMS = {"vik_item_the_alfred_jewel", "vik_item_ulfberht_sword", "vik_item_lindisfarne_gospels", "vik_item_bedes_ecclesiastical_history", "vik_item_anglo_saxon_chronicle", "vik_item_genealogies"}
MIERCNA_ITEMS = {"vik_item_durham_gospels", "vik_item_hereford_gospels", "vik_item_blickling_psalter", "vik_item_vespasian_psalter", "vik_item_the_tiberius_bede", "vik_item_caedmons_hymn"}
MIDHE_ITEMS = {"vik_item_book_of_armagh", "vik_item_lebor_na_huidre", "vik_item_book_of_kells", "vik_item_tara_brooch", "vik_item_ardagh_chalice"}
SCOAN_ITEMS = {"vik_item_book_of_deer", "vik_item_whitecleuch_chain", "vik_item_st_andrews_sacrophagus"}
GREAT_VIKING_ITEMS = {"vik_item_gram", "vik_item_ulfberht_sword", "vik_item_ingelrd_sword", "vik_item_kragehul_lance"}
GWINED_ITEMS = {"vik_item_caledfwlch", "vik_item_carnwennan", "vik_item_rhongomyniad", "vik_item_rudlwyt", "vik_item_dyrnwyn", "vik_item_annales_cambriae"}
STRAT_CLUT_ITEMS = {"vik_item_book_of_aneirin", "vik_item_book_of_taliesin", "vik_item_st_teilo_gospels", "vik_item_on_the_ruin"}
SEA_KINGS_ITEMS = {"vik_item_sunstone", "vik_item_whalebone_plaque", "vik_item_weather_vane", "vik_item_sun_compass"}
COMMON_ITEMS = {"vik_item_silver_reliquary", "vik_item_prayer_book", "vik_item_gold_ring", "vik_item_chess_set", "vik_item_lute", "vik_item_garnet_hilt_sword", "vik_item_gilt_hemlet", "vik_item_hunting_bow", "vik_item_scales_weights", "vik_item_tapestry", 
"vik_item_decorated_bible", "vik_item_elaborate_brooch", "vik_item_jewelled_chalice", "vik_item_crucifix", "vik_item_inscribed_knife", "vik_item_gold_jewellry", "vik_item_nine_mens_morris_set", "vik_item_drinking_horn" }

-- Possible to gain an Item
-- Check if the item was awarded already, if not then gain item
function CMChanceToGainItem(chance, faction)
	-- define low, medium, high
	local ran_number = cm:random_number(20);
	local item_number = 0;
	local faction_item_list;
	if faction == "vik_fact_west_seaxe" then
		faction_item_list = WESTSEXA_ITEMS;
	elseif faction == "vik_fact_mierce" then
		faction_item_list = MIERCNA_ITEMS;
	elseif faction == "vik_fact_circenn" then
		faction_item_list = SCOAN_ITEMS;
	elseif faction == "vik_fact_east_engle" or faction == "vik_fact_northymbre" then
		faction_item_list = GREAT_VIKING_ITEMS;
	elseif faction == "vik_fact_gwined" then
		faction_item_list = GWINED_ITEMS;
	elseif faction == "vik_fact_strat_clut" then
		faction_item_list = STRAT_CLUT_ITEMS;
	elseif faction == "vik_fact_dyflin" or faction == "vik_fact_sudreyar" then
		faction_item_list = SEA_KINGS_ITEMS;
	end
	--local ran_number = 1
	if ran_number >= 1 and ran_number <= 4 then
		item_number = cm:random_number(#faction_item_list)
		CMRewardItem(faction_item_list[item_number], faction);
	elseif ran_number > 4 and ran_number <= 10 then
		item_number = cm:random_number(#COMMON_ITEMS)
		CMRewardItem(COMMON_ITEMS[item_number], faction);
	end
end


function CMRewardItem(item, faction)
	local faction_leader = cm:model():world():faction_by_key(faction):faction_leader();
	local char_str = char_lookup_str(faction_leader)
	if faction_leader:has_trait(item) == false then
		output("Giving trait " .. tostring(item) .. " to faction leader of faction " .. faction .. ", lookup string is " .. char_str)
		cm:force_add_trait(char_str, item, true)
	end
end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		WESTSEXA_ITEMS = cm:load_value("WESTSEXA_ITEMS", WESTSEXA_ITEMS, context);
		MIERCNA_ITEMS = cm:load_value("MIERCNA_ITEMS", MIERCNA_ITEMS, context);
		MIDHE_ITEMS = cm:load_value("MIDHE_ITEMS", MIDHE_ITEMS, context);
		SCOAN_ITEMS = cm:load_value("SCOAN_ITEMS", SCOAN_ITEMS, context);
		GWINED_ITEMS = cm:load_value("GWINED_ITEMS", GWINED_ITEMS, context);
		STRAT_CLUT_ITEMS = cm:load_value("STRAT_CLUT_ITEMS", STRAT_CLUT_ITEMS, context);
		GREAT_VIKING_ITEMS = cm:load_value("GREAT_VIKING_ITEMS", GREAT_VIKING_ITEMS, context);
		SEA_KINGS_ITEMS = cm:load_value("SEA_KINGS_ITEMS", SEA_KINGS_ITEMS, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("WESTSEXA_ITEMS", WESTSEXA_ITEMS, context);
		cm:save_value("MIERCNA_ITEMS", MIERCNA_ITEMS, context);
		cm:save_value("MIDHE_ITEMS", MIDHE_ITEMS, context);
		cm:save_value("SCOAN_ITEMS", SCOAN_ITEMS, context);
		cm:save_value("GWINED_ITEMS", GWINED_ITEMS, context);
		cm:save_value("STRAT_CLUT_ITEMS", STRAT_CLUT_ITEMS, context);
		cm:save_value("GREAT_VIKING_ITEMS", GREAT_VIKING_ITEMS, context);
		cm:save_value("SEA_KINGS_ITEMS", SEA_KINGS_ITEMS, context);
	end
);