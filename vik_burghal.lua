







BURGHAL_VALUES = {} --:map<string, boolean>
FYRD_VALUES = {} --:map<string, string>
DISBANDED_FYRD = {} --:map<string, number>


--v function(faction: CA_FACTION)
local function EnglishRemoveEffect(faction)
	cm:remove_effect_bundle("vik_english_peasant_positive", faction:name());
	cm:remove_effect_bundle("vik_english_peasant_negative", faction:name());
end

--v function(faction: CA_FACTION )
local function BurghalRemoveBundle(faction)
	dev.log("Removing Burghal bundles for "..faction:name(), "FYRD")
	for i = 0, 4 do
		local a = i
		for j = 0, 2 do
			local b = j
			cm:remove_effect_bundle("vik_burghal_"..a.."_"..b, faction:name())
		end
	end

end

local raider_factions = {
	["rebels"] = true
}--:map<string, boolean>


--# type global BURGHAL_RETURN = "raids" | "war" | "peace"
--v function(player: CA_FACTION) --> BURGHAL_RETURN
local function BurghalWarCheck(player)
	local faction_list = cm:model():world():faction_list();
	local wars = 0;
	local raiders = 0;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if player:name() ~= current_faction:name() then
			if player:at_war_with(current_faction) then
				wars = wars + 1;
			end
		end
	end
	if wars > 0 then
		return "war";
end
	return "peace";
end


--v function(faction: CA_FACTION, num_govs: number, happy_govs: number) --> boolean
local function update_fyrd_ui(faction, num_govs, happy_govs)
	EnglishRemoveEffect(faction)
	BURGHAL_VALUES[faction:name()] = (num_govs == happy_govs)
	local culture_mechanics_panel = find_uicomponent(cm:ui_root(), "culture_mechanics");
	if not culture_mechanics_panel then
		dev.log("ERORR: Could not find the culture mechanics UI element", "FYRD")
		return false
	end
	if num_govs > happy_govs then
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_negative", faction:name(), happy_govs, num_govs);
		cm:apply_effect_bundle("vik_english_peasant_negative", faction:name(), 0);
		dev.log("Burghal is contented for ["..faction:name().."] ", "FYRD")
		return false
	else
		culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_english_peasant_positive", faction:name(), happy_govs, num_govs);
		cm:apply_effect_bundle("vik_english_peasant_positive", faction:name(), 0);
		dev.log("Burghal is contented for ["..faction:name().."] ", "FYRD")
		return true
	end
end

--v function(faction: CA_FACTION, season: number)
local function update_burghal_ui(faction, season)
	BurghalRemoveBundle(faction)
	local culture_mechanics_panel = dev.get_uic(cm:ui_root(), "culture_mechanics");
	if not culture_mechanics_panel then
		dev.log("ERORR: Could not find the culture mechanics UI element", "FYRD")
		return
	end
	local at_war = BurghalWarCheck(faction)
	local condition --:number
	if at_war == "peace" then
		condition = 0
	elseif at_war == "war" then
		if DISBANDED_FYRD[faction:name()] == nil then
			DISBANDED_FYRD[faction:name()] = 0
		end
		local disbanded = DISBANDED_FYRD[faction:name()] 
		if BURGHAL_VALUES[faction:name()] then
			condition = 4
		else
			condition = 2 
		end
	end
	if condition == nil then
		dev.log("Warning, the burghal condition for ["..faction:name().."] was nil!")
		condition = 0
	end
	cm:apply_effect_bundle("vik_burghal_"..condition.."_"..season, faction:name(), 0)
	culture_mechanics_panel:InterfaceFunction("set_war_value", season, faction:name());
	culture_mechanics_panel:InterfaceFunction("set_culture_mechanics_data", "vik_burghal_"..tostring(condition).."_"..tostring(season), faction:name());
	dev.log("Updated Burghal UI with condition ["..condition.."] and season ["..season.."] for faction ["..faction:name().."] ")
end



--v function(faction: CA_FACTION)
local function update_fyrd_for_faction(faction)
	local region_list = faction:region_list()
	local new_brughal = 0 --:number
	local new_total = 0 --:number
	local check_reg = {} --:map<CA_CQI, boolean>
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_province_capital() then
			if region:has_governor() and (not check_reg[region:governor():cqi()]) then
				new_total = new_total+ 1;
				check_reg[region:governor():cqi()] = true
				if region:governor():loyalty() >= 0 then 
					 new_brughal = new_brughal + 1;
				end
			end
		end
	end
	local fyrd_good = update_fyrd_ui(faction, new_total, new_brughal)
	local fyrd_disbanded = DISBANDED_FYRD[faction:name()] or 0
	
	local season = cm:model():season()
	if season <= 1 then
		update_burghal_ui(faction, 0)
	else
		update_burghal_ui(faction, season-1)
	end
end

local valid_factions = {
	["vik_fact_west_seaxe"] = true ,
	["vik_fact_mierce"] = true,
	["vik_fact_northleode"] = true
} --:map<string, boolean>

function Add_Burghal_Listeners()

cm:add_listener(
	"FactionTurnStart_Burghal",
	"FactionTurnStart",
	function(context) return context:faction():is_human() == true and valid_factions[context:faction():name()] end,
	function(context) update_fyrd_for_faction(context:faction()) end,
	true
);

cm:add_listener(
	"FactionLeaderSignsPeaceTreaty_Burghal",
	"FactionLeaderSignsPeaceTreaty",
	function(context) return (function() for key, _ in pairs(valid_factions) do if dev.get_faction(key):is_human() then return true end end return false end)() end,
	function(context) 
		local humans = cm:get_human_factions()
		for i = 1, #humans do
			update_fyrd_for_faction(dev.get_faction(humans[i]))
		end
	end,
	true
);

cm:add_listener(
	"GovernorAssignedCharacterEvent_Burghal",
	"GovernorAssignedCharacterEvent",
	function(context) return (function() for key, _ in pairs(valid_factions) do if dev.get_faction(key):is_human() then return true end end return false end)() end,
	function(context) 
		local humans = cm:get_human_factions()
		for i = 1, #humans do
			update_fyrd_for_faction(dev.get_faction(humans[i]))
		end
	end,
	true
);

end;



dev.new_game(function(context)
	local humans = cm:get_human_factions()
	for i = 1, #humans do
		update_fyrd_for_faction(dev.get_faction(humans[i]))
	end
end)



------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------

cm:register_loading_game_callback(
	function(context)
		BURGHAL_VALUES = cm:load_value("BURGHAL_VALUES", {}, context);
		FYRD_VALUES = cm:load_value("FYRD_VALUES", {}, context);
		DISBANDED_FYRD = cm:load_value("DISBANDED_FYRD", {}, context);
	end
);

cm:register_saving_game_callback(
	function(context)
		cm:save_value("BURGHAL_VALUES", BURGHAL_VALUES, context);
		cm:save_value("FYRD_VALUES", FYRD_VALUES, context);
		cm:save_value("DISBANDED_FYRD", DISBANDED_FYRD, context);
	end
);


function Add_Miercna_Mechanics_Listeners()

end

function Add_English_Mechanics_Listeners()

end