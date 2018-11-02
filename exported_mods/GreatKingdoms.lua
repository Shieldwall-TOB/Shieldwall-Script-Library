
__write_output_to_logfile = true







--v function(text: string, context: string?)
function MODLOG(text, context)
    if not __write_output_to_logfile then
        return; 
    end
    local pre = context --:string
    if not context then
        pre = "DEV"
    end
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("sheildwall_logs.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end


local popLog = io.open("sheildwall_logs.txt", "w+")
local logTimeStamp = os.date("%d, %m %Y %X")
--# assume logTimeStamp: string
popLog:write("NEW LOG: ".. logTimeStamp .. "\n")
popLog :flush()
popLog :close()

MODLOG("LOADING SHIELDWALL LIBRARY")
--v function(uic: CA_UIC)
local function log_uicomponent(uic)

    local LOG = MODLOG
    --v function(text: any)
    local function MODLOG(text)
        LOG(tostring(text), "UIC")
    end

    if not is_uicomponent(uic) then
        script_error("ERROR: output_uicomponent() called but supplied object [" .. tostring(uic) .. "] is not a ui component");
        return;
    end;
        
    -- not sure how this can happen, but it does ...
    if not pcall(function() MODLOG("uicomponent " .. tostring(uic:Id()) .. ":") end) then
        MODLOG("output_uicomponent() called but supplied component seems to not be valid, so aborting");
        return;
    end;
    
    MODLOG("path from root:\t\t" .. uicomponent_to_str(uic));
    
    local pos_x, pos_y = uic:Position();
    local size_x, size_y = uic:Bounds();

    MODLOG("\tposition on screen:\t" .. tostring(pos_x) .. ", " .. tostring(pos_y));
    MODLOG("\tsize:\t\t\t" .. tostring(size_x) .. ", " .. tostring(size_y));
    MODLOG("\tstate:\t\t" .. tostring(uic:CurrentState()));
    MODLOG("\tvisible:\t\t" .. tostring(uic:Visible()));
    MODLOG("\tpriority:\t\t" .. tostring(uic:Priority()));
    MODLOG("\tchildren:");
    
    
    for i = 0, uic:ChildCount() - 1 do
        local child = UIComponent(uic:Find(i));
        
        MODLOG("\t\t"..tostring(i) .. ": " .. child:Id());
    end;


    MODLOG("");
end;


-- for debug purposes
function log_uicomponent_on_click()
    local eh = get_eh();
    
    if not eh then
        script_error("ERROR: output_uicomponent_on_click() called but couldn't get an event handler");
        return false;
    end;
    
    MODLOG("output_uicomponent_on_click() called");
    
    eh:add_listener(
        "output_uicomponent_on_click",
        "ComponentLClickUp",
        true,
        function(context) log_uicomponent(UIComponent(context.component)) end,
        true
    );
end;

--v [NO_CHECK] function()
function MOD_ERROR_LOGS()
--Vanish's PCaller
    --All credits to vanish
    local eh = get_eh();

    --v function(func: function) --> any
    function safeCall(func)
        --output("safeCall start");
        local status, result = pcall(func)
        if not status then
            MODLOG(tostring(result), "ERR")
            MODLOG(debug.traceback(), "ERR");
        end
        --output("safeCall end");
        return result;
    end
    
    --local oldTriggerEvent = core.trigger_event;
    
    --v [NO_CHECK] function(...: any)
    function pack2(...) return {n=select('#', ...), ...} end
    --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
    function unpack2(t) return unpack(t, 1, t.n) end
    
    --v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
    function wrapFunction(f, argProcessor)
        return function(...)
            --output("start wrap ");
            local someArguments = pack2(...);
            if argProcessor then
                safeCall(function() argProcessor(someArguments) end)
            end
            local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
            --for k, v in pairs(result) do
            --    output("Result: " .. tostring(k) .. " value: " .. tostring(v));
            --end
            --output("end wrap ");
            return unpack2(result);
            end
    end
    
    -- function myTriggerEvent(event, ...)
    --     local someArguments = { ... }
    --     safeCall(function() oldTriggerEvent(event, unpack( someArguments )) end);
    -- end
    
    --v [NO_CHECK] function(fileName: string)
    function tryRequire(fileName)
        local loaded_file = loadfile(fileName);
        if not loaded_file then
            MODLOG("Failed to find mod file with name " .. fileName)
        else
            MODLOG("Found mod file with name " .. fileName)
            MODLOG("Load start")
            local local_env = getfenv(1);
            setfenv(loaded_file, local_env);
            loaded_file();
            MODLOG("Load end")
        end
    end
    
    --v [NO_CHECK] function(f: function(), name: string)
    function logFunctionCall(f, name)
        return function(...)
            MODLOG("function called: " .. name);
            return f(...);
        end
    end
    
    --v [NO_CHECK] function(object: any)
    function logAllObjectCalls(object)
        local metatable = getmetatable(object);
        for name,f in pairs(getmetatable(object)) do
            if is_function(f) then
                MODLOG("Found " .. name);
                if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
                    --Skip
                else
                    metatable[name] = logFunctionCall(f, name);
                end
            end
            if name == "__index" and not is_function(f) then
                for indexname,indexf in pairs(f) do
                    MODLOG("Found in index " .. indexname);
                    if is_function(indexf) then
                        f[indexname] = logFunctionCall(indexf, indexname);
                    end
                end
                MODLOG("Index end");
            end
        end
    end
    
    --logAllObjectCalls(eh);
    --logAllObjectCalls(cm);
   -- MODLOG("CA_GAME_INTERFACE")
   -- logAllObjectCalls(cm.game_interface);
    
    eh.trigger_event = wrapFunction(
        eh.trigger_event,
        function(ab)
            --output("trigger_event")
            --for i, v in pairs(ab) do
            --    output("i: " .. tostring(i) .. " v: " .. tostring(v))
            --end
            --output("Trigger event: " .. ab[1])
        end
    );
    
    check_callbacks = wrapFunction(
        check_callbacks,
        function(ab)
            --output("check_callbacks")
            --for i, v in pairs(ab) do
            --    output("i: " .. tostring(i) .. " v: " .. tostring(v))
            --end
        end
    )

    local currentFirstTick = cm.register_first_tick_callback
    --v [NO_CHECK] function (cm: any, callback: function)
    function myFirstTick(cm, callback)
        currentFirstTick(cm, wrapFunction(callback))
    end
    cm.register_first_tick_callback = myFirstTick

    
    local currentAddListener = eh.add_listener;
    --v [NO_CHECK] function(eh: any, listenerName: any, eventName: any, conditionFunc: any, listenerFunc: any, persistent: any)
    function myAddListener(eh, listenerName, eventName, conditionFunc, listenerFunc, persistent)
        local wrappedCondition = nil;
        if is_function(conditionFunc) then
            --wrappedCondition =  wrapFunction(conditionFunc, function(arg) output("Callback condition called: " .. listenerName .. ", for event: " .. eventName); end);
            wrappedCondition =  wrapFunction(conditionFunc);
        else
            wrappedCondition = conditionFunc;
        end
        currentAddListener(
            eh, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
            --eh, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc, function(arg) output("Callback called: " .. listenerName .. ", for event: " .. eventName); end), persistent
        )
    end
    eh.add_listener = myAddListener;
