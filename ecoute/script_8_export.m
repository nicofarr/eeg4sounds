%% 
addpath ../common/
check_set_resultdir;
[filetoinspect,filepath] = uigetfile([resultdir '/ecoute/preproc_final/*.mat']);

%%% Create result folder for storing final data
if ~exist([resultdir '/ecoute/data_final'],'dir')   
    mkdir([resultdir '/ecoute/data_final'])   
end



dataredef = load([filepath,filetoinspect],'data');

%%% Concatenate the 5 second segments 
concatetrl = concatenate_trl(dataredef.data.sampleinfo);
cfg = [];
cfg.trl = concatetrl;
dataredef = ft_redefinetrial(cfg,dataredef.data);

% Load annotations

load([resultdir '/ecoute/annot/',filetoinspect])
annot_trl = cfg.trl;

%%% Loop on conditions
for i = 1:length(trialnames)
    disp(trialnames(i))
    curtrl = annot_trl(i,:);
    
    
    %% loop on data trials
    keep = [];
    for j = 1:size(dataredef.trial,2)
        onset = dataredef.sampleinfo(j,1);
        if (onset >= curtrl(1)) && ( onset <= curtrl(2))
            keep = [keep,j];
        end
    end
    disp(keep)
    cfg = [];
    cfg.trials = keep;
    resultfile_data_final = [resultdir '/ecoute/data_final/'  cell2mat(trialnames(i)) '_' filetoinspect];
    cfg.outputfile = resultfile_data_final;
    
    ft_redefinetrial(cfg,dataredef);
    
    
end
