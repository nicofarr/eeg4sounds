clear

infile='/Users/nicolasfarrugia/Documents/recherche/data_eeg/eeg4sounds/LA17/LA80OddSTE_20170906_113425.mff';


%%% Identification des essais
cfg=[];
cfg.namesuj='CP12';
cfg.trialdef.prestim=0.5;
cfg.trialdef.poststim=1;
cfg.dataset=infile;
cfg=ft_definetrial(cfg);