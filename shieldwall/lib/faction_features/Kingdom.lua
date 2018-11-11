local fkm_kingdom = {} --# assume fkm_kingdom: FKM_KINGDOM


--v function(model: FKM, faction_key: string, human: boolean) --> FKM_KINGDOM
function fkm_kingdom.new(model, faction_key, human)
    local self = {}
    setmetatable(self, {
        __index = fkm_kingdom,
        __tostring = function()
            return faction_key
        end
    }) --# assume self: FKM_KINGDOM

    self._model = model
    self._name = faction_key
    self._isHuman = human
    if cm:get_saved_value("fkm_"..faction_key.."_kingdom_level") == nil then
        cm:set_saved_value("fkm_"..faction_key.."_kingdom_level", 0)
    end
    self._kingdomLevel = cm:get_saved_value("fkm_"..faction_key.."_kingdom_level") 
    self._estateOwners = {} --:map<CA_CQI, vector<ESTATE>>

    return self
end

--v function() --> FKM_KINGDOM
function fkm_kingdom.null_interface()
    local self = {}
    self.is_null_interface = function(self) return true end --: function(self: FKM_KINGDOM) --> boolean
    --# assume self: FKM_KINGDOM
    return self
end

--v function(self: FKM_KINGDOM, estate: ESTATE)
function fkm_kingdom.add_estate(self, estate)
    if self._estateOwners[estate._owner] == nil then
        self._estateOwners[estate._owner] = {}
    end
    table.insert(self._estateOwners[estate._owner], estate)
end

--v function (self: FKM_KINGDOM) --> boolean
function fkm_kingdom.is_null_interface(self)
    return false
end

--v function(self: FKM_KINGDOM, text: any)
function fkm_kingdom.log(self, text)
    self._model:log(text)
end

--v function(self: FKM_KINGDOM, level: number)
function fkm_kingdom.update_kingdom_level(self, level)
    cm:set_saved_value("fkm_"..self._name.."_kingdom_level", level)
    self._kingdomLevel = level
end

--v function(self: FKM_KINGDOM) --> number
function fkm_kingdom.kingdom_level(self)
    return self._kingdomLevel
end


return {
    new = fkm_kingdom.new,
    null_interface = fkm_kingdom.null_interface
}