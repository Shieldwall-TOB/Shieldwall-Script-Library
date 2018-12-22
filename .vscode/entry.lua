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

--Load Constants
CONST = require("shieldwall/ShieldWallConstants")

--Load Libraries
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

--Load Model
local ok, err = pcall(function()
    --MODEL MANIFEST: 
    require("ilex_verticillata/PettyKingdoms") 
    --EVENT HANDLERS:
    require("ilex_verticillata/event_handlers/RegionOccupationHandler")
    require("ilex_verticillata/event_handlers/EstateEventsHandler")
end)
if not not ok then
    dev.log("Succeessfully loaded the object model!")
else
    dev.log("************************************************************")
    dev.log("Error loading the object model!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end

--Load Features
local ok, err = pcall(function()
    --FEATURES MANIFEST: 
    require("shieldwall/standalone/CitiesLandmarks")

    require("shieldwall/content/UnitEffectsContent")
    require("shieldwall/features/UnitEffectsFeatures")

    require("shieldwall/content/PopulationContent")
    require("shieldwall/features/PopulationFeatures")

    require("shieldwall/content/FoodStorageContent")
    require("shieldwall/features/FoodStorageFeatures")

    require("shieldwall/features/WarLimiter")

    require("shieldwall/content/KingdomsContent")
    require("shieldwall/features/VassalFeatures")
    require("shieldwall/features/MajorEmpireFeatures")

    require("shieldwall/features/RestoreAllyTerritory")
end)
if not not ok then
    dev.log("Succeessfully loaded shieldwall features!")
else
    dev.log("************************************************************")
    dev.log("Error loading shieldwall features!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end