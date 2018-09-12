faction_kingdom_manager = {} --# assume faction_kingdom_manager: FKM


--v function()
function faction_kingdom_manager.init()
    local self = {}
    setmetatable(self, {
        __index = faction_kingdom_manager,
        __tostring = function() return "FACTION_KINGDOM_MANAGER" end
    }) --# assume self: FKM

    self._kingdoms = {} --:map<string, FKM_KINGDOM>
    self._vassals = {} --:map<string, FKM_VASSAL>
    
    --major faction autoresolve bonus toggles
    self._influenceAutoresolve = true --:boolean

    _G.fkm = self
end

--v method(text: any)
function faction_kingdom_manager:log(text)
    MODLOG(tostring(text), "FKM")
end



local fkm_vassal = require("shieldwall/lib/vassal_features/Vassal")
local fkm_kingdom = require("shieldwall/lib/vassal_features/Kingdom")



--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_kingdom(self, faction_key)
    if self._kingdoms[faction_key] == nil then
        return false
    else
        return true
    end
end

--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_vassal(self, faction_key)
    if self._vassals[faction_key] == nil then
        return false
    else 
        return true
    end
end

--v function(self: FKM, faction_key: string) --> FKM_KINGDOM
function faction_kingdom_manager.add_kingdom(self, faction_key)

    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add kingdom ["..faction_key.."] as a kingdom but that faction already has a kingdom entry, returning it.")
        return self._kingdoms[faction_key]
    end
local faction_obj = cm:model():world():faction_by_key(faction_key)
local kingdom = fkm_kingdom.new(self, faction_key, faction_obj:is_human())


return kingdom
end



