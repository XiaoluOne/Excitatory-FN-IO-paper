function [of_feature] = of_vlc_opto(of_tr,opto,t,t_pre,t_post)
%input of_tr can be velocity, distance tec.
%output can also be any of these features as input
    t_pre = t_pre/5-1;
    t_post = t_post/5;
    of_feature = struct('nr',[],'nose_vlc',[],'neck_vlc',[],'chest_vlc',[],'hip_vlc',[]);
    nose = of_tr.nose_vlc;
    neck = of_tr.neck_vlc;
    chest = of_tr.chest_vlc;
    hip = of_tr.hip_vlc;
    for i = 1:size(opto,1)
        [~,loc] = min(abs(t-opto(i)));
        cue = t(loc)/0.005;
        of_feature(i).nr = i;
        of_feature(i).nose_vlc = smooth(nose((cue-t_pre):(cue+t_post)));
        of_feature(i).neck_vlc = smooth(neck((cue-t_pre):(cue+t_post)));
        of_feature(i).chest_vlc = smooth(chest((cue-t_pre):(cue+t_post)));
        of_feature(i).hip_vlc = smooth(hip((cue-t_pre):(cue+t_post)));
    end
end


