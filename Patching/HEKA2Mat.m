clear
%load and read HEKA data in Matlab
HEKA_Importer('19376-03-AAV9-ChR2-2mM Ca.dat');

%transfer data from table into struct 
patch = ans.RecTable;
patch = table2struct(patch);
field = {'Experiment','Rs','Cm','Vhold','Rs_uncomp','RsFractionComp','TimeUnit','Comment','Temperature','ExternalSolution','InternalSolution','SR','TimeStamp'};
patch = rmfield(patch,field);

%saving mat file 
 save('19376-03-AAV9-ChR2-2mM Ca.mat','patch');