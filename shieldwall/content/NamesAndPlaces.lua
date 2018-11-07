--===============================
-- Historical City Information --
--===============================

--v function(text: any)
function NAPLOG(text)
    if not dev then
        return --designed for safe use outside of SW library
    end
    dev.log(tostring(text), "NAP")
end



region_intros_played = {
		["vik_reg_aberffro"] = 0, 
		["vik_reg_aberteifi"] = 0, 
		["vik_reg_achadh_bo"] = 0, 
		["vik_reg_aethelingaeg"] = 0, 
		["vik_reg_airchardan"] = 0, 
		["vik_reg_ard_macha"] = 0, 
		["vik_reg_bebbanburg"] = 0, 
		["vik_reg_blascona"] = 0, 
		["vik_reg_bornais"] = 0, 
		["vik_reg_cair_gwent"] = 0, 
		["vik_reg_caisil"] = 0,
		["vik_reg_cantwaraburg"] = 0,
		["vik_reg_carleol"] = 0,
		["vik_reg_cathair_commain"] = 0, 
		["vik_reg_ceaster"] = 0, 
		["vik_reg_cetretha"] = 0, 
		["vik_reg_cippanhamm"] = 0,
		["vik_reg_cluain_mac_nois"] = 0, 
		["vik_reg_colneceaster"] = 0,
		["vik_reg_corcach"] = 0,
		["vik_reg_din_prys"] = 0,
		["vik_reg_dinefwr"] = 0,
		["vik_reg_dofere"] = 0,
		["vik_reg_doreceaster"] = 0,
		["vik_reg_drayton"] = 0, 
		["vik_reg_druim_da_ethiar"] = 0, 
		["vik_reg_dun_att"] = 0, 
		["vik_reg_dun_beccan"] = 0, 
		["vik_reg_dun_cailden"] = 0, 
		["vik_reg_dun_foither"] = 0, 
		["vik_reg_dun_patraic"] = 0,
		["vik_reg_dun_sebuirgi"] = 0,
		["vik_reg_dyflin"] = 0,
		["vik_reg_earmutha"] = 0, 
		["vik_reg_eidenburg"] = 0, 
		["vik_reg_eoferwic"] = 0, 
		["vik_reg_exanceaster"] = 0,
		["vik_reg_gipeswic"] = 0, 
		["vik_reg_gleawceaster"] = 0,
		["vik_reg_grantabrycg"] = 0,
		["vik_reg_grianan_aileach"] = 0,
		["vik_reg_guvan"] = 0,
		["vik_reg_gyruum"] = 0,
		["vik_reg_haestingas"] = 0,
		["vik_reg_hlymrekr"] = 0,
		["vik_reg_inis_faithlenn"] = 0,
		["vik_reg_ioua"] = 0,
		["vik_reg_lindcylne"] = 0,
		["vik_reg_loidis"] = 0,
		["vik_reg_lunden"] = 0,
		["vik_reg_maeldune"] = 0, 
		["vik_reg_mameceaster"] = 0, 
		["vik_reg_mathrafal"] = 0, 
		["vik_reg_nas"] = 0, 
		["vik_reg_northhamtun"] = 0, 
		["vik_reg_northwic"] = 0, 
		["vik_reg_otergimele"] = 0, 
		["vik_reg_rath_cruachan"] = 0, 
		["vik_reg_rendlesham"] = 0, 
		["vik_reg_rofeceaster"] = 0,
		["vik_reg_scoan"] = 0,
		["vik_reg_seolesigge"] = 0,
		["vik_reg_snotingaham"] = 0, 
		["vik_reg_steanford"] = 0, 
		["vik_reg_suthhamtun"] = 0, 
		["vik_reg_tamworthige"] = 0,
		["vik_reg_tintagol"] = 0, 
		["vik_reg_tor_in_duine"] = 0,
		["vik_reg_vedrafjordr"] = 0,
		["vik_reg_veisafjordr"] = 0,
		["vik_reg_waerincwicum"] = 0,
		["vik_reg_werham"] = 0,
		["vik_reg_wintanceaster"] = 0
} --:map<string, int>

--v function(context: CA_CONTEXT)
local function OnSettlementSelected(context)
    local region_name = context:garrison_residence():region():name() --:string
    if region_intros_played[region_name] == nil then
        --we don't have a intro for this region
        return
    end
    if not cm:get_saved_value("region_intro_played_"..region_name) then
        NAPLOG("Playing region advice for ["..region_name.."] ")
        cm:set_saved_value("region_intro_played_"..region_name, true)
        effect.advance_scripted_advice_thread("Region.Intro." ..region_name,  1);
    end
end;

cm:add_listener(
    "NamesAndPlaces",
    "SettlementSelected",
    true,
    function(context)
        OnSettlementSelected(context)
    end,
    true
)

dev.add_settlement_selected_log(function(region)
	if region_intros_played[region:name()] == nil then
		return "Place has no registered name"
	else
		return "Place has a registered name"
	end
end)