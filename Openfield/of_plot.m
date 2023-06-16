%Session number: j
i = 2
%Trial numer: i
j = 15;

%Plot velocity trace 
figure
plot(of_pack(i).ttt_vlc(j).nose_norm,'r')
hold on
plot(of_pack(i).ttt_vlc(j).neck_norm,'g')
hold on
plot(of_pack(i).ttt_vlc(j).chest_norm,'b')
hold on
plot(of_pack(i).ttt_vlc(j).hip_norm,'k')
xlim([95 400])
ylim([-50 200])

%Plot body location -250~500
figure
body_xy = (of_pack(i).ttt_xy(j).body);
for k = 150:299
    a = streamline({body_xy(k).xy});
    if k<=200
        r = (k-150)*0.005;
        set(a,'Color',[r r r],'LineWidth',1);
    elseif k>200 && k<=250
        r = (k-200)*0.016; %change 0.016 to adjust gradient
        set(a,'Color',[0.75 r r],'LineWidth',1);
    elseif k>250
        r = 0.9-(k-250)*0.01;
        set(a,'Color',[0.2 r r],'LineWidth',1);
    else
    end
end