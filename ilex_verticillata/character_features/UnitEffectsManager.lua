--this object handles force effects, particularly those added by having or not having certain units.
local unit_effects_manager = {} --# assume unit_effects_manager: UNIT_EFFECTS_MANAGER
--v method(text: any)
function unit_effects_manager:log(text)
    dev.log(tostring(text), "UEM")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
unit_effects_manager._instances = {} --:map<string, UNIT_EFFECTS_MANAGER>
--v function(cqi: CA_CQI | string) --> boolean
function unit_effects_manager.has_force(cqi) 
    if is_number(cqi) then
        cqi = tostring(cqi)
    end
    --# assume cqi: string
    return not not unit_effects_manager._instances[cqi]
end

--v function(cqi_as_string: string, object: UNIT_EFFECTS_MANAGER)
local function register_to_prototype(cqi_as_string, object)
    unit_effects_manager._instances[cqi_as_string] = object
end

-------------------------
-----STATIC CONTENT------
-------------------------
unit_effects_manager._unitEffects = {} --:map<string, string>
--v function(unit: string, bundle: string)
function unit_effects_manager.add_effect_to_unit(unit, bundle)
    unit_effects_manager._unitEffects[unit] = bundle
end

unit_effects_manager._unitEffectConditions = {} --:map<string, (function(CA_CHAR) --> (boolean, string))>
--v function(unit: string, condition: (function(CA_CHAR) --> (boolean, string)))
function unit_effects_manager.add_conditional_effect_to_unit(unit, condition)
    unit_effects_manager._unitEffectConditions[unit] = condition
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------


--v function(character_detail: CHARACTER_DETAIL, force_cqi: string) --> UNIT_EFFECTS_MANAGER
function unit_effects_manager.new(character_detail, force_cqi) 
    local self = {}
    setmetatable(self, {
        __index = unit_effects_manager
    }) --# assume self: UNIT_EFFECTS_MANAGER

    --access to prototype
    --v method() --> UNIT_EFFECTS_MANAGER
    function self:prototype()
        return unit_effects_manager
    end

    self._character = character_detail
    local cqi = tonumber(force_cqi)
    --# assume cqi: CA_CQI
    self._cqi = cqi
    self._cqiAsString = force_cqi 
    
    self._activeEffects = {} --:map<string, boolean>
    if unit_effects_manager.has_force(self._cqi) then
        self._activeEffects = unit_effects_manager._instances[self._cqiAsString]._activeEffects
    end

    register_to_prototype(self._cqiAsString, self)
    return self
end


------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------


--v function(self: UNIT_EFFECTS_MANAGER) --> table
function unit_effects_manager.save(self)
    local svtable = dev.save(self, "_activeEffects")
    return svtable
end

--v function(character_detail: CHARACTER_DETAIL, force_cqi: string, sv_tab: table) --> UNIT_EFFECTS_MANAGER
function unit_effects_manager.load(character_detail, force_cqi, sv_tab)
    local self = unit_effects_manager.new(character_detail, force_cqi)
    dev.load(sv_tab, self, "_activeEffects")
    return self
end

-------------------
------EFFECTS------
-------------------

--v function(self: UNIT_EFFECTS_MANAGER, unit: string) --> boolean
function unit_effects_manager.has_effect_for_unit(self, unit)
    return not not self._unitEffects[unit]
end

--v function(self: UNIT_EFFECTS_MANAGER, unit: string) --> string
function unit_effects_manager.get_effect_for_unit(self, unit)
    return self._unitEffects[unit]
end

--v function(self: UNIT_EFFECTS_MANAGER, effect: string)
function unit_effects_manager.add_effect_to_force(self, effect)
    self._activeEffects[effect] = true
    cm:apply_effect_bundle_to_force(effect, self._cqi, 0)
end

--v function(self: UNIT_EFFECTS_MANAGER, effect: string)
function unit_effects_manager.remove_effect_from_force(self, effect)
    if not self._activeEffects[effect] then
        return
    end
    self._activeEffects[effect] = false
    cm:remove_effect_bundle_from_force(effect, self._cqi)
end

--v function(self: UNIT_EFFECTS_MANAGER, effect: string) --> boolean
function unit_effects_manager.is_effect_applied(self, effect)
    return not not self._activeEffects[effect]
end

-----------------------------------
----STATE CHANGING FUNCTIONS-------
-----------------------------------

--v function(self: UNIT_EFFECTS_MANAGER)
function unit_effects_manager.evaluate_force(self)
    local added_effects = {} --:map<string, boolean>
    local force = dev.get_force(self._cqi)
    if force:unit_list():is_empty() then
        return
    end
    local unit_list = force:unit_list()
    local cqi = force:command_queue_index()
    for unit, effect in pairs(self._unitEffects) do
        if unit_list:has_unit(unit) then
            self:add_effect_to_force(effect)
            added_effects[effect] = true
        elseif self:is_effect_applied(effect) and (not added_effects[effect]) then
            self:remove_effect_from_force(effect)
        end
    end
    if force:has_general() then
        for unit, conditional in pairs(self._unitEffectConditions) do
            local apply,bundle  = conditional(force:general_character())
            if apply then
                self:add_effect_to_force(bundle)
            else
                self:remove_effect_from_force(bundle)
            end
        end
    end
end

return {
    --creation
    new = unit_effects_manager.new,
    load = unit_effects_manager.load,
    --Content API
    add_effect_to_unit = unit_effects_manager.add_effect_to_unit,
    add_conditional_effect_to_unit = unit_effects_manager.add_conditional_effect_to_unit
}