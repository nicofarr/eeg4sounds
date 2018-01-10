%% 
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/data_ICA_interp/*.mat']);

%%% Create result folder for storing final data
if ~exist([resultdir '/ecoute/data_final'],'dir')   
    mkdir([resultdir '/ecoute/data_final'])   
end

%%% Create result folder for storing final data without ICA 
if ~exist([resultdir '/ecoute/data_preICA_final'],'dir')   
    mkdir([resultdir '/ecoute/data_preICA_final'])   
end

resultfile_data_final = [resultdir, '/ecoute/data_final/', filetoinspect];
resultfile_data_preICA_final = [resultdir, '/ecoute/data_preICA_final/', filetoinspect];

%%% Checking whether this file has been already inspected 

if exist(resultfile_data_final,'file')
    disp('File has already been inspected : ');
    decision = input('Do you want to re-inspect ICA ? (n to abort) ','s');
    if decision == 'n'
    error('F')
    end
end

%%% LOAD DATA
% Load data
datain = load([filepath,filetoinspect],'data');
datpreICA = load([resultdir '/ecoute/data_preICA_interp/', filetoinspect],'data');

% Load annotations

load([resultdir '/ecoute/annot/',filetoinspect])

newtrl =cfg.trl; 

%redefine trials
cfgredef = [];
cfgredef.trl = newtrl; 
dataredef = ft_redefinetrial(cfgredef,datain.data);
dataredef_preICA = ft_redefinetrial(cfgredef,datpreICA.data);

%% a bit of prepreocessing 
cfg =[];
cfg.demean = 'yes';
cfg.detrend = 'yes';

dataredef = ft_preprocessing(cfg,dataredef);
dataredef_preICA = ft_preprocessing(cfg,dataredef_preICA);


%% now do some plots of both data to see the effect of ICA 

nbtests = 9;
nbcell = ceil(sqrt(nbtests));

%% here specify the length of segments to visualize
tleg = 1500;


%%% this will do a figure, pick nbtests fragments of length tleg samples,
%%% pick random electrodes and random conditions, to visualize the
%%% difference before and after ICA


figure()

for n = 1:nbtests

    subplot(nbcell,nbcell,n)

    curelec = randi(length(dataredef.label),1);
    curtrial = randi(size(dataredef.trial,2),1);

     % at 1000 Hz
    t = randi(size(dataredef.trial{1},2)-tleg,1); %%% pick a random start point within the trial

    plot(dataredef.trial{1,1}(curelec,t:t+tleg))
    hold on
    plot(dataredef_preICA.trial{1,1}(curelec,t:t+tleg),'r')
    hold off
    xlim([0 tleg])
    
    curelecstr = dataredef.label(curelec);
    curelecstr = curelecstr{1};
    
    curtitle = strcat(curelecstr,',', ...
        trialnames(curtrial),num2str(t/1000),':to:', num2str((t+tleg)/1000));
    
    title(curtitle)
    
end
 legend('clean','beforeICA')