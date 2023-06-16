%-----------select fast response cells (latency<20ms)
fn10_fast = [];
for i = 1:519
   if isequal(fns(i).mod,'fac') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'10ms_1Hz')
       fn10_fast = [fn10_fast,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'10ms_1Hz')
       fn10_fast = [fn10_fast,fns(i).norm_PSTH];
   else
   end   
end

fn250_fast = [];
for i = 1:519
   if isequal(fns(i).mod,'fac') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'250ms_50Hz')
       fn250_fast = [fn250_fast,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'250ms_50Hz')
       fn250_fast = [fn250_fast,fns(i).norm_PSTH];
   else
   end   
end

fn500_fast = [];
for i = 1:519
   if isequal(fns(i).mod,'fac') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'500ms_50Hz')
       fn500_fast = [fn500_fast,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'500ms_50Hz')
       fn500_fast = [fn500_fast,fns(i).norm_PSTH];
   else
   end   
end

fn10hz_fast = [];
for i = 1:519
   if isequal(fns(i).mod,'fac') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'500ms_10Hz')
       fn10hz_fast = [fn10hz_fast,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && fns(i).mod_on<=20 && isequal(fns(i).trigger,'500ms_10Hz')
       fn10hz_fast = [fn10hz_fast,fns(i).norm_PSTH];
   else
   end   
end

aa = mean(fn10_fast'); bb = mean(fn250_fast'); cc=mean(fn500_fast'); dd=mean(fn10hz_fast');

plot(aa,'r','LineWidth',3)
hold on
plot(bb,'b','LineWidth',3)
hold on
plot(cc,'g','LineWidth',3)
hold on
plot(dd,'k','LineWidth',2)
legend('10ms_1Hz,n=109','250ms_50Hz,n=70','500ms_50Hz,n=77','500ms_10Hz,n=28')

%------------select vc cells (cells with transient inhibition)
vc10=[]; vc10hz=[]; vc250=[];vc500=[];
for i = 1:519
   if isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'10ms_1Hz')
       vc10 = [vc10,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'250ms_50Hz')
       vc250 = [vc250,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'500ms_50Hz')
       vc500 = [vc500,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'500ms_10Hz')
       vc10hz = [vc10hz,fns(i).norm_PSTH];
   else
   end
end

%------------codes for VC inhibition (muscimol+dual opto) analysis
control=[]; io_inhb=[];
for i = 1:18
   if isequal(fns(i).trigger,'before') || isequal(fns(i).trigger,'10ms_1Hz') 
       control = [control,fns(i).norm_PSTH];
   elseif isequal(fns(i).trigger,'after') || isequal(fns(i).trigger,'dual_sim10ms_1Hz') 
       io_inhb=[io_inhb,fns(i).norm_PSTH];
   else 
   end
end


