%% 1 - Garder un set d'electrodes d�fini � l'avance (d�fini dans common/eleckeep.txt)
%% -- input : donn�es brutes
%% -- output : donn�es brutes moins les �lectrodes rejet�es (format mat)

%%% Ce fichier scan le repertoire entier de fichiers annot�s, et lance la
%%% conversion sur chacun d'entre eux

addpath ../common/

check_set_resultdir;

%% Load the list of good electrodes
load_good_elecs;

%% List all annotated files
%annotedfiles = dir([resultdir '/ecoute/annot']);
%% Remove '.' and '..'
%annotedfiles(1:2) = [];

% Open a dialog to select files to process
[annotedfiles,fullpath] = uigetfile([resultdir '/ecoute/annot'],'MultiSelect','On');

%%% Create result folder

if ~exist([resultdir '/ecoute/import'],'dir')
    
    mkdir([resultdir '/ecoute/import'])
    
end

if iscell(annotedfiles)
    
    %%% Loop over all annoted files
    
    for ind = 1:size(annotedfiles,2)
        
        curfile = annotedfiles(ind);
        
        filepath = strcat(fullpath,curfile);
        
        cfgloaded = load(filepath{1},'cfg');
        
        cfgpreproc = cfgloaded.cfg;
        
        %%% Setting up the resultfile
        
        resultfile = [resultdir '/ecoute/import/' curfile];
        
        %%% Setting up parameters for "preprocessing"
        %%% We just need to select the electrodes that we will keep (in elec_cell)
        %%% and save the data into resultfile
        
        cfgpreproc.outputfile = resultfile;
        cfgpreproc.channel = elec_cell;
        
        %%% Launch the preprocessing
        
        ft_preprocessing(cfgpreproc);
        
        
    end
    
    
else
    curfile = annotedfiles;
    
    filepath = strcat(fullpath,curfile);
    
    cfgloaded = load(filepath{1},'cfg');
    
    cfgpreproc = cfgloaded.cfg;
    
    %%% Setting up the resultfile
    
    resultfile = [resultdir '/ecoute/import/' curfile];
    
    %%% Setting up parameters for "preprocessing"
    %%% We just need to select the electrodes that we will keep (in elec_cell)
    %%% and save the data into resultfile
    
    cfgpreproc.outputfile = resultfile;
    cfgpreproc.channel = elec_cell;
    
    %%% Launch the preprocessing
    
    ft_preprocessing(cfgpreproc);
    
    
    
end