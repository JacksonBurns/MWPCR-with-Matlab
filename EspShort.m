% ¶ÌÆÚÔëÉù
function[noise_short]=EspShort(index,Dis,h,noise)
    loc = noise(Dis(:,index)<=h,:);
    noise_short = sum(loc)/length(loc);
end
