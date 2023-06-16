%------organize spontaneuos sacade package for each mouse------
clear
mouse='All';
list = dir('*.mat');
for i=1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    saca_pack(i).mouse = mouse;
    saca_pack(i).session = file_name;
    saca_pack(i).type=saca.type;
    saca_pack(i).naso=saca.naso;
    saca_pack(i).tempo=saca.tempo;
end
saca = saca_pack;

%-------save package-----------
save(mouse,'saca');