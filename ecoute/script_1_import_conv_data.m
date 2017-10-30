%% 1 - Garder un set d'electrodes défini à l'avance (défini dans common/eleckeep.txt)
%% -- input : données brutes
%% -- output : données brutes moins les électrodes rejetées (format mat)

%%% Ce fichier scan le repertoire entier de fichiers annotés, et lance la
%%% conversion sur chacun d'entre eux

addpath ../common/

check_set_resultdir;

%% Load the list of good electrodes
load_good_elecs;

%% List all annotated files
annotedfiles = dir([resultdir '/ecoute/annot']);
%% Remove '.' and '..'
annotedfiles(1:2) = [];


%%% Create result folder

if ~exist([resultdir '/ecoute/import'],'dir')
    
    mkdir([resultdir '/ecoute/import'])
    
end

%%% Loop over all annoted files

for ind = 1:size(annotedfiles,1)
    
    curfile = annotedfiles(ind).name;
    
    filepath = [resultdir,'/ecoute/annot/' annotedfiles(ind).name];
    
    cfgloaded = load(filepath,'cfg');
    
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
