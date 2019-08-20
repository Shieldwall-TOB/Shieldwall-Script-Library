--v function(char: CA_CHAR) --> boolean
local function check_is_char_from_viking_faction(char)
    local viking_sc = {
        vik_sub_cult_viking_gael = true,
        vik_sub_cult_anglo_viking = true
    } --:map<string, boolean>
    return not not viking_sc[char:faction():subculture()]
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_viking_faction(faction)
    local viking_sc = {
        vik_sub_cult_viking_gael = true,
        vik_sub_cult_anglo_viking = true
    } --:map<string, boolean>
    return not not viking_sc[faction:subculture()]
end



return {
    is_char_from_viking_faction = check_is_char_from_viking_faction,
    is_faction_viking_faction = check_is_faction_viking_faction
}