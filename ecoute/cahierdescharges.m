% Description des �tapes du pipeline de preprocessing ECOUTE

%%% STRUCTURE DES DONNEES BRUTES 
%%% 6 Conditions 
%%% ....... parfois 5 
%%% Les conditions d�marrent par un trigger et font deux minutes
%%% A faire : dropper les 5 premi�res secondes de l'enregistrement 
%%% On prend au MAX 1 min 55 

%%% Dans certains cas (annotaiton sur cahier de labo), le trigger doit �tre
%%% d�cal� d'un certain nombre de secondes 
%% Dans ce cas, on retranche au MAX 1 min 55 ce qui a �t� rat� 


%% 0 - D�finition des triggers et ordres des conditions 
%% - input : donn�es brutes + le petit cahier d'Olivier (h�las pas en num�rique) 
%% - output : annotation des triggers et ordre des conditions 

%% 1 - Garder un set d'electrodes d�fini � l'avance (d�fini dans script_0_paramaters) 
%% -- input : donn�es brutes
%% -- output : donn�es brutes moins les �lectrodes rejet�es (format mat) 

%% 2 - Rejection d'artefact visuellement identifiables sur des donn�es filtr�es 
%% -- input : donn�es brutes (elec utiles )
%% -- output : annotations d'artefacts identifi�s visuellement
%% cette �tape est semi-automatique

%% 3 - Rejection d'artefacts automatique Jump + muscles 
%% -- Input : donn�es brutes (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette �tape est semi-automatique (identification du seuil) 

%% 4 - Visualisation - premier contr�le qualit� : 
%% - a - �tape identique � 2 o� l'on visualise les donn�es horizontalement avec les sections identifi�es pr�cedemment comme artefacts

%%% A CE STADE DECIDER DU DECOUPAGE


%% - b - COUPER EN TRANCHES PUIS mode "summary" qui permet d'identifier imm�diatement les �lectrodes trop bruit�es (� interpoler) 
%% - c - COUPER EN TRANCHES PUIS mode "electrode" idem 
%% output : annotations d'electrodes � rejeter et � interpoler plus tard

%% 5 - Transform ICA (Analyse en composantes ind�pendantes) 
%%% Dans cette �tape, d�couper les donn�es en segments contigus (5
%%% secondes)
%% -- Inputs : donn�es brutes (elec utiles)  + annotations d'artefacts des �tapes 2 et 3 + annotations d'electrodes � rejeter
%% -- Output : Composantes ICA

%% 6 - Inspect ICA : inspection visuelle pour identifier quelles composantes correspondent aux mouvements oculaires
%% -- input : Composantes ICA + donn�es pre-clean�es ( = brutes utiles moins elec bruit�es moins artefacts)
%% -- oustput : donn�es "back-projet�es"  (i.e. en enlevant la contribution des composantes artefacts mouvements oculaires) 

% 6b - Interpolation 
% -- Calcule les données interpolées AVANT et APRES ICA



%% 7 - Visualisation - deuxi�me contr�le qualit� : 
%% - a - �tape identique � 2 o� l'on visualise les donn�es horizontalement avec les sections identifi�es pr�cedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier imm�diatement les �lectrodes trop bruit�es (� interpoler) 
%% output : annotations de segments / essais � rejeter sur les donn�es clean 

%% 8 - Output donn�es preproc�ss�es finale
%% input : output de 7 
%% output : donn�es preproc finale 



