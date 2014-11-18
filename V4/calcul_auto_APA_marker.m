function Trial_Res_APA = calcul_auto_APA_marker(Trial_APA,Trial_TrialParams,Trial_Res_APA)
% infos
Trial_Res_APA.TrialName = Trial_APA.CP_Position.TrialName;
Trial_Res_APA.TrialNum = Trial_APA.CP_Position.TrialNum;
Trial_Res_APA.Description = Trial_APA.CP_Position.Description;

try
    %% Extraction des fields d'intérêt
    tMarkers = Trial_TrialParams.EventsTime;
    Fech = Trial_APA.CP_Position.Fech;
    
    %% Valeur minimale du CP en antéropostérieur (APAy)
    [C,I] = min(Trial_APA.CP_Position.Data(1,round(tMarkers(2)*Fech):round(tMarkers(3)*Fech)));
    Trial_Res_APA.APAy(1:2) = [mean(Trial_APA.CP_Position.Data(1,round(tMarkers(1)*Fech):round(tMarkers(2)*Fech))) - C I(1)+round(tMarkers(2)*Fech)-1];
    
    %% Déplacement latéral max du CP lors des APA (APAy_lat)
    %% Valeur minimale du CP en antéropostérieur (APAy)
    [C,I] = max(sign(Trial_APA.CP_Position.Data(2,round(tMarkers(2)*Fech)) - Trial_APA.CP_Position.Data(2,round(tMarkers(4)*Fech)))*(Trial_APA.CP_Position.Data(2,round(tMarkers(2)*Fech):round(tMarkers(3)*Fech)) - Trial_APA.CP_Position.Data(2,round(tMarkers(2)*Fech))));
    Trial_Res_APA.APAy_lateral(1:2) = [abs(mean(Trial_APA.CP_Position.Data(2,round(tMarkers(1)*Fech):round(tMarkers(2)*Fech))) - Trial_APA.CP_Position.Data(2,I(1)+round(tMarkers(2)*Fech)-1))...
        I(1)+round(tMarkers(2)*Fech)];
    
    %% Vitesse maximale à la fin du 1er APA
    [Trial_Res_APA.Vm(1,1) ind] = max(Trial_APA.CG_Speed.Data(1,round(tMarkers(3)*Fech):round(tMarkers(6)*Fech)-10));
    Trial_Res_APA.Vm(1,2) = round(tMarkers(3)*Fech) + ind;
    
    %% Vitesse verticale minimale pendant les APA
    [Trial_Res_APA.VZmin_APA(1,1) Trial_Res_APA.VZmin_APA(1,2)] = min(Trial_APA.CG_Speed.Data(3,1:round(tMarkers(4)*Fech)));
    %% Vitesse minimale pendant l'éxecution du pas
    [Trial_Res_APA.V1(1) ind] = min(Trial_APA.CG_Speed.Data(3,round(tMarkers(3)*Fech):round(tMarkers(5)*Fech-10)));
    Trial_Res_APA.V1(2) = ind + round(tMarkers(3)*Fech);
    
    %% Vitesse verticale lors du foot-contact
    Trial_Res_APA.V2 = [Trial_APA.CG_Speed.Data(3,round(tMarkers(5)*Fech)) round(tMarkers(5)*Fech)];
end







