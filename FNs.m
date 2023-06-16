clear
%generate package of each cell type
list = dir('*.mat');
fns = struct('index',[],'mouse_test_ID',[],'recording_ID',[],'cell_nr',[],'trigger',[],'tr',[],'PSTH',[],'TTT',[]);
FN_nr = 0;
%--------------pack all data in one package------------------
for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (FN,1)
            FN_nr = FN_nr+1;
            fns(FN_nr).index = FN_nr;
            fns(FN_nr).mouse_test_ID = file_name; 
            fns(FN_nr).recording_ID = FN(j).recording_ID;
            fns(FN_nr).cell_nr = FN(j).cell_nr;
            fns(FN_nr).trigger = FN(j).trigger;
            fns(FN_nr).tr = FN(j).tr;
            fns(FN_nr).PSTH = FN(j).PSTH;
            fns(FN_nr).TTT = FN(j).TTT;
    end
end

%-----------calculate PSTH (no sliding window)---------------
% for i = 1:size(fns,2)
%    if isempty(fns(i).PSTH) 
%        fns(i).PSTH = smooth(psth(fns(i).TTT,5));
%    elseif ~isempty(fns(i).PSTH) 
%        fns(i).PSTH.naso = smooth(psth(fns(i).TTT.naso,5));
%        fns(i).PSTH.tempo = smooth(psth(fns(i).TTT.tempo,5));
%    else
%    end
% end
