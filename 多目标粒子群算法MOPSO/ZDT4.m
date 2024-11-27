function [f1,f2]=ZDT4(pop)
% 0<x<1
f1=pop(1);
n=length(pop);
g=1+10*(n-1)+sum(pop(2:end).^2-10*cos(4*pi*pop(2:end)));
f2=g*(1-sqrt(f1/g));
end