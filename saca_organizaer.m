clear

nr = 0;
list = dir('*.mat');
for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (saca_pack.cell_def,2)
            nr = nr+1;
            saca_FN(nr).recording_ID = file_name; 
            saca_FN(nr).nr = nr;
            saca_FN(nr).mod_naso = saca_pack.cell_def(j).naso_mod;
            saca_FN(nr).mod_tempo = saca_pack.cell_def(j).tempo_mod;
            saca_FN(nr).spk_naso = saca_pack.SPK(j).tr_naso;
            saca_FN(nr).spk_tempo = saca_pack.SPK(j).tr_tempo;
            saca_FN(nr).saca_naso = saca_pack.SACA.naso;
            saca_FN(nr).saca_tempo = saca_pack.SACA.tempo;
            saca_FN(nr).ttt_naso = saca_pack.TTT(j).naso_tss;
            saca_FN(nr).ttt_tempo = saca_pack.TTT(j).tempo_tss;

    end
end

% Normalize spk to baseline

for i = 1:size(saca_FN,2)
    naso_bsl = mean(saca_FN(i).spk_naso(1:500));
    saca_FN(i).norm_spk_naso = saca_FN(i).spk_naso/naso_bsl*100;
    tempo_bsl = mean(saca_FN(i).spk_tempo(1:500));
    saca_FN(i).norm_spk_tempo = saca_FN(i).spk_tempo/tempo_bsl*100;
end