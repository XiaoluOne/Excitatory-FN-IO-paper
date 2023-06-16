%-----calculate sacade kinetics----- 
%(peak amplitude, time@ peak ampitude, peak velocity, time@ peak velocity)
for i = 1:size(saca,2)
    
    for j = 1:size(saca(i).naso,2)
        tr = smooth(-saca(i).naso(j).tr);
        vel = diff(tr);
      
        %------peak velocity & timing-----
        saca(i).naso(j).vel=vel;
        [pk_vel,pkt_vel] = max(vel(100:130)); %peak velocity & timing
        saca(i).naso(j).pk_vel = pk_vel/0.005;
        saca(i).naso(j).pkt_vel = (pkt_vel)*5;
        
        %------peak amplitude & timing-----
        [pk_amp,pkt_amp]= max(tr(100:130)); 
        saca(i).naso(j).pk_amp = pk_amp;% result in degree
        saca(i).naso(j).pkt_amp = (pkt_amp-1)*5; % result in ms
        
        
    end
    

end

%--------Refinement, remove nosy saccade
for i=1:size(saca,2)
    vel=[saca(i).naso(1:length(saca(i).naso)).pk_vel];
    [a,b]=find(vel<100);
    saca(i).naso(b)=[];
    pkt_vel=[saca(i).naso(1:length(saca(i).naso)).pkt_vel];
    [c,d]=find(pkt_vel>100);
    saca(i).naso(d)=[];
end


for i = 1:size(saca,2)
    n = length(saca(i).naso);
    % nasal saccade kinetics
    tr=[]; vel=[];
    for j = 1:n
        tr(:,j)=saca(i).naso(j).tr;
        vel(:,j)=saca(i).naso(j).vel;
    end
    saca(i).tr=tr;
    saca(i).vel=vel;
    saca(i).pro = n/30; % /min
    saca(i).pk_vel = mean([saca(i).naso(1:n).pk_vel]);
    saca(i).pk_amp = mean([saca(i).naso(1:n).pk_amp]);
    
    saca(i).vel_pkt = mean([saca(i).naso(1:n).pkt_vel]);
    saca(i).amp_pkt = mean([saca(i).naso(1:n).pkt_amp]);
    
    saca(i).vel_sd = std([saca(i).naso(1:n).pk_vel]);
    saca(i).amp_sd = std([saca(i).naso(1:n).pk_amp]);
    
end
