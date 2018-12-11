
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
--# _playerNewRegions: map<string, vector<string>>,
--# _aiNewRegions: map<string, vector<string>>
--# }
--this could probably become a millitary force object
--# assume global class UEM








_G.traits_localized_content = {} --:map<string, string>




