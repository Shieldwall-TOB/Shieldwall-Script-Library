local tm = traits_manager.new("shield_heathen_pagan")
local NEW_CHARACTER_TRAIT_CHANCE = 10
tm:set_cross_loyalty("shield_faithful_friend_of_the_church", -2)

tm:add_normal_trait_trigger("CharacterComesOfAge",
function(context)
    local char = context:character()
    if char:family_member():has_father() and char:family_member():father():has_trait("shield_heathen_pagan") then
        return true, char
    end
    return false, char
end)

tm:add_normal_trait_trigger("CharacterCreated",
function(context)
    local char = context:character()
    if char:age() > 20 and char:is_male() and Check.check_is_char_from_viking_faction(char) then
        if cm:random_number(100) < NEW_CHARACTER_TRAIT_CHANCE then
            return true, char
        end
    end
    return false, char
end)
