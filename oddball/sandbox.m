
cfglay = [];
cfglay.layout = '../common/layout_E.mat';
lay = ft_prepare_layout(cfglay);

ft_plot_lay(lay);


cfgerp = [];
cfgerp.demean = 'yes';
avg = ft_timelockanalysis(cfgerp,data);

cfgplot = [];
cfgplot.layout =  '../common/layout_E.mat';
ft_multiplotER(cfgplot,avg)