-- character detail object
local character_detail = {} --# assume character_detail: CHARACTER_DETAIL
--v method(text: any)
function character_detail:log(text)
    dev.log(tostring(text), "CHA")
end

-------------------------
-----STATIC CONTENT------
-------------------------

character_detail._subcultureTitleKeys = {} --:map<string, string>
--v function(subculture: string, title_key: string)
function character_detail.set_title_key_for_sc(subculture, title_key)
    character_detail._subcultureTitleKeys[subculture] = title_key
end

--v function(subculture: string) --> string
function character_detail.get_title_key_for_sc(subculture)
    return character_detail._subcultureTitleKeys[subculture] 
end

--v function(subculture: string) --> boolean
function character_detail.sc_has_titles(subculture)
    return not not character_detail._subcultureTitleKeys[subculture] 
end

character_detail._leaderTitleOverrideFactions = {} --:map<string, boolean>
--v function(faction_key: string)
function character_detail.add_faction_leader_title_override(faction_key)
    character_detail._leaderTitleOverrideFactions[faction_key] = true
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(faction_detail: FACTION_DETAIL, cqi: string) --> CHARACTER_DETAIL
function character_detail.new(faction_detail, cqi)
    local self = {}
    setmetatable(self, {
        __index = character_detail
    }) --# assume self: CHARACTER_DETAIL
    self._cqi = cqi --:string
    self._factionDetail = faction_detail
    self._friendshipLevel = 2
    self._title = "no_title"
    self._homeEstate = "no_estate" --:string!
    self._titlePoints = 0 --:number
    self._estates = {} --:map<string, number>
    self._numEstates = 0 --:number
    self._forceEffectsManager = nil --:UNIT_EFFECTS_MANAGER
    self._recruiterCharacter = nil --:RECRUITER
    return self
end

--------------------------
------GENERIC METHODS-----
--------------------------
--v function(self: CHARACTER_DETAIL) --> CA_CQI
function character_detail.cqi(self)
    local cqi = tonumber(self._cqi) --# assume cqi: CA_CQI
    return cqi
end

--v function(self: CHARACTER_DETAIL) --> FACTION_DETAIL
function character_detail.faction_detail(self)
    return self._factionDetail
end

--------------------------------
-----UNIT EFFECT SUBOBJECTS-----
--------------------------------

unit_effects_manager = require("petty_kingdoms/character_features/UnitEffectsManager")
_G.uem = unit_effects_manager
--v function(self: CHARACTER_DETAIL) --> boolean
function character_detail.has_unit_effects_manager(self)
    return not not self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL) --> UNIT_EFFECTS_MANAGER
function character_detail.get_unit_effects_manager(self)
    if self._forceEffectsManager == nil then 
        return nil
    end
    return self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL, force_cqi: string, savetable: table) --> UNIT_EFFECTS_MANAGER
function character_detail.load_unit_effects_manager(self, force_cqi, savetable)
    self._forceEffectsManager = unit_effects_manager.load(self, force_cqi, savetable)
    return self._forceEffectsManager
end

--v function(self: CHARACTER_DETAIL) --> UNIT_EFFECTS_MANAGER
function character_detail.create_unit_effects_manager(self)
    local character_obj = dev.get_character(self:cqi())
    if (not character_obj) or (not character_obj:has_military_force()) then
        return nil
    end
    local force_cqi = character_obj:military_force():command_queue_index()
    self._forceEffectsManager = unit_effects_manager.new(self, tostring(force_cqi))
    return  self._forceEffectsManager
end

-------------------------------
-------ESTATE SUBOBJECTS-------
-------------------------------

--v function(self: CHARACTER_DETAIL) --> number
function character_detail.num_estates(self)
    return self._numEstates
end


--v function(self: CHARACTER_DETAIL) --> map<string, number>
function character_detail.estates(self) 
    return self._estates 
end

--v function(self: CHARACTER_DETAIL) --> boolean
function character_detail.landless(self)
    return (self._numEstates == 0)
end

--v function(self: CHARACTER_DETAIL, estate_type: string, region_key: string?)
function character_detail.add_estate(self, estate_type, region_key)
    self._estates[estate_type] = self._estates[estate_type] + 1
    self._numEstates = self._numEstates + 1
    if region_key and self._homeEstate == "no_estate" then
        --# assume region_key: string!
        self._homeEstate = region_key
    end
end



--v function(self: CHARACTER_DETAIL, estate_type: string, region_key: string?)
function character_detail.remove_estate(self, estate_type, region_key)
    self._estates[estate_type] = self._estates[estate_type] - 1
    self._numEstates = self._numEstates - 1
    if region_key == self._homeEstate then
        self._homeEstate = "no_estate"
    end
end

--v function(self: CHARACTER_DETAIL)
function character_detail.check_start_pos_estates(self)
    --do nothing
end

----------------------------
-----TITLES AND ESTATES-----
----------------------------

--v function(self: CHARACTER_DETAIL)
function character_detail.title_for_faction_leader(self)
    local level = self._factionDetail:kingdom_level()
    local character = dev.get_faction(self:faction_detail():name()):faction_leader()
    local title --:string
    self:log("Updating title for character ["..self._cqi.."] who is a king")
    if self:faction_detail():is_faction_vassal() then
        title = CONST.charm_leader_title_prefix.."vassal" 
    end
    if (character_detail._leaderTitleOverrideFactions[self:faction_detail():name()] == true) then
        title = CONST.charm_leader_title_prefix.. self:faction_detail():name().. "_".. tostring(level)
        
    else
        title = CONST.charm_leader_title_prefix.."king"
    end
    if title then
        cm:force_remove_trait(dev.lookup(self:cqi()), self._title)
        cm:force_add_trait(dev.lookup(self:cqi()), title, true)
        self._title = title
    end
end

--v function(self: CHARACTER_DETAIL, region: string)
function character_detail.set_home_estate(self, region)
    self._homeEstate = region
end

--v function(self: CHARACTER_DETAIL)
function character_detail.update_title(self)
    local character = dev.get_character(self:cqi())
    if character == nil then
        self:log("character detail ["..self._cqi.."] points to a nill faction leader!")
        return
    end
    if character:is_heir() or character:is_faction_leader() then
        self:title_for_faction_leader()
        return
    end
    --TODO add title points to the character, incrementing their title.
end




------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

--v function(self: CHARACTER_DETAIL) --> table
function character_detail.save(self)
    local sv_tab = dev.save(self, "_homeEstate", "_title")
    return sv_tab
end

--v function(faction_detail: FACTION_DETAIL, cqi: string, sv_tab: table) --> CHARACTER_DETAIL
function character_detail.load(faction_detail, cqi, sv_tab)
    local self = character_detail.new(faction_detail, cqi)
    dev.load(sv_tab, self, "_homeEstate", "_title")
    return self
end
    






return {
    --Creation
    new = character_detail.new,
    load = character_detail.load,
    --Content API
    set_title_key_for_sc = character_detail.set_title_key_for_sc,
    add_faction_leader_title_override = character_detail.add_faction_leader_title_override
}