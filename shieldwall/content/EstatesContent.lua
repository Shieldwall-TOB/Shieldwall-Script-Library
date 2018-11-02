local et = _G.et

local starting_estates = {
    vik_reg_na_seciri = true,
    vik_reg_theodford = true,
    vik_reg_cair_segeint = true,
    vik_reg_oxnaforda = true,
    vik_reg_cenannas = true,
    vik_reg_doneceaster = true,
    vik_reg_bathanceaster = true,
    vik_reg_scireburnan = true,
    vik_reg_staefford = false,
    vik_reg_dun_eachainn = false,
    vik_reg_ethandun = false,
    vik_reg_suthhamtun = false,
    vik_reg_wiht = false,
    vik_reg_waecet = false,
    vik_reg_sceaftesburg = false,
    vik_reg_cissanbyrig = false,
    vik_reg_brug = false,
    vik_reg_ardach = false,
    vik_reg_dear = false,
    vik_reg_rinnin = false,
    vik_reg_celmeresfort = false,
    vik_reg_sancte_albanes = false,
    vik_reg_domuc = false,
    vik_reg_inis_patraic = false,
    vik_reg_eofesham = false,
    vik_reg_glastingburi = false,
    vik_reg_licetfelda = false
} --:map<string, boolean>


cm:register_first_tick_callback( function()
    if cm:is_new_game() then
        for key, value in pairs(starting_estates) do
            et:create_start_pos_estate(key, value)
        end
    end
end)