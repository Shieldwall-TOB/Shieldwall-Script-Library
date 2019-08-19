BANDITS = {} --:map<string,string>
BANDIT_ID = 0 --:number
local bandit_faction = "vik_fact_jorvik"
local raid_stance = "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID"
local bandit_spawns = {
    ["vik_reg_bodmine"] = {365,67}, 
    ["vik_reg_totanes"] = {429,91}, 
    ["vik_reg_waecet"] = {446,137}, 
    ["vik_reg_brideport"] = {504,99}, 
    ["vik_reg_suthhamtun"] = {563,113}, 
    ["vik_reg_cissanbyrig"] = {556,155}, 
    ["vik_reg_oxnaforda"] = {565,208}, 
    ["vik_reg_guldeford"] = {612,158}, 
    ["vik_reg_staeningum"] = {628,135}, 
    ["vik_reg_pefenesea"] = {655,132}, 
    ["vik_reg_rofeceaster"] = {657,148}, 
    ["vik_reg_celmeresfort"] = {661,191}, 
    ["vik_reg_herutford"] = {633,206}, 
    ["vik_reg_buccingahamm"] = {610,189}, 
    ["vik_reg_cirenceaster"] = {516,183},  
    ["vik_reg_brug"] = {504,254}, 
    ["vik_reg_staefford"] = {519,298}, 
    ["vik_reg_wyrcesuuyrthe"] = {535,328}, 
    ["vik_reg_flichesburg"] = {609,351}, 
    ["vik_reg_elig"] = {670,261}, 
    ["vik_reg_sancte_eadmundes"] = {691,225}, 
    ["vik_reg_theodford"] = {694,254},  
    ["vik_reg_huntandun"] = {635,242}, 
    ["vik_reg_rocheberie"] = {563,261}, 
    ["vik_reg_scrobbesburg"] = {511,275}, 
    ["vik_reg_lonceaster"] = {512,389}, 
    ["vik_reg_rudglann"] = {464,314}, 
    ["vik_reg_oswaldestroe"] = {464,308}, 
    ["vik_reg_menevia"] = {372,211}, 
    ["vik_reg_lann_dewi"] = {439,236}, 
    ["vik_reg_lude"] = {628,357}, 
    ["vik_reg_doneceaster"] = {560,351}, 
    ["vik_reg_beoferlic"] = {638,386}, 
    ["vik_reg_cherchebi"] = {496,411}, 
    ["vik_reg_rucestr"] = {517,501}, 
    ["vik_reg_dynbaer"] = {506,562}, 
    ["vik_reg_dun_domnaill"] = {384,520}, 
    ["vik_reg_dun_aberte"] = {328,536}, 
    ["vik_reg_dun_blann"] = {436,597}, 
    ["vik_reg_brechin"] = {488,646}, 
    ["vik_reg_ros_cuissine"] = {477,696}, 
    ["vik_reg_inber_nise"] = {424,705}, 
    ["vik_reg_torfness"] = {394,714}, 
    ["vik_reg_latharn"] = {417,777}, 
    ["vik_reg_dun_beccan"] = {291,687}, 
    ["vik_reg_aporcrosan"] = {341,707}, 
    ["vik_reg_dun_na_ngall"] = {180,439}, 
    ["vik_reg_dun_sebuirgi"] = {296,490}, 
    ["vik_reg_cairlinn"] = {291,408}, 
    ["vik_reg_clocher"] = {233,432}, 
    ["vik_reg_linns"] = {269,382}, 
    ["vik_reg_cenannas"] = {264,375}, 
    ["vik_reg_balla"] = {114,382}, 
    ["vik_reg_inis_cathaigh"] = {113,275}, 
    ["vik_reg_tuam_greine"] = {167,298}, 
    ["vik_reg_saigher"] = {222,318}, 
    ["vik_reg_cluain_mor"] = {260,297}, 
    ["vik_reg_imblech_ibair"] = {179,268}, 
    ["vik_reg_druim_collachair"] = {143,266}, 
    ["vik_reg_cluain"] = {198,220}, 
    ["vik_reg_cell_maic_aeda"] = {235,252}, 
    ["vik_reg_ros"] = {260,246}
}--:map<string, {number, number}>



--v function(region: CA_REGION) --> boolean
local function is_owned_force_nearby(region)
    local check_list = {}--:map<string, boolean>
    check_list[region:name()] = true
    for j = 0, region:adjacent_region_list():num_items() - 1 do
        check_list[region:adjacent_region_list():item_at(j):name()] = true
    end
    local char_list = region:owning_faction():character_list()
    for j = 0, char_list:num_items() - 1 do
        local current = char_list:item_at(j)
        if dev.is_char_normal_general(current) then
            if not current:region():is_null_interface() then
                if check_list[current:region():name()] then
                    return true
                end
            end
        end
    end
    return false
end




