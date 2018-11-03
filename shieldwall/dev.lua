--v function(text: string, context: string?)
local function MODLOG(text, context)
    if not CONST.__write_output_to_logfile then
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
    if not CONST.__should_output_ui then
        return
    end
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
                MODLOG("\tFound " .. name);
                if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
                    --Skip
                else
                    metatable[name] = logFunctionCall(f, name);
                end
            end
            if name == "__index" and not is_function(f) then
                for indexname,indexf in pairs(f) do
                    MODLOG("\t\tFound in index " .. indexname);
                    if is_function(indexf) then
                        f[indexname] = logFunctionCall(indexf, indexname);
                    end
                end
                MODLOG("\tIndex end");
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
--# assume logAllObjectCalls: function(object: any)
--# assume safeCall: function(func: function)


--object logging
cm:register_first_tick_callback(function()
    if not CONST.__log_game_objects then
        return
    end
    --v function(text: any)
    local function log(text)
        MODLOG(tostring(text), "OBJ")
    end
    log("GAME INTERFACE")
    logAllObjectCalls(cm.scripting.game_interface)
    log("FACTION INTERFACE")
    local faction = cm:model():world():faction_by_key(cm:get_local_faction(true))
    logAllObjectCalls(faction)
    log("REGION INTERFACE")
    logAllObjectCalls(faction:home_region())
end)



--SELECTION TRACKING

local settlement_selected_log_calls = {} --:vector<(function(CA_REGION) --> string)>
local char_selected_log_calls = {} --:vector<(function(CA_CHAR) --> string)>

--start UI tracking helpers.
cm:register_ui_created_callback( function()
    log_uicomponent_on_click()
    cm:add_listener(
        "charSelected",
        "CharacterSelected",
        true,
        function(context)
            MODLOG("selected character with CQI ["..tostring(context:character():cqi()).."]", "SEL")
            for i = 1, #char_selected_log_calls do
                MODLOG("\t"..char_selected_log_calls[i](context:character()), "SEL")
            end
        end,
        true
    )

    cm:add_listener(
        "SettlementSelected",
        "SettlementSelected",
        true,
        function(context)
            MODLOG("Selected settlement ["..  context:garrison_residence():region():name() .. "]", "SEL")
            for i = 1, #settlement_selected_log_calls do
                MODLOG("\t"..settlement_selected_log_calls[i](context:garrison_residence():region()), "SEL")
            end
        end,
        true
    )
end)

--v function(call: function(CA_REGION) --> string)
local function dev_add_settlement_select_log_call(call)
    table.insert(settlement_selected_log_calls, call)
end

--v function(call: function(CA_CHAR) --> string)
local function dev_add_character_select_log_call(call)
    table.insert(char_selected_log_calls, call)
end



--dev shortcut library

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


--v function() --> CA_REGION_LIST
local function dev_region_list()
    return cm:model():world():region_manager():region_list()
end

--v function() --> CA_FACTION_LIST
local function dev_faction_list()
    return cm:model():world():faction_list()
end

--v [NO_CHECK] function(t: table) --> table
local function dev_readonlytable(t)
    return setmetatable({}, {
        __index = table,
        __newindex = function(table, key, value)
                        error("Attempt to modify read-only table")
                    end,
        __metatable = false
    });
end

return {
    log = MODLOG,
    callback = add_callback,
    eh = get_eh(),
    out_children = print_all_uicomponent_children,
    get_uic = find_uicomponent,
    get_faction = dev_get_faction,
    get_region = dev_get_region,
    get_character = dev_get_character,
    region_list = dev_region_list,
    faction_list = dev_faction_list,
    add_settlement_selected_log = dev_add_settlement_select_log_call,
    add_character_selected_log = dev_add_character_select_log_call,
    as_read_only = dev_readonlytable
}