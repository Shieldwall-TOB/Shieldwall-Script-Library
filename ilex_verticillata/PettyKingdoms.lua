-- The Pety Kingdoms Manager is a suite of campaign features designed for shieldwall. 
-- It is the script side data tracking archetecture behind all campaign features.

-- why the fuck is it called this? I don't bloody know it was the original name of the mod.
-- see, you learn stuff by reading useless comments. 

local petty_kingdoms_manager = {} --# assume petty_kingdoms_manager: PKM
local faction_detail = require("ilex_verticillata/faction_features/FactionDetail")

--v function()
function petty_kingdoms_manager.init()
    local self = {}
    setmetatable(self, {
        __index = petty_kingdoms_manager,
        __type = function() return "PETTY_KINGDOMS_MANAGER" end
    }) --# assume self: PKM

    self._season = -1
    self._factions = {}

    _G.pkm = self

end


--v method(text: any)
function petty_kingdoms_manager:log(text)
    dev.log(tostring(text), "PKM")
end
