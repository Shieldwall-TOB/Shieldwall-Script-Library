-------------------------------------------------------------------------------
------------------------- BURGHAL SYSTEM --------------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 12/07/2018 ------------------------
------------------------- Last Updated: 10/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- The Burghal system gives different effects to English factions based on the level of taxes they have
-- It is further altered by the state of war the faction is in. People hate taxes during peace, but are more willing to pay higher taxes when at war
-- The effect from Burghals is only applied at the start of the turn. This is to prevent 'gamey' changes without suffering the negatives of high taxes.

-- Used for initialising the Burghal system on a new campaign.
BURGHAL_INITIALISED = false;

-- Tracks the tax level for each of the playable english factions. This lets us know what bundle will be applied next turn
-- Stores current and pending tax seperately so that the fyrd mechanic can read it.
BURGHAL_TAX_CURRENT_WEST_SEAXE = 2
BURGHAL_TAX_CURRENT_MIERCE = 2
BURGHAL_TAX_NEXT_WEST_SEAXE = 2
BURGHAL_TAX_NEXT_MIERCE = 2

-- Used to track the burghal effects. 0 = peace. 1 = short war. 2 = long war
BURGHAL_LEVEL_CURRENT_WEST_SEAXE = 0
BURGHAL_LEVEL_CURRENT_MIERCE = 0
BURGHAL_LEVEL_NEXT_WEST_SEAXE = 0
BURGHAL_LEVEL_NEXT_MIERCE = 0

-- Multipliers to Fyrd caps based on tax level. Level + Tax = Fyrd modifier in the table below.
BURGHAL_FYRD_VALUES = {
	[0] = 0.5,
	[1] = 0.75,
	[2] = 1,
	[3] = 1.25,
	[4] = 1.5,
	[5] = 1.75,
	[6] = 2
}	

function Add_Burghal_Listeners()

	cm:add_listener(
		"FactionTurnStart_Burghal",
		"FactionTurnStart",
		function(context) return context:faction():is_human() == true and (context:faction():name() == "vik_fact_west_seaxe" or context:faction():name() == "vik_fact_mierce") end,
		function(context) BurghalUpdateBundle(context) end,
		true
	);
	output("#### Adding Burghal Listeners ####")
	cm:add_listener(
		"GovernorshipTaxRateChanged_Burghal",
		"GovernorshipTaxRateChanged",
		function(context) return context:faction():is_human() == true and (context:faction():name() == "vik_fact_west_seaxe" or context:faction():name() == "vik_fact_mierce") end,
		function() BurghalChecks() end,
		true
	);
	cm:add_listener(
		"FactionLeaderSignsPeaceTreaty_Burghal",
		"FactionLeaderSignsPeaceTreaty",
		function(context) return get_faction("vik_fact_west_seaxe"):is_human() or get_faction("vik_fact_mierce"):is_human() end,
		function() BurghalChecks() end,
		true
	);
	cm:add_listener(
		"RegionChangesOwnership_Burghal",
		"RegionChangesOwnership",
		function() return get_faction("vik_fact_west_seaxe"):is_human() or get_faction("vik_fact_mierce"):is_human() end,
		function() BurghalChecks() end,
		true
	);
	cm:add_listener(
		"FactionSubjugatesOtherFaction_Burghal",
		"FactionSubjugatesOtherFaction",
		function() return get_faction("vik_fact_west_seaxe"):is_human() or get_faction("vik_fact_mierce"):is_human() end,
		function() BurghalChecks() end,
		true
	);
	cm:add_listener(
		"FactionLeaderDeclaresWar_Burghal",
		"FactionLeaderDeclaresWar",
		function() return get_faction("vik_fact_west_seaxe"):is_human() or get_faction("vik_fact_mierce"):is_human() end,
		function() BurghalChecks() end,
		true
	);

	if BURGHAL_INITIALISED == false then
		BURGHAL_INITIALISED = true
		if get_faction("vik_fact_west_seaxe"):is_human() == true then
			cm:apply_effect_bundle("vik_burghal_2_0", "vik_fact_west_seaxe", 0)
		end
		if get_faction("vik_fact_mierce"):is_human() == true then
			cm:apply_effect_bundle("vik_burghal_2_0", "vik_fact_mierce", 0)
		end
	end
	
	BurghalChecks()