end
MOD_ERROR_LOGS()

--start UI tracking helpers.
cm:register_ui_created_callback( function()
    log_uicomponent_on_click()
    cm:add_listener(
        "charSelected",
        "CharacterSelected",
        true,
        function(context)
            MODLOG("selected character with CQI ["..tostring(context:character():cqi()).."]", "SEL")
        end,
        true
    )

    cm:add_listener(
        "SettlementSelected",
        "SettlementSelected",
        true,
        function(context)
            MODLOG("Selected settlement ["..  context:garrison_residence():region():name() .. "]", "SEL")
        end,
        true
    )
end)

cm:register_first_tick_callback( function()

end)

--v function(key: string) --> CA_FACTION
local function dev_get_faction(key)
    local world = cm:model():world();
    
    if world:faction_exists(key) then
        return world:faction_by_key(key);
    end;
    
    return nil;
end

--v function(region_key: string) --> CA_REGION
local function dev_get_region(region_key)
    return cm:model():world():region_manager():region_by_key(region_key);
end

--v function(cqi: CA_CQI) --> CA_CHAR
local function dev_get_character(cqi)

	
	
	local model = cm:model();
	if model:has_character_command_queue_index(cqi) then
		return model:character_for_command_queue_index(cqi);
	end;

	return nil;
end


