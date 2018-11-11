
local char_detail = {} --# assume char_detail: CHAR_DETAIL

--v function(model: CHAR_MANAGER, cqi: CA_CQI) --> CHAR_DETAIL
function char_detail.new(model, cqi)
    local self = {} 
    setmetatable(self, {
        __index = char_detail
    })--# assume self: CHAR_DETAIL
    self._model = model
    self._cqi = cqi

    self._currentTitle = "no_title" --:string
    self._estates = {} --:map<string, ESTATE>
    self._homeEstate = "no_estate" --:string


    return self
end

--v function(self: CHAR_DETAIL, estate: ESTATE)
function char_detail.add_estate(self, estate)
    self._estates[estate._region] = estate
end

--v function(self: CHAR_DETAIL, estate: ESTATE)
function char_detail.remove_estate(self, estate)
    self._estates[estate._region] = nil
end

--v function(self: CHAR_DETAIL) --> map<string, ESTATE>
function char_detail.estates(self)
    return self._estates
end





--v function(self: CHAR_DETAIL) 
function char_detail.calculate_home_estate(self)
    local grand_estates = {} --:vector<ESTATE>
    local noble_estates = {} --:vector<ESTATE>
    local minor_estates = {} --:vector<ESTATE>
    local has_grand = false --:boolean
    local has_noble = false --:boolean
    local has_minor = false --:boolean

    for region, estate in pairs(self:estates()) do
        if estate:type() == CONST.grand_estate_type then
            table.insert(grand_estates, estate)
            has_grand = true
        elseif estate:type() == CONST.noble_estate_type then
            table.insert(noble_estates, estate)
            has_noble = true
        elseif estate:type() == CONST.minor_estate_type then
            table.insert(minor_estates, estate)
            has_minor = true
        end
    end

    if has_grand then
        --first, check if any of the grand estates are the current title estate
        if not not self._homeEstate then
            for i = 1, #grand_estates do
                if grand_estates[i]._region == self._homeEstate then
                    return --the home estate can remain the same!
                end
            end
        end
        --otherwise, pick one!
        self._homeEstate = grand_estates[cm:random_number(#grand_estates)]._region
    end

    if has_noble then
        if not not self._homeEstate then
            for i = 1, #noble_estates do
                if noble_estates[i]._region == self._homeEstate then
                    return --the home estate can remain the same!
                end
            end
        end
        --otherwise, pick one!
        self._homeEstate = noble_estates[cm:random_number(#noble_estates)]._region
    end

    if has_minor then
        if not not self._homeEstate then
            for i = 1, #minor_estates do
                if minor_estates[i]._region == self._homeEstate then
                    return --the home estate can remain the same!
                end
            end
        end
        --otherwise, pick one!
        self._homeEstate = minor_estates[cm:random_number(#minor_estates)]._region
    end
end


--v function(self: CHAR_DETAIL) --> string
function char_detail.get_home_estate(self)
    if self._homeEstate == "no_estate" then
        self:calculate_home_estate()
    end
    return self._homeEstate
end


--v function(self: CHAR_DETAIL) --> string
function char_detail.current_title(self)
    return self._currentTitle
end

--v function(self: CHAR_DETAIL, new_title: string)
function char_detail.update_title(self, new_title)
    local old_title = self:current_title()
    if old_title ~= "no_title" then
        cm:force_remove_trait(dev.lookup(self._cqi), old_title)
    end
    if new_title ~= "no_title" then
        cm:force_add_trait(dev.lookup(self._cqi), new_title, true)
    end
    if new_title ~= old_title then
        dev.log("Character with cqi ["..tostring(self._cqi).."] changed title from ["..old_title.."] to ["..new_title.."]", "CHM")
    end
    self._currentTitle = new_title
end





--v function(self: CHAR_DETAIL) --> CHAR_SAVE
function char_detail.save(self)
    local sv_table = {}
    sv_table._currentTitle = self._currentTitle
    sv_table._homeEstate = self._homeEstate
    sv_table._cqi = tostring(self._cqi)
    return sv_table
end



return {
    new = char_detail.new
}