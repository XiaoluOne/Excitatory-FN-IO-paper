%plotting
i = 1; tr=[];
for j=1:size(saca(i).TTT,2)
    if ~isempty(saca(i).TTT(j).onset)
        tr=[tr,saca(i).TTT(j).tr(:,1)];
    else
    end
end
tr=tr';
plot(mean(tr),'r')
hold on
plot(mean(tr)+std(tr)/sqrt(size(tr,1)),'r')
plot(mean(tr)-std(tr)/sqrt(size(tr,1)),'r')
xlim([80 300])

%judge saca in calibrated data
for i = 1:size(saca,2)
    onset=[];peak_x=[];peak_y=[];peak_t=[];peak_vel=[];tr=[];
    for j = 1:size(saca(i).TTT,2)
        baseline = saca(i).TTT(j).tr(1:99,1);
        diff_saca = diff(saca(i).TTT(j).tr);
        
        %find the point preceeds 3 time SD. If the velocity at this point
        %if bigger than 50 degree/second, onset should earlier than 150ms, then define it as onset (see J
        %Poort, 2020)
        %Peak is defined as the max in 150ms after opto (100:130)
        locs = find(abs(saca(i).TTT(j).tr(100:200,1))>3*abs(std(baseline)));
        if ~isempty(locs) && abs(saca(i).TTT(j).vel.x(locs(1)-1+100))>50 && locs(1) <30
            onset = [onset;locs(1)*5];
            peak_x = [peak_x;min(saca(i).TTT(j).tr(100:130,1))];
            peak_y = [peak_y;min(saca(i).TTT(j).tr(100:130,2))];
            [M,I] = min(saca(i).TTT(j).tr(100:130,1));
            peak_t = [peak_t;I*5];
            peak_vel = [peak_vel;max(abs(saca(i).TTT(j).vel.x(100:130)))];
%             tr=[tr,saca(i).TTT(j).tr];
            %organize data in TTT struct
            saca(i).TTT(j).onset = locs(1)*5;
            saca(i).TTT(j).peak_x = min(saca(i).TTT(j).tr(100:130,1));
            saca(i).TTT(j).peak_y = min(saca(i).TTT(j).tr(100:130,2));
            saca(i).TTT(j).peak_t = I*5;
            saca(i).TTT(j).peak_vel = max(abs(saca(i).TTT(j).vel.x(100:130)));
        else
            saca(i).TTT(j).onset =[];
            saca(i).TTT(j).peak = [];
            saca(i).TTT(j).peak_t =[];
            saca(i).TTT(j).peak_vel =[];
        end
    end
