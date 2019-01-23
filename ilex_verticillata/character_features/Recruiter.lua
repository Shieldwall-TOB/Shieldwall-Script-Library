local recruiter = {} --# assume recruiter: RECRUITER
--v method(text: any)
function recruiter:log(text)
    dev.log(tostring(text), "REC")
end


--// Sets the population cost of a unit to create
recruiter._unitPopulationCosts = {} --:map<string, number>
recruiter._unitPopulationCastes = {} --:map<string, POP_CASTE>
--v function(unit: string, caste: POP_CASTE, size: number)
function recruiter.set_population_cost_for_unit(unit, caste, size)
    recruiter._unitPopulationCosts[unit] = size
    recruiter._unitPopulationCastes[unit] = caste
end

--v function(char_detail: CHARACTER_DETAIL) --> RECRUITER
function recruiter.new(char_detail)
    local self = {}
    setmetatable(self, {
        __index = recruiter
    })--# assume self: RECRUITER

    self._characterDetail = char_detail
    self._queuedUnits = {} --:map<string, number>
    self._currentRestrictions = {} --:map<string, boolean>

    return self
end



return {
    --Creation
    new = recruiter.new,
    --Content API
    set_population_cost_for_unit = recruiter.set_population_cost_for_unit
}