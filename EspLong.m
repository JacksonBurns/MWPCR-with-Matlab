% ³¤ÆÚÔëÉù
function[noise_long]=EspLong(g,avg,std,noise)
    zeta1=normrnd(avg,std,[length(noise),1]);
    zeta2=normrnd(avg,std,[length(noise),1]);
    zeta3=normrnd(avg,std,[length(noise),1]);
    noise_long=2*sin(pi*g(1))*zeta1+2*cos(pi*g(2))*zeta2+2*sin(pi*g(3)/0.5)*zeta3+noise;
end