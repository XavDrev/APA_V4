function Torseur_R2 = changement_repere_Legnani(Torseur_R1,MH_R1_R0,MH_R2_R0,TypeTorseur)

%%
% Fonctionne avec le formalisme des matrices homog�nes
% TOUTES les matrices doivent avoir les m�mes DIMENSIONS

% Cette fonction peut �tre utilis�e pour changer de r�f�rentiel
% - Coordonn�es d'un point avec TypeTorseur='position'
% - Torseur cin�matique avec TypeTorseur = 'cinematique'
% - Torseur d'actions m�caniques avec TypeTorseur = 'dynamique'
% - Torseur cin�tique = 'cinetique'
% - Matrice de Pseudo_inertie avec TypeTorseur = 'pseudo-inertie'

% Variable(s) Entree(s)
% - Torseur_R1 : Matrice homog�ne du torseur dans R1
% - MH_R1_R0 : Matrice Homog�ne de position de R1 dans R0
% - MH_R2_R0 : Matrice Homog�ne de position de R2 dans R0
%
% Variable(s) Sortie(s)
% - Torseur_R2 : Torseur exprim� dans R2

%% Auteur(s)
%
% Auteurs : C. Sauret
% Date de cr�ation : 25-10-2011
% Cr�� dans le cadre de : Projet APSIC

%% Modif(s) :
%
% Auteurs : 
% Date :
% Notes :

%% Traitement

Torseur_R2=zeros(size(Torseur_R1));

switch TypeTorseur
    case 'vecteur'
        for k=1:size(Torseur_R1,3)
           MH_R1_R2 = inv(MH_R2_R0(:,:,k))*MH_R1_R0(:,:,k);
           Torseur_R2(:,1,k) = MH_R1_R2 * Torseur_R1(:,1,k);
        end
        
    case 'cinematique'
        for k=1:size(Torseur_R1,3)
            MH_R1_R2 = inv(MH_R2_R0(:,:,k))*MH_R1_R0(:,:,k);
            Torseur_R2(:,:,k) = MH_R1_R2 * Torseur_R1(:,:,k) * inv(MH_R1_R2);
        end
        
    case 'cinetique'
        for k=1:size(Torseur_R1,3)
            MH_R1_R2 = inv(MH_R2_R0(:,:,k))*MH_R1_R0(:,:,k);
            Torseur_R2(:,:,k) = MH_R1_R2 * Torseur_R1(:,:,k) * MH_R1_R2';
        end
        
    case 'dynamique'
        for k=1:size(Torseur_R1,3)
            MH_R1_R2 = inv(MH_R2_R0(:,:,k))*MH_R1_R0(:,:,k);
            Torseur_R2(:,:,k) = MH_R1_R2 * Torseur_R1(:,:,k) * MH_R1_R2';
        end
        
    case 'pseudo-inertie'
        for k=1:size(Torseur_R1,3)
            MH_R1_R2 = inv(MH_R2_R0(:,:,k))*MH_R1_R0(:,:,k);
            Torseur_R2(:,:,k) = MH_R1_R2 * Torseur_R1(:,:,k) * MH_R1_R2';
        end
        
    otherwise
        disp('TypeTorseur est inconnu')
end

