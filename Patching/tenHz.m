%10 Hz opto trial analysis

Rec = 39;
clear amp; clear tr_norm; clear pks;
tr = patch(Rec).dataRaw{2};
for i = 1:10
    a = tr(:,i);
    bsl = mean(a(1:2e4));
    abs = a-bsl;
    tr_norm(:,i) = abs;
    n = 2e4;
    for j = 1:10
        m = n+0.2e4;
        [pk,locs] = max(abs(n:m));
        begin = n+locs-1-5;
        finish = n+locs-1+5;
        pks(j) = mean(abs(begin:finish));
        n=n+0.2e4;
    end
    amp(i,:) = pks;
end
amp = amp*1e12;
patch(Rec).amp = amp;
avr_amp = mean(amp);