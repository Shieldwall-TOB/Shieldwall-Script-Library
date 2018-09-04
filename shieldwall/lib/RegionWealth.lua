WEALTH_BUNDLE_PREFIX = "STRING"
WEALTH_BUNDLE_MIN = 0
WEALTH_BUNDLE_MAX = 7
WEALTH_POINTS_PER_LEVEL = 50

local region_wealth_manager = {} --# assume region_wealth_manager: RWM

--v function()
function region_wealth_manager.init()
local self = {}
    setmetatable(self, {
        __index = region_wealth_manager,
        __tostring = function() return "REGION_WEALTH_MANAGER" end
    })
    --# assume self: RWM

    self._regionsToWealthPoints = {} --:map<string, number>
    self._maxPoints = WEALTH_BUNDLE_MAX*WEALTH_POINTS_PER_LEVEL
    self._minPoints = WEALTH_BUNDLE_MIN*WEALTH_POINTS_PER_LEVEL
    self._currentLevels = {} --:map<string, number>
    self._buildingWealthValues = {} --:map<string, number>

    _G.rwm = self
end


--v function(self: RWM, building: string) --> number
function region_wealth_manager.get_wealth_value_for_building(self, building)
    if self._buildingWealthValues[building] == nil then
        return 0
    end
    return self._buildingWealthValues[building]
end

--v function(self: RWM, region: string) --> number
function region_wealth_manager.get_region_wealth(self, region)
    if self._regionsToWealthPoints[region] == nil then
        self._regionsToWealthPoints[region] = 0
    end
    return self._regionsToWealthPoints[region]
end











