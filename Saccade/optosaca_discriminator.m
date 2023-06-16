% This function is used for opto-driven saccade, to determine
% 1) if a opto trial drives saccadic movement 
% 2) if yes, calculate saccade onset, peak time, peak velocity, peak amplitude 


%calculate for each trial
for i = 1:size(saca,2)
    onset=[];peak=[];peak_t=[];peak_vel=[];tr=[];
    for j = 1:size(saca(i).TTT,2)
        baseline = saca(i).TTT(j).tr(1:99);
        diff_saca = diff(saca(i).TTT(j).tr);
        
        %find the point preceeds 3 time SD. If the velocity at this point
        %if bigger than 50 degree/second, onset should earlier than 150ms, then define it as onset (see J
        %Poort, 2020)
        %Peak is defined as the max in 150ms after opto (100:130)
        locs = find(abs(saca(i).TTT(j).tr(100:200))>3*abs(std(baseline)));
        if ~isempty(locs) && abs(saca(i).TTT(j).vel.x(locs(1)-1+100))>50 && locs(1) <30
            onset = [onset;locs(1)*5];
            peak = [peak;min(saca(i).TTT(j).tr(100:130))];
            [M,I] = min(saca(i).TTT(j).tr(100:130));
            peak_t = [peak_t;I*5];
            peak_vel = [peak_vel;max(abs(saca(i).TTT(j).vel.x(100:130)))];
            tr=[tr,saca(i).TTT(j).tr];
            %organize data in TTT struct
            saca(i).TTT(j).onset = locs(1)*5;
            saca(i).TTT(j).peak = min(saca(i).TTT(j).tr(100:130));
            saca(i).TTT(j).peak_t = I*5;
            saca(i).TTT(j).peak_vel = max(abs(saca(i).TTT(j).vel.x(100:130)));
        else
            saca(i).TTT(j).onset =[];
            saca(i).TTT(j).peak = [];
            saca(i).TTT(j).peak_t =[];
            saca(i).TTT(j).peak_vel =[];
        end
    end
    saca(i).saca_tr =mean(tr');
    saca(i).probability = length(onset)/size(saca(i).TTT,2)*100;
    saca(i).onset = mean(onset);
    saca(i).peak = -mean(peak);
    saca(i).peak_t =mean(peak_t);
    saca(i).peak_vel=mean(peak_vel);
end

%average info
