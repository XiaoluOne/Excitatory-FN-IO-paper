  clear;

% Input parameters
  t_pre = 500;
  dur = 2000; 
  t_post = 1000;%4500 for 1Hz;2500 for 2Hz; otherwise 1000
  frequency_parameters.amplifier_sample_rate = 20000;
  ctp = struct('nr',[],'type',[]);
  opto_info = '250ms';
  name = 'cs';
  
  ctp(1).nr = 1; ctp(1).type = 'CS';
%   ctp(2).nr = 2; ctp(2).type = 'CS';  %-----------let op dit lijn--------%
%   ctp(3).nr = 4; ctp(3).type = 'CS'
  
% Load spike timings
  load('cs.mat');
  save_SpikeTrain_chanEvent(cs,'dat_in');
  spk(1) = struct('nr',0,'t',[]);
  spk(2) = struct('nr',1,'t',dat_in);
%   load('cs2.mat');  %-----------let op dit lijn--------%
%   save_SpikeTrain_chanEvent(cs2,'dat_in');%-----------let op dit lijn--------%
%   spk(3) = struct('nr',2,'t',dat_in);%-----------let op dit lijn--------%
%   load('cs3.mat');  %-----------let op dit lijn--------%
%   save_SpikeTrain_chanEvent(cs3,'dat_in');%-----------let op dit lijn--------%
%   spk(4) = struct('nr',4,'t',dat_in);%-----------let op dit lijn--------%

  % Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Detection opto edge
  opto = find_trg_pks([adc(1).v],0.5,t,dur);
% Calculte PSTH
   Copto = locs_vfy(0,opto,{0});
   [Opsth,Otas] = psth_calc(spk,Copto,50,5,t_pre,t_post);% there's sliding window
   Clocs = Copto;
%  Modulation detection
   mod_tp = cell_mod_detn(Opsth,[-500 0],[0 250],[0 250]); %baseline, mod detection, onset detection
 % Saving   
   sc_pack = dat_out_opto_ephys(name,t_pre,ctp,Opsth,mod_tp,Otas,opto_info);
% plot PSTH
  for i=1:size(mod_tp,2)
     figure(i)
     plot(sc_pack.SPK(i).tr)
     title(sc_pack.cell_def(i).mod)
  end