local dev = {
    get_faction = dev_get_faction,
    get_region = dev_get_region,
    get_character = dev_get_character
}



faction_kingdom_manager = {} --# assume faction_kingdom_manager: FKM


--v function()
function faction_kingdom_manager.init()
    local self = {}
    setmetatable(self, {
        __index = faction_kingdom_manager,
        __tostring = function() return "FACTION_KINGDOM_MANAGER" end
    }) --# assume self: FKM

    self._kingdoms = {} --:map<string, FKM_KINGDOM>
    self._vassals = {} --:map<string, FKM_VASSAL>
    
    --major faction autoresolve bonus toggles
    self._influenceAutoresolve = true --:boolean

    _G.fkm = self
end

--v method(text: any)
function faction_kingdom_manager:log(text)
    MODLOG(tostring(text), "FKM")
end



local fkm_vassal = {} --# assume fkm_vassal: FKM_VASSAL

--v function(model: FKM, faction_key: string, liege: string) --> FKM_VASSAL
function fkm_vassal.new(model, faction_key, liege)
    local self = {}
    setmetatable(self, {
        __index = fkm_vassal,
        __tostring = function() 
            return faction_key
        end
    }) --# assume self: FKM_VASSAL

    self._model = model
    self._name = faction_key
    self._liege = liege


    return self
end

--v function() --> FKM_VASSAL
function fkm_vassal.null_interface()
    local self = {}
    self.is_null_interface = function(self) return true end --: function(self: FKM_VASSAL) --> boolean
    --# assume self: FKM_VASSAL
    return self
end

--v function (self: FKM_VASSAL) --> boolean
function fkm_vassal.is_null_interface(self)
    return false
end

--v function(self: FKM_VASSAL, text: any)
function fkm_vassal.log(self, text)
    self._model:log(text)
end
    
local fkm_kingdom = {} --# assume fkm_kingdom: FKM_KINGDOM


--v function(model: FKM, faction_key: string, human: boolean) --> FKM_KINGDOM
function fkm_kingdom.new(model, faction_key, human)
    local self = {}
    setmetatable(self, {
        __index = fkm_kingdom,
        __tostring = function()
            return faction_key
        end
    }) --# assume self: FKM_KINGDOM

    self._model = model
    self._name = faction_key
    self._isHuman = human
    self._estateOwners = {} --:map<CA_CQI, vector<ESTATE>>

    return self
end

--v function() --> FKM_KINGDOM
function fkm_kingdom.null_interface()
    local self = {}
    self.is_null_interface = function(self) return true end --: function(self: FKM_KINGDOM) --> boolean
    --# assume self: FKM_KINGDOM
    return self
end

--v function(self: FKM_KINGDOM, estate: ESTATE)
function fkm_kingdom.add_estate(self, estate)
    if self._estateOwners[estate._owner] == nil then
        self._estateOwners[estate._owner] = {}
    end
    table.insert(self._estateOwners[estate._owner], estate)
end

--v function (self: FKM_KINGDOM) --> boolean
function fkm_kingdom.is_null_interface(self)
    return false
end

--v function(self: FKM_KINGDOM, text: any)
function fkm_kingdom.log(self, text)
    self._model:log(text)
end



--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_kingdom(self, faction_key)
    if self._kingdoms[faction_key] == nil then
        return false
    else
        return true
    end
end

--v function(self: FKM, faction_key: string) --> boolean
function faction_kingdom_manager.is_faction_vassal(self, faction_key)
    if self._vassals[faction_key] == nil then
        return false
    else 
        return true
    end
end

--v function(self: FKM, faction_key: string) --> FKM_KINGDOM
function faction_kingdom_manager.add_kingdom(self, faction_key)

    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction already has a kingdom entry, returning it.")
        return self._kingdoms[faction_key]
    end

    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a kingdom but that faction is a vassal!, deleting the vassal!")
        self._vassals[faction_key] = nil
    end

    local faction_obj = cm:model():world():faction_by_key(faction_key)
    local kingdom = fkm_kingdom.new(self, faction_key, faction_obj:is_human())
    self._kingdoms[faction_key] = kingdom
    self:log("added the faction ["..faction_key.."] as a kingdom! ")
    return kingdom
end

