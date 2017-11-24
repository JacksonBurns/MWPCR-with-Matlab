% º∆À„œ‡À∆–‘æÿ’Û
function[sim]=Smatrix(Init)
    sim=zeros(size(Init,1),size(Init,1));
    NN=size(Init,1); 
    Beta=cell2mat(Init(:,1));
%     Beta=Init(:,1);
    parfor j=1:NN
        temp=zeros(NN,1);
        XM=Init{j,3};
        XX=Beta(j,:);
%         diff=repmat(Init{j,1},size(Init,1),1)-cell2mat(Init(:,1));
%         temp=cellfun(@(x) (XX-x)/XM*(XX-x)',Beta);
        for z=1:NN
            diff=XX-Beta(z,:);
            temp(z,1)=diff/XM*diff';
        end
        sim(:,j)=temp;
    end    
end