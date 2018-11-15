--[[
Automatically generated via export from C:/Users/laura.kampis\DaVE_local\branches/attila/vikings/rome2/raw_data/db
Edit manually at your own risk
--]]

module(..., package.seeall)

events = get_events()
-- Experience Declarations

--[[ Trigger_Agent_Anti_Character_Fail ]]--

function Trigger_Agent_Anti_Character_Fail_impl (context)
		return ( context:ability()=="hinder_character" or context:ability()=="hinder_agent" ) and context:mission_result_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Character_Fail_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Character_Fail", 4,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Character_Fail_Critical ]]--

function Trigger_Agent_Anti_Character_Fail_Critical_impl (context)
		return ( context:ability()=="hinder_character" or context:ability()=="hinder_agent" ) and context:mission_result_critial_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Character_Fail_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Character_Fail_Critical", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Character_Fail_Opportune ]]--

function Trigger_Agent_Anti_Character_Fail_Opportune_impl (context)
		return ( context:ability()=="hinder_character" or context:ability()=="hinder_agent" ) and context:mission_result_opportune_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Character_Fail_Opportune_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Character_Fail_Opportune", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Character_Success ]]--

function Trigger_Agent_Anti_Character_Success_impl (context)
		return ( context:ability()=="hinder_character" or context:ability()=="hinder_agent" ) and context:mission_result_success()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Character_Success_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Character_Success", 10,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Character_Success_Critical ]]--

function Trigger_Agent_Anti_Character_Success_Critical_impl (context)
		return ( context:ability()=="hinder_character" or context:ability()=="hinder_agent" ) and context:mission_result_critial_success()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Character_Success_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Character_Success_Critical", 16,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Force_Fail ]]--

function Trigger_Agent_Anti_Force_Fail_impl (context)
		return context:ability()=="hinder_army" and context:mission_result_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Force_Fail_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Force_Fail", 4,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Force_Fail_Critical ]]--

function Trigger_Agent_Anti_Force_Fail_Critical_impl (context)
		return context:ability()=="hinder_army" and context:mission_result_critial_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Force_Fail_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Force_Fail_Critical", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Force_Fail_Opportune ]]--

function Trigger_Agent_Anti_Force_Fail_Opportune_impl (context)
		return context:ability()=="hinder_army" and context:mission_result_opportune_failure()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Force_Fail_Opportune_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Force_Fail_Opportune", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Force_Success ]]--

function Trigger_Agent_Anti_Force_Success_impl (context)
		return context:ability()=="hinder_army" and context:mission_result_success()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Force_Success_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Force_Success", 10,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Force_Success_Critical ]]--

function Trigger_Agent_Anti_Force_Success_Critical_impl (context)
		return context:ability()=="hinder_army" and context:mission_result_critial_success()
end 

events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Force_Success_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Force_Success_Critical", 16,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Settlement_Fail ]]--

function Trigger_Agent_Anti_Settlement_Fail_impl (context)
		return context:mission_result_failure()
end 

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Settlement_Fail_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Settlement_Fail", 4,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Settlement_Fail_Critical ]]--

function Trigger_Agent_Anti_Settlement_Fail_Critical_impl (context)
		return context:mission_result_critial_failure()
end 

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Settlement_Fail_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Settlement_Fail_Critical", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Settlement_Fail_Opportune ]]--

function Trigger_Agent_Anti_Settlement_Fail_Opportune_impl (context)
		return context:mission_result_opportune_failure()
end 

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Settlement_Fail_Opportune_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Settlement_Fail_Opportune", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Settlement_Success ]]--

function Trigger_Agent_Anti_Settlement_Success_impl (context)
		return context:mission_result_success()
end 

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Settlement_Success_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Settlement_Success", 10,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Anti_Settlement_Success_Critical ]]--

function Trigger_Agent_Anti_Settlement_Success_Critical_impl (context)
		return context:mission_result_critial_success()
end 

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if Trigger_Agent_Anti_Settlement_Success_Critical_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Anti_Settlement_Success_Critical", 16,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Deployed_Action ]]--

