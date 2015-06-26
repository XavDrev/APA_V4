function Trial_Res_APA = calculs_parametres_initiationPas_v4(Trial_APA,Trial_TrialParams,Trial_Res_APA)
%% Calcul des param�tres d'initiation du pas � partir des donn�es d�j� extraites dans la structure 'primResultats'
% Entr�e : Acq = Structure contenant les champs:(Sujet.(acq_courante) par d�faut), T_trig = temps du trigger externe num�rique (si existe)
% .tMarkers = Structure (Sujet.(acq_courant).tMarkers par d�faut) contenant les marqueurs temporels en champs
% .primResultats = Structures contenant les r�sultats pr�liminaires () du pr�traitement sous forme [#occurence/frame valeur] (1x2)
%              .Vy_FO1 = vitesse AP du CG lors du FO1
%              .Vm = vitesse maximale AP du CG (qnd Acc == 0)
%              .VZmin_APA = vitesse minimale verticale du CG lors des APA
%              .V1 = vitesse minimale verticale du CG lors de l'�xecution du pas
%              .V2 = vitesse verticale du CG lors du FC1 (Foot-Contact du pied oscillant)
%              .VML_abs = valeur absolue de la vitesse moyenne m�diolat�rale
%              .minAPAy_AP = d�placement post�rieur max lors des APA
%              .APAy_ML = valeur absolue du d�placement lat�ral max lors des APA
% .CP_AP = d�placement AP du CP
% .Trigger = temps du trigger externe correspondant � l'acquisition (si existe)
% Sorties : R = structure avec les champs correspondants aux param�tres des APAs suivants:
%                   Cote
%                   t_Reaction
%                   t_APA
%                   APAy
%                   APAy_lateral
%                   StepWidth
%                   t_execution
%                   t_1step
%                   t_DA
%                   t_step2
%                   t_cycle_marche
%                   Longueur_pas
%                   V_exec
%                   Vy_FO1
%                   t_VyFO1
%                   Vm
%                   VML_absolue
%                   Cadence
%                   Freq_InitiationPas
%                   VZmin_APA
%                   V1
%                   V2
%                   Diff_V
%                   Freinage
%                   t_chute
%                   t_freinage
%                   t_V1
%                   t_V2


% infos
Trial_Res_APA.TrialName = Trial_APA.CP_Position.TrialName;
Trial_Res_APA.TrialNum = Trial_APA.CP_Position.TrialNum;
Trial_Res_APA.Description = Trial_APA.CP_Position.Description;

try
    %% Extraction des fields d'int�r�t
    tMarkers = Trial_TrialParams.EventsTime;
    Fech = Trial_APA.CP_Position.Fech;
    t_0 = Trial_APA.CP_Position.Time(1);
    
    %% Identification du c�t�
%     [bbs,stats]=robustfit(Trial_APA.CP_Position.Time(round((tMarkers(2)-t_0)*Fech):round((tMarkers(4)-t_0)*Fech)),Trial_APA.CP_Position.Data(2,round((tMarkers(2)-t_0)*Fech):round((tMarkers(4)-t_0)*Fech)));
%     signe = bbs(2);
    signe =  Trial_APA.CP_Position.Data(2,round((tMarkers(4)-t_0)*Fech)) - Trial_APA.CP_Position.Data(2,round((tMarkers(2)-t_0)*Fech));
    if signe>0
        Trial_Res_APA.Cote = 'Left';
    elseif signe<0
        Trial_Res_APA.Cote = 'Right';
    elseg
        Trial_Res_APA.Cote = '';
    end
    
    %% Temps de r�action (entre l'instruction et le d�collement du talon)
    Trial_Res_APA.t_Reaction = tMarkers(2) - tMarkers(1);
    
    %% Dur�e des APA (pr�paration du mouvement)
    Trial_Res_APA.t_APA = tMarkers(4) - tMarkers(2);
    
    %% Largeur du pas
    % Trial_Res_APA.StepWidth = Trial_Res_APA.APAy_lateral*2;
    Trial_Res_APA.StepWidth = range(Trial_APA.CP_Position.Data(2,round(tMarkers(5)*Fech):round(tMarkers(6)*Fech)));
    
    %% Dur�e d'�xecution du pas (entre TO et FC1)
    Trial_Res_APA.t_execution = tMarkers(5) - tMarkers(4);
    
    %% Dur�e du 1er pas (entre T0 et FC1)
    Trial_Res_APA.t_1step = tMarkers(5) - tMarkers(2);
    
    %% Dur�e du double-appui
    Trial_Res_APA.t_DA = tMarkers(6) - tMarkers(5);
    
    %% Dur�e du 2�me pas (entre FO2 et FC2)
    Trial_Res_APA.t_step2 = tMarkers(7) - tMarkers(6);
    
    %% Dur�e du cycle de marche (entre TO et FC2)
    Trial_Res_APA.t_cycle_marche = tMarkers(7) - tMarkers(4);
    
    %% Longueur du pas
    Trial_Res_APA.Longueur_pas = range(Trial_APA.CP_Position.Data(1,round(tMarkers(5)*Fech):round(tMarkers(6)*Fech)));
    
    %% Vitesse d'�xectuion du pas
    Trial_Res_APA.V_exec = Trial_Res_APA.Longueur_pas/Trial_Res_APA.t_execution;
    
    %% Vitesse AP � la fin des APA (t = TO)
    Trial_Res_APA.Vy_FO1(1,2) = tMarkers(4)*Fech; %%
    Trial_Res_APA.Vy_FO1(1,1) = Trial_APA.CG_Speed.Data(1,round(tMarkers(4)*Fech));
    
    %% Temps du Toe-Off (tFO1 = TO)
    Trial_Res_APA.t_VyFO1 = tMarkers(4) - t_0;
    
    %% Temps pour atteindre Vm
    Trial_Res_APA.t_Vm =  Trial_Res_APA.Vm(2)/Fech - tMarkers(1);
    
    %% Vitesse M�diolat�ral du C6
    Trial_Res_APA.VML_absolue = abs(mean(Trial_APA.CG_Speed.Data(2,round(tMarkers(4)*Fech):end-5)));
    
    %% Fr�quence d'initiation du pas
    Trial_Res_APA.Freq_InitiationPas = (tMarkers(7) - tMarkers(4))^-1;
    
    %% Cadence (calculs empiriques)
    Trial_Res_APA.Cadence = 60*Trial_Res_APA.Freq_InitiationPas;
    
    %% Diff�rence des vitesses verticales
    Trial_Res_APA.Diff_V = Trial_Res_APA.V1(1) - Trial_Res_APA.V2(1);
    
    %% Force de freinage
    Trial_Res_APA.Freinage = abs(Trial_Res_APA.Diff_V*1e2/Trial_Res_APA.V1(1));
    
    %% Dur�e de la chute du CG
    Trial_Res_APA.t_chute = Trial_Res_APA.V1(2)/Fech - tMarkers(4);
    
    %% Dur�e du freinage
    Trial_Res_APA.t_freinage = tMarkers(5) - Trial_Res_APA.V1(2)/Fech;
    
    %% Temps pour atteindre V1
    Trial_Res_APA.t_V1 = Trial_Res_APA.V1(2)/Fech;
    
    %% Temps pour atteindre V2
    Trial_Res_APA.t_V2 = Trial_Res_APA.V2(2)/Fech;
end

% %% Correspondance Temps des �v�nements <-> image Vicon
%
% if isfield(Acq,'Trigger')
%     Res_APA.Im_trig = round(T_trig*Fech_vid);
% end
% Res_APA.Im_T0 = round(tMarkers.T0*Fech_vid);
% Res_APA.Im_HO = round(tMarkers.HO*Fech_vid);
% Res_APA.Im_TO = round(tMarkers.TO*Fech_vid);
% Res_APA.Im_FC1 = round(tMarkers.FC1*Fech_vid);
% Res_APA.Im_FO2 = round(tMarkers.FO2*Fech_vid);
% Res_APA.Im_FC2 = round(tMarkers.FC2*Fech_vid);




