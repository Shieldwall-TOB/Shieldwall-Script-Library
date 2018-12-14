------------------------
--UI MODDING FRAMEWORK--
------------------------

local Components = require("shieldwall/ui_script/components")
local shield_ui = {} --# assume shield_ui: SHIELD_UI

--v function(self: SHIELD_UI, text: any)
function shield_ui.log(self, text)
    if not CONST.__write_output_to_logfile then
        return; 
    end
    local pre = "CUI"
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("ui_errors.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end
    
--v function() --> SHIELD_UI
function shield_ui.init() 
    local self = {}
    setmetatable(self, {
        __index = shield_ui
    }) --# assume self: SHIELD_UI
    local root = cm:ui_root();
    root:CreateComponent("Garbage", "UI/campaign ui/script_dummy");
    local component = root:Find("Garbage");
    if not component then
        self:log("Could not create a script dummy, util init failed!")
        return nil
    else
        self.garbage =  UIComponent(component);
    end
    self.components = {} --:map<string, CA_UIC>
    

    _G.shw_uim = self
    return self
end




--v function(self: SHIELD_UI) --> map<string, CA_UIC>
function shield_ui.uic_hash(self)
    return self["components"]
end

--v function(self: SHIELD_UI, component_name: string) --> CA_UIC
function shield_ui.get_component(self, component_name)
    if not self.components[component_name] then
        return nil
    end
    return self.components[component_name]
end


--v function(uic: CA_UIC)
function shield_ui.delete(uic)
    shield_ui.garbage:Adopt(uic:Address());
    shield_ui.garbage:DestroyChildren();
end

--function entirely stolen from vanishoxyact.
-- thanks friend
--v function(name: string, parentComponent: CA_UIC, componentFilePath: string, ...:string) --> CA_UIC
function shield_ui.createComponent(name, parentComponent, componentFilePath, ...)
    local component = nil --: CA_UIC
    local temp = nil --: CA_UIC
    if not ... then
        parentComponent:CreateComponent(name, componentFilePath);
        component = UIComponent(parentComponent:Find(name));
    else
        parentComponent:CreateComponent("UITEMP", componentFilePath);
        temp = UIComponent(parentComponent:Find("UITEMP"));
        component = find_uicomponent(temp, ...);
    end
    if not component then
        local completePath = componentFilePath;
        for i, v in ipairs{...} do
            completePath = completePath .. "/" .. tostring(v);
        end
        shield_ui:log("Failed to create component "..name..", Path:" .. completePath);
        print_all_uicomponent_children(temp);
        shield_ui.delete(temp);
        return nil;
    else
        parentComponent:Adopt(component:Address());
        component:PropagatePriority(parentComponent:Priority());
        if not not ... then
            shield_ui.delete(temp);
        end
        Components.positionRelativeTo(component, parentComponent, 0, 0);        
        shield_ui:log("Created component "..name)
        return component;
    end
end



--v function(self: SHIELD_UI, name: string, parent: CA_UIC, button_type: BUTTON_TYPE, image_path: string) --> CA_UIC
function shield_ui.new_button(self, name, parent, button_type, image_path)
    local button = nil --:CA_UIC
    if button_type == "CIRCULAR" then
        button = self.createComponent(name, parent, "ui/templates/button")
    else
        self:log("Arg #3 button type expected enumerated string, recieved unrecognized ["..tostring(button_type).."] of type ["..(type(button_type)).."] ")
        return nil
    end
    button:SetImage(image_path)

    self.components[name] = button
    return button
end





return shield_ui.init