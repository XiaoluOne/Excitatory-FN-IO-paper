%-------L7-GtACR PC analysis-------
hz1_CS=[]; hz2_CS=[]; ms10_CS=[]; ms250_CS=[]; ms500_CS=[]; hz10_CS=[];
hz1_SS=[]; hz2_SS=[]; ms10_SS=[]; ms250_SS=[]; ms500_SS=[]; hz10_SS=[];
for i = 1:127
   if isequal(pcs(i).trigger,'1Hz')
       hz1_CS = [hz1_CS,pcs(i).norm_PSTH.CS];
       hz1_SS = [hz1_SS,pcs(i).norm_PSTH.SS];
   elseif isequal(pcs(i).trigger,'2Hz')
       hz2_CS = [hz2_CS,pcs(i).norm_PSTH.CS];
       hz2_SS = [hz2_SS,pcs(i).norm_PSTH.SS];
   elseif isequal(pcs(i).trigger,'10ms')
       ms10_CS = [ms10_CS,pcs(i).norm_PSTH.CS];
       ms10_SS = [ms10_SS,pcs(i).norm_PSTH.SS];
   elseif isequal(pcs(i).trigger,'250ms_50Hz')
       ms250_CS = [ms250_CS,pcs(i).norm_PSTH.CS];
       ms250_SS = [ms250_SS,pcs(i).norm_PSTH.SS];
   elseif isequal(pcs(i).trigger,'500ms_50Hz')
       ms500_CS = [ms500_CS,pcs(i).norm_PSTH.CS];
       ms500_SS = [ms500_SS,pcs(i).norm_PSTH.SS];
   elseif isequal(pcs(i).trigger,'10Hz')
       hz10_CS = [hz10_CS,pcs(i).norm_PSTH.CS];
       hz10_SS = [hz10_SS,pcs(i).norm_PSTH.SS];
   else
   end
end

%------------save work sapce-------------
filename = 'L7Cre_Ai27_PC.mat';
save(filename,'pcs','hz10_CS','hz10_SS','hz1_CS','hz1_SS','hz2_CS','hz2_SS','ms10_CS','ms10_SS','ms250_CS','ms250_SS','ms500_CS','ms500_SS');

%--------plotting-------
subplot(6,2,1) % 10Hz
sem10 = std(hz10_CS')/sqrt(41);
plot(mean(hz10_CS'))
hold on
plot(mean(hz10_CS')+sem10)
hold on
plot(mean(hz10_CS')-sem10)

subplot(6,2,2)
sem10 = std(hz10_SS')/sqrt(41);
plot(mean(hz10_SS'))
hold on
plot(mean(hz10_SS')+sem10)
hold on
plot(mean(hz10_SS')-sem10)

subplot(6,2,3) % 1Hz
sem1 = std(hz1_CS')/sqrt(13);
plot(mean(hz1_CS'))
hold on
plot(mean(hz1_CS')+sem1)
hold on
plot(mean(hz1_CS')-sem1)

subplot(6,2,4)
sem1 = std(hz1_SS')/sqrt(13);
plot(mean(hz1_SS'))
hold on
plot(mean(hz1_SS')+sem1)
hold on
plot(mean(hz1_SS')-sem1)

subplot(6,2,5) % 2Hz
sem2 = std(hz2_CS')/sqrt(12);
plot(mean(hz2_CS'))
hold on
plot(mean(hz2_CS')+sem2)
hold on
plot(mean(hz2_CS')-sem2)

subplot(6,2,6)
sem2 = std(hz2_SS')/sqrt(12);
plot(mean(hz2_SS'))
hold on
plot(mean(hz2_SS')+sem2)
hold on
plot(mean(hz2_SS')-sem2)

subplot(6,2,7) % 500ms_50Hz
sem500 = std(ms500_CS')/sqrt(32);
plot(mean(ms500_CS'))
hold on
plot(mean(ms500_CS')+sem500)
hold on
plot(mean(ms500_CS')-sem500)

subplot(6,2,8)
sem500 = std(ms500_SS')/sqrt(32);
plot(mean(ms500_SS'))
hold on
plot(mean(ms500_SS')+sem500)
hold on
plot(mean(ms500_SS')-sem500)

subplot(6,2,9) % 250ms_50Hz
sem250 = std(ms250_CS')/sqrt(38);
plot(mean(ms250_CS'))
hold on
plot(mean(ms250_CS')+sem250)
hold on
plot(mean(ms250_CS')-sem250)

subplot(6,2,10)
sem250 = std(ms250_SS')/sqrt(38);
plot(mean(ms250_SS'))
hold on
plot(mean(ms250_SS')+sem250)
hold on
plot(mean(ms250_SS')-sem250)

subplot(6,2,11) % 10ms
sem = std(ms10_CS')/sqrt(31);
plot(mean(ms10_CS'))
hold on
plot(mean(ms10_CS')+sem)
hold on
plot(mean(ms10_CS')-sem)

subplot(6,2,12)
sem = std(ms10_SS')/sqrt(31);
plot(mean(ms10_SS'))
hold on
plot(mean(ms10_SS')+sem)
hold on
plot(mean(ms10_SS')-sem)

%find SS suppression, CS faciliation peak & timing, 10ms opto
for i = 1:32
    [pk,t]= min(pcs(i).norm_PSTH.SS(100:105));
    t=(t-1)*5;
    pcs(i).SS_t=t;
    pcs(i).SS_amp=pk;
    [pk,t]= max(pcs(i).norm_PSTH.CS(105:125));
    t=(t-1+5)*5;
    pcs(i).CS_t=t;
    pcs(i).CS_amp=pk;
end
% 2Hz CS amplitude
pk_cs = []; pk_ss=[];
for i = 83:94
    cs = [pcs(i).norm_PSTH.CS];
    ss = [pcs(i).norm_PSTH.SS];
    for j =1:5
        pk_cs(j,i-82)=max(cs(j*100:j*100+20));
        pk_ss(j,i-82)=min(ss(j*100:j*100+20));
    end
end

for i = 1:12
    st = pk_cs(1,i);
    for j = 1:5
        pk_cs(j,i) = pk_cs(j,i)/st*100;
    end
end
% 10Hz CS amplitude
pk_cs = []
for i = 95:131
    cs = [pcs(i).norm_PSTH.CS];
    for j =1:5
        pk_cs(j,i-78)=max(cs(80+20*j:100+20*j));
    end
end

for i = 1:18
    st = pk_cs(1,i);
    for j = 1:5
        pk_cs(j,i) = pk_cs(j,i)/st*100;
    end
end
pk_cs=pk_cs';

% opto-induced CS trial probability, 10ms
for i = 1:31
    a = 0;
    for j = 1:size(pcs(i).TTT.CS,2)
        jg = find(pcs(i).TTT.CS(j).t>0 & pcs(i).TTT.CS(j).t<0.1);
        if ~isempty(jg)
            a = a+1;
        else
        end
    end
    prob = a/size(pcs(i).TTT.CS,2)*100;
    pcs(i).CS_trial_prob = prob;
end