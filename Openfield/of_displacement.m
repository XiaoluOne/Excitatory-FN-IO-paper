nose = of_pack.ttt_xy.nose_xy(1,:);
neck = of_pack.ttt_xy.neck_xy(1,:);
chest = of_pack.ttt_xy.chest_xy(1,:);
hip = of_pack.ttt_xy.hip_xy(1,:);
for i=1:400
 dis_nose(i) = norm(of_pack.ttt_xy.nose_xy(i,:)-nose)/2.8;
 dis_chest(i) = norm(of_pack.ttt_xy.chest_xy(i,:)-chest)/2.8;
 dis_neck(i) = norm(of_pack.ttt_xy.neck_xy(i,:)-neck)/2.8;
 dis_hip(i) = norm(of_pack.ttt_xy.hip_xy(i,:)-hip)/2.8;
end
plot(smooth(dis_nose),'r')
hold on
plot(smooth(dis_neck),'g')
plot(smooth(dis_chest),'b')
plot(smooth(dis_hip),'k')
xlim([100 350])
