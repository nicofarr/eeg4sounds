%% 6b - Interpolate
%% -- input : donn�es pre-clean�es ( = brutes utiles moins elec bruit�es moins artefacts) et données clean (après ICA)
%% -- output : donn�es clean ICA interpolees et donnees pre-cleanees interpolees
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/data_ICA_interp/*.mat']);

resultfile_data_ICA_interp = [resultdir, '/ecoute/data_ICA_interp/', filetoinspect];


%%% Checking whether this file has been already inspected 
if ~exist([resultdir '/ecoute/vis_art_final'],'dir')
    
    mkdir([resultdir '/ecoute/vis_art_final'])
    
end


visdata = load(resultfile_data_ICA_interp,'data');

cfg = [];
cfg.layout='../common/layout_E.mat';
cfg.viewmode = 'vertical'; %%%% remplacer par butterfly pour avoir les electrodes superpos�es
%%% Param�tres de pr�processing uniquement pour la visu
cfg.preproc.bpfilter = 'yes';
cfg.preproc.bpfreq = [0.3 70];

%cfg.blocksize = 10; %%% by blocks of 10 seconds 
cfg.channel = [1:50];

cfg.preproc.dftfilter = 'yes'; %%% Ceci est le notch

%%% Cette fonction d�marre l'outil de visualisation
cfg_visual_clean_final = ft_databrowser(cfg,visdata.data);

artfctdef = cfg_visual_clean_final.artfctdef; 


resultfile_visart_final = [resultdir, '/ecoute/vis_art_final/', filetoinspect];

save(resultfile_visart_final,'artfctdef')
