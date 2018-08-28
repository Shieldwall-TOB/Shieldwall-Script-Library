--class declarations
--# assume global class CM
--# assume global class CA_WORLD
--# assume global class CA_MODEL
--# assume global class CA_FACTION
--# assume global class CA_FACTION_LIST
--# assume global class CA_CHAR
--# assume global class CA_CHAR_LIST
--# assume global class CA_FAMILY
--# assume global class CA_REGION_MANAGER
--# assume global class CA_REGION
--# assume global class CA_REGION_LIST
--# assume global class CA_GARRISON_RESIDENCE
--# assume global class CA_SETTLEMENT
--# assume global class CA_SLOT
--# assume global class CA_SLOT_LIST
--# assume global class CA_BUILDING
--# assume global class CA_BUILDING_LIST
--# assume global class CA_FORCE
--# assume global class CA_FORCE_LIST
--# assume global class CA_FORCE_BUILDING
--# assume global class CA_FORCE_BUILDING_LIST
--# assume global class CA_UNIT
--# assume global class CA_UNIT_LIST
--# assume global class CA_PENDING_BATTLE
--# assume global class CA_MISSION
--# assume global class CA_AI
--UI types
--# assume global class CA_UIC
--# assume global class CA_Component
--# assume global class CA_UIContext
--Fake types
--# assume global class CA_CQI



--CM
--# assume CM.model: method() --> CA_MODEL








--MODEL
--# assume CA_MODEL.world: method() --> CA_WORLD
--# assume CA_MODEL.pending_battle: method() --> CA_PENDING_BATTLE
--# assume CA_MODEL.is_multiplayer: method() --> boolean
--# assume CA_MODEL.turn_number: method() --> number
--# assume CA_MODEL.is_player_turn: method() --> number
--# assume CA_MODEL.difficulty_level: method() --> number
--# assume CA_MODEL.campaign_ai: method() --> CA_AI
--# assume CA_MODEL.season: method() --> number
--# assume CA_MODEL.character_for_command_queue_index: method(CA_CQI) --> CA_CHAR
--# assume CA_MODEL.military_force_for_command_queue_index: method(CA_CQI) --> CA_FORCE
--# assume CA_MODEL.faction_for_command_queue_index: method(CA_CQI) --> CA_FACTION

--WORLD
--# assume CA_WORLD.faction_list: method() --> CA_FACTION_LIST
--# assume CA_WORLD.faction_by_key: method(faction_key: string) --> CA_FACTION
--# assume CA_WORLD.faction_exists: method(faction_key: string) --> boolean
--# assume CA_WORLD.CA_REGION_MANAGER: method() --> CA_REGION_MANAGER
--# assume CA_WORLD.ancillary_exists: method(ancillary_key: string)

--REGION MANAGER
--# assume CA_REGION_MANAGER.region_list: method() --> CA_REGION_LIST
--# assume CA_REGION_MANAGER.region_by_key: method(region_key: string) --> CA_REGION

--CA FACTION
--# assume CA_FACTION.character_list: method() --> CA_CHAR_LIST
--# assume CA_FACTION.treasury: method() --> number
--# assume CA_FACTION.name: method() --> string
--# assume CA_FACTION.subculture: method() --> string
--# assume CA_FACTION.culture: method() --> string
--# assume CA_FACTION.military_force_list: method() --> CA_FORCE_LIST
--# assume CA_FACTION.is_human: method() --> boolean
--# assume CA_FACTION.is_dead: method() --> boolean
--# assume CA_FACTION.is_vassal_of: method(faction: string) --> boolean
--# assume CA_FACTION.is_vassal: method() --> boolean
--# assume CA_FACTION.is_ally_vassal_or_client_state_of: method(faction: string) --> boolean
--# assume CA_FACTION.allied_with: method(faction: CA_FACTION)
--# assume CA_FACTION.at_war_with: method(faction: CA_FACTION) --> boolean
--# assume CA_FACTION.region_list: method() --> CA_REGION_LIST
--# assume CA_FACTION.has_effect_bundle: method(bundle:string) --> boolean
--# assume CA_FACTION.home_region: method() --> CA_REGION
--# assume CA_FACTION.command_queue_index: method() --> CA_CQI
--# assume CA_FACTION.is_null_interface: method() --> boolean
--# assume CA_FACTION.faction_leader: method() --> CA_CHAR
--# assume CA_FACTION.has_home_region: method() --> boolean
--# assume CA_FACTION.factions_met: method() --> CA_FACTION_LIST
--# assume CA_FACTION.factions_at_war_with: method() --> CA_FACTION_LIST
--# assume CA_FACTION.total_food: method() --> number
--# assume CA_FACTION.state_religion: method() --> string
--# assume CA_FACTION.state_religion_percentage: method() --> number
--# assume CA_FACTION.mercenary_pool: method() --> WHATEVER

-- FACTION LIST
--# assume CA_FACTION_LIST.num_items: method() --> number
--# assume CA_FACTION_LIST.item_at: method(index: number) --> CA_FACTION
--# assume CA_FACTION_LIST.is_empty: method() --> boolean



--CA REGION
--# assume CA_REGION.settlement: method() --> CA_SETTLEMENT
--# assume CA_REGION.garrison_residence: method() --> CA_GARRISON_RESIDENCE
--# assume CA_REGION.name: method() --> string
--# assume CA_REGION.province_name: method() --> string
--# assume CA_REGION.public_order: method() --> number
--# assume CA_REGION.is_null_interface: method() --> boolean
--# assume CA_REGION.is_abandoned: method() --> boolean
--# assume CA_REGION.owning_faction: method() --> CA_FACTION
--# assume CA_REGION.slot_list: method() --> CA_SLOT_LIST
--# assume CA_REGION.is_province_capital: method() --> boolean
--# assume CA_REGION.building_exists: method(building: string) --> boolean
--# assume CA_REGION.resource_exists: method(resource_key: string) --> boolean
--# assume CA_REGION.any_resource_available: method() --> boolean
--# assume CA_REGION.adjacent_region_list: method() --> CA_REGION_LIST

--CA SETTLEMENT
--# assume CA_SETTLEMENT.logical_position_x: method() --> number
--# assume CA_SETTLEMENT.logical_position_y: method() --> number
--# assume CA_SETTLEMENT.is_null_interface: method() --> boolean
--# assume CA_SETTLEMENT.faction: method() -->CA_FACTION
--# assume CA_SETTLEMENT.commander: method() --> CA_CHAR
--# assume CA_SETTLEMENT.has_commander: method() --> boolean
--# assume CA_SETTLEMENT.slot_list: method() --> CA_SLOT_LIST
--# assume CA_SETTLEMENT.is_port: method() --> boolean
--# assume CA_SETTLEMENT.region: method() --> CA_REGION





--CA CHARACTER


-- GLOBAL FUNCTIONS
-- COMMON
--# assume global find_uicomponent: function(parent: CA_UIC, string...) --> CA_UIC
--# assume global UIComponent: function(pointer: CA_Component) --> CA_UIC
--# assume global find_uicomponent_from_table: function(root: CA_UIC, findtable: vector<string>) --> CA_UIC
--# assume global uicomponent_descended_from: function(root: CA_UIC, parent_name: string) --> boolean


--# assume global is_string: function(arg: string) --> boolean
--# assume global is_table: function(arg: table) --> boolean
--# assume global is_number: function(arg: number) --> boolean
--# assume global is_function: function(arg: function) --> boolean
--# assume global is_boolean: function(arg: boolean) --> boolean









