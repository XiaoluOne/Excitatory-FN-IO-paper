
function saca_pack = dat_out_saca_ephys(filename,t_pre,cell_tp,saca,psth,cell_mod,tas,saca_raw)
  t_pre = t_pre / 1000;

  % ------  CELL TYPE related data  ------
    cell_def(size(cell_tp,2)) = struct();
    for i = 1:size(cell_tp,2)
        cell_def(i).nr = psth.naso(i).cell;
        cell_def(i).type = cell_tp(i).type;
        cell_def(i).naso_mod = cell_mod.naso(i).type;
        cell_def(i).tempo_mod = cell_mod.tempo(i).type;
    end
  
  % ------  TIME related data  ------
      fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
      t_nr = 1500; 
      t_min = - t_pre;
      t_max = t_min + (t_nr - 1) / fs;
      t = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules

  % ------  PSTH related data  ------
      freq_wfm(size(cell_mod.naso,2)) = struct();
      for i = 1:size(cell_mod.naso,2)
        % Smoothing frequency line
          freq_x_naso = linspace(min([psth.naso(i).bar.bin]),max([psth.naso(i).bar.bin]),t_nr);
          freq_tr_naso = interp1([psth.naso(i).bar.bin],[psth.naso(i).bar.h],freq_x_naso,'spline');
          freq_x_tempo = linspace(min([psth.tempo(i).bar.bin]),max([psth.tempo(i).bar.bin]),t_nr);
          freq_tr_tempo = interp1([psth.tempo(i).bar.bin],[psth.tempo(i).bar.h],freq_x_tempo,'spline');
        % Arranging data
          freq_wfm(i).nr = psth.naso(i).cell;
          freq_wfm(i).tr_naso = freq_tr_naso;
          freq_wfm(i).tr_tempo = freq_tr_tempo;
          
      end
   % ------  TRIAL TO TRIAL REGRESSION data  ------
        TTT(size(cell_mod.naso,2)) = struct();
        for i = 1:size(cell_mod.naso,2)
            TTT(i).nr = psth.naso(i).cell;
            TTT(i).naso_tss = tas.naso(i).tss; 
            TTT(i).tempo_tss = tas.tempo(i).tss; 
        end

  % ------ Saving data  ------
    saca_pack = struct('t',t,'cell_def',cell_def,'SACA',saca,'SPK',freq_wfm,'TTT',TTT,'saca_raw',saca_raw);
    cd(pwd);
    filename = strcat('sacapack_',filename,'.mat');
    save(filename,'saca_pack');
end