function [TTT] = instantanous(TTT,window,step)
%window is sliding window size, in ms (0.1s,0.05s)
%step is sliding step, in ms(0.005s)

%calculate intantaneous firing rate
window = window/1000;
step=step/1000;

    for i = 1:size(TTT,2)     
    n = 0;
    for j = -0.5:step:0.9 %step size 0.005
        ind = 0;
        n = n+1;
        for k = 1:size(TTT(i).t,1)
                if TTT(i).t(k) >= j && TTT(i).t(k)< j+window %window size 0.05s
                    ind = ind+1;
                else
                end
        end
        TTT(i).spk(n) = ind/window;%window size 0.05s
    end
    TTT(i).spk = smooth(TTT(i).spk);
    end

%normalize instantaneous firing rate (minus baseline firing rate)
for i = 1:size(TTT,2) %trial
    spk_0 = mean(TTT(i).spk(1:100));
    for j = 1:size(TTT(i).spk,1)
        TTT(i).spk(j) = TTT(i).spk(j)-spk_0;
    end
end

%sliding blink trace (not good to slide blk because some individual blk
%onset is really late)
%     for i = 1:size(cell,2)
%         for j = 1:size(cell(i).ttt.tss_CR,2)
%             blk = [];
%             n=0;
%             for k = 1:250
%                 a = mean(cell(i).ttt.tss_CR(j).blk(k:(50+k)));
%                 n = n+1;
%                 blk(n) = a;
%             end
%                 cell(i).ttt.tss_CR(j).blk = blk;
%         end
%     end

end

