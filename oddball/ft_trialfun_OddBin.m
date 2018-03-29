function [trl, event] = ft_trialfun_OddBin(cfg)

% read the header information and the events from the data
hdr   = ft_read_header(cfg.inputfile);
event = ft_read_event(cfg.inputfile);
% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);
% search for trigger sample
stimulus_sample = [event.sample]';

stimulus_sample =stimulus_sample(2:end);

if length(stimulus_sample)~=320
    disp('not 320 samples detected, removing everything that is not DIN1');
    disp(['There are ' num2str(length(stimulus_sample)) ' samples'])
    removed_el=0;
    for i=2:size(event,2)
        curval = event(i).value;
        if ~strcmp(curval,'DIN1')
            disp(['Removing event ' num2str(i-1) ' with label ' curval ' ...'])
            stimulus_sample(i-1-removed_el) = [];
            removed_el = removed_el+1;
        end
        
    end
    
end
    


% read xlsfile containing event info
filename=['triggerOddball.xlsx'];
[trigger, name] = xlsread(filename,'Feuil1');

[orders, namesubjs] = xlsread(filename,'Feuil2');

whichsubj=strcmp(namesubjs,cfg.namesuj);
whichcol = find(whichsubj(1,:));

disp(namesubjs(1,whichcol));

goodorder = orders(:,whichcol-1);

disp(goodorder)

orderstereo = trigger(:,goodorder(1)+1);
orderbin = trigger(:,goodorder(2)+1);

%%% constant shift 

onset= trigger(:,6); 


%%% Find the corresponding column
if cfg.condition==2

    cond=orderstereo;
else
    cond=orderbin;
end


% define the trials
trl(:,1) = (stimulus_sample-onset) + pretrig;  % start of segment
trl(:,2) = (stimulus_sample-onset) + posttrig; % end of segment
trl(:,3) = pretrig;                    % how many samples prestimulus

% add the other information
% these columns will be represented after ft_preprocessing in "data.trialinfo"
trl(:,4) = cond;

% % Read & Reject Error Trials (from xls file) 
% [badtrials,namesuj,raw]=xlsread([cfg.paramfold 'badtrials_' cfg.tache '.xlsx']);
% badtrials=badtrials(find(strcmp(cfg.suj,namesuj)==1),:)';
% badtrials(isnan(badtrials))=[];
% trl(badtrials,:)=[];    