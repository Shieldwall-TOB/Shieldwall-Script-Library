-----------------------
--SHIELDWALL SCRIPTS---
-----------------------
--[[
    All shieldwall scripts are split into four sections
    1. The library defines all development aids and UI functionality.
    2. The object model tracks all necessary information in a regulated data structure.
    3. The feature scripts add event handlers to actually make the mod work.
    4. The CONST sections data drive script values.
--]]

CONST = require("shieldwall/ShieldWallConstants")
------------------------
--UI MODDING FRAMEWORK--
------------------------
local ok, err = pcall(function()
    --LIB MANIFEST:
    dev = require("shieldwall/dev")
    local ui_module = require("shieldwall/ui_script/ui_module")
    
    --UI Library Init
    dev.pre_first_tick(function(context)
        dev.ui_module = ui_module()
    end)
end)
if not not ok then
	dev.log("Successfully loaded shieldwall library!")
else
    dev.log("************************************************************")
	dev.log("Error loading shieldwall library!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end

local ok, err = pcall(function()
    --MODEL MANIFEST: 
    require("ilex_verticillata/PettyKingdoms") 
end)
if not not ok then
    dev.log("Succeessfully loaded the object model!")
else
    dev.log("************************************************************")
    dev.log("Error loading the object model!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end


local ok, err = pcall(function()
    --EBS MANIFEST: 
        --empty for now
end)
if not not ok then
    dev.log("Succeessfully loaded shieldwall features!")
else
    dev.log("************************************************************")
    dev.log("Error loading shieldwall features!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end