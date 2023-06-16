function [saca] = saca_detn(saca_tr,opto,t,t_pre,t_post,angle)
    t_pre = t_pre/5-1;
    t_post = t_post/5;
    saca = struct('nr',[],'tr',[]);
    for i = 1:length(opto)
        [~,loc] = min(abs(t-opto(i)));
        cue = t(loc)/0.005;
        saca(i).nr = i;
        saca(i).tr=saca_tr((cue-t_pre):(cue+t_post),:);
%         saca(i).tr = saca(i).tr(:,1)-bsl_x; %run this line for
%         non-calibrated 
        bsl_x = mean(saca(i).tr(1:40,1));
        bsl_y = mean(saca(i).tr(1:40,2));
        saca(i).tr(:,1) = (saca(i).tr(:,1)-bsl_x)/cos(angle);
        saca(i).tr(:,2) = (saca(i).tr(:,2)-bsl_y)*cos(angle);
    end
end

