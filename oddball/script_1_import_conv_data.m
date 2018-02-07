%% 1 - Garder un set d'electrodes d�fini � l'avance (d�fini dans common/eleckeep.txt)
%% -- input : donn�es brutes
%% -- output : donn�es brutes moins les �lectrodes rejet�es (format mat)

%%% Ce fichier scan le repertoire entier de fichiers annot�s, et lance la
%%% conversion sur chacun d'entre eux

addpath ../common/
check_set_datadir;
check_set_resultdir;

%%% Create result folder

if ~exist([resultdir '/oddball/import'],'dir')
    
    mkdir([resultdir '/oddball/import'])
    
end

%%% on server 
% resultdir = '/sanssauvegarde/homes/nfarrugi/temp_data_eeg4sounds/results/';
% datadir = '/sanssauvegarde/homes/nfarrugi/temp_data_eeg4sounds/raw/';


%% Load the list of good electrodes
load_good_elecs;

% Open a dialog to select files to process
% As File names are not consistent, we need to do this once for each
% condition, as we ll as entering the subject ID manually 

[file_oddball_stereo,subjid] = choose_file(datadir,'Choisir fichier STEREO');

answ=input(['Subject id found is : ' subjid '. ok ? (y or n)'],'s');

if answ=='n'

    subjid = input('Enter subject id','s');
end

[file_oddball_binaural,junk] = choose_file(datadir,'Choisir fichier BINAURAL');




%%% Now that we have the two files and the subject ID we can create the
%%% name of the resulting file (both conditions in one file) 


resultfile_ste = [resultdir '/oddball/import/' subjid '_stereo.mat'];
resultfile_bin = [resultdir '/oddball/import/' subjid '_binaural.mat'];


%% Prepare the two input and output files
% input files 
odd_files = {file_oddball_binaural,file_oddball_stereo};
%output files
res_files = {resultfile_bin,resultfile_ste};

for ind = 1:2
    
    %%% TRIAL DEFINITION
    cfg = [];

    cfg.dataset=odd_files{ind};

    cfg.dataformat = 'egi_mff_v2';

    cfg.trialdef.eventtype = '?';

    cfg.trialdef.prestim = 0.5;
    cfg.trialdef.poststim = 1;

    cfg.headerformat = 'egi_mff_v2';
    cfg.eventformat = 'egi_mff_v2';
    
    cfg.namesuj=subjid;
    cfg.trialfun   = 'ft_trialfun_OddBin';% enleve 
            
    cfg.inputfile = odd_files{ind};
    
    cfgtrl = ft_definetrial(cfg);
    
    trl= cfgtrl.trl;
    
    %% PREPROCESSING
    %%% Setting up parameters for "preprocessing"
    %%% We just need to select the electrodes that we will keep (in elec_cell)
    
    cfg = [];
    cfg.trl = trl;
    cfg.inputfile = odd_files{ind};
    cfg.channel = elec_cell;        
    cfg.outputfile = res_files{ind};
    
    
    %%% Launch the preprocessing
    
    ft_preprocessing(cfg);
    
    
end