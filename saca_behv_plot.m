tr = [];
figure()
for i = 1:size(saca_tempo,2)
    tr(i,:) = [saca_tempo(i).tr(1:200)];
    plot(saca_tempo(i).tr)
    hold on
end
hold on
plot(mean(tr),'k','LineWidth',2)

tr = [];
figure()
for i = 1:size(saca_naso,2)
    tr(i,:) = [saca_naso(i).tr(1:200)];
    plot(saca_naso(i).tr)
    hold on
end
hold on
plot(mean(tr),'k','LineWidth',2)

