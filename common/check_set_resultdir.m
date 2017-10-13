if ~exist('resultdirset','var')
    resultdir = uigetdir('.','Choissisez le dossier des résultats');
    resultdirset=1;
    
    
    %%% Individual tests to check if the directory structure was set or not
    %%% 
    
    if ~exist([resultdir '/ecoute'],'dir')
        mkdir([resultdir '/ecoute'])
    end
    
    if ~exist([resultdir '/oddball'],'dir')
        mkdir([resultdir '/oddball'])
    end
    
    if ~exist([resultdir '/loc'],'dir')
        mkdir([resultdir '/loc'])
    end
    
    
    
end

disp(['Results Directory : ' resultdir])