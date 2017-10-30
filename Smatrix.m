% º∆À„œ‡À∆–‘æÿ’Û
function[sim]=Smatrix(Init)
    sim=zeros(size(Init,1),size(Init,1));  
    for j=1:size(Init,1)
        XM=Init{j,3};
%         diff=repmat(Init{j,1},size(Init,1),1)-cell2mat(Init(:,1));        
        for z=1:size(Init,1)
            diff=Init{j,1}-Init{z,1};
            sim(z,j)=diff/XM*diff';
        end
    end    
end