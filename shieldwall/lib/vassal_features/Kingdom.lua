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

    self.model = model
    self._name = faction_key
    self._isHuman = human

    return self
end





return {
    new = fkm_kingdom.new
}