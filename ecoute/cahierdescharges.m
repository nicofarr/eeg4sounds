% Description des étapes du pipeline de preprocessing ECOUTE

%%% STRUCTURE DES DONNEES BRUTES 
%%% 6 Conditions 
%%% ....... parfois 5 
%%% Les conditions démarrent par un trigger et font deux minutes
%%% A faire : dropper les 5 premières de l'enregistrement 
%%% On prend au MAX 1 min 55 

%%% Dans certains cas (annotaiton sur cahier de labo), le trigger doit être
%%% décalé d'un certain nombre de secondes 
%% Dans ce cas, on retranche au MAX 1 min 55 ce qui a été raté 


%% 1 - Garder un set d'electrodes défini à l'avance (défini dans script_0_paramaters) 
%% -- input : données brutes
%% -- output : données brutes moins les électrodes rejetées (format mat) 

%% 2 - Rejection d'artefact visuellement identifiables sur des données filtrées 
%% -- input : données brutes (elec utiles )
%% -- output : annotations d'artefacts identifiés visuellement
%% cette étape est semi-automatique

%% 3 - Rejection d'artefacts automatique Jump + muscles 
%% -- Input : données brutes (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette étape est semi-automatique (identification du seuile 

%% 4 - Visualisation - premier contrôle qualité : 
%% - a - étape identique à 2 où l'on visualise les données horizontalement avec les sections identifiées précedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% - c - mode "electrode" idem 
%% output : annotations d'electrodes à rejeter et à interpoler plus tard

%% 5 - Transform ICA (Analyse en composantes indépendantes) 
%%% Dans cette étape, découper les données en segments contigus (5
%%% secondes)
%% -- Inputs : données brutes (elec utiles)  + annotations d'artefacts des étapes 2 et 3 + annotations d'electrodes à rejeter
%% -- Output : Composantes ICA

%% 6 - Inspect ICA : inspection visuelle pour identifier quelles composantes correspondent aux mouvements oculaires
%% -- input : Composantes ICA + données pre-cleanées ( = brutes utiles moins elec bruitées moins artefacts)
%% -- output : données "back-projetées"  (i.e. en enlevant la contribution des composantes artefacts mouvements oculaires) 

%% 7 - Visualisation - deuxième contrôle qualité : 
%% - a - étape identique à 2 où l'on visualise les données horizontalement avec les sections identifiées précedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier immédiatement les électrodes trop bruitées (à interpoler) 
%% output : annotations de segments / essais à rejeter sur les données clean 

%% 8 - Output données preprocéssées finale
%% input : output de 7 
%% output : données preproc finale 



