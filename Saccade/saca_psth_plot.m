for i = 1:size(saca_pack.cell_def,2)
    figure(i)
    plot(saca_pack.SPK(i).tr_naso,'r')
    hold on 
    plot(saca_pack.SPK(i).tr_tempo,'k')
    legend('red naso','black tempo')
end