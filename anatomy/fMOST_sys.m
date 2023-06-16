clear
list = dir('*.csv');
cell = struct('cell_ID',[],'location',[],'region',[],'acromyn',[],'axon',[],'side',[],'density',[]);
n = 0;
for i = 1:size(list,1)
   file_name = list(i).name;
   opts = detectImportOptions(file_name);
   raw = table2struct(readtable(file_name,opts));
   for j = 1:size(raw,1)
       n = n+1;
       cell(n).cell_ID = file_name;
       cell(n).location = raw(j).Var1;
       cell(n).region = raw(j).Var2;
       cell(n).acromyn = raw(j).Var3;
       cell(n).axon = raw(j).Var4;
       cell(n).side = raw(j).Var5;
       cell(n).density = raw(j).Var6;
   end
end
