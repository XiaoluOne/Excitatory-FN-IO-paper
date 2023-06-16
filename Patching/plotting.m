tr_tr=[];
for i = 1:6
   aa = tr_norm(:,i);
   cc = seven_shorten(aa,200500,20050);
   tr_tr(:,i)=cc;
end

bb = seven_shorten(mean(tr_norm'),200500,20050);
z=mean(tr_norm');
plot(tr_tr(4500:6500,:),'k')
hold on
plot(bb(4500:6500),'r')
ylim([-6e-11 10e-11]);