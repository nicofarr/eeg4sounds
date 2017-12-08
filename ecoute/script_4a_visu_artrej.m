%% 4 - Visualisation - premier contrôle qualité : 
%% - a - étape identique à 2 où l'on visualise les données horizontalement avec les sections identifiées précedemment comme artefacts
%% output: anotation des 3 types d'artefacts
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/all_art'],'dir')
    
    mkdir([resultdir '/ecoute/all_art'])
   
end

%%% Checking whether this file has been already inspected 

resultfile_all_art = [resultdir, '/ecoute/all_art/', filetoinspect];

%%% Defining the cfg for inspection 
cfg = [];
visdata = load([filepath,filetoinspect],'data');
% Load artifacts 
resultfile_vis_art = [resultdir '/ecoute/vis_art/', filetoinspect];
resultfile_auto_art = [resultdir '/ecoute/autoreject/', filetoinspect];
artfctdef_vis = load(resultfile_vis_art,'artfctdef');
artfctdef_auto = load(resultfile_auto_art,'artfctdef');

cfg.artfctdef.visual=artfctdef_vis.artfctdef.visual;
cfg.artfctdef.jump=artfctdef_auto.artfctdef.jump;
cfg.artfctdef.muscle=artfctdef_auto.artfctdef.muscle;

if exist(resultfile_all_art,'file')
    disp('File has already been inspected : loading results.');
    artfctdef_prev = load(resultfile_all_art,'artfctdef');
    cfg.artfctdef = []
    cfg.artfctdef = artfctdef_prev.artfctdef;
end



cfg.viewmode = 'vertical'; %%%% remplacer par butterfly pour avoir les electrodes superposées
%%% Paramètres de préprocessing uniquement pour la visu
cfg.preproc.bpfilter = 'yes';
cfg.preproc.bpfreq = [0.3 70];

%cfg.blocksize = 10; %%% by blocks of 10 seconds 
cfg.channel = [1:50];

cfg.preproc.dftfilter = 'yes'; %%% Ceci est le notch

%%% Cette fonction démarre l'outil de visualisation
cfg_all_clean = ft_databrowser(cfg,visdata.data);

artfctdef = cfg_all_clean.artfctdef; 

save(resultfile_all_art,'artfctdef')

