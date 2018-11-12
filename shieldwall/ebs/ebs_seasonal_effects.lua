
local season_cache = -1 --:number

--v function()
local function apply_season_effects()
    if not dev.is_game_created() then
        return
    end
    local prefix = CONST.season_bundle_prefix
    local old_bundle = prefix .. season_cache
    local new_season = cm:model():season()
    dev.log("The current season changed! New season is ["..new_season.."], old season was ["..season_cache.."]", "SES")
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if not faction:is_null_interface() then
            if not (season_cache == -1) then
                cm:remove_effect_bundle(old_bundle, faction:name())
            end
            cm:apply_effect_bundle(prefix..new_season, faction:name(), 0)
            
        end
    end
    season_cache = new_season
end


cm:add_listener(
    "SeasonsFactionTurnStart",
    "FactionTurnStart",
    function(context)
        if cm:model():season() == season_cache then
            return false
        else
            return true
        end
    end,
    function(context)
        apply_season_effects()
    end, 
    true)

dev.pre_first_tick(function(context)
    dev.log("World created while season is ["..cm:model():season().."], and the season cache is ["..season_cache.."] ", "SES")
    if season_cache ~= cm:model():season() then
        apply_season_effects()
    end
end)

cm:register_saving_game_callback(function(context)
    cm:save_value("shield_season", season_cache, context)
    dev.log("Saving the season cache as ["..season_cache.."] ", "SES")
end)

cm:register_loading_game_callback(function(context)
    season_cache = cm:load_value("shield_season", -1, context)
    dev.log("Loaded the season cache as ["..season_cache.."] ", "SES")
end)