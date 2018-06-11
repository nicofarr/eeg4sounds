%% 6 - Check artefact final - puis calcul des ERP individuels par condition 
%% - a - mode "summary" qui permet d'identifier immédiatement les essais trop bruitées 
%% - b - Calcul des ERP individuels en séparant standards et deviants
%% input : output de 5
%% output : ERP individuel par condition

addpath ../common/
check_set_resultdir;
[filebinaural,filepath] = uigetfile([resultdir '/oddball/erp_indiv/*_binaural.mat']);

%%% Create result folder for storing final all artefacts
if ~exist([resultdir '/oddball/erp_compar'],'dir')
    
    mkdir([resultdir '/oddball/erp_compar'])
   
end

idsubj = filebinaural(1:4);

filestereo = [idsubj, '_stereo.mat'];



erp_bin = load([filepath,filebinaural],'erp');
erp_ste = load([filepath,filestereo],'erp');

cfgplot = [];
cfgplot.layout =  '../common/layout_E.mat';

ft_multiplotER(cfgplot,erp_bin.erp.std,erp_bin.erp.dev,erp_ste.erp.std,erp_ste.erp.dev)

cfgplot = [];
eleclist = {'E5','E6','E7','E14','E15','E16','E22','E23','E24','E29','E30','E36','E42','E206','E207','E215','E224'};
cfgplot.channel = eleclist;
f=figure;
ft_singleplotER(cfgplot,erp_bin.erp.std,erp_bin.erp.dev,erp_ste.erp.std,erp_ste.erp.dev)
title(idsubj)

resultfile_erpindiv = [resultdir, '/oddball/erp_compar/', idsubj,'_roiFbil.png'];
saveas(f,resultfile_erpindiv)

cfgplot = [];
eleclist = {'E85','E86','E87','E96','E97','E98','E106','E107','E108','E114','E115','E116','E150','E151','E152','E153','E159','E160','E161','E162','E168','E169','E170','E171'};
cfgplot.channel = eleclist;
f=figure;
ft_singleplotER(cfgplot,erp_bin.erp.std,erp_bin.erp.dev,erp_ste.erp.std,erp_ste.erp.dev)
title(idsubj)

resultfile_erpindiv = [resultdir, '/oddball/erp_compar/', idsubj,'_roiOccbil.png'];
saveas(f,resultfile_erpindiv)

cfgplot = [];
eleclist = {'E69','E70','E74','E75','E83','E84','E94','E95','E178','E179','E180','E190','E191','E192','E193','E202'};
cfgplot.channel = eleclist;
f=figure;
ft_singleplotER(cfgplot,erp_bin.erp.std,erp_bin.erp.dev,erp_ste.erp.std,erp_ste.erp.dev)
title(idsubj)

resultfile_erpindiv = [resultdir, '/oddball/erp_compar/', idsubj,'_roiAudbil.png'];
saveas(f,resultfile_erpindiv)
