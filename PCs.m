clear
%generate package of each cell type
list = dir('*.mat');
pcs = struct('index',[],'mouse_test_ID',[],'recording_ID',[],'cell_nr',[],'trigger',[],'tr',[],'PSTH',[],'TTT',[],'norm_PSTH',[],'CS_good',[]);
PC_nr = 0;
%--------------pack all data in one package------------------
for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (PC,1)
        if isequal(PC(j).cell_tp,'PC')
            PC_nr = PC_nr+1;
            pcs(PC_nr).index = PC_nr;
            pcs(PC_nr).mouse_test_ID = file_name; 
            pcs(PC_nr).recording_ID = PC(j).recording_ID;
            pcs(PC_nr).cell_nr = PC(j).cell_nr;
            pcs(PC_nr).trigger = PC(j).trigger;
            pcs(PC_nr).tr = PC(j).tr;
            pcs(PC_nr).PSTH = PC(j).PSTH;
            pcs(PC_nr).TTT = PC(j).TTT;
            if ~isempty(PC(j).tr.CS)
                pcs(PC_nr).CS_good = 1;
            elseif isempty(PC(j).tr.CS)
                pcs(PC_nr).CS_good = 0;
            else
            end
        else
        end
    end
end