end

function BurghalChecks()

	local culture_mechanics_panel = find_uicomponent(cm:ui_root(), "culture_mechanics");

	if get_faction("vik_fact_west_seaxe"):is_human() then
		BURGHAL_LEVEL_NEXT_WEST_SEAXE = BurghalWarCheck(get_faction("vik_fact_west_seaxe"))
		BURGHAL_TAX_NEXT_WEST_SEAXE = get_faction("vik_fact_west_seaxe"):tax_category();
		culture_mechanics_panel:InterfaceFunction("set_war_value", BURGHAL_LEVEL_NEXT_WEST_SEAXE, "vik_fact_west_seaxe");
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_burghal_"..BURGHAL_TAX_NEXT_WEST_SEAXE.."_"..BURGHAL_LEVEL_NEXT_WEST_SEAXE, "vik_fact_west_seaxe");
	end
	
	if get_faction("vik_fact_mierce"):is_human() then
		BURGHAL_LEVEL_NEXT_MIERCE = BurghalWarCheck(get_faction("vik_fact_mierce"))
		BURGHAL_TAX_NEXT_MIERCE = get_faction("vik_fact_mierce"):tax_category();
		culture_mechanics_panel:InterfaceFunction("set_war_value", BURGHAL_LEVEL_NEXT_MIERCE, "vik_fact_mierce");
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_burghal_"..BURGHAL_TAX_NEXT_MIERCE.."_"..BURGHAL_LEVEL_NEXT_MIERCE, "vik_fact_mierce");
	end

end

function BurghalWarCheck(player)
	local faction_list = cm:model():world():faction_list();
	local wars = 0;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if player:name() ~= current_faction:name() then
			if player:at_war_with(current_faction) then
				wars = wars + 1;
				if current_faction:is_horde() == false and current_faction:has_home_region() then
					if BurghalBorderCheck(player:name(), current_faction:name()) then
						return 2;
					end
				end
			end
		end
	end
	if wars > 0 then
		return 1;
	else
		return 0;
	end
end

function BurghalBorderCheck(faction_key, query_faction_key)
	local faction = cm:model():world():faction_by_key(faction_key);	
	local regions = faction:region_list();
	
	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i);
		local border_regions = region:adjacent_region_list();
		
		for j = 0, border_regions:num_items() - 1 do
			local border_region = border_regions:item_at(j);
			
			if border_region:owning_faction():is_null_interface() == false then
				if border_region:owning_faction():name() == query_faction_key then
					return true;
				end
			end
		end
	end
	return false;
end

------------------------------------------------
---------------- Effect Bundles ----------------
------------------------------------------------

function BurghalUpdateBundle(context)

	BurghalChecks()
	BurghalRemoveBundle(context:faction():name())
	BurghalApplyBundle(context:faction():name())

end

function BurghalRemoveBundle(faction)

	output("Removing Burghal bundles for "..faction)
	for i = 0, 4 do
		local a = i
		for j = 0, 2 do
			local b = j
			cm:remove_effect_bundle("vik_burghal_"..a.."_"..b, faction)
		end
	end

end

