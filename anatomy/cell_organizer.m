clear
list = dir('*.mat');
soma=struct();
soma_nr = 0;
%--------------pack all data in one package------------------
for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (cell,1)
            soma_nr = soma_nr+1;
            soma(soma_nr).index = 'HC';
            soma(soma_nr).section_ID = file_name; 
            soma(soma_nr).ML = cell(j,1);
            soma(soma_nr).DV = cell(j,2);
            soma(soma_nr).AP = cell(j,3);
    end
end
filename = '16623_04_HC.mat';
save(filename,'soma');
