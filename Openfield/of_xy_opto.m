function [of_feature] = of_xy_opto(raw_data,opto,t,t_pre,t_post)
%-----This function finds every frames before opto onset and provide the x
%y coordinates
    t_pre = t_pre/5-1;
    t_post = t_post/5;
    nose = raw_data(:,1:2);
    % leftear = raw_data(:,3:4);
    % rightear = raw_data(:,5:6);
    neck = raw_data(:,3:4);
    chest = raw_data(:,5:6);
    hip = raw_data(:,7:8);
    
    of_feature = struct();
    for i = 1:size(opto,1)
        [~,loc] = min(abs(t-opto(i)));
        cue = t(loc)/0.005; %opto onset
        of_feature(i).nr = i;
        n = 1;
        for j = cue-t_pre : cue+t_post
            [of_feature(i).nose_xy(n,1),of_feature(i).nose_xy(n,2)] = of_xy(nose,j);
            [of_feature(i).neck_xy(n,1),of_feature(i).neck_xy(n,2)] = of_xy(neck,j);
            [of_feature(i).chest_xy(n,1),of_feature(i).chest_xy(n,2)] = of_xy(chest,j);
            [of_feature(i).hip_xy(n,1),of_feature(i).hip_xy(n,2)] = of_xy(hip,j);
            % [of_feature(i).leftear_xy(n,1),of_feature(i).leftear_xy(n,2)] = of_xy(leftear,j);
            % [of_feature(i).rightear_xy(n,1),of_feature(i).rightear_xy(n,2)] = of_xy(rightear,j);
            n=n+1;
        end
        
end





