
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

-- vanilla goes here

--rewritten vanilla scripts
require("vik_burghal");


---

--Load Model
local ok, err = pcall(function()
    --MODEL MANIFEST: 
    require("petty_kingdoms/PettyKingdoms") 
    --EVENT HANDLERS:
    require("petty_kingdoms/event_handlers/RegionOccupationHandler")
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
    Check = require("shieldwall/checks")
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

    require("shieldwall/features/Bandits")
    require("shieldwall/features/SpecialBuildingEffects")
    require("shieldwall/content/TitlesSystemContent")
    --require("shieldwall/features/DecreeFeatures")
    require("shieldwall/features/SuppliesFeatures")
    require("shieldwall/features/ManOfTheHour")

    require("shieldwall/features/TraitsTriggers")
    --require("shieldwall/content/EstatesContent")
    --require("shieldwall/features/EstateFeatures")
    --require("shieldwall/features/CharacterLives")
    --UI
    require("shieldwall/ui_features/PopulationUI") 
    --TODO reimplement pop UI
    require("shieldwall/ui_features/TitlesUI")
end)
if not not ok then
    dev.log("Succeessfully loaded shieldwall features!")
else
    dev.log("************************************************************")
    dev.log("Error loading shieldwall features!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end

--load trait triggers
local ok, err = pcall(function()
    --FEATURES MANIFEST: 
    traits_manager = require("traits/helpers/trait_manager")
    local traits_list = require("traits/TraitTriggers")
    --# assume traits_list: vector<string>
    for i = 1, #traits_list do 
        require("traits/"..traits_list[i])
    end
end)
if not not ok then
    dev.log("Succeessfully loaded shieldwall trait triggers!")
else
    dev.log("************************************************************")
    dev.log("Error loading  shieldwall trait triggers!")
    dev.log(tostring(err))
    dev.log("************************************************************")
end


require("vik_rebels")