function Trigger_Agent_Deployed_Action_impl (context)
		return context:character():is_deployed()
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Agent_Deployed_Action_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Deployed_Action", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_Agent_Friendly_Target_Action ]]--

function Trigger_Agent_Friendly_Target_Action_impl (context)
		return true
end 

events.CharacterPerformsActionAgainstFriendlyTarget[#events.CharacterPerformsActionAgainstFriendlyTarget+1] =
function (context)
	if Trigger_Agent_Friendly_Target_Action_impl(context) then
		effect.add_agent_experience("Trigger_Agent_Friendly_Target_Action", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Becomes_Faction_Leader ]]--

function Trigger_Character_Becomes_Faction_Leader_impl (context)
		return true
end 

events.CharacterBecomesFactionLeader[#events.CharacterBecomesFactionLeader+1] =
function (context)
	if Trigger_Character_Becomes_Faction_Leader_impl(context) then
		effect.add_agent_experience("Trigger_Character_Becomes_Faction_Leader", 10,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Noblewoman_Influence_Gain_1 ]]--

function Trigger_Character_Noblewoman_Influence_Gain_1_impl (context)
		return context:character():model():turn_number() > 1 and not context:character():is_male() and (context:character():has_skill("att_skill_background_wife_all_drunkard") or context:character():has_skill("att_skill_background_wife_all_harridan_nag") or context:character():has_skill("att_skill_background_wife_all_quiet") or context:character():has_skill("att_skill_background_wife_all_shrew") or context:character():has_skill("att_skill_background_wife_barbarian_uncanny") or context:character():has_skill("att_skill_background_wife_civilised_mean") or context:character():has_skill("att_skill_background_wife_civilised_superior") or context:character():has_skill("att_skill_background_wife_roman_sharp_tongue"))
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Character_Noblewoman_Influence_Gain_1_impl(context) then
		effect.add_agent_experience("Trigger_Character_Noblewoman_Influence_Gain_1", 0,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Noblewoman_Influence_Gain_2 ]]--

function Trigger_Character_Noblewoman_Influence_Gain_2_impl (context)
		return context:character():model():turn_number() > 1 and not context:character():is_male() and (context:character():has_skill("att_skill_background_wife_all_arrogant") or context:character():has_skill("att_skill_background_wife_all_poisoner") or context:character():has_skill("att_skill_background_wife_barbarian_superstitious") or context:character():has_skill("att_skill_background_wife_civilised_brutal") or context:character():has_skill("att_skill_background_wife_civilised_protective") or context:character():has_skill("att_skill_background_wife_civilised_sharp_tongue") or context:character():has_skill("att_skill_background_wife_civilised_unfaithful") or context:character():has_skill("att_skill_background_wife_civilised_unsuitable") or context:character():has_skill("att_skill_background_wife_roman_decorous"))
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Character_Noblewoman_Influence_Gain_2_impl(context) then
		effect.add_agent_experience("Trigger_Character_Noblewoman_Influence_Gain_2", 0,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Noblewoman_Influence_Gain_3 ]]--

function Trigger_Character_Noblewoman_Influence_Gain_3_impl (context)
		return context:character():model():turn_number() > 1 and not context:character():is_male() and (context:character():has_skill("att_skill_background_wife_all_fertile") or context:character():has_skill("att_skill_background_wife_all_flirt") or context:character():has_skill("att_skill_background_wife_all_religious") or context:character():has_skill("att_skill_background_wife_barbarian_midwife") or context:character():has_skill("att_skill_background_wife_barbarian_shieldmaid") or context:character():has_skill("att_skill_background_wife_barbarian_swordmaid") or context:character():has_skill("att_skill_background_wife_civilised_efficient") or context:character():has_skill("att_skill_background_wife_civilised_goddess") or context:character():has_skill("att_skill_background_wife_civilised_spendthrift") or context:character():has_skill("att_skill_background_wife_roman_conservative") or context:character():has_skill("att_skill_background_wife_roman_former_vestal"))
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Character_Noblewoman_Influence_Gain_3_impl(context) then
		effect.add_agent_experience("Trigger_Character_Noblewoman_Influence_Gain_3", 0,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Noblewoman_Influence_Gain_4 ]]--

