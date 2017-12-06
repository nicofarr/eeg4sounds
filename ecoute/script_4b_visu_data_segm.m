%% 4 - Visualisation - premier contrôle qualité : 
%% - b - COUPER EN TRANCHES PUIS mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% - c - COUPER EN TRANCHES PUIS mode "electrode" idem 
%% output : annotations d'electrodes à rejeter et à interpoler plus tard

addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/art_segm'],'dir')
    
    mkdir([resultdir '/ecoute/art_segm'])
   
end

%%% Checking whether this file has been already inspected 

resultfile_art_segm = [resultdir, '/ecoute/art_segm/', filetoinspect];

if exist(resultfile_art_segm,'file')
    disp('File has already been inspected : loading results.');
    artfctdef_prev = load(resultfile_art_segm,'????');
end

%%% Defining the cfg for inspection 
cfg = [];
visdata = load([filepath,filetoinspect],'data');
% Load artifacts 
resultfile_all_art = [resultdir '/ecoute/all_art/', filetoinspect];
artfctdef_final = load(resultfile_all_art,'artfctdef');

cfg            = [];
cfg.length    = 10; % SEGMENTS DE X SECONDES 
data_cut=ft_redefinetrial(cfg,visdata.data); 

cfg            = [];
cfg.artfctdef=artfctdef_final.artfctdef;
cfg.artfctdef.reject          = 'partial';% ou 'complete' si on supprime tout le segment
cfg.artfctdef.minaccepttim    = 5;    % DUREE (en Secondes) MINIMALE TOLEREE                 
data_post_art = ft_rejectartifact(cfg,data_cut);

cfg = [];
cfg.method   = 'channel';
%cfg.alim    = 100000;
%cfg.eegscale    = 100;
cfg.channel  = 'all';   
data_clean   = ft_rejectvisual(cfg, data_post_art);  

cfg = [];
cfg.method   = 'trial';
cfg.channel  = 'all';   
data   = ft_rejectvisual(cfg, data_post_art);  

cfg = [];
cfg.method   = 'summary';% 'channel' 'trial'
cfg.channel  = 'all';    % 
data   = ft_rejectvisual(cfg, data_post_art);  






   

