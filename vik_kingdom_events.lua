-------------------------------------------------------------------------------
-------------------------- KINGDOM FORMING EVENTS -----------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 14/03/2017 ------------------------
------------------------- Last Updated: 05/03/2018 Craig Kirby ----------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Scripted events that cause a faction to reform into a new, unified Kingdom.
-- Kingdom Hierachy:
	-- Prydein
		-- Wales / Cymru
		-- Yr Hen Ogledd / The Old North
	-- Scotland
		-- Alba
	-- Ireland / Erenn
		-- Temhair
	-- England
		-- Anglo Saxon
	-- North Sea Empire
		-- Danelaw
	-- Norse Gaelic Sea
		-- Lochlann / Innsi Gall
		-- Irish Vikings 
-- Lower tier Kingdoms cannot be formed if their higher tier Kingdom exists, but higher tier Kingdoms can form from lower tiered ones.
-- For example the Anglo Saxon Kingdom can't form if the English Kingdom exists, but the English Kingdom can be formed by the Anglo Saxon Kingdom.

-- Table used to store factions that form Kingdoms, so that the same Kingdom doesn't form twice.
KINGDOM_FOUNDERS = {};

function Add_Kingdom_Events_Listeners()
output("#### Adding Kingdom Events Listeners ####")
	cm:add_listener(
		"FactionTurnStart_KingdomChecks",
		"FactionTurnStart",
		true,
		function(context) KingdomChecksTurnStart(context) end,
		true
	);
	cm:add_listener(
		"RegionChangesOwnership_KingdomChecks",
		"RegionChangesOwnership",
		true,
		function(context) KingdomChecksRegion(context) end,
		true
	);
	cm:add_listener(
		"FactionSubjugatesOtherFaction_KingdomChecks",
		"FactionSubjugatesOtherFaction",
		function(context) return cm:model():is_multiplayer() == false and cm:model():is_player_turn() == true end,
		function(context) KingdomChecksSubjugation(context) end,
		true
	);
end

function KingdomChecksTurnStart(context)
	local faction = context:faction();
	KingdomChecks(faction)
end

function KingdomChecksRegion(context)
	local faction = context:region():owning_faction();
	KingdomChecks(faction)
end

function KingdomChecksSubjugation(context)
	local faction = context:faction()
	KingdomChecks(faction)
end