function Trigger_Character_Noblewoman_Influence_Gain_4_impl (context)
		return context:character():model():turn_number() > 1 and not context:character():is_male() and (context:character():has_skill("att_skill_background_wife_all_cunning") or context:character():has_skill("att_skill_background_wife_all_faithful") or context:character():has_skill("att_skill_background_wife_all_great_beauty") or context:character():has_skill("att_skill_background_wife_all_intelligent") or context:character():has_skill("att_skill_background_wife_barbarian_priestess") or context:character():has_skill("att_skill_background_wife_civilised_educated") or context:character():has_skill("att_skill_background_wife_civilised_social_climber") or context:character():has_skill("att_skill_background_wife_civilised_wealthy") or context:character():has_skill("att_skill_background_wife_roman_noble"))
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Character_Noblewoman_Influence_Gain_4_impl(context) then
		effect.add_agent_experience("Trigger_Character_Noblewoman_Influence_Gain_4", 0,0, context)
		return true
	end
	return false
end

--[[ Trigger_Character_Noblewoman_Influence_Gain_5 ]]--

function Trigger_Character_Noblewoman_Influence_Gain_5_impl (context)
		return context:character():model():turn_number() > 1 and not context:character():is_male() and (context:character():has_skill("att_skill_background_wife_all_ambitious") or context:character():has_skill("att_skill_background_wife_civilised_political") or context:character():has_skill("att_skill_background_wife_roman_well_connected"))
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Character_Noblewoman_Influence_Gain_5_impl(context) then
		effect.add_agent_experience("Trigger_Character_Noblewoman_Influence_Gain_5", 0,0, context)
		return true
	end
	return false
end

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

--[[ Trigger_Faction_Trait_General_Xp ]]--

function Trigger_Faction_Trait_General_Xp_impl (context)
		return context:character():faction():name() == "vik_fact_west_seaxe" and char_is_general_with_army(context:character()) and not char_is_governor(context:character()) 
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Faction_Trait_General_Xp_impl(context) then
		effect.add_agent_experience("Trigger_Faction_Trait_General_Xp", 5,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Defeat ]]--

function Trigger_General_Attacking_Defeat_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and ( context:character():model():pending_battle():attacker_battle_result()=="close_defeat" or context:character():model():pending_battle():attacker_battle_result()=="decisive_defeat" or context:character():model():pending_battle():attacker_battle_result()=="pyrrhic_victory" )
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Defeat_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Defeat", 4,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Defeat_Crushing ]]--

function Trigger_General_Attacking_Defeat_Crushing_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="crushing_defeat"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Defeat_Crushing_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Defeat_Crushing", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Defeat_Valiant ]]--

function Trigger_General_Attacking_Defeat_Valiant_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="valiant_defeat"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Defeat_Valiant_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Defeat_Valiant", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Victory ]]--

function Trigger_General_Attacking_Victory_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and ( context:character():model():pending_battle():attacker_battle_result()=="close_victory" or context:character():model():pending_battle():attacker_battle_result()=="decisive_victory" or context:character():model():pending_battle():attacker_battle_result()=="valiant_defeat" )
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Victory_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Victory", 10,0, context)
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
		effect.add_agent_experience("Trigger_General_Attacking_Victory_Heroic", 14,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Attacking_Victory_Pyrrhic ]]--

function Trigger_General_Attacking_Victory_Pyrrhic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="pyrrhic_victory"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Attacking_Victory_Pyrrhic_impl(context) then
		effect.add_agent_experience("Trigger_General_Attacking_Victory_Pyrrhic", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Character_Commanding ]]--

function Trigger_General_Character_Commanding_impl (context)
		return context:character():has_military_force()
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_General_Character_Commanding_impl(context) then
		effect.add_agent_experience("Trigger_General_Character_Commanding", 1,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Court_School_1 ]]--

