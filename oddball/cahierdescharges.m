% Description des étapes du pipeline de preprocessing oddball

%% 1 - Garder un set d'electrodes défini à l'avance et découpage en essais ERP
%% -- input : données brutes 
%% -- output : données découpées moins les électrodes rejetées (format mat) 

%% 2 - Rejection d'artefacts semi-automatique Jump + muscles 
%% -- Input : données découpées (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette étape est semi-automatique (identification du seuile 

%% 3 - Visualisation - premier contrôle qualité : 
%% - a - étape identique à 2 où l'on visualise les données horizontalement avec les sections identifiées précedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% - c - mode "electrode" idem 
%% output : annotations d'electrodes à rejeter et à interpoler plus tard

%% 4 - Transform ICA (Analyse en composantes indépendantes) 
%% -- Inputs : données brutes (elec utiles)  + annotations d'artefacts des étapes 2 et 3 + annotations d'electrodes à rejeter
%% -- Output : Composantes ICA

%% 5 - Inspect ICA : inspection visuelle pour identifier quelles composantes correspondent aux mouvements oculaires
%% -- input : Composantes ICA + données pre-cleanées ( = brutes utiles moins elec bruitées moins artefacts)
%% -- output : données "back-projetées"  (i.e. en enlevant la contribution des composantes artefacts mouvements oculaires) 

%% 6 - Visualisation - deuxième contrôle qualité : 
%% - a - étape identique à 2 où l'on visualise les données horizontalement avec les sections identifiées précedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% output : annotations de segments / essais à rejeter sur les données clean 

%% 7 - Output données preprocéssées finale
%% input : output de 7 
%% output : données preproc finale 

%% 8 - Calcul des ERP individuels 
%% input : données preproc finale 
%% output : ERP individuel 

%% 9 - Visu ERP individuels 

%% 10 - Calcul des grand average ERP 
%% input : ERP individuels de tous 


