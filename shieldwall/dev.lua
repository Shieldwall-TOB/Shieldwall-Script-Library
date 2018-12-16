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

local exports = {} --:map<string, boolean>
--v function(name: string, ...: string)
local function RAWPRINT(name, ...)
    if exports[name] == nil then
        return
    end
    logText = arg[1]
    if #arg > 1 then
        for i = 2, #arg do
            logText = logText.."\t"..arg[i]
        end
    end
    local popLog = io.open("sheildwall_output_"..name..".tsv","a")
    --# assume logTimeStamp: string
    popLog :write(logText.."\n")
    popLog :flush()
    popLog :close()
end

--v function(name: string, ...: string)
local function new_export(name, ...)
    exports[name] = true
    logText = arg[1]
    if #arg > 1 then
        for i = 2, #arg do
            logText = logText.."\t"..arg[i]
        end
    end
    local popLog = io.open("sheildwall_output_"..name..".tsv","w+")
    popLog :write(logText.."\n")
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
local function log_uicomponent_on_click()
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

--v [NO_CHECK] function(uic: CA_UIC) --> string
local function dev_uicomponent_to_str(uic)
	if not is_uicomponent(uic) then
		return "";
	end;
	
	if uic:Id() == "root" then
		return "root";
	else
		return dev_uicomponent_to_str(UIComponent(uic:Parent())) .. " > " .. uic:Id();
	end;	
end;

--v [NO_CHECK] function(uic: CA_UIC)
local function dev_print_all_uicomponent_children(uic)
	MODLOG(dev_uicomponent_to_str(uic), "UIC");
	for i = 0, uic:ChildCount() - 1 do
		local uic_child = UIComponent(uic:Find(i));
		dev_print_all_uicomponent_children(uic_child);
	end;
end;

--don't call this one root. Just dont. 
--v [NO_CHECK] function(uic: CA_UIC)
local function dev_print_all_uicomponent_details(uic)
    log_uicomponent(uic)
    for i = 0, uic:ChildCount() - 1 do
        local uic_child = UIComponent(uic:Find(i));
        dev_print_all_uicomponent_details(uic_child)
    end;
end;




--v [NO_CHECK] function()
function MOD_ERROR_LOGS()
--Vanish's PCaller
    --All credits to vanishoxyact from WH2
    local eh = get_eh();

    --v function(func: function) --> any
    function safeCall(func)
        local status, result = pcall(func)
        if not status then
            MODLOG(tostring(result), "ERR")
            MODLOG(debug.traceback(), "ERR");
        end
        return result;
    end
    
    
    --v [NO_CHECK] function(...: any)
    function pack2(...) return {n=select('#', ...), ...} end
    --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
    function unpack2(t) return unpack(t, 1, t.n) end
    
    --v [NO_CHECK] function(f: function(), argProcessor: (function())?) --> function()
    function wrapFunction(f, argProcessor)
        return function(...)
            local someArguments = pack2(...);
            if argProcessor then
                safeCall(function() argProcessor(someArguments) end)
            end
            local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
            return unpack2(result);
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
    
    
    eh.trigger_event = wrapFunction(
        eh.trigger_event,
        function(ab)
        end
    );
    
    check_callbacks = wrapFunction(
        check_callbacks,
        function(ab)
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
            wrappedCondition =  wrapFunction(conditionFunc);
        else
            wrappedCondition = conditionFunc;
        end
        currentAddListener(
            eh, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
        )
    end
    eh.add_listener = myAddListener;
end
MOD_ERROR_LOGS() 
--# assume logAllObjectCalls: function(object: any)
--# assume safeCall: function(func: function)
--# assume wrapFunction: function(f: function(), argProcessor: (function())?) --> function()

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
    log("MODEL")
    logAllObjectCalls(cm:model())
    log("WORLD")
    logAllObjectCalls(cm:model():world())
    log("Region manager")
    logAllObjectCalls(cm:model():world():region_manager())
    log("FACTION INTERFACE")
    local faction = cm:model():world():faction_by_key(cm:get_local_faction(true))
    logAllObjectCalls(faction)
    log("REGION INTERFACE")
    logAllObjectCalls(faction:home_region())
    log("SETTLEMENT")
    logAllObjectCalls(faction:home_region():settlement())
    log("SLOT")
    logAllObjectCalls(faction:home_region():settlement():slot_list():item_at(0))
    log("BUILDING")
    logAllObjectCalls(faction:home_region():settlement():slot_list():item_at(0):building())
    log("GARRISON")
    logAllObjectCalls(faction:home_region():garrison_residence())
    log("CHARACTER")
    logAllObjectCalls(faction:faction_leader())
    log("FORCE")
    logAllObjectCalls(faction:faction_leader():military_force())
end)



