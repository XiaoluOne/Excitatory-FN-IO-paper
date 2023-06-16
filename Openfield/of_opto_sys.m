clear;

% Input parameters
  t_pre = 1000; %pre opto time
  t_post = 1000; %post opto time
  dur = 2000;
  f = 200; %camera frame rate
  offile ='250ms_opto.csv';
  packname ='250ms_body_opto_230216_103446';
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
% Detection trigger edges
  for i = 1:size(adc,2)
      v = [adc(i).v];
      %down sample trigger sampling rate as camera frame rate 200 fps
      adc(i).v = seven_shorten(v,size(adc(i).v,1),size(adc(i).v,1)/100);  
  end
  video = find_trg_pks([adc(1).v],0.5,t,dur);
  opto = find_trg_pks([adc(2).v],0.5,t,dur)-video(1);
% Calculate movement velocity: vlc, raw trace 
  opts = detectImportOptions(offile);
  raw_data = readtable(offile,opts);
  [vlc,raw_data] = of_vlc_cal(raw_data); %call function of_vlc
  vlc = struct2table(vlc); raw_data = struct2table(raw_data);
% Align to opto triggers: of_vlc, opto-aligned
  t = [0.005:0.005:size(vlc,1)*0.005];
  ttt_vlc = of_vlc_opto(vlc,opto,t,t_pre,t_post); % unit is mm/s
% Calculate movement coordinates relative to the initial position (opto)
  ttt_xy = of_xy_opto(raw_data,opto,t,t_pre,t_post);
% Connect nose-neck-chest-hip
  ttt_xy = of_make_line(ttt_xy,t_pre,t_post);
% Save data 
  of_pack.of_xy = ttt_xy;
  of_pack.of_vlc = ttt_vlc;
  of_pack.opto = opto_info;
  name = strcat('ofapack_',packname,'.mat');
  save(name,'of_pack');
% Plot for manual check 
  for i = 1:size(of_pack.of_vlc,2)
      plot(of_pack.of_vlc(i).nose_vlc)
      hold on
  end
