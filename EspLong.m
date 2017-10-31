% ³¤ÆÚÔëÉù
function[noise_long]=EspLong(postion,avg,std,noise)
    postion=postion';
    zeta1=normrnd(avg,std,[length(noise),1]);
    zeta2=normrnd(avg,std,[length(noise),1]);
    zeta3=normrnd(avg,std,[length(noise),1]);
    noise_long=2*sin(pi*postion(:,1)).*zeta1+2*cos(pi*postion(:,2)).*zeta2+2*sin(pi*postion(:,3)./0.5).*zeta3+noise;
end