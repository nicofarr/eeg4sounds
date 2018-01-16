%% 0 - D�finition des triggers et ordres des conditions 
%% - input : donn�es brutes + le petit cahier d'Olivier (h�las pas en num�rique) 
%% - output : annotation des triggers et ordre des conditions 


addpath ../common/

check_set_datadir;

check_set_resultdir;

[file_ecoute,subjid] = choose_file(datadir);
disp('Press enter if subj ID is good otherwise ctlr-C')
pause


resultfile = [resultdir '/ecoute/annot/' subjid '.mat'];

if exist(resultfile,'file')
    disp(['WARNING : Subject ' subjid ' has already been processed.']) 
    
    decision = input('Process anyway? ( n to abort) ','s');
    if decision == 'n'
        error('ABORTED')
    end
end
        
    
close all

%%% Reading the header to fetch the total number of samples
header_struct = ft_read_header(file_ecoute);
nsamples = header_struct.nSamples;

%%% Identification des essais
cfg=[];
cfg.dataset=file_ecoute;
cfg.dataformat = 'egi_mff_v2';
cfg.trialdef.eventtype = 'comm';
%%% the "comm" trials seem to correspo to the ones that were added manually
%%% during the experiment

%%% Here we always extract 2 minutes minus 5 seconds, and we will redefine
%%% trials afterwards by (1) adding an offset of 5 seconds and (2)
%%% potentially shifting individual trials if they were started at tbe
%%% wrong moment
cfg.trialdef.prestim = 0;
cfg.trialdef.poststim = 120;

cfg.headerformat = 'egi_mff_v2';
cfg.eventformat = 'egi_mff_v2';
%cfg.outputfile = 'testimport.mat';

cfg = ft_definetrial(cfg);

%%%% Noter ici le nombre detrials
clear trials
trials = cfg.trl;

trials(:,1)=trials(:,1) + 5000;


fig = figure;

nbtrials = plot_ann_trials(trials,nsamples,fig);


%%%% Section to DELETED new trials

addtrial = input('Do you want to delete a trial?','s');
while addtrial == 'y'
    disp('Current trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    disp('Current trial offsets (in samples) are : ')
    disp(trials(:,2))
    
    
    trialtosupp = input('Which trial do you want to suppress ? ');
    
    trials(trialtosupp,:)=[];
    
    
    disp('Updated trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    disp('Updated trial offsets (in samples) are : ')
    disp(trials(:,2))
    
    
    nbtrials = plot_ann_trials(trials,nsamples,fig);
    
    addtrial = input('Do you want to delete another trial?','s');
    
end

%%%% Section to ADD new trials
addtrial = input('Do you want to add a trial?','s');
while addtrial == 'y'
    disp('Current trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    disp('Current trial offsets (in samples) are : ')
    disp(trials(:,2))
    
    
    newonset = input('Enter onset of new trial (sample number) : ');
    newduration = input('Enter duration of new trial (put 115000 for default)');
    
    
    testdur = newonset+5000+newduration-1;
    if testdur < nsamples
        trials(end+1,:) = [newonset+5000 newonset+5000+newduration-1 0];
    else
        disp(['OUT OF BORDER - max sample is ' num2str(nsamples)])
    end
    
    
    disp('Updated trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    disp('Updated trial offsets (in samples) are : ')
    disp(trials(:,2))
    
    
    nbtrials = plot_ann_trials(trials,nsamples,fig);
    
    addtrial = input('Do you want to add another trial?','s');
    
end


%%%% Section to MOVE current trials


movetrial = input('Do you want to delay a trial?','s');

while movetrial == 'y'
    disp('Current trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    onset2move = input(['Which trial do you want to move ? : ', num2str((1:nbtrials))]);
    
    samples2add = input('How many samples do you want to add ? ');
    newduration = input('Enter duration of new trial (put 115000 for default)');
    
    trials(onset2move,:) = [trials(onset2move,1)+samples2add,...
        trials(onset2move,1)+samples2add+newduration, 0];
    
    
    disp('Updated trial onsets (in samples) are : ')
    disp(trials(:,1))
    
    nbtrials = plot_ann_trials(trials,nsamples,fig);
    
    movetrial = input('Do you want to move another trial?','s');
    
end


close(fig)

disp('UPDATING FIELDTRIP STRUCTURE WITH NEW TRIAL DEFINITIONS')

cfg.trl=trials;


load trialnamesref

%%%% Section to NAME all trials

trialnameval = 0;
clear trialnames

while trialnameval == 0
    
    disp([num2str(nbtrials) ' trials for this subject'])
    
    disp('TRIAL NAMING')
    disp('Possible names are : ')
    disp(trialnamesref)
    for i=1:nbtrials
        strinput=input(['Name Trial ', num2str(i) ':'],'s');
        
        testval = strcmp(trialnamesref,strinput);
        
        while sum(testval) == 0
            disp('Name not allowed')
            disp('Possible names are : ')
            disp(trialnamesref)
            strinput=input(['Name Trial ', num2str(i) ':'],'s');
            testval = strcmp(trialnamesref,strinput);
        end
        
        trialnames{i} = strinput;
        
    end
    
    disp('TRIAL NAMES : ' )
    disp(trialnames)
    
    trialnameval = 1;
    %
    %     for i=1:nbtrials
    %
    %         test = strcmp(trialnamesref{i},trialnames);
    %         if sum(test) < 1
    %             disp('PROBLEM IN TRIAL NAMES')
    %             disp(['Name ' trialnames{i} ' for trial ' num2str(i) ' is not allowed'])
    %             trialnameval = 0;
    %             disp('NAMING WILL RESTART NOW')
    %             pause(2)
    %             break
    %         elseif sum(test) > 1
    %
    %             disp('PROBLEM IN TRIAL NAMES')
    %             disp(['Name ' trialnames{i} ' is used more than once'])
    %             disp(trialnames)
    %             trialnameval = 0;
    %             disp('NAMING WILL RESTART NOW')
    %             pause(2)
    %             clc
    %             break
    %         end
    %     end
    
end
disp('FINISHED TRIAL NAMING')

disp('SAVING...')

if ~exist([resultdir '/ecoute/annot'],'dir')
    
    mkdir([resultdir '/ecoute/annot'])
    
end

save(resultfile,'cfg','trialnames')


disp('SUCESSFUL ! ')

