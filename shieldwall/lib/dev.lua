print("test")
__write_output_to_logfile = true







--v function(text: string, context: string?)
function MODLOG(text, context)
    if not __write_output_to_logfile then
        return; 
    end
    local pre = context --:string
    if not context then
        pre = "LOG"
    end
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("SHIELDWALL_UI.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end
MODLOG("LOADING SHIELDWALL LIBRARY")
--v function(uic: CA_UIC)
local function log_uicomponent(uic)
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
            MODLOG(tostring(result))
            MODLOG(debug.traceback());
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


cm:register_ui_created_callback( function()
    log_uicomponent_on_click()
    MOD_ERROR_LOGS()
end)

cm:register_first_tick_callback( function()
    --[[
    --# assume logAllObjectCalls: function(WHATEVER)
    local faction = cm:model():world():faction_by_key(cm:get_local_faction())
    MODLOG("CA FACTION INTERFACE")
    logAllObjectCalls(faction)
    MODLOG("CA REGION INTERFACE")
    logAllObjectCalls(faction:home_region())
    MODLOG("CA_CHARACTER INTERFACE")
    logAllObjectCalls(faction:faction_leader())
    MODLOG("CA_FORCE_INTERFACE")
    logAllObjectCalls(faction:faction_leader():military_force())
    MODLOG("CA_SETTLEMENT_INTERFACE")
    logAllObjectCalls(faction:home_region():settlement())
    MODLOG("CA_BUILDING_INTERFACE")
    logAllObjectCalls(faction:home_region():settlement():slot_list():item_at(0):building())
    --]]
end)