% 生成多尺度的权重矩阵Q....Q1 Q2 Q3
function[Q]=createQ(We,Wi,Dis,criter)
    Q=zeros(size(We,1),size(We,2),size(criter,2));
    for index=1:size(criter,2)
        We0=We;
        We0(We<criter(2,index)|Dis>criter(3,index))=0;
        Q(:,:,index)=We0*diag(Wi>criter(1,index));
    end
end
    