%plot vlc traces
i = 21;tr = [];

for j=1:size(of(i).ttt_vlc,2)
   if ~isempty(of(i).ttt_vlc(j).nose_on)
       tr=[tr,of(i).ttt_vlc(j).nose_vlc];
       plot(of(i).ttt_vlc(j).nose_vlc,'b')
       hold on
   elseif isempty(of(i).ttt_vlc(j).nose_on)
       plot(of(i).ttt_vlc(j).nose_vlc,'k')
       hold on
   end
end
plot(mean(tr'),'r')
hold on
plot(mean(tr')+std(tr')/sqrt(size(tr,2)),'r')
plot(mean(tr')-std(tr')/sqrt(size(tr,2)),'r')
ylim([0 400])
xlim([150 350])


%calculate turning angle 
for i = 1:116
    for j=1:size(of_pack(i).ttt_xy,2)
        if ~isempty(of_pack(i).ttt_vlc(j).nose_on)
            angle =[];
            for k=1:400
                nose = of_pack(i).ttt_xy(j).nose_xy(k,:);
                neck = of_pack(i).ttt_xy(j).neck_xy(k,:);
                x = nose(1)-neck(1);
                y = nose(2)-neck(2);
                angle = [angle;atan2(y,x)*180/pi]; 
            end
            of_pack(i).ttt_xy(j).angle = angle;
        else
        end
    end
end

% normalize angle, calculate max
for i = 1:116
    for j=1:size(of_pack(i).ttt_xy,2)
        if ~isempty(of_pack(i).ttt_xy(j).angle)   
            of_pack(i).ttt_xy(j).angle = of_pack(i).ttt_xy(j).angle-mean(of_pack(i).ttt_xy(j).angle(199));
            of_pack(i).ttt_xy(j).max_angle =max(of_pack(i).ttt_xy(j).angle(200:250));
        else
        end
    end
end


vlc=[];
for i=1:9
  vlc=[vlc;of(i).nose_vlc];
end
plot(vlc','k')
hold on
plot(mean(vlc),'r')
plot(mean(vlc)+sqrt(9),'r')
plot(mean(vlc)-sqrt(9),'r')
xlim([100 350])

vlc=[];
for i=1
  for j=1:size(of(i).ttt_xy,2)
        if ~isempty(of(i).ttt_vlc(j).nose_on)
           vlc=[vlc,of(i).ttt_vlc(j).nose_norm];
        else
    end
    end
end
plot(vlc,'k')
hold on
plot(mean(vlc),'r')
plot(mean(vlc)+sqrt(size(vlc,2)),'r')
plot(mean(vlc)-sqrt(size(vlc,2)),'r')
xlim([100 350])

%calculate displacement
for i = 1:size(of,2)
    for j = 1:size(of(i).ttt_xy,2)
        dis_nose =[];
      for k=1:400
        nose = of(i).ttt_xy(j).nose_xy(100,:);
        dis_nose = [dis_nose,norm(of(i).ttt_xy(j).nose_xy(k,:)-nose)/2.8];
      end
      of(i).ttt_xy(j).dis_nose = dis_nose;
    end
end

% angle, displacement, velocity correlation
for i=1:9
    v=[]; a =[];
    for j = 1:size(of(i).ttt_xy,2)
    if ~isempty(of(i).ttt_xy(j).dis_nose)
        
        a=[a,of(i).ttt_xy(j).max_angle]; %x
        v=[v,of(i).ttt_vlc(j).nose_max_vlc];%y
    else 
    end
    end
   c=[a;v]; c=c';
   corr = table(c(:,1),c(:,2),'VariableNames',{'angle','vlc'});
% regression: mix-effect linear model (spk,trial and intercept are fixed effects)
         reg = fitlm(corr,'vlc~angle'); %if recording as random effect(1|recording)+(-1+spk|recording), PC(blk~spk),FN(blk~spk+trial_ID)
         reg_r = reg.Rsquared.Adjusted;
         reg_p = reg.Coefficients.pValue(2);
         reg_int = reg.Coefficients.Estimate(1);
         reg_slp = reg.Coefficients.Estimate(2);
         %Organize outputs in cell struct
         of(i).corr = corr;
         of(i).reg_r = reg_r;
         of(i).reg_p = reg_p;
         of(i).reg_int = reg_int;
         of(i).reg_slp = reg_slp;
end
%plot ttt correlation for all mice
for i = 1:9
    avr_int =  of(i).reg_int;
    avr_slp = of(i).reg_slp;
    x = of(i).corr.angle';
    y = of(i).reg_slp*x+of(i).reg_int;
    plot(x,y,'LineWidth',1,'Color',coloblind(i,:));
    hold on
    scatter(of(i).corr.angle,of(i).corr.vlc,'MarkerFaceColor',coloblind(i,:), 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0)
    s.MarkerFaceAlpha = 'flat';
end
 

%polarhistogram
a=[]; v=[];
for i=1:9
   for j=1:size(of(i).ttt_xy,2) 
        if ~isempty(of(i).ttt_xy(j).angle)
           a=[a,of(i).ttt_xy(j).max_angle];
           v=[v,of(i).ttt_vlc(j).nose_max_vlc];
        else
   end
end
end
a_pi = (90-a)*pi/180;
out = scatplot(v,a_pi,'circles',[],[],[],2,10)
compass(mean(v),mean(a))
xlim([-350 350])
ylim([-350 350])
% mean
hold on
mean_x=mean(peak_x);
mean_y=mean(peak_y);
scatter(mean_x,mean_y,'r');

% TTT heatmap plotting
i = 4; n=[];

    for j = 1:size(of(i).ttt_xy,2)
    if isempty(of(i).ttt_xy(j).angle)   
        n=[n,j];
    else 
    end
    end
of(i).ttt_xy(n)=[];
of(i).ttt_vlc(n)=[];

% manully sort!!!!!!!
   an=[]; vel=[];
    for j = 1:size(of(i).ttt_xy,2)
        an(:,j)=of(i).ttt_xy(j).angle;
        vel(:,j)=of(i).ttt_vlc(j).nose_norm;
    end
 %an=an'; vel=vel';
 an=an(181:300,:);
 vel=vel(181:299,:);

%amplitude
subplot(1,2,1)
a = heatmap(an,'Colormap',parula);
a.GridVisible = 'off';
a.ColorLimits = [0,70];
%velocity
subplot(1,2,2)
a = heatmap(vel,'Colormap',parula);
a.GridVisible = 'off';
a.ColorLimits = [0,300];

%recalculate 
i = 91,
on=[];vlc=[];an=[];vlc_pkt=[];
for j = 1:size(of(i).ttt_vlc,2)
    if ~isempty(of(i).ttt_vlc(j).nose_on)
        on=[on,of(i).ttt_vlc(j).nose_on];
        vlc=[vlc,of(i).ttt_vlc(j).nose_max_vlc];
        vlc_pkt=[vlc_pkt,of(i).ttt_vlc(j).peak_vlc_t];
        an=[an,of(i).ttt_xy(j).max_angle];
end
end
of(i).nose_prb = size(an,2)/size(of(i).ttt_vlc,2)*100;
of(i).nose_onset=mean(on);
of(i).nose_max_vlc=mean(vlc);
of(i).angle=mean(an);
of(i).peak_vlc_t=mean(vlc_pkt);

% calculate peak velocity time
for i= 1:104
   t=[];
   for j=1:size(of(i).ttt_vlc,2)
       if ~isempty(of(i).ttt_vlc(j).nose_on)
           [v,loc]= max(of(i).ttt_vlc(j).nose_vlc(200:240));
           of(i).ttt_vlc(j).peak_vlc_t=loc*5;
           t=[t,loc*5];
       else
       end
   end
   of(i).peak_vlc_t=mean(t);
end

