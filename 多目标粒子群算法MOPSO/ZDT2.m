function [f1,f2]=ZDT2(pop)
% 0<x<1
f1=pop(1);
n=length(pop);
g=1+9*sum(pop(2:end))/(n-1);
f2=g*(1-(f1/g)^2);
end