VAR_DEFENSIVE_BATTLES_ONLY = false
VAR_NEARBY_PLAYER_RESTRICTION = true
VAR_ENABLE_FOR_ALLIES = true
local events = get_events();
local VerboseLog = true

--v function(text: any)
local function MELOG(text)
    dev.log(tostring(text), "GK ")
end

local pkm = _G.pkm


--v function() --> vector<CA_FACTION>
local function GetPlayerFactions()
    local player_factions = {};
    local faction_list = cm:model():world():faction_list();
    for i = 0, faction_list:num_items() - 1 do
        local curr_faction = faction_list:item_at(i);
        if (curr_faction:is_human() == true) then
            table.insert(player_factions, curr_faction);
        end
    end
    return player_factions;
end;

--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;

--v function(players: vector<CA_FACTION>, force: CA_FORCE) --> boolean
local function CheckIfPlayerIsNearFaction(players, force)
    local result = false;
    local force_general = force:general_character();
    local radius = 20;
    for i,value in ipairs(players) do
        local player_force_list = value:military_force_list();
        local j = 0;
        while (result == false) and (j < player_force_list:num_items()) do
            local player_character = player_force_list:item_at(j):general_character();
            local distance = distance_2D(force_general:logical_position_x(), force_general:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y());
            result = (distance < radius);
            j = j + 1;
        end
    end
    return result;
end


--v function(players: vector<CA_FACTION>, faction: CA_FACTION) --> boolean
local function CheckIfFactionIsPlayersAlly(players, faction)
    local result = false;
    for i,value in pairs(players) do
        if (result == false) and (value:allied_with(faction)==true) then
            result = true;
        end
    end
    
    return result;
end

--v function(context: WHATEVER)
function evaluate_battle(context)
	local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
	local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
	local attacker_is_major = pkm:is_faction_kingdom(attacking_faction:name())
	local defender_is_major = pkm:is_faction_kingdom(defending_faction:name());
	local attacker_is_secondary = pkm:is_faction_vassal(attacking_faction:name());
	local defender_is_secondary = pkm:is_faction_vassal(defending_faction:name());
	local player_factions = GetPlayerFactions()
	MELOG("\n#### BATTLE ####\n"..attacking_faction:name().." v "..defending_faction:name());

	if attacking_faction:is_human() == false and defending_faction:is_human() == false then
		if defender_is_secondary == false and attacker_is_secondary == false then 
			if attacker_is_major == true and defender_is_major == false then
				MELOG("Major Attacker v Minor Defender");

				if VAR_DEFENSIVE_BATTLES_ONLY == false then
					--If the minor faction is the player's military ally, we don't give bonuses to the major faction
					local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction);
					
					if VAR_ENABLE_FOR_ALLIES == true then
						ally_involved = false;
					else
						MELOG("Ally Involved: "..tostring(ally_involved));
					end

					if ally_involved == false then
						--If any of the player's armies/navies is close to the battle, the major faction won't receive the bonuses
						local player_nearby = false;
						if VAR_NEARBY_PLAYER_RESTRICTION == true then
							player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():defender():military_force());
						end
						MELOG("Player Nearby: "..tostring(player_nearby));

						if player_nearby == false then
							--Arguments: attacker win chance, defender win chance, attacker losses modifier, defender losses modifier
							MELOG("Modified autoresolve for "..context:pending_battle():attacker():faction():name());
							cm:win_next_autoresolve_battle(context:pending_battle():attacker():faction():name());
							cm:modify_next_autoresolve_battle(1, 0, 1, 20, true);
						end
					end
				else
					MELOG("No autoresolve modification");
				end
			elseif attacker_is_major == false and defender_is_major == true then
				MELOG("Minor Attacker v Major Defender");

				--If the minor faction is the player's military ally, we don't give bonuses to the major faction
				local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction);
					
				if VAR_ENABLE_FOR_ALLIES == true then
					ally_involved = false;
				else
					MELOG("Ally Involved: "..tostring(ally_involved));
				end

				if ally_involved == false then
					--If any of the player's forces is close to the battle, the major faction won't receive the bonuses
					local player_nearby = false;
					if VAR_NEARBY_PLAYER_RESTRICTION == true then
						player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():attacker():military_force());
					end
					MELOG("Player Nearby: "..tostring(player_nearby));

					if player_nearby == false then
						MELOG("Modified autoresolve for "..context:pending_battle():defender():faction():name());
							cm:win_next_autoresolve_battle(context:pending_battle():defender():faction():name());
						cm:modify_next_autoresolve_battle(0, 1, 20, 1, true);
					end;
				end
			elseif attacker_is_major == true and defender_is_major == true then
				MELOG("Major Attacker v Major Defender");
			elseif attacker_is_major == false and defender_is_major == false then
				MELOG("Minor Attacker v Minor Defender\nNo autoresolve modification");
			end
		else 
			MELOG("Secondary Defender \nNo autoresolve modification");
		end
	end
end;
	



events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function(context)
	if context:character():model():pending_battle():has_defender() and context:character():model():pending_battle():defender():cqi() == context:character():cqi() then
		-- The character is the Defender
		local result = context:character():model():pending_battle():defender_battle_result();

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			MELOG("GREAT KINGDOMS:-- Result --\n\t\t"..context:character():faction():name().." Won! ("..result..")");
		end;
	elseif context:character():model():pending_battle():has_attacker() and context:character():model():pending_battle():attacker():cqi() == context:character():cqi() then
		-- The character is the Attacker
		local result = context:character():model():pending_battle():attacker_battle_result();

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			MELOG("GREAT KINGDOMS:-- Result --\n\t\t"..context:character():faction():name().." Won! ("..result..")");
		end;
	end;
end;





cm:add_listener(
    "GuarenteedEmpires",
    "PendingBattle",
    true,
    function(context) evaluate_battle(context) end,
    true);

