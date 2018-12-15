local estate_detail =  {} --# assume estate_detail: ESTATE_DETAIL
--v method(text: any) 
function estate_detail:log(text)
    dev.log(tostring(text), "EST")
end
-------------------------
----INSTANCE REGISTER----
-------------------------
estate_detail._instances = {} --:map<string, map<string, ESTATE_DETAIL>>
--v function(region_key: string, chain_key: string) --> boolean
function estate_detail.has_estate_for_chain_in_region(region_key, chain_key) 
    if estate_detail._instances[region_key] == nil then
        estate_detail._instances[region_key] = {}
    end
    return not not estate_detail._instances[region_key][chain_key]
end

--v function(region_key: string, chain_key: string, object: ESTATE_DETAIL)
local function register_to_prototype(region_key, chain_key, object)
    if estate_detail._instances[region_key] == nil then
        estate_detail._instances[region_key] = {}
    end
    estate_detail._instances[region_key][chain_key] = object
end
-------------------------
-----STATIC CONTENT------
-------------------------
estate_detail._estateBuildingChains = {} --:map<string, string>
estate_detail._estateBuildingExpTriggers = {} --:map<string, string>
estate_detail._estateBuildingExpQuantities = {} --:map<string,number>
estate_detail._estateChainEstateTypes = {} --:map<string, string>
--v function(level_key: string, chain_key: string, exp_trigger: string, exp_quantity: number)
function estate_detail.add_estate_building_level(level_key, chain_key, exp_trigger, exp_quantity)
    estate_detail._estateBuildingChains[level_key] = chain_key
    estate_detail._estateBuildingExpTriggers[level_key] = exp_trigger
    estate_detail._estateBuildingExpQuantities[level_key] = exp_quantity
end

--v function(chain_key: string, estate_type_key: string)
function estate_detail.add_estate_chain_type(chain_key, estate_type_key)
    estate_detail._estateChainEstateTypes[chain_key] = estate_type_key
end

--v function(level_key: string) --> string
function estate_detail.estate_chain_for_level(level_key)
    return estate_detail._estateBuildingChains[level_key]
end

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------


--v function(region_detail: REGION_DETAIL, building: string) --> ESTATE_DETAIL
function estate_detail.new(region_detail, building)
    local self = {}
    setmetatable(self, {
        __index = estate_detail,
        __tostring = function() return "SHIELDWALL_REGION_ESTATE_DETAIL" end
    })--# assume self: ESTATE_DETAIL

    --v method() --> REGION_DETAIL
    function self:prototype()
        return region_detail
    end

    self._owningCharacter = nil --: CHARACTER_DETAIL
    self._regionDetail = REGION_DETAIL
    self._regionName = region_detail:name()
    self._building = building
    self._chain = estate_detail._estateBuildingChains[building]
    self._estateType = estate_detail._estateChainEstateTypes[self._chain]
    self._isRoyal = true



    register_to_prototype(self._regionName, self._chain, self)
    return self
end


--v function(self: ESTATE_DETAIL) --> string
function estate_detail.building(self) 
    return self._building
end


--v function(self: ESTATE_DETAIL) --> string
function estate_detail.chain(self) 
    return self._chain
end

--v function(self: ESTATE_DETAIL) --> string
function estate_detail.estate_type(self)
    return self._estateType
end


--v function(self: ESTATE_DETAIL, building_level: string) 
function estate_detail.upgrade_building(self, building_level)
    self._building = building_level
end

--v function(self: ESTATE_DETAIL, owning_character: CHARACTER_DETAIL)
function estate_detail.appoint_owner(self, owning_character)
    self._owningCharacter = owning_character
end



return {
    --Creation
    new = estate_detail.new,
    --Content API
    add_estate_building_level = estate_detail.add_estate_building_level,
    estate_chain_for_level = estate_detail.estate_chain_for_level,
    add_estate_chain_type = estate_detail.add_estate_chain_type
}