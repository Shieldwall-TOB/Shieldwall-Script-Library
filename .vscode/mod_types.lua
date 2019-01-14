--[[Class definitions]]
--# assume global class PKM
    --# assume global class FACTION_DETAIL
        --# assume global class CHARACTER_DETAIL
            --# assume global class RECRUITER
            --# assume global class UNIT_EFFECTS_MANAGER
        --# assume global class PROVINCE_DETAIL
            --# assume global class POP_MANAGER
        --# assume global class FOOD_MANAGER
        --# assume global class PERSONALITY_MANAGER
    --# assume global class REGION_DETAIL
        --# assume global class ESTATE_DETAIL
        --# assume global class OWNERSHIP_TRACKER

--[[Enumerations]]
--# type global POP_CASTE = "serf" | "lord" | "monk" | "foreign" 
--# type global ESTATE_TYPE = "vik_estate_agricultural" | "vik_estate_estate_building" | "vik_estate_estate_building"
--# type global START_POS_ESTATE = {_region: string, _ownerName: string, _estateBuilding: string, _estateChain: string, _faction: string}
-- // \\                //\\    Rural Estates         //\\    Commercial Estates //  \\      //  Church Estates //\\

--[[Content]]
_G.traits_localized_content = {} --:map<string, string>


--[[UI Types]]



--# type global BUTTON_TYPE = "" | " "



--# assume global class SHIELD_UI