--SELECTION TRACKING

local settlement_selected_log_calls = {} --:vector<(function(CA_REGION) --> string)>
local settlement_selected_log_lists = {} --:vector<(function(CA_REGION) --> (string, vector<string>))>
local char_selected_log_calls = {} --:vector<(function(CA_CHAR) --> string)>
local char_selected_log_lists = {} --:vector<(function(CA_CHAR) --> (string, vector<string>))>

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
            for i = 1, #char_selected_log_lists do
                local title, list = char_selected_log_lists[i](context:character())
                MODLOG("\t"..title, "SEL")
                for j = 1, #list do
                    MODLOG("\t\t"..list[j] , "SEL")
                end
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
            for i = 1, #settlement_selected_log_lists do
                local title, list = settlement_selected_log_lists[i](context:garrison_residence():region())
                MODLOG("\t"..title, "SEL")
                for j = 1, #list do
                    MODLOG("\t\t"..list[j] , "SEL")
                end
            end
        end,
        true
    )
end)

--v function(call: function(CA_REGION) --> string)
local function dev_add_settlement_select_log_call(call)
    table.insert(settlement_selected_log_calls, call)
end

--v function(call: function(CA_REGION) --> (string, vector<string>))
local function dev_add_settlement_select_log_list(call)
    table.insert(settlement_selected_log_lists, call)
end

--v function(call: function(CA_CHAR) --> string)
local function dev_add_character_select_log_call(call)
    table.insert(char_selected_log_calls, call)
end

--v function(call: function(CA_CHAR) --> (string, vector<string>))
local function dev_add_character_select_log_list(call)
    table.insert(char_selected_log_lists, call)
end

--settlement logging
if CONST.__log_settlements then
    dev_add_settlement_select_log_list(function(region)
        local retval = {} --:vector<string>
        if region:settlement():is_null_interface() then
            return "Buildings:", retval
        end
        local slot_list = region:settlement():slot_list()
        for i = 0, slot_list:num_items() - 1 do
            local slot = slot_list:item_at(i)
            if slot:has_building() then
                table.insert(retval, slot:building():name())
            end
        end
        return "Buildings:", retval 
    end)
end

if CONST.__log_characters then
    dev_add_character_select_log_list(function(character)
        local retval = {} --:vector<string>
        if character:is_null_interface() then
            return "Info:", retval
        end
        table.insert(retval, "Name: "..character:get_forename())
        table.insert(retval, "X, Y: "..character:logical_position_x()..", "..character:logical_position_y())
        table.insert(retval, "Is faction leader: ".. tostring(character:is_faction_leader()))

        return "Info:", retval
    end)
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

--v function(cqi: CA_CQI) --> CA_FORCE
local function dev_get_force(cqi)
    if cm:model():has_military_force_command_queue_index(cqi) then
        return cm:model():military_force_for_command_queue_index(cqi)
    else
        return nil
    end
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

--v function (callback: function(), timer: number?, name: string?)
function dev_callback(callback, timer, name)
    add_callback(wrapFunction(callback), timer, name)
end

local pre_first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local post_first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local new_game_callbacks = {} --:vector<function(context: WHATEVER)>

