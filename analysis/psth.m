function [PSTH] = psth(TTT,bin_size)
%bin_size should be in ms 

bin_size = bin_size/1000;
m = 0;
       for n = -0.5:bin_size:2.9999
           a = 0;
           m = m+1;
           for j = 1:size(TTT,2) %trial loop
               for k = 1:size(TTT(j).water_t,1) %spike even loop
                   if TTT(j).water_t(k) >= n && TTT(j).water_t(k) < n+bin_size
                       a = a+1;
                   else
                   end
               end
           end
%            m = round((n+0.5)/0.005+1);
%            m = round((n+0.5)*100+1);
           PSTH(m) = a/bin_size/size(TTT,2);
       end
end