%     saca(i).saca_tr =mean(tr');
    saca(i).probability = length(onset)/size(saca(i).TTT,2)*100;
    saca(i).onset = mean(onset);
    saca(i).peak_x = -mean(peak_x);
    saca(i).peak_y = -mean(peak_y);
    saca(i).peak_t =mean(peak_t);
    saca(i).peak_vel=mean(peak_vel);
end

% checking & plotting
n = 9;
for i=1:size(test4(n).TTT,2)
    subplot(7,8,i)
    plot(test4(n).TTT(i).tr)
    title(i)
end

n = 1;
onset=[];peak=[];peak_t=[];peak_vel=[];tr=[];
for i=1:size(test4(n).TTT,2)
   if ~isempty(test4(n).TTT(i).onset)
       onset = [onset;test4(n).TTT(i).onset];
       peak = [peak;test4(n).TTT(i).peak];
       peak_t = [peak_t;test4(n).TTT(i).peak_t];
       peak_vel = [peak_vel;test4(n).TTT(i).peak_vel];
       tr=[tr,test4(n).TTT(i).tr];
   else 
   end
end
    test4(n).saca_tr = mean(tr');
    test4(n).probability = length(onset)/size(test4(n).TTT,2)*100;
    test4(n).onset = mean(onset);
    test4(n).peak = -mean(peak);
    test4(n).peak_t =mean(peak_t);
    test4(n).peak_vel=mean(peak_vel);
    
    
    n =87; a=[];b=0;
for i = 1:size(saca_opto(n).TTT,2)
    if ~isempty(saca_opto(n).TTT(i).onset)
        a=[a,smooth(saca_opto(n).TTT(i).tr)];
        plot(smooth(saca_opto(n).TTT(i).tr),'r')
        b=b+1;
        hold on
    elseif isempty(saca_opto(n).TTT(i).onset)
        plot(smooth(saca_opto(n).TTT(i).tr),'k')
    else 
    end
end
hold on
plot(smooth(saca_opto(n).saca_tr),'g')
hold on
plot(mean(a')+std(a')/sqrt(b),'g')
hold on
plot(mean(a')-std(a')/sqrt(b),'g')
ylim([-12 4])

% 250ms_100% amplitude-velocity correlation
for i=1:9
    a = []; v=[];
    for j = 1:size(saca(i).TTT,2)
    if ~isempty(saca(i).TTT(j).peak_x)
        a=[a,abs(saca(i).TTT(j).peak_x)];
        v=[v,saca(i).TTT(j).peak_vel];
        
        
%     elseif isempty(saca_opto(n).TTT(i).onset)
%         plot(smooth(saca_opto(n).TTT(i).tr),'k')
    else 
    end
    end
   b=[a;v]; b=b';
   corr = table(b(:,1),b(:,2),'VariableNames',{'peak_amp','peak_vlc'});
% regression: mix-effect linear model (spk,trial and intercept are fixed effects)
         reg = fitlm(corr,'peak_vlc~peak_amp'); %if recording as random effect(1|recording)+(-1+spk|recording), PC(blk~spk),FN(blk~spk+trial_ID)
         reg_r = reg.Rsquared.Adjusted;
         reg_p = reg.Coefficients.pValue(2);
         reg_int = reg.Coefficients.Estimate(1);
         reg_slp = reg.Coefficients.Estimate(2);
         %Organize outputs in cell struct
         saca(i).corr = corr;
         saca(i).reg_r = reg_r;
         saca(i).reg_p = reg_p;
         saca(i).reg_int = reg_int;
         saca(i).reg_slp = reg_slp;
end
         
         
 % plotting polarhistogram
 peak_x=[];peak_y=[];peak_vel=[];amp=[];
for i=1:9 
   for j = 1:size(saca(i).TTT,2)
       if ~isempty(saca(i).TTT(j).onset)
           peak_x = [peak_x;saca(i).TTT(j).peak_x];
           peak_y = [peak_y;saca(i).TTT(j).peak_y];
           peak_vel=[peak_vel;saca(i).TTT(j).peak_vel];
           amp = [amp;saca(i).TTT(j).amp];
       else
       end
   end
   saca(i).peak_x = mean(peak_x);
   saca(i).peak_y = mean(peak_y);
   saca(i).peak_vel = mean(peak_vel);
   saca(i).amp = mean(amp);
end
angle_pi=atan2(peak_y,peak_x); % pi value
% angle = angle_pi*180/pi;
polarhistogram(angle_pi)
% density plot
out=scatplot(amp,angle_pi,'circles',[],[],[],2,10)
compass(mean(amp),mean(angle_pi))
xlim([-15 15])
ylim([-15 15])
% mean
hold on
mean_x=mean(peak_x);
mean_y=mean(peak_y);
scatter(mean_x,mean_y,'r');


% calculate avergae 
for i=1:9 
    peak_x=[];peak_y=[];peak_vel=[];
   for j = 1:size(saca(i).TTT,2)
       if ~isempty(saca(i).TTT(j).onset)
           peak_x = [peak_x;saca(i).TTT(j).peak_x];
           peak_y = [peak_y;saca(i).TTT(j).peak_y];
           peak_vel=[peak_vel;saca(i).TTT(j).peak_vel];
       else
       end
   end
   saca(i).peak_x = mean(peak_x);
   saca(i).peak_y = mean(peak_y);
   saca(i).peak_vel = mean(peak_vel);
end


% TTT heatmap plot
i = 6; n=[];
   tr=[]; vel=[];
    for j = 1:size(saca(i).TTT,2)
    if isempty(saca(i).TTT(j).onset)   
        n=[n,j];
    else 
    end
    end
saca(i).TTT(n)=[];

% manully sort!!!!!!!
   tr=[]; vel=[];
    for j = 1:size(saca(i).TTT,2)
        tr(:,j)=abs(saca(i).TTT(j).tr(:,1));
        vel(:,j)=abs(saca(i).TTT(j).vel.x);
    end
 tr=tr'; vel=vel';
 tr=tr(151:300,:);
 vel=vel(151:299,:);

%amplitude
subplot(1,2,1)
a = heatmap(tr,'Colormap',parula);
a.GridVisible = 'off';
a.ColorLimits = [1,20];
%velocity
subplot(1,2,2)
a = heatmap(vel,'Colormap',parula);
a.GridVisible = 'off';
a.ColorLimits = [100,800];

%plot all correlation fitting 
for i = 1:9
    avr_int =  saca(i).reg_int;
    avr_slp = saca(i).reg_slp;
    x = saca(i).corr.peak_amp';
    y = saca(i).reg_slp*x+saca(i).reg_int;
    
        plot(x,y,'magenta','LineWidth',1);
        scatter(saca(i).corr.peak_amp,saca(i).corr.peak_vlc,'k')
    
   hold on
end

% Calculate postsaccadic drift
% PSD is defined as the tinny drift from saccade peak amplitude to post
% saccadic fix eye position 
for i = 1:size(saca_opto,2)
    if any(saca_opto(i).probability)
        [v,loc]=min(saca_opto(i).tr(100:150));
        loc=loc+100-1; % peak location
        fix = abs(saca_opto(i).tr(loc+10)); % peak location + 50ms
        psd = abs(v)-abs(fix); % psd = post-saccadic drift
        saca_opto(i).psd=psd;
    else
    end
end