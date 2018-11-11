local character_manager = {} --# assume character_manager: CHAR_MANAGER

--v function(fkm: FKM) 
function character_manager.init(fkm)
    local self = {}
    setmetatable(self, {
        __index = character_manager
    }) --# assume self: CHAR_MANAGER
    self._fkm = fkm
    self._characterData = {} --:map<CA_CQI, CHAR_DETAIL>
    self._estateTypesTitlePoints = {} --:map<string, number>
    self._titleLevels = {} --:map<string, number>
    self._subcultureTitleKeys = {} --:map<string, string>
    self._leaderTitleOverrideFactions =  {} --:map<string, boolean>
    _G.charm = self
end

--v function(self: CHAR_MANAGER) --> FKM
function character_manager.fkm(self)
    return self._fkm
end

--v function(self: CHAR_MANAGER, estate_type: string, points:number)
function character_manager.register_estate_type(self, estate_type, points)
    self._estateTypesTitlePoints[estate_type] = points
end

--v function(self: CHAR_MANAGER, estate_type: string) --> number
function character_manager.get_title_points_for_estate_type(self, estate_type)
    if self._estateTypesTitlePoints[estate_type] == nil then
        return 0
    end
    return self._estateTypesTitlePoints[estate_type]
end

--v function(self: CHAR_MANAGER, subculture: string, title_key: string)
function character_manager.set_title_key_for_sc(self, subculture, title_key)
    self._subcultureTitleKeys[subculture] = title_key
end

--v function(self: CHAR_MANAGER, subculture: string) --> string
function character_manager.get_title_key_for_sc(self, subculture)
    return self._subcultureTitleKeys[subculture] 
end

--v function(self: CHAR_MANAGER, subculture: string) --> boolean
function character_manager.sc_has_titles(self, subculture)
    return not not self._subcultureTitleKeys[subculture] 
end



local char_detail = require("shieldwall/lib/character_features/CharacterDetail")


--v function(self: CHAR_MANAGER, cqi: CA_CQI) --> boolean
function character_manager.has_character(self, cqi)
    return not not self._characterData[cqi]
end

--v function(self: CHAR_MANAGER, cqi: CA_CQI) --> CHAR_DETAIL
function character_manager.get_character(self, cqi)
    if not not self._characterData[cqi] then
        return self._characterData[cqi]
    else
        self._characterData[cqi] = char_detail.new(self, cqi)
        return self._characterData[cqi]
    end
end

--v function(self: CHAR_MANAGER, sv_table: CHAR_SAVE)
function character_manager.load_character(self, sv_table)
    local cqi = tonumber(sv_table._cqi)
    --# assume cqi: CA_CQI
    local loaded_char = char_detail.new(self, cqi)
    if self:has_character(cqi) then
        loaded_char = self:get_character(cqi)
    end
    loaded_char._currentTitle = sv_table._currentTitle or "no_title"
    loaded_char._homeEstate = sv_table._homeEstate or "no_estate"
    self._characterData[cqi] = loaded_char
end

    

--v function(self: CHAR_MANAGER, cqi: CA_CQI)
function character_manager.update_title_for_character(self, cqi)
    if not dev.is_game_created() then
        return
    end
    if dev.get_character(cqi):is_faction_leader() then
        local character = self:get_character(cqi)
        local faction = dev.get_character(cqi):faction()
        dev.log("Updating title for a faction leader from ["..faction:name().."]")
        if self:fkm():is_faction_vassal(faction:name()) then
            character:update_title(CONST.charm_leader_title_prefix.."vassal")
            return
        end
        if (self._leaderTitleOverrideFactions[faction:name()] == true) and self:fkm():is_faction_kingdom(faction:name()) then
            local level = self:fkm()._kingdoms[faction:name()]:kingdom_level()
            character:update_title(CONST.charm_leader_title_prefix.. faction:name().. "_".. tostring(level))
            return
        else
            character:update_title(CONST.charm_leader_title_prefix.."king")
            return
        end
    end
    local points = 0 --:number
    for region, estate in pairs(self:get_character(cqi):estates()) do
        points = points + self:get_title_points_for_estate_type(estate:type())
    end
    local subculture = dev.get_character(cqi):faction():subculture()
    local character = self:get_character(cqi)
    local level --:number
    local home_estate = character:get_home_estate()
    if points > CONST.charm_great_noble_threshold then
        level = 2
    elseif points > CONST.charm_middle_noble_threshold then
        level = 1

    elseif points > CONST.charm_minor_noble_threshold then
        level = 0
    end
    if level == nil or home_estate == "no_estate" then
        character:update_title("no_title")
    else
        local title = CONST.charm_title_prefix .. home_estate .. "_" .. self:get_title_key_for_sc(subculture) .. "_" .. tostring(level)
        character:update_title(title)
    end
end

character_manager.init(_G.fkm)