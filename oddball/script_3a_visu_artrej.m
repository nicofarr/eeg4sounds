%% 3 - Visualisation - premier contr�le qualit� : 
%% - a - �tape identique � 2 o� l'on visualise les donn�es horizontalement avec les sections identifi�es pr�cedemment comme artefacts
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/oddball/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/oddball/all_art'],'dir')
    
    mkdir([resultdir '/oddball/all_art'])
   
end

%%% Checking whether this file has been already inspected 

resultfile_all_art = [resultdir, '/oddball/all_art/', filetoinspect];

%%% Defining the cfg for inspection 
cfg = [];
visdata = load([filepath,filetoinspect],'data');
% Load artifacts 
resultfile_auto_art = [resultdir '/oddball/autoreject/', filetoinspect];
artfctdef_auto = load(resultfile_auto_art,'artfctdef');

cfg.artfctdef.jump=artfctdef_auto.artfctdef.jump;
cfg.artfctdef.muscle=artfctdef_auto.artfctdef.muscle;

if exist(resultfile_all_art,'file')
    disp('File has already been inspected : loading results.');
    artfctdef_prev = load(resultfile_all_art,'artfctdef');
    cfg.artfctdef = [];
    cfg.artfctdef = artfctdef_prev.artfctdef;
end



cfg.viewmode = 'vertical'; %%%% remplacer par butterfly pour avoir les electrodes superpos�es
%%% Param�tres de pr�processing uniquement pour la visu
cfg.preproc.bpfilter = 'yes';
cfg.preproc.bpfreq = [0.3 70];

%cfg.blocksize = 10; %%% by blocks of 10 seconds 
cfg.channel = [1:50];

cfg.preproc.dftfilter = 'yes'; %%% Ceci est le notch

%%% Cette fonction d�marre l'outil de visualisation
cfg_all_clean = ft_databrowser(cfg,visdata.data);

artfctdef = cfg_all_clean.artfctdef; 

save(resultfile_all_art,'artfctdef')

