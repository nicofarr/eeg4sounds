%% 8 - Analyse statistique, calcul des grand average ERP 
%% input : ERP individuels de tous 

addpath ../common/
check_set_resultdir;

[filestoinspect,filepath] = uigetfile([resultdir '/oddball/erp_indiv/*_binaural.mat'],'MultiSelect','on');

if iscell(filestoinspect)
    nsuj=size(filestoinspect,2);
else
    nsuj=1;
end

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/oddball/grav'],'dir') 
    mkdir([resultdir '/oddball/grav'])  
end

for suj=1:nsuj
    if iscell(filestoinspect)
    curfile=filestoinspect{suj};
    else
    curfile=filestoinspect;
    end
    
    idsubj = curfile(1:4);

    filestereo = [idsubj, '_stereo.mat'];

% Load data
    
    erp_bin = load([filepath,curfile],'erp');
    erp_ste = load([filepath,filestereo],'erp');

    eval(['erp_bin_' idsubj '= erp_bin;'])
    eval(['erp_ste_' idsubj '= erp_ste;'])


end

cfg = [];


grav_bin_std = ft_timelockgrandaverage(cfg,erp_bin_CP12.erp.std,erp_bin_CS07.erp.std,erp_bin_DC37.erp.std,erp_bin_EB39.erp.std,erp_bin_GN06.erp.std,erp_bin_HF38.erp.std,erp_bin_LA17.erp.std,erp_bin_LV18.erp.std,erp_bin_MJ05.erp.std,erp_bin_ML15.erp.std,erp_bin_MM10.erp.std,erp_bin_MM36.erp.std,erp_bin_NC28.erp.std,erp_bin_NH32.erp.std,erp_bin_PC27.erp.std,erp_bin_PL31.erp.std,erp_bin_RV26.erp.std,erp_bin_TA19.erp.std,erp_bin_VP03.erp.std);
grav_bin_dev = ft_timelockgrandaverage(cfg,erp_bin_CP12.erp.dev,erp_bin_CS07.erp.dev,erp_bin_DC37.erp.dev,erp_bin_EB39.erp.dev,erp_bin_GN06.erp.dev,erp_bin_HF38.erp.dev,erp_bin_LA17.erp.dev,erp_bin_LV18.erp.dev,erp_bin_MJ05.erp.dev,erp_bin_ML15.erp.dev,erp_bin_MM10.erp.dev,erp_bin_MM36.erp.dev,erp_bin_NC28.erp.dev,erp_bin_NH32.erp.dev,erp_bin_PC27.erp.dev,erp_bin_PL31.erp.dev,erp_bin_RV26.erp.dev,erp_bin_TA19.erp.dev,erp_bin_VP03.erp.dev);

grav_ste_std = ft_timelockgrandaverage(cfg,erp_ste_CP12.erp.std,erp_ste_CS07.erp.std,erp_ste_DC37.erp.std,erp_ste_EB39.erp.std,erp_ste_GN06.erp.std,erp_ste_HF38.erp.std,erp_ste_LA17.erp.std,erp_ste_LV18.erp.std,erp_ste_MJ05.erp.std,erp_ste_ML15.erp.std,erp_ste_MM10.erp.std,erp_ste_MM36.erp.std,erp_ste_NC28.erp.std,erp_ste_NH32.erp.std,erp_ste_PC27.erp.std,erp_ste_PL31.erp.std,erp_ste_RV26.erp.std,erp_ste_TA19.erp.std,erp_ste_VP03.erp.std);
grav_ste_dev = ft_timelockgrandaverage(cfg,erp_ste_CP12.erp.dev,erp_ste_CS07.erp.dev,erp_ste_DC37.erp.dev,erp_ste_EB39.erp.dev,erp_ste_GN06.erp.dev,erp_ste_HF38.erp.dev,erp_ste_LA17.erp.dev,erp_ste_LV18.erp.dev,erp_ste_MJ05.erp.dev,erp_ste_ML15.erp.dev,erp_ste_MM10.erp.dev,erp_ste_MM36.erp.dev,erp_ste_NC28.erp.dev,erp_ste_NH32.erp.dev,erp_ste_PC27.erp.dev,erp_ste_PL31.erp.dev,erp_ste_RV26.erp.dev,erp_ste_TA19.erp.dev,erp_ste_VP03.erp.dev);


cfgplot = [];
cfgplot.layout =  '../common/layout_E.mat';

ft_multiplotER(cfgplot,grav_bin_std,grav_bin_dev,grav_ste_std,grav_ste_dev);


