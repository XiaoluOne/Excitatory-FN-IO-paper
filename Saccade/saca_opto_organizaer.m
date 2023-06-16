clear
mouse='15077-04';
list = dir('*.mat');
for i=1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    saca(i).mouse = mouse;
    saca(i).session = file_name;
    saca(i).opto=saca_pack.opto;
    saca(i).raw = saca_pack.raw;
%     saca(i).tr = saca_pack.tr;
    saca(i).TTT=saca_pack.TTT;
end
save(mouse,'saca');