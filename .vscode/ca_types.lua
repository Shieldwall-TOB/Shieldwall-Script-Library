--class declarations\
--# assume global class _G
--# assume global class CM
--# assume global class CA_EFFECT
--# assume global class CA_SCRIPT
--# assume global class CA_GAME
--# assume global class CA_EVENT_HANDLER
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
--# assume global class CA_ESTATE
--UI types
--# assume global class CA_UIC
--# assume global class CA_Component
--# assume global class CA_UIContext
--Fake types
--# assume global class CA_CQI
--# assume global class CA_CONTEXT
--# type global BUTTON_STATE = 
--# "active" | "hover" | "down" | 
--# "selected" | "selected_hover" | "selected_down" |
--# "drop_down"


--# type global BATTLE_SIDE =
--# "Attacker" | "Defender" 

--# type global CA_MARKER_TYPE = 
--# "pointer" | "move_to_vfx" | "look_at_vfx" | "tutorial_marker"


-- CONTEXT
--# assume CA_UIContext.component: CA_Component
--# assume CA_UIContext.string: string

-- UIC
--# assume CA_UIC.Address: method() --> CA_Component
--# assume CA_UIC.Adopt: method(pointer: CA_Component)
--# assume CA_UIC.Divorce: method(pointer: CA_Component)
--# assume CA_UIC.ChildCount: method() --> number
--# assume CA_UIC.ClearSound: method()
--# assume CA_UIC.CreateComponent: method(name: string, path: string)
--# assume CA_UIC.CurrentState: method() --> BUTTON_STATE
--# assume CA_UIC.DestroyChildren: method()
--# assume CA_UIC.Dimensions: method() --> (number, number)
--# assume CA_UIC.Find: method(arg: number | string) --> CA_Component
--# assume CA_UIC.GetTooltipText: method() --> string
--# assume CA_UIC.Id: method() --> string
--# assume CA_UIC.MoveTo: method(x: number, y: number)
--# assume CA_UIC.Parent: method() --> CA_Component
--# assume CA_UIC.Position: method() --> (number, number)
--# assume CA_UIC.Resize: method(w: number, h: number)
--# assume CA_UIC.SetInteractive: method(interactive: boolean)
--# assume CA_UIC.SetOpacity: method(opacity: number)
--# assume CA_UIC.SetState: method(state: BUTTON_STATE)
--# assume CA_UIC.SetStateText: method(text: string)
--# assume CA_UIC.SetVisible: method(visible: boolean)
--# assume CA_UIC.SetDisabled: method(disabled: boolean)
--# assume CA_UIC.ShaderTechniqueSet: method(technique: string | number, unknown: boolean)
--# assume CA_UIC.ShaderVarsSet: method(p1: number, p2: number, p3: number, p4: number, unknown: boolean)
--# assume CA_UIC.SimulateClick: method()
--# assume CA_UIC.SimulateMouseOn: method()
--# assume CA_UIC.Visible: method() --> boolean
--# assume CA_UIC.SetImage: method(path: string)
--# assume CA_UIC.SetTooltipText: method(tooltip: string, state: boolean?)
--# assume CA_UIC.GetStateText: method() --> string
--# assume CA_UIC.PropagatePriority: method(priority: number)
--# assume CA_UIC.Priority: method() --> number
--# assume CA_UIC.Bounds: method() --> (number, number)
--# assume CA_UIC.Height: method() --> number
--# assume CA_UIC.Width: method() --> number
--# assume CA_UIC.SetImageRotation:  method(unknown: number, rotation: number)
--# assume CA_UIC.ResizeTextResizingComponentToInitialSize: method(width: number, height: number)
--# assume CA_UIC.SimulateLClick: method()
--# assume CA_UIC.SimulateKey: method(keyString: string)

--event handler
--# assume CA_EVENT_HANDLER.add_listener: method(
    --# Name: string,
    --# EventName: string,
    --# Conditional: (function(context: WHATEVER) --> boolean) |  boolean,
    --# Callback: function(context: WHATEVER),
    --# Persist: boolean)
--# assume CA_EVENT_HANDLER.remove_listener: method(handler: string)
--# assume CA_EVENT_HANDLER.trigger_event: method(name: string, any...)

