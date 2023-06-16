  clear;

% Input parameters
  csv_name = 'ss.csv';
  file_name = 'ss';
  opto_info = '10HZ';
  t_pre = 500;
  dur = 2000;
  t_post = 1000; %4500 for 1Hz;2500 for 2Hz; otherwise 1000

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
% Detection opto edge
  opto = find_trg_pks([adc(1).v],0.5,t,dur);
% Calculte PSTH
   Copto = locs_vfy(0,opto,{0});
   [Opsth,Otas] = psth_calc(spk,Copto,50,5,t_pre,t_post);
   Clocs = Copto;
% Cell modulation detection
  mod_tp = cell_mod_detn(Opsth,[-500 0],[0 250],[0 250]); %baseline, mod detection, onset detection
% Saving   
   saca_pack = dat_out_opto_ephys(file_name,t_pre,ctp,Opsth,mod_tp,Otas,opto_info);
% plot PSTH
  for i=1:size(mod_tp,2)
     figure(i)
     plot(saca_pack.SPK(i).tr)
     title(saca_pack.cell_def(i).mod)
  end
  