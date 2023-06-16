%This function is to find how many spontaneous saccades are there in a contineuos
%video recording, NOT for evoked trigger
clear
%----Input----
saca_file = 'day3_FN_mosquito_pulse.csv';
mouse = '15230-06';
type = 'control'; %control, gtACR2_uni, gtACR2_bi, eOPN_uni, eOPN_bi
diff = 0.3; % temporal saccade movement criteria (differentiation, 0.2~0.4)
loc_video = 0;

%----Find saccade----
[saca_tempo,saca_naso,raw] = saca_trigger(saca_file,diff,loc_video);

% Assess saccade quality
figure(1)
title('naso')
  for i = 1:size(saca_naso,2)
      subplot(10,round(size(saca_naso,2)/10)+1,i)
      plot(saca_naso(i).tr)
      title(i)
  end
  
  figure(2)
  title('tempo')
  for i = 1:size(saca_tempo,2)
      subplot(10,round(size(saca_tempo,2)/10)+1,i)
      plot(saca_tempo(i).tr)
      title(i)
  end
  
%-----Maual check (use if necessary)------
naso_out=[];
tempo_out=[];
saca_naso(naso_out)= [];
saca_tempo(tempo_out)=[];

%----Group plotting----

saca_behv_plot

%------Organize package struct------
saca.mouse=mouse;
saca.type = type;
saca.file = saca_file;
saca.naso = saca_naso;
saca.tempo = saca_tempo;

%------Saving package-----
filename = strcat('sacapack_',saca_file,'.mat');
save(filename,'saca');