--CM
--interfaces
--# assume CM.model: method() --> CA_MODEL
--# assume CM.scripting: CA_SCRIPT
--scripting
--# assume CM.add_listener: method(
    --# Name: string,
    --# EventName: string,
    --# Conditional: (function(context: CA_CONTEXT) --> boolean) |  boolean,
    --# Callback: function(context: CA_CONTEXT),
    --# Persist: boolean)
--# assume CM.remove_listener: method(handler: string)
--# assume CM.register_ui_created_callback: method( function() )
--# assume CM.register_first_tick_callback: method(function())
--# assume CM.random_number: method(range: number, min: number?) --> int
--saving
--# assume CM.is_new_game: method() --> boolean
--# assume CM.set_saved_value: method(valueKey: string, value: any)
--# assume CM.get_saved_value: method(valueKey: string) --> WHATEVER
--# assume CM.register_loading_game_callback: method(function(context: WHATEVER))
--# assume CM.load_value: method(name: string, default: any, context: WHATEVER) --> WHATEVER
--# assume CM.register_saving_game_callback:method(function(context: WHATEVER))
--# assume CM.save_value: method(name: string, value: any, context: WHATEVER)
--# assume CM.game_interface_created: boolean
--------------------------
--game interface commands
--ui
--# assume CM.ui_root: method() --> CA_UIC
--effect bundles
--# assume CM.apply_effect_bundle_to_region: method(bundle: string, region: string, turns: number)
--# assume CM.remove_effect_bundle_from_region: method(bundle: string, region: string)
--# assume CM.apply_effect_bundle_to_characters_force: method(bundleKey: string, charCqi: CA_CQI, turns: number, useCommandQueue: boolean)
--# assume CM.remove_effect_bundle_from_characters_force: method(bundleKey: string, charCqi: CA_CQI)
--# assume CM.apply_effect_bundle: method(bundle: string, faction: string, timer: int)
--# assume CM.remove_effect_bundle: method(bundle: string, faction: string)
--# assume CM.apply_effect_bundle_to_force: method(bundle: string, mfcqi: CA_CQI, turns: number)
--# assume CM.remove_effect_bundle_from_force: method(bundle: string, mfcqi: CA_CQI)

--factions
--# assume CM.get_local_faction: method(force: boolean?) --> string
--# assume CM.get_human_factions: method() --> vector<string>
--# assume CM.treasury_mod: method(faction_key: string, quantity: number)
--# assume CM.transfer_region_to_faction: method(region: string, faction: string)
--events
--# assume CM.trigger_incident: method(factionName: string, incidentKey: string, fireImmediately: boolean)
--# assume CM.trigger_dilemma: method(faction_key: string, dilemma_key: string, trigger_immediately: boolean)
--diplomacy
--# assume CM.force_make_vassal: method(master: string, vassal: string)
--# assume CM.force_diplomacy:  method(faction: string, other_faction: string, record: string, offer: boolean, accept: boolean)
--# assume CM.force_declare_war: method(declarer: string, declaree: string)
--# assume CM.force_make_peace: method(faction: string, other_faction: string)
--# assume CM.grant_faction_handover: method(absorber: string, absorbed: string, first_turn: number, last_turn: number, context: WHATEVER)
--characters
--# assume CM.set_character_immortality: method(lookup: string, immortal: boolean)
--# assume CM.force_add_skill: method(lookup: string, skill_key: string)
--# assume CM.force_add_trait: method(lookup: string, trait_key: string, showMessage: boolean)
--# assume CM.force_remove_trait: method(lookup: string, trait_key: string)
--technology
--# assume CM.lock_technology: method(faction: string, technology: string)
--# assume CM.unlock_technology: method(faction: string, technology: string)
--ai
--# assume CM.force_change_cai_faction_personality: method(key: string, personality: string)
--battles
--# assume CM.win_next_autoresolve_battle: method(faction: string)
--# assume CM.modify_next_autoresolve_battle: method(attacker_win_chance: number, defender_win_chance: number, attacker_losses_modifier: number, defender_losses_modifier: number, wipe_out_loser: boolean)
--shroud
--# assume CM.make_sea_region_seen_in_shroud: method(region: string) 
--# assume CM.make_region_seen_in_shroud: method(faction_key: string, region_key: string)

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
--# assume CA_MODEL.has_character_command_queue_index: method(CA_CQI) --> boolean
--# assume CA_MODEL.military_force_for_command_queue_index: method(CA_CQI) --> CA_FORCE
--# assume CA_MODEL.has_military_force_command_queue_index: method(CA_CQI) --> boolean
--# assume CA_MODEL.faction_for_command_queue_index: method(CA_CQI) --> CA_FACTION

