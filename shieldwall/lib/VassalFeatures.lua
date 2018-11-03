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
    self._factionFoodStorage = {} --:map<string, number>
    
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
    self:log("added the faction ["..faction_key.."] as a kingdom! ")
    return kingdom
end

--v function(self: FKM, faction_key: string, known_liege: string?) --> FKM_VASSAL
function faction_kingdom_manager.add_vassal(self, faction_key, known_liege)
    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction already has a vassal entry, returning it.")
        return self._vassals[faction_key]
    end
    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction is a kingdom!, deleting the Kingdom!")
        self._kingdoms[faction_key] = nil
    end
    local faction_obj = cm:model():world():faction_by_key(faction_key)
    
    local liege_key --:string
    if not not known_liege then
        --# assume known_liege: string
        liege_key = known_liege
    else
        local list = cm:model():world():faction_list()
        for i = 0, list:num_items() - 1 do
            local target = list:item_at(i)
            if faction_obj:is_vassal_of(target) then
                liege_key = target:name()
                break
            end
        end
    end
    if liege_key == nil then
        self:log("ERROR: Could not find the liege for faction ["..faction_key.."], aborting their creation as a vassal!")
        return fkm_vassal.null_interface()
    end
    local vassal = fkm_vassal.new(self, faction_key, liege_key)
    self._vassals[faction_key] = vassal
    self:log("Added faction ["..faction_key.."] as a vassal with liege ["..liege_key.."]")
    return vassal
end

--v function(self: FKM, vassal: string)
function faction_kingdom_manager.remove_vassal(self, vassal)
    if not self:is_faction_vassal(vassal) then
        self:log("the faction ["..vassal.."] is being called for removal from the vassals list, they already is not a vassal!")
        return 
    end
    self:log("removing the faction ["..vassal.."] from the vassal list!")
    self._vassals[vassal] = nil
end

--v function(self: FKM, faction: string) --> number
function faction_kingdom_manager.get_food_in_storage_for_faction(self, faction)
    if self._factionFoodStorage[faction] == nil then
        self._factionFoodStorage[faction] = 0
    end
    return self._factionFoodStorage[faction]
end

--v function(self: FKM, faction: string, quantity: number)
function faction_kingdom_manager.mod_food_storage(self, faction, quantity)
    local old_val = self:get_food_in_storage_for_faction(faction)
    local new_val = old_val + quantity
    if new_val > CONST.food_storage_cap then
        new_val = CONST.food_storage_cap
    elseif new_val < 0 then
        new_val = 0
    end
    cm:remove_effect_bundle(CONST.food_storage_bundle..(tostring(old_val)), faction)
    self._factionFoodStorage[faction] = new_val
    cm:apply_effect_bundle(CONST.food_storage_bundle..(tostring(new_val)), faction, 0)
end




faction_kingdom_manager.init()
_G.fkm:log("Init complete")