--v function(self: FKM, faction_key: string, known_liege: string?) --> FKM_VASSAL
function faction_kingdom_manager.add_vassal(self, faction_key, known_liege)
    if self:is_faction_vassal(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction already has a vassal entry, returning it.")
        return self._vassals[faction_key]
    end
    if self:is_faction_kingdom(faction_key) == true then
        self:log("Tried to add ["..faction_key.."] as a vassal but that faction is a kingdom!, deleting the Kingdom!")
        self._kingdoms[faction_key] = nil
    end
    local faction_obj = cm:model():world():faction_by_key(faction_key)
    
    local liege_key --:string
    if not not known_liege then
        --# assume known_liege: string
        liege_key = known_liege
    else
        local list = cm:model():world():faction_list()
        for i = 0, list:num_items() - 1 do
            local target = list:item_at(i)
            if faction_obj:is_vassal_of(target) then
                liege_key = target:name()
                break
            end
        end
    end
    if liege_key == nil then
        self:log("ERROR: Could not find the liege for faction ["..faction_key.."], aborting their creation as a vassal!")
        return fkm_vassal.null_interface()
    end
    local vassal = fkm_vassal.new(self, faction_key, liege_key)
    self._vassals[faction_key] = vassal
    self:log("Added faction ["..faction_key.."] as a vassal with liege ["..liege_key.."]")
    return vassal
end

--v function(self: FKM, vassal: string)
function faction_kingdom_manager.remove_vassal(self, vassal)
    if not self:is_faction_vassal(vassal) then
        self:log("the faction ["..vassal.."] is being called for removal from the vassals list, they already is not a vassal!")
        return 
    end
    self:log("removing the faction ["..vassal.."] from the vassal list!")
    self._vassals[vassal] = nil
end






faction_kingdom_manager.init()
_G.fkm:log("Init complete")

local fkm = _G.fkm

VAR_DEFENSIVE_BATTLES_ONLY = false
VAR_NEARBY_PLAYER_RESTRICTION = true
VAR_ENABLE_FOR_ALLIES = true
local events = get_events();
local VerboseLog = true

--v function(text: any)
local function MELOG(text)
    MODLOG(tostring(text), "ME ")
end



--v function() --> vector<CA_FACTION>
local function GetPlayerFactions()
    local player_factions = {};
    local faction_list = cm:model():world():faction_list();
    for i = 0, faction_list:num_items() - 1 do
        local curr_faction = faction_list:item_at(i);
        if (curr_faction:is_human() == true) then
            table.insert(player_factions, curr_faction);
        end
    end
    return player_factions;
end;

--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;

--v function(players: vector<CA_FACTION>, force: CA_FORCE) --> boolean
local function CheckIfPlayerIsNearFaction(players, force)
    local result = false;
    local force_general = force:general_character();
    local radius = 20;
    for i,value in ipairs(players) do
        local player_force_list = value:military_force_list();
        local j = 0;
        while (result == false) and (j < player_force_list:num_items()) do
            local player_character = player_force_list:item_at(j):general_character();
            local distance = distance_2D(force_general:logical_position_x(), force_general:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y());
            result = (distance < radius);
            j = j + 1;
        end
    end
    return result;
end


--v function(players: vector<CA_FACTION>, faction: CA_FACTION) --> boolean
local function CheckIfFactionIsPlayersAlly(players, faction)
    local result = false;
    for i,value in pairs(players) do
        if (result == false) and (value:allied_with(faction)==true) then
            result = true;
        end
    end
    
    return result;
end
--v function(context: WHATEVER)
function evaluate_battle(context)
    local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
	local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
	local attacker_is_major = fkm:is_faction_kingdom(attacking_faction:name())
	local defender_is_major = fkm:is_faction_kingdom(defending_faction:name());
	local attacker_is_secondary = fkm:is_faction_vassal(attacking_faction:name());
	local defender_is_secondary = fkm:is_faction_vassal(defending_faction:name());
	local player_factions = GetPlayerFactions()
	MELOG("\n#### BATTLE ####\n"..attacking_faction:name().." v "..defending_faction:name());

	if attacking_faction:is_human() == false and defending_faction:is_human() == false then
		if defender_is_secondary == false and attacker_is_secondary == false then 
			if attacker_is_major == true and defender_is_major == false then
				MELOG("Major Attacker v Minor Defender");

				if VAR_DEFENSIVE_BATTLES_ONLY == false then
					--If the minor faction is the player's military ally, we don't give bonuses to the major faction
					local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction);
					
					if VAR_ENABLE_FOR_ALLIES == true then
						ally_involved = false;
					else
						MELOG("Ally Involved: "..tostring(ally_involved));
					end

					if ally_involved == false then
						--If any of the player's armies/navies is close to the battle, the major faction won't receive the bonuses
						local player_nearby = false;
						if VAR_NEARBY_PLAYER_RESTRICTION == true then
							player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():defender():military_force());
						end
						MELOG("Player Nearby: "..tostring(player_nearby));

						if player_nearby == false then
							--Arguments: attacker win chance, defender win chance, attacker losses modifier, defender losses modifier
							MELOG("Modified autoresolve for "..context:pending_battle():attacker():faction():name());
							cm:win_next_autoresolve_battle(context:pending_battle():attacker():faction():name());
							cm:modify_next_autoresolve_battle(1, 0, 1, 20, true);
						end
					end
				else
					MELOG("No autoresolve modification");
				end
			elseif attacker_is_major == false and defender_is_major == true then
				MELOG("Minor Attacker v Major Defender");

				--If the minor faction is the player's military ally, we don't give bonuses to the major faction
				local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction);
					
				if VAR_ENABLE_FOR_ALLIES == true then
					ally_involved = false;
				else
					MELOG("Ally Involved: "..tostring(ally_involved));
				end

				if ally_involved == false then
					--If any of the player's forces is close to the battle, the major faction won't receive the bonuses
					local player_nearby = false;
					if VAR_NEARBY_PLAYER_RESTRICTION == true then
						player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():attacker():military_force());
					end
					MELOG("Player Nearby: "..tostring(player_nearby));

					if player_nearby == false then
						MELOG("Modified autoresolve for "..context:pending_battle():defender():faction():name());
							cm:win_next_autoresolve_battle(context:pending_battle():defender():faction():name());
						cm:modify_next_autoresolve_battle(0, 1, 20, 1, true);
					end;
				end
			elseif attacker_is_major == true and defender_is_major == true then
				MELOG("Major Attacker v Major Defender");
			elseif attacker_is_major == false and defender_is_major == false then
				MELOG("Minor Attacker v Minor Defender\nNo autoresolve modification");
			end
		else 
			MELOG("Secondary Defender \nNo autoresolve modification");
		end
	end
