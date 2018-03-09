%% 2 - Rejection d'artefacts semi-automatique Jump + muscles 
%% -- Input : donn�es d�coup�es (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette �tape est semi-automatique (identification du seuil)

 
addpath ../common/

%%% on server 
% resultdir = '/sanssauvegarde/homes/nfarrugi/temp_data_eeg4sounds/results/';
% datadir = '/sanssauvegarde/homes/nfarrugi/temp_data_eeg4sounds/raw/';

check_set_resultdir;
check_set_datadir;

[filetoinspect,filepath] = uigetfile([resultdir '/oddball/import/*.mat']);

%%% Create result folder for storing visual artefacts

if ~exist([resultdir '/oddball/autoreject'],'dir')
    
    mkdir([resultdir '/oddball/autoreject'])
    
end

%%% Checking whether this file has been already inspected 

resultfile_autoart = [resultdir, '/oddball/autoreject/', filetoinspect];

visdata = load([filepath,filetoinspect],'data');

if exist(resultfile_autoart,'file')
    disp('File has already been inspected for Jump and Muscle artifacts.');
    decision = input('Do you want to re-inspect? (n to abort) ','s');
    if decision == 'n'
    error('Proceed to next step (script 4)')
    end
end

%%% Defining the cfg for automatic artefact rejection (Jump first, then
%%% Muscle)

% Jump artifact detection
cfg            = [];
% Param�tres de pr�processing uniquement pour la detection des jumps
% channel selection, cutoff and padding
cfg.continuous = 'no';
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
[cfg, artifact_jump] = ft_artifact_zvalue(cfg,visdata.data);
thresh_value_jump=cfg.artfctdef.zvalue.cutoff;

% Muscle artifact detection
 cfg            = [];
% Param�tres de pr�processing uniquement pour la detection des muscle art.
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
[cfg, artifact_muscle] = ft_artifact_zvalue(cfg,visdata.data);
thresh_value_muscle=cfg.artfctdef.zvalue.cutoff;


%%% Check if save this art rejection (else re-d
fprintf('Threshold value : %4.1f\n', thresh_value_jump)
fprintf('Threshold value : %4.1f\n', thresh_value_muscle)
decision = input('Do you want to save? ( n to abort) ','s');
if decision == 'n'
    error('ABORTED')
end

artfctdef.jump.artifact = artifact_jump; 
artfctdef.jump.thresh_value = thresh_value_jump; 
artfctdef.muscle.artifact = artifact_muscle; 
artfctdef.muscle.thresh_value = thresh_value_muscle; 

save(resultfile_autoart,'artfctdef');