function BurghalApplyBundle(faction)

	local culture_mechanics_panel = find_uicomponent(cm:ui_root(), "culture_mechanics");
	
	output("Applying Burghal bundle for "..faction)
	if faction == "vik_fact_west_seaxe" then
		BURGHAL_TAX_CURRENT_WEST_SEAXE = BURGHAL_TAX_NEXT_WEST_SEAXE;
		BURGHAL_LEVEL_CURRENT_WEST_SEAXE = BURGHAL_LEVEL_NEXT_WEST_SEAXE;
		cm:apply_effect_bundle("vik_burghal_"..BURGHAL_TAX_CURRENT_WEST_SEAXE.."_"..BURGHAL_LEVEL_CURRENT_WEST_SEAXE, faction, 0)
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_burghal_"..BURGHAL_TAX_CURRENT_WEST_SEAXE.."_"..BURGHAL_LEVEL_CURRENT_WEST_SEAXE, faction);
	elseif faction == "vik_fact_mierce" then
		BURGHAL_TAX_CURRENT_MIERCE = BURGHAL_TAX_NEXT_MIERCE;
		BURGHAL_LEVEL_CURRENT_MIERCE = BURGHAL_LEVEL_NEXT_MIERCE
		cm:apply_effect_bundle("vik_burghal_"..BURGHAL_TAX_CURRENT_MIERCE.."_"..BURGHAL_LEVEL_CURRENT_MIERCE, faction, 0)
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_burghal_"..BURGHAL_TAX_CURRENT_MIERCE.."_"..BURGHAL_LEVEL_CURRENT_MIERCE, faction);
	end

end

------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		BURGHAL_INITIALISED = cm:load_value("BURGHAL_INITIALISED", false, context);
		BURGHAL_LEVEL_CURRENT_WEST_SEAXE = cm:load_value("BURGHAL_LEVEL_CURRENT_WEST_SEAXE", 0, context);
		BURGHAL_LEVEL_CURRENT_MIERCE = cm:load_value("BURGHAL_LEVEL_CURRENT_MIERCE", 0, context);
		BURGHAL_TAX_CURRENT_WEST_SEAXE = cm:load_value("BURGHAL_TAX_CURRENT_WEST_SEAXE", 2, context);
		BURGHAL_TAX_CURRENT_MIERCE = cm:load_value("BURGHAL_TAX_CURRENT_MIERCE", 2, context);
		BURGHAL_TAX_NEXT_WEST_SEAXE = cm:load_value("BURGHAL_TAX_NEXT_WEST_SEAXE", 2, context);
		BURGHAL_TAX_NEXT_MIERCE = cm:load_value("BURGHAL_TAX_NEXT_MIERCE", 2, context);
		BURGHAL_LEVEL_NEXT_WEST_SEAXE = cm:load_value("BURGHAL_LEVEL_NEXT_WEST_SEAXE", 0, context);
		BURGHAL_LEVEL_NEXT_MIERCE = cm:load_value("BURGHAL_LEVEL_NEXT_MIERCE", 0, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("BURGHAL_INITIALISED", BURGHAL_INITIALISED, context);
		cm:save_value("BURGHAL_LEVEL_CURRENT_WEST_SEAXE", BURGHAL_LEVEL_CURRENT_WEST_SEAXE, context);
		cm:save_value("BURGHAL_LEVEL_CURRENT_MIERCE", BURGHAL_LEVEL_CURRENT_MIERCE, context);
		cm:save_value("BURGHAL_TAX_CURRENT_WEST_SEAXE", BURGHAL_TAX_CURRENT_WEST_SEAXE, context);
		cm:save_value("BURGHAL_TAX_CURRENT_MIERCE", BURGHAL_TAX_CURRENT_MIERCE, context);
		cm:save_value("BURGHAL_TAX_NEXT_WEST_SEAXE", BURGHAL_TAX_NEXT_WEST_SEAXE, context);
		cm:save_value("BURGHAL_TAX_NEXT_MIERCE", BURGHAL_TAX_NEXT_MIERCE, context);
		cm:save_value("BURGHAL_LEVEL_NEXT_WEST_SEAXE", BURGHAL_LEVEL_NEXT_WEST_SEAXE, context);
		cm:save_value("BURGHAL_LEVEL_NEXT_MIERCE", BURGHAL_LEVEL_NEXT_MIERCE, context);
		end
);

-----------------------------------------
---------------- Bundles ----------------
-----------------------------------------
--[[
vik_burghal_0_0
vik_burghal_1_0
vik_burghal_2_0
vik_burghal_3_0
vik_burghal_4_0

vik_burghal_0_1
vik_burghal_1_1
vik_burghal_2_1
vik_burghal_3_1
vik_burghal_4_1

vik_burghal_0_2
vik_burghal_1_2
vik_burghal_2_2
vik_burghal_3_2
vik_burghal_4_2
]]