-- Look if any Kingdom factions exist, and if not check if they should
function KingdomChecks(faction)

	-- Prydein
	if KINGDOM_FOUNDERS["prydein"] == nil then
		KingdomCheckPrydein(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["prydein"]):is_dead() == true then
		KingdomResetFounder("prydein");
		KingdomCheckPrydein(faction);
	end
	
	-- Wales / Cymru
	if KINGDOM_FOUNDERS["wales"] == nil and KINGDOM_FOUNDERS["prydein"] == nil then
		KingdomCheckWales(faction);
	elseif KINGDOM_FOUNDERS["prydein"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["wales"]):is_dead() == true then
		KingdomResetFounder("wales");
		KingdomCheckWales(faction);
	end

	-- The Old North
	if KINGDOM_FOUNDERS["old_north"] == nil and KINGDOM_FOUNDERS["prydein"] == nil then
		KingdomCheckOldNorth(faction);
	elseif KINGDOM_FOUNDERS["prydein"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["old_north"]):is_dead() == true then
		KingdomResetFounder("old_north");
		KingdomCheckOldNorth(faction);
	end
	
	-- Ireland
	if KINGDOM_FOUNDERS["ireland"] == nil then
		KingdomCheckIreland(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["ireland"]):is_dead() == true then
		KingdomResetFounder("ireland");
		KingdomCheckIreland(faction);
	end
	
	-- Temhair
	if KINGDOM_FOUNDERS["temhair"] == nil and KINGDOM_FOUNDERS["ireland"] == nil then
		KingdomCheckTemhair(faction);
	elseif KINGDOM_FOUNDERS["ireland"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["temhair"]):is_dead() == true then
		KingdomResetFounder("temhair");
		KingdomCheckTemhair(faction);
	end
	
	-- England
	if KINGDOM_FOUNDERS["england"] == nil then
		KingdomCheckEngland(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["england"]):is_dead() == true then
		KingdomResetFounder("england");
		KingdomCheckEngland(faction);
	end	
	
	-- Anglo Saxons
	if KINGDOM_FOUNDERS["anglo_saxon"] == nil and KINGDOM_FOUNDERS["england"] == nil then
		KingdomCheckAngloSaxon(faction);
	elseif KINGDOM_FOUNDERS["england"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["anglo_saxon"]):is_dead() == true then
		KingdomResetFounder("anglo_saxon");
		KingdomCheckAngloSaxon(faction);
	end

	-- North Sea Empire
	if KINGDOM_FOUNDERS["north_sea_empire"] == nil then
		KingdomCheckNorthSeaEmpire(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["north_sea_empire"]):is_dead() == true then
		KingdomResetFounder("north_sea_empire");
		KingdomCheckNorthSeaEmpire(faction);
	end
	
	-- Danelaw
	if KINGDOM_FOUNDERS["danelaw"] == nil and KINGDOM_FOUNDERS["north_sea_empire"] == nil then
		KingdomCheckDanelaw(faction);
	elseif KINGDOM_FOUNDERS["north_sea_empire"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["danelaw"]):is_dead() == true then
		KingdomResetFounder("danelaw");
		KingdomCheckDanelaw(faction);
	end

	--  Norse Gaelic Sea
	if KINGDOM_FOUNDERS["norse_gaelic_sea"] == nil then
		KingdomCheckNorseGaelicSea(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["norse_gaelic_sea"]):is_dead() == true then
		KingdomResetFounder("norse_gaelic_sea");
		KingdomCheckNorseGaelicSea(faction);
	end
	
	-- Irish Vikings
	if KINGDOM_FOUNDERS["irish_vikings"] == nil and KINGDOM_FOUNDERS["norse_gaelic_sea"] == nil then
		KingdomCheckIrishVikings(faction);
	elseif KINGDOM_FOUNDERS["norse_gaelic_sea"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["irish_vikings"]):is_dead() == true then
		KingdomResetFounder("irish_vikings");
		KingdomCheckIrishVikings(faction);
	end

	-- Lochlann
	if KINGDOM_FOUNDERS["lochlann"] == nil and KINGDOM_FOUNDERS["norse_gaelic_sea"] == nil then
		KingdomCheckLochlann(faction);
	elseif KINGDOM_FOUNDERS["norse_gaelic_sea"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["lochlann"]):is_dead() == true then
		KingdomResetFounder("lochlann");
		KingdomCheckLochlann(faction);
	end

	-- Scotland
	if KINGDOM_FOUNDERS["scotland"] == nil then
		KingdomCheckScotland(faction);
	elseif cm:model():world():faction_by_key(KINGDOM_FOUNDERS["scotland"]):is_dead() == true then
		KingdomResetFounder("scotland");
		KingdomCheckScotland(faction);
	end	
	
	-- Alba
	if KINGDOM_FOUNDERS["alba"] == nil and KINGDOM_FOUNDERS["scotland"] == nil then
		KingdomCheckAlba(faction);
	elseif KINGDOM_FOUNDERS["scotland"] == nil and cm:model():world():faction_by_key(KINGDOM_FOUNDERS["alba"]):is_dead() == true then
		KingdomResetFounder("alba");
		KingdomCheckAlba(faction);
	end

end

