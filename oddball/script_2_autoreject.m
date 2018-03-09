%% 2 - Rejection d'artefacts semi-automatique Jump + muscles 
%% -- Input : données découpées (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette étape est semi-automatique (identification du seuil)

 
addpath ../common/

check_set_resultdir;

[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing visual artefacts

if ~exist([resultdir '/ecoute/autoreject'],'dir')
    
    mkdir([resultdir '/ecoute/autoreject'])
    
end

%%% Checking whether this file has been already inspected 

resultfile_autoart = [resultdir, '/ecoute/autoreject/', filetoinspect];

visdata = load([filepath,filetoinspect],'data');

if exist(resultfile_autoart,'file')
    disp('File has already been inspected for Jump and Muscle artifacts.');
    decision = input('Do you want to re-inspect? (n to abort) ','s');
    if decision == 'n'
    error('Proceed to next step (script 4)')
    end
end

%%% Segment 10 seconds to visualise
cfg            = [];
cfg.length    = 10;
data_cut=ft_redefinetrial(cfg,visdata.data);

%%% Defining the cfg for automatic artefact rejection (Jump first, then
%%% Muscle)

% Jump artifact detection
cfg            = [];
% Paramètres de préprocessing uniquement pour la detection des jumps
% channel selection, cutoff and padding
cfg.artfctdef.zvalue.channel    = 'all';
cfg.artfctdef.zvalue.cutoff     = 95;
cfg.artfctdef.zvalue.trlpadding = 0;
cfg.artfctdef.zvalue.artpadding = 0.01;
cfg.artfctdef.zvalue.fltpadding = 0;
% algorithmic parameters
cfg.artfctdef.zvalue.cumulative    = 'yes';
cfg.artfctdef.zvalue.medianfilter  = 'yes';
cfg.artfctdef.zvalue.medianfiltord = 9;
cfg.artfctdef.zvalue.absdiff       = 'yes';
 % make the process interactive
cfg.artfctdef.zvalue.interactive = 'yes';
[cfg, artifact_jump] = ft_artifact_zvalue(cfg,data_cut);
thresh_value_jump=cfg.artfctdef.zvalue.cutoff;

% Muscle artifact detection
 cfg            = [];
% Paramètres de préprocessing uniquement pour la detection des muscle art.
% channel selection, cutoff and padding
cfg.artfctdef.zvalue.channel = 'all';
cfg.artfctdef.zvalue.cutoff      = 45;
cfg.artfctdef.zvalue.trlpadding  = 0;
cfg.artfctdef.zvalue.fltpadding  = 0;
cfg.artfctdef.zvalue.artpadding  = 0.1;
% algorithmic parameters
cfg.artfctdef.zvalue.bpfilter    = 'yes';
cfg.artfctdef.zvalue.bpfreq      = [110 140];
cfg.artfctdef.zvalue.bpfiltord   = 9;
cfg.artfctdef.zvalue.bpfilttype  = 'but';
cfg.artfctdef.zvalue.hilbert     = 'yes';
cfg.artfctdef.zvalue.boxcar      = 0.2;
% make the process interactive
cfg.artfctdef.zvalue.interactive = 'yes';
[cfg, artifact_muscle] = ft_artifact_zvalue(cfg,data_cut);
thresh_value_muscle=cfg.artfctdef.zvalue.cutoff;


%%% Check if save this art rejection (else re-d
fprintf('Treshold value : %4.1f\n', thresh_value_jump)
fprintf('Treshold value : %4.1f\n', thresh_value_muscle)
decision = input('Do you want to save? ( n to abort) ','s');
if decision == 'n'
    error('ABORTED')
end

artfctdef.jump.artifact = artifact_jump; 
artfctdef.jump.thresh_value = thresh_value_jump; 
artfctdef.muscle.artifact = artifact_muscle; 
artfctdef.muscle.thresh_value = thresh_value_muscle; 

save(resultfile_autoart,'artfctdef');
