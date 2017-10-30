% 初始化beta的值，局部线性回归
function[result]=OLS_loc(index,data,Dis,h,X)
   loc=data(:,Dis(:,index)<=h);
   X=repmat(X,size(loc,2),1);
   X=[ones(length(X),1),X];
   Y=reshape(loc,size(loc,1)*size(loc,2),1);
   [beta,~,r] = regress(Y,X);
   res=sum(power(r,2))/(size(loc,1)*size(loc,2)-2);
   cov=(X'*X)/res;
   result={beta' res cov};
end
