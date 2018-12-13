-----------------------
--SHIELDWALL SCRIPTS---
-----------------------
--[[
    All shieldwall scripts are split into three sections
    1. The library defines all data structures used by the mod's scripting.
    2. The Content section is for loading inputs, usually in the form of keys, to the script.
    3. The Event Based Scripting section is for active elements of the script
--]]
CONST = require("shieldwall/ShieldWallConstants")
------------------------
--UI MODDING FRAMEWORK--
------------------------
local ok, err = pcall(function()
dev = require("shieldwall/dev")

------------------------
dev.pre_first_tick(function(context)
	dev.ui_module = require("shieldwall/ui_script/ui_module")
end)

--library
--require("shieldwall/lib/EstateManagement")
--require("shieldwall/lib/VassalFeatures")
--require("shieldwall/lib/RegionOwnershipTracker")
--require("shieldwall/lib/RegionWealth")
--require("shieldwall/lib/UnitCompEffects")
--require("shieldwall/lib/CharacterManager")
end)
if not not ok then
	dev.log("Successfully loaded shieldwall library!")
else
	dev.log("Error loading shieldwall library!")
	dev.log(tostring(err))
end
--content
--require("shieldwall/content/KingdomsContent")
--require("shieldwall/content/NamesAndPlaces")
--require("shieldwall/content/EstatesContent")
--require("shieldwall/content/UnitEffectsContent")
--require("shieldwall/content/FoodStorageContent")
--require("shieldwall/content/TitlesSystemContent")
--require("shieldwall/content/TitlesLocalisedContent")
--ebs
--require("shieldwall/ebs/ebs_estates_tracking")
--require("shieldwall/ebs/ebs_major_empires")
--require("shieldwall/ebs/ebs_vassal_features")
--require("shieldwall/ebs/ebs_restore_ally_territory")
--require("shieldwall/ebs/ebs_region_tracking")
--require("shieldwall/ebs/ebs_wealth")
--require("shieldwall/ebs/ebs_war_limits")
--require("shieldwall/ebs/ebs_unit_effects")
--require("shieldwall/ebs/ebs_food_storage")
--require("shieldwall/ebs/ebs_seasonal_effects")
--require("shieldwall/ebs/ebs_character_manager")

require("ilex_verticillata/PettyKingdoms")