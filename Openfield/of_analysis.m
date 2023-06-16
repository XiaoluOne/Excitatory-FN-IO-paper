% clear
% % Input: load mouse data
% load('matlab'); 
% Remove outlier trials: velocity > 1000mm/s
of_outlier_remover;
% Calculate triggered movement properties for every trial
of_move_properties;
% Calculate triggered movement probability and
% session average of maximum velocisty change (mm/s)
for i = 1:size(of,2)
   opto_nose_tr=[]; opto_neck_tr=[]; opto_chest_tr=[]; opto_hip_tr=[];
   nose_on=[]; %neck_on=[]; chest_on=[]; hip_on=[];
   nose_vlc=[];%neck_vlc=[]; chest_vlc=[]; hip_vlc=[];
    for j = 1:size(of(i).ttt_vlc,2)
        if ~isempty(of(i).ttt_vlc(j).nose_on)
            opto_nose_tr = [opto_nose_tr,of(i).ttt_vlc(j).nose_vlc]; 
            nose_on = [nose_on;of(i).ttt_vlc(j).nose_on];
            nose_vlc = [nose_vlc;of(i).ttt_vlc(j).nose_max_vlc];
        else
        end
        
%         if ~isempty(of(i).ttt_vlc(j).neck_on)
%             opto_neck_tr = [opto_neck_tr,of(i).ttt_vlc(j).neck_vlc]; 
%             neck_on = [neck_on;of(i).ttt_vlc(j).neck_on];
%             neck_vlc = [neck_vlc;of(i).ttt_vlc(j).neck_max_vlc];
%         else
%         end
%         
%         if ~isempty(of(i).ttt_vlc(j).chest_on)
%             opto_chest_tr = [opto_chest_tr,of(i).ttt_vlc(j).chest_vlc]; 
%             chest_on = [chest_on;of(i).ttt_vlc(j).chest_on];
%             chest_vlc = [chest_vlc;of(i).ttt_vlc(j).chest_max_vlc];
%         else
%         end
%         
%         if ~isempty(of(i).ttt_vlc(j).hip_on)
%             opto_hip_tr = [opto_hip_tr,of(i).ttt_vlc(j).hip_vlc]; 
%             hip_on = [hip_on;of(i).ttt_vlc(j).hip_on];
%             hip_vlc = [hip_vlc;of(i).ttt_vlc(j).hip_max_vlc];
%         else
%         end
    end
    %average photo-evoked trace
    of(i).opto_nose = mean(opto_nose_tr');
%     of(i).opto_neck = mean(opto_neck_tr');
%     of(i).opto_chest = mean(opto_chest_tr');
%     of(i).opto_hip = mean(opto_hip_tr');
    %photo-evoked probability
    of(i).nose_prb = length(nose_on)/j*100;
%     of(i).neck_prb = length(neck_on)/j*100;
%     of(i).chest_prb = length(chest_on)/j*100;
%     of(i).hip_prb = length(hip_on)/j*100;
    %onset
    of(i).nose_onset = mean(nose_on);
%     of(i).neck_onset = mean(neck_on);
%     of(i).chest_onset = mean(chest_on);
%     of(i).hip_onset = mean(hip_on);
    %photo-evoked maximum velocity
    of(i).nose_max_vlc = mean(nose_vlc);
%     of(i).neck_max_vlc = mean(neck_vlc);
%     of(i).chest_max_vlc = mean(chest_vlc);
%     of(i).hip_max_vlc = mean(hip_vlc);

%Calculate turning angle
for j=1:size(of(i).ttt_xy,2)
        if ~isempty(of(i).ttt_vlc(j).nose_on)
            angle =[];
            for k=1:400
                nose = of(i).ttt_xy(j).nose_xy(k,:);
                neck = of(i).ttt_xy(j).neck_xy(k,:);
                x = nose(1)-neck(1);
                y = nose(2)-neck(2);
                angle = [angle;atan2(y,x)*180/pi]; 
            end
            of(i).ttt_xy(j).angle = angle;
        else
        end
end

%normalize angle
an =[];
for j=1:size(of(i).ttt_xy,2)
        if ~isempty(of(i).ttt_xy(j).angle)   
            of(i).ttt_xy(j).angle = of(i).ttt_xy(j).angle-mean(of(i).ttt_xy(j).angle(199));
            an=[an,max(of(i).ttt_xy(j).angle(200:250))];
            of(i).ttt_xy(j).max_angle =max(of(i).ttt_xy(j).angle(200:250));
        else
        end
end
of(i).angle=mean(an);
end

