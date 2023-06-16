
%remove duplicated regions 
i = 1;
while i>0 
    if isequal(cell(i).region,cell(i+1).region)
        cell(i+1)=[];
    elseif ~isequal(cell(i).region,cell(i+1).region)
        i=i+1;
    else
    end
end

filename='fMOST';
save(filename,'cell','region','density_hm','density_hm_sum')

%generate heatmap
neuron = struct2table(cell);
loc = struct2table(region);
loc=loc(1:102,'region');

for i = 412:433
    if ismember(neuron(i,'region'),loc) && isequal(cell(i).side,'L')
        [lia,locb]=ismember(neuron(i,'region'),loc);
        density_hm(locb,27)=cell(i).density;
    elseif ismember(neuron(i,'region'),loc) && isequal(cell(i).side,'R')
        [lia,locb]=ismember(neuron(i,'region'),loc);
        density_hm(locb,28)=cell(i).density;
    else
    end
end

% sum left and right
for i = 1:102
    for j = 1:2:27
        density_hm_sum(i,j+1)=density_hm(i,j)+density_hm(i,j+1);
    end
end
a = [1:2:27];
density_hm_sum(:,a)=[];

% color map plotting
a = heatmap(density_hm_sum,'Colormap',copper);
a.GridVisible = 'off';
a.ColorLimits = [0,5];

%patch plotting 
c=(0:0.1:10.1);
x =zeros(1,102);
y=1:102;
for i=1:28
    x(1,:)=i;
    c = density_hm(:,i);
    patch(x,y,c,'EdgeColor','interp','Marker','o','MarkerFaceColor','flat');
    hold on
end
colormap(flipud(cool))
colorbar;
