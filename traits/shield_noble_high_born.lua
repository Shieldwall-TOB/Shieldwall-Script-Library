--SETTINGS
local NEW_CHARACTER_TRAIT_CHANCE = 15


local tm = traits_manager.new("shield_noble_high_born")

tm:add_normal_trait_trigger("CharacterComesOfAge",
function(context)
    local char = context:character()
    if char:family_member():has_father() and char:family_member():father():has_trait("shield_noble_high_born") then
        return true, char
    end
    return false, char
end)

tm:add_normal_trait_trigger("CharacterCreated",
function(context)
    local char = context:character()
    if char:age() > 20 then
        if cm:random_number(100) < NEW_CHARACTER_TRAIT_CHANCE then
            return true, char
        end
    end
    return false, char
end)

tm:set_start_pos_characters(
    "faction:vik_fact_west_seaxe,forename:2147363229"
)