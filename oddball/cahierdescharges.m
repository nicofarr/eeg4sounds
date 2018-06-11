% Description des �tapes du pipeline de preprocessing oddball

%% 1 - Garder un set d'electrodes d�fini � l'avance et d�coupage en essais ERP
%% -- input : donn�es brutes 
%% -- output : donn�es d�coup�es moins les �lectrodes rejet�es (format mat) 

%% 2 - Rejection d'artefacts semi-automatique Jump + muscles 
%% -- Input : donn�es d�coup�es (elec utiles)  + Seuil (A DEFINIR POUR LE GROUPE)
%% --output : annotations d'artefacts jump et muscles 
%% cette �tape est semi-automatique (identification du seuile 

%% 3 - Visualisation - premier contr�le qualit� : 
%% - a - �tape identique � 2 o� l'on visualise les donn�es horizontalement avec les sections identifi�es pr�cedemment comme artefacts
%% - b - mode "summary" qui permet d'identifier imm�diatement les �lectrodes trop bruit�es (� interpoler) 
%% - c - mode "electrode" idem 
%% output : annotations d'electrodes � rejeter et � interpoler plus tard

%% 4 - Transform ICA (Analyse en composantes ind�pendantes) 
%% -- Inputs : donn�es brutes (elec utiles)  + annotations d'artefacts des �tapes 2 et 3 + annotations d'electrodes � rejeter
%% -- Output : Composantes ICA

%% 5 - Inspect ICA : inspection visuelle pour identifier quelles composantes correspondent aux mouvements oculaires
%% -- input : Composantes ICA + donn�es pre-clean�es ( = brutes utiles moins elec bruit�es moins artefacts)
%% -- output : donn�es "back-projet�es"  (i.e. en enlevant la contribution des composantes artefacts mouvements oculaires) 

%% 6 - Check artefact final - puis calcul des ERP individuels par condition 
%% - a - mode "summary" qui permet d'identifier imm�diatement les essais trop bruit�es 
%% - b - Calcul des ERP individuels en s�parant standards et deviants
%% input : output de 5
%% output : ERP individuel par condition

%% 7 - Visu ERP individuels pour les deux conditions
%% input : prend deux fichiers pour chaque condition par sujet
%% output : image

%% 8 - Analyse statistique, calcul des grand average ERP 
%% input : ERP individuels de tous 