cm:add_listener(
    "RegionTurnEndBanditSpawnCheck",
    "RegionTurnEnd",
    function(context)
        if context:region():owning_faction():is_null_interface() or context:region():is_province_capital() then
            return false
        end
        if dev.get_faction("vik_fact_west_seaxe"):is_human() and not cm:get_saved_value("start_mission_done_west_seaxe") then
            return false
        end
        if not context:region():owning_faction():is_human() then
            return false
        end
        dev.log("Evaluating bandit spawn potential in "..context:region():name(), "BANDIT")
        local majority_religion = context:region():majority_religion() == "vik_religion_banditry" 
        local no_forces_nearby = (not is_owned_force_nearby(context:region()))
        local region_has_spawner = (not not bandit_spawns[context:region():name()])
        dev.log("Region has spawner: ["..tostring(region_has_spawner).."], forces nearby: ["..tostring(no_forces_nearby).."], has_bandit_religion: ["..tostring(majority_religion).."]", "BANDIT")
        return no_forces_nearby and region_has_spawner and majority_religion
    end,
    function(context)
        local region = context:region()
        local owner = region:owning_faction()
        local is_vassal = pkm:get_faction(owner:name()):is_faction_vassal() 
        if not not BANDITS[region:name()] then
           --bandits already exist here 
            local bandit_cqi = tonumber(BANDITS[region:name()])  
            --# assume bandit_cqi: CA_CQI
            local bandit_general = dev.get_character(bandit_cqi)
            if not bandit_general then
                --he's probably ded.
                BANDITS[region:name()] = nil
            end
            return    
        end
        local num_units_to_add = 2
        -- Sets the number of invading armies based upon difficulty settings
        local difficulty = cm:model():difficulty_level();
        if  difficulty == -1 then -- Hard
            num_units_to_add = 3
        elseif difficulty == -2 then -- Very Hard
            num_units_to_add = 4
        elseif difficulty == -3 then -- Legendary
            num_units_to_add = 4
        end
        local bandit_army = "wel_valley_spearmen,wel_valley_spearmen,dan_fyrd_archers"
        local random_add = {"dan_fyrd_archers", "wel_valley_spearmen", "est_fighters", "est_fighters", "dan_ceorl_javelinmen", "dan_ceorl_javelinmen", "est_mailed_horsemen"} --:vector<string>
        for i = 1, num_units_to_add do 
            bandit_army = bandit_army .. "," .. random_add[cm:random_number(#random_add)]
        end
        BANDIT_ID = BANDIT_ID + 1
        local ID = "bandit_spawn_"..BANDIT_ID
        cm:create_force(bandit_faction, bandit_army, region:name(), bandit_spawns[region:name()][1], bandit_spawns[region:name()][2], ID, true)
        
    end,
true)

cm:add_listener(
    "BanditsCharacterCreated",
    "CharacterCreated",
    function(context)
        return context:character():faction():name() == bandit_faction
    end,
    function(context)
        local cqi = context:character():command_queue_index()
        local region = context:character():region()
        if region:is_null_interface() then
            dev.log("bandit region for "..tostring(cqi).."is null!")
            return
        end
        cm:disable_movement_for_character(dev.lookup(cqi))
    end,
    true
)

cm:add_listener(
    "FactionTurnStartBandits",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == bandit_faction
    end,
    function(context)
        local char_list = context:faction():character_list()
        for i = 0, char_list:num_items() - 1 do
            local bandit = char_list:item_at(i)
            local region = bandit:region()
            if region:is_null_interface() then
                dev.log("bandit region for "..tostring(bandit:command_queue_index()).."is null!")
                return
            end
            if not BANDITS[region:name()] then
                BANDITS[region:name()] = tostring(bandit:command_queue_index())
                cm:trigger_incident(region:owning_faction():name(), "shield_rebellion_bandits_"..region:name(), true)
            end
            if not context:faction():at_war_with(region:owning_faction()) then
                if not pkm:get_faction(region:owning_faction():name()):is_faction_vassal() then
                    cm:force_declare_war(bandit_faction, region:owning_faction():name())
                else
                    local vassal_master = pkm:get_faction(region:owning_faction():name()):liege():name()
                    cm:force_declare_war(bandit_faction, vassal_master)
                end
            end
            if bandit:has_military_force() and not bandit:military_force():active_stance() == raid_stance then
                cm:force_character_force_into_stance(dev.lookup(bandit:command_queue_index()), raid_stance)
            end
        end
    end,
    true
)

dev.new_game(function(context)
    local char_list = dev.get_faction(bandit_faction):character_list()
    for i = 0, char_list:num_items() - 1 do
        local bandit = char_list:item_at(i)
        if bandit:has_military_force() then
            cm:disable_movement_for_character(dev.lookup(bandit))
        end
    end
end)


cm:register_loading_game_callback(
    function(context)
		BANDITS = cm:load_value("BANDITS", {}, context);
	end
);

cm:register_saving_game_callback(
	function(context)
        cm:save_value("BANDITS", BANDITS, context);
	end
);


