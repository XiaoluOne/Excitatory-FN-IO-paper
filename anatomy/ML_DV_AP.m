ML_max=max([cell(1:579).ML]);
ML_min=min([cell(1:579).ML]);
dv_ML=ML_max-ML_min;
DV_max=max([cell(1:579).DV]);
DV_min=min([cell(1:579).DV]);
dv_DV=DV_max-DV_min;
%--------------------------------
% BinEdges=[-1500 -1200 -900 -600 -300] %for ML
BinEdges=[-4250 -4050 -3850 -3650 -3350] % for DV
HC1 = [cell(406:495).DV];
h1=histogram(HC1,5,'BinEdges',BinEdges)
h1= h1.Values
