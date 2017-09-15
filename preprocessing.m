%%%%% INITIALISATION

addpath C:\Users\odufor\Desktop\braingraph_eeg\

infile='C:\Users\odufor\Desktop\postdocorange\DONNEES_SUJETS\PC27\PC27OddBin_20170711_100408.mff';

%hdr=ft_read_header(filename);
%%


%%%% DEFINITION DES ESSAIS 

cfg=[];
cfg.namesuj='CP12';
cfg.trialfun   = 'ft_trialfun_OddBin';% enleve 
cfg.trialdef.prestim=0.5;
cfg.trialdef.poststim=1;
cfg.dataset=infile;
cfg=ft_definetrial(cfg);

%%% ON STOCKE LES ESSAIS DANS LA VARIABLE trl 
trl=cfg.trl;


% cfg.padding      = 2;
% cfg.bpfilter='yes';
% cfg.bpfreq=[0.5 45];
% cfg.bpfilttype='firws';
% cfg.bpfiltwintype= 'kaiser';
% cfg.bpfiltord =5016;
% cfg.bpfiltdev =0.0001;
% cfg.dataformat='egi_mff_v2';
% cfg.headerformat='egi_mff_v2';
    %cfg.plotfiltresp  = 'yes';
    
    

% Jump artifact detection

    cfg            = [];
    cfg.trl        = trl;
    cfg.datafile   = infile;
    cfg.headerfile = infile;
    % channel selection, cutoff and padding
    cfg.artfctdef.zvalue.channel    = 'all';
    cfg.artfctdef.zvalue.cutoff     = 60;
    cfg.artfctdef.zvalue.trlpadding = 0;
    cfg.artfctdef.zvalue.artpadding = 0;
    cfg.artfctdef.zvalue.fltpadding = 0;
    % algorithmic parameters
    cfg.artfctdef.zvalue.cumulative    = 'yes';
    cfg.artfctdef.zvalue.medianfilter  = 'yes';
    cfg.artfctdef.zvalue.medianfiltord = 9;
    cfg.artfctdef.zvalue.absdiff       = 'yes';
    % make the process interactive
    cfg.artfctdef.zvalue.interactive = 'yes';
    [cfg, artifact_jump] = ft_artifact_zvalue(cfg);

% Muscle artifact detection
    cfg            = [];
    cfg.trl        = trl;
    cfg.datafile   = infile;
    cfg.headerfile = infile;
   % channel selection, cutoff and padding
    cfg.artfctdef.zvalue.channel = 'all';
    cfg.artfctdef.zvalue.cutoff      = 30;
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
   [cfg, artifact_muscle] = ft_artifact_zvalue(cfg);
   
   % rejet artefacts
    cfg            = [];
    cfg.trl        = trl;
    cfg.datafile   = infile;
    cfg.headerfile = infile;
    cfg.artfctdef.reject          = 'complete';%'complete' (default = 'complete')
    %cfg.artfctdef.minaccepttim    =                      
    %cfg.artfctdef.crittoilim      = %when using complete rejection, reject  trial only when artifacts occur within this time window (default = whole trial)
    %cfg.artfctdef.eog.artifact    = artifact_eog;
    cfg.artfctdef.jump.artifact   = artifact_jump;
    cfg.artfctdef.muscle.artifact = artifact_muscle;
    cfg = ft_rejectartifact(cfg);
    
    
    
cfg.bpfilter = 'yes';
cfg.bpfreq=[0.5 45];
    
data = ft_preprocessing(cfg);

% Recup données elec - layout

load(['layout.mat']);
    fileID = fopen(['coordAmd256.xyz']);
    Channel = textscan(fileID,'%f %f32 %f32 %f32 %s');
    fclose(fileID);
    data.label=Channel{5};
    data.elec.label=data.label';
    data.elec.pnt = double([Channel{2}, Channel{3}, Channel{4}]);
cfg=[];

%% Art rej





 cfg = [];
    cfg.method   = 'channel';% 'channel' 'trial'
    cfg.layout   = lay;   % this allows for plotting individual trials
    cfg.channel  = 'all';    % do not show EOG channels
    data   = ft_rejectvisual(cfg, data);  

    cfg = [];
    cfg.method   = 'summary';% 'channel' 'trial'
    cfg.layout   = lay;   % this allows for plotting individual trials
    cfg.channel  = 'all';    % 
    data   = ft_rejectvisual(cfg, data);  
%% ERP
% Redefine trial par condition - Selectionne condition

cfg=[];
cfg.trials= find(data.trialinfo(:,1)==1);
data1= ft_redefinetrial(cfg,data)

cfg=[];
cfg.trials= find(data.trialinfo(:,1)==0);
data0= ft_redefinetrial(cfg,data)

cfg=[];
avg_0 = ft_timelockanalysis(cfg,data0);
cfg.baseline=[-0.2,0];
avg_0=ft_timelockbaseline(cfg,avg_0)
cfg=[];
avg_1 = ft_timelockanalysis(cfg,data1);
cfg.baseline=[-0.2,0];
avg_1=ft_timelockbaseline(cfg,avg_1)

cfg.showlabels = 'yes';
ft_multiplotER(cfg, avg_0,avg_1);