--CA SCRIPT
--# assume CA_SCRIPT.game_interface: CA_GAME

--WORLD
--# assume CA_WORLD.faction_list: method() --> CA_FACTION_LIST
--# assume CA_WORLD.faction_by_key: method(faction_key: string) --> CA_FACTION
--# assume CA_WORLD.faction_exists: method(faction_key: string) --> boolean
--# assume CA_WORLD.region_manager: method() --> CA_REGION_MANAGER
--# assume CA_WORLD.ancillary_exists: method(ancillary_key: string)
--# assume CA_WORLD.whose_turn_is_it: method() --> string
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
--# assume CA_FACTION.is_vassal_of: method(faction: CA_FACTION) --> boolean
--# assume CA_FACTION.is_ally_vassal_or_client_state_of: method(faction: string) --> boolean
--# assume CA_FACTION.allied_with: method(faction: CA_FACTION) --> boolean
--# assume CA_FACTION.at_war_with: method(faction: CA_FACTION) --> boolean
--# assume CA_FACTION.region_list: method() --> CA_REGION_LIST
--# assume CA_FACTION.home_region: method() --> CA_REGION
--# assume CA_FACTION.command_queue_index: method() --> CA_CQI
--# assume CA_FACTION.is_null_interface: method() --> boolean
--# assume CA_FACTION.faction_leader: method() --> CA_CHAR
--# assume CA_FACTION.has_home_region: method() --> boolean
--# assume CA_FACTION.factions_at_war_with: method() --> CA_FACTION_LIST
--# assume CA_FACTION.total_food: method() --> number
--# assume CA_FACTION.has_food_shortage: method() --> boolean
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
--# assume CA_REGION.majority_religion: method() --> string
--# assume CA_REGION.majority_religion_percentage: method() --> number
--# assume CA_REGION.has_governor: method() --> boolean
--# assume CA_REGION.governor: method() --> CA_CHAR
--# assume CA_REGION.is_null_interface: method() --> boolean
--# assume CA_REGION.owning_faction: method() --> CA_FACTION
--# assume CA_REGION.slot_list: method() --> CA_SLOT_LIST
--# assume CA_REGION.is_province_capital: method() --> boolean
--# assume CA_REGION.building_exists: method(building: string) --> boolean
--# assume CA_REGION.resource_exists: method(resource_key: string) --> boolean
--# assume CA_REGION.building_superchain_exists: method(superchain_key: string) --> boolean
--# assume CA_REGION.any_resource_available: method() --> boolean
--# assume CA_REGION.adjacent_region_list: method() --> CA_REGION_LIST
--# assume CA_REGION.last_building_constructed_key: method() --> string
--# assume CA_REGION.slot_type_exists: method(key: string) --> boolean

--CA REGION LIST
--# assume CA_REGION_LIST.num_items: method() --> number
--# assume CA_REGION_LIST.item_at: method(i: number) --> CA_REGION


