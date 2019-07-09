
local faction_to_follower_trait = {
    ["vik_fact_circenn"] = "vik_follower_quartermaster_circenn",
    ["vik_fact_west_seaxe"] = "vik_follower_quartermaster_west_seaxe",
    ["vik_fact_mierce"] = "vik_follower_quartermaster_mierce",
    ["vik_fact_mide"]  = "vik_follower_quartermaster_mide",
    ["vik_fact_east_engle"]  = "vik_follower_quartermaster_east_engle",
    ["vik_fact_northymbre"]  = "vik_follower_quartermaster_northymbre",
    ["vik_fact_strat_clut"]  = "vik_follower_quartermaster_strat_clut",
    ["vik_fact_gwined"]  = "vik_follower_quartermaster_gwined",
    ["vik_fact_dyflin"]  = "vik_follower_quartermaster_dyflin",
    ["vik_fact_sudreyar"]  = "vik_follower_quartermaster_sudreyar",
    ["vik_fact_northleode"]  = "vik_follower_quartermaster",
    ["vik_fact_caisil"]  = "vik_follower_quartermaster",
    ["nil"] = "vik_follower_quartermaster"
} --:map<string, string>




--army visit events can apply effect bundles to the army or the region when an army visits it. 
--pass a blank string to not add that element. 
--v function(army_bundle_key_prefix: string, region_bundle: string, incident_key: string, bundle_levels: number, upgrade_condition: false | (function(region: CA_REGION, army: CA_FORCE) --> number), duration:  number | (function(region: CA_REGION, army: CA_FORCE) --> number), condition: function(region: CA_REGION, army: CA_FORCE) --> boolean) 
function new_army_visits_settlement_event(army_bundle_key_prefix, region_bundle, incident_key, bundle_levels, upgrade_condition, duration, condition)
    local comp_key = army_bundle_key_prefix..incident_key
    cm:add_listener(comp_key, "CharacterEntersGarrison", function(context)
        return condition(context:garrison_residence():region(), context:character():military_force()) and (not cm:get_saved_value("army_visits_cooldown_"..comp_key))
    end, 
    function(context)
        local a_duration = 0 --:number
        if type(duration) == "number" then
            --# assume duration: number
            a_duration = duration
        elseif type(duration) == "function" then
            --# assume duration: function(region: CA_REGION, army: CA_FORCE) --> number
            a_duration = duration(context:garrison_residence():region(), context:character():military_force())
        end
        if army_bundle_key_prefix ~= "" then
            local bundle = army_bundle_key_prefix
            if upgrade_condition == false then
                bundle = bundle.."1"
            else
                --# assume upgrade_condition:function(region: CA_REGION, army: CA_FORCE) --> number
                bundle = bundle..upgrade_condition(context:garrison_residence():region(), context:character():military_force())
            end
            cm:apply_effect_bundle_to_characters_force(bundle, context:character():command_queue_index(), a_duration, true)
        end
        if region_bundle ~= "" then
            cm:apply_effect_bundle_to_region(region_bundle, context:garrison_residence():region():name(), a_duration)
        end
        if incident_key ~= "" then
            cm:trigger_incident(context:character():faction():name(), incident_key, true)
        end
    end,
    true)

end




new_army_visits_settlement_event("sw_warehouse_resupply_", "", "", 3, 
    function(region, army) 
        if region:has_governor() then
            local skill_key = faction_to_follower_trait[region:owning_faction():name()]
            if skill_key == nil then
                skill_key = faction_to_follower_trait[type(skill_key)]
            end
            if region:governor():has_skill(skill_key.."_4") then    
                --dev.log("DF TEST PASSED")
                return 3
            elseif region:governor():has_skill(skill_key.."_1") then
                --dev.log("DF TEST PASSED")
                return 2
            end
        end
        return 1
    end,
    function(region, army)
        local duration = 11 --:number
        if army:unit_list():num_items() > 10 then
            duration = duration - army:unit_list():num_items() + 10 
        end
        if army:has_general() then
            local bonus = 0
            for i = 1, 5 do 
                if army:general_character():has_skill("vik_follower_quartermaster_"..i) then
                    --dev.log("DF TEST PASSED")
                    bonus = i
                end
            end
            duration = duration + (bonus*2)
        end
        for i = 2, 3 do
            if region:building_exists("vik_warehouse_"..i) then
                duration = duration + (i*2)
            end
        end
        return duration
    end,
    function(region, army)
        for i = 1, 3 do
            if region:building_exists("vik_warehouse_"..i) then
                return true
            end
        end
        return false
    end)

new_army_visits_settlement_event("sw_alehouse_drinks_", "", "",  1, false, 3, function(region, army)
    return region:building_exists("vik_alehouse_1")
end)