--v function(callback: function(context: WHATEVER))
function dev_pre_first_tick(callback)
    table.insert(pre_first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
function dev_first_tick(callback)
    table.insert(first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
function dev_post_first_tick(callback)
    table.insert(post_first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
function dev_new_game_callback(callback)
    if cm:get_saved_value("dev_new_game_callback") then
        return
    end
    table.insert(new_game_callbacks, callback)
end


_G.game_created = false

cm:register_first_tick_callback(function(context)
    _G.game_created = true
    MODLOG("===================================================================================", "FTC")
    MODLOG("===================================================================================", "FTC")
    MODLOG("===============THE GAME IS STARTING: RUNNING FIRST TICK CALLBACK===================", "FTC")
    MODLOG("===================================================================================", "FTC")
    MODLOG("===================================================================================", "FTC")
    local ok, err = pcall( function()
        for i = 1, #pre_first_tick_callbacks do
            pre_first_tick_callbacks[i](context)
        end
        if not cm:get_saved_value("dev_new_game_callback") then
            MODLOG("===================================================================================", "FTC")
            MODLOG("===================================================================================", "FTC")
            MODLOG("===============NEW GAME STARTED: RUNNING NEW GAME START CALLBACK===================", "FTC")
            MODLOG("===================================================================================", "FTC")
            MODLOG("===================================================================================", "FTC")
            for i = 1, #new_game_callbacks do
                new_game_callbacks[i](context)
            end
            cm:set_saved_value("dev_new_game_callback", true)
        end
        for i = 1, #first_tick_callbacks do
            first_tick_callbacks[i](context)
        end
        for i = 1, #post_first_tick_callbacks do
            post_first_tick_callbacks[i](context)
        end
    end)
    if not ok then
        MODLOG("ERROR IN FIRST TICK", "ERR")
        MODLOG(tostring(err), "ERR")
    end
end)
--v function() --> boolean
local function dev_game_created()
    return _G.game_created
end

--v function(text: any)
local function dev_save_logger(text)
    if not CONST.__should_output_save_load then
        return
    end
    MODLOG(tostring(text), "SVL")
end


--v [NO_CHECK] function(object: any, ...:string) --> table
function dev_save_object_as_plain_table(object, ...)
    if CONST.__should_output_save_load then
        MODLOG("Saving data for object: ["..tostring(object).."]", "SAV")
    end
    local sv_tab = {} --:table
    for i = 1, #arg do
        local field = arg[i]
        if object[field] and not is_function(object[field]) then 
            sv_tab[field] = object[field] 
            if CONST.__should_output_save_load then
                if type(sv_tab[field]) == "string" or type(sv_tab[field]) == "number" then
                    MODLOG("\t Saved field ["..field.."] which had a value of ["..sv_tab[field].."]", "SAV")
                else
                    MODLOG("\t Saved field ["..field.."] which had a value type ["..type(sv_tab[field]).."]", "SAV")
                end
            end
        end
    end
    return sv_tab
end

--v [NO_CHECK] function(sv_tab: table, object: any, ...:string) 
function dev_load_object_from_plain_table(sv_tab, object, ...)
    if CONST.__should_output_save_load then
        MODLOG("Loading data for object: ["..tostring(object).."]", "LOD")
    end
    for i = 1, #arg do
        local field = arg[i]
        if sv_tab[field] then
            object[field] = sv_tab[field]
            if CONST.__should_output_save_load then
                if type(sv_tab[field]) == "string" or type(sv_tab[field]) == "number" then
                    MODLOG("\t Loaded field ["..field.."] which had a value of ["..sv_tab[field].."]", "LOD")
                else
                    MODLOG("\t Loaded field ["..field.."] which had a value type ["..type(sv_tab[field]).."]", "LOD")
                end
            end
        end
    end
end


return {
    log = MODLOG,
    export = RAWPRINT,
    new_export = new_export,
    callback = dev_callback,
    eh = get_eh(),
    out_children = dev_print_all_uicomponent_children,
    out_details_for_children = dev_print_all_uicomponent_details,
    get_uic = find_uicomponent,
    get_faction = dev_get_faction,
    get_region = dev_get_region,
    get_character = dev_get_character,
    get_force = dev_get_force,
    lookup = char_lookup_str,
    region_list = dev_region_list,
    faction_list = dev_faction_list,
    add_settlement_selected_log = dev_add_settlement_select_log_call,
    add_character_selected_log = dev_add_character_select_log_call,
    as_read_only = dev_readonlytable,
    first_tick = dev_first_tick,
    new_game = dev_new_game_callback,
    pre_first_tick = dev_pre_first_tick,
    post_first_tick = dev_post_first_tick,
    is_game_created = dev_game_created,
    save = dev_save_object_as_plain_table,
    load = dev_load_object_from_plain_table
}