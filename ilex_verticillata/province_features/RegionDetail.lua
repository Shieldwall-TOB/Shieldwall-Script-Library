local region_detail = {} --# assume region_detail: REGION_DETAIL
--v method(text: any) 
function region_detail:log(text)
    dev.log(tostring(text), "RGN")
end

-------------------------
-----STATIC CONTENT------
-------------------------

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(region_key: string) --> REGION_DETAIL
function region_detail.new(region_key)
    local self = {} 
    setmetatable(self, {
        __index = region_detail
    })
    --# assume self: REGION_DETAIL
    --v method() --> REGION_DETAIL
    function self:prototype()
        return region_detail
    end

    return self
end

------------------------------------
----SAVING AND LOADING FUNCTIONS----
------------------------------------

return {
    --creation
    region_detail.new
}