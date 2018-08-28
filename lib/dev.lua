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
    local popLog = io.open("shieldwall_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

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

    MODLOG("position on screen:\t" .. tostring(pos_x) .. ", " .. tostring(pos_y));
    MODLOG("size:\t\t\t" .. tostring(size_x) .. ", " .. tostring(size_y));
    MODLOG("state:\t\t" .. tostring(uic:CurrentState()));
    MODLOG("visible:\t\t" .. tostring(uic:Visible()));
    MODLOG("priority:\t\t" .. tostring(uic:Priority()));
    MODLOG("children:");
    
    
    for i = 0, uic:ChildCount() - 1 do
        local child = UIComponent(uic:Find(i));
        
        MODLOG(tostring(i) .. ": " .. child:Id());
    end;


    MODLOG("");
end;


-- for debug purposes
function output_uicomponent_on_click()
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

