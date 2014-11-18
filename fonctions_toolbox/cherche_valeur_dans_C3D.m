function C=cherche_valeur_dans_C3D(itf,champs1,champs2)

C = NaN;
eval(['nIndex = itf.GetParameterIndex' '(''' champs1 '''' ',' '''' champs2 '''' ');'])
if nIndex ~= -1
    nItems = itf.GetParameterLength(nIndex);
    for i=1:nItems
        C(i) = itf.GetParameterValue(nIndex,i-1);
    end
end