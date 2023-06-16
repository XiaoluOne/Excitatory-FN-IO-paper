% Remove outlier: if vlc > 800 mm/s, remove this trial 
max_vlc = 800;

for i = 1:size(of,2)
    remover = [];
    for j = 1:size(of(i).ttt_vlc,2)
        nose = of(i).ttt_vlc(j).nose_vlc;
%         neck = of(i).ttt_vlc(j).neck_vlc;
%         chest = of(i).ttt_vlc(j).chest_vlc;
%         hip = of(i).ttt_vlc(j).hip_vlc;
%         body=[nose,neck,chest,hip];
%         judge = find(body>max_vlc);
        judge = find(nose>max_vlc);
        if ~isempty(judge)
             remover = [remover,j];
        else 
        end
    end
    of(i).ttt_vlc(remover) = [];
    of(i).ttt_xy(remover) = [];
end