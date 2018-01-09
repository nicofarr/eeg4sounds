%% 5 - Transform ICA (Analyse en composantes indépendantes) 
%%% Dans cette étape, découper les données en segments contigus (5
%%% secondes)
%% -- Inputs : données brutes (elec utiles)  + annotations d'artefacts des étapes 2 et 3 + annotations d'electrodes à rejeter
%% -- Output : Composantes ICA

addpath ../common/
check_set_resultdir;
[filestoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat'],'MultiSelect','on');

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/ICA_comp'],'dir') 
    mkdir([resultdir '/ecoute/ICA_comp'])  
end

%%% Checking whether this file has been already inspected and load 
%%% bad & good electrodes list
if iscell(filestoinspect)
    nsuj=size(filestoinspect,2);
else
    nsuj=1;
end

for suj=1:nsuj
    if iscell(filestoinspect)
    filetoinspect=filestoinspect{suj};
    else
    filetoinspect=filestoinspect;
    end
    disp(filetoinspect)
    resultfile_ica = [resultdir, '/ecoute/ICA_comp/', filetoinspect];

    if exist(resultfile_ica,'file')
        disp('ICA for this subject have already been computed :');
        decision = input('Do you want to re-compute? (y or n) ','s');
    if decision == 'n'
        continue
    end
        
    end
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

    cfg            = [];
    cfg.channel =elec_list.elec.good;
    cfg.artfctdef=artfctdef_final.artfctdef;
    cfg.artfctdef.reject          = 'complete';% ou 'complete' si on supprime tout le segment
    data_post_art = ft_rejectartifact(cfg,data_post_art);

    cfg = [];
    cfg.channel = elec_list.elec.good;
    cfg.method = 'runica'; 
    cfg.runica.pca = 60; % choix nombre de pca!!!
    ICA_comp = ft_componentanalysis(cfg,data_post_art);

    save(resultfile_ica,'ICA_comp')


end





   

