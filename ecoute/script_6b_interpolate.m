%% 6b - Interpolate
%% -- input : donn�es pre-clean�es ( = brutes utiles moins elec bruit�es moins artefacts) et données clean (après ICA)
%% -- output : donn�es clean ICA interpolees et donnees pre-cleanees interpolees
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/data_ICA_interp'],'dir')   
    mkdir([resultdir '/ecoute/data_ICA_interp'])   
end

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/data_preICA_interp'],'dir')   
    mkdir([resultdir '/ecoute/data_preICA_interp'])   
end

resultfile_data_ICA_interp = [resultdir, '/ecoute/data_ICA_interp/', filetoinspect];
resultfile_data_preICA_interp = [resultdir, '/ecoute/data_preICA_interp/', filetoinspect];



%%% Checking whether this file has been already inspected 

resultfile_data_ICA = [resultdir, '/ecoute/data_ICA/', filetoinspect];
visdata = load([filepath,filetoinspect],'data');

filepath2=[resultdir '/ecoute/data_ICA/'];
data_clean = load([filepath2,filetoinspect],'data_clean');


list_elec=visdata.data.label;


if exist(resultfile_data_ICA_interp,'file')
    disp('File has already been interpolated : ');
    decision = input('Do you want to re-interpolate ICA ? (n to abort) ','s');
    if decision == 'n'
    error('Proceed to next step (script 7)')
    end
end

%%% LOAD DATA
% Load data
visdata = load([filepath,filetoinspect],'data');
% Load artifacts 
resultfile_all_art = [resultdir '/ecoute/all_art/', filetoinspect];
resultfile_elec = [resultdir, '/ecoute/art_elec/', filetoinspect];
artfctdef_final = load(resultfile_all_art,'artfctdef');
elec_list=load(resultfile_elec,'elec');
 % Segment data
cfg            = [];
cfg.length    = 5; % SEGMENTS DE X SECONDES 
data_post_art=ft_redefinetrial(cfg,visdata.data); 

%%% Rejecting electrodes
cfg            = [];
cfg.channel =elec_list.elec.good;
data_post_art=ft_preprocessing(cfg,data_post_art); 

cfg            = [];
cfg.artfctdef=artfctdef_final.artfctdef;
cfg.artfctdef.reject          = 'complete';% ou 'complete' si on supprime tout le segment
data_post_art = ft_rejectartifact(cfg,data_post_art);

%%%% Prepare ressources for interpolation

%%% Interpolate data before ICA : 


%%% Preparing neighbour structure
cfg = [];

cfg.method = 'triangulation';

cfg.layout = '../common/layout_E.mat';
cfg.channel = 'all';

neigh = ft_prepare_neighbours(cfg,visdata.data);


%% Prepare the layout electrode positions
cfg = [];
cfg.layout =  '../common/layout_E.mat';

 lay = ft_prepare_layout(cfg,visdata.data);
 
 sens =[];
 sens.label = lay.label;
 sens.chanpos = lay.pos;
 sens.elecpos = lay.pos;
 
%  The structure for EEG or ECoG channels contains
%      sens.label    = Mx1 cell-array with channel labels
%      sens.chanpos  = Mx3 matrix with channel positions
%      sens.tra      = MxN matrix to combine electrodes into channels
%      sens.elecpos  = Nx3 matrix with electrode positions
%   In case sens.tra is not present in the EEG sensor array, the channels
%   are assumed to be average referenced.
%  

%% Interpolate 

cfginterp = [];
cfginterp.method = 'average';
cfginterp.badchannel = elec_list.elec.bad;
cfginterp.neighbours = neigh;
cfginterp.trials = 'all';
cfginterp.elec = sens;


%%% Interpolate clean data (after ICA)
cfginterp.outputfile = resultfile_data_ICA_interp;
ft_channelrepair(cfginterp,data_clean.data_clean);

%%% Interpolate clean data (before ICA)
cfginterp.outputfile = resultfile_data_preICA_interp;
ft_channelrepair(cfginterp,data_post_art);