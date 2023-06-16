clear
mouse_name = 'All_mice';
list = dir('*.mat');
a = struct('mouse_ID',[],'file_ID',[],'opto',[],'ttt_xy',[],'ttt_vlc',[]);

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');  
    a(i).mouse_ID = mouse_name;
    a(i).file_ID = file_name; 
    a(i).opto = of_pack.opto;
    a(i).ttt_xy = of_pack.of_xy;
    a(i).ttt_vlc = of_pack.of_vlc;
end
of_pack = a;
filename = strcat(mouse_name,'.mat');
save(filename,'of_pack');