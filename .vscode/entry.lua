------------------------
--UI MODDING FRAMEWORK--
------------------------
--require("uimf/lib_uimf")
--require("shieldwall/lib/uimf_tests")

-----------------------
--SHIELDWALL SCRIPTS---
-----------------------
--[[
    All shieldwall scripts are split into three sections
    1. The library defines all data structures used by the mod's scripting.
    2. The Content section is for loading inputs, usually in the form of keys, to the script.
    3. The Event Based Scripting section is for active elements of the script
--]]

--library
require("shieldwall/lib/dev")
require("shieldwall/lib/EstateManagement")
require("shieldwall/lib/VassalFeatures")
require("shieldwall/lib/RegionOwnershipTracker")
--content
require("shieldwall/content/KingdomsContent")

--ebs
require("shieldwall/ebs/ebs_major_empires")
require("shieldwall/ebs/ebs_vassal_features")
require("shieldwall/ebs/ebs_restore_ally_territory")
require("shieldwall/ebs/ebs_region_tracking")
