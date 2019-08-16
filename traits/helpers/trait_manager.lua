--this object helps handle the implementation of a given trait.
--# assume global class TRAIT_MANAGER
local trait_manager = {} --# assume trait_manager: TRAIT_MANAGER
--v function(trait_key: string) --> TRAIT_MANAGER
function trait_manager.new(trait_key)
    local self = {}
    setmetatable(self, {
        __index = trait_manager
    }) --# assume self: TRAIT_MANAGER
    --stores the name
    self.key = trait_key
    --handle the trait's flag for normal character dilemmas
    self.flagged_cqi = cm:get_saved_value("tm_"..self.key.."_flagged_cqi") or -1 --:number
    self.out_for_trigger = not not cm:get_saved_value("tm_"..self.key.."_out_for_trigger")
    --handle the faction leader trait dilemmas
    self.faction_leader_add_choices = {} --:map<string, number>
    self.faction_leader_remove_choices = {} --:map<string, number>
end

