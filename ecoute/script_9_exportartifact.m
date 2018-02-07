%% 9 - Export artifacts for Mahmoud's magic
addpath ../common/
check_set_resultdir;
[filestoinspect,filepath] = uigetfile([resultdir '/ecoute/import/*.mat'],'MultiSelect','on');

%%% Create result folder for exporting artefacts
if ~exist([resultdir '/ecoute/export_artifacts'],'dir')
    mkdir([resultdir '/ecoute/export_artifacts'])
end

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
    resultfile_art = [resultdir, '/ecoute/export_artifacts/', filetoinspect];
    
    
    
    % Load artifacts
    resultfile_all_art = [resultdir '/ecoute/all_art/', filetoinspect];
    resultfile_elec = [resultdir, '/ecoute/art_elec/', filetoinspect];
    artfctdef_final = load(resultfile_all_art,'artfctdef');
    elec_list=load(resultfile_elec,'elec');
    
    trl_art = [artfctdef_final.artfctdef.jump.artifact ; artfctdef_final.artfctdef.muscle.artifact ;...
        artfctdef_final.artfctdef.visual.artifact];
    
    trl_art = [trl_art, zeros(size(trl_art,1),1)];

  
    cfg            = [];
    cfg.channel =elec_list.elec.good;
    cfg.trl = trl_art;
    cfg.inputfile = [filepath,filetoinspect];
    cfg.outputfile = resultfile_art;
    
    
    dat= ft_redefinetrial(cfg);
    
    
end