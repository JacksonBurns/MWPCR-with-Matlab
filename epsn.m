% º∆À„º”»®≤–≤Ó
function[esp]=epsn(index,WW,Dis,h,Init,data,X)
    X=[ones(length(X),1),X];
    Beta=cell2mat(Init(Dis(:,index)<=h,1))';
    Y=data(:,Dis(:,index)<=h);
    w=WW(Dis(:,index)<=h,index);
    res=cell2mat(Init(Dis(:,index)<=h,2));
    esp=(w./res)'*(Y-X*Beta)';  %1by100  
end