%% 
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/data_ICA_interp/*.mat']);

dataredef = load([filepath,filetoinspect],'data');

%%% Concatenate the 5 second segments 
concatetrl = concatenate_trl(dataredef.data.sampleinfo);
cfg = [];
cfg.trl = concatetrl;
dataredef = ft_redefinetrial(cfg,dataredef.data);

cfg.inputfile = [resultdir '/ecoute/data_preICA_interp/', filetoinspect];
dataredef_preICA = ft_redefinetrial(cfg);

%redefine trials to the full 115 seconds of conditions
% Load annotations

load([resultdir '/ecoute/annot/',filetoinspect])
annot_trl = cfg.trl;


%% a bit of prepreocessing 
cfg =[];
cfg.demean = 'yes';
cfg.detrend = 'no';
cfg.bpfilter = 'yes';
cfg.bpfreq = [0.3 50];

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
    
    %curtitle = strcat(curelecstr,',', ...
    %    trialnames(curtrial),num2str(t/1000),':to:', num2str((t+tleg)/1000));
    
    %title(curtitle)
    
end
 legend('clean','beforeICA')