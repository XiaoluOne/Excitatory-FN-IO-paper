clear;

% Input parameters
  t_pre = 500; %pre opto time
  t_post = 1000; %post opto time
  dur = 2000;
  f = 200; %camera frame rate
  sacafile ='250ms_optoDLC_resnet_50_SaccadeApr9shuffle1_1030000.csv';
  file_name = '250ms_saca_opto_230210_135346';
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
  saca_tr(:,1) = smooth(table2array(data(:,8))); % x axis
  t = [0.005:0.005:size(saca_tr,1)*0.005];
  saca = saca_detn(saca_tr,opto,t,t_pre,t_post);
  
% Saccade parameters
  for i = 1:size(saca,2)
    saca(i).vel = diff(saca(i).tr(:,1))/0.005;
  end
% Plotting
    tr = [];
      for i = 1:size(saca,2)
          a = (saca(i).tr);
          tr = [a,tr];
      end
    plot(tr,'k')
    hold on
    plot(mean(tr'),'r','LineWidth',2)
    hold on
    plot(mean(tr')+std(tr')/sqrt(size(saca,2)),'r')
    hold on
    plot(mean(tr')-std(tr')/sqrt(size(saca,2)),'r')
    title('50ms')
    %ylim([-10 10])
    title('50ms')
%data organizing
    saca_pack.TTT = saca;
    saca_pack.raw = saca_tr;
    saca_pack.tr = mean(tr');
    saca_pack.opto = opto_info;
% Saving   
   cd(pwd);
   file_name = strcat(file_name,'.mat');
   save(file_name,'saca_pack');
