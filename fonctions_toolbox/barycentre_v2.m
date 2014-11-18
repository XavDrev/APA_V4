function G = barycentre_v2(M,Poids) ;
%
% Calcul de la taille de M ;
% les noeuds doivent �tre �crit les uns sous les autres :
%
[N,Dim] = size(M) ;
%
% Cr�ation des poids
%
if nargin == 1 ;
   P = ones(size(M)) ; Poids = ones([N,1]) ;
else
   P = Poids*ones([1,Dim]) ;
end
%
% Calcul du Barycentre
%
G = nansum(P.*M,1)/sum(Poids) ;
%
% fin de la fonction