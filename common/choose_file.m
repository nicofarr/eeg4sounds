function [currentfile,subjid] = choose_file(datadir,mess)

if nargin < 2
    mess = 'Choissisez le fichier a analyser';
end

if strcmp(computer,'MACI64')
    [curfile,path2file] = uigetfile({[datadir '/*.mff']},mess);
    
    currentfile = [path2file,curfile];
    subjid = curfile(1:4);
    disp(['File : ' currentfile])
    disp(['Subject ID : ' subjid])
    
else
    
    [currentfile] = uigetdir(datadir,mess);
    
    subjid = currentfile(end-29:end-26);
    disp(['File : ' currentfile])
    disp(['Subject ID : ' subjid])
end