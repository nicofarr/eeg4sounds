function [currentfile,subjid] = choose_file(datadir)

if strcmp(computer,'MACI64')
    [curfile,path2file] = uigetfile({[datadir '/*.mff']},'Choisissez le fichier à analyser');
    
    currentfile = [path2file,curfile];
    subjid = curfile(1:4);
    disp(['File : ' currentfile])
    disp(['Subject ID : ' subjid])
    
else
    
    [currentfile] = uigetdir(datadir,'Choisissez le fichier à analyser');
    
    subjid = currentfile(end-29:end-26);
    disp(['File : ' currentfile])
    disp(['Subject ID : ' subjid])
end