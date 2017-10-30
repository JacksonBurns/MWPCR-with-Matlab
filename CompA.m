% compute A
function[AA]=CompA(index,h,WW,Dis,Init,X)
    X=[ones(length(X),1),X];
    w=WW(Dis(:,index)<=h,index);
    res=Init(Dis(:,index)<=h,2);
    AA=(X'*X)*sum(w./cell2mat(res));
end