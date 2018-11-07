local fkm_vassal = {} --# assume fkm_vassal: FKM_VASSAL

--v function(model: FKM, faction_key: string, liege: string) --> FKM_VASSAL
function fkm_vassal.new(model, faction_key, liege)
    local self = {}
    setmetatable(self, {
        __index = fkm_vassal,
        __tostring = function() 
            return faction_key
        end
    }) --# assume self: FKM_VASSAL

    self._model = model
    self._name = faction_key
    self._liege = liege


    return self
end

--v function() --> FKM_VASSAL
function fkm_vassal.null_interface()
    local self = {}
    self.is_null_interface = function(self) return true end --: function(self: FKM_VASSAL) --> boolean
    --# assume self: FKM_VASSAL
    return self
end

--v function (self: FKM_VASSAL) --> boolean
function fkm_vassal.is_null_interface(self)
    return false
end

--v function(self: FKM_VASSAL, text: any)
function fkm_vassal.log(self, text)
    self._model:log(text)
end
    




return {
    null_interface = fkm_vassal.null_interface,
    new = fkm_vassal.new
}