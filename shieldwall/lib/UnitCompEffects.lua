local unit_effects_manager = {} --# assume unit_effects_manager: UEM


--v function() --> UEM
function unit_effects_manager.init() 
    local self = {}
    setmetatable(self, {
        __index = unit_effects_manager
    }) --# assume self: UEM

    self._unitEffects = {} --:map<string, string>
    self._activeEffects = {} --:map<CA_CQI, map<string, boolean>>
    self._unitEffectConditions = {} --:map<string, (function(CA_CHAR) --> (boolean, string))>

    _G.uem = self
    return self
end

--v function(self: UEM, unit: string, bundle: string)
function unit_effects_manager.add_effect_to_unit(self, unit, bundle)
    self._unitEffects[unit] = bundle
end

--v function(self: UEM, unit: string, condition: (function(CA_CHAR) --> (boolean, string)))
function unit_effects_manager.add_conditional_effect_to_unit(self, unit, condition)
    self._unitEffectConditions[unit] = condition
end


--v function(self: UEM) --> map<string, map<string, boolean>>
function unit_effects_manager.save(self)
    local svtable = {} --:map<string, map<string, boolean>>
    for cqi, map in pairs(self._activeEffects) do
        svtable[tostring(cqi)] = map
    end
    return svtable
end

--v function(self: UEM, svtable: map<string, map<string, boolean>>)
function unit_effects_manager.load(self, svtable)
    for stringed_cqi, map in pairs(svtable) do
        cqi_as_num = tonumber(stringed_cqi)
        --# assume cqi_as_num: CA_CQI
        self._activeEffects[cqi_as_num] = map
    end
end


--v function(self: UEM, unit: string) --> boolean
function unit_effects_manager.has_effect_for_unit(self, unit)
    return not not self._unitEffects[unit]
end

--v function(self: UEM, unit: string) --> string
function unit_effects_manager.get_effect_for_unit(self, unit)
    return self._unitEffects[unit]
end

--v function(self: UEM, force: CA_CQI, effect: string)
function unit_effects_manager.add_effect_to_force(self, force, effect)
    if self._activeEffects[force] == nil then
        self._activeEffects[force] = {}
    end
    self._activeEffects[force][effect] = true
    cm:apply_effect_bundle_to_force(effect, force, 0)
end

--v function(self: UEM, force: CA_CQI, effect: string)
function unit_effects_manager.remove_effect_from_force(self, force, effect)
    if self._activeEffects[force] == nil then
        self._activeEffects[force] = {}
        return
    end
    if self._activeEffects[force][effect] == false then
        return
    end
    self._activeEffects[force][effect] = false
    cm:remove_effect_bundle_from_force(effect, force)
end

--v function(self: UEM, force: CA_CQI, effect: string) --> boolean
function unit_effects_manager.is_effect_applied(self, force, effect)
    if self._activeEffects[force] == nil then
        return false
    end
    return not not self._activeEffects[force][effect]
end


--v function(self: UEM, force: CA_FORCE)
function unit_effects_manager.evaluate_force(self, force)
    if force:unit_list():is_empty() then
        return
    end
    local unit_list = force:unit_list()
    local cqi = force:command_queue_index()
    for unit, effect in pairs(self._unitEffects) do
        if unit_list:has_unit(unit) then
            self:add_effect_to_force(cqi, effect)
        elseif self:is_effect_applied(cqi, effect) then
            self:remove_effect_from_force(cqi, effect)
        end
    end
    if force:has_general() then
        for unit, conditional in pairs(self._unitEffectConditions) do
            local apply,bundle  = conditional(force:general_character())
            if apply then
                self:add_effect_to_force(cqi, bundle)
            else
                self:remove_effect_from_force(cqi, bundle)
            end
        end
    end
end


unit_effects_manager.init()