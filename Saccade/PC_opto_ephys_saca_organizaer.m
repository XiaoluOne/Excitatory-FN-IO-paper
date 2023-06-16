clear
%--------------input-------------------%
animal = '14051-01';
test = 'PC31';

%-----------organizing package----------%
n = 0
list = dir('*.mat');
for i = 1:size(list,1)
   file_name = list(i).name;
   load (file_name,'-mat');
   if isfield(saca_pack,'OPTO') 
       for j = 1:size(saca_pack.cell_def,2)
           n = n+1;
           PC(n).recording_ID = file_name; 
           PC(n).cell_nr = saca_pack.SPK(j).nr;
           PC(n).cell_tp = saca_pack.cell_def(j).type;
           PC(n).trigger = saca_pack.OPTO;  
           PC(n).tr.SS = saca_pack.SPK(j).SS_tr;
           PC(n).tr.CS = saca_pack.SPK(j).CS_tr;
           PC(n).PSTH.SS = saca_pack.SPK(j).SS_PSTH;
           PC(n).PSTH.CS = saca_pack.SPK(j).CS_PSTH;
           PC(n).TTT.SS = saca_pack.TTT(j).SS;
           PC(n).TTT.CS = saca_pack.TTT(j).CS;
       end
   elseif ~isfield(saca_pack,'OPTO')
       for j = 1:size(saca_pack,2)
           n = n+1;
           PC(n).recording_ID = file_name; 
           PC(n).cell_nr = saca_pack(j).nr;
           PC(n).cell_tp = saca_pack(j).type;
           PC(n).trigger.naso = saca_pack(j).SACA.naso;
           PC(n).trigger.tempo = saca_pack(j).SACA.tempo;
           if ~isempty(saca_pack(j).SS_mod)
               PC(n).tr.SS_naso = saca_pack(j).SS_tr.naso;
               PC(n).tr.SS_tempo = saca_pack(j).SS_tr.tempo;
               PC(n).PSTH.SS_naso = [];
               PC(n).PSTH.SS_tempo = [];
               PC(n).TTT.SS_naso = saca_pack(j).SS_TTT.naso;
               PC(n).TTT.SS_tempo = saca_pack(j).SS_TTT.tempo;
               PC(n).TTT.CS_naso = [];
               PC(n).TTT.CS_tempo = [];
               PC(n).tr.CS_naso = [];
               PC(n).tr.CS_tempo = [];      
               PC(n).PSTH.CS_naso = [];
               PC(n).PSTH.CS_tempo = [];
           else
           end
           if ~isempty(saca_pack(j).CS_mod)
               PC(n).tr.CS_naso = saca_pack(j).CS_tr.naso;
               PC(n).tr.CS_tempo = saca_pack(j).CS_tr.tempo;      
               PC(n).TTT.CS_naso = saca_pack(j).CS_TTT.naso;
               PC(n).TTT.CS_tempo = saca_pack(j).CS_TTT.tempo;
           else
           end
       end
   else
       
   end
end
PC_ = struct2table(PC);
PC_ = sortrows(PC_,'cell_nr');
PC = table2struct(PC_);
cd(pwd);
filename = strcat(animal,'-',test,'.mat');
save(filename,'PC');

