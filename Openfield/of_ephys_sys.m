clear;
% Input parameters
  t_pre = 1000; %pre opto time
  t_post = 1000; %post opto time
  dur = 2000;
  f = 200; %camera frame rate
  file_name ='test1DLC_resnet_50_Escape_ephysFeb2shuffle1_1000000.csv';
  packname ='test1';

  
% Calculate movement velocity: vlc, raw trace 
  opts = detectImportOptions(file_name);
  raw_data = readtable(file_name,opts);
  [vlc,raw_data] = of_vlc_cal(raw_data); %call function of_vlc
  vlc = struct2table(vlc); raw_data = struct2table(raw_data);

  
  % Align to opto triggers: of_vlc, opto-aligned
  t = [0.005:0.005:size(vlc,1)*0.005];
  ttt_vlc = of_vlc_opto(vlc,opto,t,t_pre,t_post); % unit is mm/s
% Calculate movement coordinates relative to the initial position (opto)
  ttt_xy = of_xy_opto(raw_data,opto,t,t_pre,t_post);
% Connect nose-neck-chest-hip
  ttt_xy = make_line(ttt_xy,t_pre,t_post);
% Save data 
  of_pack.of_xy = ttt_xy;
  of_pack.of_vlc = ttt_vlc;
  of_pack.opto = opto_info;
  name = strcat('ofapack_',packname,'.mat');
  save(name,'of_pack');
  
  