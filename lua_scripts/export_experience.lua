--[[
Automatically generated via export from C:/Users/laura.kampis\DaVE_local\branches/attila/vikings/rome2/raw_data/db
Edit manually at your own risk
--]]

module(..., package.seeall)

events = get_events()
-- Experience Declarations

--[[ Trigger_Faction_Technology ]]--

function Trigger_Faction_Technology_impl (context)
		return char_is_general_with_army(context:character()) and not char_is_governor(context:character()) and context:character():faction():has_technology("vik_civ_religion_4")
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Faction_Technology_impl(context) then
		effect.add_agent_experience("Trigger_Faction_Technology", 3,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Victory_Heroic ]]--

function Trigger_General_Attacking_Victory_Heroic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="heroic_victory"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Victory_Heroic_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Victory_Heroic", 40,0, context)
		return true
	end
	return false
end


--[[ Trigger_General_Defending_Victory_Heroic ]]--

function Trigger_General_Defending_Victory_Heroic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="heroic_victory"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Victory_Heroic_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Victory_Heroic", 40,0, context)
		return true
	end
	return false
end


--[[ Trigger_General_Settlement_Captured ]]--

function Trigger_General_Settlement_Captured_impl (context)
		return context:garrison_residence():region():is_province_capital()
end 

events.GarrisonOccupiedEvent[#events.GarrisonOccupiedEvent+1] =
function (context)
	if Trigger_General_Settlement_Captured_impl(context) then
		effect.add_agent_experience("Trigger_General_Settlement_Captured", 50,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Attacking_Victory_Heroic ]]--

function Trigger_Secondary_General_Attacking_Victory_Heroic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="heroic_victory"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Victory_Heroic_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Victory_Heroic", 7,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Defending_Victory_Heroic ]]--

function Trigger_Secondary_General_Defending_Victory_Heroic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="heroic_victory"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Victory_Heroic_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Victory_Heroic", 7,0, context)
		return true
	end
	return false
end


