function [nbtrials] = plot_ann_trials(trials,nsamples,fig)
figure(fig)

nbtrials = size(trials,1);
%beginnings of trials : 
stem(trials(:,1)/60000,ones(nbtrials,1))
hold on 
%ends of trials : 
stem(trials(:,2)/60000,ones(nbtrials,1),'r')
ylim([-0.5 1.5]);
xlabel('Time (minutes)','Fontsize',16)
legend({'Trial begin','Trial end'},'Fontsize',16)
xlim([0 nsamples/60000])
hold off