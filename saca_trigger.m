function [saca_tempo,saca_naso,saca_raw] = saca_trigger(saca_file,diff_thre,loc_video)

% ---- Extract data form DLC-analysed file ----
filename = saca_file;
opts = detectImportOptions(filename);
data = readtable(filename,opts);
saca_raw = smooth(table2array(data(:,8)));
diff_saca = diff(saca_raw);

% ---- Nasal saccade detection (sharp trough) ----
locs_naso = find(-1.5<diff_saca(100:end) & diff_saca(100:end)<-diff_thre);
    naso = struct('tr',[],'t',[]);
    for j = 15:size(locs_naso,1)-20
        saca_0 = locs_naso(j)-150+100; 
        saca_1 = locs_naso(j)+150-1+100;
        naso(j).tr = saca_raw(saca_0:saca_1);
        naso(j).t = [(saca_0/200):0.005:(saca_1/200)];
    end
    
% ---- Remove false positive nasal saccade----
n = 0; trace = []; onset = []; begin = []; finish = []; 
saca_naso = struct('nr',[],'tr',[],'t',[],'onset_trigger',[]);
for i = 15:size(naso,2)
    [trace,onset,~] = saca_kicker([naso(i).tr],[naso(i).t],'naso');
    if ~isempty(onset)
        n = n+1;
        saca_naso(n).nr = n;
        begin = onset-100;
        finish = onset+100-1;
        saca_naso(n).tr = trace(begin:finish);
        bsl = mean(saca_naso(n).tr(1:100));
        saca_naso(n).tr = (saca_naso(n).tr-bsl);
        saca_naso(n).t = [naso(i).t(begin:finish)];
        saca_naso(n).onset_trigger = naso(i).t(onset)+loc_video;
    else
    end
end
% ---- Rmove duplicate nasal trials ----
onset = round([saca_naso(1:size(saca_naso,2)).onset_trigger]);
[~,w] = unique(onset,'stable');
duplicate_locs1 = setdiff(1:numel(onset),w);
saca_naso(duplicate_locs1)=[];
      
% ---- Temporal saccade detection ----
locs_tempo = find(1.5>diff_saca(100:end) & diff_saca(100:end)>diff_thre);
% [~,locs_tempo] = findpeaks(saca,'MinPeakProminence',saca_peak,'MinPeakDistance',10); 
    tempo = struct('tr',[],'t',[]);
    for j = 10:size(locs_tempo,1)-20
        saca_0 = locs_tempo(j)-150+100; 
        saca_1 = locs_tempo(j)+150-1+100;
        tempo(j).tr = saca_raw(saca_0:saca_1);
        tempo(j).t = [(saca_0/200):0.005:(saca_1/200)];
    end
    
% ---- Remove false positive tempral saccade ----
n = 0; trace = []; onset = []; begin = []; finish = []; 
saca_tempo = struct('nr',[],'tr',[],'t',[],'onset_trigger',[]);
for i = 10:size(tempo,2)
    [trace,onset,~] = saca_kicker([tempo(i).tr],[tempo(i).t],'tempo');
    if ~isempty(onset)
        n = n+1;
        saca_tempo(n).nr = n;
        begin = onset-100;
        finish = onset+100-1;
        saca_tempo(n).tr = trace(begin:finish);
        bsl = mean(saca_tempo(n).tr(1:100));
        saca_tempo(n).tr = (saca_tempo(n).tr-bsl);
        saca_tempo(n).t = [tempo(i).t(begin:finish)];
        saca_tempo(n).onset_trigger = tempo(i).t(onset)+loc_video;
    else
    end
end
% ---- Rmove duplicate tempral trials ----
onset = round([saca_tempo(1:size(saca_tempo,2)).onset_trigger]);
[~,w] = unique(onset,'stable');
duplicate_locs2 = setdiff(1:numel(onset),w);
saca_tempo(duplicate_locs2)=[];

end