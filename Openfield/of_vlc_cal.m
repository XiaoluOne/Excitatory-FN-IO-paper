function [vlc,data] = of_vlc_cal(raw_data)
%This function is to import the raw file from DLC and calculate movement
%features

%remove irrelavent field of DLC file
remove = [1,4,5,6,7,8,9,10,13,16,19];
raw_data(:,remove) = []; 

%change the variable name
name = {'nose_x','nose_y','neck_x','neck_y','chest_x','chest_y','hip_x','hip_y'};
raw_data.Properties.VariableNames= name;
data = table2struct(raw_data);

% calculating velocity by using norm function
vlc = struct('nose_vlc',[],'neck_vlc',[],'chest_vlc',[],'hip_vlc',[]);
for i = 2:size(data,1)
    vlc(i-1).nose_vlc = norm(data(i).nose_x-data(i-1).nose_x,data(i).nose_y-data(i-1).nose_y)/2.8*200; %1mm=2.046 pixels for passive opto experiment;
    vlc(i-1).neck_vlc = norm(data(i).neck_x-data(i-1).neck_x,data(i).neck_y-data(i-1).neck_y)/2.8*200;
    vlc(i-1).chest_vlc = norm(data(i).chest_x-data(i-1).chest_x,data(i).chest_y-data(i-1).chest_y)/2.8*200; 
    vlc(i-1).hip_vlc = norm(data(i).hip_x-data(i-1).hip_x,data(i).hip_y-data(i-1).hip_y)/2.8*200;
end

end

