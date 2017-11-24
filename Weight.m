% º∆À„»®÷ÿæÿ’Û
function[sim]=Weight(Init,W_loc,Cn)
    sim=zeros(size(Init,1),size(Init,1));
    NN=size(Init,1); 
    Beta=cell2mat(Init(:,1));
%     Beta=Init(:,1);
    parfor j=1:NN
        temp=zeros(NN,1);
        XM=inv(Init{j,3});
        XX=Beta(j,:);
%         diff=repmat(Init{j,1},size(Init,1),1)-cell2mat(Init(:,1));
%         temp=cellfun(@(x) (XX-x)/XM*(XX-x)',Beta);
        for z = find(W_loc(:,j)~=0)'
            diff=XX-Beta(z,:);
            temp(z,1)=exp(-diff*XM*diff'/Cn);
        end
        sim(:,j)=temp.*W_loc(:,j);
    end    
end