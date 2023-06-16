%Single opto analysis
Rec = 4;
clear amp; clear tr_norm; clear b; 
tr = patch(Rec).dataRaw{1};
for i = 1:size(tr,2)
    a = tr(:,i);
    bsl = mean(a(1:5e4));
    b = a-bsl;
    tr_norm(:,i) = b;
    [maxi,locs] = max(b(5e4:5.5e4));
    begin = 5e4+locs-1-5;
    finish = 5e4+locs-1+5;
    amp (i) = mean(b(begin:finish)); %average of 0.2 ms
end
amp = amp*1e12;
% patch(Rec).amp = amp;
avr_amp = mean(amp);