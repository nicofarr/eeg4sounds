%% 6 - Inspect ICA : inspection visuelle pour identifier quelles composantes correspondent aux mouvements oculaires
%% -- input : Composantes ICA + données pre-cleanées ( = brutes utiles moins elec bruitées moins artefacts)
%% -- output : données "back-projetées"  (i.e. en enlevant la contribution des composantes artefacts mouvements oculaires) 

addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/ecoute/data_ICA'],'dir')   
    mkdir([resultdir '/ecoute/data_ICA'])   
end

%%% Checking whether this file has been already inspected 

resultfile_data_ICA = [resultdir, '/ecoute/data_ICA/', filetoinspect];

visdata = load([filepath,filetoinspect],'data');
list_elec=visdata.data.label;
if exist(resultfile_data_ICA,'file')
    disp('File has already been inspected : ');
    decision = input('Do you want to re-inspect ICA ? (n to abort) ','s');
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
%for i=1:length(data_post_art.time)
  % data_post_art.time(i)=data_post_art.time(1);
%end
%Name LAYOUT
load('../common/layout_E.mat');

%%% Load COMP
resultfile_comp = [resultdir '/ecoute/ICA_comp/', filetoinspect];
load(resultfile_comp,'ICA_comp');


%%% Inspect data
figure
cfgtopoICA = [];
cfgtopoICA.component = [1:20];       % specify the component(s) that should be plotted
cfgtopoICA.layout    = lay; % specify the layout file that should be used for plotting
cfgtopoICA.comment   = 'no';
cfgtopoICA.segm   = [0 5];
ft_topoplotIC(cfgtopoICA, ICA_comp);
figure
cfgtopoICA.component = [21:40];       % specify the component(s) that should be plotted
ft_topoplotIC(cfgtopoICA, ICA_comp);
figure
cfgtopoICA.component = [41:60];       % specify the component(s) that should be plotted
ft_topoplotIC(cfgtopoICA, ICA_comp);

cfg = [];
cfg.layout = lay; % specify the layout file that should be used for plotting
cfg.preproc.bpfilter = 'no';
cfg.preproc.bpfreq = [0.1 70];
cfg.viewmode = 'component';
ft_databrowser(cfg, ICA_comp)
% Quand tu es dans le browser tu peux rajouter des parametres de filtrage:
% par exemple 
%cfg.preproc.bpfilter = 'yes';
%cfg.preproc.bpfreq = [0.3 70];

enduser = 0; 
while enduser==0  
cfgrej=[];
comp_reject = input('List of components to reject ? (ex [1,3,4]', 's'); 
eval(['cfgrej.component = ' comp_reject ]);
% remove the bad components and backproject the data
cfgrej.demean     = 'no'; % Demean or not?
data_clean = ft_rejectcomponent(cfgrej, ICA_comp, data_post_art);



verif = input('Are you satisfied / Is ICA analysis complete (Type y or n)','s');
    if verif =='y'
        enduser = 1;
        close all
        save(resultfile_data_ICA,'data_clean')
    elseif verif =='n'
        enduser = 0;
    else 
        disp('wrong entry');
        pause(0.5);
    end
end
% Save final
save(resultfile_data_ICA,'data_clean')








   

