% Í£Ö¹×¼Ôò
function[D]=stopctiter(Init,Init3)
    D=ones(size(Init,1),1);
    diff=cell2mat(Init(:,1))-cell2mat(Init3(:,1));
    for index=1:size(Init3,1)
        D(index,:)=diff(index,:)/Init{index,3}*diff(index,:)';
    end
end