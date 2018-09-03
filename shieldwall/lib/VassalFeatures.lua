faction_kingdom_manager = {} --# assume faction_kingdom_manager: FKM


--v function()
function faction_kingdom_manager.init()
    local self = {}
    setmetatable(self, {
        __index = faction_kingdom_manager,
        __tostring = function() return "FACTION_KINGDOM_MANAGER" end
    }) --# assume self: FKM

    self._kingdoms = {} --:map<string, FKM_KINGDOM>
    self._vassal = {} --:map<string, FKM_VASSAL>
    self._states = {} --:map<string, FKM_STATE>


    _G.fkm = self
end