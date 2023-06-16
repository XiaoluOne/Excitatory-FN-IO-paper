%--------For FN and PC simple spike analysis-------%
clear;
% Input parameters
  csv_name = 'spk.csv';
  saca_file = 'saca8DLC_resnet_50_SaccadeApr9shuffle1_50000.csv';
  pack_name = 'SS';
  t_pre = 500;
  dur = 1000;
  t_post = 1000;
  diff_thre = 0.2; % temporal saccade threshold (differentiation, 0.2~0.5)
  
% Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Import CSV file from JRCLUST
  spk = import_jrc_csv(csv_name);
  ctp = import_ctp_csv('cell_tp.csv');
% Detection video edge
  video = find_trg_pks([adc(2).v],3,t,dur);
  loc_video = video(1);
% Find saccade timing, return behavior traces
  [saca_tempo,saca_naso,saca_raw] = saca_trigger(saca_file,diff_thre,loc_video); % call saccade finder code
% Assess saccade quality
figure(1)
title('naso')
  for i = 1:size(saca_naso,2)
      subplot(10,round(size(saca_naso,2)/10)+1,i)
      plot(saca_naso(i).tr)
      title(saca_naso(i).nr)
  end
  
  figure(2)
  title('tempo')
  for i = 1:size(saca_tempo,2)
      subplot(10,round(size(saca_tempo,2)/10)+1,i)
      plot(saca_tempo(i).tr)
      title(saca_tempo(i).nr)
  end
  
%---------------------------------------------------------------------------%
  close all %close all figures and continue
  saca.naso = saca_naso;
  saca.tempo = saca_tempo;
% Use saccade onset to trigger PSTH
  naso_t = extractfield(saca_naso,'onset_trigger')';
  Cnaso = locs_vfy(0,naso_t,{0});
  [PSTH.naso,Tas.naso] = psth_calc(spk,Cnaso,50,5,t_pre,t_post);
  tempo_t = extractfield(saca_tempo,'onset_trigger')';
  Ctempo = locs_vfy(0,tempo_t,{0});
  [PSTH.tempo,Tas.tempo] = psth_calc(spk,Ctempo,50,5,t_pre,t_post);
% Cell modulation detection
  Mod = struct('naso',[],'tempo',[]);
  Mod.naso = cell_mod_detn(PSTH.naso,[-500 0],[-100 100],[-100 100]); 
  Mod.tempo = cell_mod_detn(PSTH.tempo,[-500 0],[-100 100],[-100 100]);
% Saving   
  saca_pack = dat_out_saca_ephys(pack_name,t_pre,ctp,saca,PSTH,Mod,Tas,saca_raw);
% Plot PSTH 
  saca_psth_plot;
  saca_behv_plot;

