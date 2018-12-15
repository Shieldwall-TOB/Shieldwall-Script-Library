-- The Pety Kingdoms Manager is a suite of campaign features designed for shieldwall. 
-- It is the script side data tracking archetecture behind all campaign features.
local petty_kingdoms_manager = {} --# assume petty_kingdoms_manager: PKM
--v method(text: any)
function petty_kingdoms_manager:log(text)
    dev.log(tostring(text), "PKM")
end


-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function()
function petty_kingdoms_manager.init()
    local self = {}
    setmetatable(self, {
        __index = petty_kingdoms_manager,
        __type = function() return "PETTY_KINGDOMS_MANAGER" end
    }) --# assume self: PKM

    --v method() --> PKM
    function self:prototype()
        return petty_kingdoms_manager
    end

    self._lastSeason = -1
    self._factions = {} --:map<string, FACTION_DETAIL>
    self._regions = {}  --:map<string, REGION_DETAIL>
    self._selectedProvince = nil
    self._selectedCharacter = nil
    self._selectedRegion = nil

    _G.pkm = self

end

----------------------------
-----SUBCLASS LIBARIES------
----------------------------
region_detail = require("ilex_verticillata/province_features/RegionDetail")
faction_detail = require("ilex_verticillata/faction_features/FactionDetail")



petty_kingdoms_manager.init()