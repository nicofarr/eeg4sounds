if ~exist('datadirset','var')
    datadir = uigetdir('.','Choissisez le dossier des données');
    datadirset=1;
end

disp([' Dossier data : ' datadir])
disp('Faire "clear" pour réinitiliaser')