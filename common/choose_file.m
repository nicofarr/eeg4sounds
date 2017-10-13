function [currentfile,subjid] = choose_file(datadir)
[curfile,path2file] = uigetfile({[datadir '/*.mff']},'Choisissez le fichier à analyser');

currentfile = [path2file,curfile];
subjid = curfile(1:4);
disp(['File : ' currentfile])