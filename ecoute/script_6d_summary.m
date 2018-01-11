%% 6b - Interpolate
%% -- input : donn�es pre-clean�es ( = brutes utiles moins elec bruit�es moins artefacts) et données clean (après ICA)
%% -- output : donn�es clean ICA interpolees et donnees pre-cleanees interpolees
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/data_ICA_interp/*.mat']);

resultfile_data_ICA_interp = [resultdir, '/ecoute/data_ICA_interp/', filetoinspect];


%%% Checking whether this file has been already inspected 
if ~exist([resultdir '/ecoute/preproc_final'],'dir')
    
    mkdir([resultdir '/ecoute/preproc_final'])
    
end

resultfile = [resultdir, '/ecoute/preproc_final/', filetoinspect];



cfg = [];
cfg.layout='../common/layout_E.mat';
cfg.method   = 'summary';% 'channel' 'trial'
cfg.inputfile = resultfile_data_ICA_interp;
cfg.outputfile = resultfile;
ft_rejectvisual(cfg); 
