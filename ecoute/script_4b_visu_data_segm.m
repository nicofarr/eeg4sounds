%% 4 - Visualisation - premier contrôle qualité : 
%% - b - COUPER EN TRANCHES PUIS mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% - c - COUPER EN TRANCHES PUIS mode "electrode" idem 
%% output : annotations d'electrodes à rejeter et à interpoler plus tard

addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/art_elec'],'dir')
    
    mkdir([resultdir '/ecoute/art_elec'])
   
end

%%% Checking whether this file has been already inspected and load 
%%% bad & good electrodes list

resultfile_elec = [resultdir, '/ecoute/art_elec/', filetoinspect];

visdata = load([filepath,filetoinspect],'data');
list_elec=visdata.data.label;
if exist(resultfile_elec,'file')
    disp('File has already been inspected : loading results.');
    artfctdef_prev = load(resultfile_elec,'elec');
    list_elec=elec.good;
end


% Load artifacts 
resultfile_all_art = [resultdir '/ecoute/all_art/', filetoinspect];
artfctdef_final = load(resultfile_all_art,'artfctdef');

% Segment data
cfg            = [];
cfg.length    = 5; % SEGMENTS DE X SECONDES 
data_post_art=ft_redefinetrial(cfg,visdata.data); 

cfg            = [];
cfg.artfctdef=artfctdef_final.artfctdef;
cfg.artfctdef.reject          = 'complete';% ou 'complete' si on supprime tout le segment
data_post_art = ft_rejectartifact(cfg,data_post_art);
for i=1:length(data_post_art.time)
   data_post_art.time(i)=data_post_art.time(1);
end
% Il est possible d'inverser si on préfere electrode puis summary       
% Affiche Summary
load('../common/layout_E.mat');
cfg = [];
cfg.layout=lay;
cfg.method   = 'summary';% 'channel' 'trial'
data   = ft_rejectvisual(cfg, data_post_art); 

% Affiche par electrodes 
cfg = [];
cfg.method   = 'channel';
cfg.preproc.demean='yes';
%cfg.alim    = 1000000000;
%cfg.eegscale    = 100;
cfg.channel  = list_elec;  
%cfg.latency = [0 5];
data   = ft_rejectvisual(cfg, data);


% Enregistre dans "elec" le nom des electrodes "good" et "bad"
chansel = false(1, length(data_post_art.label));
chansel(match_str(data_post_art.label, data.label)) = true;
removed = find(~chansel);
elec.bad=data_post_art.label(removed);
elec.good=data.label;

save(resultfile_elec,'elec')








   

