

function saca_pack = dat_out_opto_ephys(filename,t_pre,cell_tp,psth,cell_mod,tas,opto_length)
  t_pre = t_pre / 1000;

  % ------  CELL TYPE related data  ------
    cell_def(size(cell_tp,2)) = struct('nr',[],'type',[],'mod',[]);
    for i = 1:size(cell_tp,2)
        cell_def(i).nr = psth(i).cell;
        cell_def(i).type = cell_tp(i).type;
        cell_def(i).mod = cell_mod(i).type;
    end

  % ------  TIME related data  ------
      fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
      t_nr = 1500; 
      t_min = - t_pre;
      t_max = t_min + (t_nr - 1) / fs;
      t = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules

  % ------  PSTH related data  ------
      freq_wfm(size(cell_mod,2)) = struct('nr',[],'tr',[],'PSTH',[]);
      for i = 1:size(cell_mod,2)
        % Smoothing frequency line
          freq_x = linspace(min([psth(i).bar.bin]),max([psth(i).bar.bin]),t_nr);
          freq_tr = interp1([psth(i).bar.bin],[psth(i).bar.h],freq_x,'spline');
        % Arranging data
          freq_wfm(i).nr = psth(i).cell;
          freq_wfm(i).tr = freq_tr;
      end
   % ------  TRIAL TO TRIAL REGRESSION data  ------
        TTT(size(cell_mod,2)) = struct('nr',[],'tss',[]);
        for i = 1:size(cell_mod,2)
            TTT(i).nr = psth(i).cell;
            TTT(i).tss = tas(i).tss; 
        end

  % ------ Saving data  ------
    saca_pack = struct('t',t,'cell_def',cell_def,'SPK',freq_wfm,'TTT',TTT,'OPTO',opto_length);
    cd(pwd);
    filename = strcat('sacapack_',filename,'.mat');
    save(filename,'saca_pack');
end