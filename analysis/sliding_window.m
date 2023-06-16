function [PSTH] = sliding_window(TTT,window_size,step)
%bin_size should be in ms 

window_size = window_size/1000;
step=step/1000;
m = 0;
       for n = 0:step:3.9999
           a = 0;
           m = m+1;
           for j = 1:size(TTT,2) %trial loop
               for k = 1:size(TTT(j).t,1) %spike even loop
                   if TTT(j).t(k) >= n && TTT(j).t(k) < n+window_size
                       a = a+1;
                   else
                   end
               end
           end
%            m = round((n+0.5)/0.005+1);
%            m = round((n+0.5)*100+1);
           PSTH(m) = a/window_size/size(TTT,2);
       end
end