--CA GARRISON RESIDENCE
--# assume CA_GARRISON_RESIDENCE.region: method() --> CA_REGION
--# assume CA_GARRISON_RESIDENCE.faction: method() --> CA_FACTION
--# assume CA_GARRISON_RESIDENCE.is_under_siege: method() --> boolean
--# assume CA_GARRISON_RESIDENCE.settlement_interface: method() --> CA_SETTLEMENT
--# assume CA_GARRISON_RESIDENCE.army: method() --> CA_FORCE
--# assume CA_GARRISON_RESIDENCE.command_queue_index: method() --> CA_CQI
--# assume CA_GARRISON_RESIDENCE.unit_count: method() --> number
--CA SETTLEMENT
--# assume CA_SETTLEMENT.logical_position_x: method() --> number
--# assume CA_SETTLEMENT.logical_position_y: method() --> number
--# assume CA_SETTLEMENT.is_null_interface: method() --> boolean
--# assume CA_SETTLEMENT.faction: method() -->CA_FACTION
--# assume CA_SETTLEMENT.commander: method() --> CA_CHAR
--# assume CA_SETTLEMENT.has_commander: method() --> boolean
--# assume CA_SETTLEMENT.slot_list: method() --> CA_SLOT_LIST
--# assume CA_SETTLEMENT.region: method() --> CA_REGION
--SLOT LIST
--# assume CA_SLOT_LIST.num_items: method() --> number
--# assume CA_SLOT_LIST.item_at: method(index: number) --> CA_SLOT
--# assume CA_SLOT_LIST.slot_type_exists: method(slot_key: string) --> boolean
--# assume CA_SLOT_LIST.building_type_exists: method(building_key: string) --> boolean


--SLOT
--# assume CA_SLOT.has_building: method() --> boolean
--# assume CA_SLOT.building: method() --> CA_BUILDING
--# assume CA_SLOT.resource_key: method() --> string

--CA BUILDING
--# assume CA_BUILDING.name: method() --> string
--# assume CA_BUILDING.chain: method() --> string
--# assume CA_BUILDING.superchain: method() --> string
--# assume CA_BUILDING.faction: method() --> CA_FACTION
--# assume CA_BUILDING.region: method() --> CA_REGION
--CA ESTATE
--# assume CA_ESTATE.is_null_interface: method() --> boolean
--# assume CA_ESTATE.estate_record_key: method() --> string
--# assume CA_ESTATE.owner: method() --> CA_CHAR
--# assume CA_ESTATE.region: method() --> CA_REGION

--CA CHARACTER
--# assume CA_CHAR.has_trait: method(traitName: string) --> boolean
--# assume CA_CHAR.logical_position_x: method() --> number
--# assume CA_CHAR.logical_position_y: method() --> number
--# assume CA_CHAR.display_position_x: method() --> number
--# assume CA_CHAR.display_position_y: method() --> number
--# assume CA_CHAR.character_subtype_key: method() --> string
--# assume CA_CHAR.region: method() --> CA_REGION
--# assume CA_CHAR.faction: method() --> CA_FACTION
--# assume CA_CHAR.has_military_force: method() --> boolean
--# assume CA_CHAR.military_force: method() --> CA_FORCE
--# assume CA_CHAR.character_subtype: method(subtype: string) --> boolean
--# assume CA_CHAR.get_forename: method() --> string
--# assume CA_CHAR.get_surname: method() --> string
--# assume CA_CHAR.command_queue_index: method() --> CA_CQI
--# assume CA_CHAR.cqi: method() --> CA_CQI
--# assume CA_CHAR.rank: method() --> int
--# assume CA_CHAR.won_battle: method() --> boolean
--# assume CA_CHAR.battles_fought: method() --> number
--# assume CA_CHAR.is_wounded: method() --> boolean
--# assume CA_CHAR.is_faction_leader: method() --> boolean
--# assume CA_CHAR.family_member: method() --> CA_FAMILY
--# assume CA_CHAR.is_null_interface: method() --> boolean

--# assume CA_CHAR.loyalty: method() --> number
--# assume CA_CHAR.is_politician: method() --> boolean
--# assume CA_CHAR.gravitas: method() --> number
--# assume CA_CHAR.has_father: method() --> boolean
--# assume CA_CHAR.has_mother: method() --> boolean
--# assume CA_CHAR.mother: method() --> CA_FAMILY
--# assume CA_CHAR.father: method() --> CA_FAMILY
--# assume CA_CHAR.is_heir: method() --> boolean
--# assume CA_CHAR.is_minister: method() --> boolean

--CA CHAR LIST
--# assume CA_CHAR_LIST.item_at: method(i: number) --> CA_CHAR
--# assume CA_CHAR_LIST.num_items: method() --> number


-- CA FAMILY MEMBER
--# assume CA_FAMILY.is_null_interface: method() --> boolean
--# assume CA_FAMILY.come_of_age: method() --> boolean
--# assume CA_FAMILY.has_father: method() --> boolean
--# assume CA_FAMILY.has_mother: method() --> boolean
--# assume CA_FAMILY.mother: method() --> CA_FAMILY
--# assume CA_FAMILY.father: method() --> CA_FAMILY
--# assume CA_FAMILY.has_trait: method(trait_key: string) --> boolean

