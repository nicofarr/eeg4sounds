%% 6 - Check artefact final - puis calcul des ERP individuels par condition 
%% - a - mode "summary" qui permet d'identifier immédiatement les essais trop bruitées 
%% - b - Calcul des ERP individuels en séparant standards et deviants
%% input : output de 5
%% output : ERP individuel par condition

addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/oddball/data_ICA/*.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/oddball/erp_indiv'],'dir')
    
    mkdir([resultdir '/oddball/erp_indiv'])
   
end


resultfile_erp = [resultdir, '/oddball/erp_indiv/', filetoinspect];

visdata = load([filepath,filetoinspect],'data_clean');

% Affiche Summary
load('../common/layout_E.mat');
cfg = [];
cfg.layout=lay;
cfg.method   = 'summary';% 'channel' 'trial'
data_clean   = ft_rejectvisual(cfg, visdata.data_clean); 

cfg = [];
cfg.lpfreq = [45];
cfg.lpfilter = 'yes';
data_clean = ft_preprocessing(cfg,data_clean);

cfg = [];
cfg.toilim = [-0.2, 0.5];
data_clean = ft_redefinetrial(cfg,data_clean);


cfgerp = [];
cfgerp.preproc.demean = 'yes';
cfgerp.preproc.detrend = 'yes';



deviant_trials = find(data_clean.trialinfo==0);
standard_trials = find(data_clean.trialinfo==1);


erp = [];

cfgerp.trials = standard_trials;

erp.std = ft_timelockanalysis(cfgerp,data_clean);

cfgerp.trials = deviant_trials;
erp.dev = ft_timelockanalysis(cfgerp,data_clean);

cfgplot = [];
cfgplot.layout =  '../common/layout_E.mat';
ft_multiplotER(cfgplot,erp.std,erp.dev)

save(resultfile_erp,'erp')