m_control = mean(control');
sem_control = std(control')/sqrt(9);
m_io_inhb = mean(io_inhb');
sem_io_inhb = std(io_inhb')/sqrt(9);

delta = m_control-m_io_inhb;

plot(m_control,'k')
hold on 
plot(m_control+sem_control,'k')
hold on 
plot(m_control-sem_control,'k')
hold on 
plot(m_io_inhb,'r')
hold on 
plot(m_io_inhb+sem_io_inhb,'r')
hold on 
plot(m_io_inhb-sem_io_inhb,'r')
xlim([40 240])
ylim([0 400])

%--------calculate before after muscimol-------
control_sup =[];
muscimol_sup =[];
for i =1:16
    c = control(:,i);
    control_sup = [control_sup,min(c(108:120))]; %detect window 40:100ms after opto
    m = io_inhb(:,i);
    muscimol_sup = [muscimol_sup,min(m(108:120))];
end
control_sup=control_sup';
muscimol_sup =muscimol_sup';


%------- modulation detaction, onset calculation---------
for i = 1:717
   bsl = mean(fns(i).PSTH(1:90));
   sd = std(fns(i).PSTH(1:90));
   a = abs(fns(i).PSTH-bsl);
   index=find(a(100:200)>=3*sd,1);
   if ~isempty(index)
       fns(i).mod_on = index*5;
   elseif isempty(index)
       fns(i).mod_on = 0;
   else 
   end
   
   if mean(fns(i).PSTH(100:150))-bsl>0.1*bsl
       fns(i).mod = 'fac';
   elseif mean(fns(i).PSTH(100:150))-bsl< -0.1*bsl
       fns(i).mod='sup';
   else
       fns(i).mod='nom';
   end
end

%------------save work sapce-------------
filename = 'FN_single_opto_MOD.mat';
save(filename,'fns','fn10_fast','fn10hz_fast','fn250_fast','fn500_fast','vc10','vc10hz','vc250','vc500','dip10','dip250','dip500','vc_sup10','vc_sup250','vc_sup500');

%--------organize VC cells---------------
vc10=[]; vc10hz=[]; vc250=[];vc500=[];
for i = 1:519
   if isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'10ms_1Hz')
       vc10 = [vc10,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'250ms_50Hz')
       vc250 = [vc250,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'500ms_50Hz')
       vc500 = [vc500,fns(i).norm_PSTH];
   elseif isequal(fns(i).mod,'vc') && isequal(fns(i).trigger,'500ms_10Hz')
       vc10hz = [vc10hz,fns(i).norm_PSTH];
   else
   end
end

%----------plot VC cells----------
a = mean(vc10');
sea = std(vc10')/sqrt(41);
b = mean(vc10hz');
seb = std(vc10hz')/sqrt(6);
c = mean(vc250');
sec = std(vc250')/sqrt(12);
d = mean(vc500');
sed = std(vc500')/sqrt(13);

subplot(2,2,1)
plot(smooth(a))
hold on
plot(smooth(a+sea))
hold on
plot(smooth(a-sea))
xlim([40 240])
ylim([50 250])

subplot(2,2,2)
plot(smooth(b))
hold on
plot(smooth(b+seb))
hold on
plot(smooth(b-seb))
xlim([40 240])
ylim([50 400])

subplot(2,2,3)
plot(smooth(c))
hold on
plot(smooth(c+sec))
hold on
plot(smooth(c-sec))
xlim([40 240])
ylim([50 250])

subplot(2,2,4)
plot(smooth(d))
hold on
plot(smooth(d+sed))
hold on
plot(smooth(d-sed))
xlim([40 240])
ylim([50 300])

%---------calculate dip timing--------
dip10=[];
for i = 1:41
    a = vc10(:,i);
   [value,indx]=min(a(105:120));  %detection window 25-100 after opto
   dip10 = [dip10;(indx-1+5)*5];
end
a =mean(dip10);

dip250=[];
for i = 1:12
    b = vc250(:,i);
   [value,indx]=min(b(105:120));
   dip250 = [dip250;(indx-1+5)*5];
end
b =mean(dip250);

dip500=[];
for i = 1:13
    c = vc500(:,i);
   [value,indx]=min(c(105:120));
   dip500 = [dip500;(indx-1+5)*5];
end
c =mean(dip500);

%-------organize suppressed only cells--------
vc_sup10=[]; vc_sup250=[];vc_sup500=[];
for i=1:519
   if isequal(fns(i).trigger,'10ms_1Hz') && isequal(fns(i).mod,'vc_sup') 
       vc_sup10 = [vc_sup10,fns(i).norm_PSTH];
   elseif isequal(fns(i).trigger,'250ms_50Hz') && isequal(fns(i).mod,'vc_sup')
       vc_sup250 = [vc_sup250,fns(i).norm_PSTH];
   elseif isequal(fns(i).trigger,'500ms_50Hz') && isequal(fns(i).mod,'vc_sup')
       vc_sup500 = [vc_sup500,fns(i).norm_PSTH];
   else
   end
end

sem10=std(vc_sup10')/sqrt(35);
sem250=std(vc_sup250')/sqrt(11);
sem500=std(vc_sup500')/sqrt(12);

subplot(3,1,1)
plot(smooth(mean(vc_sup10')))
hold on
plot(smooth(mean(vc_sup10')+sem10))
hold on
plot(smooth(mean(vc_sup10')-sem10))
xlim([40 240])
ylim([40 120])

subplot(3,1,2)
plot(smooth(mean(vc_sup250')))
hold on
plot(smooth(mean(vc_sup250')+sem250))
hold on
plot(smooth(mean(vc_sup250')-sem250))
xlim([40 240])
ylim([40 120])

subplot(3,1,3)
plot(smooth(mean(vc_sup500')))
hold on
plot(smooth(mean(vc_sup500')+sem500))
hold on
plot(smooth(mean(vc_sup500')-sem500))
xlim([40 240])
ylim([40 120])