function Trigger_General_Court_School_1_impl (context)
		return context:character():has_region() and char_is_general_with_army(context:character()) and not char_is_governor(context:character()) and (context:character():region():building_exists("vik_court_school_1") and context:character():region():owning_faction() == context:character():faction())
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_General_Court_School_1_impl(context) then
		effect.add_agent_experience("Trigger_General_Court_School_1", 3,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Court_School_2 ]]--

function Trigger_General_Court_School_2_impl (context)
		return context:character():has_region() and char_is_general_with_army(context:character()) and not char_is_governor(context:character()) and (context:character():region():building_exists("vik_court_school_2") and context:character():region():owning_faction() == context:character():faction())
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_General_Court_School_2_impl(context) then
		effect.add_agent_experience("Trigger_General_Court_School_2", 5,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Court_School_3 ]]--

function Trigger_General_Court_School_3_impl (context)
		return context:character():has_region() and char_is_general_with_army(context:character()) and not char_is_governor(context:character()) and (context:character():region():building_exists("vik_court_school_3") and context:character():region():owning_faction() == context:character():faction())
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_General_Court_School_3_impl(context) then
		effect.add_agent_experience("Trigger_General_Court_School_3", 8,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Defending_Defeat ]]--

function Trigger_General_Defending_Defeat_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and ( context:character():model():pending_battle():defender_battle_result()=="close_defeat" or context:character():model():pending_battle():defender_battle_result()=="decisive_defeat" or context:character():model():pending_battle():defender_battle_result()=="pyrrhic_victory" )
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Defeat_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Defeat", 4,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Defending_Defeat_Crushing ]]--

function Trigger_General_Defending_Defeat_Crushing_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="crushing_defeat"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Defeat_Crushing_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Defeat_Crushing", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Defending_Defeat_Valiant ]]--

function Trigger_General_Defending_Defeat_Valiant_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="valiant_defeat"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Defeat_Valiant_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Defeat_Valiant", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Defending_Victory ]]--

function Trigger_General_Defending_Victory_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and ( context:character():model():pending_battle():defender_battle_result()=="close_victory" or context:character():model():pending_battle():defender_battle_result()=="decisive_victory" or context:character():model():pending_battle():defender_battle_result()=="valiant_defeat" )
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Victory_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Victory", 10,0, context)
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
		effect.add_agent_experience("Trigger_General_Defending_Victory_Heroic", 14,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Defending_Victory_Pyrrhic ]]--

function Trigger_General_Defending_Victory_Pyrrhic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="pyrrhic_victory"
end 

events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if Trigger_General_Defending_Victory_Pyrrhic_impl(context) then
		effect.add_agent_experience("Trigger_General_Defending_Victory_Pyrrhic", 6,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Horde_Completed_Construction_Project ]]--

function Trigger_General_Horde_Completed_Construction_Project_impl (context)
		return context:character():has_military_force() and context:character():faction():is_horde()
end 

events.CharacterBuildingCompleted[#events.CharacterBuildingCompleted+1] =
function (context)
	if Trigger_General_Horde_Completed_Construction_Project_impl(context) then
		effect.add_agent_experience("Trigger_General_Horde_Completed_Construction_Project", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_General_Settlement_Captured ]]--

function Trigger_General_Settlement_Captured_impl (context)
		return true
end 

events.GarrisonOccupiedEvent[#events.GarrisonOccupiedEvent+1] =
function (context)
	if Trigger_General_Settlement_Captured_impl(context) then
		effect.add_agent_experience("Trigger_General_Settlement_Captured", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Governor_Character_Governing ]]--

function Trigger_Governor_Character_Governing_impl (context)
		return context:character():has_region() and context:character():region():has_governor() and context:character():region():governor() == context:character()
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Governor_Character_Governing_impl(context) then
		effect.add_agent_experience("Trigger_Governor_Character_Governing", 1,0, context)
		return true
	end
	return false
end

--[[ Trigger_Governor_Completed_Construction_Project ]]--

function Trigger_Governor_Completed_Construction_Project_impl (context)
		return context:character():has_region() and context:building():region():has_governor() and context:building():region():governor() == context:character()
