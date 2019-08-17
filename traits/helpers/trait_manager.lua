--this object helps handle the implementation of a given trait.

local TM_TRIGGERED_DILEMMA = {} --:map<string, map<string, boolean>>

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
    self.flagged_cqi = cm:get_saved_value("tm_"..self.key.."_flagged_cqi") or -1 --:CA_CQI
    self.out_for_trigger = not not cm:get_saved_value("tm_"..self.key.."_out_for_trigger")
    --handle the faction leader trait dilemmas
    self.faction_leader_add_choices = {} --:map<string, number>
    self.faction_leader_remove_choices = {} --:map<string, number>
    --startpos characters
    self.startpos_characters = {}
    self.start_traits_applied = not not cm:get_saved_value("tm_"..self.key.."_start_traits_applied")
    return self
end

--v function(self: TRAIT_MANAGER, text: any)
function trait_manager.log(self, text)
    dev.log(tostring(text), "TM-")
end



--v function(self: TRAIT_MANAGER)
function trait_manager.cache(self)
    cm:set_saved_value("tm_"..self.key.."_flagged_cqi", self.flagged_cqi)
    cm:set_saved_value("tm_"..self.key.."_out_for_trigger", self.out_for_trigger)
end


--v function(self: TRAIT_MANAGER, dilemma_key: string, choice: number)
function trait_manager.register_faction_leader_add_trait_dilemma(self, dilemma_key, choice)


end

--v function(self: TRAIT_MANAGER, dilemma_key: string, choice: number)
function trait_manager.register_faction_leader_remove_trait_dilemma(self, dilemma_key, choice)


end

--private function
--v function(self: TRAIT_MANAGER, char: CA_CHAR)
local function apply_trait_dilemma_for_character(self, char)
    if (not char:faction():is_human()) then
        if cm:random_number(100) > 50 then
            cm:force_add_trait(dev.lookup(char) ,self.key, false)
        end
        return 
    end
    if (not char:is_faction_leader()) and (not char:has_trait(self.key)) and (not char:has_trait(self.key.."_flag")) then
        cm:force_add_trait(dev.lookup(char) ,self.key.."_flag", false)
        dev.log("Added trait trigger ["..self.key.."] to character ["..tostring(char:command_queue_index()).."] from faction ["..char:faction():name().."] ")
        self.out_for_trigger = true
        self.flagged_cqi = char:command_queue_index()
        self:cache()
    end
end


--v [NO_CHECK] function(self: TRAIT_MANAGER)
function trait_manager.clear_trait_flag(self)
    self.flagged_cqi = -1
    self.out_for_trigger = false
    self:cache() 
end


--v function(self: TRAIT_MANAGER, event: string, conditional_function: function(context: WHATEVER) --> (boolean, CA_CHAR?), on_trigger: (function(cqi: CA_CQI))? )
function trait_manager.add_dilemma_flag_listener(self, event, conditional_function, on_trigger)
    local flag = self.key .."_flag"
    TM_TRIGGERED_DILEMMA[flag] = TM_TRIGGERED_DILEMMA[flag] or {}
    --listen for trigger
    cm:add_listener(
        "TraitTrigger"..self.key,
        event,
        function(context)

            return true
        end,
        function(context)
            self:log("Evaluating trait validity ".. self.key)
            local valid, char = conditional_function(context)
            --exclude case, no character returned
            if not char then
                return 
            end
            --# assume char: CA_CHAR

            --case: out for trigger and trigger char now invalid
            if self.out_for_trigger and (not valid) then
                if char:command_queue_index() == self.flagged_cqi then
                    cm:force_remove_trait(dev.lookup(char), flag)
                    self:clear_trait_flag()
                end
            end
            --case: valid, not yet out for a trigger, not previously triggered for this CQI
            if valid and (not self.out_for_trigger) and (not TM_TRIGGERED_DILEMMA[flag][tostring(char:command_queue_index())]) then
                apply_trait_dilemma_for_character(self, char)
            end
        end,
        true)

        --removes flags after a trait choice so that you don't get spammed with the same one.
        --also handles responses
        cm:add_listener(
            "DilemmaChoiceMadeEventRemoveFlagsTraitName",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == self.key.."_choice"
            end,
            function(context)
                for i = 0, context:faction():character_list():num_items() - 1 do
                    local char = context:faction():character_list():item_at(i)
                    if char:has_trait(flag) then
                        if on_trigger then
                            --# assume on_trigger: function(cqi: CA_CQI)
                            on_trigger(char:command_queue_index())
                        end
                        TM_TRIGGERED_DILEMMA[flag][tostring(char:command_queue_index())] = true --saves the fact its happened for this character
                        cm:force_remove_trait(dev.lookup(char), flag) --ensures we don't repeat the same event over and over
                        self:clear_trait_flag()--makes the trait available again for new characters to take
                    end
                end
            end, true)
        cm:add_listener(
            "IncidentOccuredEventRemoveFlags",
            "IncidentOccuredEvent",
            function(context)
                return context:dilemma() == self.key.."_event"
            end,
            function(context)
                for i = 0, context:faction():character_list():num_items() - 1 do
                    local char = context:faction():character_list():item_at(i)
                    if char:has_trait(flag) then
                        if on_trigger then
                            --# assume on_trigger: function(cqi: CA_CQI)
                            on_trigger(char:command_queue_index())
                        end
                        cm:force_remove_trait(dev.lookup(char), flag) --ensures we don't repeat the same event over and over
                        TM_TRIGGERED_DILEMMA[flag][tostring(char:command_queue_index())] = true --saves the fact its happened for this character
                        self:clear_trait_flag() --makes the trait available again for new characters to take
                    end
                end
            end, true)
end


--v function(self: TRAIT_MANAGER, event: string, conditional_function: function(context: WHATEVER) --> (boolean, CA_CHAR?))
function trait_manager.add_normal_trait_trigger(self, event, conditional_function) 
    cm:add_listener(
        "TMTraitTriggerNormal"..self.key,
        event,
        true,
        function(context)
            local valid, char = conditional_function(context)
            --case: function returned a valid character
            if valid and char then
                --# assume char: CA_CHAR
                if not char:has_trait(self.key) then
                    cm:force_add_trait(dev.lookup(char), self.key, true)
                end
            end
        end,
        true
    )
end

--v function(self: TRAIT_MANAGER, ...:string)
function trait_manager.set_start_pos_characters(self, ...)
    dev.first_tick(function(context)
        if self.start_traits_applied == false then
            cm:set_saved_value("tm_"..self.key.."_start_traits_applied", true)
            for i = 1, #arg do
                cm:force_add_trait(arg[i], self.key, false)
            end
        end
    end)
end




cm:register_loading_game_callback(
    function(context)
		TM_TRIGGERED_DILEMMA = cm:load_value("TM_TRIGGERED_DILEMMA", {}, context);
	end
);

cm:register_saving_game_callback(
	function(context)
        cm:save_value("TM_TRIGGERED_DILEMMA", TM_TRIGGERED_DILEMMA, context);
	end
);


return {
    new = trait_manager.new
}