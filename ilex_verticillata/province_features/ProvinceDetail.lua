--this stores information for a faction's province, including population numbers and effects.
--these are stored by faction and do not link to characters.
local province_detail = {} --# assume province_detail: PROVINCE_DETAIL
--v method(text: any)
function province_detail:log(text)
    dev.log(tostring(text), "PRV")
end


-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------
--v function(faction_detail: FACTION_DETAIL, key: string) --> PROVINCE_DETAIL
function province_detail.new(faction_detail, key)
    local self = {}
    setmetatable(self, {
        __index = province_detail
    }) --# assume self: PROVINCE_DETAIL

    --v method() --> PROVINCE_DETAIL
    function self:prototype()
        return province_detail
    end

    self._key = key
    self._factionDetail = faction_detail

    return self
end

---------------------------
------NIL SAFE QUERIES-----
---------------------------


----------------------------
-----SUBCLASS LIBARIES------
----------------------------
local region_detail = require("ilex_verticillata/province_features/RegionDetail")









return {
    --Creation
    new = province_detail.new
    --Content API
}