end 

events.CharacterBuildingCompleted[#events.CharacterBuildingCompleted+1] =
function (context)
	if Trigger_Governor_Completed_Construction_Project_impl(context) then
		effect.add_agent_experience("Trigger_Governor_Completed_Construction_Project", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Politician_Character_Politicking ]]--

function Trigger_Politician_Character_Politicking_impl (context)
		return context:character():model():turn_number() > 1 and context:character():is_politician() and context:character():is_male()
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if Trigger_Politician_Character_Politicking_impl(context) then
		effect.add_agent_experience("Trigger_Politician_Character_Politicking", 0,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Attacking_Defeat ]]--

function Trigger_Secondary_General_Attacking_Defeat_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and ( context:character():model():pending_battle():attacker_battle_result()=="close_defeat" or context:character():model():pending_battle():attacker_battle_result()=="decisive_defeat" or context:character():model():pending_battle():attacker_battle_result()=="pyrrhic_victory" )
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Defeat_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Defeat", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Attacking_Defeat_Crushing ]]--

function Trigger_Secondary_General_Attacking_Defeat_Crushing_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="crushing_defeat"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Defeat_Crushing_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Defeat_Crushing", 1,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Attacking_Defeat_Valiant ]]--

function Trigger_Secondary_General_Attacking_Defeat_Valiant_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="valiant_defeat"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Defeat_Valiant_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Defeat_Valiant", 3,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Attacking_Victory ]]--

function Trigger_Secondary_General_Attacking_Victory_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and ( context:character():model():pending_battle():attacker_battle_result()=="close_victory" or context:character():model():pending_battle():attacker_battle_result()=="decisive_victory" or context:character():model():pending_battle():attacker_battle_result()=="valiant_defeat" )
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Victory_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Victory", 5,0, context)
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

--[[ Trigger_Secondary_General_Attacking_Victory_Pyrrhic ]]--

function Trigger_Secondary_General_Attacking_Victory_Pyrrhic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():attacker():won_battle() and context:character():model():pending_battle():attacker_battle_result()=="pyrrhic_victory"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Attacking_Victory_Pyrrhic_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Attacking_Victory_Pyrrhic", 3,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Defending_Defeat ]]--

function Trigger_Secondary_General_Defending_Defeat_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and ( context:character():model():pending_battle():defender_battle_result()=="close_defeat" or context:character():model():pending_battle():defender_battle_result()=="decisive_defeat" or context:character():model():pending_battle():defender_battle_result()=="pyrrhic_victory" )
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Defeat_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Defeat", 2,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Defending_Defeat_Crushing ]]--

function Trigger_Secondary_General_Defending_Defeat_Crushing_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="crushing_defeat"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Defeat_Crushing_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Defeat_Crushing", 1,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Defending_Defeat_Valiant ]]--

function Trigger_Secondary_General_Defending_Defeat_Valiant_impl (context)
		return not context:character():won_battle() and not context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="valiant_defeat"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Defeat_Valiant_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Defeat_Valiant", 3,0, context)
		return true
	end
	return false
end

--[[ Trigger_Secondary_General_Defending_Victory ]]--

function Trigger_Secondary_General_Defending_Victory_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and ( context:character():model():pending_battle():defender_battle_result()=="close_victory" or context:character():model():pending_battle():defender_battle_result()=="decisive_victory" or context:character():model():pending_battle():defender_battle_result()=="valiant_defeat" )
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Victory_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Victory", 5,0, context)
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

--[[ Trigger_Secondary_General_Defending_Victory_Pyrrhic ]]--

function Trigger_Secondary_General_Defending_Victory_Pyrrhic_impl (context)
		return context:character():won_battle() and context:character():model():pending_battle():defender():won_battle() and context:character():model():pending_battle():defender_battle_result()=="pyrrhic_victory"
end 

events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	if Trigger_Secondary_General_Defending_Victory_Pyrrhic_impl(context) then
		effect.add_agent_experience("Trigger_Secondary_General_Defending_Victory_Pyrrhic", 3,0, context)
		return true
	end
	return false
end

