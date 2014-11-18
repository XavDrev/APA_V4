function C=cherche_string_dans_C3D(itf,champs1,champs2)

C={};
eval(['nIndex = itf.GetParameterIndex' '(''' champs1 '''' ',' '''' champs2 '''' ');'])
nItems = itf.GetParameterLength(nIndex);
if nIndex~=-1
    for i=1:nItems
        C{i} = itf.GetParameterValue(nIndex,i-1);
    end
end