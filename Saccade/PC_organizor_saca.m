%---Put SS and CS from the same PC in one package, for saca experiment---
clear
file_name = 'saca8_210602_140003';
load('sacapack_SS');
%--------------------------------------%
PC = struct()
for i = 1:size(saca_pack.cell_def,2)
    PC(i).nr = i;
    PC(i).type = saca_pack.cell_def(i).type;
    PC(i).SS_mod.naso = saca_pack.cell_def(i).naso_mod;
    PC(i).SS_mod.tempo = saca_pack.cell_def(i).tempo_mod;
    PC(i).SS_tr.naso = saca_pack.SPK(i).tr_naso;
    PC(i).SS_tr.tempo = saca_pack.SPK(i).tr_tempo;
    PC(i).SS_PSTH.naso = [];
    PC(i).SS_PSTH.tempo = [];
    PC(i).SS_TTT.naso = saca_pack.TTT(i).naso_tss;
    PC(i).SS_TTT.tempo = saca_pack.TTT(i).tempo_tss;
    PC(i).SACA.naso = saca_pack.SACA.naso;
    PC(i).SACA.tempo = saca_pack.SACA.tempo;
    PC(i).SACA.raw = saca_pack.saca_raw;
end
load('sacapack_CS');
for i = 1:size(saca_pack.cell_def,2)
    for j = 1:size(PC,2)
       if isequal(saca_pack.cell_def(i).nr,PC(j).nr)
           PC(j).CS_mod.naso = saca_pack.cell_def(i).naso_mod;
           PC(j).CS_mod.tempo = saca_pack.cell_def(i).tempo_mod;
           PC(j).CS_tr.naso = saca_pack.SPK(i).tr_naso;
           PC(j).CS_tr.tempo = saca_pack.SPK(i).tr_tempo;
           PC(j).CS_PSTH.naso = [];
           PC(j).CS_PSTH.tempo = [];
           PC(j).CS_TTT.naso = saca_pack.TTT(i).naso_tss;
           PC(j).CS_TTT.tempo = saca_pack.TTT(i).tempo_tss;
       else   
       end
    end
end

clear saca_pack
saca_pack = PC;
save(file_name,'saca_pack');