function KingdomCheckPrydein(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_gwined"):is_human() == false and cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_welsh" and Has_Required_Regions_Vassals(faction:name(), REGIONS_WALES) and Has_Required_Regions_Vassals(faction:name(), REGIONS_OLD_NORTH) and Has_Required_Regions_Vassals(faction:name(), REGIONS_CERNEU) == true then
			KingdomSetFounderFaction(faction, "prydein", false);
		end
	end
end

function KingdomCheckWales(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_gwined"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_welsh" and faction:name() ~= "vik_fact_strat_clut" and Has_Required_Regions_Vassals(faction:name(), REGIONS_WALES) == true then
			KingdomSetFounderFaction(faction, "wales", false);
		end
	end
end

function KingdomCheckOldNorth(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_strat_clut"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_welsh" and faction:name() ~= "vik_fact_gwined" and Has_Required_Regions_Vassals(faction:name(), REGIONS_OLD_NORTH) == true then
			KingdomSetFounderFaction(faction, "old_north", false);
		end
	end
end

function KingdomCheckIreland(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_mide"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_irish" then
			local vassalcheck = 0;
			for i = 0, cm:model():world():faction_list():num_items() - 1 do
				local f = cm:model():world():faction_list():item_at(i)
				if f:is_vassal_of(faction) == true then
					vassalcheck = vassalcheck + 1
				end
			end
			if vassalcheck >= 10 then
				KingdomSetFounderFaction(faction, "ireland", false);
			end
		end
	end
end

function KingdomCheckTemhair(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_mide"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_irish" then
			local vassalcheck = 0;
			for i = 0, cm:model():world():faction_list():num_items() - 1 do
				local f = cm:model():world():faction_list():item_at(i)
				if f:is_vassal_of(faction) == true then
					vassalcheck = vassalcheck + 1
				end
			end
			if vassalcheck >= 5 then
				KingdomSetFounderFaction(faction, "temhair", false);
			end
		end
	end
end

function KingdomCheckEngland(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == false and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_english" and Has_Required_Regions_Vassals(faction:name(), REGIONS_ENGLAND_CAPITALS) == true and faction:region_list():num_items() >= 20 then
			KingdomSetFounderFaction(faction, "england", false);
		end
	end
end

function KingdomCheckAngloSaxon(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_west_seaxe"):is_human() == false and cm:model():world():faction_by_key("vik_fact_mierce"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_english" and Has_Required_Regions_Vassals(faction:name(), REGIONS_ANGLO_SAXON_CAPITALS) == true and faction:region_list():num_items() >= 10 then
			KingdomSetFounderFaction(faction, "anglo_saxon", false);
		end
	end
end

function KingdomCheckNorthSeaEmpire(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() == false and cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_anglo_viking" and Has_Required_Regions_Vassals(faction:name(), REGIONS_ENGLAND_CAPITALS) == true and faction:region_list():num_items() >= 20 then
			KingdomSetFounderFaction(faction, "north_sea_empire", false);
		end
	end
end

function KingdomCheckDanelaw(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_east_engle"):is_human() == false and cm:model():world():faction_by_key("vik_fact_northymbre"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_anglo_viking" and Has_Required_Regions_Vassals(faction:name(), REGIONS_DANELAW_CAPITALS) == true and faction:region_list():num_items() >= 10 then
			KingdomSetFounderFaction(faction, "danelaw", false);
		end
	end
end

function KingdomCheckNorseGaelicSea(faction)
	if cm:model():is_multiplayer() == true or (cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == false and cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == false) then
		if faction:subculture() == "vik_sub_cult_viking_gael" and cm:model():world():region_manager():region_by_key("vik_reg_dyflin"):owning_faction():name() == faction:name() and cm:model():world():region_manager():region_by_key("vik_reg_bornais"):owning_faction():name() == faction:name() and Has_Any_Required_Regions_Vassals(faction:name(), REGIONS_PORTS, 20) then
			KingdomSetFounderFaction(faction, "norse_gaelic_sea", false);
		end
	end
end

function KingdomCheckIrishVikings(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_dyflin"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_viking_gael" and faction:name() ~= "vik_fact_sudreyar" and cm:model():world():region_manager():region_by_key("vik_reg_dyflin"):owning_faction():name() == faction:name() and Has_Any_Required_Regions_Vassals(faction:name(), REGIONS_PORTS, 10)  then
			KingdomSetFounderFaction(faction, "irish_vikings", false);
		end
	end
end
	
function KingdomCheckLochlann(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_sudreyar"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_viking_gael" and faction:name() ~= "vik_fact_dyflin" and cm:model():world():region_manager():region_by_key("vik_reg_bornais"):owning_faction():name() == faction:name() and Has_Any_Required_Regions_Vassals(faction:name(), REGIONS_PORTS, 10) then
			KingdomSetFounderFaction(faction, "lochlann", false);
		end
	end
end

function KingdomCheckScotland(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_circenn"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_scots" then
			local vassalcheck = 0;
			for i = 0, cm:model():world():faction_list():num_items() - 1 do
				local f = cm:model():world():faction_list():item_at(i)
				if f:is_vassal_of(faction) == true then
					vassalcheck = vassalcheck + 1
				end
			end
			if vassalcheck >= 10 then
				KingdomSetFounderFaction(faction, "scotland", false);
			end
		end
	end
end

function KingdomCheckAlba(faction)
	if cm:model():is_multiplayer() == true or cm:model():world():faction_by_key("vik_fact_circenn"):is_human() == false then
		if faction:subculture() == "vik_sub_cult_scots" then
			local vassalcheck = 0;
			for i = 0, cm:model():world():faction_list():num_items() - 1 do
				local f = cm:model():world():faction_list():item_at(i)
				if f:is_vassal_of(faction) == true then
					vassalcheck = vassalcheck + 1
				end
			end
			if vassalcheck >= 5 then
				KingdomSetFounderFaction(faction, "alba", false);
			end
		end
	end
end

function KingdomSetFounderFaction(faction, kingdom, long_victory)
	KINGDOM_FOUNDERS[kingdom] = faction:name();
	Rename_Faction(faction:name(), "vik_fact_kingdom_"..kingdom);
	local founder = "ai";
	
	--Remove old effect bundles for player and apply new effect bundles
	if faction:is_human() then
		founder = "player";
		if faction:name() == "vik_fact_gwined" then
			cm:remove_effect_bundle("vik_faction_trait_gwined_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_wales_gwined", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_gwined", faction:name(), 0)
		elseif faction:name() == "vik_fact_mide" then
			cm:remove_effect_bundle("vik_faction_trait_mide_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_temhair_mide", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_mide", faction:name(), 0)
		elseif faction:name() == "vik_fact_strat_clut" then
			cm:remove_effect_bundle("vik_faction_trait_strat_clut_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_old_north_strat_clut", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_strat_clut", faction:name(), 0)
		elseif faction:name() == "vik_fact_circenn" then
			cm:remove_effect_bundle("vik_faction_trait_circenn_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_alba_circenn", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_circenn", faction:name(), 0)
		elseif faction:name() == "vik_fact_west_seaxe" then
			cm:remove_effect_bundle("vik_faction_trait_west_seaxe_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_anglo_saxon_west_seaxe", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_west_seaxe", faction:name(), 0)
		elseif faction:name() == "vik_fact_mierce" then
			cm:remove_effect_bundle("vik_faction_trait_mierce_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_anglo_saxon_mierce", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_mierce", faction:name(), 0)
		elseif faction:name() == "vik_fact_east_engle" then
			cm:remove_effect_bundle("vik_faction_trait_east_engle_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_danelaw_east_engle", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_east_engle", faction:name(), 0)
		elseif faction:name() == "vik_fact_northymbre" then
			cm:remove_effect_bundle("vik_faction_trait_northymbre_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_danelaw_northymbre", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_northymbre", faction:name(), 0)
		elseif faction:name() == "vik_fact_dyflin" then
			cm:remove_effect_bundle("vik_faction_trait_dyflin_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_irish_vikings_dyflin", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_dyflin", faction:name(), 0)
		elseif faction:name() == "vik_fact_sudreyar" then
			cm:remove_effect_bundle("vik_faction_trait_sudreyar_campaign", faction:name())
			cm:remove_effect_bundle("vik_kingdom_lochlann_sudreyar", faction:name())
			cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_sudreyar", faction:name(), 0)
		end
	end
	dev.eh:trigger_event("FactionFormsKingdom", kingdom, get_faction(faction))
	--Fire the incident
	local incident = "vik_incident_kingdom_formed_"..kingdom.."_"..founder;
	if long_victory == true then
		incident = "vik_incident_kingdom_formed_"..kingdom.."_player_long_victory";
	end
	local x = faction:home_region():settlement():logical_position_x()
	local y = faction:home_region():settlement():logical_position_y()
	if cm:model():is_multiplayer() == false then
		-- Incident disabled in multiplayer as 'short kingdom' victories aren't in multiplayer
		TriggerIncidentLocationMPSafe(incident, x, y);
	end
end

function KingdomResetFounder(kingdom)
	--local incident = "vik_incident_kingdom_destroyed_"..kingdom
	--TriggerIncidentMPSafe(incident);
	cm:set_faction_name_override(KINGDOM_FOUNDERS[kingdom], "");
	KINGDOM_FOUNDERS[kingdom] = nil
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:register_loading_game_callback(
	function(faction)
		KINGDOM_FOUNDERS = LoadKeyPairTable(faction, "KINGDOM_FOUNDERS");
	end
);

cm:register_saving_game_callback(
	function(faction)
		SaveKeyPairTable(faction, KINGDOM_FOUNDERS, "KINGDOM_FOUNDERS");
	end
);

function SaveKeyPairTable(faction, tab, savename)
	output("Saving Key Pair Table: "..savename);
	local savestring = "";
	
	for key,value in pairs(tab) do
		savestring = savestring..key..","..value..",;";
	end
	cm:save_value(savename, savestring, faction);
end

function LoadKeyPairTable(faction, savename)
	output("Loading Key Pair Table: "..savename);
	local savestring = cm:load_value(savename, "", faction);
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