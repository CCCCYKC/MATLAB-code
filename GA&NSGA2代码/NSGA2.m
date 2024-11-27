clc
close all
clear

options=gaoptimset('PopulationSize',200,'Generations',5000,'stallGenLimit',200,'TolFun',1e-10,'plotFcn',@gaplotbestf);
fun=@fitnessfun;
nvars=4;
A=[13,13.5,14,15
   -13,-13.5,-14,-15
   1.5,2,1.8,1.1];
b=[15200,-12000,2000]';
Aeq=[];beq=[];
lb=[0,0,150,0];ub=[270,240,460,130];
[x_best,fval,exitflag]=gamultiobj(fun,nvars,A,b,Aeq,beq,lb,ub,options);

% function y=fitnessfun(x)
% y(1)=10*x(1)+20*x(2)+12*x(3)+14*x(4);
% y(2)=0.01*(1.5*x(1)+2*x(2)+1.8*x(3)+1.1*x(4));