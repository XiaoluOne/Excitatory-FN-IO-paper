% -----Normalize vlc traces,
% Baseline of movement = 250ms before opto
bl = [100:199];
cri = 6; % cri = criteria for how many times of standard deviation

for i = 1:size(of,2)

    for j = 1:size(of(i).ttt_vlc,2)
        % Normalization: substract baseline
        % Smoothen the raw velocity traces
        nose_bsl = mean(of(i).ttt_vlc(j).nose_vlc(bl));
        of(i).ttt_vlc(j).nose_norm = smooth(of(i).ttt_vlc(j).nose_vlc-nose_bsl);
        of(i).ttt_vlc(j).nose_vlc = smooth(of(i).ttt_vlc(j).nose_vlc);
        
%         neck_bsl = mean(of(i).ttt_vlc(j).neck_vlc(bl));
%         of(i).ttt_vlc(j).neck_norm = smooth(of(i).ttt_vlc(j).neck_vlc-neck_bsl);
%         of(i).ttt_vlc(j).neck_vlc = smooth(of(i).ttt_vlc(j).neck_vlc);
%         
%         chest_bsl = mean(of(i).ttt_vlc(j).chest_vlc(bl));
%         of(i).ttt_vlc(j).chest_norm = smooth(of(i).ttt_vlc(j).chest_vlc-chest_bsl);
%         of(i).ttt_vlc(j).chest_vlc = smooth(of(i).ttt_vlc(j).chest_vlc);
%         
%         hip_bsl = mean(of(i).ttt_vlc(j).hip_vlc(bl));
%         of(i).ttt_vlc(j).hip_norm = smooth(of(i).ttt_vlc(j).hip_vlc-hip_bsl);
%         of(i).ttt_vlc(j).hip_vlc = smooth(of(i).ttt_vlc(j).hip_vlc);
    end
    
end

% Calculate movement onset
% Criteria: 1. Velocity should increase for 3 frames (15ms)
%           2. Detection window for onset = 150ms after opto (point 200:230)
for i = 1:size(of,2)
    for j = 1:size(of(i).ttt_vlc,2)
        nose_sd = std(of(i).ttt_vlc(j).nose_vlc(bl));
        nose_idx = [];
        nose_idx = find(of(i).ttt_vlc(j).nose_vlc(200:230)>=cri*nose_sd);
        if ~isempty(nose_idx) 
            nose1 = of(i).ttt_vlc(j).nose_vlc(nose_idx(1)+200-1);
            nose2 = of(i).ttt_vlc(j).nose_vlc(nose_idx(1)+200);
            nose3 = of(i).ttt_vlc(j).nose_vlc(nose_idx(1)+200+1);
            nose4 = of(i).ttt_vlc(j).nose_vlc(nose_idx(1)+200+2);
            if nose2>nose1 && nose3>nose2 %&& nose4>nose3
                of(i).ttt_vlc(j).nose_on = nose_idx(1)*5; % unit is ms
                of(i).ttt_vlc(j).nose_max_vlc = max(of(i).ttt_vlc(j).nose_norm(200:250));
            else
                of(i).ttt_vlc(j).nose_on =[];
            end
        else
        end
        
%         neck_sd = std(of(i).ttt_vlc(j).neck_vlc(bl));
%         neck_idx = [];
%         neck_idx = find(of(i).ttt_vlc(j).neck_vlc(200:230)>=cri*neck_sd);
%         if ~isempty(neck_idx)
%             neck1 = of(i).ttt_vlc(j).neck_vlc(neck_idx(1)+200-1);
%             neck2 = of(i).ttt_vlc(j).neck_vlc(neck_idx(1)+200);
%             neck3 = of(i).ttt_vlc(j).neck_vlc(neck_idx(1)+200+1);
%             neck4 = of(i).ttt_vlc(j).neck_vlc(neck_idx(1)+200+2);
%             if neck2>neck1 && neck3>neck2 %&& neck4>neck3
%                 of(i).ttt_vlc(j).neck_on = neck_idx(1)*5; % unit is ms
%                 of(i).ttt_vlc(j).neck_max_vlc = max(of(i).ttt_vlc(j).neck_norm(200:250));
%             else
%                 of(i).ttt_vlc(j).neck_on = [];
%             end
%         else
%         end
        
%         chest_sd = std(of(i).ttt_vlc(j).chest_vlc(bl));
%         chest_idx = [];
%         chest_idx = find(of(i).ttt_vlc(j).chest_vlc(200:230)>=cri*chest_sd);
%         if ~isempty(chest_idx)
%             chest1 = of(i).ttt_vlc(j).chest_vlc(chest_idx(1)+200-1);
%             chest2 = of(i).ttt_vlc(j).chest_vlc(chest_idx(1)+200);
%             chest3 = of(i).ttt_vlc(j).chest_vlc(chest_idx(1)+200+1);
%             chest4 = of(i).ttt_vlc(j).chest_vlc(chest_idx(1)+200+2);
%             if chest2>chest1 && chest3>chest2 %&& chest4>chest3
%                 of(i).ttt_vlc(j).chest_on = chest_idx(1)*5; % unit is ms
%                 of(i).ttt_vlc(j).chest_max_vlc = max(of(i).ttt_vlc(j).chest_norm(200:250));
%             else
%                 of(i).ttt_vlc(j).chest_on =[];
%             end
%         else
%         end
        
%         hip_sd = std(of(i).ttt_vlc(j).hip_vlc(bl));
%         hip_idx = [];
%         hip_idx = find(of(i).ttt_vlc(j).hip_vlc(200:230)>=cri*hip_sd);
%         if ~isempty(hip_idx)
%             hip1 = of(i).ttt_vlc(j).hip_vlc(hip_idx(1)+200-1);
%             hip2 = of(i).ttt_vlc(j).hip_vlc(hip_idx(1)+200);
%             hip3 = of(i).ttt_vlc(j).hip_vlc(hip_idx(1)+200+1);
%             hip4 = of(i).ttt_vlc(j).hip_vlc(hip_idx(1)+200+2);
%             if hip2>hip1 && hip3>hip2 %&& hip4>hip3
%                 of(i).ttt_vlc(j).hip_on = hip_idx(1)*5; % unit is ms
%                 of(i).ttt_vlc(j).hip_max_vlc = max(of(i).ttt_vlc(j).hip_norm(200:250));
%             else
%                 of(i).ttt_vlc(j).hip_on =[];
%             end
%         else
%         end
    end
    

end