-- PENDING BATTLE
--# assume CA_PENDING_BATTLE.attacker: method() --> CA_CHAR
--# assume CA_PENDING_BATTLE.defender: method() --> CA_CHAR
--# assume CA_PENDING_BATTLE.ambush_battle: method() --> boolean

-- CA FORCE

--# assume CA_FORCE.general_character: method() --> CA_CHAR
--# assume CA_FORCE.has_general: method() --> boolean
--# assume CA_FORCE.unit_list: method() --> CA_UNIT_LIST
--# assume CA_FORCE.active_stance: method() --> string
--# assume CA_FORCE.command_queue_index: method() --> CA_CQI
--CA_FORCE_LIST
--# assume CA_FORCE_LIST.num_items: method() --> number
--# assume CA_FORCE_LIST.item_at: method(i: number) --> CA_FORCE

--CA UNIT
--# assume CA_UNIT.unit_key: method() --> string

--CA UNIT LIST
--# assume CA_UNIT_LIST.num_items: method() --> number
--# assume CA_UNIT_LIST.item_at: method(i: number) --> CA_UNIT
--# assume CA_UNIT_LIST.has_unit: method(string) --> boolean
--# assume CA_UNIT_LIST.is_empty: method() --> boolean

--CA CONTEXT
--# assume CA_CONTEXT.garrison_residence: method() --> CA_GARRISON_RESIDENCE
--# assume CA_CONTEXT.faction: method() --> CA_FACTION
--# assume CA_CONTEXT.proposer: method() --> CA_FACTION
--# assume CA_CONTEXT.recipient: method() --> CA_FACTION
--# assume CA_CONTEXT.character: method() --> CA_CHAR
--# assume CA_CONTEXT.component: CA_Component
--# assume CA_CONTEXT.string: string
--# assume CA_CONTEXT.dilemma: method() --> string
--# assume CA_CONTEXT.choice: method() --> number
--# assume CA_CONTEXT.estate: method() --> CA_ESTATE
--# assume CA_CONTEXT.region: method() --> CA_REGION
--# assume CA_CONTEXT.building: method() --> CA_BUILDING


--CA_EFFECT
--# assume CA_EFFECT.advance_scripted_advice_thread: function(key: string, prioritiy: number)
--# assume CA_EFFECT.add_agent_experience: function(trigger: string, exp: number, auth: number, context: CA_CONTEXT)


-- GLOBAL FUNCTIONS
-- COMMON
--# assume global get_eh: function() --> CA_EVENT_HANDLER
--# assume global get_events: function() --> map<string, vector<function(context:WHATEVER?)>>


--# assume global is_uicomponent: function(arg: any) --> boolean
--# assume global find_uicomponent: function(parent: CA_UIC, string...) --> CA_UIC
--# assume global find_uicomponent_by_table: function(uic: CA_UIC, path: vector<string>) --> CA_UIC
--# assume global UIComponent: function(pointer: CA_Component) --> CA_UIC
--# assume global uicomponent_to_str: function(uic: CA_UIC) --> string
--# assume global print_all_uicomponent_children: function(component: CA_UIC)
--# assume global output_uicomponent: function(uic: CA_UIC, omit_children: boolean)
--# assume global uicomponent_descended_from: function(uic: CA_UIC, parent_name: string) --> boolean
--# assume global output: function(text: string)
--# assume global script_error: function(text: string)

--# assume global is_string: function(arg: string) --> boolean
--# assume global is_table: function(arg: table) --> boolean
--# assume global is_number: function(arg: number) --> boolean
--# assume global is_function: function(arg: function) --> boolean
--# assume global is_boolean: function(arg: boolean) --> boolean
--# assume global add_callback: function(callback: function(), timer: number?, name: string?)
--# assume global char_lookup_str: function(CA_CHAR | CA_CQI) --> string

-- GLOBAL VARIABLES
--leave at the bottom of this file
--# assume global cm: CM
--# assume global effect: CA_EFFECT
--# assume global __write_output_to_logfile: boolean






