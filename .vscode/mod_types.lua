
--should become the defacto faction object
--# assume global class FKM
--# assume global class FKM_KINGDOM
--# assume global class FKM_VASSAL
--# assume global class FKM_STATE


--defacto character management objects
--# assume global class CHAR_MANAGER
--# assume global class CHAR_DETAIL
--# type global CHAR_SAVE = {_currentTitle: string, _homeEstate: string , _cqi: string}

--should probably be rolled together with RWM and ROT to become a single region object
--# assume global class ET
--# assume global class ESTATE
--# type global ESTATE_SAVE = {
--# _faction: string, _region: string, _type: string, _cqi: string, _isRoyal: boolean, _turnGranted: string, _lastBundle: string
--#}
--# assume CA_CONTEXT.shield_estate: method() --> ESTATE
--# assume global class RWM

--# assume global class ROT
--# type global ROT_SAVE = {
--# _owners: map<string, string>,
--# _pastOwners: map<string, map<string, number>>,
--# _playerNewRegions: map<string, vector<string>>
--# }
--this could probably become a millitary force object
--# assume global class UEM















--UI
--# assume global class LOG
--# assume global class BUTTON
--# assume global class TEXT
--# assume global class IMAGE
--# assume global class TEXT_BUTTON
--# assume global class FRAME
--# assume global class TEXT_BOX
--# assume global class LIST_VIEW
--# assume global class DUMMY
--# assume global class UTIL
--# assume global class COMPONENTS

--# type global COMPONENT_TYPE = 
--# TEXT | IMAGE | BUTTON | TEXT_BUTTON | FRAME | TEXT_BOX | LIST_VIEW | DUMMY

--# type global BUTTON_TYPE = 
--# "CIRCULAR" | "SQUARE"

--# type global TEXT_BUTTON_TYPE = 
--# "TEXT" 

--# type global TEXT_TYPE = 
--# "NORMAL" | "WRAPPED" | "TITLE" | "HEADER"
--# assume BUTTON.GetContentComponent: method() --> CA_UIC
--# assume BUTTON.GetPositioningComponent: method() --> CA_UIC
--# assume global class CONTAINER
--# assume global class GAP
--# assume global class FLOW_LAYOUT
--# type global LAYOUT = FLOW_LAYOUT
--# type global FLOW_LAYOUT_TYPE = "VERTICAL" | "HORIZONTAL"
--# type global LIST_SCROLL_DIRECTION = "VERTICAL" | "HORIZONTAL"
--# assume global Log: LOG
--# assume global Text: TEXT
--# assume global Image: IMAGE
--# assume global Button: BUTTON
--# assume global TextButton: TEXT_BUTTON
--# assume global Frame: FRAME
--# assume global TextBox: TEXT_BOX
--# assume global ListView: LIST_VIEW
--# assume global Util: UTIL
--# assume global FlowLayout: FLOW_LAYOUT
--# assume global Dummy: DUMMY
--# assume global Container: CONTAINER
--# assume global TABLES: map<string, map<string, WHATEVER>>
--# assume global write_log: boolean