%calculate the average projection density of each regions
m(:,1) = all_mice(:,1);
m(:,2)= all_mice(:,2);
m(:,3) = all_mice(:,5);
m(:,4) = all_mice(:,8);
avr = [];
for i = 1:320
    v = [m(i,2),m(i,3),m(i,4)];
    v = table2array(v);
    avr = [avr;mean(v)];
end
m(:,5) = array2table(avr);

% saving
filename = 'all_mice.mat';
save(filename,'all','m','top50');


a = table2array(top50);
b = heatmap(a,'Colormap','hot');
b.GridVisible = 'off';
b.ColorLimits = [5,50];
