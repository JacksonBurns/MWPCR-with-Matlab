% computer We
function[temp]=WE(index,warm,Dis,hmax)
    temp=zeros(size(warm,1),1);
    war=warm(:,index);
    dis=Dis(:,index);
    temp(dis<=hmax,1)=war( dis<=hmax,1)/sum(war( dis<=hmax,1));
end