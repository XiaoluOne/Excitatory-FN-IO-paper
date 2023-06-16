function [trace,onset,t] = saca_kicker(tr,t,saca_type)
%this function is used to select significant saccade evens
%   input: raw saccade trace;
%   output: trace = valid saccade trace; 
%           onset = saccade onset; 
%           t = evnt timing based on 200 fps;

baseline = [tr(50:100)]; 
a = find(abs(tr(110:150)-mean(baseline))>3*std(baseline),1); %find the first point > 3 baseline SD
a = 110+a-1; % corresponding timing of the first point > 3 baseline SD
b = [];
if isequal(saca_type,'tempo')
    for i = 112:150
        if tr(i)<tr(i+1) && tr(i+1)<tr(i+2) && tr(i+2)<tr(i+3) && tr(i+3)<tr(i+5)%eye moves to the same direction at least for 4 frames after saccade onset  
            b = [b;i];
        else
        end
    end
    
elseif isequal(saca_type,'naso')
     for i = 112:150
        if tr(i)>tr(i+1) && tr(i+1)>tr(i+2) && tr(i+2)>tr(i+3) && tr(i+3)>tr(i+5)%eye moves to the same direction at least for 4 frames after saccade onset  
            b = [b;i];
        else
        end
     end   
else
end

if ismember(a,b)
           onset = a;
           trace = tr; % save saccade trace 500ms before and after onset 
    else
        onset = [];
        trace = [];
end
end