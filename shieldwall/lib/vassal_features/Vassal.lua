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





return {
    new = fkm_vassal.new
}