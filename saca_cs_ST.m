%-------------For PC complex spike analysis ----------%
clear spk
% Input parameters
  pack_name = 'CS';
  t_pre = 500;
  dur = 1000;
  t_post = 1000;
  frequency_parameters.amplifier_sample_rate = 20000;
  ctp = struct('nr',[],'type',[]);
  ctp(1).nr = 4; ctp(1).type = 'CS'
%   ctp(2).nr = 2; ctp(2).type = 'CS'  %-----------let op dit lijn--------%
%   ctp(3).nr = 3; ctp(3).type = 'CS'  %-----------let op dit lijn--------%
% Import CSV file from SpikeTrain
  load('cs4.mat');
  save_SpikeTrain_chanEvent(cs4,'dat_in');
  spk(1) = struct('nr',0,'t',[]);
  spk(2) = struct('nr',4,'t',dat_in);
%   load('cs2.mat');
%   save_SpikeTrain_chanEvent(cs2,'dat_in');
%   spk(3) = struct('nr',2,'t',dat_in);
%   load('cs3.mat');
%   save_SpikeTrain_chanEvent(cs3,'dat_in');
%   spk(4) = struct('nr',3,'t',dat_in);
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