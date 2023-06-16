% This code is based on saca_opto_sys with eye position calibrated 
% both X and Y of eye movement are saved 
clear;

% Input parameters
  t_pre = 500; %pre opto time
  t_post = 1000; %post opto time
  dur = 2000;
  f = 200; %camera frame rate
  sacafile ='250ms_optoDLC_resnet_50_SaccadeApr9shuffle1_1030000.csv';
  file_name = '250ms_saca_opto_230210_141712';
  opto_info = '250ms';
% Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
  t = seven_shorten(t,size(t,1),size(t,1)/100);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Detection trigger (opto and video) edges
  for i = 1:size(adc,2)
      v = [adc(i).v];
      %down sample trigger sampling rate as camera frame rate 200 fps
      adc(i).v = seven_shorten(v,size(adc(i).v,1),size(adc(i).v,1)/100);  
  end
  video = find_trg_pks([adc(1).v],0.5,t,dur);
  opto = find_trg_pks([adc(2).v],0.5,t,dur)-video(1);
% Saccade detection
  opts = detectImportOptions(sacafile);
  data = readtable(sacafile,opts);
% Calibration
  left(1) = mean(table2array(data(:,2))); %left x
  left(2) = mean(table2array(data(:,3))); %left y
  right(1) = mean(table2array(data(:,5))); %right x
  right(2) = mean(table2array(data(:,6))); %right y
  angle = 90-atan2(abs(left(1)-right(1)),abs(left(2)-right(2))); % caligrated angle 
  
  saca_tr(:,1) = smooth(table2array(data(:,8)));
  %/cos(angle); % x
  saca_tr(:,2) = smooth(table2array(data(:,9)));
  %*cos(angle)); % y
  t = [0.005:0.005:size(saca_tr,1)*0.005];
  saca = saca_detn(saca_tr,opto,t,t_pre,t_post,angle);
  
% Saccade parameters
  for i = 1:size(saca,2)
    saca(i).vel.x = diff(saca(i).tr(:,1))/0.005;
    saca(i).vel.y = diff(saca(i).tr(:,2))/0.005;
  end
%data organizing
    saca_pack.TTT = saca;
    saca_pack.raw = saca_tr;
%     saca_pack.tr = mean(tr');
    saca_pack.opto = opto_info;
% Saving   
   cd(pwd);
   file_name = strcat(file_name,'.mat');
   save(file_name,'saca_pack');
