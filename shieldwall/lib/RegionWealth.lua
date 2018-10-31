WEALTH_BUNDLE_PREFIX = "shield_wealth_bundle_"
WEALTH_BUNDLE_MIN = 0
WEALTH_BUNDLE_MAX = 3


local region_wealth_manager = {} --# assume region_wealth_manager: RWM

--v function()
function region_wealth_manager.init()
local self = {}
    setmetatable(self, {
        __index = region_wealth_manager,
        __tostring = function() return "REGION_WEALTH_MANAGER" end
    })
    --# assume self: RWM

    self._maxPoints = WEALTH_BUNDLE_MAX
    self._minPoints = WEALTH_BUNDLE_MIN
    self._currentLevels = {} --:map<string, number>
    self._levelTimers = {} --:map<string, number>

    _G.rwm = self
end

--v method(text: any)
function region_wealth_manager:log(text)
    MODLOG(tostring(text), "RWM")
end


--v function(self: RWM, region: string) --> number
function region_wealth_manager.get_region_wealth(self, region)
    if self._currentLevels[region] == nil then
        self._currentLevels[region] = 0
    end
    return self._currentLevels[region]
end

--v function(self: RWM, region: string) 
function region_wealth_manager.update_bundle(self, region)
    self:log("Updating bundles for region: ["..region.."] ")
    for i = self._minPoints, self._maxPoints do
        cm:remove_effect_bundle_from_region(WEALTH_BUNDLE_PREFIX..i, region)
    end
    cm:apply_effect_bundle_to_region(WEALTH_BUNDLE_PREFIX..self:get_region_wealth(region), region, 0)
end

--v function(self: RWM, region: string, value: number)
function region_wealth_manager.set_region_wealth(self, region, value)
    self._currentLevels[region] = value
    self._levelTimers[region] = 2+((value-1)*4)
    self:update_bundle(region)
end

--v function(self: RWM, region: string)
function region_wealth_manager.process_end_turn(self, region)
    if self._levelTimers[region] == nil then
        self._levelTimers[region] = 0
        self._currentLevels[region] = 0
        if cm:model():world():region_manager():region_by_key(region):owning_faction():is_human() then
            local fact_list = cm:model():world():region_manager():region_by_key(region):owning_faction():factions_at_war_with()
            for i = 0, fact_list:num_items() - 1 do
                local char_list = fact_list:item_at(i):character_list()
                for j = 0, char_list:num_items() - 1 do
                    local char = char_list:item_at(j)
                    if char:region():name() == region then
                        self._currentLevels[region] = 1
                    end
                end
            end
        end
        self:update_bundle(region)
        return
    end
    if self._levelTimers[region] > 0 then
        self._levelTimers[region] = self._levelTimers[region] - 1
        local timer = self._levelTimers[region]
        local level = self:get_region_wealth(region)
        if timer <= ((level-1)*4) then
            self._currentLevels[region] = self._currentLevels[region] - 1 
            self:update_bundle(region)
        end
    end
end







region_wealth_manager.init()
