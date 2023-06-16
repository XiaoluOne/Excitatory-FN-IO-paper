%---Put SS and CS from the same PC in one package, for opto experiment---
clear
opto_info = '10HZ';
file_name = '10HZ_221020_145047';
load('sacapack_ss');
%--------------------------------------%
PC = struct('cell_def',[],'SPK',[],'TTT',[],'OPTO',[]);
for i = 1:size(saca_pack.cell_def,2)
    PC.cell_def(i).nr = saca_pack.cell_def(i).nr;
    PC.cell_def(i).type = saca_pack.cell_def(i).type;
    PC.cell_def(i).SS_MOD = saca_pack.cell_def(i).mod;
    PC.SPK(i).nr = saca_pack.SPK(i).nr;
    PC.SPK(i).SS_tr = saca_pack.SPK(i).tr;
    PC.SPK(i).SS_PSTH = saca_pack.SPK(i).PSTH;
    PC.TTT(i).nr = saca_pack.TTT(i).nr;
    PC.TTT(i).SS = saca_pack.TTT(i).tss;
end
load('sacapack_cs');
for i = 1:size(saca_pack.cell_def,2)
    for j = 1:size(PC.cell_def,2)
       if isequal(saca_pack.SPK(i).nr,PC.cell_def(j).nr)
           PC.cell_def(j).CS_MOD = saca_pack.cell_def(i).mod;
           PC.SPK(j).CS_tr = saca_pack.SPK(i).tr;
           PC.SPK(j).CS_PSTH = saca_pack.SPK(i).PSTH;
           PC.TTT(j).CS = saca_pack.TTT(i).tss;
       else   
       end
    end
end
PC.OPTO = opto_info;
clear saca_pack
saca_pack = PC;
save(file_name,'saca_pack');