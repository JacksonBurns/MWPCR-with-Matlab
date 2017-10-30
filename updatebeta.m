% updata beta
function[beta]=updatebeta(index,h,WW,Dis,data,X,Init,A)
    X=[ones(length(X),1),X];
    w=WW(Dis(:,index)<=h,index);
    res=cell2mat(Init(Dis(:,index)<=h,2));
    Y=data(:,Dis(:,index)<=h)*(w./res);
    beta=(A{index,:}\X'*Y)';     
end