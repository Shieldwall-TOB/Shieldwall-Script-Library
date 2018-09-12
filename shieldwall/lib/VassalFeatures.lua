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
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction already has a kingdom entry, returning it.")
        return self._kingdoms[faction_key]
    end

    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction is a vassal!, deleting the vassal!")
        self._vassals[faction_key] = nil
    end

    local faction_obj = cm:model():world():faction_by_key(faction_key)
    local kingdom = fkm_kingdom.new(self, faction_key, faction_obj:is_human())
    self._kingdoms[faction_key] = kingdom

    return kingdom
end

--v function(self: FKM, faction_key: string) --> FKM_VASSAL
function faction_kingdom_manager.add_vassal(self, faction_key)
    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction already has a vassal entry, returning it.")
        return self._vassals[faction_key]
    end
    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction is a kingdom!, deleting the Kingdom!")
        self._kingdoms[faction_key] = nil
    end
    local faction_obj = cm:model():world():faction_by_key(faction_key)
    if not faction_obj:is_vassal() then
        self:log("tried to add faction ["..faction_key.."] as a vassal but they aren't anyone's vassal, aborting")
        return fkm_vassal.null_interface()
    end 
    local liege_key --:string
    for i = 0, faction_obj:factions_met():num_items() - 1 do
        local target = faction_obj:factions_met():item_at(i)
        if faction_obj:is_vassal_of(target) then
            liege_key = target:name()
            break
        end
    end
    if liege_key == nil then
        self:log("ERROR: Could not find the liege for faction ["..faction_key.."], aborting their creation as a vassal!")
        return fkm_vassal.null_interface()
    end
    local vassal = fkm_vassal.new(self, faction_key, liege_key)
    self._vassals[faction_key] = vassal
    return vassal
end








faction_kingdom_manager.init()
_G.fkm:log("Init complete")
