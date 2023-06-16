clear
%--------------input-------------------%
animal = '10124-02';
test = 'PC8';

%-----------organizing package----------%
n = 0
list = dir('*.mat');
for i = 1:size(list,1)
   file_name = list(i).name;
   load (file_name,'-mat');
   if isfield(saca_pack,'OPTO') 
       for j = 1:size(saca_pack.cell_def,2)
           n = n+1;
           FN(n).recording_ID = file_name; 
           FN(n).cell_nr = saca_pack.SPK(j).nr;
           FN(n).trigger = saca_pack.OPTO;  
           FN(n).tr = saca_pack.SPK(j).tr;
           FN(n).PSTH = saca_pack.SPK(j).PSTH;
           FN(n).TTT= saca_pack.TTT(j).tss;
       end
   elseif ~isfield(saca_pack,'OPTO')
       for j = 1:size(saca_pack.cell_def,2)
           n = n+1;
           FN(n).recording_ID = file_name; 
           FN(n).cell_nr = saca_pack.SPK(j).nr;
           FN(n).trigger.naso = saca_pack.SACA.naso;
           FN(n).trigger.tempo = saca_pack.SACA.tempo;
           FN(n).tr.naso = saca_pack.SPK(j).tr_naso;
           FN(n).tr.tempo = saca_pack.SPK(j).tr_tempo; 
           FN(n).PSTH.naso = [];
           FN(n).PSTH.tempo = []; 
           FN(n).TTT.naso = saca_pack.TTT(j).naso_tss;
           FN(n).TTT.tempo = saca_pack.TTT(j).tempo_tss;
       end
   else 
   end
end
FN_ = struct2table(FN);
FN_ = sortrows(FN_,'cell_nr');
FN = table2struct(FN_);
cd(pwd);
filename = strcat(animal,'-',test,'.mat');
save(filename,'FN');

%plotting
% for i = 1:2:size(FN,1)
%     figure
%     plot(FN(i+1).tr,'b')
%     hold on
%     plot(FN(i).tr,'r')
%     legend('before','after')
% end