end;



events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function(context)
	if VerboseLog == false then 
		return
	end
	if context:character():model():pending_battle():has_defender() and context:character():model():pending_battle():defender():cqi() == context:character():cqi() then
		-- The character is the Defender
		local result = context:character():model():pending_battle():defender_battle_result();

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			MELOG("DFME:-- Result --\n"..context:character():faction():name().." Won! ("..result..")");
		end;
	elseif context:character():model():pending_battle():has_attacker() and context:character():model():pending_battle():attacker():cqi() == context:character():cqi() then
		-- The character is the Attacker
		local result = context:character():model():pending_battle():attacker_battle_result();

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			MELOG("DFME:-- Result --\n"..context:character():faction():name().." Won! ("..result..")");
		end;
	end;
end;





cm:add_listener(
    "GuarenteedEmpires",
    "PendingBattle",
    true,
    function(context) evaluate_battle(context) end,
    true);

MELOG("MAJOR EMPIRES INIT COMPLETE")





local kingdoms = {
"vik_fact_gwined",
"vik_fact_strat_clut",
"vik_fact_dyflin",
"vik_fact_norse",
"vik_fact_sudreyar",
"vik_fact_circenn",
"vik_fact_normaunds",
"vik_fact_mide",
"vik_fact_mierce",
"vik_fact_west_seaxe",
"vik_fact_east_engle",
"vik_fact_northymbre",
"vik_fact_aileach"
}--:vector<string>


cm:register_first_tick_callback( function()
    for i = 1, #kingdoms do
        local faction_name = kingdoms[i]
        fkm:add_kingdom(faction_name)
        local faction_obj = cm:model():world():faction_by_key(faction_name)
        local faction_list = cm:model():world():faction_list()
        for j = 0, faction_list:num_items() - 1 do
            local potential_vassal = faction_list:item_at(j)
            if potential_vassal:is_vassal_of(faction_obj) then
                fkm:add_vassal(potential_vassal:name(), faction_name)
            end
        end
    end
end)

fkm:log("KINGDOMS CONTENT INIT COMPLETE")
