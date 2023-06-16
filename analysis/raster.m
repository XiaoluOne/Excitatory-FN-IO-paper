function [t] = raster(cell,n)
%input n: array the numbers of cells that you want to plot 

    i = n
    
    figure(1)
    t = zeros(size(cell(i).TTT.CS,2),1500); %default 1500
    for j = 1:size(cell(i).TTT.CS,2)
        trial = round(1000*cell(i).TTT.CS(j).t'+500);
        idx = find(~trial);
        trial(idx) = 1;
        t(j,trial) = trial;
    end
    t = logical(t);
    figure(1);
    plotSpikeRaster(t,'plotType','vertline');
    
%     figure(2)
%     t = zeros(size(cell(i).TTT.tempo,2),1500); %default 1500
%     for j = 1:size(cell(i).TTT.tempo,2)
%         trial = round(1000*cell(i).TTT.tempo(j).t'+500);
%         idx = find(~trial);
%         trial(idx) = 1;
%         t(j,trial) = trial;
%     end
%     t = logical(t);
%     figure(2);
%     plotSpikeRaster(t,'plotType','vertline');
    
    
end
end


