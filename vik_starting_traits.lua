-------------------------------------------------------------------------------
-------------------------------- SCRIPTED TRAITS ------------------------
-------------------------------------------------------------------------------
------------------------- Created by Laura: 23/11/2017 -----------------
------------------------- Last Updated: 03/07/2018 by Laura ------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Add the starting Personality and Starting traits for new characters

function Add_Starting_Traits_Listeners()
output("#### Adding Starting trait Listeners ####")
	--[[
	cm:add_listener(
		"StartingTraits",
		"CharacterCreated",
		true,
		function(context) StartingTraits(context) end,
		true
	);
	
	cm: add_listener(
		"AITraits",
		"CharacterTurnStart",
		function(context) return context:character():faction():is_human() == false end,
		function(context) StartingTraits(context) end,
		true
	);
	
	cm: add_listener(
		"TraitBackup",
		"CharacterTurnStart",
		true,
		function(context) TraitBackup(context) end, -- In case the character didn't get their traits on creation...
		true
	);
	
	--]]
end

