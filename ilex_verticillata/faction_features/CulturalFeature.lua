--# type global DECREE_DETAIL = { name: string,
--# event: string, duration: number, gold_cost: number, currency: string, currency_cost: number, cooldown: number, locked: boolean
--# }






local cultural_feature = {} --# assume cultural_feature: CULT_FEATURE
--v method(text: any)
function cultural_feature:log(text)
    dev.log(tostring(text), "CLT")
end




--v function(faction_detail: FACTION_DETAIL) --> CULT_FEATURE
function cultural_feature.new(faction_detail)
    local self = {}
    setmetatable(self, {
        __index = cultural_feature
    }) --# assume self: CULT_FEATURE

    self._factionDetail = faction_detail

    self._cultCurrencyValue = 3
    self._cultCurrencyMax = 6
    self._cultCurrencyMin = 0

    self._warDecrees = {} --:map<string, DECREE_DETAIL>
    self._civilDecrees = {} --:map<string, DECREE_DETAIL>

    return self
end


--v function(self: CULT_FEATURE, decree: DECREE_DETAIL, is_civil: boolean)
function cultural_feature.add_decree(self, decree, is_civil)
    if is_civil then
        self._civilDecrees[decree.name] = decree
    else
        self._warDecrees[decree.name] = decree
    end
end

--v function(self: CULT_FEATURE, name: string) --> DECREE_DETAIL
function cultural_feature.get_decree(self, name)
    if self._warDecrees[name] == nil then
        if self._civilDecrees[name] == nil then
        self:log("Asked for decree ["..name.."] on faction ["..self._factionDetail._name.."] but could not find any decree with this name!")
            return nil
        else
            return self._civilDecrees[name]
        end
    else
        return self._warDecrees[name]
    end
end

--v function(faction: FACTION_DETAIL, savetable: table) --> CULT_FEATURE
function cultural_feature.load(faction, savetable)
    local self = cultural_feature.new(faction)
    dev.load(savetable, self, "_warDecrees", "_civilDecrees", "_cultCurrencyValue")
    return self
end

--v function(self: CULT_FEATURE) --> table
function cultural_feature.save(self)
    return dev.save(self, "_warDecrees", "_civilDecrees", "_cultCurrencyValue")
end


return {
    new = cultural_feature.new
}